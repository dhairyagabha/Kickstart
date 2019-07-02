class Alert{
    constructor(){
        this.alerts = document.querySelectorAll('.alert')
        this.closeAlerts = document.querySelectorAll('.alert > .close')
    }

    alertsAvailable(){
        return this.alerts.length > 0;
    }

    start(){
        this.alerts.forEach(function(alert){
            if(alert.dataset.duration != undefined){
                setTimeout(function(){
                    alert.remove()
                }, alert.dataset.duration);
            }
        }.bind(this))
        this.closeAlerts.forEach(function(close){
            close.addEventListener('click', function(e){
                console.log(close)
                e.preventDefault()
                close.closest('.alert').remove()
            })
        }.bind(this))
    }
}
$(document).on('turbolinks:load', function () {
    let alerts = new Alert()
    if (alerts.alertsAvailable()){
        alerts.start()
    }
})