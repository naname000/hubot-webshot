'use strict'
Helper = require('hubot-test-helper')
helper = new Helper('../src/webshot.coffee')
expect = require('chai').expect

url = 'http://live.city.nanto.toyama.jp/livecam/index04.jsp'
keyword = 'イオックス'
addMessage = "webshot add #{keyword} #{url}"
left = 10
top = 180
height = 558
width = 665

addMessageWithParams = "#{addMessage} left:#{left} top:#{top} height:#{height} width:#{width}"
deleteMessage = "webshot delete #{keyword}"

describe.skip 'webshot-completeイベントが発生する', ->
  @timeout 30000
  before ->
    @models = require('../models')
    @room = helper.createRoom(httpd: false)
    return @models.sequelize.sync(force: true) #データベース初期化

  it "user1 says \'#{addMessageWithParams}\' and webshot #{keyword}", (done) ->
    @room.robot.on 'webshot-complete', () ->
      done()
    @room.user.say('user1', addMessageWithParams)
    .then =>
      @room.user.say('user1', "webshot #{keyword}")
    console.log 'Handle on webshot-complete'

describe 'webshot add,deleteを発言するとデータベースに登録,削除される事を検証する', ->
  @timeout 2000
  before ->
    @models = require('../models')
    @room = helper.createRoom(httpd: false)
    return @models.sequelize.sync(force: true) #データベース初期化

  beforeEach ->

  it "user1 says \'#{addMessage}\'", ->
    @room.user.say('user1', addMessage)
    .then =>
      @models.Target.findOne(where: keyword: keyword)
      .then (target) =>
        expect(target.keyword).to.equal(keyword)
        expect(target.url).to.equal(url)

  it "user1 says \'#{deleteMessage}\'", ->
    @room.user.say('user1', deleteMessage)
    .then =>
      @models.Target.count(where: keyword: keyword)
      .then (count) =>
        expect(count).to.equal(0)

  it "user1 says \'#{addMessageWithParams}\'", ->
    @room.user.say('user1', addMessageWithParams)
    .then =>
      @models.Target.findOne(where: keyword: keyword)
      .then (target) =>
        expect(target.keyword).to.equal(keyword)
        expect(target.url).to.equal(url)
        expect(target.left).to.equal(left)
        expect(target.top).to.equal(top)
        expect(target.width).to.equal(width)
        expect(target.height).to.equal(height)
        expect(target.channel).to.equal(@room.name)

  it "user1 says \'#{deleteMessage}\'", ->
    @room.user.say('user1', deleteMessage)
    .then =>
      @models.Target.count(where: keyword: keyword)
      .then (count) =>
        expect(count).to.equal(0)


describe 'webshot add,deleteを発言してレスポンスを検証する', ->
  before ->
    @models = require('../models')
    @room = helper.createRoom(httpd: false)
    return @models.sequelize.sync(force: true)

  beforeEach ->

  it 'webshot add and delete', ->
    @room.user.say('user1', addMessage).then =>
      @room.user.say('user1', addMessage).then =>
        @room.user.say('user1', deleteMessage).then =>
          @room.user.say('user1', deleteMessage).then =>
            expect(@room.messages).to.eql(
              [
                ['user1', addMessage]
                ['hubot', '@user1 Webshot add succeed.']
                ['user1', addMessage]
                ['hubot', "@user1 Webshot add failed. #{keyword} is already registered."]
                ['user1', deleteMessage]
                ['hubot', '@user1 Webshot delete succeed.']
                ['user1', deleteMessage]
                ['hubot', "@user1 Webshot delete failed. #{keyword} is not registered."]
              ]
            )

describe 'webshot http://...を発言してwebshotイベントが発生することを検証する', ->
  before (done) ->
    @models = require('../models')
    @room = helper.createRoom(httpd: false)
    @models.sequelize.sync(force: true)
    .then ->
      done()
    return undefined

  it 'user1 says webshot http://www.yahoo.co.jp and options...', ->
    eventCount = 0
    @room.robot.on 'webshot', () ->
      eventCount++
    @room.user.say('user1', 'webshot http://www.yahoo.co.jp').then =>
      @room.user.say('user1', 'webshot http://www.yahoo.co.jp left:10 top:10 width:10 height:10').then =>
        expect(eventCount).to.equal(2)
        expect(@room.messages).to.eql(
          [
            ['user1', 'webshot http://www.yahoo.co.jp']
            ['user1', 'webshot http://www.yahoo.co.jp left:10 top:10 width:10 height:10']
          ]
        )

describe.only 'webshot ggl ...を発言してwebshotイベントが発生することを検証する', ->
  @timeout 20000
  before (done) ->
    @models = require('../models')
    @room = helper.createRoom(httpd: false)
    @models.sequelize.sync(force: true)
    .then ->
      done()
    return undefined

  it 'user1 says webshot ggl ...', (done) ->
    @room.robot.on 'webshot-complete', () ->
      done()
    @room.user.say('user1', 'webshot ggl hogehoge').then =>
      expect(@room.messages).to.eql(
        [
          ['user1', 'webshot ggl hogehoge']
        ]
      )
    # MochaはPromiseをreturnするとdoneメソッドが使えない。CoffeeScriptは最終行が勝手にreturn.
    return undefined
