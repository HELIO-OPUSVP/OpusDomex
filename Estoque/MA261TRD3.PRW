#Include 'Protheus.ch'
 
User Function MA261TRD3()
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe os identificadores Recno() gerados na tabela SD3      ³
//³ para que seja feito o posicionamento                         ³
// Jonas Pereira - 08/05/2020
//Este ponto de entrada irá chamar a rotina CHKMOV, com objetivo de 
// validar e corrigir inconsistencias nas transferencias de armazens
//envitando DIFSALDO
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local aRecSD3 := PARAMIXB[1]
Local nX := 1
 

For nx := 1 to Len(aRecSD3) 
    If aRecSD3[nx][1] > 0
        SD3->(DbGoto(aRecSD3[nX][1])) // Requisicao RE4
        U_CHKMOV(SD3->D3_COD, SD3->D3_NUMSEQ, SD3->( Recno()), "T")
    ElseIf aRecSD3[nX][1] > 0
        SD3->(DbGoto(aRecSD3[nX][2])) // Devolucao DE4
        U_CHKMOV(SD3->D3_COD, SD3->D3_NUMSEQ, SD3->( Recno()), "T")
    EndIF
Next nx

Return Nil