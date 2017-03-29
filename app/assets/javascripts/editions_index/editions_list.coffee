Vue.component 'editions-list',
  template: '#editions_list_template'

  props:
    editions: { required: true }

  computed:
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
      DataRefresher.loadEditionDetails(edition).then (detailedEdition) =>
        EventsDispatcher.$emit('editEdition', detailedEdition)

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
