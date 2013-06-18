$(document).ready ->
  window.openDonationLine = []
  window.openRewardLine = []

  $("#namesearch")
    .autocomplete( source: (request, response) ->
      $.getJSON '/pledgers/search.json', {name: request.term}, (results) ->
        names = []
        # Search results
        for result in results
          names.push
            id: result.id
            value: result.name
            desc: "<br />#{result.perm_address}"
        # Permanently at the bottom: new pledger
        names.push
          id: "new"
          value: "New Pledger"
          desc: ""
        response names # Callback an array of values.
        return false
    select: (event, ui) ->
      window.location = "/pledgers/#{ui.item.id}"
    )
    .data("ui-autocomplete")._renderItem = (ul,item) ->
      $("<li>")
        .append("<a style=\"line-height:1.3\">#{item.value}<span style=\"font-size: 11px; margin-left: 1em;\">#{item.desc}</span></a>")
        .appendTo(ul)

  $(document).on("click", "#pledgerFormCancelButton", ->
    window.location = "/pledgers"
  )

  $(document).on("click",".clickable.donationLine", ->
    window.openDonationLine[String($(this).attr('data-id'))] = $(this)
    if $(this).attr('data-id') != 'new'
      editOrNot = "/edit"
    else
      editOrNot = ""
    $(this).replaceWith($('<div class="donationForm donationLine">').load("/donations/#{$(this).attr('data-id')}#{editOrNot}", ->
      $(".chzn-select").chosen()
      $(".chzn-select").trigger("liszt:updated")
      $("#donation_pledger_id").val($("#pledgerID").attr("data-id"))
    ))
  )

  $(document).on("click","#donationFormCancelButton", ->
    donationID = $(this).attr("data-id")
    $(this).parents(".donationForm").replaceWith(window.openDonationLine[String(donationID)])
    window.openDonationLine[String(donationID)] = null
  )

  $(document).on("click",".clickable.rewardLine", ->
    window.openRewardLine[String($(this).attr('data-id'))] = $(this)
    if $(this).attr('data-id') != 'new'
      editOrNot = "/edit"
    else
      editOrNot = ""
    $(this).replaceWith($('<div class="rewardForm rewardLine">').load("/rewards/#{$(this).attr('data-id')}#{editOrNot}", ->
      $(".chzn-select").chosen()
      $(".chzn-select").trigger("liszt:updated")
      $("#reward_pledger_id").val($("#pledgerID").attr("data-id"))
    ))
  )

  $(document).on("click","#rewardFormCancelButton", ->
    rewardID = $(this).attr("data-id")
    $(this).parents(".rewardForm").replaceWith(window.openRewardLine[String(rewardID)])
    window.openRewardLine[String(rewardID)] = null
  )

  #$(".donationForm").bind('ajax:before', ->
    #alert("ajax:before")
    #$(this).contents().replaceWith("<span class='fontawesome-spinner icon-spin>&nbsp;</span>'")
  #)

jQuery ->
  $('.best_in_place').best_in_place()

  $(".phonemasked").mask("(999) 999-9999")

  $(document).on('change','#pledger_perm_zip', ->
    $.zipLookup(
      $(this).val(), (cityName,stateName,stateShortName) ->
        $('#pledger_perm_city').val(cityName)
        $('#pledger_perm_state').val(stateShortName)
        $('#pledger_perm_city').removeAttr("disabled")
        $('#pledger_perm_state').removeAttr("disabled")
      (errMsg) ->
        $('#pledger_perm_city').val("Error: " + errMsg)
    )
  )
  $(document).on('change','#pledger_local_zip', ->
    $.zipLookup(
      $(this).val(), (cityName,stateName,stateShortName) ->
        $('#pledger_local_city').val(cityName)
        $('#pledger_local_state').val(stateShortName)
        $('#pledger_local_city').removeAttr("disabled")
        $('#pledger_local_state').removeAttr("disabled")
      (errMsg) ->
        $('#pledger_local_city').val("Error: " + errMsg)
    )
  )
