package lexer;
import java_cup.runtime.*;
import Parser.Simbolos;
%%

%cupsym Simbolos
%class Lexer
%type Symbol
%line
%cup
%column
%unicode
%char
%ignorecase
%state MYSTRING
%state MYCHAR
%state COMENTARIOBLOQUE
%state COMENTARIOBLOQUE2


%{
    //esto se copia directamente

    StringBuffer string = new StringBuffer();
    Boolean cambioLinea = false;

    public String lexeme;
    public int getLine(){
        return yyline;
    }
%}

Letra = [a-zA-Z_]
Numero = [0-9]
Binario = (0|1)
Octal = [0-7]
Hexadecimal = ([0-9]|[a-f])
WhiteSpace = {LineTerminator} | [ ]
LineTerminator = (\r\n|\r|\n)
InputCharacter = [^\r\n] /* todos los caracteres que no son el enter */
IdentificadorInvalido = ([^\x00-\x7F])

Comentario = {ComentarioDeLinea}
ComentarioDeLinea = "#" {InputCharacter}* {LineTerminator}?


PalabraRerservada = ("assert"|"break"|"class"|"continue"|"def"|"del"|"elif"|"else"|"except"|"exec"|"finally"|"for"|"from"|"global"|"if"|"import"|"in"|"is"|"lambda"|"pass"|"print"|"raise"|"return"|"try"|"while"|"int"|"float"|"string"|"list"|"bool"|"None")

opAritmeticos = "+"|"-"|"*"|"/"|"//"|"%"|"**"
opComparadores = "=="|"!="|"<>"|">"|"<"|">="|"<="
opLogicos = "and"|"or"|"not"
opBits = ">>"|"<<"|"&"|"^"|"~"|\u007C
opAsignaciones = "+="|"-="|"*="|"/="|"**="|"//="|"="
opDelimitadores ="("|")"|","|"."|":"|"\t"|"["|"]"|"{"|"}"

%%
/* Comentarios y espacios en blanco son ignorados */



<YYINITIAL> {
 \"\"\"                         { string.setLength(0); yybegin(COMENTARIOBLOQUE);}
 \'\'\'                         { string.setLength(0); yybegin(COMENTARIOBLOQUE2);}
 \"                             { string.setLength(0); cambioLinea = false; yybegin(MYSTRING); }
 {WhiteSpace}                   {/* ignore */}
 {Comentario}                   {/* ignore */}
 0("b"|"B")                     {Binario}+ {lexeme=yytext(); return new Symbol(Simbolos.INT, yychar,yyline,lexeme);}
 0("o"|"O")                     {Octal}+  {lexeme=yytext(); return new Symbol(Simbolos.INT, yychar,yyline,lexeme);}
 0("x"|"X")                     {Hexadecimal}+  {lexeme=yytext(); return new Symbol(Simbolos.INT, yychar,yyline,lexeme);}
 {Numero}+({Letra}+{Numero}*)+ {lexeme = yytext(); return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);}
 {Numero}+ {lexeme=yytext(); return new Symbol(Simbolos.INT, yychar,yyline,lexeme);}
 ({Numero}+"."{Numero}+) {lexeme=yytext(); return new Symbol(Simbolos.FLOAT, yychar,yyline,lexeme);}

 \' {string.setLength(0); yybegin(MYCHAR);} 



/* Operadores */
{opAritmeticos}     {lexeme = yytext(); return new Symbol(Simbolos.opAritmeticos, yychar,yyline,lexeme);}
{opComparadores}    {lexeme = yytext(); return new Symbol(Simbolos.opComparadores, yychar,yyline,lexeme);}
{opLogicos}         {lexeme = yytext(); return new Symbol(Simbolos.opLogicos, yychar,yyline,lexeme);}
{opBits}            {lexeme = yytext(); return new Symbol(Simbolos.opBits, yychar,yyline,lexeme);}
{opAsignaciones}    {lexeme = yytext(); return new Symbol(Simbolos.opAsignaciones, yychar,yyline,lexeme);}
{opDelimitadores}   {lexeme = yytext(); return new Symbol(Simbolos.opDelimitadores, yychar,yyline,lexeme);}

/* Palabras reservadas */
{PalabraRerservada} {lexeme = yytext(); return new Symbol(Simbolos.PalabraReservada, yychar,yyline,lexeme);}

{Letra}(({Letra}|{Numero})*({IdentificadorInvalido})+({Letra}|{Numero})*)+ {lexeme=yytext(); return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);} 
{Letra}({Letra}|{Numero})* {lexeme=yytext(); return new Symbol(Simbolos.Identificador, yychar,yyline,lexeme);}

}

<MYCHAR> {

\'                              {yybegin(YYINITIAL); lexeme = "'"+ string.toString()+"'"; 
                                 if(string.length()>1)
                                    return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);
                                 else
                                    return new Symbol(Simbolos.CHAR, yychar,yyline,lexeme);   }
<<EOF>>                          { yybegin(YYINITIAL); lexeme = "Char sin terminar: " + string.toString(); return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);}
\S                               { string.append( yytext() );}
\s                               { string.append( yytext() );}


}
<MYSTRING> {
  {LineTerminator}               { cambioLinea = true; string.append('\n');}
  \"                             { yybegin(YYINITIAL);
                                   lexeme = "\"" +string.toString()+"\"";
                                   if(cambioLinea){
                                        return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);
                                   }else{
                                        return new Symbol(Simbolos.STRING, yychar,yyline,lexeme);
                                   }} /*Numero linea = adonde terminO*/
 <<EOF>>                         { yybegin(YYINITIAL); lexeme = "String sin terminar: " + string.toString(); return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);}
  \t                             { string.append('\t'); } 
  \u0020                         {string.append(' ');}
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }
  \\r                            { string.append('\r'); }
  \\\"                           { string.append('\"'); }
  \S                             { string.append( yytext() ); }

}

<COMENTARIOBLOQUE> {
  \"\"\"                           { yybegin(YYINITIAL);}
  \S                               { string.append( yytext() ); }
  <<EOF>>                          { yybegin(YYINITIAL); lexeme = "Comentario de bloque sin terminar: " + "\"\"\"" + string.toString(); return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);}
  \\t                              { string.append('\t'); }
  \\n                              { string.append('\n'); }
  \\r                              { string.append('\r'); }
  \\\"                             { string.append('\"'); }
  [ ]                              { string.append(' '); }
  {LineTerminator}                 { string.append(yytext()); }
  \s                               { string.append(yytext()); }
}
<COMENTARIOBLOQUE2> {
  \'\'\'                           { yybegin(YYINITIAL);}
  \S                               { string.append( yytext() ); }
  <<EOF>>                          { yybegin(YYINITIAL); lexeme = "Comentario de bloque sin terminar: " + "\'\'\'" + string.toString(); return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);}
  \\t                              { string.append('\t'); }
  \\n                              { string.append('\n'); }
  \\r                              { string.append('\r'); }
  \\\"                             { string.append('\"'); }
  [ ]                              { string.append(' '); }
  {LineTerminator}                 { string.append(yytext()); }
  \s                               { string.append(yytext()); }
}



/* Error */
. {lexeme = yytext();return new Symbol(Simbolos.ERROR, yychar,yyline,lexeme);}