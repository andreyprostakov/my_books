Vue.component 'categories-tabs',
  template: '#categories_tabs_template'

  computed: Vuex.mapState
    currentCategory: 'category'
    editions: 'editions'

  methods:
    switchToCategory: (categoryCode) ->
      @$store.commit('setCategory', categoryCode)
      EventsDispatcher.$emit('categoryChanged')

    currentCategoryIs: (categoryToCheck) ->
      @currentCategory == categoryToCheck

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    anyEditionsOfCategory: (categoryToCheck) ->
      !!@editionsOfCategory(categoryToCheck).length
