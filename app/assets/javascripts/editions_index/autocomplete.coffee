Vue.component 'autocomplete',
  template: '<input type="text" v-html="value" v-model="currentValue" :placeholder="placeholder">'

  props:
    value: { required: true }
    source: { required: true }
    placeholder: {}

  data: ->
    currentValue: null

  mounted: ->
    @initValuesSync()
    @initAutocomplete()
    @$watch 'source', @initAutocomplete

  methods:
    initValuesSync: ->
      @currentValue = @value
      @$watch 'value', =>
        @currentValue = @value
      $(@$el).on 'keyup', =>
        @$emit('input', @currentValue)

    initAutocomplete: ->
      Vue.nextTick =>
        $(@$el).autocomplete
          source: @source
          minLength: 0
          select: (_, ui) =>
            @$emit('input', ui.item.value)
