Vue.component 'editions-index',
  props: [
    'initialSelectedEditionId',
    'initialAuthorName',
    'initialCategoryCode',
    'initialPublisherName',
    'initialSeriesTitle'
  ]

  mounted: ->
    @loadLists()
    @presetInitialFilters()

    @loadEditions()
    @$watch 'currentOrder', @loadEditions
    @$watch 'currentAuthorName', @loadEditions
    @$watch 'currentPublisherName', @loadEditions
    @$watch 'currentSeriesTitle', @loadEditions
    EventsDispatcher.$on 'editionCreated', =>
      @loadLists()
      @loadEditions()
    EventsDispatcher.$on 'editionUpdated', =>
      @loadLists()
      @loadEditions()

  computed: Vuex.mapState
    pageState: 'pageState'
    editions: 'editions'
    currentAuthorName: ->
      @$store.getters.currentAuthorName
    currentPublisherName: ->
      @$store.getters.currentPublisherName
    currentSeriesTitle: ->
      @$store.getters.currentSeriesTitle
    currentOrder: 'editionsOrder'
    routes: -> Routes

  methods:
    loadLists: ->
      @loadAuthors()
      @loadPublishers()
      @loadSeries()

    loadAuthors: ->
      DataRefresher.loadAuthors().then (authors) =>
        @$store.commit('setAuthors', authors)

    loadPublishers: ->
      DataRefresher.loadPublishers().then (publishers) =>
        @$store.commit('setPublishers', publishers)

    loadSeries: ->
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
