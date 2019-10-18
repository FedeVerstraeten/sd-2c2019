#include <stdio.h>
#include <math.h>
// 
//--------------------------------------------------------------------
//
// Calculo de suma en N bits con M bits de exponente
//
//--------------------------------------------------------------------


/**********************************************************************
 *                                                                    *
 *  Procedimiento para mostrar un numero en representacion binaria    *
 *                                                                    *
 **********************************************************************/
void imprimir_bin(unsigned int num, int N){
    int i;
    
    for (i=0; i<N; i++){
        printf("%d", (num>>(N-1-i)) & 0x01);
    
    }
}

/**********************************************************************
 *                                                                    *
 *  Procedimiento para calcular las mascaras necesarias para          *
 *  extraer las diferentes partes de un numero en punto flotante      *
 *                                                                    *
 **********************************************************************/
void gen_Mask(int bits_totales, int bits_exp, int *final_mask,
              int *exponent_mask, int *mantisa_mask, int *mantisa_mask_plus_1) {

    *final_mask = pow(2, bits_totales) - 1;
    *exponent_mask = pow(2, bits_exp) - 1;
    *mantisa_mask = pow(2, bits_totales - bits_exp -1) - 1;
    *mantisa_mask_plus_1 = pow(2, bits_totales - bits_exp) - 1;
    
}
/**********************************************************************
 *                                                                    *
 *  Procedimiento para desempaquetar un numero en punto flotante      *
 *                                                                    *
 **********************************************************************/
void unpack_FP(int num, int bits_totales, int bits_exp) {
    
    unsigned int signo;
    unsigned int exponente;
    unsigned int mantisa;
    unsigned int final_mask, exponent_mask, mantisa_mask, mantisa_mask_plus_1;
    
    gen_Mask(bits_totales, bits_exp, &final_mask, &exponent_mask, &mantisa_mask, &mantisa_mask_plus_1);
    
    signo = (num >> (bits_totales-1)) & 0x01;
    exponente = (num >> (bits_totales-bits_exp-1)) & exponent_mask;
    mantisa = num & mantisa_mask;
    // Para ver los valores desempaquetados descomentar la línea siguiente
    //printf("\nSigno: %d\nExponente: %d\nMantisa: %d\n\n", signo, exponente, mantisa);

}

/**********************************************************************
 *                                                                    *
 *  Operacion de suma de dos numeros en punto flotante                *
 *                                                                    *
 **********************************************************************/

suma_FP(int BITS_T, int EXPONENTE, unsigned int A, unsigned int B, unsigned int *resultado, int dflag) {
    unsigned int C;
    unsigned int expA = 0;
    unsigned int expB = 0;
    unsigned int manA = 0;
    unsigned int manB = 0;
    
    int FINAL_MASK;
    int EXPONENT_MASK;
    int MANTISA_MASK;
    int MANTISA_MASK_PLUS_1;

    int bias;

    bias = pow(2,(EXPONENTE-1))-1;
    
    
    unpack_FP(6016292, 23, 6);

    // generacion de las mascaras
    gen_Mask(BITS_T, EXPONENTE, &FINAL_MASK, &EXPONENT_MASK, &MANTISA_MASK, &MANTISA_MASK_PLUS_1);

    unsigned int s1 = 0; // significand (1,mantisa);
    unsigned int s2 = 0; // significand (1,mantisa);
    unsigned int uno = 1;
    
    int swapFlag = 0;
    int compFlag_Paso2 = 0;
    int compFlag_Paso4 = 0;
    int carryFlag = 0;
    
    int k;
    int guard_bit = 0;

    int signo_A = (A >> (BITS_T-1)) & 0x01;
    int signo_B = (B >> (BITS_T-1)) & 0x01;
    int signo_res;
    unsigned int resultado_aux = 0; // resultado de la suma (23 bits)
    
    // extraccion de los exponentes
    expA = (A>>(BITS_T-EXPONENTE-1)) & EXPONENT_MASK;
    expB = (B>>(BITS_T-EXPONENTE-1)) & EXPONENT_MASK;
    
    // extracción de las mantisas
    manA = A & MANTISA_MASK;
    manB = B & MANTISA_MASK;

    if (dflag == 1) {
        printf("\n------------------------------------------------\n");
        printf("Numero de bits de los operandos: %d\n", BITS_T);
        printf("Numero de bits del exponente: %d\n", EXPONENTE);
        printf("BIAS: %d\n", bias);
        printf("------------------------------------------------\n\n");
    
        printf("Signo de A: %d\n", signo_A);
        printf("Signo de B: %d\n", signo_B);
    
        printf("Exponente A: %d\n", expA);
        printf("Exponente B: %d\n", expB);

        printf("Mantisa A: %d\n", manA);
        printf("Mantisa B: %d\n", manB);
    
    }
    
    // Comienzo del algoritmo
    
    // PASO 1
    // Verificar si expA > expB. Si no es así invertir los operandos
    if (dflag == 1)
        printf("\n PASO 1\n-----------------------------------\n");
    
    if (expB>expA){
        swapFlag = 1;
        C = A;
        A = B;
        B = C;
        
        expA = (A>>(BITS_T-EXPONENTE-1)) & EXPONENT_MASK;
        expB = (B>>(BITS_T-EXPONENTE-1)) & EXPONENT_MASK;
        manA = A & MANTISA_MASK;
        manB = B & MANTISA_MASK;

    }
        
    // Se elije tentativamente el valor del exponente de A como el exponente final
    int expFinal = expA;
    
    uno = 1 << (BITS_T-EXPONENTE-1);
    s1 = uno + manA;
    s2 = uno + manB;
    
    if (dflag == 1) {
        printf("Significand 1: ");
        imprimir_bin(s1, (BITS_T-EXPONENTE));
        printf("\nSignificand 2: ");
        imprimir_bin(s2, (BITS_T-EXPONENTE));
    }
    
    // PASO 2
    // El signo de A es distinto al signo de B, por lo tanto se complementa s2
    if (dflag == 1)
        printf("\n\n PASO 2\n-----------------------------------\n");
    
    if (signo_A != signo_B){
        compFlag_Paso2 = 1;
        s2 = (~s2 + 1) & MANTISA_MASK_PLUS_1;   // complemento a dos
        if (dflag == 1)
            imprimir_bin(s2, (BITS_T-EXPONENTE));
    }
    
    if (dflag == 1)
        printf("\ncompFlag del paso 2: %d", compFlag_Paso2);
    
    // PASO3
    // Se desplaza a derecha el s2
    if (dflag == 1)
        printf("\n\n PASO 3\n-----------------------------------\n");

    for (k=0; k<(expA - expB); k++){
        guard_bit = s2 & 0x01;
        s2 = (s2 >> 1);
        if (compFlag_Paso2 == 1){
            s2 = s2 + (1 << (BITS_T-EXPONENTE-1));
        }
    }
    
    if (dflag == 1) {
        printf("Significand del paso 3: ");
        imprimir_bin(s2, (BITS_T-EXPONENTE));
        printf("\nBit de guarda: %d", guard_bit);
    }
    
    // PASO 4
    // Cálculo de la suma preliminar
    if (dflag == 1)
        printf("\n\n PASO 4\n-----------------------------------\n");
    unsigned int s = s1 + s2;
    
    if (dflag == 1) {
        printf("Resultado de la suma: ");
        imprimir_bin(s, (BITS_T-EXPONENTE));
        printf("\nCarry flag: %d", carryFlag);
        printf("\nBit mas significativo: %d", ((s >> (BITS_T-EXPONENTE-1))&0x1));
    }
    
    carryFlag = (s >> (BITS_T-EXPONENTE)) & 0x01;

    if ((signo_A != signo_B) && (((s >> (BITS_T-EXPONENTE-1))&0x1) == 1) && (carryFlag == 0)) {
        s = (~s + 1) & MANTISA_MASK_PLUS_1;
        compFlag_Paso4 = 1;
        if (dflag == 1) {
            printf("\nA <> B, bit mas significativo de S es 1 y no hay carry => se complementa S: ");
            imprimir_bin(s, (BITS_T-EXPONENTE));
        }
    }

    if (dflag == 1)
        printf("\ncompFlag = %d", compFlag_Paso4);

    // PASO 5
    // 
    if (dflag == 1)
        printf("\n\n PASO 5\n-----------------------------------\n");
    
    unsigned int auxiliar = 0;
    int count = 0;
    
    if ((signo_A == signo_B) && (carryFlag == 1)) {
        s = (s >> 1) + (1 << (BITS_T-EXPONENTE));
        expFinal = expFinal + 1;
        if (expFinal > (pow(2, EXPONENTE-1)-1)) {
            expFinal = (pow(2, EXPONENTE)-1);
            s = 0;
            printf("\n******** ENTRO ***** \n");
        }
    }
    else {
        auxiliar = (s>>(BITS_T-EXPONENTE-1)) & 0x01;
        while (auxiliar == 0 && (count < (BITS_T-EXPONENTE))) {
            if (count == 0) {
                s = (s << 1) + guard_bit;
            }
            else {
                s = (s << 1);
            };
            
            count++;
            auxiliar = (s>>(BITS_T-EXPONENTE-1)) & 0x01;

        }
        
        if (count == (BITS_T-EXPONENTE))  // ***** VERIFICAR ESTO, JUNTO CON LA
            expFinal = 0;                // CONDICION DEL WHILE !!!
        else {
            expFinal = expFinal - count;
            if (expFinal < 0) {       //  ***** VERIFICAR ESTO !!!: UNDERFLOW -> 0
                expFinal = 0;
                s = 0;
            }
        }
    }

    if (dflag == 1) {
        printf("Suma preliminar normalizada: ");
        imprimir_bin(s, BITS_T-EXPONENTE);
        printf("\nExponente final: %d", expFinal);
    }
    
    // PASO 8
    // 
    if (dflag == 1) {
        printf("\n\n PASO 8\n-----------------------------------\n");
        printf("Signo de a1 <> a2 = %d\n", (signo_A != signo_B));
        printf("swapFlag = %d\n", swapFlag);
        printf("compFlag del paso 4 = %d\n", compFlag_Paso4);
    }
    
    if (signo_A != signo_B) {
        if (swapFlag == 1) {	// swap = yes
            if (signo_A == 0)
                signo_res = 1;
            else
                signo_res = 0;
                
        }
        else {                  // swap = no
            if (compFlag_Paso4 == 0) {
                signo_res = signo_A;
            }
            else {
                signo_res = ~signo_A;
            }
        
        }
    }
    else {
        signo_res = signo_A;
    }
    
    // Armado del resultado final (resultado = signo + exponente + mantisa)
    resultado_aux = (s & MANTISA_MASK) + (expFinal << (BITS_T-EXPONENTE-1)) + (signo_res << (BITS_T-1));
    if (dflag == 1)
        imprimir_bin(resultado_aux, BITS_T);
    
    resultado_aux = resultado_aux & FINAL_MASK;
    
    if (dflag == 1)
        printf(" = %d", resultado_aux);
    
    *resultado = resultado_aux;
    
    printf("\n\n");
}

/********************************************************************
 *                                                                  *
 *  Aplicacion principal desde donde es llamada la funcion de suma  *
 *  en punto flotante                                               *
 *                                                                  *
 ********************************************************************/
main(int argc, char *argv[]){

    int BITS_T = atoi(argv[1]);     // cantidad de bits totales del numero
    int EXPONENTE = atoi(argv[2]);  // cantidad de bits del exponente
    unsigned int A = atoi(argv[3]); // operando A
    unsigned int B = atoi(argv[4]); // operando B
    int flag = atoi(argv[5]);       // debugging flag
    
    int c;
    unsigned int opA, opB, res;
    unsigned int resultado = 0;        // resultado de la operacion (función)
    int error_count = 0;
    int i = 0;
    
    FILE *ptrFile;
    
    ptrFile = fopen("../Archivos_Enviados_por_Gustavo_29-10-10/test_IMP_sum_float_23_6.txt", "r");
    
    if (flag == 1) {
        suma_FP(BITS_T, EXPONENTE, A, B, &resultado, 1);
        
    }
    else {
        c = fscanf(ptrFile, "%d %d %d", &opA, &opB, &res);
    
//         while (c!=EOF && i<500) {
        while (c!=EOF) {
            suma_FP(BITS_T, EXPONENTE, opA, opB, &resultado, 0);
            if (resultado != res)
                error_count++;
            printf("\t%d) Archivo: %d %d %d\t| Resultado: %d\t| Diferencia: %d", i+1, opA, opB, res, resultado, resultado-res);
            c = fscanf(ptrFile, "%d %d %d", &opA, &opB, &res);
            i++;
        }
        printf("\n ****** Cantidad de errores: %d\n", error_count);
    }
        
    fclose(ptrFile);
    
    return 0;
}
