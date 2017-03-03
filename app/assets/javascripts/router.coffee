# For more information see: http://emberjs.com/guides/routing/

App.Router.map ->
  @route 'authors', ->
    @route 'new'
  @route 'books', ->
    @route 'new'
  @route 'index', path: '/'
  @route 'editions', ->
    @route 'new'
    @route 'show', path: '/:edition_id', ->
      @route 'edit'
      @route 'remove'
  @route 'publishers', ->
    @route 'new'
