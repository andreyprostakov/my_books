App.IndexRoute = Ember.Route.extend
  model: ->
    @store.findAll('edition')
