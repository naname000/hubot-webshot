'use strict'
# Description:
#   webshot hogehoge
#   と発言することで、hogehogeに応じた内容でスクリーンショットを撮影、imgurに画像をアップロードし
#   アップロードした画像のURLを発言します。
#   hogehogeに対応するスクリーンショットの動作、及び発言先のキーワードはhubot-webshot.jsonに記述します。
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
#   hubot <keyword> - keywordに応じたスクリーンショットを撮影、投稿します
#   <trigger> - <what the hear trigger does>
#
# Notes:
#
# Author:
#   naname000
module.exports = (robot) ->
  options =
    shotOffset:
      left: 10
      top: 180
    shotSize:
      width: 665
      height: 558

  username = process.env.IMGUR_USERNAME
  password = process.env.IMGUR_PASSWORD
  clientId = process.env.IMGUR_CLIENT_ID

  robot.hear /webshot/, id: 'webshot', (res) ->

  robot.listenerMiddleware (context, next, done) ->
    if context.listener.options.id == 'webshot'
      webshot = require('webshot')
      stream = webshot 'http://live.city.nanto.toyama.jp/livecam/index04.jsp', options
      imgur = require('imgur')
      imgur.setCredentials username, password, clientId

      buffers = []
      stream.on 'data', (buffer) ->
        buffers.push buffer
      stream.on 'error', (err) ->
        robot.send context.response.message.user, "Webshot Failed."
        next done
      stream.on 'end', () ->
        data = Buffer.concat(buffers)
        imgur.uploadBase64(data.toString('base64')).then (json) ->
          robot.send context.response.message.user, json.data.link
          next done
    else
      next done

