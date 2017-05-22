Vue.component 'editions-list',
  template: '#editions_list_template'

  computed: Vuex.mapState
    editions: ->
      @$store.getters.currentPageEditions
    selectionMode: 'selectionMode'
    selectedEditionIds: 'selectedEditionIds'

  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    selectEdition: (edition) ->
      @$store.commit('setOpenedEditionId', edition.id)

    toggleEditionFromSelection: (edition) ->
      if @editionIsSelected(edition)
        @$store.commit('removeEditionFromSelection', edition)
      else
        @$store.commit('addEditionToSelection', edition)

    editionIsSelected: (edition) ->
      _.contains @selectedEditionIds, edition.id

    switchToAuthor: (author) ->
      @$store.commit('setAuthorName', author.name)
      @close()

    editionsCount: ->
      @editions.length

    urlForEdition: (edition) ->
      @$store.state.pageState.urlForEdition(edition.id)
