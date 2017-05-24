Vue.component 'author-info',
  template: '#author_info_template'

  data: ->
    editMode: false
    inputName: ''

  computed: Vuex.mapState
    currentAuthor: ->
      @$store.getters.currentAuthor

    show: ->
      !!@currentAuthor

    title: ->
      @currentAuthor.name

  methods:
    deselect: ->
      @$store.commit('setCurrentAuthor', null)

    edit: ->
      @inputName = @currentAuthor.name
      @editMode = true

    update: ->
      $.ajax(
        type: 'PUT'
        url: Routes.author_path(@currentAuthor.id)
        dataType: 'json'
        data:
          author: { name: @inputName }
        success: (updatedItem) =>
          @$store.commit('updateAuthor', updatedItem)
          @editMode = false
        error: @handleErrorResponse
      )

    remove: ->
      return unless confirm("Удалить автора \"#{@currentAuthor.name}\"?")
      $.ajax(
        type: 'DELETE'
        url: Routes.author_path(@currentAuthor.id)
        dataType: 'json'
        success: =>
          @$store.commit('removeAuthor', @currentAuthor)
        error: @handleErrorResponse
      )

    cancelEditMode: ->
      @editMode = false
