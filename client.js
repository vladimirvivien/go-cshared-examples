var ffi = require('ffi');

var awesome = ffi.Library('awesomelib/awesome.so', {
  'Cosine': ['double', ['double']]
});

console.log(awesome.Cosine(1));
