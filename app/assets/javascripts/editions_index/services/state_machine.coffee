class window.StateMachine
  ALLOWED_ATTRIBUTES = ['editionId', 'authorName', 'publisherName', 'categoryCode', 'seriesTitle']

  constructor: (state = {}) ->
    @state = state
    @prepareEventHandlers()

  setState: (state) ->
    state = @filterStateAttributes(state)
    state = @filterStateValues(state)
    @state = state

  changeState: (changes) ->
    filteredChanges = @filterStateAttributes(changes)
    return if _.isEmpty filteredChanges
    updatedState = _.extend(_.clone(@state), filteredChanges)
    return if _.isEqual(@state, updatedState)
    @setState(updatedState)
    history.pushState(@state, 'state', @urlForState())

  prepareEventHandlers: ->
    window.onpopstate = (event) =>
      @setState(event.state || {})
      window.scrollTo(0, 0)

  filterStateAttributes: (attributes) ->
    _.pick attributes, (v, k) =>
      _.contains(ALLOWED_ATTRIBUTES, k)

  filterStateValues: (state) ->
    _.mapObject state, (v, k) =>
      if v == undefined then null else v

  goToEdition: (id) ->
    @changeState(editionId: id)

  urlForEdition: (id) ->
    @changedStateUrl(editionId: id)

  goToCategory: (categoryCode) ->
    @changeState(@stateForCategory(categoryCode))

  urlForCategory: (categoryCode) ->
    @changedStateUrl(@stateForCategory(categoryCode))

  stateForCategory: (categoryCode) ->
    categoryCode: categoryCode
    editionId: null

  goToAuthor: (authorName) ->
    @changeState(@stateForAuthor(authorName))

  urlForAuthor: (authorName) =>
    @urlForState(@stateForAuthor(authorName))

  stateForAuthor: (authorName) ->
    authorName: authorName
    editionId: null

  goToPublisher: (publisherName) ->
    @changeState(@stateForPublisher(publisherName))

  urlForPublisher: (publisherName) =>
    @urlForState(@stateForPublisher(publisherName))

  stateForPublisher: (publisherName) ->
    publisherName: publisherName
    editionId: null

  goToSeries: (seriesTitle) ->
    @changeState(@stateForSeries(seriesTitle))

  urlForSeries: (seriesTitle) =>
    @urlForState(@stateForSeries(seriesTitle))

  stateForSeries: (seriesTitle) ->
    seriesTitle: seriesTitle
    editionId: null

  changedStateUrl: (changes) ->
    filteredChanges = @filterStateAttributes(changes)
    state = _.extend(_.clone(@state), filteredChanges)
    @urlForState(state)

  urlForState: (state = null) ->
    state = @filterStateAttributes(state || @state)
    Routes.root_path
      edition_id: state.editionId
      author_name: state.authorName
      publisher_name: state.publisherName
      category_code: state.categoryCode
      series_title: state.seriesTitle
