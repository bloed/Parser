package lexer;

import java_cup.runtime.Symbol;
import Main.Consola;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Collections;


public class ScannerController {
    
    private ArrayList<TokenDesplegable> tokens;
    private ArrayList<String> errores;
    private String path;
    private Consola console;
    
    public ScannerController(String pPath, Consola console){
        path = pPath;
        this.console = console; 
        tokens = new ArrayList<TokenDesplegable>();
        errores = new ArrayList<String>();
    }
    
    public void Scan() throws IOException{
        Reader reader = new BufferedReader(new FileReader(path));
        Lexer lexer = new Lexer(reader);
        Symbol currentToken;
        while(true){
            currentToken = lexer.next_token();
            if (currentToken.sym == 0){
                //se llega al final del archivo.
                break;
            }
            else{
                switch(currentToken.sym){
                    case 13:
                        String error = "Error : " + lexer.lexeme + ". En la línea: " + (lexer.getLine()+1);
                        errores.add(error);
                        break;
                    default:
                        
                        createToken(lexer.lexeme, String.valueOf(currentToken.sym) , lexer.getLine()+1); 
                        break;
                }
            }
        }
        Collections.sort(tokens);
        
        printErrores();
        printTokens();
    }
    
    private void printTokens(){
        
        Collections.sort(tokens); 
        
        for(TokenDesplegable token: tokens)
            console.impirmir(token.toString());
        
    }
    
    private void printErrores(){
        console.impirmir("Se tienen los siguientes errores léxicos:");
        for (String error: errores) {
            console.impirmir(error);
        }
    }
    
    private void createToken(String pNombre, String pTipo, int pNumeroLinea){
        
        TokenDesplegable tokenActual = verificarToken(pNombre);
        
        if(tokenActual != null){
            tokenActual.crearLinea(pNumeroLinea);
        } else {
            tokenActual = new TokenDesplegable(pNombre, pTipo);
            tokenActual.crearLinea(pNumeroLinea);
            tokens.add(tokenActual);
        }
        
    }
    
    private TokenDesplegable verificarToken(String pToken){
        
        for(TokenDesplegable nuevoToken: tokens ){
            if(nuevoToken.compareName(pToken))
                return nuevoToken;
        }
        return null;
    }
}
