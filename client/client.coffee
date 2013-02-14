# An example client for the ChatZone server
$ ->
  user = ""
  $template = $("#template").removeAttr "id"
  # $template.remove()

  appendMessage = (data) ->
    console.log $template.clone()
      .find(".at").text(data.at).end()
      .find(".by").text(data.user).end()
      .find(".msg").text(data.text).end()
      .appendTo("#messages")

  socket = io.connect "localhost"
  socket.on "message", appendMessage
  $("#chat").on "submit", (event) ->
    data =
      at: new Date
      user: user
      text: $("#chat input").val()
    appendMessage data
    $("#chat input").val("")
    console.log data
    return false