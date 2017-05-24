Vue.component 'publisher-info',
  template: '#publisher_info_template'

  data: ->
    editMode: false
    inputName: ''

  computed: Vuex.mapState
    currentPublisher: ->
      @$store.getters.currentPublisher

    show: ->
      !!@currentPublisher

    title: ->
      @currentPublisher.name

  methods:
    deselect: ->
      @$store.commit('setCurrentPublisher', null)

    edit: ->
      @inputName = @currentPublisher.name
      @editMode = true

    update: ->
      $.ajax(
        type: 'PUT'
        url: Routes.publisher_path(@currentPublisher.id)
        dataType: 'json'
        data:
          publisher: { name: @inputName }
        success: (updatedItem) =>
          @$store.commit('updatePublisher', updatedItem)
          @editMode = false
        error: @handleErrorResponse
      )

    remove: ->
      return unless confirm("Удалить автора \"#{@currentPublisher.name}\"?")
      $.ajax(
        type: 'DELETE'
        url: Routes.publisher_path(@currentPublisher.id)
        dataType: 'json'
        success: =>
          @$store.commit('removePublisher', @currentPublisher)
        error: @handleErrorResponse
      )

    cancelEditMode: ->
      @editMode = false
