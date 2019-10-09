import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

// - foreign function interface in dart 2.5 does not allow calls using structures 
// so converted them to pointers

// - macOS blocks loading function without matching signature of the dart binary
// so removed dart binary signature by running "codesign --remove-signature dart"

class GoSlice extends Struct<GoSlice> {
  Pointer<Int64> data;

  @Int64()
  int len;

  @Int64()
  int cap;

  List<int> toList() {
    List<int> units = [];
    for (int i = 0; i < len; ++i) {
      units.add(data.elementAt(i).load<int>());
    }
    return units;
  }

  static Pointer<GoSlice> fromList(List<int> units) {
    final ptr = Pointer<Int64>.allocate(count: units.length);
    for (int i =0; i < units.length; ++i) {
      ptr.elementAt(i).store(units[i]);
    }
    final GoSlice slice = Pointer<GoSlice>.allocate().load();
    slice.data = ptr;
    slice.len = units.length;
    slice.cap = units.length;
    return slice.addressOf;
  }
}

class GoString extends Struct<GoString> {
  Pointer<Uint8> string;

  @IntPtr()
  int length;

  String toString() {
    List<int> units = [];
    for (int i = 0; i < length; ++i) {
      units.add(string.elementAt(i).load<int>());
    }
    return Utf8Decoder().convert(units);
  }

  static Pointer<GoString> fromString(String string) {
    List<int> units = Utf8Encoder().convert(string);
    final ptr = Pointer<Uint8>.allocate(count: units.length);
    for (int i = 0; i < units.length; ++i) {
      ptr.elementAt(i).store(units[i]);
    }
    final GoString str = Pointer<GoString>.allocate().load();
    str.length = units.length;
    str.string = ptr;
    return str.addressOf;
  }
}

typedef add_func = Int64 Function(Int64, Int64);
typedef Add = int Function(int, int);
typedef cosine_func = Double Function(Double);
typedef Cosine = double Function(double);
typedef log_func = Int64 Function(Pointer<GoString>);
typedef Log = int Function(Pointer<GoString>);
typedef sort_func = Void Function(Pointer<GoSlice>);
typedef Sort = void Function(Pointer<GoSlice>);

void main(List<String> args) {

  final awesome = DynamicLibrary.open('awesome.so');

  final Add add = awesome.lookup<NativeFunction<add_func>>('Add').asFunction();
  stdout.writeln("awesome.Add(12, 99) = ${add(12, 99)}");

  final Cosine cosine = awesome.lookup<NativeFunction<cosine_func>>('Cosine').asFunction();
  stdout.writeln("awesome.Cosine(1) = ${cosine(1.0)}");

  final Log log = awesome.lookup<NativeFunction<log_func>>('LogPtr').asFunction();
  final Pointer<GoString> message = GoString.fromString("Hello, Dart!");
  try {
    log(message);
  }
  finally {
    message.free();
  }

  final Sort sort = awesome.lookup<NativeFunction<sort_func>>('SortPtr').asFunction();
  var nums = [12,54,0,423,9];
  final Pointer<GoSlice> slice = GoSlice.fromList(nums);
  try {
    sort(slice);
    stdout.writeln(slice.load<GoSlice>().toList());
  } finally {
    slice.free();
  }

  for (int i=0; i < 100000; i++) {
    Pointer<GoString> m = GoString.fromString("Hello, Dart!");
    Pointer<GoSlice> s = GoSlice.fromList(nums);
    print("$m $s");
    m.free();
    s.free();
  }

  stdin.readByteSync();
}

