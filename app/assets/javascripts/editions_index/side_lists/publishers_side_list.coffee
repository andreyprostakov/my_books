Vue.component 'publishers-side-list',
  template: '#publishers_side_list_template'

  data: ->
    showedPublisherIds: []

  computed: Vuex.mapState
    allPublishers: 'allPublishers'

    pageState: 'pageState'

    currentAuthorName: ->
      @$store.getters.currentAuthorName

    currentSeriesTitle: ->
      @$store.getters.currentSeriesTitle

    currentPublisher: ->
      @$store.getters.currentPublisher

    currentCategory: ->
      @$store.getters.currentCategory

    showedPublishers: (state) ->
      _.select state.allPublishers, (publisher) =>
        _.contains @showedPublisherIds, publisher.id

    items: (state) ->
      _.object(_.map(@showedPublishers, 'name'), @showedPublishers)

    routes: -> Routes

  mounted: ->
    @refreshItems()
    EventsDispatcher.$on 'editionCreated', @refreshItems
    EventsDispatcher.$on 'editionUpdated', @refreshItems
    @$watch 'currentAuthorName', @refreshItems
    @$watch 'currentSeriesTitle', @refreshItems
    @$watch 'currentCategory', @refreshItems

  methods:
    refreshItems: ->
      DataRefresher.loadPublishers(
        author_name: @currentAuthorName
        series_title: @currentSeriesTitle
        category_code: @currentCategory
      ).then (publishers) =>
        @showedPublisherIds = _.map(publishers, 'id')

    onSelect: (publisher) ->
      @$store.commit('setCurrentPublisher', publisher)

    publisherUrl: (publisher) ->
      @$store.state.pageState.urlForPublisher(publisher.name)

    createPublisher: (publisherName) ->
      $.ajax(
        type: 'POST'
        url: Routes.publishers_path()
        dataType: 'json'
        data:
          publisher: { name: publisherName }
        success: (createdItem) =>
          @$store.commit('addPublisher', createdItem)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)
