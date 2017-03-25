window.Store = new Vuex.Store
  state:
    author: null
    publisher: null

  mutations:
    setAuthor: (state, author) ->
      state.publisher = null
      state.author = author
    setPublisher: (state, publisher) ->
      state.publisher = publisher
      state.author = null
