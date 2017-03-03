# For more information see: http://emberjs.com/guides/routing/

App.Router.map ->
  @route 'authors', ->
    @route 'new'
  @route 'books', ->
    @route 'new'
  @route 'index', path: '/'
  @route 'edition', path: '/editions/:edition_id', ->
    @route 'edit'
    @route 'remove'
  @route 'editions', path: '/editions', ->
    @route 'new'
  @route 'publishers', ->
    @route 'new'
