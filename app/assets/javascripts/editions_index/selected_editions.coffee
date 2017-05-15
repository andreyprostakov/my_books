Vue.component 'selected-editions',
  template: '#selected_editions_template'

  computed: Vuex.mapState
    editionIds: 'selectedEditionIds'

  methods:
    updateBatchReadStatus: (status) ->
      $.ajax(
        type: 'PUT'
        url: Routes.editions_batch_path()
        dataType: 'json'
        data: { edition_ids: @editionIds, editions_batch: { read: status } }
        success: (response) =>
          console.log 'emit reloading editions'
          EventsDispatcher.$emit('reloadEditions')
        error: (response) =>
          console.log(response)
      )
