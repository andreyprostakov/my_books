Vue.component 'order-select',
  template: '#order_select_template'

  props:
    initialOrder: { required: true }

  mounted: ->
    @$store.commit('setEditionsOrder', @initialOrder)

  computed: Vuex.mapState
    currentOrder: 'editionsOrder'

  methods:
    onSelect: ->
      @$store.commit('setEditionsOrder', event.target.value)

    currentOrderIs: (orderToCheck) ->
      @currentOrder == orderToCheck
