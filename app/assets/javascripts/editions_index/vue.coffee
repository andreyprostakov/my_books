$ ->
  new Vue
    el: '#editions_index'

Vue.component 'editions-index',
  data: => {
    editions: []
    currentOrder: null
    currentCategory: null
  }

  computed:
    filteredEditions: ->
      return @editions if !@currentCategory
      @editions.filter((e) => e.edition_category == @currentCategory)

  methods:
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

    editionUrl: (edition) ->
      Routes.edition_path(edition.id)

    editEditionUrl: (edition) ->
      Routes.edit_edition_path(edition.id)

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

    switchToCategory: (categoryCode) ->
      @currentCategory = categoryCode

    currentCategoryIs: (categoryToCheck) ->
      @currentCategory == categoryToCheck

    switchToOrder: (orderCode) ->
      @currentOrder = orderCode
      $.getJSON(Routes.editions_path(order: orderCode), (data) => @editions = data)

    currentOrderIs: (orderToCheck) ->
      @currentOrder == orderToCheck

  mounted: ->
    $.getJSON(Routes.editions_path(), (data) =>
      @editions = data
    )
