Vue.component 'editions-index',
  mounted: ->
    @reloadEditions()
    @$watch 'currentOrder', @reloadEditions
    @$watch 'author', @reloadEditions
    @$watch 'publisher', @reloadEditions

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

    reloadEditions: ->
      $.getJSON(
        Routes.editions_path(
          order: @currentOrder
          author: @author
          publisher: @publisher
        ),
        (data) => @$store.commit('setEditions', data)
      )
