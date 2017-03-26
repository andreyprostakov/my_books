Vue.component 'side-list',
  template: '#side_list_template'

  props:
    title: { required: true }
    initialItems: { required: true }
    preselectedItem: { default: null }

    selectedItemName: { required: true }
    mutationForSelect: { required: true }

    createItemUrl: {}
    updateItemUrl: {}
    removeItemUrl: {}

  data: ->
    items: []
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

  mounted: ->
    @items = @initialItems

  methods:
    mounted: ->
      @select(@preselectedItem)

    currentItemIs: (item) ->
      (item || {name: null}).name == @selectedItem

    select: (item) ->
      @hideCreationInput()
      @hideEditInput()
      @$store.commit(@mutationForSelect, (item || {name: null}).name)
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
          @items.splice(0, 0, createdItem)
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
          Vue.set(@items, @items.indexOf(item), updatedItem)
          @hideEditInput()
        error: @handleErrorResponse
      )

    removeItem: (item) ->
      $.ajax(
        type: 'DELETE'
        url: @removeItemUrl(item.id)
        dataType: 'json'
        success: =>
          @items.splice(@items.indexOf(item), 1)
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
