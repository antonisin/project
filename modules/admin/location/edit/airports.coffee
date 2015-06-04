@Air.module 'Admin.Location.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.AirportsController extends App.Base.Controller
    name: 'admin/locations/airports'

    initialize: (opts) ->
      { @collection } = opts

      @show @getView(@collection),
        loading: 
          entities: [@collection]

    getView: (collection) ->
      new Edit.AirportsListView
        collection: collection

  class Edit.AirportsListItemView extends Air.BaseItemView
    template  : 'admin/location/airport_item'
    tagName   : "li"

  class Edit.AirportsListEmptyView extends Air.BaseItemView
    template  : 'admin/location/airport_empty'
    tagName   : 'label'
    className : 'control-label'

  class Edit.AirportsListView extends Air.BaseCompositeView
    template              : 'admin/location/airport_list'
    itemView              : Edit.AirportsListItemView
    emptyView             : Edit.AirportsListEmptyView
    itemViewContainer     : 'ul'

  App.reqres.setHandler 'admin:locations:airports', (opts) =>
    new Edit.AirportsController opts