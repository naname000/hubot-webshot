'use strict';

module.exports = function(robot) {
  robot.hear(/webshot/, {id:'webshot'}, function(res) {
  });
  return robot.listenerMiddleware(
    function(context, next, done) {
      console.log(context.listener.options.id);
      if(context.listener.options.id == 'webshot') {
        const webshot = require('webshot');
        const options = {
          shotOffset: {
            left: 108,
            //right: 769,
            top: 219,
            //bottom: 769
          },
          shotSize: {
            width: 500,
            height: 500
          }
        };
        webshot('http://live.city.nanto.toyama.jp/livecam/index04.jsp',
          'yahoooo.png', options, function (err) {
          done();
        });
      }
    }
  );
};
