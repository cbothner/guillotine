$(document).ready ->
  $(document).on("change", ".semester_select", ->
     console.log($(this))
     semester = $(this).val()
     #if semester == "New Semester"
       #TODO New semester in JS
     window.location = "/#{$(this).attr('data-prefix')}#{semester}"
  )
