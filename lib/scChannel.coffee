############# HOW TO USE ###############
# Set ENV values
# CHANNEL_URL, CHANNEL_KEY
#
# require('./scChannel')
# scChannel.talk(params)
############# HOW TO USE ###############

# Dependent
request = require 'request'

global.scChannel =
  talk: (params) ->
    req = _reqDefault
    req.json = params

    scPrint.channel("Talk #{params.channelName} params: #{JSON.stringify(params.msg)}")
    request.post req, (error, response, body)->
      scErrorsHandle error if error?

_reqDefault =
  url: "#{ENV?.CHANNEL_URL}/talk_in_channel"
  headers:
    channel_key: ENV?.CHANNEL_KEY
