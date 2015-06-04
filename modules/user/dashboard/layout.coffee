@Air.module "User.Dashboard", (Dashboard, App, Backbone, Marionette, $, _) ->

  class Dashboard.Layout extends Air.BaseLayout
    template: 'dashboard/layout'

    regions:
      header      : '#header'
      tasks       : '#tasks'
      statistics  : '#statistics'
      race        : '#race'