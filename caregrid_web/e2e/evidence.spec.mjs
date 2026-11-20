import { test, expect } from "@playwright/test";
import { createHash } from "node:crypto";
import { mkdir } from "node:fs/promises";

test("private attachments stay optional, scoped to a case and separate from response proof", async ({
  browser,
  page,
}) => {
  const member = await browser.newContext();
  let incidentId, releaseRead;
  const gate = new Promise((resolve) => {
    releaseRead = resolve;
  });
  try {
    const headers = { "x-caregrid-request": "1" };
    expect(
      (
        await member.request.post("http://127.0.0.1:4173/api/session", {
          headers,
          data: { handle: "student.aanya", pin: "5501" },
        })
      ).ok(),
    ).toBe(true);
    const raised = await member.request.post(
      "http://127.0.0.1:4173/api/rpc/sos/raise",
      {
        headers,
        data: {
          zoneCode: "HB",
          locationDetail: "Block C, ground-floor common room",
          note: "A friend needs the campus response team.",
          forSelf: false,
        },
      },
    );
    const incident = (await raised.json()).data;
    incidentId = incident.incidentId;
    for (const method of ["list", "upload", "read", "remove"]) {
      const response = await member.request.post(
        `http://127.0.0.1:4173/api/rpc/evidence/${method}`,
        {
          headers,
          data: {
            incidentId,
            pageToken: null,
            mediaType: "image/png",
            base64Data: "YWJj",
            key: "a".repeat(64),
            generation: "1",
          },
        },
      );
      expect(response.status()).toBe(403);
    }
    await page.goto("/console");
    await page.getByLabel("Demo account").selectOption("cmd.night");
    await page.getByLabel("Demo PIN").fill("1111");
    await page
      .getByRole("button", { name: "Enter workspace", exact: true })
      .click();
    await page
      .locator('[data-action="select-incident"]')
      .filter({ hasText: incident.code })
      .click();
    const panel = page.getByRole("region", { name: "Private attachments" });
    await panel
      .getByRole("button", { name: "Load attachments", exact: true })
      .click();
    await expect(panel).toContainText("Google evidence storage is not enabled");
    // Actual RPC body > Serverpod's old 512 KiB default must reach validation.
    const tooLargeImage = await page.request.post("/api/rpc/evidence/upload", {
      headers,
      data: {
        incidentId,
        mediaType: "image/png",
        base64Data: "a".repeat(700000),
      },
    });
    expect(tooLargeImage.status()).toBe(400);

    // Only storage calls below are UI fixtures. Identity, incident, claim and
    // cleanup still use the real local backend. No live Google storage claim.
    const base64Data = await page.evaluate(() => {
      const canvas = document.createElement("canvas");
      canvas.width = 640;
      canvas.height = 360;
      const ctx = canvas.getContext("2d");
      ctx.fillStyle = "#10151f";
      ctx.fillRect(0, 0, 640, 360);
      ctx.strokeStyle = "#26d5ff";
      ctx.lineWidth = 3;
      ctx.strokeRect(50, 75, 540, 200);
      for (let i = 1; i < 5; i++) {
        ctx.beginPath();
        ctx.moveTo(50 + i * 108, 75);
        ctx.lineTo(50 + i * 108, 275);
        ctx.stroke();
      }
      ctx.fillStyle = "#c6ff3d";
      ctx.fillRect(266, 75, 108, 200);
      ctx.fillStyle = "#ece9e1";
      ctx.font = "bold 24px sans-serif";
      ctx.fillText("SYNTHETIC IMAGE ATTACHMENT", 50, 45);
      ctx.font = "18px sans-serif";
      ctx.fillText("Demo floor plan · no live camera feed", 50, 320);
      return canvas.toDataURL("image/png").split(",")[1];
    });
    const bytes = Buffer.from(base64Data, "base64");
    const file = {
      key: "a".repeat(64),
      mediaType: "image/png",
      byteLength: bytes.length,
      sha256: createHash("sha256").update(bytes).digest("hex"),
      generation: "1234567890123456789",
      metageneration: "1",
      createdAt: "2026-11-20T06:00:00Z",
    };
    let attached = false,
      hold = true;
    await page.route("**/api/rpc/evidence/*", async (route) => {
      const method = new URL(route.request().url()).pathname.split("/").pop();
      const args = route.request().postDataJSON();
      expect(args.incidentId).toBe(incidentId);
      if (method === "upload") {
        expect(args.base64Data).toBe(base64Data);
        expect(args).not.toHaveProperty("filename");
        attached = true;
        return route.fulfill({ json: { data: file } });
      }
      if (method === "list")
        return route.fulfill({
          json: {
            data: {
              status: "ready",
              files: attached ? [file] : [],
              notice:
                "Private synthetic observation. Review alongside the case record.",
              nextPageToken: null,
            },
          },
        });
      expect(args.generation).toBe(file.generation);
      if (method === "read") {
        if (hold) await gate;
        return route.fulfill({ json: { data: { file, base64Data } } });
      }
      expect(method).toBe("remove");
      attached = false;
      return route.fulfill({ json: { data: null } });
    });
    await panel
      .getByRole("button", { name: "Refresh attachments", exact: true })
      .click();
    await panel.getByLabel("Attach image", { exact: true }).setInputFiles({
      name: "synthetic-floor-plan.png",
      mimeType: "image/png",
      buffer: bytes,
    });
    await expect(panel.getByText("PNG image", { exact: true })).toBeVisible();
    await panel
      .getByRole("button", { name: "View privately", exact: true })
      .click();
    const claim = page.getByRole("button", {
      name: "Take ownership",
      exact: true,
    });
    await expect(claim).toBeEnabled();
    await claim.click();
    const readDone = page.waitForResponse("**/api/rpc/evidence/read");
    hold = false;
    releaseRead();
    await (await readDone).finished();
    await expect(panel.locator("img")).toHaveCount(0);
    await panel
      .getByRole("button", { name: "Load attachments", exact: true })
      .click();
    await panel
      .getByRole("button", { name: "View privately", exact: true })
      .click();
    await expect(panel.locator("img")).toBeVisible();
    await expect(
      page.getByRole("button", {
        name: "Approve recommended dispatch",
        exact: true,
      }),
    ).toBeEnabled();
    if (process.env.CAREGRID_CAPTURE === "1") {
      await page.evaluate(() => document.fonts.ready);
      await mkdir("../assets/pitch/connected", { recursive: true });
      await panel.screenshot({
        path: "../assets/pitch/connected/10-private-attachments-preview.png",
        animations: "disabled",
      });
    }
    await panel.getByRole("button", { name: "Remove", exact: true }).click();
    await page
      .getByRole("button", { name: "Remove attachment", exact: true })
      .click();
    await expect(panel).toContainText("No attachments on this page");
    await expect(panel.locator("img")).toHaveCount(0);
    await page
      .locator('[data-action="select-incident"]')
      .filter({ hasNotText: incident.code })
      .first()
      .click();
    await expect(
      panel.getByRole("button", { name: "Load attachments", exact: true }),
    ).toBeVisible();
  } finally {
    releaseRead();
    if (incidentId)
      await page.request.post("/api/rpc/incident/dismiss", {
        headers: { "x-caregrid-request": "1" },
        data: {
          incidentId,
          reason:
            "Command confirmed no further help needed (synthetic rehearsal).",
        },
      });
    await member.close();
  }
});
