Vue.component 'selected-edition',
  template: '#selected_edition_template'

  data: ->
    edition: null

  computed: Vuex.mapState
    openedEdition: 'openedEdition'
    selectedEditionId: 'selectedEditionId'
    openedEditionId: ->
      @$store.getters.openedEditionId
    editionIsOpened: ->
      @selectedEditionId == @openedEditionId
    routes: -> Routes

  mounted: ->
    @$watch 'selectedEditionId', @refresh

  methods:
    refresh: ->
      if @selectedEditionId
        DataRefresher.loadEditionDetails(id: @selectedEditionId).then (detailedEdition) =>
          @edition = detailedEdition
      else
        @edition = null

    editEdition: ->
      EventsDispatcher.$emit('editEdition', @edition)

    openEdition: ->
      @$store.commit('setOpenedEditionId', @selectedEditionId)

    closeEdition: ->
      @$store.commit('setOpenedEditionId', null)

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
