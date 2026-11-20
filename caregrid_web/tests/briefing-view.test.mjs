import { test } from "node:test";
import assert from "node:assert/strict";
import { renderBriefing } from "../briefing-view.mjs";

test("model prose and metadata cannot become active HTML", () => {
  const html = renderBriefing({
    incidentId: 1,
    brief: {
      status: "generated",
      summary: '<img src=x onerror="alert(1)">',
      notice: "<script>run()</script>",
      evidenceRefs: ["recorded_state"],
      model: "gemini-test-fixture",
      promptVersion: "handoff-facts-v1",
      sourceUpdatedAt: "2026-11-20T00:00:00Z",
    },
  });
  assert.doesNotMatch(html, /<img|<script>/);
  assert.match(html, /&lt;img/);
  assert.match(html, /recorded state/);
  assert.match(html, /GEMINI DRAFT/);
});

test("disabled assistance has no generated draft label or invented fallback", () => {
  const html = renderBriefing({
    incidentId: 1,
    brief: { status: "disabled", notice: "Gemini is not enabled." },
  });
  assert.match(html, /Gemini is not enabled/);
  assert.doesNotMatch(html, /GEMINI DRAFT/);
  assert.match(
    renderBriefing({ incidentId: 1, busy: true }),
    /disabled>Drafting/,
  );
  assert.match(
    renderBriefing({ incidentId: 1, offline: true }),
    /disabled>Draft handoff/,
  );
});
