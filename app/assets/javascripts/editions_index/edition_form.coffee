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

    addAuthor: (book) ->
      book.authors.push(null)

    removeAuthor: (book, author) ->
      index = book.authors.indexOf(author)
      book.authors.splice(index, 1)

    addBook: ->
      @edition.books.push @newBook()

    removeBook: (book) ->
      index = @edition.books.indexOf(book)
      @edition.books.splice(index, 1)

    newBook: ->
      {authors: [null]}
