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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

%%

%public
%class AnalisadorLexico
%standalone

%unicode

%{
	static int scope = 0;
  	static int identifierCount = 0;
	static Map<String, Integer> identifiers = new HashMap<String, Integer>();
	static Map<String, Integer> identifierScope = new HashMap<String, Integer>();
	 
	private static void printIdentifier(String word) {
		if(identifiers.get(word) != null) {
			System.out.printf("[Id, %s]", identifiers.get(word));
		} else {
			// se novo guarda escopo nos dois maps.
			identifierCount++;
			identifiers.put(word, identifierCount);
			identifierScope.put(word, scope);
			System.out.printf("[Id, %s]", identifierCount);
		}
		System.out.println("Map id " + identifiers.toString()); // só para teste
		System.out.println("Map scope " + identifierScope.toString()); // só para teste
	}

	private static void closeScope(int scope) {
		for(String key: identifierScope.keySet()) {
			if(identifierScope.get(key).equals(scope)) {
				System.out.println(key); 
			}
		}
		//identifierScope.values().remove(scope);
		System.out.println("on scope " + scope + " Map scope is " + identifierScope.toString()); // só para teste
	}

  private void writeOtherChar(String value) {
  	switch(value){
  		case "=":
  			System.out.println("[equal, " + yytext() + "]"); 
  			break;
  		case "(":
		    scope++;
  			System.out.println("[l_paren, " + yytext() + "]"); 
			  System.out.println("Map id" + identifierScope.toString()); // só para teste
  			break;
  		case ")":
		    // se fechou escopo apaga todos com escopo igual
		    closeScope(scope);
		    scope--;
  			System.out.println("[r_paren, " + yytext() + "]"); 
  			break;
  		case "[":
  			System.out.println("[l_bracket, " + yytext() + "]"); 
  			break;
  		case "]":
  			System.out.println("[r_bracket, " + yytext() + "]"); 
  			break;
      case "{":
	    scope++;
        System.out.println("[l_braces, " + yytext() + "]"); 
        break;
      case "}":
	    // se fechou escopo apaga todos com escopo igual
	    closeScope(scope);
	    scope--;
        System.out.println("[r_braces, " + yytext() + "]"); 
		System.out.println("Map id" + identifierScope.toString()); // só para teste
        break;
  		case ",":
  			System.out.println("[comma, " + yytext() + "]"); 
  			break;
  		case ";":
  			System.out.println("[semicolon, " + yytext() + "]"); 
  			break;
      case ".":
        System.out.println("[dot, " + yytext() + "]"); 
        break;
  	}
  }

  private String getFormattedString(String text) {
    String withoutQuotes = text.replaceAll("\"", "");
    return withoutQuotes.replaceAll("\\s+", " ");
  }
%}

LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]
InputCharacter = [^\r\n]

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
Comment = {TraditionalComment} | {EndOfLineComment}

Condition = "if"|"else"|"switch"|"case"
Loop = "do"|"while"|"for"|"break"
Type = "int"|"float"|"double"|"string"|"bool"|"null"|"NULL"|"void"
OtherReservedWord = "return"
ReservedWord = {Condition} | {Loop} | {Type} | {OtherReservedWord}

OtherCharacteres = "="|"("|")"|"{"|"}"|"["|"]"|","|";"|"."

RelationalOperator = "<"|"<="|"=="|"!="|">="|">"

LogicalOperator = "&&"|"||"

ArithmeticOperator = "+"|"-"|"*"|"/"

Digit = [0-9]
Id = [a-zA-Z][a-zA-Z0-9]*
String = (\"[^\"]*\")

%%

/* integers */
{Digit}+ { System.out.println("[num, " + yytext() + "]"); }

/* floats */
{Digit}+"."{Digit}+ { System.out.println("[num, " + yytext() + "]"); }

/* reserved words */
{ReservedWord} { System.out.println("[reserved_word, " + yytext() + "]"); }

/* other characteres */
{OtherCharacteres} { writeOtherChar(yytext()); }

/* relational operator */
{RelationalOperator} { System.out.println("[relational_operator, " + yytext() + "]"); }

/* logical operator */
{LogicalOperator} { System.out.println("[logical_operator, " + yytext() + "]"); }

/* arithmetic operator */
{ArithmeticOperator} { System.out.println("[arithmetic_operator, " + yytext() + "]"); }

/* strings */
{String} { System.out.println("[string_literal, " + getFormattedString(yytext()) + "]"); }

/* identifiers */
{Id} { printIdentifier(yytext()); }

{WhiteSpace} { /* ignore */ }
{Comment} { /* ignore */ }

/* error fallback */
[^] { System.out.println("Illegal character <" + yytext() + ">"); }
