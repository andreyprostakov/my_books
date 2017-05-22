Vue.component 'side-list',
  template: '#side_list_template'

  props:
    title: { required: true }
    preselectedItem: { default: null }

    loadMethodName: { required: true }
    collectionName: { required: true }
    currentItemMethodName: { required: true }
    setAllMethodName: { required: true }
    selectItemMethodName: { require: true }

    itemKeyAttribute: { required: true }
    singleItemName: { required: true }
    pascalItemName: { required: true }
    pluralItemName: { required: true }

    apiItemUrl: { required: true }
    apiIndexUrl: { required: true }
    selectItemUrl: { required: true }

    anyItemLabel: { required: true }

  data: ->
    toggledExpanded: false
    creationMode: false
    newItemName: null

    searchMode: false
    searchKey: ''

    editedItem: null
    inputItemName: null

  computed: Vuex.mapState
    selectedItem: ->
      @$store.getters[@currentItemMethodName]

    expanded: ->
      @toggledExpanded || @selectedItem

    filteredItems: ->
      return @items if !@searchMode
      @items.filter((i) => i[@itemKeyAttribute].match(new RegExp(@searchKey, 'i')))

    items: ->
      @$store.state[@collectionName]

  mounted: ->
    @loadItems()
    EventsDispatcher.$on 'editionCreated', @loadItems
    EventsDispatcher.$on 'editionUpdated', @loadItems

    @$watch 'selectedItem', =>
      @toggledExpanded = true if @selectedItem

  methods:
    mounted: ->
      @select(@preselectedItem)

    keyForItem: (item) ->
      item[@itemKeyAttribute]

    loadItems: ->
      DataRefresher[@loadMethodName]().then (items) =>
        @$store.commit(@setAllMethodName, items)

    currentItemIs: (item) ->
      if item
        item[@itemKeyAttribute] == @selectedItem
      else
        @selectedItem == null

    select: (item) ->
      @hideCreationInput()
      @hideEditInput()
      if item
        @$store.commit(@selectItemMethodName, item[@itemKeyAttribute])
      else
        @$store.commit(@selectItemMethodName, null)
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
      @focusOn(@singleItemName + '-create')

    hideCreationInput: ->
      @creationMode = false

    showEditInput: (item) ->
      @hideCreationInput()
      @hideSearchInput()
      @inputItemName = item[@itemKeyAttribute]
      @editedItem = item
      @focusOn(@singleItemName + '-edit-' + item.id)

    hideEditInput: ->
      @editedItem = null

    showSearchInput: ->
      @hideEditInput()
      @hideCreationInput()
      @searchKey = ''
      @searchMode = true
      @expand()
      @focusOn(@singleItemName + '-search')

    hideSearchInput: ->
      @searchMode = false

    createNewItem: ->
      $.ajax(
        type: 'POST'
        url: @apiIndexUrl()
        dataType: 'json'
        data: @requestDataWithItemName(@newItemName)
        success: (createdItem) =>
          @$store.commit("add#{@pascalItemName}", createdItem)
          @hideCreationInput()
          @newItemName = null
        error: @handleErrorResponse
      )

    updateItemName: (item) ->
      $.ajax(
        type: 'PUT'
        url: @apiItemUrl(item.id)
        dataType: 'json'
        data: @requestDataWithItemName(@inputItemName)
        success: (updatedItem) =>
          @$store.commit("update#{@pascalItemName}", updatedItem)
          @hideEditInput()
        error: @handleErrorResponse
      )

    removeItem: (item) ->
      $.ajax(
        type: 'DELETE'
        url: @apiItemUrl(item.id)
        dataType: 'json'
        success: =>
          @$store.commit("remove#{@pascalItemName}", item)
        error: @handleErrorResponse
      )

    requestDataWithItemName: (itemName) ->
      data = {}
      data[@singleItemName] = {}
      data[@singleItemName][@itemKeyAttribute] = itemName
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
      @selectItemUrl(item[@itemKeyAttribute])
