require 'ffi'

# Module to define shared lib
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
# Prepare type mapping for
# C typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;
# Create poninter to array
nums = [92,101,3,44,7]
ptr = FFI::MemoryPointer.new :long_long, nums.size
ptr.write_array_of_long_long  nums
# Create new GoSlice object to map to struct
slice = Awesome::GoSlice.new
slice[:data] = ptr
slice[:len] = nums.size
slice[:cap] = nums.size
Awesome.Sort(slice)
# retrieve sorted data
sorted = slice[:data].read_array_of_long_long nums.size
print "awesome.Sort(", nums, ") = ", sorted, "\n"

# Call Log
# Prepare type mapping for 
# typedef struct { const char *p; GoInt n; } GoString;
msg = "Hello Ruby!"
str = Awesome::GoString.new
str[:p] = FFI::MemoryPointer.from_string(msg) 
str[:len] = msg.size
print "logid ", Awesome.Log(str), "\n"
