# Description:
#   webshot hogehoge
#   と発言することで、hogehogeに応じた内容でスクリーンショットを撮影、imgurに画像をアップロードし
#   アップロードした画像のURLを発言します。
#   hogehogeに対応するスクリーンショットの動作、及び発言先のキーワードはhubotディレクトリ直下、hubot-webshot.jsonに記述します。
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
#   <trigger> - <what the hear trigger does>
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

  jsonPath = process.cwd() + '/' + 'hubot-webshot.json'

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

  robot.hear /webshot (.+)/, id: 'webshot', (res) ->
    try
      if !fs.existsSync(jsonPath)?
        throw new Error('hubot-webshot.json does not exist.')
      json = JSON.parse(fs.readFileSync(jsonPath, 'utf8'))
      if !json[res.match[1]]?
        throw new Error("#{res.match[1]} is not defined in hubot-webshot.json")
      target = json[res.match[1]]
    catch e
      res.reply "Webshot failed: #{e.message}"
      return
    robot.emit 'webshot', target.url, target.options, target.channel
