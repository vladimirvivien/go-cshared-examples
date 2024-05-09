const std = @import("std");

const go_int = i64;
const go_float = f64;
const go_str = []const u8;
const go_slice = extern struct {
    data: *[]go_int,
    len: go_int,
    cap: go_int,
};
var Add: *const fn (a: go_int, b: go_int) go_int = undefined;
var Cosine: *const fn (n: go_float) go_float = undefined;
var SortPtr: *const fn (nums: *go_slice) void = undefined;
var Log: *const fn (str: go_str) go_int = undefined;

pub fn main() !void {
    // use dlopen to load shared object
    var awesome = try std.DynLib.open("./awesome.so");
    // close file handle when done
    defer awesome.close();

    // resolve Add symbol and assign to fn ptr
    Add = awesome.lookup(@TypeOf(Add), "Add") orelse return error.LookupFail;
    // call Add()
    std.debug.print("awesome.Add(12,99) = {d}\n", .{Add(12, 99)});

    // resolve Cosine symbol
    Cosine = awesome.lookup(@TypeOf(Cosine), "Cosine") orelse return error.LookupFail;
    // Call Cosine
    std.debug.print("awesome.Cosine(1) = {d}\n", .{Cosine(1.0)});

    // resolve SortPtr symbol
    SortPtr = awesome.lookup(@TypeOf(SortPtr), "SortPtr") orelse return error.LookupFail;
    const data = [5]go_int{ 44, 23, 7, 66, 2 };
    const nums = go_slice{ .data = @ptrCast(@constCast(&data)), .len = data.len, .cap = data.len };
    // call SortPtr
    SortPtr(@ptrCast(@constCast(&nums)));
    std.debug.print("awesome.SortPtr(44,23,7,66,2): ", .{});
    for (@as(*align(1) const [nums.len]go_int, @ptrCast(nums.data))) |n| {
        std.debug.print("{d},", .{n});
    }
    std.debug.print("\n", .{});

    // resolve Log symbol
    Log = awesome.lookup(@TypeOf(Log), "Log") orelse return error.LookupFail;
    // call Log
    _ = Log("Hello from Zig!");
}
