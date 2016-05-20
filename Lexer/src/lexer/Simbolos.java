package lexer;

public interface Simbolos{
    public static final int EOF = 0;
    public static final int Identificador = 1;
    public static final int opAritmeticos = 2;
    public static final int opComparadores = 3;
    public static final int opAsignaciones = 4;
    public static final int opDelimitadores = 5;
    public static final int opBits = 6;
    public static final int opLogicos   = 7;                         
    public static final int PalabraReservada = 8;
    public static final int INT = 9;
    public static final int FLOAT = 10;
    public static final int CHAR = 11;
    public static final int STRING = 12;
    public static final int ERROR = 13;
    
}
