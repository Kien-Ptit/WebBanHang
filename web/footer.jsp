<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css?v=1"/>

<footer class="fs-footer">
  <div class="fs-container">

    <div class="fs-cols">
      <!-- Cột thương hiệu -->
      <section class="fs-col fs-brand">
        <h5 class="fs-title">
          <!-- Icon áo -->
          <svg class="fs-icon" viewBox="0 0 24 24" aria-hidden="true">
            <path fill="currentColor" d="M16.5 3l3.5 2 2 4-3 2v8a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V11L2 9l2-4 3.5-2A6 6 0 0 0 9 6h6a6 6 0 0 0 1.5-3z"/>
          </svg>
          Kien Store
        </h5>
        <p class="fs-desc">
          Chuyên cung cấp thời trang cao cấp với phong cách hiện đại và chất lượng tốt nhất.
        </p>
        <div class="fs-social">
            <a href="https://www.facebook.com/XuanKienIT.2004" aria-label="Facebook" class="fs-social-btn" target="_blank">
            <svg viewBox="0 0 24 24"><path fill="currentColor" d="M22 12a10 10 0 1 0-11.5 9.9v-7H7.9V12h2.6V9.8c0-2.6 1.5-4 3.8-4 1.1 0 2.2.2 2.2.2v2.4h-1.2c-1.2 0-1.6.8-1.6 1.6V12h2.8l-.45 2.9h-2.35v7A10 10 0 0 0 22 12z"/></svg>
          </a>
          <a href="https://www.instagram.com/dokienhihi/" aria-label="Instagram" class="fs-social-btn" target="_blank">
            <svg viewBox="0 0 24 24"><path fill="currentColor" d="M7 2h10a5 5 0 0 1 5 5v10a5 5 0 0 1-5 5H7a5 5 0 0 1-5-5V7a5 5 0 0 1 5-5m0 2a3 3 0 0 0-3 3v10a3 3 0 0 0 3 3h10a3 3 0 0 0 3-3V7a3 3 0 0 0-3-3H7m5 3.8a5.2 5.2 0 1 1 0 10.4 5.2 5.2 0 0 1 0-10.4m0 2a3.2 3.2 0 1 0 0 6.4 3.2 3.2 0 0 0 0-6.4M18 6.3a1.1 1.1 0 1 1 0 2.2 1.1 1.1 0 0 1 0-2.2z"/></svg>
          </a>
          <a href="https://x.com/BanhBao_0804" aria-label="Twitter" class="fs-social-btn" target="_blank">
            <svg viewBox="0 0 24 24"><path fill="currentColor" d="M22 5.9c-.7.3-1.5.6-2.3.7.8-.5 1.4-1.2 1.7-2.1-.8.5-1.7.9-2.6 1.1A4 4 0 0 0 12 8.6c0 .3 0 .6.1.8-3.3-.2-6.3-1.8-8.3-4.2a4 4 0 0 0 .6 5.4c-.6 0-1.2-.2-1.7-.5v.1c0 2 1.4 3.7 3.3 4.1-.3.1-.7.1-1 .1-.2 0-.5 0-.7-.1a4 4 0 0 0 3.8 2.8A8 8 0 0 1 2 19.5c-.3 0-.6 0-.9-.1A11.3 11.3 0 0 0 7.1 21c7.2 0 11.2-6 11.2-11.2v-.5c.8-.6 1.4-1.3 1.7-2.1z"/></svg>
          </a>
          <a href="https://www.youtube.com/@kieno4902" aria-label="YouTube" class="fs-social-btn" target="_blank">
            <svg viewBox="0 0 24 24"><path fill="currentColor" d="M10 15l5.2-3L10 9v6m12-3a9 9 0 0 1-1 4c-.5 1-1 1.6-2 1.8-1.8.5-9 .5-9 .5s-7.2 0-9-.5c-1-.2-1.6-.8-2-1.8A9 9 0 0 1 0 12a9 9 0 0 1 1-4c.5-1 1-1.6 2-1.8C4.8 5.7 12 5.7 12 5.7s7.2 0 9 .5c1 .2 1.6.8 2 1.8a9 9 0 0 1 1 4z"/></svg>
          </a>
        </div>
      </section>

      <!-- Cột liên kết -->
      <section class="fs-col">
        <h6 class="fs-heading">Liên kết</h6>
        <ul class="fs-links">
          <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
          <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
          <li><a href="${pageContext.request.contextPath}/about">Về chúng tôi</a></li>
          <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
        </ul>
      </section>

      <!-- Cột hỗ trợ -->
      <section class="fs-col">
        <h6 class="fs-heading">Hỗ trợ</h6>
        <ul class="fs-links">
          <li><a href="#">Hướng dẫn mua hàng</a></li>
          <li><a href="#">Chính sách đổi trả</a></li>
          <li><a href="#">Bảo hành</a></li>
          <li><a href="#">FAQ</a></li>
        </ul>
      </section>

      <!-- Cột liên hệ -->
      <section class="fs-col">
        <h6 class="fs-heading">Liên hệ</h6>
        <ul class="fs-contact">
          <li><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C8.1 2 5 5.1 5 9c0 5.2 7 13 7 13s7-7.8 7-13c0-3.9-3.1-7-7-7zm0 9.5a2.5 2.5 0 1 1 0-5 2.5 2.5 0 0 1 0 5z"/></svg>số 3, Ngách 15, Ngõ 254, Vĩnh Hưng, Hoàng Mai, Hà Nội</li>
          <li><svg viewBox="0 0 24 24"><path fill="currentColor" d="M6.6 10.8a15.5 15.5 0 0 0 6.6 6.6l2.2-2.2c.3-.3.7-.4 1.1-.3 1.2.4 2.6.6 4 .6.6 0 1 .4 1 1V21c0 .6-.4 1-1 1C10.4 22 2 13.6 2 3c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.4.2 2.8.6 4 .1.4 0 .8-.3 1.1l-2.2 2.2z"/></svg>1900 123 456</li>
          <li><svg viewBox="0 0 24 24"><path fill="currentColor" d="M22 6v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6l10 7L22 6zM20 4H4l8 5 8-5z"/></svg>http://localhost:9999/banquanao/</li>
          <li><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 7a5 5 0 0 1 5 5h2a7 7 0 1 0-7 7v-2a5 5 0 1 1 0-10z"/></svg>8:00 - 22:00 (Thứ 2 - CN)</li>
        </ul>
      </section>
    </div>

    <hr class="fs-divider"/>

    <div class="fs-bottom">
      <p>© 2024 Kien Store. Tất cả quyền được bảo lưu.</p>
      <div class="fs-bottom-links">
        <a href="#">Điều khoản sử dụng</a>
        <a href="#">Chính sách bảo mật</a>
      </div>
    </div>
  </div>
</footer>

<!-- Back to top -->
<button type="button" class="fs-backtop" id="fsBackTop" aria-label="Lên đầu trang" hidden>
  <svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M12 8l-6 6h12z"/></svg>
</button>

<script>
(function(){
  const btn = document.getElementById('fsBackTop');
  function onScroll(){
    if (window.scrollY > 300) btn.hidden = false; else btn.hidden = true;
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
  btn.addEventListener('click', function(){
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
})();
</script>
