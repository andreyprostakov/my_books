Vue.component 'selection-meta-info',
  template: '#selection_meta_info_template'

  data: ->
    updates:
      read: null
      category: {}
      publisher: {}
      series: {}
    errors: {}

  computed: Vuex.mapState
    editions: 'editions'
    authorName: ->
      @$store.getters.authorName
    publisherName: ->
      @$store.getters.publisherName
    seriesTitle: ->
      @$store.getters.seriesTitle

    editionsCount: ->
      @$store.getters.filteredEditions.length

  methods:
    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')

    deselectAuthor: ->
      @$store.commit('setAuthorName', null)

    deselectPublisher: ->
      @$store.commit('setPublisherName', null)

    deselectSeries: ->
      @$store.commit('setSeriesTitle', null)
