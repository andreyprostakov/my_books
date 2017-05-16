Vue.component 'selected-editions',
  template: '#selected_editions_template'

  data: ->
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
      console.log @publisherNames
      console.log $('[data-publisher-autocomplete]').length
      Vue.nextTick =>
        console.log @publisherNames
        console.log $('[data-publisher-autocomplete]').length
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

    submitUpdates: ->
      @sendUpdates(
        read: @read
        publisher: @publisher
        category: @category
      )

    sendUpdates: (updates) ->
      $.ajax(
        type: 'PUT'
        url: Routes.editions_batch_path()
        dataType: 'json'
        data: { edition_ids: @editionIds, editions_batch: updates }
        success: (response) =>
          console.log 'emit reloading editions'
          EventsDispatcher.$emit('reloadEditions')
        error: (response) =>
          console.log(response)
      )
