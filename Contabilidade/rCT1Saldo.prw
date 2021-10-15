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
	Local nIniMes, nFimMes   := 0
	Local nIniAno, nFimAno   := 0
	Local wMes, wAno   := 0
	Local dtInicio     := Ctod("99/99/9999")
	Local dtFim        := Ctod("99/99/9999")
	Local dtDia        := Ctod("  /  /    ")
	Local nContas      := 0
	Local X			   := 0
	Local aAreaZZV     := ZZV->(GetArea())
	Local aAreaCT1     := CT1->(GetArea())
    Private _cPerg     := "CT1SLD"+Space(04)

   
	fCriaPerg(_cPerg)

If !Pergunte(_cPerg, .T.)
   Return
EndIf   

    nIniMes  := MV_PAR01
	nIniAno  := MV_PAR02
	nFimMes  := MV_PAR03
	nFimAno  := MV_PAR04

	dtInicio := Ctod("01/"+StrZero(nIniMes,2)+"/"+Str(nIniAno))
	wMes := nFimMes + 1
	wAno := nFimAno 
	If wMes = 13 
		wMes := 1
		wAno := wAno + 1
	EndIf

	dtFim := Ctod("01/"+StrZero(wMes,2)+"/"+Str(wAno))
	dtFim := dtFim -1

	ZZV->(dbSetOrder(02))
	ZZV->(dbSeek(xFilial()+StrZero(MV_PAR01,2)+Str(MV_PAR02)))
	While (ZZV->ZZV_DATA >= dtInicio .And. ZZV->ZZV_DATA <= dtFim) .And.  ZZV->(!Eof())
		If ZZV->ZZV_CONTA >= MV_PAR05 .And. ZZV->ZZV_CONTA <= MV_PAR06
			Reclock("ZZV",.F.)
			ZZV->(dbDelete())
			ZZV->(msUnlock())
		EndIf
		ZZV->(dbSkip())	
	EndDo


	nContas := CT1->(RecCount())
	ProcRegua(nContas)

	CT1->( dbSetOrder(01) )
	CT1->( dbGotop() )
	While  CT1->(!Eof())
		x++
		IncProc("Gerando a conta.....: " + CT1->CT1_CONTA + "   -    " + Str(x)+"/"+Str(nContas) )

 		If CT1->CT1_FILIAL <> CT1->( xFilial() )
			CT1->(dbSkip())
			Loop
		EndIf

		If CT1->CT1_CLASSE <> "2"
			CT1->(dbSkip())
			Loop
		EndIf

		If CT1->CT1_CONTA < MV_PAR05 .Or. CT1->CT1_CONTA > MV_PAR06
			CT1->(dbSkip())
			Loop
		EndIf

		dtDia := dtInicio
		While dtDia <= dtFim
			nSldAnterior := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",6)
			//nDebito      := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",2)
			//nCredito     := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",3)
			//nSldAtual    := SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",1)
			wMes := StrZero(Month(dtDia),2)
			wAno := StrZero(Year(dtDia),4)
		
			nDebito  := 0
			nCredito := 0
			
			While StrZero(Month(dtDia),2) == wMes .And. StrZero(Year(dtDia),4) == wAno 
   				nDebito   += SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",2)
				nCredito  += SALDOCONTA(CT1->CT1_CONTA,dtDia,"01", "1",3)
				dtDia := dtDia +1
			EndDo

			nSldAtual := SALDOCONTA(CT1->CT1_CONTA,(dtDia-1),"01", "1",1)

			If nSldAnterior <> 0 .Or. nDebito <> 0 .Or. nCredito <> 0 .Or. nSldAtual <> 0
				RecLock("ZZV",.T.)
				ZZV->ZZV_FILIAL  := xFilial("ZZV")
				ZZV->ZZV_DATA    := dtDia -1
				ZZV->ZZV_MES     := wMes  //StrZero(Month(dtDia),2)
				ZZV->ZZV_ANO     := wAno  //StrZero(Year(dtDia),4)
				ZZV->ZZV_CONTA   := CT1->CT1_CONTA
				ZZV->ZZV_SLDANT  := nSldAnterior
				ZZV->ZZV_DEBITO  := nDebito
				ZZV->ZZV_CREDITO := nCredito
				ZZV->ZZV_SLDATU  := nSldAtual
				ZZV->(msUnLock())
			EndIf

			
			/*
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
			*/
		EndDo
		CT1->(dbSkip())
	EndDo


	Alert("Tabela gerada (ZZV)....")

	RestArea(aAreaCT1)
	RestArea(aAreaZZV)
Return (Nil)



Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Mes Inicial (99)?   ","","","mv_ch1","N",02,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Ano Inicial (9999)? ","","","mv_ch2","N",04,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","Mes Final (99)?     ","","","mv_ch3","N",02,00,00,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"04","Ano Final (9999)?   ","","","mv_ch4","N",04,00,00,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"05","Conta Inicial?      ","","","mv_ch5","C",20,00,00,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
AADD(aRegistros,{_cPerg,"06","Conta Final?        ","","","mv_ch6","C",20,00,00,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})

DbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	Endif
Next i
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)

