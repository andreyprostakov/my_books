Vue.component 'editions-index',
  mounted: ->
    @loadEditions()
    @$watch 'currentOrder', @loadEditions
    @$watch 'author', @loadEditions
    @$watch 'publisher', @loadEditions

  computed: Vuex.mapState
    editions: 'editions'
    currentOrder: 'editionsOrder'
    author: 'author'
    publisher: 'publisher',
    category: 'category',
    filteredEditions: ->
      return @editions if !@category
      @editionsOfCategory(@category)
    routes: -> Routes

  methods:
    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category == categoryCode)

    loadEditions: ->
      DataRefresher.loadEditions(@$store).then (editions) =>
        @$store.commit('setEditions', editions)
