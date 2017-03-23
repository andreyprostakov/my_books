window.Store = new Vuex.Store
  state:
    author: null
    publisher: null

  mutations:
    setAuthor: (state, author) ->
      state.author = author
    setPublisher: (state, publisher) ->
      state.publisher = publisher
