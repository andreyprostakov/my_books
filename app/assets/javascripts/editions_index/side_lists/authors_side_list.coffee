Vue.component 'authors-side-list',
  template: '#authors_side_list_template'

  data: ->
    showedAuthorIds: []

  computed: Vuex.mapState
    allAuthors: 'allAuthors'

    pageState: 'pageState'

    currentAuthor: ->
      @$store.getters.currentAuthor

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
    @$watch 'publisherName', @refreshItems
    @$watch 'seriesTitle', @refreshItems

  methods:
    refreshItems: ->
      DataRefresher.loadAuthors(
        publisherName: @publisherName
        seriesTitle: @seriesTitle
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
          @showedAuthorIds.push(createdItem.id)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)
