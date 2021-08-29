#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA265TDOK    �Autor  �Helio Ferreira � Data �  10/03/20    ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o tudo Ok na tela de ender�amento                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA265TDOK()
    Local _Retorno     := .T.
    Local n
    Local nPDB_DATA    := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "DB_DATA"    })
    Local nPDB_ESTORNO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "DB_ESTORNO" })
    Local nPDB_REC_WT  := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "DB_REC_WT"  })
    
    For n := 1 to Len(aCols)
        If aCols[n,nPDB_DATA] <> M->DA_DATA .and. aCols[n,nPDB_ESTORNO] <> 'S' .and. Empty(aCols[n,nPDB_REC_WT])
            MsgInfo("Favor corrir a data dos itens conforme a data do cabe�alho")
            _Retorno := .F.
        EndIf
    Next n

Return _Retorno