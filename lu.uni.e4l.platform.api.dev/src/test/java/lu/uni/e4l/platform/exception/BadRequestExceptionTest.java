package lu.uni.e4l.platform.exception;

import lu.uni.e4l.platform.exception.BadRequestException;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class BadRequestExceptionTest {

    @Test
    public void testBadRequestException() {
        String message = "Test BadRequestException";
        BadRequestException exception = new BadRequestException(message);

        assertEquals(message, exception.getMessage());
    }
}
