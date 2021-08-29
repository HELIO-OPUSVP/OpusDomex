#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VD1_TES    ºAutor  ³Helio Ferreira     º Data ³  19/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa criado para validar o D1_TES e não deixar a NF serº±±
±±º          ³ classificada com uma tes que atualize estoque para um      º±±
±±º          ³ produto sem controle de Endereçamento.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VD1_TES()

Local _Retorno   := .T.
Local aAreaGER   := GetArea()
Local aAreaSF4   := SF4->( GetArea() )
Local aAreaSB1   := SB1->( GetArea() )
Local nPD1_COD   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == 'D1_COD'   } )
Local nPD1_XOPER := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == 'D1_XOPER' } )
Local nPD1_ITEM  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == 'D1_ITEM' } )
Local cProduto   := aCols[n,nPD1_COD]
Local cFornece   := CA100FOR
Local cLoja      := CLOJA
Local cOperacao  := aCols[n,nPD1_XOPER]

If Type("l103Class") == "U"
	l103Class := .F.
EndIf

If _Retorno
	// Validando a TES com o cadastro de TES Inteligente
	If aCols[n,nPD1_XOPER] <> '99' .and. !Empty(aCols[n,nPD1_XOPER]) .and. aCols[n,nPD1_XOPER] <> '05' // 05=serviços
	   ZZ5->( dbSetOrder(1) )
	   If ZZ5->( dbSeek( xFilial() + cProduto + cFornece + cLoja + cOperacao) )
	      If M->D1_TES <> ZZ5->ZZ5_TES1
	         MsgInfo("TES informada ("+M->D1_TES+") diferente da cadastrada como TES Inteligente ("+ZZ5->ZZ5_TES1+")")
	         // _Retorno := .F.
	      EndIf
	   Else
	      If MsgNoYes("Cadastro de TES Inteligente não encontrado para esta Operação. Deseja incluir um registro com essas informações?" + ChR(13) + "Produto: " + cProduto + Chr(13) + "Fornecedor/Loja " + cFornece + '/' + cLoja + Chr(13) + "Operação: " + cOperacao )
	         Reclock("ZZ5",.T.)
	         ZZ5->ZZ5_FILIAL := xFilial("ZZ5")
	         ZZ5->ZZ5_TIPO   := cOperacao
	         ZZ5->ZZ5_FORNEC := cFornece
	         ZZ5->ZZ5_LOJAFO := cLoja
	         ZZ5->ZZ5_CODPRO := cProduto
	         ZZ5->ZZ5_TES1   := M->D1_TES
	         ZZ5->ZZ5_NF1    := CNFISCAL
	         ZZ5->ZZ5_IT1    := aCols[N,nPD1_ITEM]
	         ZZ5->ZZ5_NOME1  := UsrRetName(__cUserID)
	         ZZ5->ZZ5_DT1    := Date()
	         ZZ5->ZZ5_MSBLQL := '2'
	         ZZ5->( msUnlock() )
	      Else
	         // _Retorno := .F.
	      EndIf
	   EndIf
	EndIf
EndIf

If  _Retorno
	If l103Class
		SF4->( dbSetOrder(1) )
		If SF4->( dbSeek( xFilial() + M->D1_TES ) )
			If SF4->F4_ESTOQUE == 'S'
				SB1->( dbSetOrder(1) )
				If SB1->( dbSeek( xFilial() + aCols[N,nPD1_COD] ) )
					// Validando produtos sem endereçamento
					If SB1->B1_TIPO <> 'SI' .and. SB1->B1_TIPO <> 'PA' .and. !Localiza(aCols[N,nPD1_COD])
						MsgStop("Não é possível utilizar uma Tes que atualize estoque para produtos sem controle de Endereçamento.")
						_Retorno := .F.
					EndIf
					
					If SB1->B1_TIPO <> 'SI' .and. SB1->B1_TIPO <> 'PA' .and. !Rastro(aCols[N,nPD1_COD])
						MsgStop("Não é possível utilizar uma Tes que atualize estoque para produtos sem controle de Lote.")
						_Retorno := .F.
					EndIf
					
					// Trecho Abaixo desabilitado por Marco Aurelio-OPUS em 6/04/16 após o Denis informar que este processo na existe mais.
					// Agora as notas podem ser classificadas sem ter uma Etiqueta Emitida.
					
					// Validando se já foram emitidas etiquetas
					/*
					If ALTERA .and. _Retorno .and. CUFORIG <> 'EX'
					If SB1->B1_TIPO <> 'SI'
					XD1->( dbSetOrder(2) )
					If !XD1->( dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEM))
					MsgStop("Não é possível classificar uma NF que não teve a etiqueta de identificação de materiais emitida.")
					_Retorno := .F.
					EndIf
					EndIf
					EndIf
					*/
					
				EndIf
			EndIf
		EndIf
	Else
		SF4->( dbSetOrder(1) )
		If SF4->( dbSeek( xFilial() + M->D1_TES ) )
			If SF4->F4_ESTOQUE == 'S'
				SB1->( dbSetOrder(1) )
				If SB1->( dbSeek( xFilial() + aCols[N,nPD1_COD] ) )
					// Validando produtos sem endereçamento
					If SB1->B1_TIPO <> 'SI' .and. SB1->B1_TIPO <> 'PA' .and. !Localiza(aCols[N,nPD1_COD])
						MsgStop("Não é possível utilizar uma Tes que atualize estoque para produtos sem controle de Endereçamento.")
						_Retorno := .F.
					EndIf
					
					If SB1->B1_TIPO <> 'SI' .and. SB1->B1_TIPO <> 'PA' .and. !Rastro(aCols[N,nPD1_COD])
						MsgStop("Não é possível utilizar uma Tes que atualize estoque para produtos sem controle de Lote.")
						_Retorno := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aAreaGER)

Return _Retorno
