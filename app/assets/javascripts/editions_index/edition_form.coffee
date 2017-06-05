Vue.component 'edition-form',
  template: '#edition_form_template'

  data: ->
    enabled: false
    formData: null
    errors: {}

  mounted: ->
    EventsDispatcher.$on 'addNewEdition', =>
      @formData = @newEdition()
      @show()
    EventsDispatcher.$on 'editEdition', (edition) =>
      DataRefresher.loadEditionDetails(edition).then (detailedEdition) =>
        @formData = @editionToFormData(detailedEdition)
        @show()

  computed: Vuex.mapState
    preselectedAuthor: ->
      @$store.getters.currentAuthorName
    preselectedPublisher: ->
      @$store.getters.currentPublisherName
    preselectedCategory: ->
      @$store.getters.currentCategory
    preselectedSeries: ->
      @$store.getters.currentSeriesTitle

    canBeShown: ->
      @enabled

    canShowEditionTitleInput: ->
      @formData.title || (@formData.books.length > 1)

    coverStyle: ->
      'background-image: url(' + @coverUrl + ')'

    coverUrl: ->
      @formData.remote_cover_url || @formData.cover_url

    authorNames: ->
      @$store.getters.authorNames

    publisherNames: ->
      @$store.getters.publisherNames

    seriesTitles: ->
      _.map @$store.state.allSeries, 'title'

  methods:
    show: ->
      @clearErrors()
      @enabled = true

    close: ->
      @enabled = false

    addAuthor: (book) ->
      book.authors.push({})

    removeAuthor: (book, author) ->
      authorIndex = book.authors.indexOf(author)
      book.authors.splice(authorIndex, 1)
      @clearErrors(@authorErrorPath(book, author))

    addBook: ->
      @formData.books.push @newBook()

    removeBook: (book) ->
      index = @formData.books.indexOf(book)
      @formData.books.splice(index, 1)
      @clearErrors(@bookErrorPath(book))

    newEdition: ->
      books: [@newBook()]
      publisherName: @preselectedPublisher
      categoryCode: @preselectedCategory
      seriesTitle: @preselectedSeries
      pagesCount: 1
      publicationYear: 2016
      remoteCoverUrl: null
      coverUrl: null
      cover: null

    newBook: ->
      authors: [{name: @preselectedAuthor}]

    submit: ->
      @clearErrors()
      if @formData.id
        @updateEdition()
      else
        @createEdition()

    createEdition: ->
      $.ajax(
        type: 'POST'
        url: Routes.editions_path()
        dataType: 'json'
        data: @formDataToRequestData()
        success: (createdEdition) =>
          @$store.commit('addEdition', createdEdition)
          EventsDispatcher.$emit('editionCreated', createdEdition)
          @showEditionDetails(createdEdition)
        error: @handleErrorResponse
      )

    updateEdition: ->
      console.log 'updateEdition'
      console.log @formDataToRequestData()
      $.ajax(
        type: 'PUT'
        url: Routes.edition_path(@formData.id)
        dataType: 'json'
        data: @formDataToRequestData()
        success: (updatedEdition) =>
          @$store.commit('updateEdition', updatedEdition)
          EventsDispatcher.$emit('editionUpdated', updatedEdition)
          @showEditionDetails(updatedEdition)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      @errors = response.responseJSON

    authorNameError: (book, author) ->
      _.first @errors[@authorErrorPath(book, author, 'name')]

    bookTitleError: (book) ->
      _.first @errors[@bookErrorPath(book, 'title')]

    authorErrorPath: (book, author, attribute) ->
      authorIndex = book.authors.indexOf(author)
      @bookErrorPath book, "authors[#{authorIndex}].#{attribute}"

    bookErrorPath: (book, attribute) ->
      bookIndex = @formData.books.indexOf(book)
      "books[#{bookIndex}].#{attribute}"

    coverError: ->
      _.first @errors["cover"]

    categoryError: ->
      _.first @errors["category"]

    clearErrors: (key = null) ->
      if key
        regexp = new RegExp("^#{key}")
        @errors = _.omit(@errors, (v, k) => k.match(regexp))
      else
        @errors = {}

    editionToFormData: (edition) ->
      data = _.clone edition
      data.publicationYear = edition.publication_year
      data.pagesCount = edition.pages_count
      data.seriesTitle = edition.series.title if edition.series
      data.categoryCode = edition.category.code if edition.category
      data.publisherName = edition.publisher.name if edition.publisher
      data

    formDataToRequestData: ->
      edition:
        title: @formData.title
        books: @formData.books
        cover: @formData.coverFile
        remote_cover_url: @formData.remoteCoverUrl
        publication_year: @formData.publicationYear
        pages_count: @formData.pagesCount
        annotation: @formData.annotation
        isbn: @formData.isbn
        category: { code: @formData.categoryCode } if @formData.categoryCode
        publisher: { name: @formData.publisherName } if @formData.publisherName
        series: { title: @formData.seriesTitle } if @formData.seriesTitle
        force_update_books: true

    showEditionDetails: ->
      @close()
      @$store.commit('setSelectedEditionId', @formData.id)
