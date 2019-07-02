class Dialog{
    constructor(){
        this.dialogs = document.querySelectorAll('.dialog-container')
        this.dialogButtons = document.querySelectorAll('[data-dialog]')
        this.dialogCloseButtons = document.querySelectorAll('.dialog-container .close')
    }

    dialogAvailable(){
        return this.dialogs.length > 0
    }

    start(){
        this.dialogButtons.forEach(function(button){
            button.addEventListener('click', function(e){
                console.log(button)
                e.preventDefault()
                var dialogBox = document.querySelector(button.dataset.dialog)
                dialogBox.classList.toggle('active')
            })
        }.bind(this))
        this.dialogCloseButtons.forEach(function(close){
            close.addEventListener('click', function (e) {
                e.preventDefault()
                close.closest('.dialog-container').classList.toggle('active')
            })
        }.bind(this))
        this.dialogs.forEach(function(dialog){
            dialog.addEventListener('click', function (e) {
                e.preventDefault()
                if (e.target.classList.contains('dialog-container')){
                    e.target.classList.toggle('active');
                }
            })
        }.bind(this))
    }
}
$(document).on('turbolinks:load', function () {
    let dialogs = new Dialog()
    if (dialogs.dialogAvailable()){
        dialogs.start()
    }
})