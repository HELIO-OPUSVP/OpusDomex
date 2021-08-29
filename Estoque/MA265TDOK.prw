#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA265TDOK    บAutor  ณHelio Ferreira บ Data ณ  10/03/20    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo tudo Ok na tela de ender็amento                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rosenberger                                                บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA265TDOK()
    Local _Retorno     := .T.
    Local n
    Local nPDB_DATA    := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "DB_DATA"    })
    Local nPDB_ESTORNO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "DB_ESTORNO" })
    Local nPDB_REC_WT  := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "DB_REC_WT"  })
    
    For n := 1 to Len(aCols)
        If aCols[n,nPDB_DATA] <> M->DA_DATA .and. aCols[n,nPDB_ESTORNO] <> 'S' .and. Empty(aCols[n,nPDB_REC_WT])
            MsgInfo("Favor corrir a data dos itens conforme a data do cabe็alho")
            _Retorno := .F.
        EndIf
    Next n

Return _Retorno