var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-7384499-4']);
_gaq.push(['_trackPageview']);

(function () {
    var ga = document.createElement('script');
    ga.type = 'text/javascript';
    ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(ga, s);
})();

$(document).ready(function () {
    $(".login").click(function (e) {
        e.preventDefault();
        $("#sign_in").toggle();
        $(".login").toggleClass("menu-open");
    });
    $("fieldset#signin_menu").mouseup(function () {
        return false
    });
    $("#change-location-trigger").click(function (e) {
        e.preventDefault();
        $("#change_location").toggle();
        $("#change-location-trigger").toggleClass("menu-open");
    });
    $("fieldset#signin_menu").mouseup(function () {
        return false
    });
    $(document).mouseup(function (e) {
        if ($(e.target).parents("#sign_in").length == 0) {
            $(".login").removeClass("menu-open");
            $("#sign_in").hide();
        }
        if ($(e.target).parents("#change_location").length == 0 && !$(e.target).is("#change_location")) {
            $("#change-location-trigger").removeClass("menu-open");
            $("#change_location").hide();
        }
        if ($(e.target).parents("#myAccount").length == 0) {
            $("#myAccount").removeClass("hover");
        }
    });
    $("#change_location_hide").click(function () {
        $("#change-location-trigger").removeClass("menu-open");
        $("#change_location").hide();
        return false;
    });
    $("#myAccount a.menu").click(function () {
        $("#myAccount").addClass("hover");
        return false;
    });
});