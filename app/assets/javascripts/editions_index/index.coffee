Vue.component 'editions-index',
  props: [
    'initialSelectedEditionId',
    'initialAuthorName',
    'initialCategoryCode',
    'initialPublisherName',
    'initialSeriesTitle'
  ]

  mounted: ->
    @presetInitialFilters()

    @loadEditions()
    @$watch 'currentOrder', @loadEditions
    @$watch 'authorName', @loadEditions
    @$watch 'publisherName', @loadEditions
    @$watch 'seriesTitle', @loadEditions
    EventsDispatcher.$on 'reloadEditions', =>
      @loadEditions()

  computed: Vuex.mapState
    pageState: 'pageState'
    editions: 'editions'
    authorName: ->
      @$store.getters.authorName
    publisherName: ->
      @$store.getters.publisherName
    seriesTitle: ->
      @$store.getters.seriesTitle
    currentOrder: 'editionsOrder'
    routes: -> Routes

    editionsCount: ->
      @$store.getters.filteredEditions.length

  methods:
    presetInitialFilters: ->
      @$store.state.pageState.setState
        authorName: @initialAuthorName,
        publisherName: @initialPublisherName
        categoryCode: @initialCategoryCode
        seriesTitle: @initialSeriesTitle
        editionId: parseInt(@initialSelectedEditionId)

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    loadEditions: ->
      $('#editions_list').spin()
      DataRefresher.loadEditions(@$store).then (editions) =>
        $('#editions_list').spin(false)
        @$store.commit('setEditions', editions)

    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')
