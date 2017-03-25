Vue.component 'edition-details',
  template: '#edition_details_template'

  data: ->
    enabled: false
    edition: null

  mounted: ->
    EventsDispatcher.$on 'showEditionDetails', (edition) =>
      @edition = edition
      @show()

  computed:
    canBeShown: ->
      @edition && @enabled
    coverStyle: ->
      'background-image: url(' + @edition.cover_url + ')'

  methods:
    show: ->
      @enabled = true
    close: ->
      @enabled = false
    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author)
      @close()
    switchToPublisher: (publisher) ->
      @$store.commit('setPublisher', publisher)
      @close()
    switchToCategory: (categoryCode) ->
      @$store.commit('setCategory', categoryCode)
      @close()
