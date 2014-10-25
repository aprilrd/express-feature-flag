'use strict'
gulp = require 'gulp'
$ = require('gulp-load-plugins')()

# Main jobs
gulp.task('test', ->
  gulp.src(['server/**', 'test/**'], { read: false })
    .pipe($.watch({ emit: 'all' }, (files) ->
      files
        .pipe($.grepStream('**/*.mocha.coffee'))
        .pipe($.mocha({ reporter: 'spec' }))
        .on('error', (err) ->
          this.emit('end')
        )
    ))
)

gulp.task('default', ['test'])
