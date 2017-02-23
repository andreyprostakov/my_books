# For more information see: http://emberjs.com/guides/routing/

App.Router.map ->
  @route('books')
  @route('index', path: '/')
  @route('editions', path: '/editions')
