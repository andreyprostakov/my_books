Vue.component 'series-info',
  template: '#series_info_template'

  data: ->
    editMode: false
    inputName: ''

  computed: Vuex.mapState
    currentSeries: ->
      @$store.getters.currentSeries

    show: ->
      !!@currentSeries

    title: ->
      @currentSeries.title

  methods:
    deselect: ->
      @$store.commit('setCurrentSeries', null)

    edit: ->
      @inputName = @currentSeries.title
      @editMode = true

    update: ->
      $.ajax(
        type: 'PUT'
        url: Routes.series_path(@currentSeries.id)
        dataType: 'json'
        data:
          series: { title: @inputName }
        success: (updatedItem) =>
          @$store.commit('updateSeries', updatedItem)
          @editMode = false
        error: @handleErrorResponse
      )

    remove: ->
      return unless confirm("Удалить серию \"#{@currentSeries.title}\"?")
      $.ajax(
        type: 'DELETE'
        url: Routes.series_path(@currentSeries.id)
        dataType: 'json'
        success: =>
          @$store.commit('removeSeries', @currentSeries)
        error: @handleErrorResponse
      )

    cancelEditMode: ->
      @editMode = false
