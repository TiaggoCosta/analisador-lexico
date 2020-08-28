/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Trabalho GA Tradutores - UNISINOS                                       *
 * Karolina Pacheco                                                        *
 * Nadine Schneider                                                        *
 * Tiago Costa                                                             *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


/**
   Este é o arquivo que contém as regras para geração do analisador léxico
   para o trabalho do GA da disciplina de Tradutores da UNISINOS
*/

%%

%public
%class AnalisadorLexico
%standalone

%unicode

%{
  String test;
%}

LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]
InputCharacter = [^\r\n]

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
Comment = {TraditionalComment} | {EndOfLineComment}

Condition = "if"|"else"|"switch"|"case"
Loop = "do"|"while"|"for"|"break"
Type = "int"|"float"|"double"|"string"|"bool"|"null"|"NULL"
OtherReservedWord = "return"|"void"|"printf"|"scanf"
ReservedWord = {Condition} | {Loop} | {Type} | {OtherReservedWord}


RelationalOperator = "<"|"<="|"=="|"="|">="|">"

Digit = [0-9]
Id = [a-z][a-z0-9]*

%%

/* integers */
{Digit}+ { System.out.println("[num, " + yytext() + "]"); }

/* floats */
{Digit}+"."{Digit}+ { System.out.println("[num, " + yytext() + "]"); }

/* reserved words */
{ReservedWord} { System.out.println("[reserved_word, " + yytext() + "]"); }

/* relational operator */
{RelationalOperator} { System.out.println("[elational_operator, " + yytext() + "]"); }

{WhiteSpace} { /* ignore */ }
{Comment} { /* ignore */ }

/* error fallback */
[^] { System.out.println("Illegal character <" + yytext() + ">"); }
