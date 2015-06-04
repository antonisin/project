@Air.module 'Admin.Landings.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.Layout extends Air.BaseLayout
    template: 'admin/landing/edit/layout'
    regions:
      landing     : '#landing'
      landingItems: '#landingItems'