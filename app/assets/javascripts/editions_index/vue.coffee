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
      $.ajax(
        type: 'PUT'
        url: Routes.edition_path(edition.id)
        dataType: 'json'
        data: { edition: { read: !edition.read } }
        success: (updated_edition) =>
          edition.read = updated_edition.read
        error: @handleErrorResponse
      )

    editionUrl: (edition) ->
      Routes.edition_path(edition.id)

    editEditionUrl: (edition) ->
      Routes.edit_edition_path(edition.id)

    removeEdition: (edition) ->
      $.ajax(
        type: 'DELETE'
        url: Routes.edition_path(edition.id)
        dataType: 'json'
        success: =>
          console.log 'removed'
          @editions.splice(@editions.indexOf(edition), 1)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)

  mounted: ->
    $.getJSON(@sourceUrl, (data) =>
      @editions = data
    )
