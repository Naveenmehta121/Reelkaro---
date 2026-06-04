/**
 * CurvedLoop — Pure JS + SVG port of the React Bits CurvedLoop component.
 * Works in any JSP / plain HTML page — zero dependencies.
 *
 * Usage:
 *   <div class="curved-loop-jacket" data-text="Your text ✦" data-speed="2"
 *        data-curve="400" data-direction="left" data-interactive="true"></div>
 *
 *   Then call: CurvedLoop.initAll();
 */

(function () {
  'use strict';

  let _uid = 0;

  function initOne(jacket) {
    const marqueeText = jacket.dataset.text   || 'ReelKaro ✦ India\'s Creator Marketplace ✦';
    const speed       = parseFloat(jacket.dataset.speed  || 2);
    const curveAmount = parseFloat(jacket.dataset.curve  || 400);
    const direction   = jacket.dataset.direction || 'left';
    const interactive = jacket.dataset.interactive !== 'false';
    const className   = jacket.dataset.class || '';

    const uid    = ++_uid;
    const pathId = 'curved-loop-path-' + uid;

    // Normalise text: strip trailing whitespace, add non-breaking space
    const text = marqueeText.replace(/\s+$/, '') + '\u00A0';

    // SVG path: a gentle quadratic bezier
    const pathD = `M-100,40 Q500,${40 + curveAmount} 1540,40`;

    // ── Build SVG ────────────────────────────────────────────────────────────
    const ns = 'http://www.w3.org/2000/svg';

    const svg = document.createElementNS(ns, 'svg');
    svg.setAttribute('class', 'curved-loop-svg');
    svg.setAttribute('viewBox', '0 0 1440 120');
    svg.setAttribute('aria-hidden', 'true');

    // Hidden measure text
    const measureText = document.createElementNS(ns, 'text');
    measureText.setAttribute('style', 'visibility:hidden;opacity:0;pointer-events:none;');
    measureText.setAttribute('xml:space', 'preserve');
    if (className) measureText.setAttribute('class', className);
    measureText.textContent = text;
    svg.appendChild(measureText);

    // Defs + path
    const defs = document.createElementNS(ns, 'defs');
    const path = document.createElementNS(ns, 'path');
    path.setAttribute('id', pathId);
    path.setAttribute('d', pathD);
    path.setAttribute('fill', 'none');
    path.setAttribute('stroke', 'transparent');
    defs.appendChild(path);
    svg.appendChild(defs);

    // Animated text element (hidden until spacing measured)
    const animText = document.createElementNS(ns, 'text');
    animText.setAttribute('font-weight', 'bold');
    animText.setAttribute('xml:space', 'preserve');
    if (className) animText.setAttribute('class', className);
    animText.style.visibility = 'hidden';

    const textPath = document.createElementNS(ns, 'textPath');
    textPath.setAttribute('href', '#' + pathId);
    textPath.setAttribute('xml:space', 'preserve');
    textPath.setAttribute('startOffset', '0px');
    animText.appendChild(textPath);
    svg.appendChild(animText);

    jacket.appendChild(svg);
    jacket.style.visibility = 'hidden';

    // ── Measure & init ───────────────────────────────────────────────────────
    // Must be in DOM before getComputedTextLength() works
    requestAnimationFrame(function () {
      const spacing = measureText.getComputedTextLength();
      if (!spacing) return;

      // Fill the visible width with repeated text
      const copies  = Math.ceil(1800 / spacing) + 2;
      const fullText = Array(copies).fill(text).join('');
      textPath.textContent = fullText;

      // Set initial offset
      let offset = -spacing;
      textPath.setAttribute('startOffset', offset + 'px');

      animText.style.visibility = 'visible';
      jacket.style.visibility   = 'visible';

      // ── Animation loop ───────────────────────────────────────────────────
      let dragging  = false;
      let lastX     = 0;
      let vel       = 0;
      let dir       = direction;
      let rafHandle = 0;

      function step() {
        if (!dragging) {
          const delta = dir === 'right' ? speed : -speed;
          offset += delta;
          if (offset <= -spacing) offset += spacing;
          if (offset > 0)         offset -= spacing;
          textPath.setAttribute('startOffset', offset + 'px');
        }
        rafHandle = requestAnimationFrame(step);
      }
      rafHandle = requestAnimationFrame(step);

      // ── Drag interaction ─────────────────────────────────────────────────
      if (interactive) {
        jacket.style.cursor = 'grab';

        jacket.addEventListener('pointerdown', function (e) {
          dragging = true;
          lastX    = e.clientX;
          vel      = 0;
          jacket.style.cursor = 'grabbing';
          jacket.setPointerCapture(e.pointerId);
        });

        jacket.addEventListener('pointermove', function (e) {
          if (!dragging) return;
          const dx = e.clientX - lastX;
          lastX    = e.clientX;
          vel      = dx;
          offset  += dx;
          if (offset <= -spacing) offset += spacing;
          if (offset > 0)         offset -= spacing;
          textPath.setAttribute('startOffset', offset + 'px');
        });

        function endDrag() {
          if (!dragging) return;
          dragging = false;
          jacket.style.cursor = 'grab';
          dir = vel > 0 ? 'right' : 'left';
        }
        jacket.addEventListener('pointerup',    endDrag);
        jacket.addEventListener('pointerleave', endDrag);
      }
    });
  }

  // Public API
  window.CurvedLoop = {
    initAll: function (selector) {
      var nodes = document.querySelectorAll(selector || '.curved-loop-jacket');
      nodes.forEach(initOne);
    },
    init: initOne
  };
})();
