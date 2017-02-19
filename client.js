var ref = require("ref");
var ffi = require("ffi");
var Struct = require("ref-struct")
var ArrayType = require("ref-array")

var longlong = ref.types.longlong;
var LongArray = ArrayType(longlong);

var GoSlice = Struct({
  data: LongArray,
  len:  "longlong",
  cap: "longlong"
});

var GoString = Struct({
  p: "string",
  n: "longlong"
});

var awesome = ffi.Library("awesomelib/awesome.so", {
  Add: ["longlong", ["longlong", "longlong"]],
  Cosine: ["double", ["double"]], 
  Sort: ["void", [GoSlice]],
  Log: ["longlong", [GoString]]
});

console.log("awesome.Add(12, 99) = ", awesome.Add(12, 99));
console.log("awesome.Cosine(1) = ", awesome.Cosine(1));

nums = LongArray([12,54,0,423,9]);
var slice = new GoSlice();
slice["data"] = nums;
slice["len"] = 5;
slice["cap"] = 5;
awesome.Sort(slice);
console.log(nums.toArray());

str = new GoString();
str["p"] = "Hello Node!";
str["n"] = 11;
awesome.Log(str);
