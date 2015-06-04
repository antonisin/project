class Air.BaseBehavior extends Marionette.Behavior
  collectionSave: (url, data) ->
    formData = new FormData()
    data = JSON.stringify @array
    formData.append "collection", data

    xhr = new XMLHttpRequest()
    xhr.open("POST", Config.routePrefix + url, true)
    xhr.send(formData)
