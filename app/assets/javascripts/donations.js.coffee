# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

print_single_gpo = ->

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

  url = window.location.href
  last = url[url.length - 1]
  penultimate = url[url.length - 2]
  pledger_id = if last == '#' then penultimate else last

  x.src =  '/gpo/single/' + pledger_id
  x.onload = setPrint
  document.body.appendChild x


#DRIVER
$ ->
  $("#print-single-gpo").click(print_single_gpo)
