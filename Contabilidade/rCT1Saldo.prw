#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³rCT1Saldo ºAutor  ³Osmar Ferreira      º Data ³  20/09/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Balancete por conta e item em tabela customizada           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function rCT1Saldo()
	Local nSldAnterior := 0
	Local nDebito      := 0
	Local nCredito     := 0
	Local nSldAtual    := 0

//Local nItSldAnterior := 0 
//Local nItDebito      := 0
//Local nItCredito     := 0
//Local nItSldAtual    := 0

	Local dtInicio       := Ctod("14/09/2017")
	Local dtFim          := Ctod("15/09/2017")
	Local dtDia          := Ctod("  /  /    ")
	Local aAreaZZV       := ZZV->(GetArea())
	Local aAreaCT1       := CT1->(GetArea())


//Criar janela para carregar parametros

///110201000000        C00313001

//CT1 / CT4 / CTD

	CT1->( dbSetOrder(01) )
	CT1->( dbGotop() )
	While  CT1->(!Eof())
		If CT1->CT1_FILIAL <> CT1->( xFilial() )
			CT1->(dbSkip())
			Loop
		EndIf
		If CT1->CT1_CLASSE <> "2"
			CT1->(dbSkip())
			Loop
		EndIf

		dtDia := dtInicio
		While dtDia <= dtFim
			nSldAnterior := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",6)
			nDebito      := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",2)
			nCredito     := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",3)
			nSldAtual    := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",1)
			If nSldAnterior <> 0 .Or. nDebito <> 0 .Or. nCredito <> 0 .Or. nSldAtual <> 0
				RecLock("ZZV",.T.)
				ZZV->ZZV_FILIAL  := xFilial("ZZV")
				ZZV->ZZV_DATA    := dtDia
				ZZV->ZZV_MES     := StrZero(Month(dtDia),2)
				ZZV->ZZV_ANO     := StrZero(Year(dtDia),4)
				ZZV->ZZV_CONTA   := CT1->CT1_CONTA
				ZZV->ZZV_SLDANT  := nSldAnterior
				ZZV->ZZV_DEBITO  := nDebito
				ZZV->ZZV_CREDITO := nCredito
				ZZV->ZZV_SLDATU  := nSldAtual
				ZZV->(msUnLock())
			EndIf

			//Ver item contabil
			If CT1->CT1_ACITEM == "1"

				//Verifica se há movimentação para a conta
				CT4->( dbSetOrder(02) )
				If CT4->(dbSeek(xFilial()+CT1->CT1_CONTA))
					//Percorre o CTD por todos os itens, buscando no CT4 a conta com o item
					CTD->(dbSetOrder(01))
					CTD->(dbGotop())
					While CTD->(!Eof())
					    If CTD->CTD_FILIAL <> CTD->(xFilial())
							CTD->(dbSkip())
							Loop
						EndIf	
						//VERIFICAR A CONTA E O ITEM NO CT4
						//If CT4->(dbSeek(xFilial("")+CT1->CT1_CONTA+SPACE(09)+ CTD->CTD_ITEM))
						If CT4->(dbSeek(xFilial()+CT1->CT1_CONTA+""+ CTD->CTD_ITEM))
							nSldAnterior := SALDOITEM(CT1->CT1_CONTA,"",CTD->CTD_ITEM,dtDia,"01", "1",6)
							nDebito      := SALDOITEM(CT1->CT1_CONTA,"",CTD->CTD_ITEM,dtDia,"01", "1",2)
							nCredito     := SALDOITEM(CT1->CT1_CONTA,"",CTD->CTD_ITEM,dtDia,"01", "1",3)
							nSldAtual    := SALDOITEM(CT1->CT1_CONTA,"",CTD->CTD_ITEM,dtDia,"01", "1",1)
							If nSldAnterior <> 0 .Or. nDebito <> 0 .Or. nCredito <> 0 .Or. nSldAtual <> 0
								RecLock("ZZV",.T.)
								ZZV->ZZV_FILIAL  := xFilial("ZZV")
								ZZV->ZZV_DATA    := dtDia
								ZZV->ZZV_MES     := StrZero(Month(dtDia),2)
								ZZV->ZZV_ANO     := StrZero(Year(dtDia),4)
								ZZV->ZZV_CONTA   := CT1->CT1_CONTA
								ZZV->ZZV_ITEM    := CTD->CTD_ITEM
								ZZV->ZZV_SLDANT  := nSldAnterior
								ZZV->ZZV_DEBITO  := nDebito
								ZZV->ZZV_CREDITO := nCredito
								ZZV->ZZV_SLDATU  := nSldAtual
								ZZV->(msUnLock())
							EndIf
						EndIf
						CTD->(dbSkip())
					EndDo
				EndIf
			EndIf

			dtDia := dtDia +1
		EndDo

		CT1->(dbSkip())
	EndDo


	Alert("Final....")


//Conta contabil
//nSldAnterior := SALDOCONTA("110129000100",Ctod("01/12/2020"),"01", "1",6)
//nDebito      := SALDOCONTA("110129000100",Ctod("31/12/2020"),"01", "1",2)
//nCredito     := SALDOCONTA("110129000100",Ctod("31/12/2020"),"01", "1",3)
//nSldAtual    := SALDOCONTA("110129000100",Ctod("31/12/2020"),"01", "1",1)


//RecLock("ZZV",.T.)
//    ZZV->ZZV_FILIAL  := xFilial("ZZV")
//    ZZV->ZZV_DATA    := dDataBase
//    ZZV->ZZV_MES     := StrZero(Month(dDataBase),2)
//    ZZV->ZZV_ANO     := StrZero(Year(dDataBase),4)
//    ZZV->ZZV_CONTA   := "110129000100"
//    ZZV->ZZV_SLDANT  := nSldAnterior
//    ZZV->ZZV_DEBITO  := nDebito
//    ZZV->ZZV_CREDITO := nCredito
//    ZZV->ZZV_SLDATU  := nSldAtual
//ZZV->(msUnLock())



//Alert(nSldAnterior)
//Alert(nDebito)
//Alert(nCredito)
//Alert(nSldAtual)


//nItSldAnterior := SALDOITEM("110129000100","","2101",Ctod("31/12/2020"),"01", "1",6)
//nItDebito      := SALDOITEM("110129000100","","2101",Ctod("31/12/2020"),"01", "1",2)
//nItCredito     := SALDOITEM("110129000100","","2101",Ctod("31/12/2020"),"01", "1",3)
//nItSldAtual    := SALDOITEM("110129000100","","2101",Ctod("31/12/2020"),"01", "1",1)

//Alert(nItSldAnterior)
//Alert(nItDebito)
//Alert(nItCredito)
//Alert(nItSldAtual)


	RestArea(aAreaCT1)
	RestArea(aAreaZZV)
Return (Nil)
