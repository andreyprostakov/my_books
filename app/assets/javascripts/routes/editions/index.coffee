App.EditionsIndexRoute = Ember.Route.extend
  model: ->
    @store.findAll('edition')
