Vue.component 'selected-edition',
  template: '#selected_edition_template'

  computed: Vuex.mapState
    editions: 'editions'
    openedEdition: 'openedEdition'
    selectedEditionId: 'selectedEditionId'

    edition: ->
      _.find @editions, id: @selectedEditionId

    openedEditionId: ->
      @$store.getters.openedEditionId

    editionIsOpened: ->
      @selectedEditionId == @openedEditionId

    routes: -> Routes

    seriesTitle: ->
      return unless @edition.series
      @edition.series.title

  methods:
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

    openSeries: ->
      return unless @edition.series
      @$store.commit('setCurrentSeries', @edition.series)
