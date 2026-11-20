// Shared behaviour for the glass navigation bar. Layout is read only when the
// active item changes or the bar resizes; scrolling does no work unless the
// "scrolled" state actually flips.

export function glassThumb(nav) {
  const thumb = nav?.querySelector(".gbar-thumb");
  if (!thumb) return () => {};
  let first = true;
  const place = () => {
    const active = nav.querySelector("[aria-current]");
    if (!active) {
      thumb.removeAttribute("data-ready");
      return;
    }
    const left = active.offsetLeft;
    const width = active.offsetWidth;
    if (first) thumb.style.transition = "none";
    thumb.style.width = `${width}px`;
    thumb.style.transform = `translateX(${left}px)`;
    if (first) {
      void thumb.offsetWidth;
      thumb.style.transition = "";
      first = false;
    }
    thumb.setAttribute("data-ready", "");
    if (nav.scrollWidth > nav.clientWidth)
      nav.scrollTo({
        left: left - (nav.clientWidth - width) / 2,
        behavior: "smooth",
      });
  };
  new ResizeObserver(() => place()).observe(nav);
  document.fonts?.ready.then(place);
  return place;
}

// One listener for the page, however often a bar is re-rendered.
let scrollInstalled = false;
let scrolled = false;
const applyScrolled = () => {
  for (const bar of document.querySelectorAll("[data-gbar]"))
    bar.toggleAttribute("data-scrolled", scrolled);
};
export function glassScroll() {
  if (!scrollInstalled) {
    scrollInstalled = true;
    scrolled = window.scrollY > 8;
    window.addEventListener(
      "scroll",
      () => {
        const next = window.scrollY > 8;
        if (next !== scrolled) {
          scrolled = next;
          applyScrolled();
        }
      },
      { passive: true },
    );
  }
  applyScrolled();
}
