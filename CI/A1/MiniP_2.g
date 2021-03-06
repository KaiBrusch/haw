grammar MiniP_2;

main : PROGRAM declaration+ BEGIN statements END
;

declaration 
:	TYPE ids SEMICOL
;

ids :	ID  (COMMA ID)*
;

var_def : ID DEF expression
;

expression :  BOOL | STRING | ar_exp
;
BOOL	:	'true' | 'false'
;


ifStmt	:	'if' (BOOL | cmp ) 'then' statements ('else' statements)? 'fi'
;

whileStmt
:	'while' (BOOL | cmp) 'do' statements 'od'
;

io_stmt	:	('print' | 'println') '(' expression ')'
| 'read(' expression ')'
;
ar_exp
:	product (STRICH_OP product)*
;
product	:	ar_term (PUNKT_OP ar_term)*
;

ar_term	:	ID |  numberconst | '(' ar_exp ')'
;

cmp	:	ar_exp RELOP ar_exp
;

statement
:	ifStmt
|	whileStmt
| io_stmt
| var_def
;

statements
:	statement  (SEMICOL statement)*
;

numberconst
:	INT | FLOAT
;

DEF : ':='
    ;

PUNKT_OP : ('*' | '/')
    ;
    
STRICH_OP : ('+' | '-')
    ;

RELOP : ('=' | '<>' | '<' | '<=' | '>' | '>=')
    ;

PROGRAM :	'program'
;

BEGIN :	'begin'
;

END :	'end'
;

TYPE :	('integer' | 'string' | 'real' | 'boolean')
;

SEMICOL :     ';'
    ;

COMMA    :     ','
    ;

FLOAT
    :   ('0'..'9')+ '.' ('0'..'9')*
    ;
    
INT :	('0'..'9')+
    ;

STRING
    :  '"' ('a'..'z' | 'A'..'Z' | '0'..'9' | ' ')* '"'//'"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    ;

ID  :	('a'..'z' | 'A'..'Z') ('0'..'9' | ('a'..'z' | 'A'..'Z') |'_')*
    ;

COMMENT
    :   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
    ;

WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

fragment
DIGIT	:	('0'..'9')
;

fragment
LETTER :    ('a'..'z' | 'A'..'Z')
    ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') 
;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;