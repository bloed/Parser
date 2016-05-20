package lexer;


public enum Token {
    //Identificadores
        Identificador,
        
    //Operadores (en orden como la tabla que nos dio la profe)
        /*opSuma,opResta,opMult,opDiv,opDivEntera,opMod,opExponente,opIgual,opExactamenteIgual,
        opDiferencia,opDiferencia2,opMayorQue,opMenorQue,opMayorOIgual,opMenorOIgual,opMasIgual,opMenosIgual,opMulIgual,
        opDivIgual,opExponenteIgual,opDivEnteraIgual,opParentesis1,opParentesis2,opComa,opPunto,opShiftDerecho,opShiftIzquierdo,
        opANDLog,opORLog,opNOTLog,opANDBits,opORBits,opXOR,opNOTBits,opTAB,*/
        opAritmeticos,opComparadores,opAsignaciones,opDelimitadores,opBits,opLogicos,
        
    //Palabras reservadas(en orden igual)
        /*rAnd,rAssert,rBreak,rClass,rContinue,rDef,rDel,rElif,rElse,rExcept,rExec,rFinally,rFor,rFrom,
        rGlobal,rIf,rImport,rIn,rIs,rLambda,rNot,rOr,rPass,rPrint,rRaise,rReturn,rTry,rWhile,
        rInt,rFloat,rString,rList,rBool,//sera un python tipado*/
        PalabraReservada,
        
    //Literales
        INT,FLOAT,CHAR,STRING,
        
    //ERROR
        ERROR
}
