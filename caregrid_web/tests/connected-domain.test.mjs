import { test } from "node:test";
import assert from "node:assert/strict";
import {
  activeDispatch,
  duration,
  escapeHtml,
  label,
  navigationFor,
  incidentStage,
  nextResponderAction,
  openIncident,
  proofSteps,
} from "../connected-domain.mjs";

test("text from the backend is escaped before it reaches HTML", () => {
  assert.equal(
    escapeHtml(`<img src=x onerror="alert('x')">&`),
    "&lt;img src=x onerror=&quot;alert(&#39;x&#39;)&quot;&gt;&amp;",
  );
  assert.equal(escapeHtml(null), "");
});

test("enum labels and durations read as operators speak", () => {
  assert.equal(label("enRoute"), "En route");
  assert.equal(label("hospitalReady"), "Hospital Ready");
  assert.equal(duration(7), "7s");
  assert.equal(duration(85), "1m 25s");
  assert.equal(duration(null), "—");
  assert.equal(duration(-5), "0s");
});

test("only live assignments can be stood down", () => {
  for (const status of [
    "offered",
    "acknowledged",
    "enRoute",
    "onScene",
    "care",
  ])
    assert.equal(activeDispatch({ status }), true, status);
  for (const status of ["completed", "declined", "timedOut", "recalled"])
    assert.equal(activeDispatch({ status }), false, status);
});

test("the proof chain counts recorded milestones, never estimates", () => {
  assert.deepEqual(
    proofSteps({
      offeredAt: "t",
      acknowledgedAt: "t",
      enRouteAt: null,
      onSceneAt: null,
      careAt: null,
      etaSeconds: 85,
    }),
    [true, true, false, false, false],
  );
});

test("each responder status offers exactly one next action", () => {
  assert.deepEqual(nextResponderAction("offered"), [
    "acknowledge",
    "Acknowledge assignment",
  ]);
  assert.deepEqual(nextResponderAction("enRoute")[0], "arrive");
  assert.equal(nextResponderAction("completed"), null);
});

test("navigation follows the server role, and closed cases are not open", () => {
  assert.deepEqual(
    navigationFor("member").map(([key]) => key),
    ["sos"],
  );
  assert.deepEqual(navigationFor("unknown"), []);
  assert.equal(openIncident({ state: "care" }), true);
  assert.equal(openIncident({ state: "resolved" }), false);
  assert.equal(openIncident({ state: "dismissed" }), false);
});

test("the progress spine follows the measured incident state", () => {
  assert.equal(incidentStage("detected"), 0);
  assert.equal(incidentStage("review"), incidentStage("verified"));
  assert.equal(incidentStage("onScene"), 5);
  assert.equal(incidentStage("resolved"), 7);
  assert.equal(incidentStage("dismissed"), 7);
  assert.equal(incidentStage("unexpected"), 0);
});
