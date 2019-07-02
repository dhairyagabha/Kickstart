class Navbar{
    constructor(){
        this.drawer_toggle = document.querySelectorAll('.drawer-menu-toggle')
        this.drawer_obfuscator = document.querySelectorAll('.drawer-obfuscator')
    }

    navbarAvailable(){
        return this.drawer_toggle.length > 0;
    }

    start(){
        this.drawer_toggle.forEach(function(toggler){
            toggler.addEventListener('click', function(e){
                e.preventDefault();
                document.getElementById(toggler.dataset.menu).classList.toggle('active')
                document.getElementById(toggler.dataset.obfuscator).classList.toggle('active')
            })
        })
        this.drawer_obfuscator.forEach(function(obfuscator){
            obfuscator.addEventListener('click', function(e){
                e.preventDefault();
                document.getElementById(obfuscator.dataset.menu).classList.toggle('active')
                document.getElementById(obfuscator.dataset.obfuscator).classList.toggle('active')
            })
        })
    }
}
$(document).on('turbolinks:load', function () {
    let navbar = new Navbar()
    if (navbar.navbarAvailable()){
        navbar.start()
    }
})