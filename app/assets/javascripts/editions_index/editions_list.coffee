Vue.component 'editions-list',
  template: '#editions_list_template'

  computed: Vuex.mapState
    layout: 'layout'

    editions: ->
      @$store.getters.currentPageEditions

    filteredEditions: ->
      @$store.getters.filteredEditions

    selectionMode: 'selectionMode'

    selectedEditionIds: 'selectedEditionIds'

    editionsCount: ->
      @filteredEditions.length

  mounted: ->
    @$watch 'editions', =>
      Vue.nextTick =>
        $('.edition-preview-annotation, .edition-preview-authors').dotdotdot()

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

    switchToList: ->
      @$store.commit('switchToListLayout')

    switchToGrid: ->
      @$store.commit('switchToGridLayout')

    goToAuthor: (author) ->
      @$store.commit('setCurrentAuthor', author)
