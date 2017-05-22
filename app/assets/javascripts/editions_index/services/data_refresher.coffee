class window.DataRefresher
  @loadEditions: (store) ->
    $.when $.getJSON(
      Routes.editions_path(
        order: store.state.editionsOrder
        author: store.getters.authorName
        publisher: store.getters.publisherName
        series_title: store.getters.seriesTitle
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

  @loadSeries: ->
    $.when $.getJSON(
      Routes.series_index_path()
    )
