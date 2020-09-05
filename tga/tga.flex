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
  	static int identifierCount = 0;
	static Map<String, Integer> identifiers = new HashMap<String, Integer>();
	private static void printIdentifier(String word) {
		if(identifiers.get(word) != null) {
			System.out.printf("[Id, %s]", identifiers.get(word));
		} else {
			identifierCount++;
			identifiers.put(word, identifierCount);
			System.out.printf("[Id, %s]", identifierCount);
		}
	}

  private void writeOtherChar(String value) {
  	switch(value){
  		case "=":
  			System.out.println("[equal, " + yytext() + "]"); 
  			break;
  		case "(":
  			System.out.println("[l_paren, " + yytext() + "]"); 
  			break;
  		case ")":
  			System.out.println("[r_paren, " + yytext() + "]"); 
  			break;
  		case "[":
  			System.out.println("[l_bracket, " + yytext() + "]"); 
  			break;
  		case "]":
  			System.out.println("[r_bracket, " + yytext() + "]"); 
  			break;
      case "{":
        System.out.println("[l_braces, " + yytext() + "]"); 
        break;
      case "}":
        System.out.println("[r_braces, " + yytext() + "]"); 
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

Identifier = "#identificador"

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
{Id} { System.out.println("identificador: " + yytext()); }

/* check identifier */
{Identifier} { printIdentifier(yytext()); }

{WhiteSpace} { /* ignore */ }
{Comment} { /* ignore */ }

/* error fallback */
[^] { System.out.println("Illegal character <" + yytext() + ">"); }
