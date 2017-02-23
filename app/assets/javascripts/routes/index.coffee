App.IndexRoute = Ember.Route.extend
  model: ->
    @store.findAll('edition')
  actions:
    select: (edition) ->
      console.log edition.get('title')
