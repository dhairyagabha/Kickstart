$(document).on('turbolinks:load', function () {
    $('[data-dialog]').on('click', function (e) {
        $($(this).data('dialog')).toggleClass('active');
        e.preventDefault();
    });
    $('.dialog-container .close').on('click', function(e){
        $(this).closest('.dialog-container').toggleClass('active');
        e.preventDefault();
    });
    $('.dialog-container').on('click', function(e){
        if (e.target.classList.contains('dialog-container')){
            e.target.classList.remove('active');
        }
        e.preventDefault();
    });
});