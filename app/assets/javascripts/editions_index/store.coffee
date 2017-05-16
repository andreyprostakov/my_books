window.Store = new Vuex.Store
  state:
    editions: []
    selectedEdition: null
    selectionMode: false
    selectedEditionIds: []
    openedEdition: null
    editionsOrder: null
    authors: []
    author: null
    publishers: []
    publisher: null
    category: null
    page: 1
    pageSize: 18

  getters:
    filteredEditions: (state) ->
      return state.editions unless state.category
      state.editions.filter((e) => e.category.code == state.category)

    currentPageEditions: (state, getters) ->
      startIndex = state.pageSize * (state.page - 1)
      getters.filteredEditions.slice startIndex, startIndex + state.pageSize

    authorNames: (state) ->
      _.map state.authors, 'name'

    publisherNames: (state) ->
      _.map state.publishers, 'name'

  mutations:
    setEditions: (state, editions) ->
      state.editions = editions

    setSelectedEdition: (state, edition) ->
      state.selectedEdition = edition

    setOpenedEdition: (state, edition) ->
      state.openedEdition = edition

    addEdition: (state, edition) ->
      state.editions.splice(0, 0, edition)

    updateEdition: (state, updatedEdition) ->
      oldEdition = state.editions.find((e) => e.id == updatedEdition.id)
      state.editions.splice(state.editions.indexOf(oldEdition), 1, updatedEdition)

    setEditionsOrder: (state, order) ->
      state.editionsOrder = order

    setPage: (state, page) ->
      state.page = page


    startSelectingEditions: (state) ->
      state.selectionMode = true

    addEditionToSelection: (state, edition) ->
      state.selectedEditionIds.splice(0, 0, edition.id)

    removeEditionFromSelection: (state, edition) ->
      index = state.selectedEditionIds.indexOf(edition.id)
      state.selectedEditionIds.splice(index, 1)

    stopSelectingEditions: (state) ->
      state.selectionMode = false

    clearSelectedEditions: (state) ->
      state.selectedEditionIds.splice(0, state.selectedEditionIds.length)
      Store.commit('stopSelectingEditions')


    setAuthors: (state, authors) ->
      state.authors = authors

    setAuthor: (state, author) ->
      state.publisher = null
      state.author = author
      state.category = null
      state.openedEdition = null
      state.page = 1

    addAuthor: (state, newAuthor) ->
      state.authors.splice(0, 0, newAuthor)

    updateAuthor: (state, updatedAuthor) ->
      oldAuthor = state.authors.find((a) => a.id == updatedAuthor.id)
      state.authors.splice(state.authors.indexOf(oldAuthor), 1, updatedAuthor)

    removeAuthor: (state, author) ->
      state.authors.splice(state.authors.indexOf(author), 1)


    setPublishers: (state, publishers) ->
      state.publishers = publishers

    setPublisher: (state, publisher) ->
      state.publisher = publisher
      state.author = null
      state.category = null
      state.openedEdition = null
      state.page = 1

    addPublisher: (state, newPublisher) ->
      state.publishers.splice(0, 0, newPublisher)

    updatePublisher: (state, updatedPublisher) ->
      oldPublisher = state.publishers.find((p) => p.id == updatedPublisher.id)
      state.publishers.splice(state.publishers.indexOf(oldPublisher), 1, updatedPublisher)

    removePublisher: (state, publisher) ->
      state.publishers.splice(state.publishers.indexOf(publisher), 1)


    setCategory: (state, category) ->
      state.category = category
      state.page = 1
