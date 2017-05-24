window.Store = new Vuex.Store
  state:
    editions: []
    selectionMode: false
    selectedEditionIds: []
    selectedEditionId: null
    editionsOrder: null

    allAuthors: []
    filteredAuthorIds: []
    allPublishers: []
    filteredPublisherIds: []
    allSeries: []
    filteredSeriesIds: []
    series: null

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

    openedEditionId: (state) ->
      state.pageState.state.editionId

    authorName: (state) ->
      state.pageState.state.authorName

    filteredAuthors: (state) ->
      authors = _.select state.allAuthors, (author) =>
        _.contains state.filteredAuthorIds, author.id
      _.sortBy authors, 'name'

    authorNames: (state) ->
      _.map state.allAuthors, 'name'

    publisherName: (state) ->
      state.pageState.state.publisherName

    filteredPublishers: (state) ->
      publishers = _.select state.allPublishers, (publisher) =>
        _.contains state.filteredPublisherIds, publisher.id
      _.sortBy publishers, 'name'

    publisherNames: (state) ->
      _.map state.allPublishers, 'name'

    categoryCode: (state) ->
      state.pageState.state.categoryCode

    seriesTitle: (state) ->
      state.pageState.state.seriesTitle

    filteredSeries: (state) ->
      series = _.select state.allSeries, (series) =>
        _.contains state.filteredSeriesIds, series.id
      _.sortBy series, 'name'

    seriesTitles: (state) ->
      _.map state.allSeries, 'title'

  mutations:
    # Editions

    setEditions: (state, editions) ->
      state.editions = editions

    setSelectedEditionId: (state, id) ->
      state.selectedEditionId = id
      state.pageState.goToEdition(id)

    setOpenedEditionId: (state, id) ->
      state.pageState.goToEdition(id)

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

    setAuthors: (state, allAuthors) ->
      state.allAuthors = allAuthors

    setFilteredAuthors: (state, authors) ->
      state.filteredAuthorIds = _.map(authors, 'id')

    setAuthorName: (state, authorName) ->
      state.pageState.goToAuthor(authorName)
      state.page = 1

    addAuthor: (state, newAuthor) ->
      state.allAuthors.splice(0, 0, newAuthor)

    updateAuthor: (state, updatedAuthor) ->
      oldAuthor = state.allAuthors.find((a) => a.id == updatedAuthor.id)
      state.allAuthors.splice(state.allAuthors.indexOf(oldAuthor), 1, updatedAuthor)

    removeAuthor: (state, author) ->
      state.allAuthors.splice(state.allAuthors.indexOf(author), 1)

    # Publishers

    setPublishers: (state, publishers) ->
      state.allPublishers = publishers

    setFilteredPublishers: (state, publishers) ->
      state.filteredPublisherIds = _.map(publishers, 'id')

    setPublisherName: (state, publisherName) ->
      state.pageState.goToPublisher(publisherName)
      state.page = 1

    addPublisher: (state, newPublisher) ->
      state.allPublishers.splice(0, 0, newPublisher)

    updatePublisher: (state, updatedPublisher) ->
      oldPublisher = state.allPublishers.find((p) => p.id == updatedPublisher.id)
      state.allPublishers.splice(state.allPublishers.indexOf(oldPublisher), 1, updatedPublisher)

    removePublisher: (state, publisher) ->
      state.allPublishers.splice(state.allPublishers.indexOf(publisher), 1)

    # Series

    setAllSeries: (state, allSeries) ->
      state.allSeries = allSeries

    setFilteredSeries: (state, series) ->
      state.filteredSeriesIds = _.map series, 'id'

    setSeriesTitle: (state, title) ->
      state.pageState.goToSeries(title)
      state.page = 1

    addSeries: (state, newSeries) ->
      state.allSeries.splice(0, 0, newSeries)

    updateSeries: (state, updatedSeries) ->
      oldSeries = state.allSeries.find((p) => p.id == updatedSeries.id)
      state.allSeries.splice(state.allSeries.indexOf(oldSeries), 1, updatedSeries)

    removeSeries: (state, series) ->
      state.allSeries.splice(state.allSeries.indexOf(series), 1)

    # Categories

    setCategoryCode: (state, categoryCode) ->
      state.pageState.goToCategory(categoryCode)
      state.page = 1
