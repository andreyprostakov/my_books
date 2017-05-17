Vue.component 'editions-index',
  mounted: ->
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
    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    loadEditions: ->
      DataRefresher.loadEditions(@$store).then (editions) =>
        @$store.commit('setEditions', editions)

    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')
