public class ErrorHandler {
    public void report(String type, int line, int column, String lexeme, String reason) {
        System.err.println(
            "Error Type: " + type +
            ", Line: " + line +
            ", Column: " + column +
            ", Lexeme: '" + lexeme + "'" +
            ", Reason: " + reason
        );
    }
}