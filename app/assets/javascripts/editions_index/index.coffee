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
    @$watch 'author', @loadEditions
    @$watch 'publisher', @loadEditions
    EventsDispatcher.$on 'reloadEditions', =>
      @loadEditions()

  computed: Vuex.mapState
    editions: 'editions'
    author: 'author'
    publisher: 'publisher'
    category: 'category'
    currentOrder: 'editionsOrder'
    routes: -> Routes

    editionsCount: ->
      @$store.getters.filteredEditions.length

  methods:
    presetInitialFilters: ->
      @$store.commit('setAuthor', @initialAuthorName) if @initialAuthorName
      @$store.commit('setPublisher', @initialPublisherName) if @initialPublisherName
      @$store.commit('setCategory', @initialCategoryCode) if @initialCategoryCode
      if @initialSelectedEditionId
        EventsDispatcher.$emit('selectEdition', id: @initialSelectedEditionId)

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    loadEditions: ->
      $('#editions_list').spin()
      DataRefresher.loadEditions(@$store).then (editions) =>
        $('#editions_list').spin(false)
        @$store.commit('setEditions', editions)

    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')
