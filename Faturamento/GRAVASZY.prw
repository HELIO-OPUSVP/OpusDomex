#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVASZY  ºAutor  ³Michel Sander       º Data ³  02/19/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a gravação do SZY na manutenção do pedido de venda     º±±
±±º          ³ Chamado por dentro dos P.E. do pedido de venda             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GRAVASZY()
Local _nX, nDifere, nTotSZY, cAux

__nPosItem := aScan( aHeader, {|x| Alltrim( Upper( x[2] ) ) == "C6_ITEM" } )
__nPosProd := aScan( aHeader, {|x| Alltrim( Upper( x[2] ) ) == "C6_PRODUTO" } )
__nPosQtde := aScan( aHeader, {|x| Alltrim( Upper( x[2] ) ) == "C6_QTDVEN" } ) 
__nPosQEnt := aScan( aHeader, {|x| Alltrim( Upper( x[2] ) ) == "C6_QTDENT" } )           //mauresi
__nPosFat  := aScan( aHeader, {|x| Alltrim( Upper( x[2] ) ) == "C6_ENTRE3" } )
cAux       := "00"

For nItem := 1 to Len(aCols)
	
	cAux := Soma1(cAux)   //STRZERO(nItem,2)
	
	// Verifica se a Previsão está Preenchida
	If .F. // Len(aCols&cAux) > 0
		
		For nX := 1 to Len(aCols&cAux)
			
			// Deletando todo SZY se o SC6 estiver deletado
			If aCols[nItem,Len(aCols[nItem])]
				SZY->(dbSetOrder(1))
				//				Do While SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,1]))     //
				Do While SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,__nPosItem]))     //
					Reclock("SZY",.F.)
					SZY->(dbDelete())
					SZY->(MsUnlock())
				EndDo
				Loop
			EndIf
			
			// Deletando o SZY se o acols do SZY estiver deletado
			If aCols&cAux[nX,Len(aCols&cAux[nX])]
				SZY->(dbSetOrder(1))
				//				If SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols&cAux[nX,1]+aCols&cAux[nX,2]+aCols&cAux[nX,3]))
				If SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols&cAux[nX,__nPosItem]+"001"+aCols&cAux[nX,__nPosProd]))    // ZY_FILIAL+ZY_PEDIDO+ZY_ITEM+ZY_SEQ+ZY_PRODUTO
					Reclock("SZY",.F.)
					SZY->(dbDelete())
					SZY->(MsUnlock())
				EndIf
				Loop
			Endif
			
			SZY->(dbSetOrder(1))
			//			If !SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols&cAux[nX,1]+aCols&cAux[nX,2]+aCols&cAux[nX,3]))
			If !SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols&cAux[nX,__nPosItem]+"001"+aCols&cAux[nX,__nPosProd]))
				Reclock("SZY",.T.)
			Else
				Reclock("SZY",.F.)
			EndIf
			
			SZY->ZY_FILIAL  := xFilial("SZY")
			SZY->ZY_PEDIDO  := SC5->C5_NUM
			SZY->ZY_ITEM    :=  aCols&cAux[nX,__nPosItem]  // aCols&cAux[nX,1]
			SZY->ZY_SEQ     := "001"	//aCols&cAux[nX,2]
			SZY->ZY_PRODUTO := aCols[nItem,__nPosProd] //aCols&cAux[nX,3]
			SZY->ZY_DESC    := Posicione("SB1",1,xFilial("SB1")+aCols[nItem,__nPosProd],"B1_DESC")
			SZY->ZY_UM      := Posicione("SB1",1,xFilial("SB1")+aCols[nItem,__nPosProd],"B1_UM")
			SZY->ZY_QUANT   := aCols&cAux[nX,__nPosQtde]    //aCols&cAux[nX,6]
			
			// Alterado Por Michel Sander em 03.02.2017 para manter a data digitada na previsão
			If !Empty(aCols&cAux[nX,8])
				if EMPTY(SZY->ZY_PRVFAT)
					//	   	SZY->ZY_PRVFAT  := aCols&cAux[nX,8]
				endif
			Else
				if EMPTY(SZY->ZY_PRVFAT)
					//	   	SZY->ZY_PRVFAT  := aCols[nItem,__nPosFat]
				endif
			EndIf
			
			// CAMPO SERÁ DESCONTINUADO em 03.02.2017 POIS O SITE DE ENTREGA IRÁ PARA O SC6010
			//SZY->ZY_LOCENTR := aCols&cAux[nX,12]
			SZY->(MsUnlock())
			
		Next nX
		
	Else
		
		// Despreza item do ACOLS deletado
		SZY->(dbSetOrder(1))
		If aCols[nItem,Len(aCols[nItem])]
			//			Do While SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,1]))
			Do While SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,__nPosItem]))
				Reclock("SZY",.F.)
				SZY->(dbDelete())
				SZY->(MsUnlock())
			EndDo
			Loop
		EndIf
		
		SZY->(dbSetOrder(1))
		//////If !SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,1]+"001"+aCols[nItem,2]))
		//	If !SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,1]+"001")) // Alterado por Hélio em 23/05/16   __nPosItem
		If !SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,__nPosItem]+"001")) // Alterado por Hélio em 23/05/16   __nPosItem
			Reclock("SZY",.T.)
			SZY->ZY_FILIAL  := xFilial("SZY")
			SZY->ZY_PEDIDO  := SC5->C5_NUM
			SZY->ZY_ITEM    := aCols[nItem,__nPosItem]
			SZY->ZY_SEQ     := "001"
			SZY->ZY_PRODUTO := aCols[nItem,__nPosProd]
			SZY->ZY_DESC    := Posicione("SB1",1,xFilial("SB1")+aCols[nItem,__nPosProd],"B1_DESC")
			SZY->ZY_UM      := Posicione("SB1",1,xFilial("SB1")+aCols[nItem,__nPosProd],"B1_UM")
			SZY->ZY_QUANT   := aCols[nItem,__nPosQtde]
			SZY->ZY_PRVFAT  := aCols[nItem,__nPosFat]
			SZY->( MsUnlock() )
		Else
						
			aVetSZY := {}
			nTotSZY := 0
			While !SZY->( EOF() ) .and. SZY->ZY_FILIAL == xFilial("SZY") .and. SZY->ZY_PEDIDO == SC5->C5_NUM .and. SZY->ZY_ITEM == aCols[nItem,__nPosItem]
				If Empty(SZY->ZY_NOTA) .and. SZY->ZY_BLQ <> 'R'
					AADD(aVetSZY, SZY->( Recno() ) )
					nTotSZY += SZY->ZY_QUANT
				EndIf
				SZY->( dbSkip() )
			End

		   nQtdEnt := Posicione("SC6",1,xFilial("SC6")+SC5->C5_NUM+aCols[nItem,__nPosItem],"C6_QTDENT")
 			nDifere :=  aCols[nItem,__nPosQtde]  - nQtdEnt       - nTotSZY
//			nDifere :=  aCols[nItem,__nPosQtde]      - nTotSZY										
			
			For _nX := Len(aVetSZY) to 1 Step(-1)
				If nDifere <> 0
					SZY->( dbGoto(aVetSZY[_nX]) )
					If nDifere > 0
						Reclock("SZY",.F.)
						SZY->ZY_QUANT += nDifere                 // Quando aumenta o SC6
						SZY->( msUnlock() )
						Exit
					Else
						If SZY->ZY_QUANT > (nDifere*(-1))
							Reclock("SZY",.F.)
							SZY->ZY_QUANT -= (nDifere*(-1))       // Quando o SC6 diminui mas dá pra ajustar em um SZY
							SZY->( msUnlock() )
							Exit
						Else
							nDifere += SZY->ZY_QUANT
							Reclock("SZY",.F.)
							SZY->( dbDelete() )                  // Quando o SC6 diminui mas tem que deletar o SZY pq o mesmo não é suficiente
							SZY->( msUnlock() )
						EndIf
					EndIf
				EndIf
			Next x
			
			//nQtdItem   := 0
			//nQtdRegSZY := 0
			//While !SZY->( EOF() ) .and. SZY->ZY_PEDIDO == SC5->C5_NUM .and. SZY->ZY_ITEM == aCols[nItem,1]
			//	nQtdRegSZY++
			//	SZY->( dbSkip() )
			//End
			
			//SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM+aCols[nItem,1]+"001"))
			
			//While !SZY->( EOF() ) .and. SZY->ZY_PEDIDO == SC5->C5_NUM .and. SZY->ZY_ITEM == aCols[nItem,1]
			
			/*
			If Empty(SZY->ZY_NOTA)
			//	nQtdItem += SZY->ZY_QUANT
			//Else
			Reclock("SZY",.F.)
			SZY->ZY_FILIAL  := xFilial("SZY")
			SZY->ZY_PEDIDO  := SC5->C5_NUM
			//SZY->ZY_ITEM    := aCols[nItem,__nPosItem]
			//SZY->ZY_SEQ     := "001"
			SZY->ZY_PRODUTO := aCols[nItem,__nPosProd]
			SZY->ZY_DESC    := Posicione("SB1",1,xFilial("SB1")+aCols[nItem,__nPosProd],"B1_DESC")
			SZY->ZY_UM      := Posicione("SB1",1,xFilial("SB1")+aCols[nItem,__nPosProd],"B1_UM")
			//SZY->ZY_QUANT   := aCols[nItem,__nPosQtde]
			If !Empty(aCols[nItem,__nPosFat])
			if empty(SZY->ZY_PRVFAT)
			SZY->ZY_PRVFAT  := aCols[nItem,__nPosFat]
			endif
			EndIf
			SZY->( MsUnlock() )
			EndIf
			*/
			//SZY->( dbSkip() )
			//End
		EndIf
		
	EndIf
	
Next

Return
