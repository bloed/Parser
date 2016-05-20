package Parser;

public class ParserController {
    
    public ParserController(){ }
    
    public void generarCup(){
        String opciones[] = new String[5];
        
        //seleccionamos opcion de destino
        opciones[0] = "-destdir";
        opciones[1] = "src\\Parser";
        
        //le damos un nombre al archivo
        opciones[2] = "-parser";
        opciones[3] = "Analizador";
        
        //le decimos donde esta el .cup
        opciones[4] = "src\\Parser\\Parser.cup";
        try{
            java_cup.Main.main(opciones);
        }
        catch (Exception e){
            System.out.println(e.getMessage());
        }
        
    }
}
