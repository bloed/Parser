package lexer;
import static lexer.Token.*;
%%

%class Lexer
%type Token
%line
%column
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
Operador = [+,-] /*No se si tener todos los valores de operador servira para arreglar el ER de identificador */
Hexadecimal = ([0-9]|[a-f])
WhiteSpace = {LineTerminator} | [ ]
LineTerminator = (\r\n|\r|\n)
InputCharacter = [^\r\n] /* todos los caracteres que no son el enter */
IdentificadorInvalido = ([^\x00-\x7F])

Comentario = {ComentarioDeLinea}
ComentarioDeLinea = "#" {InputCharacter}* {LineTerminator}?
ComentarioDeBloque = \"\"\"([\s\S]*)\"\"\"

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
 0("b"|"B")                     {Binario}+ {lexeme=yytext(); return INT;}
 0("o"|"O")                     {Octal}+  {lexeme=yytext(); return INT;}
 0("x"|"X")                     {Hexadecimal}+  {lexeme=yytext(); return INT;}
 {Numero}+({Letra}+{Numero}*)+ {lexeme = yytext(); return ERROR;}
 {Numero}+ {lexeme=yytext(); return INT;}
 ({Numero}+"."{Numero}+) {lexeme=yytext(); return FLOAT;}

 \' {string.setLength(0); yybegin(MYCHAR);} 



/* Operadores */
{opAritmeticos}     {lexeme = yytext(); return opAritmeticos;}
{opComparadores}    {lexeme = yytext(); return opComparadores ;}
{opLogicos}         {lexeme = yytext(); return opLogicos;}
{opBits}            {lexeme = yytext(); return opBits;}
{opAsignaciones}    {lexeme = yytext(); return opAsignaciones;}
{opDelimitadores}   {lexeme = yytext(); return opDelimitadores;}

/* Palabras reservadas */
{PalabraRerservada} {lexeme = yytext(); return PalabraReservada;}

{Letra}(({Letra}|{Numero})*({IdentificadorInvalido})+({Letra}|{Numero})*)+ {lexeme=yytext(); return ERROR;} 
{Letra}({Letra}|{Numero})* {lexeme=yytext(); return Identificador;}

}

<MYCHAR> {

\'                              {yybegin(YYINITIAL); lexeme = "'"+ string.toString()+"'"; 
                                 if(string.length()>1)
                                    return ERROR;
                                 else
                                    return CHAR;   }
<<EOF>>                          { yybegin(YYINITIAL); lexeme = "Char sin terminar: " + string.toString(); return ERROR;}
\S                               { string.append( yytext() );}
\s                               { string.append( yytext() );}


}
<MYSTRING> {
  {LineTerminator}               { cambioLinea = true; string.append('\n');}
  \"                             { yybegin(YYINITIAL);
                                   lexeme = "\"" +string.toString()+"\"";
                                   if(cambioLinea){
                                        return ERROR;
                                   }else{
                                        return STRING;
                                   }} /*Numero linea = adonde terminO*/
 <<EOF>>                         { yybegin(YYINITIAL); lexeme = "String sin terminar: " + string.toString(); return ERROR;}
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
  <<EOF>>                          { yybegin(YYINITIAL); lexeme = "Comentario de bloque sin terminar: " + "\"\"\"" + string.toString(); return ERROR;}
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
  <<EOF>>                          { yybegin(YYINITIAL); lexeme = "Comentario de bloque sin terminar: " + "\'\'\'" + string.toString(); return ERROR;}
  \\t                              { string.append('\t'); }
  \\n                              { string.append('\n'); }
  \\r                              { string.append('\r'); }
  \\\"                             { string.append('\"'); }
  [ ]                              { string.append(' '); }
  {LineTerminator}                 { string.append(yytext()); }
  \s                               { string.append(yytext()); }
}



/* Error */
. {lexeme = yytext();return ERROR;}