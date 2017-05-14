Vue.component 'edition-details',
  template: '#edition_details_template'

  data: ->
    enabled: false

  mounted: ->
    EventsDispatcher.$on 'showEditionDetails', (edition) =>
      DataRefresher.loadEditionDetails(edition).then (detailedEdition) =>
        @$store.commit('setOpenedEdition', detailedEdition)
        @show()

    EventsDispatcher.$on 'hideEditionDetails', =>
      @close()

    Vue.nextTick =>
      $('body').on 'click', '[data-edition-details]', (event) =>
        if $(event.target).closest('[data-edition-details-content]').length == 0
          @close()

  computed: Vuex.mapState
    editions: 'editions'
    edition: 'openedEdition'
    canBeShown: ->
      @edition && @enabled

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
    show: ->
      @enabled = true

    close: ->
      @enabled = false
      @$store.commit('setOpenedEdition', null)

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author.name)
      @close()

    switchToPublisher: (publisher) ->
      @$store.commit('setPublisher', publisher.name)
      @close()

    switchToCategory: (category) ->
      @$store.commit('setCategory', category.code)
      @close()
