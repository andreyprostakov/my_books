Vue.component 'editions-index',
  props:
    initialOrder: { required: true }
    initialCategory: {}
    author: {}

  mounted: ->
    @currentOrder = @initialOrder
    @currentCategory = @initialCategory || null
    @reloadEditions()
    @$watch 'currentOrder', @reloadEditions
    @$watch 'currentCategory', @reloadEditions

  data: => {
    editions: []
    currentOrder: null
    currentCategory: null
  }

  computed:
    filteredEditions: ->
      @editions

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

    authorUrl: (author) ->
      Routes.editions_path(author: author)

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

    currentOrderIs: (orderToCheck) ->
      @currentOrder == orderToCheck

    reloadEditions: ->
      $.getJSON(
        Routes.editions_path(
          order: @currentOrder
          category: @currentCategory
          author: @author
        ),
        (data) => @editions = data
      )
