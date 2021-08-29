#Include "Matr120.ch"
#Include "FIVEWIN.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR120  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 12.06.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da Rela‡„o de Pedidos de Compras                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.	/  .F.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DMXMR120()
Local oReport

//If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
//Else
	//MATR120R3()
//EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³12.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(nReg)

Local oReport 
Local oSection1
Local oSection2 
Local oSection3 
Local oSection4
Local oSection5
Local oCell         
Local aOrdem	:= {}
#IFNDEF TOP
	Local cAliasSC7 := "SC7"	
#ELSE
	Local cAliasSC7 := GetNextAlias()
#ENDIF
PRIVATE cPerg := "DMR120"
AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("MATR120",STR0007,"DMR120", {|oReport| ReportPrint(oReport,cAliasSC7)},STR0001+" "+STR0002+" "+STR0003) //"Relacao de Pedidos de Compras"##"Emissao da Relacao de  Pedidos de Compras."##"Sera solicitado em qual Ordem, qual o Intervalo para"##"a emissao dos pedidos de compras."
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)
Pergunte("DMR120",.F.)
Aadd( aOrdem, STR0004 ) // "Por Numero"
Aadd( aOrdem, STR0005 ) // "Por Produto"
Aadd( aOrdem, STR0006 ) // "Por Fornecedor"
Aadd( aOrdem, STR0049 ) // "Por Previsao de Entrega "

oSection1 := TRSection():New(oReport,STR0062,{"SC7","SA2","SB1"},aOrdem) //"Relacao de Pedidos de Compras"
oSection1 :SetTotalInLine(.F.)

TRCell():New(oSection1,"C7_NUM","SC7",STR0065/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Num.PC"
TRCell():New(oSection1,"C7_NUMSC","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C7_LOJA","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_TEL","SA2",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_FAX","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_CONTATO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"COMPRADOR"," ","Comprador" ,/*Picture*/,40,/*lPixel*/,{||Alltrim(ImpCompr(cAliasSC7)) }) //"ENTREGA PREVISTA :  "
TRCell():New(oSection1,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection1,"cDescri","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescri(cAliasSC7) })
TRCell():New(oSection1,"C7_DATPRF","SC7",STR0052,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"ENTREGA PREVISTA :  "
oSection1:Cell("cDescri"):GetFieldInfo("B1_DESC")             

oSection2 := TRSection():New(oSection1,STR0063,{"SC7","SA2","SB1"}) 
oSection2 :SetTotalInLine(.F.)
oSection2 :SetHeaderPage()
oSection2 :SetTotalText(STR0033) //"Total Geral "

TRCell():New(oSection2,"C7_NUM","SC7",STR0065/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"Num.PC"
TRCell():New(oSection2,"C7_ITEM","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"cDescri","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescri(cAliasSC7) })
oSection2:Cell("cDescri"):GetFieldInfo("B1_DESC")
TRCell():New(oSection2,"B1_GRUPO","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_EMISSAO","SC7",STR0068/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"Emissao"
TRCell():New(oSection2,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_LOJA","SC7",STR0067/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"Lj"
TRCell():New(oSection2,"A2_NOME","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"A2_TEL","SA2",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,"COMPRADOR","","Comprador" ,/*Picture*/,40,/*lPixel*/,{||Alltrim(POSICIONE("SY1",3,XFILIAL("SY1")+SC7->C7_USER,"Y1_NOME")) }) 
TRCell():New(oSection2,"C7_DATPRF","SC7",STR0066/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) //"Entrega"
TRCell():New(oSection2,"C7_QUANT","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_UM","SC7",STR0069/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)//"UM"
TRCell():New(oSection2,"nVlrUnit","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVunit(cAliasSC7) }) 
oSection2:Cell("nVlrUnit"):GetFieldInfo("C7_PRECO")
TRCell():New(oSection2,"C7_VLDESC","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpDescon(cAliasSC7) }) 
TRCell():New(oSection2,"nVlrIPI","   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVIPI(cAliasSC7) })
oSection2:Cell("nVlrIPI"):GetFieldInfo("C7_VALIPI")
TRCell():New(oSection2,"C7_TOTAL","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ImpVTotal(cAliasSC7) })
TRCell():New(oSection2,"C7_QUJE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"nQtdRec","   ",STR0060,PesqPict('SC7','C7_QUANT'),/*Tamanho*/,/*lPixel*/,{|| If(Empty((cAliasSC7)->C7_RESIDUO),IIF((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE<0,0,(cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE),0) }) //Quant.Receber
TRCell():New(oSection2,"nSalRec","   ",STR0061,PesqPict('SC7','C7_TOTAL'),TamSX3("C7_TOTAL")[1],/*lPixel*/,{|| ImpSaldo(cAliasSC7) }) //Saldo Receber
TRCell():New(oSection2,"C7_RESIDUO","   ",STR0070+CRLF+STR0071/*Titulo*/,/*Picture*/,3,/*lPixel*/,{|| If(Empty((cAliasSC7)->C7_RESIDUO),STR0031,STR0032) }) //"Res."##"Elim."

TRFunction():New(oSection2:Cell("nVlrIPI"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 
TRFunction():New(oSection2:Cell("C7_TOTAL"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nSalRec"),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSC7)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)  
Local oBreak
Local nTxMoeda	:= 1
Local lFirst    := .F.
Local nOrdem    := oReport:Section(1):GetOrder() 
Local nTamDPro	:= If( TamSX3("C7_PRODUTO")[1] > 15, 20, 30 )
Local nFilters 	:= 0
Local nI

#IFNDEF TOP
	Local cCondicao := ""
#ELSE
	Local cWhere := ""
	Local cFrom := "%%"
#ENDIF

Local lFilUsr	:= oSection1:GetAdvplExp() <> ""

dbSelectArea("SC7")
If nOrdem == 4
	dbSetOrder(16) 
Else
	dbSetOrder(nOrdem)
EndIf

If nOrdem == 1
	If ( cPaisLoc$"ARG|POR|EUA" )	//Ordena los pedidos de compra y luego la AE.
		dbSetOrder(10)
	Endif	
	oReport:SetTitle( oReport:Title()+STR0014) // " - POR NUMERO"
	oSection1 :SetTotalText(STR0034) //"Total dos Itens: " 
ElseIf nOrdem == 2
	oReport:SetTitle( oReport:Title()+STR0018) //" - POR PRODUTO"
	oSection1 :SetTotalText(STR0035) //"Total do Produto"
ElseIf nOrdem == 3
	oReport:SetTitle( oReport:Title()+STR0022) //" - POR FORNECEDOR"
	oSection1 :SetTotalText(STR0036) //"Total do Fornecedor"
ElseIf nOrdem == 4
	oReport:SetTitle( oReport:Title()+STR0053) //" - POR PREVISAO DE ENTREGA"
	oSection1 :SetTotalText(STR0043) //"Total da Previsao de Entrega"
Endif

If mv_par07==1
	oReport:SetTitle( oReport:Title()+STR0025) //", Todos"
Elseif mv_par07==2
	oReport:SetTitle( oReport:Title()+STR0026) //", Em Abertos"
Elseif mv_par07==3
	oReport:SetTitle( oReport:Title()+STR0027) //", Residuos"
Elseif mv_par07==4
	oReport:SetTitle( oReport:Title()+STR0028) //", Atendidos"
Elseif mv_par07==5
	oReport:SetTitle( oReport:Title()+STR0059) //", Atendidos + Parcial entregue"
Endif
oReport:SetTitle( oReport:Title()+" - " + GetMv("MV_MOEDA"+STR(mv_par13,1))) //" MOEDA "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	

	cWhere :="%"

	If mv_par11 == 1 
		cWhere += "AND C7_CONAPRO <> 'B' "	
	ElseIf mv_par11 == 2
		cWhere += "AND C7_CONAPRO = 'B' "	
	Endif

	If mv_par07 == 2 
		cWhere += "AND ( (C7_QUANT-C7_QUJE) > 0 ) "	
		cWhere += "AND C7_RESIDUO = ' ' "
	ElseIf mv_par07 == 3
		cWhere += "AND C7_RESIDUO <> ' ' "
	ElseIf mv_par07 == 4
		cWhere += "AND C7_QUANT <= C7_QUJE "	
	ElseIf mv_par07 == 5
		cWhere += "AND C7_QUJE > 0 "		
	Endif
	
	If mv_par10 == 1 
		cWhere += "AND C7_TIPO = 1 "	
	ElseIf mv_par10 == 2
		cWhere += "AND C7_TIPO = 2 "	
	Endif
	
	If mv_par12 == 1 //Firmes
		cWhere += "AND (C7_TPOP = 'F' OR C7_TPOP = ' ') "	
	ElseIf mv_par12 == 2 //Previstas
		cWhere += "AND C7_TPOP = 'P' "	
	Endif
	
	If lFilUsr
		nFilters := len(oSection1:aUserFilter)
		
		cFrom := "%"
		
		For nI := 1 to nFilters
			If oSection1:aUserFilter[nI][1] == "SA2" .And. oSection1:aUserFilter[nI][2] <> ""
				cFrom += "," + RetSqlName("SA2") + " SA2 "
				cWhere += "AND C7_FORNECE = A2_COD AND SA2.D_E_L_E_T_ = ' ' "
				If FWModeAccess("SC7")=="E" .And. FWModeAccess("SA2")=="E"
					cWhere += "AND SC7.C7_FILIAL = SA2.A2_FILIAL "
				Endif
				
			ElseIf	oSection1:aUserFilter[nI][1] == "SB1" .And. oSection1:aUserFilter[nI][2] <> ""
				cFrom += "," + RetSqlName("SB1") + " SB1 "
				cWhere += "AND C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ' ' "
				If FWModeAccess("SC7")=="E" .And. FWModeAccess("SB1")=="E"
					cWhere += "AND SC7.C7_FILIAL = SB1.B1_FILIAL "
				Endif
			Endif	
		Next nI
		
		cFrom += "%" 
	Endif

	cWhere +="%"	

	BeginSql Alias cAliasSC7

	SELECT SC7.*
	
	FROM %table:SC7% SC7 %Exp:cFrom%
	
	WHERE C7_FILIAL = %xFilial:SC7% AND 
		  C7_NUM >= %Exp:mv_par08% AND 
		  C7_NUM <= %Exp:mv_par09% AND 	 	  
		  C7_PRODUTO >= %Exp:mv_par01% AND 
		  C7_PRODUTO <= %Exp:mv_par02% AND 
  		  C7_EMISSAO >= %Exp:Dtos(mv_par03)% AND 
		  C7_EMISSAO <= %Exp:Dtos(mv_par04)% AND 
  		  C7_DATPRF >= %Exp:Dtos(mv_par05)% AND 
		  C7_DATPRF <= %Exp:Dtos(mv_par06)% AND 		  
	 	  C7_FORNECE >= %Exp:mv_par15% AND 
		  C7_FORNECE <= %Exp:mv_par16% AND 
		  C7_USER >= %Exp:mv_par17% AND
		  C7_USER <= %Exp:mv_par18% AND
		  SC7.%NotDel% 
		  %Exp:cWhere%
		  
	ORDER BY %Order:SC7% 
			
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

#ELSE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao Advpl                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'C7_FILIAL == "'+xFilial("SC7")+'".And.' 
	cCondicao += 'C7_NUM >= "'+mv_par08+'".And.C7_NUM <="'+mv_par09+'".And.'
	cCondicao += 'C7_PRODUTO >= "'+mv_par01+'".And.C7_PRODUTO <="'+mv_par02+'".And.'
	cCondicao += 'Dtos(C7_EMISSAO) >= "'+Dtos(mv_par03)+'".And.Dtos(C7_EMISSAO) <="'+Dtos(mv_par04)+'".And.'
	cCondicao += 'Dtos(C7_DATPRF) >= "'+Dtos(mv_par05)+'".And.Dtos(C7_DATPRF) <="'+Dtos(mv_par06)+'".And.'
	cCondicao += 'C7_FORNECE >= "'+mv_par15+'".And.C7_FORNECE <="'+mv_par16+'"'
   cCondicao += 'C7_USER >= "'+mv_par17+'".And.C7_USER <= "'+mv_par18+'"'
	If mv_par11 == 1 
		cCondicao += '.And.C7_CONAPRO <> "B"'	
	ElseIf mv_par11 == 2
		cCondicao += '.And.C7_CONAPRO == "B"'	
	Endif
	
	If mv_par07 == 2 
		cCondicao += '.And.(C7_QUANT-C7_QUJE) > 0'	
		cCondicao += '.And.C7_RESIDUO == " "'	
	ElseIf mv_par07 == 3
		cCondicao += '.And.C7_RESIDUO <> " "'	
	ElseIf mv_par07 == 4
		cCondicao += '.And.C7_QUANT <= C7_QUJE'	
	ElseIf mv_par07 == 5
		cCondicao += '.And.C7_QUJE > 0'					
	Endif
	If mv_par10 == 1 
		cCondicao += '.And.C7_TIPO == 1'					
	ElseIf mv_par10 == 2
		cCondicao += '.And.C7_TIPO == 2'					
	Endif
	If mv_par12 == 1 //Firmes
		cCondicao += '.And.(C7_TPOP == "F" .OR. C7_TPOP == " ")'	
	ElseIf mv_par12 == 2 //Previstas
		cCondicao += '.And.C7_TPOP == "P"'	
	Endif
	
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
#ENDIF		
oSection2:SetParentQuery()

Do Case
	Case nOrdem == 1
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_NUM == cParam },{ || (cAliasSC7)->C7_NUM })
	Case nOrdem == 2
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_PRODUTO == cParam },{ || (cAliasSC7)->C7_PRODUTO })
	Case nOrdem == 3
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA == cParam },{ || (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA })
	Case nOrdem == 4
		oSection2:SetParentFilter( { |cParam| (cAliasSC7)->C7_DATPRF == cParam },{ || (cAliasSC7)->C7_DATPRF })
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA})
TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
TRPosition():New(oSection2,"SA2",1,{|| xFilial("SA2") + (cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA})
TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1") + (cAliasSC7)->C7_PRODUTO})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(SC7->(LastRec()))

If nOrdem <> 2
	oSection1:Cell("cDescri"):SetSize(nTamDPro)
	oSection2:Cell("cDescri"):SetSize(nTamDPro)
EndIf

Do Case
		Case nOrdem == 1

			oSection1:Cell("C7_PRODUTO"):Disable()
			oSection1:Cell("cDescri"):Disable()
			oSection1:Cell("A2_FAX"):Disable()
			oSection1:Cell("A2_CONTATO"):Disable()
			oSection1:Cell("C7_DATPRF"):Disable()
			oSection2:Cell("C7_NUM"):Disable()
			oSection2:Cell("C7_FORNECE"):Disable()
			oSection2:Cell("A2_NOME"):Disable()
			oSection2:Cell("A2_TEL"):Disable()
			
			
			oSection1:Print()
		
		Case nOrdem == 2

			oSection1:Cell("C7_NUM"):Disable()
			oSection1:Cell("C7_NUMSC"):Disable()
			oSection1:Cell("C7_FORNECE"):Disable()
			oSection1:Cell("A2_NOME"):Disable()
			oSection1:Cell("A2_TEL"):Disable()
			oSection1:Cell("A2_FAX"):Disable()
			oSection1:Cell("A2_CONTATO"):Disable()
			oSection1:Cell("C7_DATPRF"):Disable()
			oSection2:Cell("C7_PRODUTO"):Disable()
			oSection2:Cell("cDescri"):Disable()
			oSection2:Cell("B1_GRUPO"):Disable()
			oSection2:Cell("C7_UM"):Disable()
			oSection2:Cell("A2_TEL"):Disable()
			
			oSection1:Print()
	
		Case nOrdem == 3

			oSection1:Cell("C7_NUM"):Disable()
			oSection1:Cell("C7_NUMSC"):Disable()
			oSection1:Cell("C7_PRODUTO"):Disable()
			oSection1:Cell("cDescri"):Disable()
			oSection1:Cell("C7_DATPRF"):Disable()			
			oSection2:Cell("C7_FORNECE"):Disable()
			oSection2:Cell("A2_NOME"):Disable()
			oSection2:Cell("A2_TEL"):Disable()
			oSection2:Cell("C7_UM"):Disable()
			
			oSection1:Print()
			
		Case nOrdem == 4
		
			oSection1:Cell("C7_NUM"):Disable()
			oSection1:Cell("C7_NUMSC"):Disable()
			oSection1:Cell("C7_FORNECE"):Disable()
			oSection1:Cell("A2_NOME"):Disable()
			oSection1:Cell("A2_TEL"):Disable()
			oSection1:Cell("A2_FAX"):Disable()
			oSection1:Cell("A2_CONTATO"):Disable()
			oSection1:Cell("C7_PRODUTO"):Disable()
			oSection1:Cell("cDescri"):Disable()
			//oSection2:Cell("COMPRADOR"):Disable()
			oSection2:Cell("B1_GRUPO"):Disable()
			oSection2:Cell("C7_DATPRF"):Disable()
			oSection2:Cell("C7_UM"):Disable()
			oSection2:Cell("C7_FORNECE"):SetTitle(STR0064) //"Fornec."
			oSection2:Cell("cDescri"):SetSize(15)            
			
			If TamSX3("C7_PRODUTO")[1] > 15
				oSection2:Cell("A2_NOME"):Disable()				
				oSection1:Cell("cDescri"):SetSize(14)
				oSection2:Cell("cDescri"):SetSize(14)
			Else
				oSection1:Cell("A2_NOME"):SetSize(15)
				oSection2:Cell("A2_NOME"):SetSize(15)
			EndIf
		
			oSection1:Print()			
EndCase			

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpDescri ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpDescri(cAliasSC7)

Local aArea   := GetArea()
Local cDescri := ""

If Empty(mv_par14)
	mv_par14 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+(cAliasSC7)->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial("SB5")+(cAliasSC7)->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par14) == "C7_DESCRI"
	cDescri := Alltrim((cAliasSC7)->C7_DESCRI)
EndIf

RestArea(aArea)

Return(cDescri)


Static Function ImpCompr(cAliasSC7)

Local aArea   := GetArea()
Local cComprador := ""

DbSelectArea("SY1")
SY1->(DbSetOrder(3))
If SY1->(DbSeek(xFilial("SY1") + (cAliasSC7)->C7_USER))
	cComprador := UPPER(ALLTRIM(SY1->Y1_NOME))
EndIf                                 

RestArea(aArea)

Return(cComprador)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpVunit  ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpVunit(cAliasSC7)

Local aArea    := GetArea()
Local nVlrUnit := 0
Local aTam	   := TamSx3("C7_PRECO")
Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)

If !Empty((cAliasSC7)->C7_REAJUST)
	nVlrUnit := xMoeda(Form120((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,aTam[2],nTxMoeda) 
Else
	nVlrUnit := xMoeda((cAliasSC7)->C7_PRECO,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,aTam[2],nTxMoeda) 
Endif

RestArea(aArea)

Return(nVlrUnit)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpVIPI   ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpVIPI(cAliasSC7)

Local aArea    := GetArea()
Local nVlrIPI  := 0
Local nToTIPI  := 0
Local nTotal   := 0
Local nItemIVA := 0 
Local nValor   := ((cAliasSC7)->C7_QUANT) * IIf(Empty((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_PRECO,Formula((cAliasSC7)->C7_REAJUST))
Local nTotDesc := (cAliasSC7)->C7_VLDESC
Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)
Local nI 

If cPaisLoc <> "BRA"
	R120FIniPC((cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
	aValIVA := MaFisRet(,"NF_VALIMP")
	If !Empty( aValIVA )
		For nI := 1 To Len( aValIVA )
			nItemIVA += aValIVA[nI]
		Next
	Endif
	nVlrIPI := xMoeda(nItemIVA,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)  
Else
	If nTotDesc == 0
		nTotDesc := CalcDesc(nValor,(cAliasSC7)->C7_DESC1,(cAliasSC7)->C7_DESC2,(cAliasSC7)->C7_DESC3)
	EndIF
	nTotal := nValor - nTotDesc
	nTotIPI := IIF((cAliasSC7)->C7_IPIBRUT == "L",nTotal, nValor) * ( (cAliasSC7)->C7_IPI / 100 )
	nVlrIPI := xMoeda(nTotIPI,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)  
EndIf

RestArea(aArea)

Return(nVlrIPI)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpSaldo  ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpSaldo(cAliasSC7)

Local aArea    := GetArea()
Local nSalRec  := 0
Local nItemIVA := 0 
Local nQuant   := If(Empty((cAliasSC7)->C7_RESIDUO),IIF((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE<0,0,(cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE),0)
Local nTotal   := 0
Local nSalIPI  := 0
Local nValor   := ((cAliasSC7)->C7_QUANT) * IIf(Empty((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_PRECO,Formula((cAliasSC7)->C7_REAJUST))
Local nSaldo   := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE) * IIf(Empty((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_PRECO,Formula((cAliasSC7)->C7_REAJUST))
Local nTotDesc := (cAliasSC7)->C7_VLDESC
Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)
Local nI 

If cPaisLoc <> "BRA"
	R120FIniPC((cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
	aValIVA  := MaFisRet(,"NF_VALIMP")
	If !Empty( aValIVA )
		For nI := 1 To Len( aValIVA )
			nItemIVA += aValIVA[nI]
		Next
	Endif
	nSalIPI := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE) * nItemIVA / (cAliasSC7)->C7_QUANT
Else
	If nTotDesc == 0
		nTotDesc := CalcDesc(nValor,(cAliasSC7)->C7_DESC1,(cAliasSC7)->C7_DESC2,(cAliasSC7)->C7_DESC3)
	EndIF
	nTotal := nValor - nTotDesc
	If Empty((cAliasSC7)->C7_RESIDUO)
		nTotal := nSaldo - nTotDesc
		nSalIPI := IIF((cAliasSC7)->C7_IPIBRUT == "L",nTotal, nSaldo) * ( (cAliasSC7)->C7_IPI / 100 )
	Endif
EndIf

If Empty((cAliasSC7)->C7_REAJUST)
	nSalRec := (nQuant * xMoeda((cAliasSC7)->C7_PRECO,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)-xMoeda((cAliasSC7)->C7_VLDESC,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)) + xMoeda(nSalIPI,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) 
Else
	nSalRec  := (nQuant * xMoeda(Formula((cAliasSC7)->C7_REAJUST),(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)) + ;
		xMoeda(nSalIPI,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda) 
Endif

RestArea(aArea)

Return(nSalRec)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpVTotal ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpVTotal(cAliasSC7)

Local aArea    := GetArea()
Local nVlrTot  := 0
Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)

R120FIniPC((cAliasSC7)->C7_NUM,(cAliasSC7)->C7_ITEM,(cAliasSC7)->C7_SEQUEN)
nTotal  := MaFisRet(,'NF_TOTAL')
nVlrTot := xMoeda(nTotal,(cAliasSC7)->C7_MOEDA,mv_par13,(cAliasSC7)->C7_DATPRF,,nTxMoeda)		  		

RestArea(aArea)

Return(nVlrTot)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImpDescon ºAutor³Nereu Humberto Junior º Data ³ 12/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpDescon(cAliasSC7)

Local aArea    := GetArea()
Local nVlrDesc := 0
Local nTxMoeda := IIF((cAliasSC7)->C7_TXMOEDA > 0,(cAliasSC7)->C7_TXMOEDA,Nil)

nVlrDesc := xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)

RestArea(aArea)

Return(nVlrDesc)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R120IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 10.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R120Imp(ExpL1,ExpC1,ExpC2,ExpC3)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = controle para interrupcao do usuario	              ³±±
±±³          ³ ExpC1 = tamanho do layout                                  ³±±
±±³          ³ ExpC2 = nome do programa                                   ³±±
±±³          ³ ExpC3 = Alias do arquivo principal                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R120Imp(lEnd,tamanho,wnrel,cString)

LOCAL cbtxt := SPACE(10)
LOCAL nQuebra,cCabQuebra,cQuebrant,cCOndBus
LOCAL CbCont
LOCAL nQuant_a_Rec := 0
Local nTotParc	:= 0
Local nTxMoeda	:= 1

CbCont   := 00
nQuebra  := 00
li       := 80
m_pag    := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Totalizar os valores do relatorio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nT_qtd_ped := 0 // qtde pedida
nT_vl_ipi  := 0 // valor do ipi
nT_vl_total:= 0 // valor total do pedido
nT_qtd_entr:= 0 // qtde entregue
nT_sd_receb:= 0 // saldo a receber
nT_desc    := 0 // total de desconto
nTotIVA    := 0 // Total de IVA (impostos)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Totalizar os valores p/ item de acordo com a ordem ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPedida    := 0 // qtde pedida
nValIpi    := 0 // valor do ipi
nTotal     := 0 // valor total do pedido
nQuant     := 0 // qtde entregue
nSaldo     := 0 // saldo a receber
nFlag      := 0 // flag que indica se imprime totais por item ou nao
nITemIpi   := 0
nSalIpi    := 0
nFrete     := 0 // valor do frete
nDesc      := 0 // valor do desconto
nValIVA    := 0 // valor do IVA
nItemIVA   := 0 // valor do item do imposto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos de acordo com os parametros              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1    := STR0011		//"RELACAO DOS PEDIDOS DE COMPRAS"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o ponto inicial para a impressao                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]

dbSelectArea("SC7")

If nOrdem <> 4
	dbSetOrder(nOrdem)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica qual ordem foi selecionada                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1
	If ( cPaisLoc$"ARG|POR|EUA" )	//Ordena los pedidos de compra y luego la AE.
		DbSetOrder(10)
		cCondBus	:=	"0"+MV_PAR08
	Else
		cCondBus	:=	mv_par08
	EndIf

	dbSeek(xFilial("SC7")+cCondBus,.T.)
	cCampo     := "SC7->C7_NUM"

	If mv_par10 == 2
		cTexQuebra := STR0012	//"AUTOR. N. : "
	Else
		cTexQuebra := STR0013	//"PEDIDO N. : "
	EndIf
	titulo     += STR0014		//" - POR NUMERO"

	// Verifica se utilizara LayOut Maximo
	if aTamSXG[1] != aTamSXG[3]
		cabec1 := STR0046		//"ITEM CODIGO          DESCRICAO                    GRP  CODIGO               RAZAO SOCIAL         DATA DE  ENTREGA   QUANTIDADE  UM      VALOR        VALOR         VALOR TOTAL  QUANT.      QUANT. A          SALDO   RES."
		//				  	       0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
		//                  	   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Else
		cabec1 := STR0015		//"ITEM CODIGO          DESCRICAO                    GRP  CODIGO RAZAO SOCIAL                        DATA DE  ENTREGA   QUANTIDADE  UM      VALOR        VALOR         VALOR TOTAL  QUANT.      QUANT. A          SALDO   RES."
		//                           		 1         2         3         4         5         6         7         8         9        10        11        12        13   X    14        X5        16   X    17        18        19        20        10
		//                         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Endif
	cabec2 := STR0016		    //"     PRODUTO         DO PRODUTO                           FORN.                                     EMISSAO  PREVISTA      PEDIDA           UNIT.         IPI            (C/IPI)   ENTREGUE    RECEBER         RECEBER  ELIM."	
ElseIf nOrdem == 2
	dbSeek(xFilial("SC7")+mv_par01,.T.)
	cCampo     := "SC7->C7_PRODUTO"
	cTexQuebra := STR0017	//"PRODUTO : "
	titulo     += STR0018	//" - POR PRODUTO"
	// Verifica se utilizara LayOut Maximo
	if aTamSXG[1] != aTamSXG[3]
		If ( cPaisLoc$"ARG|POR|EUA" )
			cabec1 := STR0050 //"PED/AE ITEM  DATA      CODIGO               RAZAO SOCIAL          FONE            ENTREGA         QUANTIDADE           VALOR    DESCONTO           VALOR     PRECO TOTAL      QUANTIDADE   QUANT. A          SALDO RESIDUOS"
		Else
			cabec1 := STR0047 //"PEDIDO ITEM  DATA      CODIGO               RAZAO SOCIAL          FONE            ENTREGA         QUANTIDADE           VALOR    DESCONTO           VALOR     PRECO TOTAL      QUANTIDADE   QUANT. A          SALDO RESIDUOS"
			//					 123456  12  99/99/9999 12345678901234567890 123456789012345678901 12345789012345 12/34/5678 123456789012345 123456789012345 123456789012 1234567890123 123456789012345 123456789012345 1234567890 123456789012345   Sim
			//					 		   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
			//					 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		EndIf
	Else
		If ( cPaisLoc$"ARG|POR|EUA" )
			cabec1 := STR0051 //"PED/AE ITEM  DATA      CODIGO RAZAO SOCIAL                        FONE            ENTREGA         QUANTIDADE           VALOR    DESCONTO           VALOR     PRECO TOTAL      QUANTIDADE   QUANT. A          SALDO RESIDUOS"
		Else
			cabec1 := STR0019 //"PEDIDO ITEM  DATA      CODIGO RAZAO SOCIAL                        FONE            ENTREGA         QUANTIDADE           VALOR    DESCONTO           VALOR     PRECO TOTAL      QUANTIDADE   QUANT. A          SALDO RESIDUOS"
			// 					 123456  12  99/99/9999 123456 12345678901234567890123456789012345 12345789012345 12/34/5678 123456789012345 123456789012345 123456789012 1234567890123 123456789012345 123456789012345 1234567890 123456789012345   Sim
			//					 		   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
			//					 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		EndIf
	Endif
	cabec2 := STR0020 //"             EMISSAO   FORN.                                      FORN.           PREVISTA            PEDIDA        UNITARIO                         IPI       (C/IPI)          ENTREGUE    RECEBER        RECEBER ELIMINADOS"
ElseIf nOrdem == 3
	dbSeek(xFilial("SC7"))
	cCampo     := "SC7->C7_FORNECE+SC7->C7_LOJA"
	cTexQuebra := STR0021	//"FORNECEDOR : "
	titulo     += STR0022	//" - POR FORNECEDOR"
	If ( cPaisLoc$"ARG|POR|EUA" )
		cabec1 := STR0042 //"PED/AE ITEM  DATA     CODIGO           DESCRICAO DO PRODUTO           GRUPO  ENTREGA        QUANTIDADE            PRECO            VALOR       PRECO TOTAL        QUANTIDADE      QUANT. A       SALDO     RESIDUOS"
	Else
		cabec1 := STR0023 //"PEDIDO ITEM  DATA     CODIGO           DESCRICAO DO PRODUTO           GRUPO  ENTREGA        QUANTIDADE            PRECO            VALOR       PRECO TOTAL        QUANTIDADE      QUANT. A       SALDO     RESIDUOS"
	EndIf
	cabec2 :=  STR0024    //"NUMERO       EMISSAO  PRODUTO                                                PREVISTA           PEDIDA         UNITARIO              IPI         (C/IPI)            ENTREGUE    RECEBER        RECEBER   ELIMINADOS"
	//                       123456  12  12/45/78 123456789012345 123456789012345678901234567890 1234  12/34/56 123456789012345 123456789012345 123456789012 1234567890123 123456789012345 123456789012345 1234567890 123456789012345   Sim
	//                      		   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
	//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Else		// Ordem == 4
	dbSetOrder(16)
	dbSeek(xFilial("SC7"))
	cCampo     := "DTOC(SC7->C7_DATPRF)"
	cTexQuebra := STR0052 //"ENTREGA PREVISTA :  "
	titulo     += STR0053 //" - POR PREVISAO DE ENTREGA"
	// Verifica se utilizara' LayOut Maximo
	if aTamSXG[1] != aTamSXG[3]
		If ( cPaisLoc$"ARG|POR|EUA" )
			cabec1 := 	STR0054 //"PED/AE ITEM  DATA      CODIGO           DESCRICAO         CODIGO               RAZAO SOCIAL    FONE             QUANTIDADE        VALOR   DESCONTO        VALOR     PRECO TOTAL   QUANTIDADE   QUANT. A           SALDO RES."
		Else
			cabec1 := 	STR0055 //"PEDIDO ITEM  DATA      CODIGO           DESCRICAO         CODIGO               RAZAO SOCIAL    FONE             QUANTIDADE        VALOR   DESCONTO        VALOR     PRECO TOTAL   QUANTIDADE   QUANT. A           SALDO RES."
			//		  	 	 	   123456 1234 99/99/99   123456789012345 123456789012345678 12345678901234567890 123456789012345 12345789012345 123456789012 123456789012 1234567890 123456789012 123456789012345 123456789012 1234567890 123456789012345  Sim
			//			 		  		     1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
			//					   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		EndIf
	Else
		If ( cPaisLoc$"ARG|POR|EUA" )
			cabec1 := 	STR0056 //"PED/AE ITEM  DATA      CODIGO           DESCRICAO         CODIGO RAZAO SOCIAL                  FONE             QUANTIDADE        VALOR   DESCONTO        VALOR     PRECO TOTAL   QUANTIDADE   QUANT. A           SALDO RES."
		Else
			cabec1 := 	STR0057 //"PEDIDO ITEM  DATA      CODIGO           DESCRICAO         CODIGO RAZAO SOCIAL                  FONE             QUANTIDADE        VALOR   DESCONTO        VALOR     PRECO TOTAL   QUANTIDADE   QUANT. A           SALDO RES."
			//		  	 		   123456 1234 99/99/99   123456789012345 123456789012345678 123456 12345678901234567890123456789 12345789012345 123456789012 123456789012 1234567890 123456789012 123456789012345 123456789012 1234567890 123456789012345  Sim
			//			 		     		 1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
			//			 		   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		Endif
	Endif
	cabec2 := 			STR0058 //"             EMISSAO                    DO PRODUTO        FORN.                                FORN.                PEDIDA     UNITARIO                     IPI    (C/IMPOSTOS)     ENTREGUE    RECEBER         RECEBER ELIM."
Endif

If mv_par07==1
	titulo+=STR0025	//", Todos"
Elseif mv_par07==2
	titulo+=STR0026	//", Em Abertos"
Elseif mv_par07==3
	titulo+=STR0027	//", Residuos"
Elseif mv_par07==4
	titulo+=STR0028	//", Atendidos"
Elseif mv_par07==5
	titulo+=STR0059 //", Atendidos + Parcial entregue"
Endif

titulo += " - " + GetMv("MV_MOEDA"+STR(mv_par13,1))		//" MOEDA "
SetRegua(RecCount())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a leitura do arquivo SC7                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While !Eof() .And. C7_FILIAL = xFilial("SC7")

	nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
	IncRegua()
	If lEnd
		@PROW()+1,001 PSAY STR0029	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR PEDIDO                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_NUM < mv_par08 .Or. C7_NUM > mv_par09
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR PRODUTO                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_PRODUTO < mv_par01 .Or. C7_PRODUTO > mv_par02
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR EMISSAO                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_EMISSAO < mv_par03 .Or. C7_EMISSAO > mv_par04
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. POR DATA ENTREGA                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_DATPRF < mv_par05 .Or. C7_DATPRF > mv_par06
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste se o pedido esta' liberado.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	(C7_CONAPRO == "B" .And. mv_par11 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par11 == 2)
		dbSkip()
		Loop
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. EM ABERTO                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 2
		If C7_QUANT-C7_QUJE <= 0 .Or. !EMPTY(C7_RESIDUO)
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. RESIDUOS                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 3
		If EMPTY(C7_RESIDUO)
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. ATENDIDOS                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 4
		If C7_QUANT > C7_QUJE
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. ATENDIDOS +pedidos parcialmente entregues³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 5
		If C7_QUJE = 0
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Tipo	de Pedido  1-PC    2-AE    3-Ambos           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1 .And. C7_TIPO != 1
		dbSkip()
		Loop
	ElseIf mv_par10 == 2 .And.	C7_TIPO !=2
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. por fornecedor                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_FORNECE < mv_par15 .Or. C7_FORNECE > mv_par16
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par12, 'SC7')
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se e nova pagina                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif

	If nQuebra == 0
		cQuebrant := &cCampo
		li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		If nOrdem = 1
			cCabQuebra := " "
		ElseIf nOrdem = 2
			dbSelectArea("SC7")
			cCabQuebra := Alltrim(SC7->C7_DESCRI)

			If Empty(mv_par14)
				mv_par14 := "B1_DESC"
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da descricao generica do Produto.                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(mv_par14) == "B1_DESC"
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(cFilial+&cCampo)
				cCabQuebra := Alltrim(SB1->B1_DESC)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da descricao cientifica do Produto.                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(mv_par14) == "B5_CEME"
				dbSelectArea("SB5")
				dbSetOrder(1)
				If dbSeek(cFilial+&cCampo)
					cCabQuebra := Alltrim(B5_CEME)
				EndIf
			EndIf

			dbSelectArea("SC7")
			If AllTrim(mv_par14) == "C7_DESCRI"
				cCabQuebra := Alltrim(SC7->C7_DESCRI)
			EndIf
		ElseIf nOrdem = 3
			dbSelectArea("SA2")
			dbSeek(cFilial+&cCampo)
			cCabQuebra := A2_NOME
		ElseIf nOrdem = 4
			cCabQuebra := " "
		Endif
		If ( cPaisLoc$"ARG|POR|EUA" ).AND.mv_par10==3.And.nOrdem==1
			If ( SC7->C7_TIPO==2 )
				@ li,000 PSAY STR0012 + &cCampo + " " + Substr(cCabQuebra,1,(nTamNome-5)) // "AUTOR. No. : "
			Else
				If nOrdem == 1 .And. !Empty(SC7->C7_NUMSC)
					@ li,000 PSAY STR0013 + &cCampo + " " + STR0048 + SC7->C7_NUMSC + " " + Substr(cCabQuebra,1,(nTamNome-5)) // "PEDIDO No. : "
				Else
					@ li,000 PSAY STR0013 + &cCampo + " " + Substr(cCabQuebra,1,(nTamNome-5))  // "PEDIDO No. : "
				Endif
			Endif
		Else
			If nOrdem == 1 .And. !Empty(SC7->C7_NUMSC)
				@ li,000 PSAY cTexQuebra + &cCampo + " " + STR0048 + SC7->C7_NUMSC + " " + Substr(cCabQuebra,1,(nTamNome-5)) // "SOLICITACAO COMPRAS No. : "
			Else
				@ li,000 PSAY cTexQuebra + &cCampo + " " + Substr(cCabQuebra,1,(nTamNome-5))
			Endif
		EndIf

		If nOrdem = 1 .or. nOrdem = 3
			dbSelectArea("SA2")
			If dbSeek(cFilial+SC7->C7_FORNECE+SC7->C7_LOJA)
				If nOrdem = 1
					@ li,055 PSAY SC7->C7_FORNECE
					@ li,(062+nDifNome) PSAY Substr(SA2->A2_NOME,1,nTamNome)
					@ li,098 PSAY STR0041+Substr(SA2->A2_TEL,1,15) // Fone.:
				Else
					@ li,055 PSAY STR0041+Substr(SA2->A2_TEL,1,15) + STR0044 + SA2->A2_FAX + STR0045 + SA2->A2_CONTATO   // Fone.: Fax: Contato:
				Endif
			Endif
			dbSelectArea("SC7")
		Endif
		nQuebra := 1
		nFlag:=0
	Endif

	dbSelectArea("SC7")
	If cQuebrant != &cCampo
		nQuebra := 0
		li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		If nFlag > 1 .Or. nOrdem != 2
			Impitem(1)
			nFlag:=0
		EndIf
		nPedida:=nValIpi:=nTotal:=nQuant:=nSaldo:=nValIVA:=0
		@ li,000 PSAY __PrtThinLine()
		Loop
	Endif
	li++
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	nItemIpi := 0
	nSalIpi  := 0
	nItemIVA := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica ordem a ser impressa           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	R120FIniPC(SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_SEQUEN)
	If nOrdem = 1
		nTotParc := ImpOrd1()
	ElseIf nOrdem = 2
		nTotParc := ImpOrd2()
	ElseIf nOrdem = 3
		nTotParc := ImpOrd3()
	Else
		nTotParc := ImpOrd4()
	Endif
	nTotal 	+= xMoeda(nTotParc,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma as variaveis dos totais p/item     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPedida = nPedida + C7_QUANT
	nValIpi = nValIpi + xMoeda(nItemIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	nQuant  = nQuant  + C7_QUJE
	nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
	nSaldo  = nSaldo  + (nQuant_a_Rec * IIf(Empty(C7_REAJUST),xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda),xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda))) + xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	nValIVA := nValIVA + xMoeda(nItemIVA,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor do Frete         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFrete := C7_FRETE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valor do Desconto         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If C7_DESC1 != 0 .or. C7_DESC2 != 0 .or. C7_DESC3 != 0
		nDesc += CalcDesc(C7_TOTAL,C7_DESC1,C7_DESC2,C7_DESC3)
	Else
		nDesc += C7_VLDESC
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma as variaveis dos totais gerais     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nT_vl_ipi   := nT_vl_ipi   + xMoeda(nItemIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	nT_vl_total := nT_vl_total + xMoeda(nTotParc,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	nT_sd_receb := nT_sd_receb + (nQuant_a_Rec * IIf(Empty(C7_REAJUST),xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda),xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda))) + xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	nTotIVA     := nTotIVA     + xMoeda(nItemIVA,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
	dbSelectArea("SC7")
	dbSkip()
EndDo

If nOrdem == 2 
	nT_Desc += xMoeda(nDesc,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
EndIf

If nFlag > 1 .Or. nOrdem != 2
	If li > 60 .And. li != 80
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	If li != 80
		li++
		Impitem(2)
	Endif
	nFlag:=0
EndIf

If nT_qtd_ped > 0 .Or. nT_vl_ipi > 0 .Or.;
		nT_vl_total > 0 .Or. nT_qtd_entr > 0 .Or. nT_sd_receb > 0
	Imptot(limite)
Endif

IF li != 80
	li++
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	@ li,000 PSAY __PrtThinLine()
	roda(CbCont,STR0030,"G")		//"PEDIDOS"
EndIF

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD1  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio na 1a ordem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := ImpOrd1()                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = Valor total                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpOrd1()

Local nQuant_a_Rec:=0
Local aTam		:= TamSx3("C7_PRECO")
Local aTamVal	:= TamSx3("C7_VALICM")
Local nTotal	:= MaFisRet(,'NF_TOTAL')
Local aValIVA  := MaFisRet(,"NF_VALIMP")
Local nI       := 0
Local j        := 0
Local cDescri  := Alltrim(SC7->C7_DESCRI)
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)

If Empty(mv_par14)
	mv_par14 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial("SB5")+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par14) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If cPaisLoc <> "BRA" .And. !Empty( aValIVA )
	For nI := 1 To Len( aValIVA )
		nItemIVA += aValIVA[nI]
	Next
Endif

dbSelectArea("SC7")
@ li,000 PSAY C7_ITEM
@ li,005 PSAY C7_PRODUTO
nFlag++
@ li,021 PSAY Subs(cDescri,1,28)
dbSelectArea("SB1")
dbSeek(cFilial+SC7->C7_PRODUTO)
If Found()
	@ li,050 PSAY B1_GRUPO
EndIf
dbSelectArea("SC7")
@ li,076 PSAY C7_EMISSAO
@ li,086 PSAY C7_DATPRF
@ li,097 PSAY C7_QUANT Picture Tm(C7_QUANT,10,2)
@ li,109 PSAY C7_UM
If !Empty(C7_REAJUST)
	@ li,113 PSAY xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(Formula(C7_REAJUST),10,aTam[2])
Else
	@ li,113 PSAY xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(C7_PRECO,13,aTam[2])
Endif
nItemIPI := CalcIPI()[1]
nSalIPI := CalcIPI()[2]
@ li,128 PSAY xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(C7_VLDESC,12,aTamVal[2])
If cPaisLoc <> "BRA"
	@ li,141 PSAY xMoeda(nItemIVA,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIVA,15,aTamVal[2])
Else
	@ li,141 PSAY xMoeda(nItemIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIPI,15,aTamVal[2])
EndIf
@ li,157 PSAY xMoeda(nTotal,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotal,15,aTamVal[2])
@ li,173 PSAY C7_QUJE Picture tm(C7_QUJE,10,2)
nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
@ li,189 PSAY nQuant_a_Rec Picture tm(C7_QUANT-C7_QUJE,10,2)

If Empty(C7_REAJUST)
	@ li,199 PSAY (nQuant_a_Rec * xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)- ;
		xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda))+ ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Else
	@ li,199 PSAY (nQuant_a_Rec * xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)) + ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Endif
@ li,215 PSAY If(Empty(C7_RESIDUO),STR0031,STR0032)		//'Nao'###'Sim'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Descricao Adicional do Produto (se houver)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For j:=29 TO Len(Trim(cDescri)) Step 28
	If !empty(Subs(cDescri,j,28))
		Li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		@ li,21 PSAY SubStr(cDescri,j,28)
	Endif
Next j

Return(nTotal)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD2  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio na 2a ordem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := ImpOrd2()                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = Valor total                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpOrd2()

Local nQuant_a_Rec
Local aTam		:= TamSx3("C7_PRECO")
Local aTamVal	:= TamSx3("C7_VALICM")
Local nTotal	:= MaFisRet(,'NF_TOTAL')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nTxMoeda  := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
Local nI

If cPaisLoc <> "BRA" .And. !Empty( aValIVA )
	For nI := 1 To Len( aValIVA )
		nItemIVA += aValIVA[nI]
	Next
Endif

dbSelectArea("SC7")
If ( cPaisLoc$"ARG|POR|EUA" )
	@ li,000 PSAY If(C7_TIPO==1,"P"+C7_NUM,"A"+C7_NUM)
Else
	@ li,000 PSAY C7_NUM
EndIf
@ li,007 PSAY C7_ITEM
nFlag++
@ li,012 PSAY C7_EMISSAO
@ li,023 PSAY C7_FORNECE
dbSelectArea("SA2")
If dbSeek(cFilial+SC7->C7_FORNECE+SC7->C7_LOJA)
	@li,(30+nDifNome) PSAY Subs(A2_NOME,1,nTamNome)
	@li,66 PSAY Substr(A2_TEL,1,15)
Endif

DbSelectArea("SC7")
@ li,82 PSAY C7_DATPRF
@ li,93 PSAY C7_QUANT Picture tm(C7_QUANT,15,2)
If !Empty(C7_REAJUST)
	@ li,109 PSAY xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(Formula(C7_REAJUST),15,aTam[2])
Else
	@ li,109 PSAY xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(C7_PRECO,15,aTam[2])
Endif
nItemIPI := CalcIPI()[1]
nSalIPI := CalcIPI()[2]
@ li,124 PSAY xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(C7_VLDESC,12,aTamVal[2])
If cPaisLoc <> "BRA"
	@ li,137 PSAY xMoeda(nItemIVA,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIVA,15,aTamVal[2])
Else
	@ li,137 PSAY xMoeda(nItemIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIPI,15,aTamVal[2])
EndIf
@ li,153 PSAY xMoeda(nTotal,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotal,15,aTamVal[2])
@ li,169 PSAY C7_QUJE Picture tm(C7_QUJE,15,2)
nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
@ li,185 PSAY nQuant_a_Rec Picture tm(C7_QUANT-C7_QUJE,10,2)

If Empty(C7_REAJUST)
	@ li,195 PSAY (nQuant_a_Rec * xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)- ;
		xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda))+ ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Else
	@ li,195 PSAY (nQuant_a_Rec * xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)) + ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Endif
@ li,211 PSAY If(Empty(C7_RESIDUO),STR0031,STR0032)		//'Nao'###'Sim'

Return(nTotal)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD3  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio na 3a ordem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := ImpOrd3()                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = Valor total                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpOrd3()

Local nQuant_a_Rec:=0
Local aTam		:= TamSx3("C7_PRECO")
Local aTamVal	:= TamSx3("C7_VALICM")
Local nTotal	:= MaFisRet(,"NF_TOTAL")
Local aValIVA  := MaFisRet(,"NF_VALIMP")
Local nI       := 0
Local j        := 0
Local cDescri := Alltrim(SC7->C7_DESCRI)
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)

If Empty(mv_par14)
	mv_par14 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial("SB5")+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par14) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If cPaisLoc <> "BRA" .And. !Empty( aValIVA )
	For nI := 1 To Len( aValIVA )
		nItemIVA += aValIVA[nI]
	Next
Endif
dbSelectArea("SC7")
If ( cPaisLoc$"ARG|POR|EUA" )
	@li,000 PSAY If(C7_TIPO==1,"P"+C7_NUM,"A"+C7_NUM)
Else
	@li,000 PSAY C7_NUM
EndIf
@ li,007 PSAY C7_ITEM
nFlag++
@ li,012 PSAY C7_EMISSAO
@ li,023 PSAY C7_PRODUTO
@ li,039 PSAY Subs(cDescri,1,28)
dbSelectArea("SB1")
If dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
	@ li,068 PSAY B1_GRUPO
Endif
dbSelectArea("SC7")
@ li,073 PSAY C7_DATPRF
@ li,085 PSAY C7_QUANT Picture tm(C7_QUANT,13,2)
If !Empty(C7_REAJUST)
	@li,99 PSAY xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(Formula(C7_REAJUST),15,aTam[2])
Else
	@li,99 PSAY xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(C7_PRECO,15,aTam[2])
Endif
nItemIPI := CalcIPI()[1]
nSalIPI := CalcIPI()[2]
@ li,115 PSAY xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_VLDESC,12,2)
If cPaisLoc <> "BRA"
	@ li,128 PSAY xMoeda(nItemIVA,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIVA,15,aTamVal[2])
Else
	@ li,128 PSAY xMoeda(nItemIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIPI,15,aTamVal[2])
EndIf
@ li,143 PSAY xMoeda(nTotal,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotal,15,aTamVal[2])
@ li,158 PSAY C7_QUJE	Picture tm(C7_QUJE,15,2)
nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
@ li,174 PSAY nQuant_a_Rec Picture tm(C7_QUANT-C7_QUJE,10,2)

If Empty(C7_REAJUST)
	@ li,185 PSAY (nQuant_a_Rec * xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)- ;
		xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda))+ ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Else
	@ li,185 PSAY (nQuant_a_Rec * xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)) + ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Endif
@ li,203 PSAY If(Empty(C7_RESIDUO),STR0031,STR0032)		//'Nao'###'Sim'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Descricao Adicional do Produto (se houver)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For j:=29 TO Len(Trim(cDescri)) Step 28
	If !empty(Subs(cDescri,j,28))
		li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		@ li,39 PSAY SubStr(cDescri,j,28)
	Endif
Next j

Return(nTotal)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD4  ³ Autor ³ Ricardo Berti         ³ Data ³ 03.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio na 4a ordem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := ImpOrd4()                                     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 = Valor total 	                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpOrd4()

Local nQuant_a_Rec
Local aTam		:= TamSx3("C7_PRECO")
Local aTamVal	:= TamSx3("C7_VALICM")
Local nTotal	:= MaFisRet(,'NF_TOTAL')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nTxMoeda  := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
Local nI		:= 0
Local j			:= 0
Local cDescri	:= Alltrim(SC7->C7_DESCRI)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Redefine tamanho da razao social do fornecedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nDifNome := 0
PRIVATE nTamNome := 29
If aTamSXG[1] != aTamSXG[3]
	nDifNome := aTamSXG[4] - aTamSXG[3]
	nTamNome := if(aTamSXG[1] != aTamSXG[3],29-(aTamSXG[4]-aTamSXG[3]),29)
Endif
If Empty(mv_par14)
	mv_par14 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par14) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial("SB5")+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par14) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If cPaisLoc <> "BRA" .And. !Empty( aValIVA )
	For nI := 1 To Len( aValIVA )
		nItemIVA += aValIVA[nI]
	Next
Endif

dbSelectArea("SC7")
If ( cPaisLoc$"ARG|POR|EUA" )
	@ li,000 PSAY If(C7_TIPO==1,"P"+C7_NUM,"A"+C7_NUM)
Else
	@ li,000 PSAY C7_NUM
EndIf
@ li,007 PSAY C7_ITEM
nFlag++
@ li,012 PSAY C7_EMISSAO
@ li,023 PSAY C7_PRODUTO
@ li,039 PSAY Subs(cDescri,1,18)
@ li,058 PSAY C7_FORNECE
dbSelectArea("SA2")
If dbSeek(cFilial+SC7->C7_FORNECE+SC7->C7_LOJA)
	@li,(65+nDifNome) PSAY Subs(A2_NOME,1,nTamNome)
	@li,95 PSAY Substr(A2_TEL,1,15)
Endif
DbSelectArea("SC7")
@ li,110 PSAY C7_QUANT Picture tm(C7_QUANT,12,2)
If !Empty(C7_REAJUST)
	@ li,123 PSAY xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(Formula(C7_REAJUST),12,aTam[2])
Else
	@ li,123 PSAY xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,aTam[2],nTxMoeda) Picture tm(C7_PRECO,12,aTam[2])
Endif
nItemIPI:= CalcIPI()[1]
nSalIPI	:= CalcIPI()[2]
@ li,136 PSAY xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(C7_VLDESC,10,aTamVal[2])
If cPaisLoc <> "BRA"
	@ li,147 PSAY xMoeda(nItemIVA,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIVA,12,aTamVal[2])
Else
	@ li,147 PSAY xMoeda(nItemIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)  Picture tm(nItemIPI,12,aTamVal[2])
EndIf
@ li,160 PSAY xMoeda(nTotal,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotal,15,aTamVal[2])
@ li,176 PSAY C7_QUJE Picture tm(C7_QUJE,12,2)
nQuant_a_Rec := If(Empty(C7_RESIDUO),IIF(C7_QUANT-C7_QUJE<0,0,C7_QUANT-C7_QUJE),0)
@ li,189 PSAY nQuant_a_Rec Picture tm(C7_QUANT-C7_QUJE,10,2)
If Empty(C7_REAJUST)
	@ li,200 PSAY (nQuant_a_Rec * xMoeda(C7_PRECO,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)- ;
		xMoeda(C7_VLDESC,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda))+ ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Else
	@ li,200 PSAY (nQuant_a_Rec * xMoeda(Formula(C7_REAJUST),SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)) + ;
		xMoeda(nSalIPI,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda) Picture tm(C7_TOTAL,15,aTamVal[2])
Endif
@ li,217 PSAY If(Empty(C7_RESIDUO),STR0031,STR0032)		//'Nao'###'Sim'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da Descricao Adicional do Produto (se houver)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For j:=19 TO Len(Trim(cDescri)) Step 18
	If !empty(Subs(cDescri,j,18))
		li++
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		@ li,39 PSAY SubStr(cDescri,j,18)
	Endif
Next j

Return(nTotal)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPTOT   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 03.02.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao dos totais do relatorio                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpTot(ExpN1)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = tamanho limite da linha                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpTot(limite)

Local nc1,nc2,nc3,nc4,nc5,nc6  	// numeros das colunas para aparecer os
								// totais dependendo do tipo de rela-
								// torio escolhido(1,2,3)
nc1:=nc2:=nc3:=nc4:=nc5:=nc6:=0
If nOrdem = 1
	nc3:= 141
	nc4:= 157; nc6:= 199
ElseIf nOrdem = 2
	nc3:= 137
	nc4:= 153;nc6:= 195
ElseIf nOrdem = 3
	nc3:= 128
	nc4:= 143;nc6:= 185
Else
	nc3:= 147-3
	nc4:= 160;nc6:= 200
Endif
li+=2
@ li,000 PSAY STR0033	//"Total Geral "
If cPaisLoc <> "BRA"
	@ li,nc3 PSAY nTotIVA   Picture tm(nTotIVA,15,2)
Else
	@ li,nc3 PSAY nT_vl_ipi Picture tm(nT_vl_ipi,15,2)
EndIf
@ li,nc4 PSAY nT_vl_total           Picture tm(nT_vl_total,15,2)
@ li,nc6 PSAY nT_sd_receb - nT_desc Picture tm(nT_sd_receb,15,2)
Return(.T.)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPITEM  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 08.05.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao dos totais p/ item de acordo com a ordem         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpItem(nTipo)

Local nc1,nc2,nc3,nc4,nc5,nc6		// numeros das colunas para aparecer os
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
// totais dependendo do tipo de rela-
// torio escolhido(1,2,3)

nc1:=nc2:=nc3:=nc4:=nc5:=nc6:=0
If nOrdem = 1
	nc3:= 141
	nc4:= 157; nc6:= 199
	cTotal:=STR0034	//"Total dos Itens "
ElseIf nOrdem = 2
	nc3:= 137
	nc4:= 153; nc6:= 195
	cTotal:=STR0035	//"Total do Produto"
ElseIf nOrdem = 3
	nc3:= 128
	nc4:= 143;nc6:= 185
	cTotal:=STR0036	//"Total do Fornecedor"
Else //AQUI
	nc3:= 147-3
	nc4:= 160;nc6:= 200
	cTotal:=STR0043 //"Total da Previsao de Entrega"
Endif

li ++
@ li,000 PSAY cTotal
If cPaisLoc <> "BRA"
	@ li,nc3 PSAY nValIVA  Picture tm(nValIVA,15,2)
Else
	@ li,nc3 PSAY nValIpi  Picture tm(nValIpi,15,2)
EndIf
@ li,nc4 PSAY nTotal   Picture tm(nTotal,15,2)
@ li,nc6 PSAY (nSaldo-nDesc) Picture tm(nSaldo,15,2)
li++
If li > 60
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Endif
If nOrdem <> 2 .Or. (nOrdem == 2 .And. nTipo <> 2)
	nT_desc += xMoeda(nDesc,SC7->C7_MOEDA,mv_par13,SC7->C7_DATPRF,,nTxMoeda)
Endif	
nDesc:=0
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CALCIPI  ³ Autor ³ Marcos Bregantim      ³ Data ³ 30.08.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do IPI                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := CalcIPI()                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 = array com valor e saldo de IPI					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CalcIPI()

Local nToTIPI	:= 0,nTotal,nSalIPI:= 0
Local nValor 	:= (C7_QUANT) * IIf(Empty(C7_REAJUST),C7_PRECO,Formula(C7_REAJUST))
Local nSaldo 	:= (C7_QUANT-C7_QUJE) * IIf(Empty(C7_REAJUST),C7_PRECO,Formula(C7_REAJUST))
Local nTotDesc := C7_VLDESC

If cPaisLoc <> "BRA"
	nSalIPI := (C7_QUANT-C7_QUJE) * nItemIVA / C7_QUANT
Else
	If nTotDesc == 0
		nTotDesc := CalcDesc(nValor,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
	EndIF
	nTotal := nValor - nTotDesc
	nTotIPI := IIF(SC7->C7_IPIBRUT == "L",nTotal, nValor) * ( SC7->C7_IPI / 100 )
	If Empty(C7_RESIDUO)
		nTotal := nSaldo - nTotDesc
		nSalIPI := IIF(SC7->C7_IPIBRUT == "L",nTotal, nSaldo) * ( SC7->C7_IPI / 100 )
	Endif
EndIf

Return {nTotIPI,nSalIPI}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor³Flavio Luiz Vicco     º Data ³ 10/04/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR120                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()
Local cHelpKey := "P."+AllTrim(cPerg)+"07."        
Local cGrupo   := PADR("DMR120",10)
Local cGrpSXG  := "001"	//Grupo de Cliente / Fornecedor
Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}
Local nTamSX1  :=Len(SX1->X1_GRUPO)       
Local nTamFor  := TamSX3("A2_COD")[1]	

/*--------------------------MV_PAR07---------------------------*/
aAdd( aHelpPor, "Seleciona quais os pedidos de compras a serem" )
aAdd( aHelpPor, "impressos, as opções são : todos, em aberto, " )
aAdd( aHelpPor, "com residuo,atendidos e atendidos mais "       )
aAdd( aHelpPor, "parcialmente entregues."                       )

aAdd( aHelpSpa, "Selecione los pedidos de compras que se deben"  )
aAdd( aHelpSpa, "imprimir, las opciones son: todos, en abierto," )
aAdd( aHelpSpa, "con residuo y atendidos."                       )

aAdd( aHelpEng, "Select the purchase orders to print. Those can" )
aAdd( aHelpEng, "be: All open, with residue or executed."        )

//-- Verifica se a pergunta 07 esta atualizada - Se nao estiver, inclue nova opcao
If SX1->(MsSeek(PADR(cPerg,nTamSX1)+'07', .F.)) .And. (Upper(AllTrim(SX1->X1_PERGUNT))=='LISTA QUAIS ?') .And. (AllTrim(SX1->X1_DEF05)=='')
	Reclock('SX1', .F.)
	SX1->X1_DEF05   := "Atend + Parcial"
	SX1->X1_DEFSPA5 := "Atend + Parcial"
	SX1->X1_DEFENG5 := "Servced+Partial"
	MsUnlock()
	PutSX1Help(cHelpKey,aHelpPor,aHelpEng,aHelpSpa)
EndIf  

// "Fornecedor De ?"
If SX1->(MsSeek(cGrupo+'15')) .And. SX1->X1_TAMANHO <> nTamFor .And. SX1->X1_GRPSXG <> cGrpSXG
	RecLock("SX1",.F.)
	SX1->X1_TAMANHO	:= nTamFor
	SX1->X1_GRPSXG	:= cGrpSXG
	MsUnlock()
EndIf

// "Fornecedor Ate ?"          
If SX1->(MsSeek(cGrupo+'16')) .And. SX1->X1_TAMANHO <> nTamFor .And. SX1->X1_GRPSXG <> cGrpSXG
	RecLock("SX1",.F.)
	SX1->X1_TAMANHO	:= nTamFor
	SX1->X1_GRPSXG	:= cGrpSXG
	MsUnlock()
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Formula  ³ Autor ³ Julio Saraiva         ³ Data ³ 11/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Interpreta formula cadastrada trocando o Alias             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ xExp1:= Formula(cExp1,nExp2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ xExp1:= Retorna formula iterpretada                        ³±±
±±³          ³ cExp1:= Codigo da formula previamente cadastrada em SM4    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
FUNCTION Form120(cFormula)
Local xAlias 
Local cForm		:= "" , xValor
Local cString 	:= "SC7->"
Local cNewAlias := "" 
Local cNewForm	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva a integridade dos dados                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xAlias := Alias()

DbSelectArea("SM4")
If DbSeek(cFilial+cFormula)
	cForm := AllTrim(M4_FORMULA)
	cNewAlias := xAlias + "->"
	cNewForm := StrTran(cForm,cString,cNewAlias)
	DbSelectArea(xAlias)      
	xValor := &cNewForm
Else
	xValor := NIL
EndIf
DbSelectArea(xAlias)
Return xValor
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R120FIniPC³ Autor ³ Edson Maricate        ³ Data ³20/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa as funcoes Fiscais com o Pedido de Compras      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R120FIniPC(ExpC1,ExpC2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Numero do Pedido                                  ³±±
±±³          ³ ExpC2 := Item do Pedido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110,MATR120,Fluxo de Caixa                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R120FIniPC(cPedido,cItem,cSequen,cFiltro)

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local cValid		:= ""
Local nPosRef		:= 0
Local nItem		:= 0
Local cItemDe		:= IIf(cItem==Nil,'',cItem)
Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
Local cRefCols	:= ''
DEFAULT cSequen	:= ""
DEFAULT cFiltro	:= ""

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
	MaFisEnd()
	MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
	While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
			SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)

		// Nao processar os Impostos se o item possuir residuo eliminado  
		If &cFiltro
			dbSelectArea('SC7')
			dbSkip()
			Loop
		EndIf
            
		// Inicia a Carga do item nas funcoes MATXFIS  
		nItem++
		MaFisIniLoad(nItem)
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek('SC7')
		While !EOF() .AND. (X3_ARQUIVO == 'SC7')
			cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
			cValid	:= StrTran(cValid,"'",'"')
			If "MAFISREF" $ cValid
				nPosRef  := AT('MAFISREF("',cValid) + 10
				cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
				// Carrega os valores direto do SC7.           
				MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
			EndIf
			dbSkip()
		End
		MaFisEndLoad(nItem,2)
		dbSelectArea('SC7')
		dbSkip()
	End
EndIf

RestArea(aAreaSC7)
RestArea(aArea)

Return .T.

Static Function SchedDef()

Local aParam  := {}
Local aOrd := {}
Aadd( aOrd, STR0004 ) // "Por Numero"
Aadd( aOrd, STR0005 ) // "Por Produto"
Aadd( aOrd, STR0006 ) // "Por Fornecedor"
Aadd( aOrd, STR0049 ) // "Por Previsao de Entrega "

aParam := { "R",;			//Tipo R para relatorio P para processo
            "DMR120",;	//Pergunte do relatorio, caso nao use passar ParamDef
            "SC7",;				//Alias
            aOrd,;				//Array de ordens
            STR0007}				//Titulo

Return aParam