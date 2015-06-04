Backbone.Marionette.Renderer.render = (template, data) ->
  return if template is false
  path = HAML["_#{template}"]
  unless path
    throw "Template #{template} not found!"
  path data
