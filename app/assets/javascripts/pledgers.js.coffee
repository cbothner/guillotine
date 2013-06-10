$(document).ready ->
  $("#namesearch")
    .autocomplete( source: (request, response) ->
      $.getJSON 'pledgers/search.json', {name: request.term}, (results) ->
        names = []
        for result in results
          names.push
            id: result.id
            value: result.name
            desc: result.perm_address
        response names # Callback an array of values.
        return false
    select: (event, ui) ->
      window.location = "pledgers/#{ui.item.id}"
    )
    .data("ui-autocomplete")._renderItem = (ul,item) ->
      $("<li>")
        .append("<a>#{item.value}<br />#{item.desc}</a>")
        .appendTo(ul)
