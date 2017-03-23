Vue.component 'editions-index',
  props:
    initialOrder: { required: true }
    initialCategory: { default: null }

  data: => {
    editions: []
    currentOrder: null
    currentCategory: null
    editionDetails: null
  }

  mounted: ->
    @currentOrder = @initialOrder
    @currentCategory = @initialCategory
    @reloadEditions()
    @$watch 'currentOrder', @reloadEditions
    @$watch 'author', @reloadEditions
    @$watch 'publisher', @reloadEditions

  computed: Vuex.mapState
    author: 'author'
    publisher: 'publisher'
    filteredEditions: ->
      return @editions if !@currentCategory
      @editionsOfCategory(@currentCategory)
    routes: -> Routes

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

    showEditionDetails: (edition) ->
      $.getJSON(
        Routes.edition_path(edition.id),
        (data) => @editionDetails = data
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

    switchToCategory: (categoryCode) ->
      @currentCategory = categoryCode

    currentCategoryIs: (categoryToCheck) ->
      @currentCategory == categoryToCheck

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category == categoryCode)

    anyEditionsOfCategory: (categoryToCheck) ->
      !!@editionsOfCategory(categoryToCheck).length

    switchToOrder: (orderCode) ->
      @currentOrder = orderCode

    currentOrderIs: (orderToCheck) ->
      @currentOrder == orderToCheck

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author)

    reloadEditions: ->
      $.getJSON(
        Routes.editions_path(
          order: @currentOrder
          author: @author
          publisher: @publisher
        ),
        (data) => @editions = data
      )
