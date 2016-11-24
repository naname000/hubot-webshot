'use strict'

module.exports = (robot) ->
  options =
    shotOffset:
      left: 10
      top: 180
    shotSize:
      width: 665
      height: 558

  robot.hear /webshot/, id: 'webshot', (res) ->

  robot.listenerMiddleware (context, next, done) ->
    if context.listener.options.id == 'webshot'
      webshot = require('webshot')
      webshot 'http://live.city.nanto.toyama.jp/livecam/index04.jsp', 'yahoooo.png', options, (err) ->
        if err
          throw err
        next done
    else
      next done
