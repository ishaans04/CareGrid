import http from "node:http";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.dirname(fileURLToPath(import.meta.url));
const types = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".json": "application/json",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".woff2": "font/woff2",
};
const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, "http://localhost");
    const pathname = decodeURIComponent(url.pathname);
    const target = path.resolve(
      root,
      "." + (pathname === "/" ? "/index.html" : pathname),
    );
    if (target !== root && !target.startsWith(root + path.sep)) {
      res.writeHead(403);
      return res.end("Forbidden");
    }
    const data = await fs.readFile(target);
    res.writeHead(200, {
      "Content-Type": types[path.extname(target)] || "application/octet-stream",
      "X-Content-Type-Options": "nosniff",
      "Cache-Control": "no-store",
    });
    res.end(data);
  } catch {
    res.writeHead(404, { "Content-Type": "text/plain" });
    res.end("Not found");
  }
});
const port = Number(process.env.PORT || 4173);
server.listen(port, "127.0.0.1", () =>
  console.log(`CareGrid prototype: http://127.0.0.1:${port}`),
);
