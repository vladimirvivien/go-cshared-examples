var ref = require("ref");
var ffi = require("ffi");
var Struct = require("ref-struct")
var ArrayType = require("ref-array")

var GoSlice = Struct({
  data: "void *",
  len:  "longlong",
  cap: "longlong"
});

var awesome = ffi.Library("awesomelib/awesome.so", {
  Add: ["long", ["long", "long"]],
  Cosine: ["double", ["double"]], 
  Sort: ["void", [GoSlice]]
});

console.log("awesome.Add(12, 99) = ", awesome.Add(12, 99));
console.log("awesome.Cosine(1) = ", awesome.Cosine(1));

var longArr = ref.types.longlong
var LongArrType = ArrayType(longArr)
var nums = new LongArrType([53,66,2,12,5])

var slice = new GoSlice
slice["data"] = 
slice["len"] = nums.length
slice["cap"] = nums.length
awesome.Sort(slice)
console.log(nums.toArray())
