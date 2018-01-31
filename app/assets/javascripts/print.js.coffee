# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Requires valid source url
# Pulls up browser's print GUI for that page
window.printURL = (url) ->
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
  x.src = url
  x.onload = setPrint
  document.body.appendChild x
