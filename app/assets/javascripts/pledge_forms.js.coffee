# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#print-pledge-forms-all").click ->
    window.alert 'Be sure to print these double-sided!'
    printURL('/pledge_forms/all/');
