using System;
using System.Runtime.InteropServices;

class Awesome
{
    const string libName = "awesome";

    public struct GoSlice
    {
        public IntPtr data;
        public long len, cap;
        public GoSlice(IntPtr data, long len, long cap)
        {
            this.data = data;
            this.len = len;
            this.cap = cap;
        }
    }
    public struct GoString
    {
        public string msg;
        public long len;
        public GoString(string msg, long len)
        {
            this.msg = msg;
            this.len = len;
        }
    }

    // Use DllImport to import the Awesome lib.
    [DllImport(libName)]
    public static extern int Add(long a, long b);

    [DllImport(libName)]
    public static extern double Cosine(double a);

    [DllImport(libName)]
    public static extern void Sort(GoSlice a);

    [DllImport(libName, CharSet = CharSet.Unicode)]
    public static extern void Log(GoString msg);

    static void Main()
    {
        long add = Add(12, 99);
        double cosine = Cosine(1);

        long[] data = { 77, 12, 5, 99, 28, 23 };
        IntPtr data_ptr = Marshal.AllocHGlobal(Buffer.ByteLength(data));
        Marshal.Copy(data, 0, data_ptr, data.Length);
        var nums = new GoSlice(data_ptr, data.Length, data.Length);
        Sort(nums);
        Marshal.Copy(nums.data, data, 0, data.Length);

        string msg = "Hello from C#!";
        GoString str = new GoString(msg, msg.Length);

        Console.WriteLine("awesome.Add(12,99) = " + add);
        Console.WriteLine("awesome.Cosine(1) = " + cosine);
        Console.WriteLine("awesome.Sort(77,12,5,99,28,23): " + string.Join(", ", data));
        Log(str);
    }
}
