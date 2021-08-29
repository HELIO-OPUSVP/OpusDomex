#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RETAVULSA ºAutor  ³Michel A. Sander    º Data ³  09/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna embalagem fora da estrutura para apontamento       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetAvulsa(cProduto, cNivel)

Local _Retorno := {"",0,"",.F.}
Local aAreaGER := GetArea()
Local aAreaSG1 := SG1->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )

ZA1->( dbSetOrder(1) )
If ZA1->( dbSeek(xFilial() + SC2->C2_PRODUTO ) )
	Do While ZA1->(!Eof()) .And. ZA1->ZA1_FILIAL+ZA1->ZA1_PRODUT == xFilial("ZA1")+cProduto
		If ZA1->ZA1_NIVEL == cNivel
			_Retorno[1] := ZA1->ZA1_CODEMB
			_Retorno[2] := ZA1->ZA1_QUANT
			_Retorno[3] := ZA1->ZA1_NIVEL
			_Retorno[4] := .T.
		Endif
		ZA1->(dbSkip())
	EndDo
Else
	ZA1->( dbSetOrder(2) )
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
	If ZA1->( dbSeek(xFilial()+SB1->B1_GRUPO+SB1->B1_SUBCLAS) )
		Do While ZA1->(!Eof()) .And. ZA1->ZA1_FILIAL+ZA1->ZA1_GRUPO+ZA1->ZA1_SUBCLA == xFilial("ZA1")+SB1->B1_GRUPO+SB1->B1_SUBCLAS
			If ZA1->ZA1_NIVEL == cNivel
				_Retorno[1] := ZA1->ZA1_CODEMB
				_Retorno[2] := ZA1->ZA1_QUANT
				_Retorno[3] := ZA1->ZA1_NIVEL
				_Retorno[4] := .T.
			Endif
			ZA1->(dbSkip())
		EndDo
	EndIf
EndIf

RestArea(aAreaSG1)
RestArea(aAreaGER)
RestArea(aAreaSB1)

Return _Retorno