require 'ffi'

module Awesome
  extend FFI::Library
  ffi_lib 'awesomelib/awesome.so'
  class GoSlice < FFI::Struct
    layout :data,  :pointer,
           :len,   :long_long,
           :cap,   :long_long
  end
  class GoString < FFI::Struct
    layout :p,     :pointer,
           :len,   :long_long
  end

  attach_function :Add, [:long_long, :long_long], :long_long
  attach_function :Cosine, [:double], :double
  attach_function :Sort, [GoSlice.by_value], :void
end

print "awesome.Add(12, 99) = ",  Awesome.Add(12, 99), "\n"
print "awesome.Cosine(1) = ", Awesome.Cosine(1), "\n"

# call Sort
# First prepare data mapping for
# C typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;
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
