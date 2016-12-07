class EditionForm
  constructor: (form) ->
    @$form = $(form)
    @_initAutocompletes()

  _initAutocompletes: ->
    for input in @$form.find('[data-autocomplete]')
      @_initInputAutocomplete(input)
    @$form.on('cocoon:after-insert', (_, insertedItem) =>
      for input in $(insertedItem).find('[data-autocomplete]')
        @_initInputAutocomplete(input)
    )

  _initInputAutocomplete: (input) ->
    $input = $(input)
    return unless $input.data('autocomplete')
    $input.autocomplete(
      source: $input.data('values'),
      minLength: 2
    )

$ ->
  form = $('#edition_form')
  new EditionForm(form) if form.length
