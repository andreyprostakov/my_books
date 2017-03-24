Vue.component 'edition-details',
  template: '#edition_details_template'

  data: ->
    enabled: false
    edition: null

  mounted: ->
    console.log('mounting edition-details')
    EventsDispatcher.$on 'showEditionDetails', (edition) =>
      console.log(edition)
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
