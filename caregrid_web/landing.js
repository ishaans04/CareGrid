import { glassThumb, glassScroll } from "./glass.mjs";
import { rehearsal, fmtSeconds } from "./domain.mjs";

const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];
const clamp = (value, min = 0, max = 1) => Math.min(max, Math.max(min, value));
const range = (p, start, end) => clamp((p - start) / (end - start));
const lerp = (a, b, t) => a + (b - a) * t;
const easeOut = (t) => 1 - (1 - t) ** 3;
const reduceMotion = matchMedia("(prefers-reduced-motion: reduce)");

let vw = innerWidth;
let vh = innerHeight;

/* ───────── Top bar, scroll-spy and tone ───────── */
const bar = $("[data-gbar]");
glassScroll();
const spy = $("[data-spy]");
const placeThumb = glassThumb(spy);
const spyLinks = $$("a", spy);
const spyIds = spyLinks.map((link) => link.hash.slice(1));
let spyActive = "";
function setSpy(id) {
  if (id === spyActive) return;
  spyActive = id;
  for (const link of spyLinks)
    link.hash.slice(1) === id
      ? link.setAttribute("aria-current", "true")
      : link.removeAttribute("aria-current");
  placeThumb();
}
const spyObserver = new IntersectionObserver(
  (entries) => {
    for (const entry of entries)
      if (entry.isIntersecting)
        setSpy(spyIds.includes(entry.target.id) ? entry.target.id : "");
  },
  { rootMargin: "-50% 0px -50% 0px" },
);
for (const section of $$("main > section")) spyObserver.observe(section);
// Transparent white-on-blue bar while a blue band sits under it.
const heroBands = new Set();
const toneObserver = new IntersectionObserver(
  (entries) => {
    for (const entry of entries)
      entry.isIntersecting
        ? heroBands.add(entry.target)
        : heroBands.delete(entry.target);
    heroBands.size
      ? bar.setAttribute("data-tone", "hero")
      : bar.removeAttribute("data-tone");
  },
  { rootMargin: "0px 0px -92% 0px" },
);
for (const section of $$("[data-tone-hero]")) toneObserver.observe(section);

/* ───────── Pinned, scroll-scrubbed sections ───────── */
const pins = [];
function pin(element, update, onMeasure = () => {}) {
  if (element)
    pins.push({ element, update, onMeasure, top: 0, length: 1, last: -1 });
}
function measure() {
  vw = innerWidth;
  vh = innerHeight;
  for (const item of pins) {
    item.top = item.element.getBoundingClientRect().top + scrollY;
    item.length = Math.max(1, item.element.offsetHeight - vh);
    item.last = -1;
    item.onMeasure();
  }
  frame();
}
let queued = false;
function frame() {
  queued = false;
  const y = scrollY;
  for (const item of pins) {
    const p = clamp((y - item.top) / item.length);
    if (p !== item.last) {
      item.last = p;
      item.update(p);
    }
  }
}
addEventListener(
  "scroll",
  () => {
    if (!queued) {
      queued = true;
      requestAnimationFrame(frame);
    }
  },
  { passive: true },
);
let resizeTimer;
addEventListener("resize", () => {
  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(measure, 80);
});

/* ───────── Hero campus model: extruded isometric blocks, drawn once ───────── */
const ISO = {
  scale: 0.74,
  cos: Math.cos(Math.PI / 6),
  sin: 0.5,
  ox: 0,
  oy: -150,
};
// Plan (x, y) in a 600 × 600 campus; z is height. Returns viewBox coordinates.
const iso = (x, y, z = 0) => [
  (x - y) * ISO.cos * ISO.scale + ISO.ox,
  (x + y) * ISO.sin * ISO.scale - z * ISO.scale + ISO.oy + 160,
];
const pts = (list) =>
  list.map((p) => p.map((n) => n.toFixed(1)).join(",")).join(" ");
{
  const svg = $("[data-model-svg]");
  const palettes = {
    blue: ["url(#g-blue-top)", "url(#g-blue-right)", "url(#g-blue-front)"],
    yellow: ["url(#g-yel-top)", "url(#g-yel-right)", "url(#g-yel-front)"],
    frost: ["url(#g-fro-top)", "url(#g-fro-right)", "url(#g-fro-front)"],
    plate: ["#f3f6fd", "#c3d2ee", "#b0c3e8"],
  };
  const box = (x0, y0, x1, y1, h, kind = "blue", z0 = 0) => {
    const [top, right, front] = palettes[kind];
    const edge =
      kind === "plate"
        ? ""
        : ` stroke="#ffffff" stroke-opacity=".7" stroke-width=".9" stroke-linejoin="round"`;
    return `<g><polygon points="${pts([iso(x1, y0, z0), iso(x1, y1, z0), iso(x1, y1, h), iso(x1, y0, h)])}" fill="${right}"${edge}/><polygon points="${pts([iso(x0, y1, z0), iso(x1, y1, z0), iso(x1, y1, h), iso(x0, y1, h)])}" fill="${front}"${edge}/><polygon points="${pts([iso(x0, y0, h), iso(x1, y0, h), iso(x1, y1, h), iso(x0, y1, h)])}" fill="${top}"${edge}/></g>`;
  };
  const flat = (x0, y0, x1, y1, fill, z = 0.4) =>
    `<polygon points="${pts([iso(x0, y0, z), iso(x1, y0, z), iso(x1, y1, z), iso(x0, y1, z)])}" fill="${fill}"/>`;
  const gradient = (id, a, b) =>
    `<linearGradient id="${id}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${a}"/><stop offset="1" stop-color="${b}"/></linearGradient>`;
  // Buildings as [x0, y0, x1, y1, height, kind].
  const blocks = [
    [54, 58, 112, 106, 26],
    [152, 58, 214, 106, 34],
    [230, 58, 296, 106, 34],
    [338, 58, 442, 106, 44],
    [482, 58, 544, 106, 30],
    [54, 150, 112, 296, 54],
    [152, 150, 296, 188, 62, "yellow"],
    [152, 188, 194, 296, 62, "yellow"],
    [254, 188, 296, 296, 62, "yellow"],
    [338, 150, 442, 174, 72],
    [338, 174, 360, 272, 72],
    [420, 174, 442, 272, 72],
    [338, 272, 442, 296, 72],
    [54, 340, 112, 402, 30],
    [54, 416, 112, 472, 30],
    [338, 340, 442, 398, 50],
    [338, 414, 442, 472, 58],
    [482, 340, 544, 472, 66, "frost"],
  ].sort((a, b) => a[0] + a[1] + a[2] + a[3] - (b[0] + b[1] + b[2] + b[3]));
  const roads = [
    [30, 117, 570, 139],
    [30, 307, 570, 329],
    [30, 481, 570, 503],
    [121, 30, 143, 570],
    [307, 30, 329, 570],
    [451, 30, 473, 570],
  ];
  const route = [
    [512, 406],
    [462, 406],
    [462, 318],
    [318, 318],
    [318, 214],
    [296, 214],
  ];
  const routePath = route
    .map(
      ([x, y], i) =>
        `${i ? "L" : "M"}${iso(x, y, 1)
          .map((n) => n.toFixed(1))
          .join(" ")}`,
    )
    .join("");
  const [ax, ay] = iso(390, 318, 1);
  const cross = [
    iso(507, 400, 66.5),
    iso(519, 400, 66.5),
    iso(519, 412, 66.5),
    iso(507, 412, 66.5),
  ];
  const crossH = [
    iso(497, 404, 66.5),
    iso(529, 404, 66.5),
    iso(529, 408, 66.5),
    iso(497, 408, 66.5),
  ];
  svg.innerHTML = `<defs>${gradient("g-blue-top", "#e2edff", "#a9c6f6")}${gradient("g-blue-right", "#5f8de3", "#2f5bbc")}${gradient("g-blue-front", "#4a78d6", "#2a50aa")}${gradient("g-yel-top", "#fff5c8", "#f6dd78")}${gradient("g-yel-right", "#f3d465", "#e0b842")}${gradient("g-yel-front", "#ebc957", "#cfa63a")}${gradient("g-fro-top", "#ffffff", "#eef3fc")}${gradient("g-fro-right", "#e3ebf8", "#c7d5ef")}${gradient("g-fro-front", "#d6e1f4", "#b9cae8")}<radialGradient id="g-shadow"><stop offset="0" stop-color="#1e3c8a" stop-opacity=".16"/><stop offset="1" stop-color="#1e3c8a" stop-opacity="0"/></radialGradient></defs><ellipse cx="0" cy="${iso(300, 300)[1] + 40}" rx="470" ry="150" fill="url(#g-shadow)"/>${box(0, 0, 600, 600, 0, "plate", -16)}${roads.map((r) => flat(...r, "#ffffff")).join("")}${flat(150, 338, 300, 474, "#dcefdc")}${flat(480, 146, 546, 300, "#dcefdc")}<path d="${routePath}" fill="none" stroke="#2b58bf" stroke-width="5" stroke-linejoin="round" stroke-linecap="round"/><path d="${routePath}" fill="none" stroke="#ffffff" stroke-width="1.6" stroke-dasharray="2 7" stroke-linecap="round"/>${blocks.map(([x0, y0, x1, y1, h, kind]) => box(x0, y0, x1, y1, h, kind)).join("")}<polygon points="${pts(cross)}" fill="#1f8a4c"/><polygon points="${pts(crossH)}" fill="#1f8a4c"/><g transform="translate(${ax.toFixed(1)} ${ay.toFixed(1)})"><ellipse rx="14" ry="8" fill="#2b58bf" stroke="#fff" stroke-width="2.5"/><path d="M-5 2 0-4 5 2" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></g>`;
  // Place chips and the incident ring at their projected points.
  const [vx, vy, vw0, vh0] = svg
    .getAttribute("viewBox")
    .split(/\s+/)
    .map(Number);
  for (const element of $$("[data-chip]")) {
    const [x, y, z] = element.dataset.chip.split(",").map(Number);
    const [px, py] = iso(x, y, z);
    element.style.left = `${(((px - vx) / vw0) * 100).toFixed(2)}%`;
    element.style.top = `${(((py - vy) / vh0) * 100).toFixed(2)}%`;
  }
  // Gentle lift as the hero scrolls away (transform only).
  const stage = $("[data-model-stage]");
  const hero = $(".hero");
  pin(hero, (p) => {
    if (reduceMotion.matches) return;
    stage.style.transform = `translateY(${(-easeOut(p) * 70).toFixed(1)}px)`;
  });
}

/* ───────── Statements: words resolve from grey to ink ───────── */
for (const section of $$("[data-pin='statement']")) {
  const say = $("[data-say]", section);
  const words = say.textContent.trim().split(/\s+/);
  say.innerHTML = words
    .map((word) => `<span class="w">${word}</span> `)
    .join("");
  const spans = $$(".w", say);
  const cards = $$(".card", section);
  const threads = $$(".threads i", section);
  let lit = -1;
  let shown = -1;
  pin(section, (p) => {
    const nextLit = Math.round(range(p, 0.08, 0.7) * spans.length);
    if (nextLit !== lit) {
      lit = nextLit;
      spans.forEach((span, index) => span.classList.toggle("on", index < lit));
    }
    const nextShown = Math.floor(range(p, 0.15, 0.85) * (cards.length + 0.999));
    if (nextShown !== shown) {
      shown = nextShown;
      cards.forEach((card, index) =>
        card.classList.toggle("on", index < shown),
      );
    }
    const draw = easeOut(range(p, 0, 0.35)).toFixed(3);
    threads.forEach((thread, index) => {
      thread.style.setProperty("--draw", draw);
      thread.style.setProperty(
        "--run",
        `${(((p * 1.6 + index * 0.23) % 1) * 90).toFixed(1)}%`,
      );
    });
  });
}

/* ───────── Introducing: the split title closes, the preview rises ───────── */
{
  const section = $("[data-pin='intro']");
  const left = $("[data-left]", section);
  const right = $("[data-right]", section);
  const preview = $("[data-preview]", section);
  let gap = 0;
  pin(
    section,
    (p) => {
      const close = easeOut(range(p, 0.05, 0.55));
      const shift = (gap / 2) * close;
      left.style.transform = `translateX(${shift.toFixed(1)}px)`;
      right.style.transform = `translateX(${(-shift).toFixed(1)}px)`;
      const rise = easeOut(range(p, 0.25, 0.7));
      preview.style.opacity = String(rise);
      preview.style.transform = `translateY(${((1 - rise) * 40).toFixed(1)}px)`;
    },
    () => {
      left.style.transform = "";
      right.style.transform = "";
      const box = left.parentElement.getBoundingClientRect();
      gap = Math.max(0, box.width - left.offsetWidth - right.offsetWidth - 24);
    },
  );
}

/* 02 · One hundred seconds, scrubbed by scroll */
{
  const section = $("[data-pin='replay']");
  const clockEl = $("[data-clock]");
  const events = $$("[data-events] article");
  const ledger = $$("[data-ledger] li");
  const chain = $$("[data-chain] span");
  const frameEl = $("[data-map]");
  const route = $("[data-route]");
  const unit = $("[data-unit]");
  const tag = $("[data-tag]");
  const cams = $$("[data-cam]");
  const incident = $("[data-incident]");
  route.setAttribute("pathLength", "1");
  route.style.strokeDasharray = "1";
  route.style.strokeDashoffset = "1";

  const times = [0, 2, 5, 8, 13, 18, 82, 88, 100];
  const marks = times.map(
    (_, index) => 0.05 + (index * 0.87) / (times.length - 1),
  );
  const path = [
    [512, 406],
    [462, 406],
    [462, 318],
    [318, 318],
    [318, 214],
    [296, 214],
  ];
  const segments = path.slice(1).map(([x, y], index) => {
    const [px, py] = path[index];
    return {
      x: px,
      y: py,
      dx: x - px,
      dy: y - py,
      length: Math.hypot(x - px, y - py),
    };
  });
  const total = segments.reduce((sum, segment) => sum + segment.length, 0);
  function along(progress) {
    let remaining = progress * total;
    for (const segment of segments) {
      if (remaining <= segment.length || segment === segments.at(-1)) {
        const t = segment.length ? clamp(remaining / segment.length) : 0;
        return {
          x: segment.x + segment.dx * t,
          y: segment.y + segment.dy * t,
          angle: (Math.atan2(segment.dy, segment.dx) * 180) / Math.PI + 90,
        };
      }
      remaining -= segment.length;
    }
  }
  let size = 600;
  let tagWidth = 0;
  let step = -1;
  let shown = -1;
  pin(
    section,
    (p) => {
      let seconds = 0;
      let index = 0;
      for (let i = 0; i < marks.length; i++) if (p >= marks[i]) index = i;
      if (p >= marks.at(-1)) seconds = 100;
      else if (p > marks[0]) {
        const t = (p - marks[index]) / (marks[index + 1] - marks[index]);
        seconds = lerp(times[index], times[index + 1], t);
      }
      const whole = Math.floor(seconds);
      if (whole !== shown) {
        shown = whole;
        const minutes = 17 + Math.floor(whole / 60);
        clockEl.textContent = `02:${String(minutes).padStart(2, "0")}:${String(whole % 60).padStart(2, "0")}`;
      }
      const travel = clamp((seconds - 18) / (82 - 18));
      route.style.strokeDashoffset = (1 - travel).toFixed(4);
      const point = along(travel);
      const scale = size / 600;
      const ux = point.x * scale;
      const uy = point.y * scale;
      unit.style.transform = `translate(${ux.toFixed(1)}px, ${uy.toFixed(1)}px) rotate(${point.angle}deg)`;
      if (index !== step) {
        step = index;
        const visible = index >= 3;
        unit.style.opacity = visible ? "1" : "0";
        tag.style.opacity = visible ? "1" : "0";
        tag.textContent =
          index >= 8
            ? "AMB-A2 · HANDED OVER"
            : index >= 6
              ? "AMB-A2 · ON SCENE"
              : index >= 5
                ? "AMB-A2 · EN ROUTE"
                : "AMB-A2 · DISPATCHED";
        tagWidth = tag.offsetWidth;
        events.forEach((event, i) => event.classList.toggle("on", i === index));
        ledger.forEach((row, i) => {
          row.classList.toggle("done", i < index || index === 8);
          row.classList.toggle("now", i === index && index !== 8);
        });
        const proved = Math.max(0, index - 2);
        chain.forEach((link, i) => link.classList.toggle("done", i < proved));
        cams[0].classList.toggle("hot", index <= 2);
        cams[1].classList.toggle("hot", index >= 1 && index <= 2);
        incident.classList.toggle("resolved", index === 8);
      }
      const tagX =
        ux + 22 + tagWidth > size - 12 ? ux - 22 - tagWidth : ux + 22;
      tag.style.transform = `translate(${tagX.toFixed(1)}px, ${(uy - 36).toFixed(1)}px)`;
    },
    () => {
      size = frameEl.offsetWidth;
      tagWidth = tag.offsetWidth;
    },
  );
}

/* 04 · Readiness lab, using the same model as the interactive demo */
{
  const form = $("[data-lab]");
  const time = $("[data-time]");
  const verdict = $("[data-verdict]");
  const totalBar = $("[data-total]");
  const stageList = $("[data-stages]");
  const fields = ["ambulanceBusy", "gateClosed", "cameraDegraded", "fix"];
  let current = rehearsal();
  stageList.innerHTML = current.stages
    .map(
      (stage) =>
        `<div><dt>${stage.label}</dt><dd><i></i></dd><b class="tnum">${stage.seconds}s</b></div>`,
    )
    .join("");
  const bars = $$("dd i", stageList);
  const values = $$("b", stageList);
  let tween = 0;
  function render(result, animate) {
    verdict.textContent = result.pass ? "Within objective" : "Objective missed";
    verdict.classList.toggle("pass", result.pass);
    totalBar.style.transform = `scaleX(${Math.min(1, result.seconds / 420).toFixed(4)})`;
    totalBar.classList.toggle("pass", result.pass);
    result.stages.forEach((stage, index) => {
      bars[index].style.transform =
        `scaleX(${Math.min(1, stage.seconds / 300).toFixed(4)})`;
      values[index].textContent = `${stage.seconds}s`;
    });
    const from = current.seconds;
    const to = result.seconds;
    current = result;
    cancelAnimationFrame(tween);
    if (!animate || reduceMotion.matches || from === to) {
      time.textContent = fmtSeconds(to);
      return;
    }
    const start = performance.now();
    const step = (now) => {
      const t = easeOut(clamp((now - start) / 520));
      time.textContent = fmtSeconds(Math.round(lerp(from, to, t)));
      if (t < 1) tween = requestAnimationFrame(step);
    };
    tween = requestAnimationFrame(step);
  }
  form.addEventListener("change", () =>
    render(
      rehearsal(
        Object.fromEntries(
          fields.map((name) => [name, form.elements[name].checked]),
        ),
      ),
      true,
    ),
  );
  render(current, false);
}

measure();
document.fonts?.ready.then(measure);
