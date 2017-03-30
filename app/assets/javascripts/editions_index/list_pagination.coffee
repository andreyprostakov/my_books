Vue.component 'list-pagination',
  template: '#list_pagination_template'

  computed: Vuex.mapState
    pageSize: 'pageSize'
    page: 'page'

    showLinkToFirstPage: ->
      @page > 2

    showLinkToLastPage: ->
      @page < (@lastPage - 1)

    previousPage: ->
      return if @page == 1
      @page - 1

    nextPage: ->
      return if @page == @lastPage
      @page + 1

    lastPage: ->
      Math.ceil @editions.length / @pageSize

    editions: ->
      @$store.getters.filteredEditions

  methods:
    goToPage: (pageNumber) ->
      @$store.commit('setPage', pageNumber)
