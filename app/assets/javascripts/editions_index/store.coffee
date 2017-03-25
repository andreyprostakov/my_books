window.Store = new Vuex.Store
  state:
    editions: []
    editionsOrder: null
    author: null
    publisher: null
    category: null

  mutations:
    setEditions: (state, editions) ->
      state.editions = editions

    setEditionsOrder: (state, order) ->
      state.editionsOrder = order

    setAuthor: (state, author) ->
      state.publisher = null
      state.author = author
      state.category = null

    setPublisher: (state, publisher) ->
      state.publisher = publisher
      state.author = null
      state.category = null

    setCategory: (state, category) ->
      state.category = category
