@Air.module 'Monitoring.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Layout extends Air.BaseLayout
    template: 'monitoring/list/layout'
    regions:
      inline  : '#inline'
      inorder : '#inorder'
      outline : '#outline'
