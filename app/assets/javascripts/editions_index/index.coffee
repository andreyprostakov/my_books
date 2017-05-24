Vue.component 'editions-index',
  props: [
    'initialSelectedEditionId',
    'initialAuthorName',
    'initialCategoryCode',
    'initialPublisherName',
    'initialSeriesTitle'
  ]

  mounted: ->
    @preloadLists()
    @presetInitialFilters()

    @loadEditions()
    @$watch 'currentOrder', @loadEditions
    @$watch 'currentAuthorName', @loadEditions
    @$watch 'publisherName', @loadEditions
    @$watch 'seriesTitle', @loadEditions
    EventsDispatcher.$on 'reloadEditions', =>
      @loadEditions()

  computed: Vuex.mapState
    pageState: 'pageState'
    editions: 'editions'
    currentAuthorName: ->
      @$store.getters.currentAuthorName
    publisherName: ->
      @$store.getters.publisherName
    seriesTitle: ->
      @$store.getters.seriesTitle
    currentOrder: 'editionsOrder'
    routes: -> Routes

  methods:
    preloadLists: ->
      DataRefresher.loadAuthors().then (authors) =>
        @$store.commit('setAuthors', authors)
      DataRefresher.loadPublishers().then (publishers) =>
        @$store.commit('setPublishers', publishers)
      DataRefresher.loadSeries().then (series) =>
        @$store.commit('setAllSeries', series)

    presetInitialFilters: ->
      @$store.state.pageState.setState
        authorName: @initialAuthorName,
        publisherName: @initialPublisherName
        categoryCode: @initialCategoryCode
        seriesTitle: @initialSeriesTitle
        editionId: parseInt(@initialSelectedEditionId)

    loadEditions: ->
      $('#editions_list').spin()
      DataRefresher.loadEditions(@$store).then (editions) =>
        $('#editions_list').spin(false)
        @$store.commit('setEditions', editions)
