export const stages = [
  "Verified",
  "Dispatched",
  "Acknowledged",
  "Moving",
  "On scene",
  "Care started",
  "Resolved",
];
export function newState() {
  return {
    version: 1,
    stage: 0,
    selected: "CG-0217",
    missedAck: false,
    escalated: false,
    alternate: false,
    hospitalReady: false,
    rehearsed: false,
    fix: false,
    closedAt: null,
    audit: [
      {
        at: "02:17:05",
        actor: "Policy engine",
        text: "Night-hostel SOP matched. Human dispatch confirmation required.",
      },
      {
        at: "02:17:02",
        actor: "Signal fusion",
        text: "Adjacent camera corroboration recorded; no recovery observed.",
      },
      {
        at: "02:17:00",
        actor: "Edge simulator",
        text: "Person-down candidate received from CAM-HB-B07.",
      },
    ],
  };
}
export function advance(state, action) {
  const s = structuredClone(state);
  const allowed = {
    dispatch: 0,
    ack: 1,
    move: 2,
    arrive: 3,
    care: 4,
    resolve: 5,
  };
  if (!(action in allowed) || s.stage !== allowed[action])
    throw new Error("Complete the current response step first.");
  if (action === "ack" && s.missedAck && !s.alternate)
    throw new Error(
      "The assigned unit has not acknowledged. Escalate and offer an alternate unit.",
    );
  s.stage++;
  if (action === "resolve") s.closedAt = "02:18:40";
  const messages = {
    dispatch:
      "Operator confirmed desk + ambulance dispatch. Acceptance required.",
    ack: `${s.alternate ? "Ambulance A1" : "Ambulance A2"} explicitly accepted the task (demo).`,
    move: "Crew reported moving. Map position is illustrative.",
    arrive:
      "Responder recorded arrival using a demo check-in; no live GPS is connected.",
    care: "Responder recorded care start. No diagnosis is inferred.",
    resolve: "Command operator closed the case with a demo handoff outcome.",
  };
  s.audit.unshift({
    at: [
      "02:17:08",
      "02:17:13",
      "02:17:18",
      "02:18:22",
      "02:18:28",
      "02:18:40",
    ][s.stage - 1],
    actor:
      action === "dispatch" || action === "resolve"
        ? "Command operator"
        : "Responder (demo)",
    text: messages[action],
  });
  return s;
}
export function escalate(state) {
  const s = structuredClone(state);
  if (s.stage !== 1)
    throw new Error("Missed-ACK escalation applies to an offered dispatch.");
  if (s.alternate) throw new Error("Alternate unit is already offered.");
  s.escalated = true;
  s.alternate = true;
  s.audit.unshift({
    at: "02:17:38",
    actor: "Proof-of-Response (demo)",
    text: "Missed acknowledgement flagged. A2 marked unreachable; alternate A1 offered.",
  });
  return s;
}
export function rehearsal({
  ambulanceBusy = true,
  gateClosed = true,
  cameraDegraded = true,
  fix = false,
} = {}) {
  const seconds =
    180 +
    (ambulanceBusy ? 115 : 0) +
    (gateClosed ? 75 : 0) +
    (cameraDegraded ? 31 : 0) -
    (fix && gateClosed ? 149 : 0);
  return {
    seconds,
    pass: seconds <= 300,
    sla: 300,
    stages: [
      { label: "Detect", seconds: cameraDegraded ? 10 : 4 },
      { label: "Verify", seconds: cameraDegraded ? 20 : 5 },
      { label: "Coordinate", seconds: 33 },
      {
        label: "Travel + access",
        seconds: seconds - (cameraDegraded ? 30 : 9) - 33,
      },
    ],
    assumptions:
      "Illustrative prototype model; not a measured emergency response.",
  };
}
export function fmtSeconds(s) {
  return `${Math.floor(s / 60)}m ${String(s % 60).padStart(2, "0")}s`;
}
