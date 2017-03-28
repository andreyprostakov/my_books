Vue.component 'edition-form',
  template: '#edition_form_template'

  data: ->
    enabled: false
    edition: null

  mounted: ->
    EventsDispatcher.$on 'addNewEdition', =>
      @edition = @newEdition()
      @show()

  computed: Vuex.mapState
    preselectedAuthor: 'author'
    preselectedPublisher: 'publisher'
    preselectedCategory: 'category'
    canBeShown: ->
      @enabled

  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    canAddAuthorToBook: (book) ->
      book.authors.filter((a) => !a.name).length == 0

    addAuthor: (book) ->
      book.authors.push({})

    removeAuthor: (book, authorIndex) ->
      book.authors.splice(authorIndex, 1)

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
        pagesCount: 1
        publicationYear: 2016
      }

    newBook: ->
      {
        authors: [{name: @preselectedAuthor}]
      }

    submit: ->
      $.ajax(
        type: 'POST'
        url: Routes.editions_path()
        dataType: 'json'
        data: { edition: @edition }
        success: (createdEdition) =>
          @$store.commit('addEdition', createdEdition)
          EventsDispatcher.$emit('editionCreated', createdEdition)
          @close()
        error: @handleErrorResponse
      )
