

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK  �Autor  �Marcos Rezende      � Data �  01/21/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � controle de inclus�o de pedidos sem ser de reposi��o       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			alert('Pedidos de compras devem ser gerados a partir de cota��o'+chr(13)+'Somente pedidos de reposi��o podem ser inclusos manualmente')
			lret := .f.
		endif
	endif

	// VAlidando se a SC � de compra ou somente de cota��o (projeto de margens de venda)
	If !aCols[n][Len(aHeader)+1]
		SC1->( dbSetOrder(1) )
		If SC1->( dbSeek(xFilial() + aCols[n][nPosNumSC] + aCols[n][nPosItemSC]))
			If SC1->C1_MSBLQL == "1"
				MsgStop("A Solicita��o de Compra n�mero " + AllTrim(aCols[n][nPosNumSC])+ " deve ser usada somente para cota��o")
				lret := .F.
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSC1)
	RestArea(aArea)

Return lret
