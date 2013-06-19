module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-mocha-test"
  
  grunt.config.data['mocha'] =
    test:
      options:
        reporter: "spec"
        require: "test/coverage/blanket"
      src: [ "test/test.js" ]
    coverage:
      options:
        reporter: "html-cov"
        quiet: true
      src: [ "test/test.js" ]
      dest: "test/coverage/coverage.html"

  grunt.renameTask "mochaTest", "mocha"