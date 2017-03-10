local ffi = require("ffi")
local awesome = ffi.load("./awesome.so")

ffi.cdef([[
typedef long long GoInt64;
typedef unsigned long long GoUint64;
typedef GoInt64 GoInt;
typedef GoUint64 GoUint;
typedef double GoFloat64;

typedef struct { const char *p; GoInt n; } GoString;
typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;

extern GoInt Add(GoInt p0, GoInt p1);
extern GoFloat64 Cosine(GoFloat64 p0);
extern void Sort(GoSlice p0);
extern GoInt Log(GoString p0);
]]);


io.write( string.format("awesome.Add(12, 99) = %f\n", math.floor(tonumber(awesome.Add(12,99)))) )

io.write( string.format("awesome.Cosine(1) = %f\n", tonumber(awesome.Cosine(1))) )

local nums = ffi.new("long long[5]", {12,54,0,423,9})
local numsPointer = ffi.new("void *", nums);
local typeSlice = ffi.metatype("GoSlice", {})
local slice = typeSlice(numsPointer, 5, 5)
awesome.Sort(slice)

io.write("awesome.Sort([12,54,9,423,9] = ")
for i=0,4 do
	if i > 0 then
		io.write(", ")
	end
	io.write(tonumber(nums[i]))
end
io.write("\n");

local typeString = ffi.metatype("GoString", {})
local logString = typeString("Hello LUA!", 10)
awesome.Log(logString)