@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  API = 
    send: (opts) ->
      $.ajax  opts.url, 
        type: opts.type
        data: opts.data
        dataType: 'json'
        error: opts.error
        success: opts.success


  App.commands.setHandler 'ajax:post', (opts) ->
    opts.type = 'post'
    API.send opts

  App.commands.setHandler 'ajax:get', (opts) ->
    opts.type = 'get'
    API.send opts