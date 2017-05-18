Vue.component 'side-list',
  template: '#side_list_template'

  props:
    title: { required: true }
    preselectedItem: { default: null }

    loadMethodName: { required: true }
    itemsName: { required: true }
    selectedItemName: { required: true }
    mutationItemName: { required: true }

    createItemUrl: {}
    updateItemUrl: {}
    removeItemUrl: {}

  data: ->
    toggledExpanded: false
    creationMode: false
    newItemName: null

    searchMode: false
    searchKey: ''

    editedItem: null
    inputItemName: null

  computed: Vuex.mapState
    selectedItem: (state) ->
      state[@selectedItemName]

    expanded: ->
      @toggledExpanded || @selectedItem

    filteredItems: ->
      return @items if !@searchMode
      @items.filter((i) => i.name.match(new RegExp(@searchKey, 'i')))

    items: ->
      @$store.state[@itemsName]

  mounted: ->
    @loadItems()
    EventsDispatcher.$on 'editionCreated', @loadItems

  methods:
    mounted: ->
      @select(@preselectedItem)

    loadItems: ->
      DataRefresher[@loadMethodName]().then (items) =>
        @$store.commit('set' + @mutationItemName + 's', items)

    currentItemIs: (item) ->
      (item || {name: null}).name == @selectedItem

    select: (item) ->
      @hideCreationInput()
      @hideEditInput()
      @$store.commit('set' + @mutationItemName, (item || {name: null}).name)
      @expand() if item

    expand: ->
      @toggledExpanded = true

    hide: ->
      @toggledExpanded = false
      @select(null)
      @hideCreationInput()
      @hideEditInput()

    showCreationInput: ->
      @hideEditInput()
      @hideSearchInput()
      @creationMode = true
      @expand()
      @focusOn(@selectedItemName + '-create')

    hideCreationInput: ->
      @creationMode = false

    showEditInput: (item) ->
      @hideCreationInput()
      @hideSearchInput()
      @inputItemName = item.name
      @editedItem = item
      @focusOn(@selectedItemName + '-edit-' + item.id)

    hideEditInput: ->
      @editedItem = null

    showSearchInput: ->
      @hideEditInput()
      @hideCreationInput()
      @searchKey = ''
      @searchMode = true
      @expand()
      @focusOn(@selectedItemName + '-search')

    hideSearchInput: ->
      @searchMode = false

    createNewItem: ->
      $.ajax(
        type: 'POST'
        url: @createItemUrl()
        dataType: 'json'
        data: @requestDataWithItemName(@newItemName)
        success: (createdItem) =>
          @$store.commit('add' + @mutationItemName, createdItem)
          @hideCreationInput()
          @newItemName = null
        error: @handleErrorResponse
      )

    updateItemName: (item) ->
      $.ajax(
        type: 'PUT'
        url: @updateItemUrl(item.id)
        dataType: 'json'
        data: @requestDataWithItemName(@inputItemName)
        success: (updatedItem) =>
          @$store.commit('update' + @mutationItemName, updatedItem)
          @hideEditInput()
        error: @handleErrorResponse
      )

    removeItem: (item) ->
      $.ajax(
        type: 'DELETE'
        url: @removeItemUrl(item.id)
        dataType: 'json'
        success: =>
          @$store.commit('remove' + @mutationItemName, item)
        error: @handleErrorResponse
      )

    requestDataWithItemName: (itemName) ->
      data = {}
      data[@selectedItemName] = { name: itemName }
      data

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)

    focusOn: (ref) ->
      Vue.nextTick =>
        element = @$refs[ref]
        element = element[0] || element
        element.focus() if element

    urlForItem: (item) ->
      params = {}
      params[@selectedItemName + '_name'] = item.name
      Routes.root_path(params)
