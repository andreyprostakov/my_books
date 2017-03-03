App.EditionsShowRoute = Ember.Route.extend
  model: (params) ->
    @store.findRecord('edition', params.edition_id)
