'use strict';

module.exports = function (grunt) {
  //grunt.loadNpmTasks('grunt-env');
  grunt.initConfig({
    env: {
      dev: {
        IMGUR_USERNAME: '',
        IMGUR_PASSWORD: '',
        IMGUR_CLIENT_ID: ''
      }
    },
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: 'coffee-script'
        },
        src: ['test/**/*.coffee', 'test/**/*.js']
      }
    },
    release: {
      options: {
        tagName: 'v<%= version %>',
        commitMessage: 'Prepared to release <%= version %>.'
      }
    },
    watch: {
      files: ['Gruntfile.js', 'src/**/*.coffee', 'test/**/*.coffee', 'src/**/*.js', 'test/**/*.js'],
      tasks: ['test']
    }
  });

  // load all grunt tasks
  require('matchdep').filterDev(['grunt-*', '!grunt-cli']).forEach(grunt.loadNpmTasks);

  grunt.registerTask('test', ['env:dev', 'mochaTest']);
  grunt.registerTask('test:watch', ['watch']);
  grunt.registerTask('default', ['test']);
};
