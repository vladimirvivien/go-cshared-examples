require 'ffi'

# Module that represents shared lib
module Awesome
  extend FFI::Library
  
  ffi_lib './awesome.so'
  
  # define class GoSlice to map to:
  # C type struct { void *data; GoInt len; GoInt cap; }
  class GoSlice < FFI::Struct
    layout :data,  :pointer,
           :len,   :long_long,
           :cap,   :long_long
  end

  # define class GoString to map:
  # C type struct { const char *p; GoInt n; }
  class GoString < FFI::Struct
    layout :p,     :pointer,
           :len,   :long_long
  end

  # foreign function definitions
  attach_function :Add, [:long_long, :long_long], :long_long
  attach_function :Cosine, [:double], :double
  attach_function :Sort, [GoSlice.by_value], :void
  attach_function :Log, [GoString.by_value], :int
end

# Call Add
print "awesome.Add(12, 99) = ",  Awesome.Add(12, 99), "\n"

# Call Cosine
print "awesome.Cosine(1) = ", Awesome.Cosine(1), "\n"

# call Sort
nums = [92,101,3,44,7]
ptr = FFI::MemoryPointer.new :long_long, nums.size
ptr.write_array_of_long_long  nums
slice = Awesome::GoSlice.new
slice[:data] = ptr
slice[:len] = nums.size
slice[:cap] = nums.size
Awesome.Sort(slice)
sorted = slice[:data].read_array_of_long_long nums.size
print "awesome.Sort(", nums, ") = ", sorted, "\n"

# Call Log
msg = "Hello Ruby!"
gostr = Awesome::GoString.new
gostr[:p] = FFI::MemoryPointer.from_string(msg) 
gostr[:len] = msg.size
print "logid ", Awesome.Log(gostr), "\n"
