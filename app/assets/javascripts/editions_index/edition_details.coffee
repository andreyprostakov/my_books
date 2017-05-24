Vue.component 'edition-details',
  template: '#edition_details_template'

  data: ->
    edition: null

  mounted: ->
    @$watch 'openedEditionId', @refresh

    Vue.nextTick =>
      $('body').on 'click', '[data-edition-details]', (event) =>
        if $(event.target).closest('[data-edition-details-content]').length == 0
          @$store.commit('setOpenedEditionId', null)

  computed: Vuex.mapState
    editions: 'editions'

    openedEditionId: ->
      @$store.getters.openedEditionId

    annotation: ->
      @edition.annotation && @edition.annotation.autoLink(target: '_blank')

    booksByAuthors: ->
      booksByAuthors = []
      for book in @edition.books
        continue if booksByAuthors.find((bba) => _.isEqual(bba.authors, book.authors))
        books = @edition.books.filter((b) => _.isEqual(b.authors, book.authors))
        booksByAuthors.push(
          authors: book.authors
          books: books
        )
      booksByAuthors

    bookTitles: ->
      return @edition.title if @edition.title
      _.reduce(
        _.map(@edition.books, 'title'),
        (t1, t2) => "#{t1}; #{t2}"
      )


  methods:
    refresh: ->
      if @openedEditionId
        @$store.commit('setSelectedEditionId', @openedEditionId)
        DataRefresher.loadEditionDetails(id: @openedEditionId).then (detailedEdition) =>
          @edition = detailedEdition
      else
        @edition = null

    switchToAuthor: (author) ->
      @$store.commit('setCurrentAuthor', author)

    switchToPublisher: (publisher) ->
      @$store.commit('setPublisherName', publisher.name)

    switchToCategory: (category) ->
      @$store.commit('setCategoryCode', category.code)
