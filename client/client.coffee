# An example client for the ChatZone server
$ ->
  user = ""
  $template = $("#template").removeAttr "id"
  $chat =  $('#chat input[name=chat]')
  $handle = $('#chat input[name=handle]')

  $template.remove()

  getHandle = ->
    $handle.val()

  appendMessage = (data) ->
    time = new Date(data.at)
    timestamp = "#{time.getHours()}:#{time.getMinutes()}:#{time.getSeconds()}"
    $template.clone()
      .find(".at").text(timestamp).end()
      .find(".by").text(data.user).end()
      .find(".msg").text(data.text).end()
      .appendTo("#messages")

    $(window).scrollTop($chat.offset().top)

  socket = do io.connect 
  socket.on "message", appendMessage

  $("#chat").on "submit", (event) ->
    data = { text: $chat.val() }

    $chat.val("")
    appendMessage
      user: getHandle()
      text: data.text
      at: new Date

    socket.emit "message", data
    return false

  $handle.on "change", (event) ->
    user =
      name: getHandle()
    socket.emit "set", user
