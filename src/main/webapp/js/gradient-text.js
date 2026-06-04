/**
 * GradientText — Pure JS port of the React Bits GradientText component.
 * Animates text with a moving gradient background clip, optionally displaying a moving gradient border.
 *
 * Usage:
 *   <div class="animated-gradient-text" data-colors="['#40ffaa', '#4079ff', '#40ffaa']" data-speed="3" data-border="true">
 *     Add a splash of color!
 *   </div>
 *
 *   Then call: GradientText.initAll();
 */

(function () {
  'use strict';

  function initOne(el) {
    if (el._gradientInitialized) return;
    el._gradientInitialized = true;

    // Parse attributes
    let colors = ['#5227FF', '#FF9FFC', '#B497CF'];
    const colorsAttr = el.getAttribute('data-colors');
    if (colorsAttr) {
      try {
        // Handle single quote formatting in data attributes
        colors = JSON.parse(colorsAttr.replace(/'/g, '"'));
      } catch (e) {
        console.error('Failed to parse colors data attribute on GradientText:', colorsAttr, e);
      }
    }

    const animationSpeed = parseFloat(el.getAttribute('data-speed') || 8);
    const showBorder = el.getAttribute('data-border') === 'true';
    const direction = el.getAttribute('data-direction') || 'horizontal';
    const pauseOnHover = el.getAttribute('data-pause-hover') === 'true';
    const yoyo = el.getAttribute('data-yoyo') !== 'false';

    const animationDuration = animationSpeed * 1000;
    let isPaused = false;
    let elapsed = 0;
    let lastTime = null;
    let progress = 0;
    let rafHandle = null;

    // Prepare children structure
    const originalContent = el.innerHTML;
    el.innerHTML = '';

    const textContent = document.createElement('div');
    textContent.className = 'text-content';
    textContent.innerHTML = originalContent;

    let overlay = null;
    if (showBorder) {
      el.classList.add('with-border');
      overlay = document.createElement('div');
      overlay.className = 'gradient-overlay';
      el.appendChild(overlay);
    }
    el.appendChild(textContent);

    // Gradient Setup
    const gradientAngle =
      direction === 'horizontal' ? 'to right' : direction === 'vertical' ? 'to bottom' : 'to bottom right';
    // Duplicate first color at the end for seamless looping
    const gradientColors = [...colors, colors[0]].join(', ');

    const gradientStyle = {
      backgroundImage: `linear-gradient(${gradientAngle}, ${gradientColors})`,
      backgroundSize: direction === 'horizontal' ? '300% 100%' : direction === 'vertical' ? '100% 300%' : '300% 300%',
      backgroundRepeat: 'repeat'
    };

    // Apply styles to elements
    Object.assign(textContent.style, gradientStyle);
    if (overlay) {
      Object.assign(overlay.style, gradientStyle);
    }

    function updatePosition(p) {
      let pos;
      if (direction === 'horizontal') {
        pos = `${p}% 50%`;
      } else if (direction === 'vertical') {
        pos = `50% ${p}%`;
      } else {
        // Diagonal: move horizontally
        pos = `${p}% 50%`;
      }
      textContent.style.backgroundPosition = pos;
      if (overlay) {
        overlay.style.backgroundPosition = pos;
      }
    }

    // Animation Loop
    function animate(time) {
      if (isPaused) {
        lastTime = null;
        rafHandle = requestAnimationFrame(animate);
        return;
      }

      if (lastTime === null) {
        lastTime = time;
        rafHandle = requestAnimationFrame(animate);
        return;
      }

      const deltaTime = time - lastTime;
      lastTime = time;
      elapsed += deltaTime;

      if (yoyo) {
        const fullCycle = animationDuration * 2;
        const cycleTime = elapsed % fullCycle;

        if (cycleTime < animationDuration) {
          progress = (cycleTime / animationDuration) * 100;
        } else {
          progress = 100 - ((cycleTime - animationDuration) / animationDuration) * 100;
        }
      } else {
        progress = (elapsed / animationDuration) * 100;
      }

      updatePosition(progress);
      rafHandle = requestAnimationFrame(animate);
    }

    // Event Listeners for pause on hover
    if (pauseOnHover) {
      el.addEventListener('mouseenter', function () {
        isPaused = true;
      });
      el.addEventListener('mouseleave', function () {
        isPaused = false;
      });
    }

    rafHandle = requestAnimationFrame(animate);

    // Destructor
    el._destroyGradient = function () {
      if (rafHandle) {
        cancelAnimationFrame(rafHandle);
      }
    };
  }

  window.GradientText = {
    initAll: function (selector) {
      const nodes = document.querySelectorAll(selector || '.animated-gradient-text');
      nodes.forEach(initOne);
    },
    init: initOne
  };
})();
