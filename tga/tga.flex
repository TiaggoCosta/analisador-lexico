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
WhiteSpace     = {LineTerminator} | [ \t\f]

Digit = [0-9]
Id = [a-z][a-z0-9]*

%%

{Digit}+ { System.out.println("Found digit: " + yytext()); }

{WhiteSpace} { /* ignore */ }

/* error fallback */
[^] { System.out.println("Illegal character <" + yytext() + ">"); }
