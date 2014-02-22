module.exports = (grunt) ->
  grunt.initConfig
    mkdir:
      reports:
        options:
          create: ['reports']
    clean: 
      build: ['lib']
      coverage: ['lib-cov']
      reports: ['reports']
    coffee:
      build:
        expand: true 
        src: ['src/**/*.coffee', 'test/**/*.coffee', 'fixtures/**/*.coffee']
        dest: 'lib'
        ext: '.js'
    copy:
      build:
        src: []
        dest: 'lib/'
      coverage:
        src: ['lib/test/**']
        dest: 'lib-cov/'
    blanket:
      source:
        src: ['lib/src/']
        dest: 'lib-cov/lib/src'
      fixtures:
        src: ['lib/fixtures/']
        dest: 'lib-cov/lib/fixtures'
    mochaTest:
      'spec':
        options: 
          reporter: 'spec'
        src: ['lib-cov/lib/test/**/*.js']
      'html-cov':
        options: 
          reporter: 'html-cov'
          quiet: true
          captureFile: 'reports/coverage.html'
        src: ['lib-cov/lib/test/**/*.js']
      'mocha-lcov-reporter':
        options: 
          reporter: 'mocha-lcov-reporter'
          quiet: true
          captureFile: 'reports/lcov.info'
        src: ['lib-cov/lib/test/**/*.js']
      'travis-cov':
        options:
          reporter: 'travis-cov'
        src: ['lib-cov/lib/test/**/*.js']
    coveralls:
      options:
        force: true
      all:
        src: 'reports/lcov.info'
    watch:
      files: ['src/**/*.coffee', 'test/**/*.coffee', 'mock/**/*.coffee', '../fixtures/**']
      tasks: ['default']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-blanket'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-coveralls'

  grunt.registerTask 'build', [
    'clean:build'
    'copy:build'
    'coffee:build'
  ]

  grunt.registerTask 'coverage', [
    'clean:coverage'
    'build'
    'copy:coverage'
    'blanket'
  ]

  grunt.registerTask 'defaultTest', [
    'mochaTest:spec'
    'mochaTest:html-cov'
    'mochaTest:travis-cov'
  ]

  grunt.registerTask 'ciTest', [
    'mochaTest:spec'
    'mochaTest:mocha-lcov-reporter'
    'mochaTest:travis-cov'
  ]

  grunt.registerTask 'default', [
    'clean:reports'
    'mkdir:reports'
    'coverage'
    'defaultTest'
  ]

  grunt.registerTask 'ci', [
    'clean:reports'
    'mkdir:reports'
    'coverage'
    'ciTest'
    'coveralls'
  ]