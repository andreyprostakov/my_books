Vue.component 'editions-list',
  template: '#editions_list_template'

  computed: Vuex.mapState
    editions: ->
      @$store.getters.currentPageEditions

    routes: -> Routes

  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    showEditionDetails: (edition) ->
      EventsDispatcher.$emit('showEditionDetails', edition)

    editEdition: (edition) ->
      EventsDispatcher.$emit('editEdition', edition)

    editEditionUrl: (edition) ->
      Routes.edit_edition_path(edition.id)

    removeEdition: (edition) ->
      $.ajax(
        type: 'DELETE'
        url: Routes.edition_path(edition.id)
        dataType: 'json'
        success: =>
          @editions.splice(@editions.indexOf(edition), 1)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author.name)
      @close()

    editionsCount: ->
      @editions.length
