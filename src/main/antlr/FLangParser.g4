parser grammar FLangParser;

options { tokenVocab=FLangLexer; }

program
    : declaration (SEMI declaration)*
    ;

declaration
    : ID (COLUMN type)? IS expression
    ;

// Expressions
expression
    : secondary
    | expression operatorSign expression
    ;

operatorSign
    : PLUS | MINUS | MULT | DIVISION | LESS | GREATER
    | LESS_EQ | GREATER_EQ | EQUAL | NOT_EQ | AND | OR | XOR
    ;

secondary
    : primary
    | secondary LPAR (expression (COMMA expression)*)? RPAR
    | secondary LSQUARE expression RSQUARE
    | secondary DOT ID
    | secondary DOT INT_LIT
    ;

primary
    : elementary
    | conditional
    | function
    | array
    | tuple
    | map
    | LPAR expression RPAR
    ;

elementary
    : FALSE | TRUE | INT_LIT | REAL_LIT
    | RAT_LIT | COMP_LIT | STR_LIT | ID
    ;


conditional
    : IF expression THEN expression ELSE expression END
    ;

// Statements
statement
    : assignment | functionCall | ifStatement
    | loopStatement | returnStatement | breakStatement
    | printStatement | declaration
    ;

functionCall
    : secondary LPAR (expression (COMMA expression)*)? RPAR
    ;

assignment
    : secondary ASSIGN expression
    ;

ifStatement
    : IF expression THEN statement (ELSE statement)? END
    ;

loopStatement
    : (loopHeader)? LOOP (statement)? END
    ;

loopHeader
    : FOR (ID IN)? expression (DOTDOT expression)?
    | WHILE expression
    ;

returnStatement
    : RETURN (expression)?
    ;

breakStatement
    : BREAK
    ;

printStatement
    : PRINT (expression (COMMA expression)*)?
    ;


// Functions and function types
functionType
    : FUNC LPAR (type (COMMA type)*)? RPAR COLUMN type
    ;

function
    : FUNC LPAR (parameter (COMMA parameter)*)? RPAR (COLUMN type)? body
    ;

parameter
    : ID COLUMN type
    ;

body
    : DO statement END
    | LINE_FUN expression
    ;

// Arrays
arrayType
    : LSQUARE type RSQUARE
    ;

array
    : LSQUARE expression (COMMA expression)* RSQUARE
    ;

// Maps
mapType
    : LCURLY type COLUMN type RCURLY
    ;

map
    : LCURLY pair (COMMA pair)* RCURLY
    ;

pair
    : expression COLUMN expression
    ;

// Tuples
tupleType
    : LPAR type (COMMA type)* RPAR
    ;

tuple
    : LPAR (tupleElement (COMMA tupleElement)*)? RPAR
    ;

tupleElement
    : (ID IS)? expression
    ;


// Atomic types
type
    : booleanType | integerType | realType | rationalType
    | complexType | stringType | functionType
    | tupleType | arrayType | mapType
    ;

booleanType
    : BOOLEAN
    ;

integerType
    : INTEGER
    ;

realType
    : REAL
    ;

rationalType
    : RATIONAL
    ;

complexType
    : COMPLEX
    ;

stringType
    : STRING
    ;

