$(document).on('turbolinks:load', function () {
    // $('[data-dismiss]').on('click', function (e) {
    //     $(this).closest($(this).data('dismiss')).remove();
    //     e.preventDefault();
    // });
    $('.dropdown [data-toggle]').on('click', function (e) {
        $(this).parent().find($(this).data('toggle')).toggleClass('active');
        e.preventDefault();
    });
    $('.card-menu .search').on('click', function (e) {
        $(this).closest('.card').find('.card-table-search').toggleClass('active');
        e.preventDefault();
    });
    $('.card-table-search .close-search').on('click', function (e) {
        $(this).closest('input').reset();
        e.preventDefault();
    });
    $('.mobile-toggle').on('click', function (e) {
        menu = $(this).parent().find('ul:first');
        console.log(menu);
        menu.toggleClass('mobile-menu');
        e.preventDefault();
    });
    // $('.drawer-menu-toggle, .drawer-obfuscator').on('click', function(e){
    //    $('.drawer-menu').toggleClass('active');
    //    $('.drawer-obfuscator').toggleClass('active');
    //     e.preventDefault();
    // });
});