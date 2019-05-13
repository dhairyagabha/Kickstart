$(document).on('turbolinks:load', function () {
    $('.tabs-header [data-tab-toggle]').on('click', function (e) {
        $(this).closest('.tabs-header').find('a.active').removeClass('active');
        $(this).addClass('active');
        console.log( $(this).closest('.tabs'));
        console.log( $(this).closest('.tabs').find('.tabs-panel.active'));
        $(this).closest('.tabs').find('.tabs-panel.active').removeClass('active');
        $($(this).data('tab-toggle')).addClass('active');
        e.preventDefault();
    });
});