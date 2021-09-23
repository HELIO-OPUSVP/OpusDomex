#include "rwmake.ch"
#include "protheus.ch"         
#INCLUDE "TOPCONN.CH"   
#include "tbiconn.ch"

//PONTO ENTRADA APOS ACERTO INVENTARIO
// JONAS 15092021
User Function MT340D3( )

//Replace D3_CC  With  '1101001'

If 'JONAS.OPUS' $ Upper(GetEnvServer())
    Reclock("SD3",.F.)
    SD3->D3_DOC := SB7->B7_DOC
    SD3->(MsUnLock())
EndIf



Return
