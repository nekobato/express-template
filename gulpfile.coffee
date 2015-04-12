'use strict'

fs = require('fs')
path = require('path')
gulp = require('gulp')
gutil = require('gulp-util')
watch = require('gulp-watch')
notify = require("gulp-notify")
sourcemaps = require('gulp-sourcemaps')
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
browserify = require('browserify')
coffeeify = require('coffeeify')
transform = require('vinyl-transform')
rename = require("gulp-rename")
uglify = require('gulp-uglify')
watchify = require('watchify')
express = require('gulp-express')
livereload = require('gulp-livereload')


app = require('./package')


#
# Directory structure
#
paths =
  main: './server'
  app: './app'
  views: './views'
  dist:
    scripts: './public/scripts'
    styles:  './public/styles'
    images:  './public/images'
    fonts:   './public/fonts'
  src:
    scripts: './scripts'
    styles:  './styles'
    images:  './images'
    fonts:   './fonts'
    bower:   './bower_components'
  tests: './tests'


#
# Notify handle error
#
handleErrors = () ->
  args = Array.prototype.slice.call(arguments)
  notify.onError
    title: "Compile Error",
    message: "<%= error %>"
  .apply(this, args)

  this.emit('end');

gulp.task 'reload', ->
  gulp.run livereload()


#
# Stylessheets
#
gulp.task 'style', ->
  gulp.src "#{paths.src.styles}/**/*.{sass,scss}"
  .pipe watch("#{paths.src.styles}/**/*.{sass,scss}")
  .pipe sourcemaps.init()
  .pipe sass
    indentedSyntax: true
  .on 'error', handleErrors
  .pipe sourcemaps.write()
  .pipe autoprefixer({ browsers: ['last 2 version'] })
  .pipe gulp.dest(paths.dist.styles)
  # .pipe livereload()


#
# Javascripts
#
gulp.task 'script', () ->

  bundle = transform (filename) ->
    browserify filename,
      extensions: ['.coffee', '.js']
      debug: true
      transform: coffeeify
    .bundle()
    .on 'error', handleErrors

  #
  # bundle = () ->
  #   bundle = transform (filename) ->
  #     bundler.bundle()
  #     .on 'error', handleErrors

  gulp.src "#{paths.src.scripts}/*.coffee"
  .pipe bundle
  .pipe rename
    extname: '.js'
  .pipe sourcemaps.init
    loadMaps: true
  .pipe uglify()
  .pipe sourcemaps.write('./')
  .pipe gulp.dest(paths.dist.scripts)


#
# Express server
#
gulp.task 'server', ->
  express.run
    file: paths.main
    lr:
      port: 3000
    env:
      NODE_ENV: 'development'


#
# Test
#


#
# Tasks
#
gulp.task 'default', ['script'], ->
  # gulp.watch paths.app,          ['server']
  # gulp.watch paths.views,        ['reload']
  # gulp.watch "#{paths.src.styles}/**/*.{sass,scss}", ['style']
  gulp.watch "#{paths.src.scripts}/**/*.{js,coffee}", ['script']
