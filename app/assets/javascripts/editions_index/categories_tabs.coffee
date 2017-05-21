Vue.component 'categories-tabs',
  template: '#categories_tabs_template'

  computed: Vuex.mapState
    currentCategory: ->
      @$store.getters.categoryCode
    editions: 'editions'
    pageState: 'pageState'

  methods:
    switchToCategory: (categoryCode) ->
      @$store.commit('setCategoryCode', categoryCode)

    currentCategoryIs: (categoryToCheck) ->
      @currentCategory == categoryToCheck

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    anyEditionsOfCategory: (categoryToCheck) ->
      !!@editionsOfCategory(categoryToCheck).length

    urlForCategory: (categoryCode) ->
      @pageState.changedStateUrl
        categoryCode: categoryCode
