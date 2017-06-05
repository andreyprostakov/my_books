Vue.component 'order-select',
  template: '#order_select_template'

  data: ->
    notReadOnly: false

  props:
    initialOrder: { required: true }

  mounted: ->
    @$store.commit('setEditionsOrder', @initialOrder)
    @$watch 'notReadOnly', =>
      @$store.commit('showOnlyNotRead', @notReadOnly)

  computed: Vuex.mapState
    currentOrder: 'editionsOrder'
    openedEdition: 'openedEdition'

  methods:
    onSelect: ->
      @$store.commit('setEditionsOrder', event.target.value)

    currentOrderIs: (orderToCheck) ->
      @currentOrder == orderToCheck
