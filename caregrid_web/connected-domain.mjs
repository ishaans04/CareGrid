export const escapeHtml = (value) =>
  String(value ?? "").replace(
    /[&<>"']/g,
    (character) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        character
      ],
  );
export const label = (value) =>
  ({
    enRoute: "En route",
    onScene: "On scene",
    timedOut: "Timed out",
    personDown: "Person down",
    sosRequest: "SOS request",
  })[value] ||
  String(value || "Unknown")
    .replace(/([a-z])([A-Z])/g, "$1 $2")
    .replace(/^./, (character) => character.toUpperCase());
export function duration(seconds) {
  if (seconds == null || !Number.isFinite(Number(seconds))) return "—";
  const total = Math.max(0, Math.round(seconds));
  return total < 60
    ? `${total}s`
    : `${Math.floor(total / 60)}m ${String(total % 60).padStart(2, "0")}s`;
}
export const clock = (value) =>
  value
    ? new Date(value).toLocaleTimeString("en-IN", {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false,
      })
    : "Awaiting";
export const openIncident = (incident) =>
  !["resolved", "dismissed"].includes(incident.state);
export const activeDispatch = (dispatch) =>
  ["offered", "acknowledged", "enRoute", "onScene", "care"].includes(
    dispatch.status,
  );
export const proofSteps = (dispatch) =>
  ["offeredAt", "acknowledgedAt", "enRouteAt", "onSceneAt", "careAt"].map(
    (key) => Boolean(dispatch[key]),
  );
export const nextResponderAction = (status) =>
  ({
    offered: ["acknowledge", "Acknowledge assignment"],
    acknowledged: ["enRoute", "Confirm departure"],
    enRoute: ["arrive", "Confirm I am on scene"],
    onScene: ["startCare", "Confirm care has started"],
    care: ["complete", "Complete my assignment"],
  })[status] || null;
export const navigationFor = (role) =>
  ({
    command: [
      ["overview", "Command centre"],
      ["care", "Care handoff"],
      ["readiness", "Readiness lab"],
      ["analytics", "After action"],
    ],
    admin: [
      ["overview", "Campus overview"],
      ["readiness", "Readiness lab"],
      ["analytics", "After action"],
      ["audit", "Audit trail"],
    ],
    medical: [["care", "Care console"]],
    responder: [["response", "My assignment"]],
    member: [["sos", "Request help"]],
  })[role] || [];
