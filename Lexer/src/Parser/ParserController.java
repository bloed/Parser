package Parser;

public class ParserController {
    
    public ParserController(){ }
    
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
}
