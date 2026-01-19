$(function () {
  const $sidebar = $(".sidebar");
  const $overlay = $("#sidebarOverlay");
  const $btn = $("#btnSidebarToggle");

  function openSidebar() {
    $sidebar.addClass("open");
    $overlay.addClass("show");
    $("body").addClass("sidebar-open"); // 스크롤 방지용
  }

  function closeSidebar() {
    $sidebar.removeClass("open");
    $overlay.removeClass("show");
    $("body").removeClass("sidebar-open");
  }

  $btn.on("click", function (e) {
    e.preventDefault();
    if ($sidebar.hasClass("open")) closeSidebar();
    else openSidebar();
  });

  $overlay.on("click", closeSidebar);

  // 메뉴 클릭하면 자동 닫힘
  $(document).on("click", ".sidebar .sidebar-menu-link", function () {
    if (window.matchMedia("(max-width: 991.98px)").matches) {
      closeSidebar();
    }
  });

  // PC로 넘어가면 강제 닫기
  $(window).on("resize", function () {
    if (!window.matchMedia("(max-width: 991.98px)").matches) {
      closeSidebar();
    }
  });
});
