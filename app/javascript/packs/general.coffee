$(document).on 'turbolinks:load', ->

#  Dismiss elements
  $('[data-dismiss]').on 'click', (e) ->
    $(this).closest($(this).data('dismiss')).remove()
    e.preventDefault()
    return

#  Toggle class active for dropdowns
  $('[data-toggle]').on 'click', (e) ->
    $(this).parent().find($(this).data('toggle')).toggleClass 'active'
    e.preventDefault()
    return