package conduitApp;

//import com.intuit.karate.Results;
//import com.intuit.karate.Runner;
//import static org.junit.jupiter.api.Assertions.*;
//import org.junit.jupiter.api.Test;

import com.intuit.karate.junit5.Karate;

class conduitTest {

    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }

}
