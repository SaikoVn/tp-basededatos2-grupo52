(function () {
    var actual = window.location.pathname.split("/").pop().toLowerCase();
    document.querySelectorAll("header nav a").forEach(function (link) {
        var destino = new URL(link.href, window.location.href).pathname.split("/").pop().toLowerCase();
        if (destino === actual) {
            link.classList.add("actual");
            link.setAttribute("aria-current", "page");
        }
    });
}());