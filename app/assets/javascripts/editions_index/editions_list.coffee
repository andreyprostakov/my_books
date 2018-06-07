Vue.component 'editions-list',
  template: '#editions_list_template'

  data: ->
    selected3dBookId: null

  computed: Vuex.mapState
    layout: 'layout'

    page: 'page'

    editions: ->
      @$store.getters.currentPageEditions

    filteredEditions: ->
      @$store.getters.filteredEditions

    selectionMode: 'selectionMode'

    selectedEditionIds: 'selectedEditionIds'

    editionsCount: ->
      @filteredEditions.length

  mounted: ->
    @$watch 'editions', @truncateAnnotations
    @$watch 'layout', @truncateAnnotations

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

    switchTo3d: ->
      @$store.commit('switchTo3d')

    goToAuthor: (author) ->
      @$store.commit('setCurrentAuthor', author)

    truncateAnnotations: ->
      return if @layout != 'list'
      Vue.nextTick =>
        $('.edition-preview-annotation, .edition-preview-authors').dotdotdot()

    select3dBook: (edition) ->
      @selected3dBookId = edition.id
