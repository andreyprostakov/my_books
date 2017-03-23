Vue.component 'side-list',
  template: '#side_list_template'

  props:
    title: { required: true }
    items: { required: true }
    preselectedItem: { default: null }

    selectedItemName: { required: true }
    mutationForSelect: { required: true }

    newItemUrl: {}
    editItemUrl: {}
    removeItemUrl: {}

  data: ->
    toggledExpanded: false

  computed: Vuex.mapState
    selectedItem: (state) ->
      state[@selectedItemName]

    expanded: ->
      @toggledExpanded || @selectedItem

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
