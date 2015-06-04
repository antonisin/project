@Air.module 'Accounting.Fine.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.BaseLayout
    template: 'accounting/fine/list/layout'

    regions:
      'fine'  : '#fine'

      'filter':
        selector: '#filter'
        regionType: FadeTransitionRegion

      'new'   :
        selector: '#new'
        regionType: FadeTransitionRegion
