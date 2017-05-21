class window.StateMachine
  ALLOWED_ATTRIBUTES = ['editionId', 'authorName', 'publisherName', 'categoryCode']

  constructor: (state = {}) ->
    @state = state
    @prepareEventHandlers()

  setState: (state) ->
    console.log 'setState'
    newState = @filterChanges(state)
    changes = _.omit(newState, (v, k) => @state[k] == newState[k])
    definedChanges = _.mapObject changes, (v, k) =>
      if v == undefined then null else v
    return if _.isEmpty(definedChanges)

    _.each ALLOWED_ATTRIBUTES, (attribute) =>
      newValue = definedChanges[attribute]
      return if _.isUndefined(newValue)
      console.log "Setting #{attribute} to #{newValue}"
      switch attribute
        when 'editionId' then EventsDispatcher.$emit('selectEdition', id: newValue)
        when 'authorName' then state.authorName = newValue
        when 'publisherName' then state.publisherName = newValue
        when 'categoryCode' then state.categoryCode = newValue
        else console.log "WTF is #{attribute}?"

    @state = newState
    console.log 'pushState'
    console.log @state

  changeState: (changes) ->
    filteredChanges = @filterChanges(changes)
    return if _.isEmpty filteredChanges
    updatedState = _.extend(_.clone(@state), filteredChanges)
    @setState(updatedState)
    history.pushState(@state, 'state', @urlForState())

  changedStateUrl: (changes) ->
    state = _.extend(_.clone(@state), @filterChanges(changes))
    @urlForState(state)

  prepareEventHandlers: ->
    window.onpopstate = (event) =>
      console.log 'popState'
      console.log(event.state)
      @setState(event.state || {})

  filterChanges: (changes) ->
    _.pick changes, (v, k) =>
      _.contains(ALLOWED_ATTRIBUTES, k)

  urlForState: (state = null) ->
    state ||= @state
    Routes.root_path
      edition_id: @state.editionId
      author_name: @state.authorName
      publisher_name: @state.publisherName
      category_code: @state.categoryCode
