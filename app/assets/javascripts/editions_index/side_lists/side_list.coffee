Vue.component 'side-list',
  template: '#side_list_template'

  props:
    id: { required: true }

    title: { required: true }

    itemUrl: { required: true }

    anyItemLabel: { required: true }

    items: { type: Object, required: true }

  data: ->
    expanded: true
    creationMode: false
    newItemName: null

    searchMode: false
    searchKey: ''

    editedItem: null
    inputItemName: null

  computed: Vuex.mapState
    filteredItems: ->
      return @items if !@searchMode
      _.pick @items, (item, label) => label.match(new RegExp(@searchKey, 'i'))

    newItemFormRef: ->
      "#{@id}-create-form"

    searchFormRef: ->
      "#{@id}-search-form"

  mounted: ->
    @$watch 'items', =>
      @hideCreationInput()
      @hideEditInput()
      @hideSearchInput()

  methods:
    select: (item) ->
      @hideCreationInput()
      @hideEditInput()
      @$emit('select', item)

    expand: ->
      @hideCreationInput()
      @hideEditInput()
      @hideSearchInput()
      @expanded = true

    hide: ->
      @expanded = false
      @select(null)
      @hideCreationInput()
      @hideEditInput()

    showCreationInput: ->
      @expand()
      @creationMode = true
      @focusOn(@newItemFormRef)

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
      @searchKey = ''
      @expand()
      @searchMode = true
      @focusOn(@searchFormRef)

    hideSearchInput: ->
      @searchMode = false

    createNewItem: ->
      @$emit('submit:new-item', @newItemName)

    focusOn: (ref) ->
      Vue.nextTick =>
        element = @$refs[ref]
        element = element[0] || element
        element.focus() if element

    urlForItem: (item) ->
      @itemUrl(item)

    deselect: ->
      @select(null)
