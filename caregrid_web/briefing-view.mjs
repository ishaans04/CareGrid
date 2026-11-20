import { escapeHtml as e, clock } from "./connected-domain.mjs";

export function renderBriefing({ incidentId, brief, busy, offline }) {
  const generated = brief?.status === "generated";
  return `<div class="detail-section" id="handoff-brief"><div class="row between"><h3>Handoff brief</h3><span class="pill ${generated ? "good" : ""}">${generated ? "GEMINI DRAFT" : "OPTIONAL"}</span></div><p class="muted small">Create a short draft from recorded response facts. Review it before sharing.</p><div style="margin-top:16px"><button type="button" class="button" data-action="draft-brief" data-id="${e(incidentId)}" ${busy || offline ? "disabled" : ""}>${busy ? "Drafting…" : "Draft handoff brief"}</button></div>${brief ? `<div style="margin-top:18px">${generated ? `<p>${e(brief.summary)}</p><p class="small cyan" style="margin-top:12px">Record references: ${brief.evidenceRefs.map((ref) => e(ref.replaceAll("_", " "))).join(" · ")}</p><p class="small muted" style="margin-top:10px">${e(brief.model)} · ${e(brief.promptVersion)} · source ${clock(brief.sourceUpdatedAt)}</p>` : ""}<p class="small muted" style="margin-top:12px">${e(brief.notice)}</p></div>` : ""}</div>`;
}
