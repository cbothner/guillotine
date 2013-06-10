$(document).ready ->
  $("#namesearch")
    .autocomplete source: (request, response) ->
      $.getJSON 'pledgers/search.json', {name: request.term}, (results) ->
        names = []
        for result in results
          names.push result.name
        response names
    select: (event, ui) ->

