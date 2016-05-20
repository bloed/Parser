package Parser;

import Main.Consola;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.Reader;
import java_cup.Lexer;

public class ParserController {
    
    private String path;
    private Consola console;
    
    public ParserController(String pPath, Consola console){ 
        path = pPath;
        this.console = console;
    }
    
    public void generarCup(){
        String opciones[] = {"-destdir","src\\Parser",
                "-parser","Analizador",
                "-symbols","Simbolos",
                "src\\Parser\\Parser.cup"
        };        
        try{
            java_cup.Main.main(opciones);   
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }    
    }
    
    public void parsear(){
        try{
            Reader reader = new BufferedReader(new FileReader(path));
            Analizador parser = new Analizador(new Lexer(reader));
            Object result = parser.parse();
            System.out.println(result.toString());
            System.out.println("Finalizado");
            
        }
        catch(Exception e){
            System.out.println(e.getMessage());
            System.out.println("Hubo excepcion");
        }
    }
}
