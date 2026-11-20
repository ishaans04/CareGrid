import { escapeHtml as e } from "./connected-domain.mjs";

const MAX_BYTES = 512 * 1024;
const keyPattern = /^[a-f0-9]{64}$/;
const generationPattern = /^[1-9][0-9]{0,29}$/;

function validFile(file) {
  return (
    file &&
    keyPattern.test(file.key) &&
    keyPattern.test(file.sha256) &&
    generationPattern.test(file.generation) &&
    generationPattern.test(file.metageneration) &&
    ["image/png", "image/jpeg"].includes(file.mediaType) &&
    Number.isInteger(file.byteLength) &&
    file.byteLength > 0 &&
    file.byteLength <= MAX_BYTES &&
    Number.isFinite(Date.parse(file.createdAt))
  );
}

// Case/session scoped optional state. It never sets the workspace's busy flag
// or connection error. Preview bytes remain in memory and clear on context loss.
export class EvidenceController {
  constructor({
    rpc,
    changed = () => {},
    now = Date.now,
    schedule = (callback, delay) => setTimeout(callback, delay),
    cancel = (handle) => clearTimeout(handle),
  }) {
    Object.assign(this, { rpc, changed, now, schedule, cancel });
    this.contextKey = "";
    this.incidentId = null;
    this.offline = false;
    this.blocked = false;
    this.epoch = 0;
    this.timer = null;
    this.clear();
  }
  clear() {
    this.epoch++;
    this.cancel(this.timer);
    this.timer = null;
    this.page = null;
    this.preview = null;
    this.busy = false;
    this.error = "";
    this.hasPrevious = false;
  }
  context({ incidentId, userId, offline = false, blocked = false }) {
    const key = incidentId && userId ? `${userId}:${incidentId}` : "";
    if (key !== this.contextKey || (offline && !this.offline)) this.clear();
    this.contextKey = key;
    this.incidentId = key ? incidentId : null;
    this.offline = offline;
    this.blocked = blocked;
  }
  get snapshot() {
    return {
      page: this.page,
      preview:
        this.preview && this.now() < this.preview.expires ? this.preview : null,
      busy: this.busy,
      error: this.error,
      blocked: this.blocked || this.offline,
      hasPrevious: this.hasPrevious,
    };
  }
  async run(task) {
    if (!this.incidentId || this.busy || this.offline || this.blocked) return;
    const epoch = this.epoch,
      incidentId = this.incidentId;
    this.busy = true;
    this.error = "";
    this.changed();
    const current = () =>
      epoch === this.epoch && incidentId === this.incidentId;
    try {
      await task({ incidentId, current });
    } catch (error) {
      if (current())
        this.error =
          error.message ||
          "Attachments are unavailable. Continue response actions.";
    } finally {
      if (current()) {
        this.busy = false;
        this.changed();
      }
    }
  }
  async fetchPage(incidentId, pageToken) {
    const page = await this.rpc("evidence", "list", { incidentId, pageToken });
    if (
      !page ||
      !["ready", "disabled", "unavailable"].includes(page.status) ||
      !Array.isArray(page.files) ||
      page.files.length > 50 ||
      !page.files.every(validFile) ||
      (page.nextPageToken != null &&
        (typeof page.nextPageToken !== "string" ||
          page.nextPageToken.length > 4096))
    )
      throw Error(
        "The attachment list could not be read. Continue response actions.",
      );
    return page;
  }
  load(pageToken = null) {
    return this.run(async ({ incidentId, current }) => {
      const page = await this.fetchPage(incidentId, pageToken);
      if (current()) {
        this.page = page;
        this.hasPrevious = pageToken != null;
        this.hidePreview();
      }
    });
  }
  upload(file) {
    if (this.page?.status !== "ready") return Promise.resolve();
    return this.run(async ({ incidentId, current }) => {
      if (
        !file ||
        !["image/png", "image/jpeg"].includes(file.type) ||
        file.size <= 0 ||
        file.size > MAX_BYTES
      )
        throw Error("Choose a PNG or JPEG image of at most 512 KiB.");
      const bytes = new Uint8Array(await file.arrayBuffer());
      if (!current()) return;
      if (bytes.length !== file.size)
        throw Error("The image could not be read.");
      let binary = "";
      for (let i = 0; i < bytes.length; i += 8192)
        binary += String.fromCharCode(...bytes.subarray(i, i + 8192));
      await this.rpc("evidence", "upload", {
        incidentId,
        mediaType: file.type,
        base64Data: btoa(binary),
      });
      if (!current()) return;
      const page = await this.fetchPage(incidentId, null);
      if (!current()) return;
      this.page = page;
      this.hasPrevious = false;
      this.hidePreview();
    });
  }
  read(key) {
    const file = this.page?.files.find((item) => item.key === key);
    if (!file) return Promise.resolve();
    return this.run(async ({ incidentId, current }) => {
      const content = await this.rpc("evidence", "read", {
        incidentId,
        key,
        generation: file.generation,
      });
      if (!current()) return;
      if (
        !validFile(content?.file) ||
        content.file.key !== key ||
        content.file.generation !== file.generation ||
        content.file.sha256 !== file.sha256 ||
        content.file.metageneration !== file.metageneration ||
        typeof content.base64Data !== "string" ||
        content.base64Data.length > Math.ceil(MAX_BYTES / 3) * 4 ||
        !/^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(
          content.base64Data,
        ) ||
        atob(content.base64Data).length !== content.file.byteLength
      )
        throw Error(
          "The private image could not be verified. Refresh the attachment list.",
        );
      this.hidePreview();
      this.preview = {
        file: content.file,
        base64Data: content.base64Data,
        expires: this.now() + 60_000,
      };
      const epoch = this.epoch;
      this.timer = this.schedule(() => {
        if (epoch === this.epoch) {
          this.hidePreview();
          this.changed();
        }
      }, 60_000);
    });
  }
  remove(key) {
    const file = this.page?.files.find((item) => item.key === key);
    if (!file) return Promise.resolve();
    return this.run(async ({ incidentId, current }) => {
      await this.rpc("evidence", "remove", {
        incidentId,
        key,
        generation: file.generation,
      });
      if (!current()) return;
      this.hidePreview();
      this.page = null;
      const page = await this.fetchPage(incidentId, null);
      if (current()) {
        this.page = page;
        this.hasPrevious = false;
      }
    });
  }
  hidePreview() {
    this.cancel(this.timer);
    this.timer = null;
    this.preview = null;
  }
}

export function renderEvidence({
  page,
  preview,
  busy,
  error,
  blocked,
  hasPrevious,
} = {}) {
  const disabled = busy || blocked ? "disabled" : "";
  const action = (name, action, key = "", danger = false) =>
    `<button class="button ${danger ? "danger" : ""}" data-action="evidence-${action}" data-id="${e(key)}" ${disabled}>${e(name)}</button>`;
  return `<section class="detail-section evidence-panel" aria-label="Private attachments"><div class="row between"><h3>Private attachments</h3><span class="pill">COMMAND ONLY</span></div><p class="muted small">Add recorded observations for this case. An image is not proof of arrival or care.</p><div class="actions">${action(busy ? "Working…" : page ? "Refresh attachments" : "Load attachments", "load")}${page?.status === "ready" ? `<label class="button evidence-upload">Attach image<input type="file" name="evidence-image" accept="image/png,image/jpeg" ${disabled}/></label>` : ""}</div>${error ? `<p class="orange small" role="status">${e(error)}</p>` : ""}${page ? `<p class="muted small">${e(page.notice)}</p>` : ""}${page?.status === "ready" ? `<p class="muted small">PNG/JPEG · 512 KiB maximum · original metadata retained. Use approved synthetic material for staging.</p>${page.files.length ? `<div class="evidence-files">${page.files.map((file) => `<article class="evidence-file"><div><strong>${file.mediaType === "image/png" ? "PNG" : "JPEG"} image</strong><p class="muted small">${Math.ceil(file.byteLength / 1024)} KiB · ${e(new Date(file.createdAt).toLocaleString())}</p><code title="SHA-256">${e(file.sha256.slice(0, 16))}…</code></div><div class="actions">${action("View privately", "read", file.key)}${action("Remove", "remove", file.key, true)}</div></article>`).join("")}</div>` : `<p class="muted small">No attachments on this page.</p>`}${hasPrevious ? action("First page", "load") : ""}${page.nextPageToken ? action("Next page", "next") : ""}` : ""}${preview ? `<figure class="evidence-preview"><img src="data:${e(preview.file.mediaType)};base64,${e(preview.base64Data)}" alt="Unverified private incident attachment"/><figcaption class="muted small">Unverified observation · preview closes after 60 seconds.</figcaption>${action("Close preview", "close")}</figure>` : ""}</section>`;
}
