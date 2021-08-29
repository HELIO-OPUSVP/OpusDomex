#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VBC_LOCORIºAutor  ³Helio Ferreira      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa criado para validar o campo BC_LOCORI para obrigarº±±
±±º          ³ o apontamento de perdas de apropriação indireta no 99      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VBC_LOCORI()

Local _Retorno       := .T.
Local nPosBC_PRODUTO := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == 'BC_PRODUTO' } )

SB1->( dbSetOrder(1) )
If SB1->( dbSeek( xFilial() + aCols[n,nPosBC_PRODUTO] ) )
	If SB1->B1_APROPRI == 'I'
		If M->BC_LOCORIG <> GetMv("MV_LOCPROC")
			MsgStop('Produtos com apropriação indidireta devem ter suas perdas apontadas no local ' + GetMv("MV_LOCPROC") + '.')
			_Retorno := .F.
		EndIf
	Else
		If M->BC_LOCORIG == GetMv("MV_LOCPROC")
			MsgStop('Produtos com apropriação direta não devem ter suas perdas apontadas no local ' + GetMv("MV_LOCPROC") + '.')
			_Retorno := .F.
		EndIf
	EndIf
EndIf

Return _Retorno
