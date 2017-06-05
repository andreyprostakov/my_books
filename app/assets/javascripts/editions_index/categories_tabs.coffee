Vue.component 'categories-tabs',
  template: '#categories_tabs_template'

  computed: Vuex.mapState
    currentCategory: ->
      @$store.getters.currentCategory
    editions: 'editions'

  methods:
    switchToCategory: (categoryCode) ->
      @$store.commit('setCurrentCategory', categoryCode)

    currentCategoryIs: (categoryToCheck) ->
      @currentCategory == categoryToCheck

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    anyEditionsOfCategory: (categoryToCheck) ->
      !!@editionsOfCategory(categoryToCheck).length

    urlForCategory: (categoryCode) ->
      @$store.state.pageState.urlForCategory(categoryCode)
