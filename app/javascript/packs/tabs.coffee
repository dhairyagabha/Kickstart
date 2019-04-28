$(document).on 'turbolinks:load', ->

  $('.tabs-header [data-tab-toggle]').on 'click', (e) ->
    $(this).closest('.tabs-header').find('a.active').removeClass('active')
    $(this).addClass('active')
    $(this).closest('.tabs').find('.tabs-panels>.tabs-panel.active').removeClass('active')
    $($(this).data('tab-toggle')).toggleClass 'active'
    e.preventDefault()
    return