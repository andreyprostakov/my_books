class window.DataRefresher
  @loadEditions: (store) ->
    $.when $.getJSON(
      Routes.editions_path(
        order: store.state.editionsOrder
        author_name: store.getters.currentAuthorName
        publisher_name: store.getters.currentPublisherName
        series_title: store.getters.currentSeriesTitle
      )
    )

  @loadEditionDetails: (edition) ->
    $.when $.getJSON(
      Routes.edition_path(edition)
    )

  @loadAuthors: (params = {}) ->
    $.when $.getJSON(
      Routes.authors_path(params)
    )

  @loadPublishers: (params = {}) ->
    $.when $.getJSON(
      Routes.publishers_path(params)
    )

  @loadSeries: (params = {}) ->
    $.when $.getJSON(
      Routes.series_index_path(params)
    )
