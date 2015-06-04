@Air.module 'Accounting.Transfer.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.BaseLayout
    template: 'accounting/transfer/list/layout'

    regions:
      'list'  : '#list'
      'filter': '#filter'
      'new'   :
        selector: '#new'
        regionType: FadeTransitionRegion