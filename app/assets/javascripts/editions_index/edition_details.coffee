Vue.component 'edition-details',
  template: '#edition_details_template'

  data: ->
    enabled: false
    edition: null

  mounted: ->
    EventsDispatcher.$on 'showEditionDetails', (edition) =>
      console.log "showEditionDetails"
      console.log edition
      DataRefresher.loadEditionDetails(edition).then (detailedEdition) =>
        console.log detailedEdition
        @edition = detailedEdition
        @show()

  computed: Vuex.mapState
    editions: ->
      @$store.getters.filteredEditions

    canBeShown: ->
      @edition && @enabled

    coverStyle: ->
      'background-image: url(' + @coverUrl + ')'

    coverUrl: ->
      @edition.cover_url

    currentEditionIndex: ->
      @editions.findIndex((e) => e.id == @edition.id)

    rightPageNumber: ->
      @currentEditionIndex * 2

    leftPageNumber: ->
      @rightPageNumber + 1

    canSwitchToPrievousEdition: ->
      @currentEditionIndex > 0

    canSwitchToNextEdition: ->
      @currentEditionIndex < (@editions.length - 1)

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
      _.reduce(
        _.map(@edition.books, 'title'),
        (t1, t2) => "#{t1} ; #{t2}"
      )


  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author.name)
      @close()

    switchToPublisher: (publisher) ->
      @$store.commit('setPublisher', publisher.name)
      @close()

    switchToCategory: (category) ->
      @$store.commit('setCategory', category.code)
      @close()

    switchToNextEdition: ->
      return unless @canSwitchToNextEdition
      EventsDispatcher.$emit 'showEditionDetails', (@editions[@currentEditionIndex + 1])

    switchToPreviousEdition: ->
      console.log "@canSwitchToPrievousEdition? #{@canSwitchToPrievousEdition}"
      return unless @canSwitchToPrievousEdition
      console.log "prievousEdition index: #{@editions[@currentEditionIndex - 1]}"
      EventsDispatcher.$emit 'showEditionDetails', (@editions[@currentEditionIndex - 1])

    editEdition: ->
      @close()
      EventsDispatcher.$emit('editEdition', @edition)
