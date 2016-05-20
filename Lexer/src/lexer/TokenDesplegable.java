package lexer;

import java.util.ArrayList;

public class TokenDesplegable implements Comparable<TokenDesplegable> {
    
    public String nombre;
    private String tipo;
    private ArrayList<Linea> lineas;
    
    public TokenDesplegable(String pNombre, String pTipo){
        
        nombre = pNombre;
        tipo = pTipo;
        lineas = new ArrayList<Linea>();
        
    }
    
    private Linea verificarLinea(int pNumeroLinea){
        
        for(Linea nLinea: lineas){
            if(nLinea.compareLinea(pNumeroLinea))
                return nLinea;
        }
        return null;
        
    }
    
    public void crearLinea(int pNumeroLinea){
        
        Linea lineaActual = verificarLinea(pNumeroLinea);
        
        if(lineaActual != null){
            lineaActual.incApariciones();
        }else{
            lineaActual = new Linea(pNumeroLinea);
            lineas.add(lineaActual);
        }
    }
    
    private String printLineas(){
        
        String resultado = "";
        for(Linea nLinea: lineas)
            resultado += nLinea + ", ";
        
        resultado = resultado.substring(0, resultado.length()-2); //se que no deberia ir aqui, pero no tiene sentido que esta clase tenga una funcion para esto y hacer una clase de utilidades solo para esta como que no...
        
        
        return resultado;
    }

    @Override
    public int compareTo(TokenDesplegable o) { //ordenamiento
        
        return nombre.compareTo(o.nombre);
    
    }
    
    @Override
    public String toString(){
        return  nombre + " de tipo: " + tipo + " en las lineas: " + printLineas() + ".";
    }
    
    public boolean compareName(String pNombre){ //comprobar existencia
        return nombre.equals(pNombre);
    }
    
}
