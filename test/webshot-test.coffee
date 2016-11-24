'use strict'
Helper = require('hubot-test-helper')
helper = new Helper('../src/webshot.coffee')
Promise = require('bluebird')
co = require('co')
expect = require('chai').expect
describe 'webshot', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)
  describe 'webshot context', ->
    @timeout 30000
    co =>
      yield @room.user.say('user1', 'webshot');

    it 'webshot', ->
      @room.user.say('user1', 'webshot').then ->



