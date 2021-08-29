#include "rwmake.ch"
#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GC6_PRODUTOºAutor  ³Helio Ferreira     º Data ³  12/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GC6_PRODUTO()
Local _Retorno     := ""
Local nPC6_LOCAL   := aScan(aHeader,{|aVet| AllTrim(aVet[2]) == "C6_LOCAL"   })
Local nPC6_PRODUTO   := aScan(aHeader,{|aVet| AllTrim(aVet[2]) == "C6_PRODUTO"   })
Local nPC6_XXPREVI := aScan(aHeader,{|aVet| AllTrim(aVet[2]) == "C6_XXPREVI" })
Local aAreaGER     := GetArea()
Local aAreaSA1     := SA1->( GetArea() )

_Retorno := aCols[n,nPC6_PRODUTO]

SB2->( dbSetOrder(1) )
If !SB2->( dbSeek( xFilial() + aCols[n,nPC6_PRODUTO] + '13' ) )
	aCampos := {;
	{"B2_COD"                ,XD1->XD1_COD   ,Nil},;
	{"B2_LOCAL"              ,'13'           ,Nil} }
	MSExecAuto({|x,y| MATA225(x,y)},aCampos,3)
EndIf
aCols[n,nPC6_LOCAL] := '13'
//aCols[n,nPC6_LOCAL] := '31'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Previsão de Vendas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SB1->( dbSetOrder(1) )
SA1->( dbSetOrder(1) )

If SA1->( dbSeek( xFilial() + M->C5_CLIENTE + M->C5_LOJAENT ) )
	SC4->( dbSetOrder(3) )   // C4_PRODUTO + C4_CNPJ + C4_DATA
	aPrivisoes := {}
	If SC4->( dbSeek( xFilial() + aCols[n,nPC6_PRODUTO] + Subs(SA1->A1_CGC,1,8) ) )
		While !SC4->( EOF() ) .and. SC4->C4_PRODUTO == aCols[n,nPC6_PRODUTO] .and. Subs(SC4->C4_XXCNPJ,1,8) == Subs(SA1->A1_CGC,1,8)
			If SC4->C4_DATA >= FirstDay(dDataBase)
				AADD(aPrivisoes, SC4->(Recno()) )
			EndIf
			SC4->( dbSkip() )
		End
	EndIf
	
	// Novo campo de Produto geral para Previsões de Vendas
	If SB1->( dbSeek( xFilial() + aCols[n,nPC6_PRODUTO] ) )
		If SB1->( FieldPos("B1_XPRVEND") ) > 0
			If !Empty(SB1->B1_XPRVEND)
				If SC4->( dbSeek( xFilial() + SB1->B1_XPRVEND + Subs(SA1->A1_CGC,1,8) ) )
					While !SC4->( EOF() ) .and. SC4->C4_PRODUTO == SB1->B1_XPRVEND .and. Subs(SC4->C4_XXCNPJ,1,8) == Subs(SA1->A1_CGC,1,8)
						If SC4->C4_DATA >= FirstDay(dDataBase)
							AADD(aPrivisoes, SC4->(Recno()) )
						EndIf
						SC4->( dbSkip() )
					End
				EndIf
			EndIf
		EndIf
	EndIf
	
	//If Len(aPrivisoes) == 0
	//	SC4->( dbSetOrder(4) ) // C4_CNPJ + C4_DATA + C4_PRODUTO
	//	If SC4->( dbSeek( xFilial() + Subs(SA1->A1_CGC,1,8) ) )
	//		aPrivisoes := {}
	//		//While !SC4->( EOF() ) .and. Subs(SC4->C4_XXCNPJ,1,8) == Subs(SA1->A1_CGC,1,8)
	//		While !SC4->( EOF() ) .and. Subs(SC4->C4_XXCNPJ,1,8) == Subs(SA1->A1_CGC,1,8) .and. SC4->C4_QUANT >0  //MLS   10/05/2016
	//			If SC4->C4_DATA >= FirstDay(dDataBase)
	//				AADD(aPrivisoes, SC4->(Recno()) )
	//			EndIf
	//			SC4->( dbSkip() )
	//		End
	//	EndIf
	//EndIf
	
	If Len(aPrivisoes) <> 0 .and. .F.  // Alterado por Hélio em 29/05/17 para não abrir mais a janela de previsões de Vendas.
		MarcaPrev()
	Else
		//MsgInfo("Não foram encontradas Previsões de Vendas para este Cliente.")
	EndIf
EndIf

RestArea(aAreaSA1)
RestArea(aAreaGER)

Return _Retorno


Static Function MarcaPrev()
Local _aStru   := {}

DEFINE MSDIALOG oDlgPrevi TITLE 'Seleção de Previsão de Vendas' FROM 000, 000  TO 280, 1000 COLORS 0, 16777215 PIXEL

/*
@ 011, 010 SAY oSay1 PROMPT "Rejeição :CFOP DE IMPORTAÇÃO, DI " 	SIZE 336, 024 OF oDlgNFE FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 037, 010 SAY oSay2 PROMPT "Nota Fiscal :" 	     	      SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
@ 050, 010 SAY oSay3 PROMPT "Serie :" 			            SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
@ 063, 010 SAY oSay3 PROMPT "Processo :" 	               SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL

@ 037, 050 MSGET oGet1 VAR _cPAR01 WHEN(.T.) F3 "SD1EIC" SIZE 050, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
@ 050, 050 MSGET oGet2 VAR _cPAR02 WHEN(.T.)             SIZE 030, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
@ 063, 050 MSGET oGet3 VAR _cPAR03 WHEN(.T.) F3 "SW6"    SIZE 050, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL

DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgNFE ENABLE Action (lImport :=.T., oDlgNFE:End() )
DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgNFE ENABLE Action (lLOOP   :=.F., oDlgNFE:End() )//oDlgNFE:End()
*/


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

AADD(_aStru, {"MARCA"       ,"C",01,0} )
AADD(_aStru, {"C4_PRODUTO"  ,"C",15,0} )
AADD(_aStru, {"B1_DESC"     ,"C",60,4} )
AADD(_aStru, {"C4_QUANT"    ,"N",10,2} )
AADD(_aStru, {"C4_XXQTDOR"  ,"N",10,2} )
AADD(_aStru, {"C4_DATA"     ,"D",08,0} )
AADD(_aStru, {"C4_OBS"      ,"C",30,0} )

_cArqTrab := CriaTrab(_aStru,.T.)

dbUseArea(.T.,__LocalDriver,_cArqTrab,"TRB",.F.)

IndRegua("TRB",_cArqTrab,"C4_PRODUTO+DTOS(C4_DATA)",,,)

_aCampos := {}

AADD(_aCampos,{"MARCA"       ,"" ,""            ,""                } )
AADD(_aCampos,{"C4_PRODUTO"  ,"" ,"Produto"     ,"@R"              } )
AADD(_aCampos,{"B1_DESC"     ,"" ,"Descrição"   ,"@R"              } )
AADD(_aCampos,{"C4_QUANT"    ,"" ,"Qtd.Atual"   ,"@E 9,999,999.99" } )
AADD(_aCampos,{"C4_XXQTDOR"  ,"" ,"Qtd.Original","@E 9,999,999.99" } )
AADD(_aCampos,{"C4_DATA"     ,"" ,"Data"        ,"@R"              } )
AADD(_aCampos,{"C4_OBS"      ,"" ,"Obs"         ,"@R"              } )

For x := 1 to Len(aPrivisoes)
	SC4->( dbGoTo(aPrivisoes[x]) )
	If SB1->( dbSeek( xFilial() + SC4->C4_PRODUTO ) )
		IF SC4->C4_QUANT>0 //MLS   10/05/2016
			Reclock("TRB",.T.)
			TRB->C4_PRODUTO := SC4->C4_PRODUTO
			TRB->B1_DESC    := SB1->B1_DESC
			TRB->C4_QUANT   := SC4->C4_QUANT
			TRB->C4_XXQTDOR := SC4->C4_XXQTDOR
			TRB->C4_DATA    := SC4->C4_DATA
			TRB->C4_OBS     := SC4->C4_OBS
			TRB->( msUnlock() )
		ENDIF
	EndIf
Next x

oMark:= MsSelect():New("TRB","MARCA",,_aCampos,Nil,Nil,{05,05,110,500})
oMark:oBrowse:oFont:= TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
oMark:oBrowse:Refresh()
//oMark:oBrowse:bAllMark  := { || fAllMark() }
oMark:bMark               := { || fMark()}
oMark:oBrowse:lCanAllmark := .F.


dbSelectArea("TRB")
dbGotop()

oMark:oBrowse:Refresh()

@ 120,100 BUTTON "Ok"       ACTION Processa( {|| fbOK(),oDlgPrevi:End() } ) SIZE 50,13 PIXEL OF oDlgPrevi
@ 120,170 BUTTON "Cancela"  ACTION Processa( {|| oDlgPrevi:End()} ) SIZE 50,13 PIXEL OF oDlgPrevi

ACTIVATE MSDIALOG oDlgPrevi CENTERED

Return

Static Function fMark()

Local nRecnoTemp := TRB->( recno() )

TRB->( dbGoTop() )
While !TRB->( EOF() )
	If TRB->( Recno() ) <> nRecnoTemp
		Reclock("TRB",.F.)
		TRB->MARCA := ' '
		TRB->( msUnlock() )
	EndIf
	TRB->( dbSkip() )
End
TRB->( dbGoTo(nRecnoTemp) )

oMark:oBrowse:Refresh()

Return


Static Function fbOK()

Local nPC6_PREVI := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XXPREVI" } )
Local nPC6_PREDT := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XXPREDT" } )

TRB->( dbGoTop() )
While !TRB->( EOF() )
	If !Empty(TRB->MARCA)
		aCols[N,nPC6_PREVI] := TRB->C4_PRODUTO
		aCols[N,nPC6_PREDT] := TRB->C4_DATA
	EndIf
	TRB->( dbSkip() )
End

Return
