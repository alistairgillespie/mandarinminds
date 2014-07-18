# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

source = new EventSource('/plans')

source.addEventListener 'notification', (e) ->
  notification = $.parseJSON(e.data).notification
  $('#notification-list').append($('<li>').text("#{notification.image} #{notification.content}"))

