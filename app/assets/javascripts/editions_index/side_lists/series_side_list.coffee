Vue.component 'series-side-list',
  template: '#series_side_list_template'

  data: ->
    showedSeriesIds: []

  computed: Vuex.mapState
    allSeries: 'allSeries'

    pageState: 'pageState'

    currentAuthorName: ->
      @$store.getters.currentAuthorName

    currentPublisherName: ->
      @$store.getters.currentPublisherName

    currentSeries: ->
      @$store.getters.currentSeries

    currentCategory: ->
      @$store.getters.currentCategory

    showedSeries: (state) ->
      _.select state.allSeries, (series) =>
        _.contains @showedSeriesIds, series.id

    items: (state) ->
      _.object(_.map(@showedSeries, 'title'), @showedSeries)

    routes: -> Routes

  mounted: ->
    @refreshItems()
    EventsDispatcher.$on 'editionCreated', @refreshItems
    EventsDispatcher.$on 'editionUpdated', @refreshItems
    @$watch 'currentAuthorName', @refreshItems
    @$watch 'currentPublisherName', @refreshItems
    @$watch 'currentCategory', @refreshItems

  methods:
    refreshItems: ->
      DataRefresher.loadSeries(
        author_name: @currentAuthorName
        publisher_name: @currentPublisherName
        category_code: @currentCategory
      ).then (series) =>
        @showedSeriesIds = _.map(series, 'id')

    onSelect: (series) ->
      @$store.commit('setCurrentSeries', series)

    seriesUrl: (series) ->
      @$store.state.pageState.urlForSeries(series.title)

    createSeries: (seriesTitle) ->
      $.ajax(
        type: 'POST'
        url: Routes.series_index_path()
        dataType: 'json'
        data:
          series: { title: seriesTitle }
        success: (createdItem) =>
          @$store.commit('addSeries', createdItem)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)
