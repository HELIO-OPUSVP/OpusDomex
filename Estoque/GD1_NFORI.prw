#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GD1_NFORI ºAutor  ³Helio Ferreira      º Data ³  19/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º@±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GD1_NFORI()

	Local aAreaGER   := GetArea()
	Local aAreaSD4   := SD4->( GetArea() )
	Local _Retorno   := M->D1_NFORI
	Local cNFOri     := aCols[n,aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_NFORI"   } )]
	Local cSerieOri  := aCols[n,aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_SERIORI" } )]
	Local cItemOri   := aCols[n,aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_ITEMORI" } )]
	Local cProdut    := aCols[n,aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_COD"     } )]
	Local nPD1_OP    := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_OP"    } )
	Local nPD1_LOCAL := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D1_LOCAL" } )
	Local cFornece   := CA100FOR
	Local cLoj       := CLOJA

	SD2->( dbSetOrder(3) )  // D2_FILIAL+D2_DOC + D2_SERIE  + D2_CLIENTE + D2_LOJA + D2_COD  + D2_ITEM
	If SD2->( dbSeek( xFilial() + cNFOri + cSerieOri + cFornece + cLoj + cProdut + cItemOri) )
		SC6->( dbSetOrder(1) )
		If SC6->( dbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV ) )
			If !Empty(SC6->C6_XXOP)
				aCols[N,nPD1_OP] := SC6->C6_XXOP
				SD4->( dbSetOrder(2) )
				If SD4->( dbSeek( xFilial() + Subs(SC6->C6_XXOP,1,11) + "  " + cProdut ) )
					//MsgStop("Não foi encontrado empenho deste produto para esta OP.")
					If aCols[n,nPD1_LOCAL] <> SD4->D4_LOCAL
						//MsgStop("Almoxarifado da NF ("+aCols[n,nPD1_LOCAL]+") alterado para o mesmo do Empenho da OP ("+SD4->D4_LOCAL+").")
						aCols[n,nPD1_LOCAL] := SD4->D4_LOCAL
					EndIf
				Else
					MsgStop("Não foi encontrado empenho deste produto para esta OP.")
				EndIf
			Else
				MsgStop("Não foi preenchido o numero da OP no Pedido de Vendas " + SD2->D2_PEDIDO + " item " +SD2->D2_ITEMPV)
			EndIf
		Else
			MsgStop("Pedido de Vendas " + SD2->D2_PEDIDO + " item " + SD2->D2_ITEMPV + " não encontrado.")
		EndIf
	Else
		MsgStop("Documento Original não encontrado.")
	EndIf

	RestArea(aAreaSD4)
	RestArea(aAreaGER)

Return _Retorno
