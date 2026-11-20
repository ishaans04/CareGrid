import { test, expect } from "@playwright/test";

test("a slow optional draft leaves response actions usable and is discarded after a source change", async ({
  browser,
  page,
}) => {
  const member = await browser.newContext();
  let incidentId;
  let release;
  const gate = new Promise((resolve) => {
    release = resolve;
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
          locationDetail: "Block A, first-floor common room",
          note: "A friend needs the campus response team.",
          forSelf: false,
        },
      },
    );
    expect(raised.ok()).toBe(true);
    const incident = (await raised.json()).data;
    incidentId = incident.incidentId;
    await page.goto("/console");
    await page.getByLabel("Demo account").selectOption("cmd.night");
    await page.getByLabel("Demo PIN").fill("1111");
    await page
      .getByRole("button", { name: "Enter workspace", exact: true })
      .click();
    await page
      .locator(".incident-row")
      .filter({ hasText: incident.code })
      .click();
    await page.route("**/api/rpc/briefing/generate", async (route) => {
      // UI race test only. No provider call or generated model claim.
      await gate;
      await route.fulfill({
        json: {
          data: {
            incidentCode: incident.code,
            sourceUpdatedAt: new Date().toISOString(),
            status: "generated",
            summary: "STALE FIXTURE MUST NOT APPEAR",
            evidenceRefs: ["recorded_state"],
            model: "gemini-test-fixture",
            promptVersion: "fixture",
            notice: "Fixture only",
          },
        },
      });
    });
    await page
      .getByRole("button", { name: "Draft handoff brief", exact: true })
      .click();
    await expect(
      page.getByRole("button", { name: "Drafting…", exact: true }),
    ).toBeDisabled();
    const dispatch = page.getByRole("button", {
      name: "Approve recommended dispatch",
      exact: true,
    });
    await expect(dispatch).toBeEnabled();
    await dispatch.click();
    await expect(
      page.getByRole("heading", {
        name: "Proof of response · per unit",
        exact: true,
      }),
    ).toBeVisible();
    const completed = page.waitForResponse("**/api/rpc/briefing/generate");
    release();
    await (await completed).finished();
    await page.evaluate(
      () =>
        new Promise((resolve) =>
          requestAnimationFrame(() => requestAnimationFrame(resolve)),
        ),
    );
    await expect(
      page.getByRole("button", { name: "Draft handoff brief", exact: true }),
    ).toBeEnabled();
    await expect(
      page.getByText("STALE FIXTURE MUST NOT APPEAR", { exact: true }),
    ).toHaveCount(0);
  } finally {
    release();
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
