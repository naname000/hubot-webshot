'use strict'
Helper = require('hubot-test-helper')
helper = new Helper('../src/webshot.coffee')
expect = require('chai').expect
#describe 'webshotイベントが発生する', ->
#  @timeout 1000
#  beforeEach ->
#    @room = helper.createRoom(httpd: false)
#  it 'user1がwebshot イオックスと発言、webshotイベントが発生する', (done) ->
#    @room.robot.on 'webshot', ->
#      done()
#    @room.user.say 'user1', 'webshot イオックス'

describe 'webshot-completeイベントが発生する', ->
  @timeout 30000
  beforeEach ->
    @room = helper.createRoom(httpd: false)
  it 'user1がwebshot イオックスと発言、webshot-completeイベントが発生する', (done) ->
    @room.user.say 'user1', 'webshot イオックス'
    console.log 'Handle on webshot-complete'
    @room.robot.on 'webshot-complete', () ->
      done() #TODO 上記コメントアウト部分のテストを動かすとここが呼ばれない。Why

#TODO テストコードリファクタリング
