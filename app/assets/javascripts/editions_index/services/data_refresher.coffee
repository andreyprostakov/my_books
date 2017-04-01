class window.DataRefresher
  @loadEditions: (store) ->
    $.when $.getJSON(
      Routes.editions_path(
        order: store.state.editionsOrder
        author: store.state.author
        publisher: store.state.publisher
      )
    )

  @loadEditionDetails: (edition) ->
    $.when $.getJSON(
      Routes.edition_path(edition)
    )

  @loadAuthors: (store) ->
    $.when $.getJSON(
      Routes.authors_path(category_code: store.state.category)
    )

  @loadPublishers: (store) ->
    $.when $.getJSON(
      Routes.publishers_path(category_code: store.state.category)
    )
