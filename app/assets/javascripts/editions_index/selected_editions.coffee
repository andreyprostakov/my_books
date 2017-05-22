Vue.component 'selected-editions',
  template: '#selected_editions_template'

  data: ->
    updates:
      read: null
      category: {}
      publisher: {}

  computed: Vuex.mapState
    editionIds: 'selectedEditionIds'
    selectionMode: 'selectionMode'

    publisherNames: ->
      @$store.getters.publisherNames

  methods:
    updatePublisherAutocomplete: ->
      Vue.nextTick =>
        $('[data-publisher-autocomplete]').autocomplete
          source: @publisherNames
          minLength: 0

    toggleSelectionMode: ->
      if @selectionMode
        @$store.commit('stopSelectingEditions')
      else
        @$store.commit('startSelectingEditions')
        @updatePublisherAutocomplete()

    updateBatchReadStatus: (status) ->
      @sendUpdates(read: status)

    clearSelection: ->
      @$store.commit('clearSelectedEditions')

    selectFilteredEditions: ->
      @$store.commit('selectFilteredEditions')

    deselectFilteredEditions: ->
      @$store.commit('deselectFilteredEditions')

    clearErrors: ->
      $('[data-selected-editions-updates-error]').hide()

    submitUpdates: ->
      @clearErrors()
      @sendUpdates(@updates)

    sendUpdates: (updates) ->
      $.ajax(
        type: 'PUT'
        url: Routes.editions_batch_path()
        dataType: 'json'
        data: { edition_ids: @editionIds, editions_batch: updates }
        success: (response) =>
          EventsDispatcher.$emit('reloadEditions')
        error: (response) =>
          $('[data-selected-editions-updates-error]').show()
      )
