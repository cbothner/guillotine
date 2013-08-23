$(document).ready ->
  window.rewardComments = []
  
  comments = $(".reward-comment")
  for comment, i in comments
    if $(comment).contents().length != 0
      window.rewardComments[i] = $(comment).replaceWith "<td class='reward-comment-hidden' data-id='#{i}'>!</td>"

  $(document).on "click", ".reward-comment-hidden", ->
    alert window.rewardComments[ $(this).attr("data-id") ].text()
