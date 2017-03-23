Vue.component 'edition-details',
  template: '#edition_details_template'

  props:
    edition: { required: true }

  computed:
    coverStyle: ->
      'background-image: url(' + @edition.cover_url + ')'
