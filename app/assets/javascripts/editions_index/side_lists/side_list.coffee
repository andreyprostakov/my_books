Vue.component 'side-list',
  template: '#side_list_template'

  props:
    id: { required: true }

    title: { required: true }

    itemUrl: { required: true }

    anyItemLabel: { required: true }

    items: { type: Object, required: true }

  data: ->
    creationMode: false
    newItemName: null

    searchMode: false
    searchKey: ''

  computed: Vuex.mapState
    filteredItems: ->
      return @items if !@searchMode
      _.pick @items, (item, label) => label.match(new RegExp(@searchKey, 'i'))

    newItemFormRef: ->
      "#{@id}-create-form"

    searchFormRef: ->
      "#{@id}-search-form"

    listIsEmpty: ->
      _.values(@filteredItems).length == 0

    showLinkToAny: ->
      !@creationMode && !@searchMode && _.values(@items).length > 1

  mounted: ->
    @$watch 'items', =>
      @hideForms()

  methods:
    select: (item) ->
      @hideForms()
      @$emit('select', item)

    hideForms: ->
      @hideCreationInput()
      @hideSearchInput()

    showCreationInput: ->
      @hideForms()
      @creationMode = true
      @focusOn(@newItemFormRef)

    hideCreationInput: ->
      @creationMode = false

    showSearchInput: ->
      @searchKey = ''
      @hideForms()
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
