class window.DataRefresher
  @loadEditions: (store) ->
    $.when $.getJSON(
      Routes.editions_path(
        order: store.state.editionsOrder
        author: store.state.pageState.state.authorName
        publisher: store.state.pageState.state.publisherName
      )
    )

  @loadEditionDetails: (edition) ->
    $.when $.getJSON(
      Routes.edition_path(edition)
    )

  @loadAuthors: ->
    $.when $.getJSON(
      Routes.authors_path()
    )

  @loadPublishers: ->
    $.when $.getJSON(
      Routes.publishers_path()
    )
