Vue.component 'authors-side-list',
  template: '#authors_side_list_template'

  data: ->
    showedAuthorIds: []

  computed: Vuex.mapState
    allAuthors: 'allAuthors'

    items: (state) ->
      _.select state.allAuthors, (author) =>
        _.contains @showedAuthorIds, author.id

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

    onSelect: (authorName) ->
      @$store.commit('setAuthor', authorName)
