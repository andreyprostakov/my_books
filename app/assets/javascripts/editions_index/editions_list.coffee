Vue.component 'editions-list',
  template: '#editions_list_template'

  computed: Vuex.mapState
    editions: ->
      @$store.getters.currentPageEditions

    filteredEditions: ->
      @$store.getters.filteredEditions

    selectionMode: 'selectionMode'

    selectedEditionIds: 'selectedEditionIds'

    editionsCount: ->
      @filteredEditions.length

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

    urlForEdition: (edition) ->
      @$store.state.pageState.urlForEdition(edition.id)

    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')
