# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
`var nextBtn = document.getElementById('next-week-button');
var prevBtn = document.getElementById('previous-week-button');
nextBtn.addEventListener('click', function() {
  $('#current-week-calendar').hide();
  $('#next-week-calendar').show();
  nextBtn.hide();
});
prevBtn.addEventListener('click', function() {
  $('#next-week-calendar').hide();
  $('#current-week-calendar').show();
  prevBtn.hide();
});`