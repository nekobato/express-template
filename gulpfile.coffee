'use strict'

gulp = require('gulp')
sass = require('gulp-sass')
server = require('gulp-express')
express = require('gulp-express')
browserify = require('gulp-browserify')
livereload = require('gulp-livereload')
autoprefixer = require('gulp-autoprefixer')

paths =
  main: './app/server'
  app: './app/**/*'
  dist:
    js:  './public/javascripts/'
    css: './public/stylesheets/'
  src:
    js:  './scripts/*.coffee'
    css: './styles/*.{sass,scss}'

gulp.task 'reload', ->
  gulp.run livereload()

gulp.task 'sass', ->
  gulp.src paths.src.css
  .pipe sass()
  .pipe autoprefixer()
  .pipe gulp.dest(paths.dist.css)
  .pipe livereload()

gulp.task 'script', ->
  gulp.src paths.src.js
  .pipe browserify
    transform:  ['coffeeify']
    extensions: ['.coffee']
    debug: true
  .pipe gulp.dest paths.dist.js
  .pipe livereload()

gulp.task 'server', ->
  express.run
    file: paths.main
    lr:
      port: 3000
    env:
      NODE_ENV: 'development'
  .pipe livereload()

gulp.task 'default', ['sass', 'script', 'server'], ->
  gulp.watch paths.app,     ['server']
  gulp.watch paths.views,   ['reload']
  gulp.watch paths.src.css, ['sass']
  gulp.watch paths.src.js,  ['script']
