// A simple syntax-directed translator for a simple language

grammar MyLanguageV1Code;

// Root non-terminal symbol
// A program is a bunch of declarations followed by a bunch of statements
// The Java code outputs the necessary NASM code around these declarations

program       : 
              {System.out.println("%include \"asm_io.inc\"");
               System.out.println("segment .bss"); }
              declaration*
              {System.out.println("segment .text"); 
               System.out.println("\tglobal asm_main"); 
               System.out.println("asm_main:"); 
               System.out.println("\tenter 0,0"); 
               System.out.println("\tpusha"); }
              statement*
              {System.out.println("\tpopa"); 
               System.out.println("\tmov eax,0"); 
               System.out.println("\tleave"); 
               System.out.println("\tret"); } 
	      subprogram*
              ;

// Parse rule for variable declarations

declaration   : 
              {int a; }
              INT a=NAME SEMICOLON
              {System.out.println("\t"+$a.text + "  resd 1");}
              ;

// Parse rule for statements

statement      : 
               ifstmt 
             | printstmt 
             | assignstmt 
	     | leftshift
	     | forloop
	     | funccall
               ;

// QUESTION 4
// Parse rule for subprograms

subprogram	:
		VOID NAME LPAREN RPAREN LCURLY
		{System.out.println($NAME.text + ":");}
		{System.out.println("\tenter 0,0");}
		statement*
		{System.out.println("\tleave");}
		{System.out.println("\tret");}
		RCURLY
		;

// Parse rule for if statements

ifstmt      : 
            {int a,b;} 
            {String label;}
            IF LPAREN a=identifier EQUAL b=integer RPAREN
            {System.out.println("\tcmp dword "+$a.toString+","+$b.toString);
             label = "label_"+Integer.toString($IF.index);
             System.out.println("\tjnz "+label); }
            statement*
            { System.out.println(label+":"); }
            ENDIF

// QUESTION 2

	  | {int a,b;} 
            {String label;}
            IF LPAREN a=identifier NOTEQUAL b=integer RPAREN
            {System.out.println("\tcmp dword "+$a.toString+","+$b.toString);
             label = "label_"+Integer.toString($IF.index);
             System.out.println("\tjz "+label); }
            statement*
            { System.out.println(label+":"); }
            ENDIF
            ;


// Parse rule for print statements

printstmt      : 
               PRINT (printterm COMMA)* printterm SEMICOLON
	       {System.out.println("\tcall print_nl");} 
               ;

// QUESTION 5

printterm	:
		term
		{System.out.println("\tmov eax, "+$term.toString);
                 System.out.println("\tcall print_int");
		 System.out.println("\tmov eax, 32");
		 System.out.println("\tcall print_char");}
               	;

// Parse rule for assignment statements

assignstmt      : 
                {int a; }
                a=NAME ASSIGN expression SEMICOLON 
                {System.out.println("\tmov ["+$a.text+"], eax");} 
                ;

// QUESTION 1
// Parse rule for left shifts

leftshift	:
		NAME LSHIFT INTEGER SEMICOLON
		{System.out.println("\tmov eax, [" + $NAME.text + "]");}
		{System.out.println("\tshl eax, "  + $INTEGER.text); }
		{System.out.println("\tmov [" + $NAME.text + "], eax");}
		;

// QUESTION 3
// Parse rule for for loops

forloop		:
		{int a,b;}
		{String c, d;}
		FOR NAME ASSIGN a=INTEGER COMMA b=INTEGER
		{System.out.println("\tmov dword [" + $NAME.text + "], " + $a.text);}
		{c = "for_"+Integer.toString($FOR.index);}
		{d = "endfor_"+Integer.toString($FOR.index);}
		{System.out.println(c + ":");}
		{System.out.println("\tcmp dword [" + $NAME.text + "], " + $b.text);}
		{System.out.println("\tjg " + d);}
		statement*
		{System.out.println("\tinc dword [" + $NAME.text + "]");}
		{System.out.println("\tjmp " + c);}
		{System.out.println(d + ":");}
		ENDFOR
		;

// QUESTION 4
// Parse rule for function calls

funccall	:
		NAME LPAREN RPAREN SEMICOLON
		{System.out.println("\tcall " + $NAME.text);}
		;

// Parse rule for expressions

expression      : 
                {int a,b; }
                a=term 
                {System.out.println("\tmov eax,"+$a.toString);}
              | 
                a=term PLUS b=term 
                {System.out.println("\tmov eax,"+$a.toString);}
                {System.out.println("\tadd eax,"+$b.toString);}
                ;

// Parse rule for terms

term returns [String toString]  : 
                                identifier {$toString = $identifier.toString;} 
                              | integer {$toString = $integer.toString;} 
                                ;

// Parse rule for identifiers

identifier returns [String toString]: NAME {$toString = "["+$NAME.text+"]";} ;

// Parse rule for numbers 

integer returns [String toString]: INTEGER {$toString = $INTEGER.text;} ;


// Reserved Keywords
////////////////////////////////

IF: 'if';
ENDIF: 'endif';
PRINT: 'print';
INT: 'int';
FOR: 'for';
ENDFOR: 'endfor';

// Operators
PLUS: '+';
EQUAL: '==';
ASSIGN: '=';
NOTEQUAL: '!=';
LSHIFT: '<<';

// Semicolon and parentheses
SEMICOLON: ';';
LPAREN: '(';
RPAREN: ')';

// Commas
COMMA: ',';

// Curly braces
LCURLY: '{';
RCURLY: '}';

// Return type
VOID: 'void';

// Integers
INTEGER: [0-9][0-9]*;

// Variable names
NAME: [a-z]+;   

// Ignore all white spaces 
WS: [ \t\r\n]+ -> skip ; 
