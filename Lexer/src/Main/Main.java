package Main;

import Parser.Analizador;
import Parser.ParserController;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java_cup.Lexer;
import lexer.ScannerController;
import lexer.TokenDesplegable;


public class Main {
    
    private static ArrayList<TokenDesplegable> tokens;

    public static void main(String[] args) throws FileNotFoundException {
        String path = "src\\lexer\\lexer.flex";
        Consola console = new Consola();
        console.setVisible(true);
        ParserController parser = new ParserController("Prueba.mypy",console);
        parser.generarCup();
        generarLexer(path);
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
        parser.parsear();
        
    }
    public static void generarLexer(String path){
        File file=new File(path);
        jflex.Main.generate(file);
    }
    
}
