window.Store = new Vuex.Store
  state:
    editions: []
    selectedEditionId: null
    selectionMode: false
    selectedEditionIds: []
    openedEdition: null
    editionsOrder: null
    authors: []
    publishers: []
    page: 1
    pageSize: 18
    pageState: new StateMachine()

  getters:
    filteredEditions: (state, getters) ->
      return state.editions unless getters.categoryCode
      state.editions.filter((e) => e.category.code == getters.categoryCode)

    currentPageEditions: (state, getters) ->
      startIndex = state.pageSize * (state.page - 1)
      getters.filteredEditions.slice startIndex, startIndex + state.pageSize

    authorName: (state) ->
      state.pageState.state.authorName

    authorNames: (state) ->
      _.map state.authors, 'name'

    publisherName: (state) ->
      state.pageState.state.publisherName

    publisherNames: (state) ->
      _.map state.publishers, 'name'

    categoryCode: (state) ->
      state.pageState.state.categoryCode

  mutations:
    # Editions

    setEditions: (state, editions) ->
      state.editions = editions

    setSelectedEditionId: (state, id) ->
      state.selectedEditionId = id

    setOpenedEdition: (state, edition) ->
      state.openedEdition = edition

    addEdition: (state, edition) ->
      state.editions.splice(0, 0, edition)

    updateEdition: (state, updatedEdition) ->
      oldEdition = state.editions.find((e) => e.id == updatedEdition.id)
      state.editions.splice(state.editions.indexOf(oldEdition), 1, updatedEdition)

    setEditionsOrder: (state, order) ->
      state.editionsOrder = order

    # Pages

    setPage: (state, page) ->
      state.page = page

    # SelectionMode, SelectedEditionIds

    startSelectingEditions: (state) ->
      state.selectionMode = true

    addEditionToSelection: (state, edition) ->
      state.selectedEditionIds.push(edition.id)

    removeEditionFromSelection: (state, edition) ->
      index = state.selectedEditionIds.indexOf(edition.id)
      state.selectedEditionIds.splice(index, 1)

    stopSelectingEditions: (state) ->
      state.selectionMode = false

    clearSelectedEditions: (state) ->
      state.selectedEditionIds.splice(0, state.selectedEditionIds.length)

    selectFilteredEditions: (state) ->
      _.each Store.getters.filteredEditions, (edition) =>
        state.selectedEditionIds.push(edition.id)

    deselectFilteredEditions: (state) ->
      _.each Store.getters.filteredEditions, (edition) =>
        index = state.selectedEditionIds.indexOf(edition.id)
        state.selectedEditionIds.splice(index, 1) if index >= 0

    # Authors

    setAuthors: (state, authors) ->
      state.authors = authors

    setAuthorName: (state, authorName) ->
      state.pageState.changeState
        publisherName: null
        authorName: authorName
        categoryCode: null
        editionId: null
      state.page = 1

    addAuthor: (state, newAuthor) ->
      state.authors.splice(0, 0, newAuthor)

    updateAuthor: (state, updatedAuthor) ->
      oldAuthor = state.authors.find((a) => a.id == updatedAuthor.id)
      state.authors.splice(state.authors.indexOf(oldAuthor), 1, updatedAuthor)

    removeAuthor: (state, author) ->
      state.authors.splice(state.authors.indexOf(author), 1)

    # Publishers

    setPublishers: (state, publishers) ->
      state.publishers = publishers

    setPublisherName: (state, publisherName) ->
      state.pageState.changeState
        publisherName: publisherName
        authorName: null
        categoryCode: null
        editionId: null
      state.page = 1

    addPublisher: (state, newPublisher) ->
      state.publishers.splice(0, 0, newPublisher)

    updatePublisher: (state, updatedPublisher) ->
      oldPublisher = state.publishers.find((p) => p.id == updatedPublisher.id)
      state.publishers.splice(state.publishers.indexOf(oldPublisher), 1, updatedPublisher)

    removePublisher: (state, publisher) ->
      state.publishers.splice(state.publishers.indexOf(publisher), 1)

    # Categories

    setCategory: (state, category) ->
      state.category = category
      state.page = 1

    setCategoryCode: (state, categoryCode) ->
      state.pageState.changeState(categoryCode: categoryCode)
      state.page = 1
