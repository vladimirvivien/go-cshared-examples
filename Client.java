import com.sun.jna.*;
import java.util.*;
import java.lang.Long;

public class Client {
   public interface Awesome extends Library {
        // GoSlice class maps to:
        // C typedef struct { void *data; GoInt len; GoInt cap; }
        public class GoSlice extends Structure {
            public static class ByValue extends GoSlice implements Structure.ByValue {}
            public Pointer data;
            public long len;
            public long cap;
            protected List getFieldOrder(){
                return Arrays.asList(new String[]{"data","len","cap"});
            }
        }

        // GoString class maps to:
        // C typedef struct { const char *p; GoInt n; }
        public class GoString extends Structure {
            public static class ByValue extends GoString implements Structure.ByValue {}
            public String p;
            public long n;
            protected List getFieldOrder(){
                return Arrays.asList(new String[]{"p","n"});
            }

        }

        // Foreign functions
        public long Add(long a, long b);
        public double Cosine(double val);
        public void Sort(GoSlice.ByValue vals);
        public long Log(GoString.ByValue str);
    }
 
   static public void main(String argv[]) {
        Awesome awesome = (Awesome) Native.loadLibrary(
            "awesomelib/awesome.so", Awesome.class);

        System.out.printf("awesome.Add(12, 99) = %s\n", awesome.Add(12, 99));
        System.out.printf("awesome.Cosine(1.0) = %s\n", awesome.Cosine(1.0));
        
        // Call Sort
        // First, prepare data array 
        long[] nums = new long[]{53,11,5,2,88};
        Memory arr = new Memory(nums.length * Native.getNativeSize(Long.TYPE));
        arr.write(0, nums, 0, nums.length); 
        // fill in the GoSlice class for type mapping
        Awesome.GoSlice.ByValue slice = new Awesome.GoSlice.ByValue();
        slice.data = arr;
        slice.len = nums.length;
        slice.cap = nums.length;
        awesome.Sort(slice);
        System.out.print("awesome.Sort(53,11,5,2,88) = [");
        long[] sorted = slice.data.getLongArray(0,nums.length);
        for(int i = 0; i < sorted.length; i++){
            System.out.print(sorted[i] + " ");
        }
        System.out.println("]");

        // Call Log
        Awesome.GoString.ByValue str = new Awesome.GoString.ByValue();
        str.p = "Hello Java!";
        str.n = str.p.length();
        System.out.printf("msgid %d\n", awesome.Log(str));

    }
}
