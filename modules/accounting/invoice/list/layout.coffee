@Air.module 'Accounting.Invoice.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends Air.BaseLayout
    template: 'accounting/invoice/list/layout'

    regions:
      'list':   '#list'
      'filter': '#filter'
