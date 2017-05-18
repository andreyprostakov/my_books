Vue.component 'categories-tabs',
  template: '#categories_tabs_template'

  computed: Vuex.mapState
    currentCategory: 'category'
    editions: 'editions'
    author: 'author'
    publisher: 'publisher'

  methods:
    switchToCategory: (categoryCode) ->
      @$store.commit('setCategory', categoryCode)

    currentCategoryIs: (categoryToCheck) ->
      @currentCategory == categoryToCheck

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category.code == categoryCode)

    anyEditionsOfCategory: (categoryToCheck) ->
      !!@editionsOfCategory(categoryToCheck).length

    urlForCategory: (categoryCode) ->
      Routes.root_path(
        author_name: @author,
        publisher_name: @publisher,
        category_code: categoryCode
      )
