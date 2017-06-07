updateItemInArray = (array, updatedItem) ->
  index = _.findIndex array, id: updatedItem.id
  return null if index < 0
  oldItem = array[index]
  array.splice(index, 1, updatedItem)
  oldItem

LIST_LAYOUT = 'list'
GRID_LAYOUT = 'grid'

window.Store = new Vuex.Store
  state:
    editions: []
    selectionMode: false
    selectedEditionIds: []
    selectedEditionId: null
    editionsOrder: null

    allAuthors: []
    allPublishers: []
    allSeries: []

    page: 1
    pageSize: 18
    pageState: new StateMachine()

    layout: GRID_LAYOUT

  getters:
    filteredEditions: (state, getters) ->
      return state.editions unless getters.currentCategory
      state.editions.filter((e) => e.category.code == getters.currentCategory)

    currentPageEditions: (state, getters) ->
      startIndex = state.pageSize * (state.page - 1)
      getters.filteredEditions.slice startIndex, startIndex + state.pageSize

    openedEditionId: (state) ->
      state.pageState.state.editionId

    currentAuthorName: (state) ->
      state.pageState.state.authorName

    currentAuthor: (state, getters) ->
      return null unless getters.currentAuthorName
      _.find state.allAuthors, name: getters.currentAuthorName

    authorNames: (state) ->
      _.map state.allAuthors, 'name'

    currentPublisherName: (state) ->
      state.pageState.state.publisherName

    currentPublisher: (state, getters) ->
      return null unless getters.currentPublisherName
      _.find state.allPublishers, name: getters.currentPublisherName

    publisherNames: (state) ->
      _.map state.allPublishers, 'name'

    currentCategory: (state) ->
      state.pageState.state.categoryCode

    currentSeriesTitle: (state) ->
      state.pageState.state.seriesTitle

    currentSeries: (state, getters) ->
      return null unless getters.currentSeriesTitle
      _.find state.allSeries, title: getters.currentSeriesTitle

    seriesTitles: (state) ->
      _.map state.allSeries, 'title'

  mutations:
    # Editions

    setEditions: (state, editions) ->
      state.editions = editions

    setSelectedEditionId: (state, id) ->
      state.selectedEditionId = id
      state.pageState.goToEdition(id)
      window.scrollTo(0, 0)

    setOpenedEditionId: (state, id) ->
      state.selectedEditionId = id
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
      window.scrollTo(0, 0)

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
        return if _.contains state.selectedEditionIds, edition.id
        state.selectedEditionIds.push(edition.id)

    deselectFilteredEditions: (state) ->
      _.each Store.getters.filteredEditions, (edition) =>
        index = state.selectedEditionIds.indexOf(edition.id)
        state.selectedEditionIds.splice(index, 1) if index >= 0

    # Authors

    setAuthors: (state, allAuthors) ->
      state.allAuthors = allAuthors

    setCurrentAuthor: (state, author) ->
      state.pageState.goToAuthor((author || {}).name)
      state.page = 1

    addAuthor: (state, newAuthor) ->
      state.allAuthors.splice(0, 0, newAuthor)
      state.pageState.goToAuthor(newAuthor.name)

    updateAuthor: (state, updatedAuthor) ->
      oldAuthor = updateItemInArray(state.allAuthors, updatedAuthor)
      return unless oldAuthor
      state.pageState.goToAuthor(updatedAuthor.name) if Store.getters.currentAuthorName == oldAuthor.name

    removeAuthor: (state, author) ->
      state.allAuthors.splice(state.allAuthors.indexOf(author), 1)
      state.pageState.goToAuthor(null) if Store.getters.currentAuthorName == author.name

    # Publishers

    setPublishers: (state, publishers) ->
      state.allPublishers = publishers

    setCurrentPublisher: (state, publisher) ->
      state.pageState.goToPublisher((publisher || {}).name)
      state.page = 1

    addPublisher: (state, newPublisher) ->
      state.allPublishers.splice(0, 0, newPublisher)
      state.pageState.goToPublisher(newPublisher.name)

    updatePublisher: (state, updatedPublisher) ->
      oldPublisher = updateItemInArray(state.allPublishers, updatedPublisher)
      return unless oldPublisher
      state.pageState.goToPublisher(updatedPublisher.name) if Store.getters.currentPublisherName == oldPublisher.name

    removePublisher: (state, publisher) ->
      state.allPublishers.splice(state.allPublishers.indexOf(publisher), 1)
      state.pageState.goToPublisher(null) if Store.getters.currentPublisherName == publisher.name

    # Series

    setAllSeries: (state, allSeries) ->
      state.allSeries = allSeries

    setCurrentSeries: (state, series) ->
      state.pageState.goToSeries((series || {}).title)
      state.page = 1

    addSeries: (state, newSeries) ->
      state.allSeries.splice(0, 0, newSeries)
      state.pageState.goToSeries(newSeries.title)

    updateSeries: (state, updatedSeries) ->
      oldSeries = updateItemInArray(state.allSeries, updatedSeries)
      return unless oldSeries
      state.pageState.goToSeries(updatedSeries.title) if Store.getters.currentSeriesTitle == oldSeries.title

    removeSeries: (state, series) ->
      state.allSeries.splice(state.allSeries.indexOf(series), 1)
      state.pageState.goToSeries(null) if Store.getters.currentSeriesTitle == series.title

    # Categories

    setCurrentCategory: (state, categoryCode) ->
      state.pageState.goToCategory(categoryCode)
      state.page = 1

    # Layout

    switchToListLayout: (state) ->
      state.layout = LIST_LAYOUT

    switchToGridLayout: (state) ->
      state.layout = GRID_LAYOUT
