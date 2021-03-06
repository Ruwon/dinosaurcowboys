# Dinosaur Cowboys Namespace.
NS = window.DinosaurCowboys ||= {}

class NS.MumbleBrowser
  constructor: (element, @host, @port) ->
    @element = $(element)

    @element.find('.refresh').click (e) =>
      e.preventDefault()
      @update()

    if @element.length
      interval = 10  # Seconds.
      NS.setIntervalAndExecute(interval * 1000, => @update())

  populate: (data) ->
    @element.find('ul.channels').empty()

    $(data['root']['channels']).each (i, channel) =>
      populateChannel(@element.find('ul.channels'), channel)

      hasSubChannelAndUsers = channel['channels'].length &&
        !(channel['channels'].every (c) -> c['users'].length == 0)

      if hasSubChannelAndUsers
        insert = @element.find("ul.channels #channel_#{channel['id']}")
        insert.append("<ul class='sub-channels'></ul>")
        $(channel['channels']).each (i, sub_channel) ->
          populateChannel(insert.find('.sub-channels'), sub_channel)

  typefrag: (callback) ->
    host  = 'http://www.typefrag.com'
    route = '/server-status/mumble/ChannelViewerProtocol.aspx'
    params =
      'ReturnType': 'json',
      'HostName': @host,
      'PortNumber': @port
    $.get host + route, params, (data) ->
      callback(data)

  update: ->
    @element.find('.title ul li a i').removeClass('fa-exclamation-triangle')
    @element.find('.title ul li a i').addClass('fa-refresh')
    @element.find('.title ul li a i').addClass('fa-spin')
    xhr = @typefrag (data) =>
      NS.setTimeout 500, =>  # UX
        @populate(data)
        @element.find('.title ul li a i').removeClass('fa-spin')
    xhr.fail =>
      @element.find('.title ul li a i').removeClass('fa-spin')
      @element.find('.title ul li a i').removeClass('fa-refresh')
      @element.find('.title ul li a i').addClass('fa-exclamation-triangle')

  # Private

  populateChannel = (parent, channel) ->
    hasSubChannelUsers = false
    $(channel['channels']).each (i, sub_channel) ->
      hasSubChannelUsers ||= sub_channel['users'].length

    if channel['users'].length || hasSubChannelUsers
      p  = "<p class='title'>#{channel['name']}</p>"
      li = "<li id='channel_#{channel['id']}' class='channel'>#{p}</li>"

      insert = $(li)
      parent.append(insert)

      if channel['users'].length
        insert.append("<ul class='users'></ul>")
        $(channel['users']).each (i, user) ->
          userIcon = "<i class='fa fa-user'></i>"
          otherIcons = ""
          if user['deaf'] || user['selfDeaf']
            otherIcons += "<i class='fa fa-headphones'></i> "
          if user['mute'] || user['selfMute']
            otherIcons += "<i class='fa fa-microphone-slash'></i> "

          u = "<li class='user'>#{userIcon} #{user['name']} #{otherIcons}</li>"
          insert.find('.users').append(u)
