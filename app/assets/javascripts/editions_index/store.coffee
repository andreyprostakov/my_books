window.Store = new Vuex.Store
  state:
    author: null
    publisher: null
    category: null

  mutations:
    setAuthor: (state, author) ->
      state.publisher = null
      state.author = author

    setPublisher: (state, publisher) ->
      state.publisher = publisher
      state.author = null

    setCategory: (state, category) ->
      state.category = category
