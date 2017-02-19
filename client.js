var ref = require("ref");
var ffi = require("ffi");
var Struct = require("ref-struct")
var ArrayType = require("ref-array")

var longlong = ref.types.longlong;
var LongArray = ArrayType(longlong);

// define object GoSlice to map to:
// C type struct { void *data; GoInt len; GoInt cap; }
var GoSlice = Struct({
  data: LongArray,
  len:  "longlong",
  cap: "longlong"
});

// define object GoString to map:
// C type struct { const char *p; GoInt n; }
var GoString = Struct({
  p: "string",
  n: "longlong"
});

// define foreign functions
var awesome = ffi.Library("./awesome.so", {
  Add: ["longlong", ["longlong", "longlong"]],
  Cosine: ["double", ["double"]], 
  Sort: ["void", [GoSlice]],
  Log: ["longlong", [GoString]]
});

// call Add
console.log("awesome.Add(12, 99) = ", awesome.Add(12, 99));

// call Cosine
console.log("awesome.Cosine(1) = ", awesome.Cosine(1));

// call Sort
nums = LongArray([12,54,0,423,9]);
var slice = new GoSlice();
slice["data"] = nums;
slice["len"] = 5;
slice["cap"] = 5;
awesome.Sort(slice);
console.log("awesome.Sort([12,54,9,423,9] = ", nums.toArray());

// call Log
str = new GoString();
str["p"] = "Hello Node!";
str["n"] = 11;
awesome.Log(str);
