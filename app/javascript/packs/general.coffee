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

  # Toggle card search
  $('.card-menu .search').on 'click', (e) ->
    $(this).closest('.card').find('.card-table-search').toggleClass 'active'
    e.preventDefault()
    return

  # Reset card search
  $('.card-table-search .close-search').on 'click', (e) ->
    $(this).closest('input').reset()
    e.preventDefault()
    return