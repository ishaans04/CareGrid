import { glassThumb, glassScroll } from "./glass.mjs";
import { rehearsal, fmtSeconds } from "./domain.mjs";

const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];
const clamp = (value, min = 0, max = 1) => Math.min(max, Math.max(min, value));
const range = (p, start, end) => clamp((p - start) / (end - start));
const lerp = (a, b, t) => a + (b - a) * t;
const easeOut = (t) => 1 - (1 - t) ** 3;
const easeInOut = (t) => (t < 0.5 ? 4 * t ** 3 : 1 - (-2 * t + 2) ** 3 / 2);
const reduceMotion = matchMedia("(prefers-reduced-motion: reduce)");

let vw = innerWidth;
let vh = innerHeight;

/* ───────── Glass bar and scroll-spy ───────── */
const bar = $("[data-gbar]");
glassScroll(bar);
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
// The bar turns to smoked glass while a dark section sits beneath it.
const toneObserver = new IntersectionObserver(
  (entries) => {
    for (const entry of entries)
      entry.isIntersecting
        ? bar.setAttribute("data-tone", "dark")
        : bar.removeAttribute("data-tone");
  },
  { rootMargin: "-4% 0px -95% 0px" },
);
for (const section of $$(".night")) toneObserver.observe(section);

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

/* 01 · Exploded campus */
{
  const section = $("[data-pin='reveal']");
  const copy = $("[data-hero-copy]");
  const rig = $("[data-rig]");
  const layers = $$(".layer", rig);
  const planes = $$(".plane", rig);
  const chapters = $("[data-chapters]");
  const chapterItems = $$("li", chapters);
  const coda = $("[data-coda]");
  const cue = $(".scroll-cue");
  const scene = $(".scene");
  let S = 600;
  let chapter = -1;
  pin(
    section,
    (p) => {
      const wide = vw > 960;
      const still = reduceMotion.matches;
      const arrive = easeInOut(range(p, 0.02, 0.19));
      const open = easeOut(range(p, 0.18, 0.32));
      const close = easeInOut(range(p, 0.84, 0.96));
      const explode = open * (1 - close);

      copy.style.opacity = String(1 - range(p, 0.015, 0.13));
      copy.style.transform = `translate(-50%, ${(-arrive * vh * 0.14).toFixed(1)}px)`;
      copy.style.visibility = p > 0.15 ? "hidden" : "";
      cue.style.opacity = String(1 - range(p, 0, 0.03));

      const x = wide ? lerp(0, vw * 0.2, arrive) : 0;
      const y =
        lerp(vh * 0.43, wide ? vh * 0.02 : -vh * 0.1, arrive) +
        explode * S * (wide ? 0.25 : 0.2) +
        close * (wide ? vh * 0.02 : 0);
      const tiltX = lerp(56, 57, arrive);
      const turn = still ? -38 : -38 + p * 18;
      const scale = lerp(0.94, wide ? 0.9 : 0.8, arrive);
      rig.style.transform = `translate3d(${x.toFixed(1)}px, ${y.toFixed(1)}px, 0) rotateX(${tiltX.toFixed(2)}deg) rotateZ(${turn.toFixed(2)}deg) scale(${scale.toFixed(4)})`;

      const gap = S * (wide ? 0.2 : 0.17) * explode;
      const next =
        p < 0.3 ? 0 : Math.min(3, Math.floor((p - 0.3) / ((0.84 - 0.3) / 4)));
      const focus = range(p, 0.28, 0.32) * (1 - range(p, 0.82, 0.86));
      layers.forEach((layer, index) => {
        layer.style.transform = `translateZ(${(index * gap).toFixed(1)}px)`;
        const dim = index === next ? 0 : index === 0 ? 0.3 : 0.55;
        layer.style.opacity = String(1 - focus * dim);
      });
      for (const plane of planes) plane.style.opacity = String(explode * 0.42);

      chapters.style.opacity = String(
        range(p, 0.19, 0.26) * (1 - range(p, 0.83, 0.87)),
      );
      chapters.style.setProperty("--fill", range(p, 0.3, 0.84).toFixed(3));
      if (next !== chapter) {
        chapter = next;
        chapterItems.forEach((item, index) =>
          item.classList.toggle("on", index === next),
        );
      }
      const outro = range(p, 0.88, 0.96);
      coda.style.opacity = String(outro);
      coda.style.transform = wide
        ? `translateY(calc(-50% + ${((1 - outro) * 24).toFixed(1)}px))`
        : `translateY(${((1 - outro) * 24).toFixed(1)}px)`;
    },
    () => {
      S = scene.offsetWidth;
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
      unit.style.transform = `translate3d(${ux.toFixed(1)}px, ${uy.toFixed(1)}px, 0) rotate(${point.angle}deg)`;
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
      tag.style.transform = `translate3d(${tagX.toFixed(1)}px, ${(uy - 36).toFixed(1)}px, 0)`;
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
