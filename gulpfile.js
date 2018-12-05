"use strict";

var gulp = require('gulp');
var sass = require('gulp-sass');
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer');

sass.compiler = require('node-sass');

function css() {
  return gulp.src('./Public/styles/styles.scss')
    .pipe(sass())
    .pipe(postcss([
      autoprefixer()
    ]))
    .pipe(
      gulp.dest('./Public/styles/dist')
    );
}

gulp.task('watch', function() {
  gulp.watch('./Public/styles/**.scss', css);
});
