Vue.component 'editions-index',
  mounted: ->
    @loadEditions()
    @$watch 'currentOrder', @loadEditions
    @$watch 'author', @loadEditions
    @$watch 'publisher', @loadEditions
    EventsDispatcher.$on 'reloadEditions', =>
      console.log 'reloading editions'
      @loadEditions()

  computed: Vuex.mapState
    editions: 'editions'
    currentOrder: 'editionsOrder'
    author: 'author'
    publisher: 'publisher',
    category: 'category',
    openedEdition: 'openedEdition'
    selectionMode: 'selectionMode'
    routes: -> Routes

    editionsCount: ->
      @$store.getters.filteredEditions.length

  methods:
    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    loadEditions: ->
      DataRefresher.loadEditions(@$store).then (editions) =>
        @$store.commit('setEditions', editions)

    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')

    startSelectingEdition: ->
      @$store.commit('startSelectingEditions')

    stopSelectingEdition: ->
      @$store.commit('stopSelectingEditions')
