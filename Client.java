import com.sun.jna.Library;
import com.sun.jna.Native;

public class Cos {
    public interface Awesome extends Library {
        public double Cosine(double val);
    }
 
   static public void main(String argv[]) {
        Awesome awesome = (Awesome) Native.loadLibrary("awesomelib/awesome.so", Awesome.class);
        System.out.print(awesome.Cosine(1.0));
    }
}
