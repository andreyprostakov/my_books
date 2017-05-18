Vue.component 'editions-list',
  template: '#editions_list_template'

  computed: Vuex.mapState
    editions: ->
      @$store.getters.currentPageEditions
    selectionMode: 'selectionMode'
    selectedEditionIds: 'selectedEditionIds'
    routes: -> Routes

  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    selectEdition: (edition) ->
      EventsDispatcher.$emit('selectEdition', edition)

    toggleEditionFromSelection: (edition) ->
      if @editionIsSelected(edition)
        @$store.commit('removeEditionFromSelection', edition)
      else
        @$store.commit('addEditionToSelection', edition)

    editionIsSelected: (edition) ->
      _.contains @selectedEditionIds, edition.id

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author.name)
      @close()

    editionsCount: ->
      @editions.length
