$ ->
  new Vue
    el: '#editions_index'

Vue.component 'editions-index',
  props: [
    'sourceUrl'
  ]

  data: => {
    editions: []
  }

  methods:
    changeReadStatus: (edition) ->
      url = 
      $.ajax(
        type: 'PUT'
        url: Routes.edition_path(edition.id)
        dataType: 'json'
        data: { edition: { read: !edition.read } }
        success: (updated_edition) =>
          edition.read = updated_edition.read
        error: (errors) =>
          console.log('OOPS')
          console.log(errors)
      )

  mounted: ->
    $.getJSON(@sourceUrl, (data) =>
      @editions = data
    )
