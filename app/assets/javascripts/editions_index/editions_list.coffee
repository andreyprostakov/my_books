Vue.component 'editions-list',
  template: '#editions_list_template'

  computed: Vuex.mapState
    editions: ->
      @$store.getters.currentPageEditions

  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    selectEdition: (edition) ->
      EventsDispatcher.$emit('selectEdition', edition)

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author.name)
      @close()

    editionsCount: ->
      @editions.length
