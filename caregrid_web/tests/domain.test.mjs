import test from "node:test";
import assert from "node:assert/strict";
import { newState, advance, escalate, rehearsal } from "../domain.mjs";
test("closure requires the full explicit response chain", () => {
  let s = newState();
  assert.throws(() => advance(s, "resolve"));
  for (const a of ["dispatch", "ack", "move", "arrive", "care", "resolve"])
    s = advance(s, a);
  assert.equal(s.stage, 6);
  assert.equal(s.audit.length, 9);
  assert.throws(() => advance(s, "resolve"));
});
test("silence cannot become acknowledgement or closure", () => {
  let s = newState();
  s.missedAck = true;
  s = advance(s, "dispatch");
  assert.throws(() => advance(s, "ack"));
  assert.throws(() => advance(s, "resolve"));
  s = escalate(s);
  assert.equal(s.alternate, true);
  s = advance(s, "ack");
  assert.equal(s.stage, 2);
  assert.equal(s.escalated, true);
});
test("rehearsal is isolated and the route intervention changes the predicted verdict", () => {
  const original = newState();
  const failed = rehearsal();
  const improved = rehearsal({ fix: true });
  assert.equal(failed.seconds, 401);
  assert.equal(failed.pass, false);
  assert.equal(improved.seconds, 252);
  assert.equal(improved.pass, true);
  assert.deepEqual(original, newState());
  assert.equal(
    rehearsal({ gateClosed: false, fix: true }).seconds,
    rehearsal({ gateClosed: false }).seconds,
  );
});
