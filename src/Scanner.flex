%%
import java.io.*;

%%
%class Yylex
%public
%unicode
%line
%column
%type Token

%{
    private ErrorHandler errorHandler = new ErrorHandler();

    private Token makeToken(TokenType type) {
        return new Token(type, yytext(), yyline + 1, yycolumn + 1);
    }
%}

DIGIT       = [0-9]
LETTER      = [a-zA-Z]
ID          = {LETTER}({LETTER}|{DIGIT})*
INT         = {DIGIT}+
FLOAT       = {DIGIT}+"."{DIGIT}+
WHITESPACE  = [ \t\r\n]+

STRING      = \"([^\"\\]|\\.)*\"
CHAR        = \'([^\'\\]|\\.)\'

LINE_COMMENT = "//".*
BLOCK_COMMENT = "/*"([^*]|\*+[^*/])*\*+"/"

%%
{WHITESPACE}        { }
{LINE_COMMENT}     { }
{BLOCK_COMMENT}    { }

"if"        { return makeToken(TokenType.IF); }
"else"      { return makeToken(TokenType.ELSE); }
"while"     { return makeToken(TokenType.WHILE); }
"return"    { return makeToken(TokenType.RETURN); }

"=="        { return makeToken(TokenType.EQ); }
"!="        { return makeToken(TokenType.NEQ); }
"<="        { return makeToken(TokenType.LE); }
">="        { return makeToken(TokenType.GE); }
"="         { return makeToken(TokenType.ASSIGN); }
"+"         { return makeToken(TokenType.PLUS); }
"-"         { return makeToken(TokenType.MINUS); }
"*"         { return makeToken(TokenType.MUL); }
"/"         { return makeToken(TokenType.DIV); }

{FLOAT}     { return makeToken(TokenType.FLOAT_LITERAL); }
{INT}       { return makeToken(TokenType.INT_LITERAL); }
{STRING}    { return makeToken(TokenType.STRING_LITERAL); }
{CHAR}      { return makeToken(TokenType.CHAR_LITERAL); }

{ID} {
    if (yytext().length() > 31) {
        errorHandler.report("Invalid Identifier", yyline + 1, yycolumn + 1, yytext(), "Identifier too long");
        return null;
    }
    return makeToken(TokenType.IDENTIFIER);
}

. {
    errorHandler.report("Invalid Character", yyline + 1, yycolumn + 1, yytext(), "Unrecognized symbol");
}