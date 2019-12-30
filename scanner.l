%{
#include <stdio.h>
#include <stdlib.h>
#include "scan.h"

enum TokenType {ELSE_TK=300, IF_TK, INT_TK, RETURN_TK, VOID_TK, WHILE_TK, SEMICOL_TK,
		COMMA_TK, LPARA_TK, RPARA_TK, LBRACKET_TK, RBRACKET_TK, LBRACE_TK, 
		RBRACE_TK, LCOMMENT_TK, RCOMMENT_TK, ADDOP, MULOP, RELOP, ASGNOP, ID, NUM};
enum OpType {ADD=1, SUB, MUL, DIV, EQ, NE, LT, LE, GT, GE, ASGN};

int line = 1;
int pos = 0;
int epos = 1;
int total_errors = 0;
OpType op;
void lex_err(char*, char*);
int yywrap();
bool lex_init(char*, char*);
%}
letter			[a-zA-Z]
digit			[0-9]
blank_str		[ \t]+
identifier		{letter}({letter}|{digit})*(("."|"#"|"$"|"_")?({letter}|{digit})+)?
number			({digit}+|{digit}+"."{digit}*)((e|E)(+|-)?{digit}+)?
operator		"+"|"-"|"*"|"/"|"<"|">"|"<="|">="|"=="|"!="|"="
valid_symbol	[{letter}{digit}{blank_str}{operator}";"",""("")""[""]""{""}"".""#""$""_"]
invalid_id		{letter}({letter}|{digit})*("."|"#"|"$"|"_")([^{letter}]|[^{digit}])
invalid_num		({digit}+|{digit}+"."{digit}*)(e|E)(+|-)? [^{digit}]
invalid_symbol	[^{valid_symbol}]
%%                
\n				line++; epos = 1;
{blank_str}		epos += yyleng;
{identifier}		pos = epos; epos += yyleng; return ID;
{number}			pos = epos; epos += yyleng; return NUM;
[eE][lL][sS][eE]	pos = epos; epos += 4; return ELSE_TK;				
[iI][fF]			pos = epos; epos += 2; return IF_TK;
[iI][nN][tT]		pos = epos; epos += 3; return INT_TK;
[rR][eE][tT][uU][rR][nN]	pos = epos; epos += 6; return RETURN_TK;
[vV][oO][iI][dD]		pos = epos; epos += 4; return VOID_TK;
[wW][hH][iI][lL][eE]		pos = epos; epos += 5; return WHILE_TK;				
"+"					op = ADD; pos = epos; epos += 1; return ADDOP;			
"-"					op = SUB; pos = epos; epos += 1; return ADDOP;
"*"					op = MUL; pos = epos; epos += 1; return MULOP;
"/"					op = DIV; pos = epos; epos += 1; return MULOP;
"<"					op = LT; pos = epos; epos += 1; return RELOP;
"<="				op = LE; pos = epos; epos += 2; return RELOP;
">"					op = GT; pos = epos; epos += 1; return RELOP;
">="				op = GE; pos = epos; epos += 2; return RELOP;
"=="				op = EQ; pos = epos; epos += 2; return RELOP;
"!="				op = NE; pos = epos; epos += 2; return RELOP;
"="					op = ASGN; pos = epos; epos += 1; return ASGNOP;
";"					pos = epos; epos += 1; return SEMICOL_TK;
","					pos = epos; epos += 1; return COMMA_TK;
"("					pos = epos; epos += 1; return LPARA_TK;
")"					pos = epos; epos += 1; return RPARA_TK;
"["					pos = epos; epos += 1; return LBRACKET_TK;
"]"					pos = epos; epos += 1; return LBRACKET_TK;
"{"					pos = epos; epos += 1; return LBRACE_TK;
"}"					pos = epos; epos += 1; return RBRACE_TK;
"/*"				{	int c;
						int start_line = line;
						int pos = epos;
						epos += 2;
						c = yyinput();
						epos++;
						while(c != EOF){
							if(c == '\n') {line++; epos =1;}
							if(c == '*') {
								c = yyinput();
								epos++;
								if(c == '/') break;
								else continue;
							}
							c = yyinput();
							epos++;
						}
						if(c == EOF){
							int eof_line = line;
							line = start_line;
							lex_err("Unclosed Comment", "");
							line = eof_line;
						}
						return LCOMMENT_TK;
					}
"*/"				pos = epos; epos += 1; return RCOMMENT_TK;
{invalid_id}		{	lex_err("Invalid Identifier", "");
						pos = epos; epos += yyleng; 
						return ID;
					}
{invalid_num}		{	lex_err("Invalid Number", "");
						pos = epos; epos += yyleng; 
						return NUM;
					}
{invalid_symbol}	{	lex_err("Invalid Symbol", "");
						pos = epos; epos += 1; 
					}	
.					{	lex_err("Invalid Symbol", "");
						pos = epos; epos += 1; 
					}
%%
void lex_err(char* s1, char* s2){
	fprintf(stderr, "line %d, character %d:\t%s%s\n", line, pos, s1, s2);
	total_errors++;
}
int yywrap(){
	return 1;
}
bool lex_init(char* srcfile, char* outfile){
	yyin = fopen(srcfile, "r");
	yyout = fopen(outfile, "w");
	bool done = true;
	if(yyin == 0){
		fprintf(stderr, "Can't open %s\n", srcfile);
		done = false;
	}
	if(yyout == false){
		fprintf(stderr, "Can't write to %s", outfile);
		done = false;
	}
	return done;
}
int main(int argc, char **argv) {
        ++argv; --argc;  
        if (argc > 0) {
            yyin = fopen(argv[0], "r");
        } else {
            yyin = stdin;
        }
        yylex();
	return 0;
    }