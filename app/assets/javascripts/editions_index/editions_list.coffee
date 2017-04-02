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

    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')

    showEditionDetails: (edition) ->
      EventsDispatcher.$emit('showEditionDetails', edition)

    editEdition: (edition) ->
      EventsDispatcher.$emit('editEdition', edition)

    editEditionUrl: (edition) ->
      Routes.edit_edition_path(edition.id)

    changeReadStatus: (edition) ->
      $.ajax(
        type: 'PUT'
        url: Routes.edition_path(edition.id)
        dataType: 'json'
        data: { edition: { read: !edition.read } }
        success: (updated_edition) =>
          edition.read = updated_edition.read
        error: @handleErrorResponse
      )
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

    editionBackgroundColor: (edition) ->
      switch edition.category.code
        when 'fiction' then 'darkred'
        when 'non_fiction' then 'deepskyblue'
        when 'comics' then 'darkslategrey'
        when 'encyclopedia' then 'seagreen'
        when 'media' then 'black'
        else 'white'
