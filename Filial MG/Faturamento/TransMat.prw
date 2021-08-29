
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TransMat  ºAutor  ³Osmar Ferreira      º Data ³  05/03/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Saldos em estoque por armazém                 º±±
±±º          ³ para transferencia da Matriz para a filial MG                        º±±
±±º          ³ com layout para importação no PV                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TransMat()

	Local oReport
	Private _cPerg :="TRAMAT"
	Private cLocTransf  :=  GetMV("MV_XLOCTRA")

	fCriaPerg()
	If Pergunte(_cPerg,.T.)
		oReport:=ReportDef()
		oReport:PrintDialog()
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função principal Relatório.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportDef()
	Local oReport
	Local oSection
	//Local oBreak

	oReport:=TReport():New("TransMat","Material a ser transferido para a Matriz. " ,"TransMat",{|oReport| PrintReport(oReport)},"Armazém "+cLocTransf)

	oReport:SetLineHeight(40)
	oReport:nFontBody:=08   // 08
	oReport:lParamPage := .F.

	oReport:SetLandscape() 	  			// Retrato
	oReport:opage:SetPaperSize(9)     	// Papel A4
    //oReport:opage:SetPaperSize(8) 	// Papel A3
	oReport:cFontBody:='Courier New'

	oSection   :=TRSection():New(oReport,"Saldo em estoque ",{})

	TRCell():New(oSection,"PRODUTO"             ,,"PRODUTO"             , ,015,.F.,)
	TRCell():New(oSection,"SALDO_ATUAL"         ,,"SALDO ATUAL"         , ,020,.F.,)
	TRCell():New(oSection,"PRECO"         		,,"PRECO"        		, ,020,.F.,)
	TRCell():New(oSection,"CODCLI"         		,,"COD CLIENTE"         , ,020,.F.,)
	TRCell():New(oSection,"ITEM_CLI"         	,,"ITEM CLIENTE"        , ,020,.F.,)
	TRCell():New(oSection,"SHIPHUAWEI"         	,,"SHIP (HUAWEI)"       , ,020,.F.,)
	TRCell():New(oSection,"DATA_CLI"         	,,"DATA CLIENTE"        , ,020,.F.,)
	TRCell():New(oSection,"TP_OPER_RDT"         ,,"TP_OPER_RDT"         , ,020,.F.,)

    //oBreak := TRBreak():New(oSection,oSection:Cell("B1_DESC"),,.F.)
    //TRFunction():New(oSection:Cell("B1_COD"),"Qtd. ítens","COUNT",,,"@E 999,999",,.T.,.F.,.F.,oSection)    // F T F

Return oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função de filtro dos Dados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function PrintReport(oReport)

	//Local cPart
	//Local cFiltro    := ""

	Local nRecno     := 0
	Private _cAlias	 := GetNextAlias()
	Private oSection := oReport:Section(1)
	Private nOrdem   := oSection:GetOrder()
	
//	oReport:SetLandscape() 	 		// Retrato
//	oReport:opage:SetPaperSize(9)  	// Papel A4

	oSection:Init()
	oSection:SetTotalInLine(.F.)

	xQuery1()

	nRecno := 0
	(_cAlias)->( dbEval({|| nRecno++}) )

	(_cAlias)->( dbGoTop() )

	oReport:SetMeter(nRecno)

	dbSelectArea(_cAlias)

	While !oReport:Cancel() .And. (_cAlias)->(!Eof()) //.And. cUsuario == (_cAlias)->ID_USUARIO

		If oReport:Cancel()
			Exit
		EndIf

		oSection:Cell("PRODUTO")			:SetValue((_cAlias)->PRODUTO  )
		oSection:Cell("SALDO ATUAL")		:SetValue((_cAlias)->SALDO_ATUAL  	 )
		oSection:Cell("PRECO")				:SetValue(Round(U_RetCusB9((_cAlias)->PRODUTO,"N"),4) )
		oSection:Cell("COD CLIENTE")		:SetValue((_cAlias)->CODCLI )
		oSection:Cell("ITEM CLIENTE")		:SetValue((_cAlias)->ITEM_CLI)
		oSection:Cell("SHIP (HUAWEI)")		:SetValue((_cAlias)->SHIPHUAWEI )
		oSection:Cell("DATA CLIENTE")		:SetValue((_cAlias)->DATA_CLI)
		oSection:Cell("TP_OPER_RDT")		:SetValue((_cAlias)->TP_OPER_RDT)

		oSection:PrintLine()

		oReport:IncMeter()

		(_cAlias)->(dbSkip()	)

		///////////////////oReport:Skipline()
		//oReport:Thinline()
		//oReport:Skipline()

	EndDo

	oReport:EndPage()

	// Finaliza Secao e Imprime o Total Geral, Definido no TRFUNCTION
	oSection:Finish()
	////oItSection:Finish()
	oReport:EndPage()

	(_cAlias)->( dbCloseArea() )
Return


Static Function fCriaPerg()
	Local i:=j:=0
	aSvAlias:={Alias(),IndexOrd(),Recno()}
	//i:=j:=0
	aRegistros:={}
	_cPerg := PADR(_cPerg,10)
     //                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
	AADD(aRegistros,{_cPerg,"02","Código de?  ","","","mv_ch1","C",08,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
	AADD(aRegistros,{_cPerg,"03","Até Código? ","","","mv_ch2","C",08,00,00,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
	
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



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query com saldos em estoque³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function xQuery1

	MakeSqlExpr(_cAlias)
	oSection:BeginQuery()
	//oItSection:BeginQuery()

	BeginSql alias _cAlias

	Select	B2_FILIAL, B2_COD As 'PRODUTO', B2_QATU As 'SALDO_ATUAL', '' As 'CODCLI', 
			'' As 'ITEM_CLI', '' As 'SHIPHUAWEI','' As 'DATA_CLI', '50' As 'TP_OPER_RDT'
    From %Table:SB2% SB2 (Nolock)
    Inner Join %Table:SB1% SB1 (Nolock) On SB1.%NotDel% And B1_COD = B2_COD 
    Where SB2.%NotDel% And B2_FILIAL = '02' And B2_QATU > 0 And
		B2_LOCAL = %Exp:cLocTransf% And  B1_COD BetWeen %Exp:mv_par01% And %Exp:mv_par02%
    Order By B1_COD

	EndSql

	oSection:EndQuery()
	///oItSection:EndQuery()

Return(_cAlias)




