var gulp = require('gulp');
var gutil = require('gulp-util');
var through = require('through2');
var source = require('vinyl-source-stream');
var markdownInclude = require('markdown-include');

gulp.task('default', function () {
   // place code for your default task here
});

gulp.task('makeMarkdownJSONFile', function () {
   var stream = through();
   stream.write('hello world');

   stream.pipe(gulp.dest('./markdown.json'));   
});
