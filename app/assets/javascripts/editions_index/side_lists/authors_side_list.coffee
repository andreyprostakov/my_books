Vue.component 'authors-side-list',
  template: '#authors_side_list_template'

  data: ->
    showedAuthorIds: []

  computed: Vuex.mapState
    allAuthors: 'allAuthors'

    pageState: 'pageState'

    currentPublisherName: ->
      @$store.getters.currentPublisherName

    currentSeriesTitle: ->
      @$store.getters.currentSeriesTitle

    currentAuthor: ->
      @$store.getters.currentAuthor

    currentCategory: ->
      @$store.getters.currentCategory

    showedAuthors: (state) ->
      _.select state.allAuthors, (author) =>
        _.contains @showedAuthorIds, author.id

    items: (state) ->
      _.object(_.map(@showedAuthors, 'name'), @showedAuthors)

    routes: -> Routes

  mounted: ->
    @refreshItems()
    EventsDispatcher.$on 'editionCreated', @refreshItems
    EventsDispatcher.$on 'editionUpdated', @refreshItems
    @$watch 'currentPublisherName', @refreshItems
    @$watch 'currentSeriesTitle', @refreshItems
    @$watch 'currentCategory', @refreshItems

  methods:
    refreshItems: ->
      DataRefresher.loadAuthors(
        publisher_name: @currentPublisherName
        series_title: @currentSeriesTitle
        category_code: @currentCategory
      ).then (authors) =>
        @showedAuthorIds = _.map(authors, 'id')

    onSelect: (author) ->
      @$store.commit('setCurrentAuthor', author)

    authorUrl: (author) ->
      @$store.state.pageState.urlForAuthor(author.name)

    createAuthor: (authorName) ->
      $.ajax(
        type: 'POST'
        url: Routes.authors_path()
        dataType: 'json'
        data:
          author: { name: authorName }
        success: (createdItem) =>
          @$store.commit('addAuthor', createdItem)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)
