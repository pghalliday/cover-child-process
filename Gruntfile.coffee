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
        src: ['src/**/*.coffee', 'test/**/*.coffee', 'mocks/**/*.coffee', 'fixtures/**/*.coffee']
        dest: 'lib'
        ext: '.js'
    copy:
      coverage:
        src: ['lib/test/**']
        dest: 'lib-cov/'
      fixtures:
        src: ['lib/fixtures/**']
        dest: 'lib-cov/'
    instrument:
      files: ['src/**/*.js', 'mocks/**/*.js']
      options:
        cwd: 'lib/'
        lazy: true
        basePath: 'lib-cov/lib/'
    mochaTest:
      spec:
        options:
          reporter: 'spec'
        src: ['lib-cov/lib/test/**/*.js']
    storeCoverage:
      options:
        dir: 'reports'
    makeReport:
      src: 'reports/**/*.json'
      options:
        type: 'lcov'
        dir: 'reports'
        print: 'detail'
    coverage:
      default:
        options:
          thresholds:
            'statements': 100
            'branches': 80
            'lines': 100
            'functions': 100
          dir: 'reports'
    coveralls:
      options:
        force: true
      all:
        src: 'reports/lcov.info'
    watch:
      files: ['src/**', 'test/**', 'mocks/**', 'fixtures/**']
      tasks: ['default']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-istanbul'
  grunt.loadNpmTasks 'grunt-istanbul-coverage'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-coveralls'

  grunt.registerTask 'build', [
    'clean:build'
    'coffee:build'
  ]

  grunt.registerTask 'buildCoverage', [
    'clean:coverage'
    'build'
    'copy'
    'instrument'
  ]

  grunt.registerTask 'test', [
    'mochaTest:spec'
    'storeCoverage'
    'makeReport'
    'coverage'
  ]

  grunt.registerTask 'default', [
    'clean:reports'
    'mkdir:reports'
    'buildCoverage'
    'test'
  ]

  grunt.registerTask 'ci', [
    'default'
    'coveralls'
  ]
