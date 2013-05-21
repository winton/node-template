# Update package.json and rename project.

module.exports = (grunt) ->

  grunt.registerTask(
    "setup"
    [
      "package"
      "replace"
      "rename"
    ]
  )