

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120LOK  ºAutor  ³Marcos Rezende      º Data ³  01/21/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ controle de inclusão de pedidos sem ser de reposição       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120LOK

	local lret       := .T.
	Local nPosNumSC  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_NUMSC'})
	Local nPosItemSC := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEMSC'})
	Local aArea 	 := GetArea()
	Local aAreaSC1	 := SC1->(GetArea())

	Local lINCLUI := (_DOMOpcX == 3)

	if linclui
		IF _cTPPC <> 'RP'
			alert('Pedidos de compras devem ser gerados a partir de cotação'+chr(13)+'Somente pedidos de reposição podem ser inclusos manualmente')
			lret := .f.
		endif
	endif

	// VAlidando se a SC é de compra ou somente de cotação (projeto de margens de venda)
	If !aCols[n][Len(aHeader)+1]
		SC1->( dbSetOrder(1) )
		If SC1->( dbSeek(xFilial() + aCols[n][nPosNumSC] + aCols[n][nPosItemSC]))
			If SC1->C1_MSBLQL == "1"
				MsgStop("A Solicitação de Compra número " + AllTrim(aCols[n][nPosNumSC])+ " deve ser usada somente para cotação")
				lret := .F.
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSC1)
	RestArea(aArea)

Return lret
