Vue.component 'edition-form',
  template: '#edition_form_template'

  data: ->
    enabled: false
    edition: {}

  mounted: ->
    EventsDispatcher.$on 'addNewEdition', =>
      @edition = { books: [@newBook()] }
      @show()

  computed:
    canBeShown: ->
      @enabled

  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    canAddAuthorToBook: (book) ->
      book.authors.filter((a) => !a).length == 0

    addAuthor: (book) ->
      book.authors.push(null)

    removeAuthor: (book, authorIndex) ->
      book.authors.splice(authorIndex, 1)

    addBook: ->
      @edition.books.push @newBook()

    removeBook: (book) ->
      index = @edition.books.indexOf(book)
      @edition.books.splice(index, 1)

    newBook: ->
      {authors: [null]}

    submit: ->
      $.ajax(
        type: 'POST'
        url: Routes.editions_path()
        dataType: 'json'
        data: { edition: @edition }
        success: (createdEdition) =>
          console.log createdEdition
        error: @handleErrorResponse
      )
