import { build } from "esbuild";
await build({
  entryPoints: ["firebase-auth.js"],
  outfile: "assets/generated/firebase-auth.js",
  bundle: true,
  format: "esm",
  platform: "browser",
  target: "es2022",
  minify: true,
  legalComments: "external",
  sourcemap: false,
});
