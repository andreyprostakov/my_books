Vue.component 'selection-meta-info',
  template: '#selection_meta_info_template'

  data: ->
    updates:
      read: null
      category: {}
      publisher: {}
      series: {}
    errors: {}
    editAuthorMode: false
    authorFormName: ''

  computed: Vuex.mapState
    editions: 'editions'
    currentAuthor: ->
      @$store.getters.currentAuthor
    publisherName: ->
      @$store.getters.publisherName
    seriesTitle: ->
      @$store.getters.seriesTitle

    editionsCount: ->
      @$store.getters.filteredEditions.length

  methods:
    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')

    deselectAuthor: ->
      @$store.commit('setCurrentAuthor', null)

    editAuthor: ->
      @authorFormName = @currentAuthor.name
      @editAuthorMode = true

    updateAuthor: ->
      $.ajax(
        type: 'PUT'
        url: Routes.author_path(@currentAuthor.id)
        dataType: 'json'
        data:
          author: { name: @authorFormName }
        success: (updatedItem) =>
          @$store.commit('updateAuthor', updatedItem)
          @editAuthorMode = false
        error: @handleErrorResponse
      )

    deleteAuthor: ->
      return unless confirm("Удалить автора \"#{@currentAuthor.name}\"?")
      $.ajax(
        type: 'DELETE'
        url: Routes.author_path(@currentAuthor.id)
        dataType: 'json'
        success: =>
          @$store.commit('removeAuthor', @currentAuthor)
        error: @handleErrorResponse
      )

    cancelAuthorEditMode: ->
      @editAuthorMode = false

    deselectPublisher: ->
      @$store.commit('setPublisherName', null)

    deselectSeries: ->
      @$store.commit('setSeriesTitle', null)
