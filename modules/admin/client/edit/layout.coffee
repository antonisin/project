@Air.module 'Admin.Client.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.EditLayout extends App.BaseLayout
    template: 'admin/client/edit'
    regions:
      hits: '#hits'

    initialize: ->
      ua = UAParser @model.get('browser')

      @model.set 'browser', ua.browser.name
      @model.set 'os', ua.os.name
      @model.set 'device', "#{ua.device.type or ''} #{ua.device.model or ''}"

    dialog: ->
      title  : App.request('lang:get', 'client:view:title')
      buttons: {save: false, close: true, yes: false, no: false}

    onShow: ->
      @$("#ip-info").popover()
