const std = @import("std");
const awesome = @cImport({
    @cInclude("awesome.h");
});

pub fn main() !void {
    //Call Add() - passing integer params, interger result
    const a: awesome.GoInt = 12;
    const b: awesome.GoInt = 99;
    std.debug.print("awesome.Add(12,99) = {d}\n", .{awesome.Add(a, b)});

    //Call Cosine() - passing float param, float returned
    std.debug.print("awesome.Cosine(1) = {d}\n", .{awesome.Cosine(1.0)});

    //Call SortPtr() - converting the array and passing as GoSlice pointer
    const data = [6]awesome.GoInt{ 77, 12, 5, 99, 28, 23 };
    const nums = awesome.GoSlice{ .data = @ptrCast(@constCast(&data)), .len = data.len, .cap = data.len };
    awesome.SortPtr(@ptrCast(@constCast(&nums)));
    std.debug.print("awesome.SortPtr(77,12,5,99,28,23): ", .{});
    for (@as(*align(1) const [nums.len]awesome.GoInt, @ptrCast(nums.data))) |n| {
        std.debug.print("{d},", .{n});
    }
    std.debug.print("\n", .{});

    //Call Log() - passing string value
    const msg = awesome.GoString{ .p = "Hello from Zig!", .n = 16 };
    _ = awesome.Log(msg);
}
