package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.symbols.SymbolTable;
import lyc.compiler.model.*;
import static lyc.compiler.constants.Constants.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}


%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}


LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation = [ \t\f]

OP_SUMA = "+"
OP_MULT = "*"
OP_RESTA = "-"
OP_DIV = "/"
OP_ASIG = ":="
OP_TIPO = ":"
COMP_MEN = "<"
COMP_MAY = ">"
COMA = ","

PAR_ABRIR = "("
PAR_CERRAR = ")"
LLAVE_ABRIR = "{"
LLAVE_CERRAR = "}"
COM_INI = "#+"
COM_FIN = "+#"

DIGITO = [0-9]
LETRA = [a-zA-Z]

COMENTARIO = {COM_INI}.*{COM_FIN}
ID = {LETRA}({LETRA}|{DIGITO})*
CTE_CADENA = \"([^\"\\\\]|\\\\.)*\"
CTE_ENTERA = {DIGITO}+
CTE_FLOTANTE = {DIGITO}+\.{DIGITO}*|\.{DIGITO}+

ESPACIO = {LineTerminator} | {Identation}

%%


/* keywords */

<YYINITIAL> {
  /* keywords */
  "if"              { return symbol(ParserSym.IF); }
  "else"            { return symbol(ParserSym.ELSE); }
  "while"           { return symbol(ParserSym.WHILE); }
  "AND"             { return symbol(ParserSym.AND); }
  "OR"              { return symbol(ParserSym.OR); }
  "NOT"             { return symbol(ParserSym.NOT); }
  "write"           { return symbol(ParserSym.WRITE); }
  "read"            { return symbol(ParserSym.READ); }
  "init"            { return symbol(ParserSym.INIT); }

  "Float" 	        { return symbol(ParserSym.DT_FLOAT); }
  "Int" 		        { return symbol(ParserSym.DT_INT); }
  "String" 	        { return symbol(ParserSym.DT_STRING); }

  /* identifiers */
  {ID}              { SymbolTable.insert(yytext(), "ID", yytext()); return symbol(ParserSym.ID, yytext()); }

  /* Constants */
  {CTE_ENTERA}      { SymbolTable.insert("_" + yytext(), "Int", yytext()); return symbol(ParserSym.CTE_ENTERA, yytext()); }
  {CTE_FLOTANTE}    { SymbolTable.insert("_" + yytext(), "Float", yytext()); return symbol(ParserSym.CTE_FLOTANTE, yytext()); }
  {CTE_CADENA}      { SymbolTable.insert("_" + yytext(), "String", yytext()); return symbol(ParserSym.CTE_CADENA, yytext()); }

  /* operators */
  {OP_SUMA}         { return symbol(ParserSym.OP_SUMA); }
  {OP_RESTA}        { return symbol(ParserSym.OP_RESTA); }
  {OP_MULT}         { return symbol(ParserSym.OP_MULT); }
  {OP_DIV}          { return symbol(ParserSym.OP_DIV); }
  {OP_ASIG}         { return symbol(ParserSym.OP_ASIG); }
  {OP_TIPO}         { return symbol(ParserSym.OP_TIPO); }
  {COMP_MEN}        { return symbol(ParserSym.COMP_MEN); }
  {COMP_MAY}        { return symbol(ParserSym.COMP_MAY); }

  /* others */
  {COMA}            { return symbol(ParserSym.COMA); }
  {PAR_ABRIR}       { return symbol(ParserSym.PAR_ABRIR); }
  {PAR_CERRAR}      { return symbol(ParserSym.PAR_CERRAR); }
  {LLAVE_ABRIR}     { return symbol(ParserSym.LLAVE_ABRIR); }
  {LLAVE_CERRAR}    { return symbol(ParserSym.LLAVE_CERRAR); }

  /* whitespace */
  {ESPACIO}         { /* ignorar */ }

  /* comment */
  {COMENTARIO}      { /* ignorar */ }
}

/* error fallback */
[^]                 { throw new UnknownCharacterException(yytext()); }