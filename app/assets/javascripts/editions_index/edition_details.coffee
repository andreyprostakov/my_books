Vue.component 'edition-details',
  template: '#edition_details_template'

  data: ->
    enabled: false
    edition: null

  mounted: ->
    EventsDispatcher.$on 'showEditionDetails', (edition) =>
      DataRefresher.loadEditionDetails(edition).then (detailedEdition) =>
        @edition = detailedEdition
        @show()

  computed: Vuex.mapState
    editions: 'editions'
    canBeShown: ->
      @edition && @enabled

    coverStyle: ->
      'background-image: url(' + (@edition.remote_cover_url || @edition.cover_url) + ')'

    currentEditionIndex: ->
      @editions.findIndex((e) => e.id == @edition.id)

    rightPageNumber: ->
      @currentEditionIndex * 2

    leftPageNumber: ->
      @rightPageNumber + 1

    canSwitchToPrievousEdition: ->
      @currentEditionIndex > 0

    canSwitchToNextEdition: ->
      @currentEditionIndex < (@editions.length - 1)

  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author.name)
      @close()

    switchToPublisher: (publisher) ->
      @$store.commit('setPublisher', publisher.name)
      @close()

    switchToCategory: (category) ->
      @$store.commit('setCategory', category.code)
      @close()

    switchToNextEdition: ->
      return unless @canSwitchToNextEdition
      EventsDispatcher.$emit 'showEditionDetails', (@editions[@currentEditionIndex + 1])

    switchToPreviousEdition: ->
      return unless @canSwitchToPrievousEdition
      EventsDispatcher.$emit 'showEditionDetails', (@editions[@currentEditionIndex - 1])

    editEdition: ->
      @close()
      EventsDispatcher.$emit('editEdition', @edition)
