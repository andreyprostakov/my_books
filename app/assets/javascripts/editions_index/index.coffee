Vue.component 'editions-index',
  props: [
    'initialSelectedEditionId',
    'initialAuthorName',
    'initialCategoryCode',
    'initialPublisherName'
  ]

  mounted: ->
    @presetInitialFilters()

    @loadEditions()
    @$watch 'currentOrder', @loadEditions
    @$watch 'authorName', @loadEditions
    @$watch 'publisherName', @loadEditions
    EventsDispatcher.$on 'reloadEditions', =>
      @loadEditions()

  computed: Vuex.mapState
    editions: 'editions'
    authorName: ->
      @$store.getters.authorName
    publisherName: ->
      @$store.getters.publisherName
    currentOrder: 'editionsOrder'
    pageState: 'pageState'
    routes: -> Routes

    editionsCount: ->
      @$store.getters.filteredEditions.length

  methods:
    presetInitialFilters: ->
      @pageState.setState
        authorName: @initialAuthorName,
        publisherName: @initialPublisherName
        categoryCode: @initialCategoryCode
        edition_id: @initialSelectedEditionId

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    loadEditions: ->
      $('#editions_list').spin()
      DataRefresher.loadEditions(@$store).then (editions) =>
        $('#editions_list').spin(false)
        @$store.commit('setEditions', editions)

    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')
