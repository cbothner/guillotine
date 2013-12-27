$(document).ready ->
  $(".chzn-select").chosen()
  $(".chzn-select").trigger("liszt:updated")

  $(document).on("change", ".semester_select", ->
    semester = $(".semester_select").val()
    if semester == "New Semester"
      semester = prompt("Name the new fundraising cycle in YYYY.MM format.", "")
    window.location = "/slots/#{semester}"
  )
