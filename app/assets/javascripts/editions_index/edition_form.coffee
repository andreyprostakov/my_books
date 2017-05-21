Vue.component 'edition-form',
  template: '#edition_form_template'

  data: ->
    enabled: false
    edition: null

  mounted: ->
    EventsDispatcher.$on 'addNewEdition', =>
      @edition = @newEdition()
      @show()
    EventsDispatcher.$on 'editEdition', (edition) =>
      DataRefresher.loadEditionDetails(edition).then (detailedEdition) =>
        @edition = detailedEdition
        @show()

  computed: Vuex.mapState
    preselectedAuthor: ->
      @$store.getters.authorName
    preselectedPublisher: ->
      @$store.getters.publisherName
    preselectedCategory: ->
      @$store.getters.categoryCode

    canBeShown: ->
      @enabled

    canShowEditionTitleInput: ->
      @edition.title || (@edition.books.length > 1)

    coverStyle: ->
      'background-image: url(' + @coverUrl + ')'

    coverUrl: ->
      @edition.remote_cover_url || @edition.cover_url

    authorNames: ->
      @$store.getters.authorNames

    publisherNames: ->
      @$store.getters.publisherNames

  methods:
    show: ->
      @enabled = true
      @updateAuthorsAutocompletes()
      @updatePublisherAutocomplete()

    close: ->
      @enabled = false

    canAddAuthorToBook: (book) ->
      book.authors.filter((a) => !a.name).length == 0

    addAuthor: (book) ->
      book.authors.push({})

    removeAuthor: (book, authorIndex) ->
      book.authors.splice(authorIndex, 1)

    updateAuthorsAutocompletes: ->
      Vue.nextTick =>
        $('[data-author-autocomplete]').autocomplete
          source: @authorNames
          minLength: 0

    updatePublisherAutocomplete: ->
      Vue.nextTick =>
        $('[data-publisher-autocomplete]').autocomplete
          source: @publisherNames
          minLength: 0

    addBook: ->
      @edition.books.push @newBook()

    removeBook: (book) ->
      index = @edition.books.indexOf(book)
      @edition.books.splice(index, 1)

    newEdition: ->
      {
        books: [@newBook()]
        publisher: { name: @preselectedPublisher }
        category: { code: @preselectedCategory }
        pages_count: 1
        publication_year: 2016
        remote_cover_url: null
        cover_url: null
      }

    newBook: ->
      {
        authors: [{name: @preselectedAuthor}]
      }

    submit: ->
      if @edition.id
        @updateEdition()
      else
        @createEdition()

    createEdition: ->
      $.ajax(
        type: 'POST'
        url: Routes.editions_path()
        dataType: 'json'
        data: { edition: @editionFormData() }
        success: (createdEdition) =>
          @$store.commit('addEdition', createdEdition)
          EventsDispatcher.$emit('editionCreated', createdEdition)
          @showEditionDetails(createdEdition)
        error: @handleErrorResponse
      )

    updateEdition: ->
      $.ajax(
        type: 'PUT'
        url: Routes.edition_path(@edition)
        dataType: 'json'
        data: { edition: @editionFormData() }
        success: (updatedEdition) =>
          @$store.commit('updateEdition', updatedEdition)
          EventsDispatcher.$emit('editionUpdated', updatedEdition)
          @showEditionDetails(updatedEdition)
        error: @handleErrorResponse
      )

    editionFormData: ->
      _.extend(@edition, force_update_books: true)

    showEditionDetails: (edition) ->
      @close()
      return unless edition.id
      EventsDispatcher.$emit('selectEdition', edition)
