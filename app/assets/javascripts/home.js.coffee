# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#TODO stop printing second blank page
print_blank_cc_gpo = ->

  x = document.createElement('iframe')

  closePrint = ->
    document.body.removeChild @__container__
    return

  setPrint = ->
    @contentWindow.__container__ = this
    @contentWindow.onbeforeunload = closePrint
    @contentWindow.onafterprint = closePrint
    @contentWindow.focus() # Required for IE
    @contentWindow.print()
    return

  x.style.visibility = 'hidden'
  x.style.position = 'fixed'
  x.style.right = '0'
  x.style.bottom = '0'
  x.style.width = '8.5in'
  x.style.height = '11in'
  x.src = '/credit_card_forms/new'
  x.onload = setPrint
  document.body.appendChild x


#DRIVER
$ ->
  $("#blank-cc-gpo").click(print_blank_cc_gpo)
