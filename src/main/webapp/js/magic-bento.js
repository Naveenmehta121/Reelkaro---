/**
 * MagicBento — Pure JS port of the React Bits MagicBento component using GSAP.
 * Fully interactive bento grid with mouse spotlight, 3D tilt, magnetism, star particles, and click ripple.
 *
 * Requirements: GSAP library loaded via CDN.
 */

(function () {
  'use strict';

  const DEFAULT_PARTICLE_COUNT = 12;
  const DEFAULT_SPOTLIGHT_RADIUS = 300;
  const DEFAULT_GLOW_COLOR = '132, 0, 255'; // RGB
  const MOBILE_BREAKPOINT = 768;

  function createParticleElement(x, y, color) {
    const el = document.createElement('div');
    el.className = 'particle';
    el.style.cssText = `
      position: absolute;
      width: 4px;
      height: 4px;
      border-radius: 50%;
      background: rgba(${color}, 1);
      box-shadow: 0 0 6px rgba(${color}, 0.6);
      pointer-events: none;
      z-index: 100;
      left: ${x}px;
      top: ${y}px;
    `;
    return el;
  }

  function calculateSpotlightValues(radius) {
    return {
      proximity: radius * 0.5,
      fadeDistance: radius * 0.75
    };
  }

  function updateCardGlowProperties(card, mouseX, mouseY, glow, radius) {
    const rect = card.getBoundingClientRect();
    const relativeX = ((mouseX - rect.left) / rect.width) * 100;
    const relativeY = ((mouseY - rect.top) / rect.height) * 100;

    card.style.setProperty('--glow-x', `${relativeX}%`);
    card.style.setProperty('--glow-y', `${relativeY}%`);
    card.style.setProperty('--glow-intensity', glow.toString());
    card.style.setProperty('--glow-radius', `${radius}px`);
  }

  function initCard(card, config) {
    if (card._bentoInitialized) return;
    card._bentoInitialized = true;

    const {
      enableStars,
      enableTilt,
      enableMagnetism,
      clickEffect,
      particleCount,
      glowColor,
      disableAnimations
    } = config;

    if (disableAnimations) return;

    let particles = [];
    let timeouts = [];
    let isHovered = false;
    let memoizedParticles = [];
    let particlesInitialized = false;
    let magnetismTween = null;

    function initializeParticles() {
      if (particlesInitialized) return;
      const rect = card.getBoundingClientRect();
      for (let i = 0; i < particleCount; i++) {
        memoizedParticles.push(
          createParticleElement(Math.random() * rect.width, Math.random() * rect.height, glowColor)
        );
      }
      particlesInitialized = true;
    }

    function clearAllParticles() {
      timeouts.forEach(clearTimeout);
      timeouts = [];
      if (magnetismTween) magnetismTween.kill();

      particles.forEach(p => {
        if (window.gsap) {
          window.gsap.to(p, {
            scale: 0,
            opacity: 0,
            duration: 0.3,
            ease: 'back.in(1.7)',
            onComplete: () => {
              if (p.parentNode) p.parentNode.removeChild(p);
            }
          });
        } else {
          p.remove();
        }
      });
      particles = [];
    }

    function animateParticles() {
      if (!isHovered) return;
      if (!particlesInitialized) initializeParticles();

      memoizedParticles.forEach((particle, index) => {
        const timeoutId = setTimeout(() => {
          if (!isHovered) return;

          const clone = particle.cloneNode(true);
          card.appendChild(clone);
          particles.push(clone);

          if (window.gsap) {
            window.gsap.fromTo(clone, { scale: 0, opacity: 0 }, { scale: 1, opacity: 1, duration: 0.3, ease: 'back.out(1.7)' });

            window.gsap.to(clone, {
              x: (Math.random() - 0.5) * 100,
              y: (Math.random() - 0.5) * 100,
              rotation: Math.random() * 360,
              duration: 2 + Math.random() * 2,
              ease: 'none',
              repeat: -1,
              yoyo: true
            });

            window.gsap.to(clone, {
              opacity: 0.3,
              duration: 1.5,
              ease: 'power2.inOut',
              repeat: -1,
              yoyo: true
            });
          }
        }, index * 100);

        timeouts.push(timeoutId);
      });
    }

    card.addEventListener('mouseenter', () => {
      isHovered = true;
      if (enableStars) animateParticles();

      if (enableTilt && window.gsap) {
        window.gsap.to(card, {
          rotateX: 5,
          rotateY: 5,
          duration: 0.3,
          ease: 'power2.out',
          transformPerspective: 1000
        });
      }
    });

    card.addEventListener('mouseleave', () => {
      isHovered = false;
      if (enableStars) clearAllParticles();

      if (enableTilt && window.gsap) {
        window.gsap.to(card, {
          rotateX: 0,
          rotateY: 0,
          duration: 0.3,
          ease: 'power2.out'
        });
      }

      if (enableMagnetism && window.gsap) {
        window.gsap.to(card, {
          x: 0,
          y: 0,
          duration: 0.3,
          ease: 'power2.out'
        });
      }
    });

    card.addEventListener('mousemove', (e) => {
      if (!enableTilt && !enableMagnetism) return;

      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      const centerX = rect.width / 2;
      const centerY = rect.height / 2;

      if (enableTilt && window.gsap) {
        const rotateX = ((y - centerY) / centerY) * -10;
        const rotateY = ((x - centerX) / centerX) * 10;

        window.gsap.to(card, {
          rotateX,
          rotateY,
          duration: 0.1,
          ease: 'power2.out',
          transformPerspective: 1000
        });
      }

      if (enableMagnetism && window.gsap) {
        const magnetX = (x - centerX) * 0.05;
        const magnetY = (y - centerY) * 0.05;

        magnetismTween = window.gsap.to(card, {
          x: magnetX,
          y: magnetY,
          duration: 0.3,
          ease: 'power2.out'
        });
      }
    });

    card.addEventListener('click', (e) => {
      if (!clickEffect) return;

      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const maxDistance = Math.max(
        Math.hypot(x, y),
        Math.hypot(x - rect.width, y),
        Math.hypot(x, y - rect.height),
        Math.hypot(x - rect.width, y - rect.height)
      );

      const ripple = document.createElement('div');
      ripple.style.cssText = `
        position: absolute;
        width: ${maxDistance * 2}px;
        height: ${maxDistance * 2}px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(${glowColor}, 0.4) 0%, rgba(${glowColor}, 0.2) 30%, transparent 70%);
        left: ${x - maxDistance}px;
        top: ${y - maxDistance}px;
        pointer-events: none;
        z-index: 1000;
      `;

      card.appendChild(ripple);

      if (window.gsap) {
        window.gsap.fromTo(
          ripple,
          { scale: 0, opacity: 1 },
          {
            scale: 1,
            opacity: 0,
            duration: 0.8,
            ease: 'power2.out',
            onComplete: () => ripple.remove()
          }
        );
      } else {
        setTimeout(() => ripple.remove(), 800);
      }
    });
  }

  function initSection(section) {
    if (section._bentoInitialized) return;
    section._bentoInitialized = true;

    // Read general parameters
    const textAutoHide = section.dataset.textAutoHide !== 'false';
    const enableStars = section.dataset.enableStars !== 'false';
    const enableSpotlight = section.dataset.enableSpotlight !== 'false';
    const enableBorderGlow = section.dataset.enableBorderGlow !== 'false';
    const enableTilt = section.dataset.enableTilt === 'true';
    const enableMagnetism = section.dataset.enableMagnetism !== 'false';
    const clickEffect = section.dataset.clickEffect !== 'false';
    const spotlightRadius = parseInt(section.dataset.spotlightRadius || DEFAULT_SPOTLIGHT_RADIUS);
    const particleCount = parseInt(section.dataset.particleCount || DEFAULT_PARTICLE_COUNT);
    const glowColor = section.dataset.glowColor || DEFAULT_GLOW_COLOR;

    const isMobile = window.innerWidth <= MOBILE_BREAKPOINT;
    const disableAnimations = section.dataset.disableAnimations === 'true' || isMobile;

    const config = {
      textAutoHide,
      enableStars,
      enableSpotlight,
      enableBorderGlow,
      enableTilt,
      enableMagnetism,
      clickEffect,
      spotlightRadius,
      particleCount,
      glowColor,
      disableAnimations
    };

    // Apply config colors/classes to cards
    const cards = section.querySelectorAll('.magic-bento-card');
    cards.forEach(card => {
      card.style.setProperty('--glow-color', glowColor);
      if (enableBorderGlow) {
        card.classList.add('magic-bento-card--border-glow');
      }
      if (textAutoHide) {
        card.classList.add('magic-bento-card--text-autohide');
      }
      initCard(card, config);
    });

    // Global Spotlight setup
    if (enableSpotlight && !disableAnimations) {
      let spotlight = document.createElement('div');
      spotlight.className = 'global-spotlight';
      spotlight.style.cssText = `
        position: fixed;
        width: 800px;
        height: 800px;
        border-radius: 50%;
        pointer-events: none;
        background: radial-gradient(circle,
          rgba(${glowColor}, 0.15) 0%,
          rgba(${glowColor}, 0.08) 15%,
          rgba(${glowColor}, 0.04) 25%,
          rgba(${glowColor}, 0.02) 40%,
          rgba(${glowColor}, 0.01) 65%,
          transparent 70%
        );
        z-index: 200;
        opacity: 0;
        transform: translate(-50%, -50%);
        mix-blend-mode: screen;
      `;
      document.body.appendChild(spotlight);

      let isInsideSection = false;

      const handleMouseMove = (e) => {
        const rect = section.getBoundingClientRect();
        const mouseInside =
          e.clientX >= rect.left && e.clientX <= rect.right && e.clientY >= rect.top && e.clientY <= rect.bottom;

        isInsideSection = mouseInside;

        if (!mouseInside) {
          if (window.gsap) {
            window.gsap.to(spotlight, { opacity: 0, duration: 0.3, ease: 'power2.out' });
          } else {
            spotlight.style.opacity = '0';
          }
          cards.forEach(card => {
            card.style.setProperty('--glow-intensity', '0');
          });
          return;
        }

        const { proximity, fadeDistance } = calculateSpotlightValues(spotlightRadius);
        let minDistance = Infinity;

        cards.forEach(card => {
          const cardRect = card.getBoundingClientRect();
          const centerX = cardRect.left + cardRect.width / 2;
          const centerY = cardRect.top + cardRect.height / 2;
          const distance =
            Math.hypot(e.clientX - centerX, e.clientY - centerY) - Math.max(cardRect.width, cardRect.height) / 2;
          const effectiveDistance = Math.max(0, distance);

          minDistance = Math.min(minDistance, effectiveDistance);

          let glowIntensity = 0;
          if (effectiveDistance <= proximity) {
            glowIntensity = 1;
          } else if (effectiveDistance <= fadeDistance) {
            glowIntensity = (fadeDistance - effectiveDistance) / (fadeDistance - proximity);
          }

          updateCardGlowProperties(card, e.clientX, e.clientY, glowIntensity, spotlightRadius);
        });

        if (window.gsap) {
          window.gsap.to(spotlight, {
            left: e.clientX,
            top: e.clientY,
            duration: 0.1,
            ease: 'power2.out'
          });
        } else {
          spotlight.style.left = `${e.clientX}px`;
          spotlight.style.top = `${e.clientY}px`;
        }

        const targetOpacity =
          minDistance <= proximity
            ? 0.8
            : minDistance <= fadeDistance
              ? ((fadeDistance - minDistance) / (fadeDistance - proximity)) * 0.8
              : 0;

        if (window.gsap) {
          window.gsap.to(spotlight, {
            opacity: targetOpacity,
            duration: targetOpacity > 0 ? 0.2 : 0.5,
            ease: 'power2.out'
          });
        } else {
          spotlight.style.opacity = targetOpacity.toString();
        }
      };

      const handleMouseLeave = () => {
        isInsideSection = false;
        cards.forEach(card => {
          card.style.setProperty('--glow-intensity', '0');
        });
        if (window.gsap) {
          window.gsap.to(spotlight, { opacity: 0, duration: 0.3, ease: 'power2.out' });
        } else {
          spotlight.style.opacity = '0';
        }
      };

      document.addEventListener('mousemove', handleMouseMove);
      document.addEventListener('mouseleave', handleMouseLeave);

      section._cleanupBentoSpotlight = () => {
        document.removeEventListener('mousemove', handleMouseMove);
        document.removeEventListener('mouseleave', handleMouseLeave);
        if (spotlight.parentNode) spotlight.parentNode.removeChild(spotlight);
      };
    }
  }

  window.MagicBento = {
    initAll: function (selector) {
      const nodes = document.querySelectorAll(selector || '.bento-section');
      nodes.forEach(initSection);
    }
  };
})();
