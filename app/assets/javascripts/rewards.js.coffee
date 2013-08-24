$(document).ready ->
  window.rewardComments = []

  comments = $(".reward-comment")
  for comment, i in comments
    if $(comment).contents().length != 0
      window.rewardComments[i] = $(comment).replaceWith "<td class='reward-comment-hidden' data-id='#{i}'>!</td>"

  $(document).on "click", ".reward-comment-hidden", ->
    alert window.rewardComments[ $(this).attr("data-id") ].text()

  tables = $(".reward-table")
  for table, i in tables
    $(table).children("table").css("display","none")
    $(table).children("h4").addClass("reward-table-header-hidden")

  $(document).on "click", ".reward-table-header-hidden", ->
    $(this).siblings("table").css("display","inherit")
    $(this).addClass("reward-table-header-visible")
    $(this).removeClass("reward-table-header-hidden")

  $(document).on "click", ".reward-table-header-visible", ->
    $(this).siblings("table").css("display","none")
    $(this).removeClass("reward-table-header-visible")
    $(this).addClass("reward-table-header-hidden")
