/* ============================================================
   O Capítulo Oculto — Scripts de interação
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {

  /* ── Scroll Animations (IntersectionObserver) ── */
  const animateElements = () => {
    const targets = document.querySelectorAll(
      '.section-header, .fact-card, .bible-quote, .layer-item, ' +
      '.method-step, .deliverable-item, .audience-card, .guarantee-card, ' +
      '.faq-item, .transparency-box, .definition-box, .sources-box, ' +
      '.emphasis-text, .price-block, .section-final-cta h2, .section-final-cta .final-lead'
    );

    targets.forEach(el => el.classList.add('animate-on-scroll'));

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    }, {
      threshold: 0.12,
      rootMargin: '0px 0px -40px 0px'
    });

    targets.forEach(el => observer.observe(el));
  };

  animateElements();

  /* ── Staggered animation for grid children ── */
  const staggerElements = (selector, delay = 80) => {
    const parent = document.querySelector(selector);
    if (!parent) return;
    const children = parent.children;
    Array.from(children).forEach((child, i) => {
      child.style.transitionDelay = `${i * delay}ms`;
    });
  };

  staggerElements('.facts-grid', 100);
  staggerElements('.method-steps', 120);
  staggerElements('.faq-list', 60);

  /* ── Pulse CTAs when visible ── */
  const ctaButtons = document.querySelectorAll('.cta-btn');
  const ctaObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('cta-pulse');
      } else {
        entry.target.classList.remove('cta-pulse');
      }
    });
  }, { threshold: 0.5 });

  ctaButtons.forEach(btn => ctaObserver.observe(btn));

  /* ── Smooth scroll for internal links ── */
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const targetId = this.getAttribute('href');
      if (targetId === '#' || targetId === '#LINK_CHECKOUT') return;
      e.preventDefault();
      const target = document.querySelector(targetId);
      if (target) {
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

  /* ── Meta Pixel: Track CTA clicks as InitiateCheckout ── */
  ctaButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      if (typeof fbq === 'function') {
        fbq('track', 'InitiateCheckout', {
          value: 37.00,
          currency: 'BRL',
          content_name: 'O Capítulo Oculto — Prosperidade'
        });
      }
    });
  });

  /* ── Topbar subtle hide on scroll down, show on scroll up ── */
  const topbar = document.getElementById('topbar');
  let lastScrollY = 0;

  window.addEventListener('scroll', () => {
    const currentY = window.scrollY;
    if (currentY > 200 && currentY > lastScrollY) {
      topbar.style.transform = 'translateY(-100%)';
      topbar.style.transition = 'transform 0.3s ease';
    } else {
      topbar.style.transform = 'translateY(0)';
    }
    lastScrollY = currentY;
  }, { passive: true });

});
