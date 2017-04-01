# Description:
#   webshot <keyword>
#   と発言することで、keywordに応じた内容でスクリーンショットを撮影、imgurに画像をアップロードし
#   アップロードした画像のURLを発言します。
#   詳しくはhubot help webshotを御覧ください。
#
# Dependencies:
#   "webshot" : "*"
#   "imgur" : "*"
#
# Configuration:
#   IMGUR_USERNAME imgurアカウントのユーザ名
#   IMGUR_PASSWORD imgurアカウントのパスワード
#   IMGUR_CLIENT_ID imgurアカウントのクライアントID
#
# Commands:
#   hubot webshot <keyword> - keywordに応じたスクリーンショットを撮影、投稿します
#   hubot webshot add <keyword> <url> - スクリーンショットを撮影するURLをキーワードと共に登録します
#   hubot webshot add <keyword> <url> <options> - 撮影オプション付きで登録します。利用可能なオプションはtop left width heightです。オプション名と値をコロン区切りで指定します。ex. (top:10)
#   hubot webshot <url> [<options>] - 一度だけ撮影を行います。オプションの調整など
#   hubot webshot delete <keyword> - 登録されているキーワードを削除します。
#
# Notes:
#
# Author:
#   naname000
'use strict'

module.exports = (robot) ->
  fs = require('fs')
  username = process.env.IMGUR_USERNAME
  password = process.env.IMGUR_PASSWORD
  clientId = process.env.IMGUR_CLIENT_ID

  models = require('../models')
  models.sequelize.sync()

  robot.on 'webshot', (url, options, channel) ->
    webshot = require('webshot')
    imgur = require('imgur')
    imgur.setCredentials username, password, clientId
    stream = webshot url, options
    buffers = []
    stream.on 'data', (buffer) ->
      buffers.push buffer
    stream.on 'error', (err) ->
      #FixMe ErrorHandling
    stream.on 'end', () ->
      data = Buffer.concat(buffers)
      imgur.uploadBase64(data.toString('base64')).then (json) ->
        console.log json.data.link
        robot.messageRoom channel, json.data.link
        robot.emit 'webshot-complete'

  robot.hear /webshot\s(?!(?:https?|add|list|delete))(.+)/,
    id: 'webshot', (res) ->

  robot.hear /webshot\s+add/, (res) ->
    if false == /webshot\s+add\s+((?!http)[^ ]+)\s+(https?\S+)(?:\s((?:left|top|width|height):\d+))*/.test(res.message)
      res.reply 'Webshot Usage: webshot add <keyword> <url>'

  robot.hear /webshot\s+add\s+((?!http)[^ ]+)\s+(https?\S+)(?:\s((?:left|top|width|height):\d+))*/,
    id: 'webshot.add', (res) ->

  robot.hear /webshot\s+(https?\S+)(?:\s((?:left|top|width|height):\d+))*/,
    id: 'webshot.once', (res) ->

  robot.hear /webshot\s+delete\s([^ ]+)/,
    id: 'webshot.delete', (res) ->

  robot.listenerMiddleware (context, next, done) ->
    switch context.listener.options.id
      when 'webshot.once'
        robot.emit(
          'webshot',
          context.response.match[1],
          {
            'shotOffset':
              'left': context.response.match[0].match(/left:(\d+)/)?[1]
              'top': context.response.match[0].match(/top:(\d+)/)?[1]
            'shotSize':
              'width': context.response.match[0].match(/width:(\d+)/)?[1]
              'height': context.response.match[0].match(/height:(\d+)/)?[1]
          }
          context.response.envelope.room
        )
        done()

      when 'webshot'
        models.Target.findAll(where: keyword: context.response.match[1])
        .then (targets) ->
          if 1 < targets.length
            throw new Error('keyword is registered redundantly.')
          if targets.length == 0
            context.response.reply "Webshot failed. #{context.response.match[1]} is not registered."
          if targets.length == 1
            robot.emit(
              'webshot',
              targets[0].url,
              {
                'shotOffset':
                  'left': targets[0].left
                  'top': targets[0].top
                'shotSize':
                  'width': targets[0].width
                  'height': targets[0].height
              }
              targets[0].channel
            )
          done()

      when 'webshot.add'
        models.Target.count(where: keyword: context.response.match[1])
        .then (count) ->
          if 1 < count
            throw new Error('keyword is registered redundantly.')
          if count == 1
            context.response.reply "Webshot add failed. #{context.response.match[1]} is already registered."
            done()
          if count == 0
            models.Target.create({
              keyword: context.response.match[1]
              url: context.response.match[2]
              left: context.response.match[0].match(/left:(\d+)/)?[1]
              top: context.response.match[0].match(/top:(\d+)/)?[1]
              width: context.response.match[0].match(/width:(\d+)/)?[1]
              height: context.response.match[0].match(/height:(\d+)/)?[1]
              channel: context.response.envelope.room})
            .then ->
              context.response.reply "Webshot add succeed."
              # Don't process further middleware.
              done()

      when 'webshot.delete'
        models.Target.destroy(where: keyword: context.response.match[1])
        .then (num) ->
          if 1 < num
            throw new Error('keyword is registered redundantly.')
          if num == 1
            context.response.reply "Webshot delete succeed."
            done()
          if num == 0
            context.response.reply "Webshot delete failed. #{context.response.match[1]} is not registered."
            done()

      else
        next(done)


