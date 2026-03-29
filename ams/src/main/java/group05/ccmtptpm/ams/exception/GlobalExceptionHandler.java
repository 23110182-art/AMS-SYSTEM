package group05.ccmtptpm.ams.exception;

import group05.ccmtptpm.ams.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // 1. Custom exception
    @ExceptionHandler(CustomException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiResponse<?> handleCustomException(CustomException ex) {
        return ApiResponse.builder()
                .success(false)
                .message(ex.getMessage())
                .data(null)
                .build();
    }

    // 2. Validation exception
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiResponse<?> handleValidationException(MethodArgumentNotValidException ex) {

        String errorMessage = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .findFirst()
                .map(err -> err.getDefaultMessage())
                .orElse("Validation error");

        return ApiResponse.builder()
                .success(false)
                .message(errorMessage)
                .data(null)
                .build();
    }

    // 3. General exception
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ApiResponse<?> handleException(Exception ex) {
        return ApiResponse.builder()
                .success(false)
                .message("Internal server error")
                .data(null)
                .build();
    }

    // 4. access denied exception
    @ExceptionHandler(org.springframework.security.access.AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ApiResponse<?> handleAccessDeniedException(org.springframework.security.access.AccessDeniedException ex) {
        return ApiResponse.builder()
                .success(false)
                .message("Forbidden")
                .data(null)
                .build();
    }
}