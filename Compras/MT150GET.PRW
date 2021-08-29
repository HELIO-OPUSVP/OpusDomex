
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT150GET  ºAutor  ³Osmar Ferreira      º Data ³  02/02/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alterar itens da cotação no momento em que se atualiza uma  º±±
±±º          ³cotação.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MT150GET()
	Local aCols := Paramixb[1]      //-- Rotina de customização do usuárioReturn aCols
	Local n     := 1
	Local nPosC8Recno    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_REC_WT'})
	Local nPosC8CodTab   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_CODTAB'})
	Local nPosC8Produto  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_PRODUTO'})
	Local nPosC8Unitario := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_PRECO'})
	Local nPosC8Total    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_TOTAL'})
	Local nPosC8Quant    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_QUANT'})
	Local aAreaGeral := GetArea()
	Local aAreaSC8   := SC8->(GetArea())
	Local aAreaSA2   := SA2->(GetArea())
	Local aAreaAIB   := AIB->(GetArea())
	Private cFornece := Space(6)
	Private cLoja    := Space(2)
	Private cTabela  := Space(3)

	If Len(aCols) > 0

		U_fTabela(aCols[1,nPosC8Recno])
		AIB->(dbSetOrder(2))
		For n:=1 To Len(aCols)
			If AIB->(dbSeek(xFilial()+cFornece+cLoja+cTabela+aCols[n,nPosC8Produto]))
				//If Empty(aCols[n,nPosC8CodTab])
				If Empty(aCols[n,nPosC8Unitario])
					aCols[n,nPosC8CodTab]   := cTabela
					aCols[n,nPosC8Unitario] := AIB->AIB_PRCCOM
					aCols[n,nPosC8Total]    := aCols[n,nPosC8Quant] * AIB->AIB_PRCCOM
				EndIf
			EndIf
		Next n
	EndIf

	RestArea(aAreaAIB)
	RestArea(aAreaSA2)
	RestArea(aAreaSC8)
	RestArea(aAreaGeral)

Return aCols

///////////////////////////////////////////////////////
///
/// Retorna o código da tabela de preço por fornecedor
//                                                   
///////////////////////////////////////////////////////
User Function fTabela(nRecord)
	Local nRegistroAtual

	nRegistroAtual := SC8->(Recno())

	SC8->(dbGoto(nRecord))

	cFornece := SC8->C8_FORNECE
	cLoja    := SC8->C8_LOJA

	SC8->(dbGoto(nRegistroAtual))

	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial()+cFornece+cLoja))
		cTabela := SA2->A2_XTABELA
	EndIf

Return
