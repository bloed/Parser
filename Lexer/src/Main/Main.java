package Main;

import Parser.ParserController;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import lexer.ScannerController;
import lexer.TokenDesplegable;


public class Main {
    
    private static ArrayList<TokenDesplegable> tokens;

    public static void main(String[] args) {
        String path = "src\\lexer\\lexer.flex";
        generarLexer(path);
        Consola console = new Consola();
        console.setVisible(true);
        console.impirmir("Analizador Creado. Se procede a scannear:");
        try{
            ScannerController scanner = new ScannerController("Prueba.mypy", console);
            scanner.Scan();
            console.impirmir("Análisis léxico terminado.");
            System.out.println("Análisis léxico terminado");
        }
        catch(IOException e){
            console.impirmir("No se pudo abrir el archivo.");
        }
        console.impirmir("\n Ahora se procede a parsear:");
        ParserController parser = new ParserController();
        //parser.generarCup();
    }
    public static void generarLexer(String path){
        File file=new File(path);
        jflex.Main.generate(file);
    }
    
}
