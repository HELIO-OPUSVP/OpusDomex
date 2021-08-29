#include "rwmake.ch"
#include "totvs.ch"
#include "Topconn.ch"
#Include "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410INC  ºAutor  ³Helio Ferreira      º Data ³  06/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Roda depois da gravação do Pedido de Vendas                º±±
±±º          ³                                                            º±±
±±º          ³ Criado para atualizar a amarração de Código do cliente     º±±
±±º          ³                                                            º±±
±±º          ³ na tabela SA7                                              º±±
±±º          ³                                                            º±±
±±º          ³ Alterado para baixar a Previsão de Vendas                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT410INC()

Local aAreaGER    := GetArea()
Local aAreaSA7    := SA7->( GetArea() )
Local aAreaSC5    := SC5->( GetArea() )
Local aAreaSC6    := SC6->( GetArea() )
Local aAreaSA1    := SA1->( GetArea() )
Local aAreaSB1	  := SB1->( GetArea() )
Local aAreaAtuSv  := GetArea()
Local nPC6PRODUTO := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
Local nPC6SEUCOD  := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "C6_SEUCOD"  } )
Local cCodCli     := M->C5_CLIENTE
Local cLojCli     := M->C5_LOJAENT
Local x 		  := 0
Local cQryTemST	  := ""

SA7->( dbSetOrder(1) )
For x := 1 to Len(aCols)
	If !aCols[x,Len(aHeader)+1]
		If !Empty(aCols[x,nPC6SEUCOD])
			If SA7->( dbSeek( xFilial() + cCodCli + cLojCli + aCols[x,nPC6PRODUTO] ) )
				If Alltrim(SA7->A7_CODCLI) <> Alltrim(aCols[x,nPC6SEUCOD])
					Reclock("SA7",.F.)
					SA7->A7_CODCLI := Alltrim(aCols[x,nPC6SEUCOD])
					SA7->( msUnlock() )
				EndIf
			Else
				Reclock("SA7",.T.)
				SA7->A7_FILIAL  := xFilial("SA7")
				SA7->A7_CLIENTE := cCodCli
				SA7->A7_LOJA    := cLojCli
				SA7->A7_PRODUTO := aCols[x,nPC6PRODUTO]
				SA7->A7_CODCLI  := Alltrim(aCols[x,nPC6SEUCOD])
				SA7->( msUnlock() )
			EndIf
		EndIf
	EndIf
Next x

//Verificar se o pedido possui ST e atualizar o campo C5_XXTEMST
aAreaAtuSv := GetArea()
cQryTemST := " SELECT C6_NUM,C5_TIPOCLI, SUM(C6_ICMSRET) ICMSRET "
cQryTemST += " FROM " + RetSqlName("SC6") + " SC6 "
cQryTemST += " JOIN " + RetSqlName("SC5") + " SC5 ON SC5.D_E_L_E_T_ ='' AND SC5.C5_FILIAL  =SC6.C6_FILIAL AND SC5.C5_NUM= SC6.C6_NUM AND SC5.C5_CLIENTE = SC6.C6_CLI "
cQryTemST += " WHERE SC6.D_E_L_E_T_ ='' AND SC5.C5_FILIAL  ='" + SC5->C5_FILIAL + "' AND LEFT(C6_CF,2) IN ('54','64') "
cQryTemST += " AND SC5.C5_NUM = '" + SC5->C5_NUM  + "' "
cQryTemST += " GROUP BY C6_NUM,C5_TIPOCLI "
If Select("TMPTST") > 0
	TMPTST->(DbCloseArea())
endif
TCQUERY cQryTemST NEW ALIAS "TMPTST"
If TMPTST->(!EOF())
	RecLock("SC5",.F.)
		SC5->C5_XXTEMST := "S"
	SC5->(MsUnlock())
EndIf
TMPTST->(DbCloseArea())
RestArea(aAreaAtuSv)

// Previsão de Vendas
SC6->( dbSetOrder(1) )
SC4->( dbSetOrder(3) )  // C4_FILIAL + C4_PRODUTO + C4_CNPJ + C4_DATA
SA1->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )

If SC5->C5_TIPO == 'N'
	If SC6->( dbSeek( xFilial() + SC5->C5_NUM ) )
		If SA1->( dbSeek( xFilial() + SC5->C5_CLIENTE + SC5->C5_LOJAENT ) )
			While !SC6->( EOF() ) .and. SC6->C6_NUM == SC5->C5_NUM
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Quando se usava gravar as previsões no SC6³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				
				//If !Empty(SC6->C6_XXPREVI)
				//	If SC4->( dbSeek( xFilial() + SC6->C6_XXPREVI + Subs(SA1->A1_CGC,1,8) + Space(6) + DtoS(SC6->C6_XXPREDT) ) )
				//		Reclock("SC4",.F.)
				//		SC4->C4_QUANT := If((SC4->C4_QUANT-SC6->C6_QTDVEN)>0,SC4->C4_QUANT-SC6->C6_QTDVEN,0)
				//		SC4->( msUnlock() )
				//		Reclock("SC6",.F.)
				//		SC6->C6_XXPREQT := SC6->C6_QTDVEN
				//		SC6->( msUnlock() )
				//	Else
				//	   //MsgStop("Previsão de Vendas não encontrada para o produto " + Alltrim(SC6->C6_XXPREVI) + " na data " + CtoD(SC6->C6_XXPREDT) + ".")
				//	EndIf
				//EndIf
				
				If !Empty(SC6->C6_ENTREG)
					If SC4->( dbSeek( xFilial() + SC6->C6_PRODUTO + Subs(SA1->A1_CGC,1,8) + Space(6) + Subs(DtoS(SC6->C6_ENTREG),1,6) ) )
						Reclock("SC4",.F.)
						SC4->C4_QUANT := If((SC4->C4_QUANT-SC6->C6_QTDVEN)>0,SC4->C4_QUANT-SC6->C6_QTDVEN,0)
						SC4->( msUnlock() )
						If Date() = StoD("20170530")
						   MsgInfo("Baixando saldo da Previsão de Vendas")
						EndIf
					Else
						SB1->( dbSeek( xFilial() + SC6->C6_PRODUTO ) ) 
						If SC4->( dbSeek( xFilial() + SB1->B1_XPRVEND + Subs(SA1->A1_CGC,1,8) + Space(6) + Subs(DtoS(SC6->C6_ENTREG),1,6) ) )
							Reclock("SC4",.F.)
							SC4->C4_QUANT := If((SC4->C4_QUANT-SC6->C6_QTDVEN)>0,SC4->C4_QUANT-SC6->C6_QTDVEN,0)
							SC4->( msUnlock() )
							If Date() = StoD("20170530")
						      MsgInfo("Baixando saldo da Previsão de Vendas")
						   EndIf
   					EndIf
					EndIf
				Else
					If Date() = StoD("20170530")
					   MsgInfo("Não foi possível baixar o saldo da Previsão de Vendas. Data do Cliente não informada.")
					EndIf
				EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÆXå«Xå«¿
			//³Atualiza CFOP do PV com CFOP da TES, caso esteja Diferente³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÆXå«Xå«Ù
				_xxCF	:= POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_CF")
				_cUF	:= SA1->A1_EST
				if SC6->C6_CF  <> _xxCF 
					if _cUF <> "SP"
                  		if _cUF == "EX"
	                  		_cDig := "7"  
                  		else
	                  		_cDig := "6"  
                  		endif
				
						Reclock("SC6",.F.)
							SC6->C6_CF := _cDig+Substr(_xxCF,2,3)  //"6"+Substr(_xxCF,2,3)
						SC6->( msUnlock() )						
				   endif
				endif

				SC6->( dbSkip() )
			End
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui a previsão de faturamento por item ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
U_GRAVASZY()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza Tabela de TES INTELIGENTE DOMEX³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SB1->( dbSetOrder(1) )
ZFM->( dbSetOrder(1) )


RestArea(aAreaSB1)
RestArea(aAreaSA1)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA7)
RestArea(aAreaGER)

//Posiciona o browser
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+M->C5_NUM))

Return
