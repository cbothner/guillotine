# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#print-gpo-all").click ->
    window.alert 'Be sure to print these single-sided!'
    printURL('/gpo/all/');
