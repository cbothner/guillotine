$(document).ready ->
  $(document).on("change", ".semester_select", ->
     console.log($(this))
     semester = $(this).val()
     if semester == "New Semester"
       semester = prompt("Name the new fundraising cycle in YYYY.MM format.", "")
     window.location = "/#{$(this).attr('data-prefix')}#{semester}"
  )
