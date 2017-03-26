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
    editedItem: null
    inputItemName: null

  computed: Vuex.mapState
    selectedItem: (state) ->
      state[@selectedItemName]

    expanded: ->
      @toggledExpanded || @selectedItem

  mounted: ->
    @items = @initialItems

  methods:
    mounted: ->
      @select(@preselectedItem)

    currentItemIs: (item) ->
      (item || {name: null}).name == @selectedItem

    select: (item) ->
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
      @creationMode = true
      @expand()
      @focusOn(@selectedItemName + '-create')

    hideCreationInput: ->
      @creationMode = false

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

    editItemName: (item) ->
      @hideCreationInput()
      @inputItemName = item.name
      @editedItem = item
      @focusOn(@selectedItemName + '-edit-' + item.id)

    hideEditInput: ->
      @editedItem = null

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
