import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const errors = [];
let count = 0;
async function walk(dir) {
  let out = [];
  for (const entry of await fs.readdir(dir, { withFileTypes: true })) {
    if (["node_modules", "test-results", "playwright-report"].includes(entry.name)) continue;
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) out.push(...(await walk(p)));
    else out.push(p);
  }
  return out;
}
const docs = [
  "README.md",
  "docs/COMPONENTS.md",
  "infra/google/README.md",
  ...(await walk(path.join(root, "docs/buildathon"))).filter((p) =>
    p.endsWith(".md"),
  ),
  ...(await walk(path.join(root, "assets/pitch"))).filter((p) =>
    /\.(md|html)$/.test(p),
  ),
  ...(await walk(path.join(root, "caregrid_web"))).filter((p) =>
    p.endsWith(".md"),
  ),
];
for (const doc of docs) {
  const absolute = path.resolve(root, doc);
  const text = await fs.readFile(absolute, "utf8");
  const links = [...text.matchAll(/\]\(([^)]+)\)/g)].map((m) => m[1]);
  if (absolute.endsWith(".html"))
    for (const match of text.matchAll(/(?:src|href)="([^"]+)"/g))
      links.push(match[1]);
  for (let link of links) {
    if (/^(https?:|mailto:|#)/.test(link)) continue;
    link = link.split("#")[0];
    if (!link) continue;
    count++;
    try {
      await fs.access(
        path.resolve(path.dirname(absolute), decodeURIComponent(link)),
      );
    } catch {
      errors.push(`${path.relative(root, absolute)}: ${link}`);
    }
  }
}
for (const manifest of [
  "docs/buildathon/pdf-review-manifest.json",
  "docs/buildathon/source-verification.json",
])
  JSON.parse(await fs.readFile(path.join(root, manifest), "utf8"));
const sources = JSON.parse(
  await fs.readFile(
    path.join(root, "docs/buildathon/source-verification.json"),
    "utf8",
  ),
);
if (sources.some((x) => x.status !== 200))
  errors.push("Source manifest has unsuccessful links.");
if (errors.length) {
  console.error(errors.join("\n"));
  process.exit(1);
}
console.log(
  `${count} local document/asset links resolve; JSON manifests parse; ${sources.length} recorded public links returned HTTP 200.`,
);
