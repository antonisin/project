@mixins.logger =
  
  info: (text) ->
    App.execute 'logger:info', text, 'info'
