#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C6XXSEPARA ºAutor  ³Helio Ferreira     º Data ³  07/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo C6_XXDTSEP (Data de Separação de Senf)  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function C6XXDTSEP()
Local _Retorno    := .T.
Local nPC6_ITEM   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"   })
Local nPC6_ENTRE3 := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTRE3" })
 
SZY->( dbSetOrder(1) )
If !SZY->( dbSeek( xFilial() + M->C5_NUM + aCols[N,nPC6_ITEM] ) )
   If M->C6_XXDTSEP == aCols[N,nPC6_ENTRE3]
      // Data Ok
   Else
      MsgStop("Data de Separação diferente da Data do PCP.")
      _Retorno := .F.
   EndIf	
Else
	If SZY->ZY_PRVFAT <> M->C6_XXDTSEP
	   MsgStop("Data de Separação diferente da Data do PCP.")
      _Retorno := .F.
	EndIf
EndIf

Return _Retorno
