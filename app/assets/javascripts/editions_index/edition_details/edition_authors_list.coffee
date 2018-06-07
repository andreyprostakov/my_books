Vue.component 'edition-authors-list',
  template: '#edition_authors_list_template'

  props:
    edition: { required: true }

  computed:
    authors: ->
      @edition.authors

    activeClick: ->
      !!@$listeners.click

  methods:
    clickOnAuthor: (author) ->
      @$emit('click', author)

    urlForAuthor: (author) ->
      @$store.state.pageState.urlForAuthor(author.name)
