#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMPCP02  บAutor  ณRicardo Roda        บ Data ณ  08/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓ro de Falta de Materiais na abertura de OPs          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMPCP2N()
	Private _cPerg :="DOMPCP002N"
	Private oReport
	Private cFilterUser
	Private oSection1
	Private oFont , oFontN
	Private cTitulo

	AjustaSX1(_cPerg)

	If Pergunte(_cPerg,.T.)
		oReport:=ReportDef()
		oReport:PrintDialog()
	EndIf

Return

//-----------------------------------

Static Function ReportDef()
	Local _cPictTit := "@E@Z 99999,999.99"
	Local _cPictTot := "@E 99,999,999.99"
	Local oSection1

	cTitulo:= "Relat๓rio de Falta de Materiais na abertura de OPs"
//oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito
//oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

//oSenha:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	oReport   :=TReport():New("DOMPCP02",cTitulo,_cPerg,{|oReport| ReportPrint(oReport)},"Este relat๓rio exibirแ as faltas de materiais apontadas na abertura das OPs.")

	oReport:SetLandScape()

	oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

	TRCell():New(oSection1,"XX_DATA"          ,,"Data"             , ,008,.F.,)
	TRCell():New(oSection1,"XX_PRODUTO"       ,,"Produto"          , ,015,.F.,)
	TRCell():New(oSection1,"XX_DESC"          ,,"Descri็ใo"        , ,060,.F.,)
	TRCell():New(oSection1,"XX_OP"            ,,"OP"               , ,011,.F.,)
	TRCell():New(oSection1,"XX_QTD"           ,,"Quantidade"       , ,020,.F.,)
	TRCell():New(oSection1,"XX_EMP"           ,,"Total Empenhos"   , ,020,.F.,)
	TRCell():New(oSection1,"XX_SALDO"         ,,"Saldo Estoque"    , ,020,.F.,)
	TRCell():New(oSection1,"XX_NECESS"        ,,"Necessidade"      , ,020,.F.,)
	TRCell():New(oSection1,"XX_DTPC"          ,,"DataPC"           , ,008,.F.,)
	TRCell():New(oSection1,"XX_PEDIDO"        ,,"Numero PC"        , ,006,.F.,)
	TRCell():New(oSection1,"XX_SALDOPC"       ,,"Saldo PC"         , ,011,.F.,)

	oSection1:SetHeaderPage()

	oSection1:Cell("XX_QTD"):SetHeaderAlign("RIGHT")
	oSection1:Cell("XX_QTD"):SetAlign("RIGHT")
	oSection1:Cell("XX_QTD"):SetSize(20)

	oSection1:Cell("XX_EMP"):SetHeaderAlign("RIGHT")
	oSection1:Cell("XX_EMP"):SetAlign("RIGTH")
	oSection1:Cell("XX_EMP"):SetSize(20)

	oSection1:Cell("XX_SALDO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("XX_SALDO"):SetAlign("RIGTH")
	oSection1:Cell("XX_SALDO"):SetSize(20)

	oSection1:Cell("XX_NECESS"):SetHeaderAlign("RIGHT")
	oSection1:Cell("XX_NECESS"):SetAlign("RIGTH")
	oSection1:Cell("XX_NECESS"):SetSize(20)

	oSection1:Cell("XX_DTPC"):SetHeaderAlign("RIGHT")
	oSection1:Cell("XX_DTPC"):SetAlign("RIGHT")
	oSection1:Cell("XX_DTPC"):SetSize(08)

	oSection1:Cell("XX_PEDIDO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("XX_PEDIDO"):SetAlign("RIGTH")
	oSection1:Cell("XX_PEDIDO"):SetSize(06)

	oSection1:Cell("XX_SALDOPC"):SetHeaderAlign("RIGHT")
	oSection1:Cell("XX_SALDOPC"):SetAlign("RIGHT")
	oSection1:Cell("XX_SALDOPC"):SetSize(11)
//oSection1:Cell("XX_SALDOPC"):SetPicture("@E 999,999.9999",11)

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMPCP02N บAutor  ณMicrosiga           บ Data ณ  08/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local nOrdem    := oSection1:GetOrder()
	Local _cAlias   := GetNextAlias()
	Local _cOrder   := "%D4_COD,C2_EMISSAO,D4_OP%"
	Local nTotal    := 0
	Local cProduto  := ''
	Local nSaldoB2	 := 0

	oReport:SetTitle(cTitulo)

	oFontN := TFont():New("Courier New",,08,,.T.,,,,.T.,.F.)// Negrito
	oFont  := TFont():New("Courier New",,08,,.F.,,,,.F.,.F.)

	BeginSql Alias _cAlias
	
	SELECT *
	FROM %table:SD4% SD4
	INNER JOIN %table:SC2% SC2 ON SC2.C2_FILIAL = %xFilial:SC2% AND C2_NUM = SUBSTRING(D4_OP,1,6) AND C2_ITEM = SUBSTRING(D4_OP,7,2) AND C2_SEQUEN = SUBSTRING(D4_OP,9,3) AND SC2.%notDel% 
	WHERE D4_QUANT <> 0
	AND SD4.D4_FILIAL = %xFilial:SD4% 
	AND SD4.%notDel% 
	AND C2_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	AND D4_COD BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%  
	AND D4_OPORIG = '' 
	AND D4_LOCAL <> '08'
	ORDER BY %Exp:_cOrder%
	
	EndSql

//TcSetField(_cAlias,"XX_DATA"   ,"D",  8, 0)

	oSection1:EndQuery()

	oSection1:Init()

//SD4->( dbSetOrder(1) )
	SC6->( dbSetOrder(1) )

	nRegAtu := 1
	nRetTot :=0
	(_cAlias)->( dbEval({|| nRetTot++}) )

	(_cAlias)->( dbGoTop() )

	dbSelectArea(_cAlias)
	While !oReport:Cancel() .And. (_cAlias)->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf

		//oReport:IncMeter('OP ' + Alltrim(Str(nRegAtu)) + '/' + Alltrim(Str(nRetTot)))
		oReport:IncMeter()
		nRegAtu++

		IF Empty(cProduto) .or. cProduto <> (_cAlias)->D4_COD
			cProduto := (_cAlias)->D4_COD
			// Saldo em estoque
			SB2->( dbSeek( xFilial() + cProduto ) )
			nTotB2 := 0
			nSaldoB2 := 0
			While !SB2->( EOF() ) .and. SB2->B2_COD == cProduto .and. SB2->B2_FILIAL == xFilial("SB2")
				//If SB2->B2_LOCAL <> '97'
				if SB2->B2_QATU > 0
					nTotB2 += SB2->B2_QATU
					nSaldoB2 := SB2->B2_QATU
				Endif
				//	EndIf
				SB2->( dbSkip() )
			End
		Endif

		nTotal   := (_cAlias)->D4_QUANT

		if nTotb2 >= nTotal
			nTotB2 := nTotb2 - nTotal
			(_cAlias)->(dbSkip())
		Else

			oSection1:Cell("XX_DATA")    :SetValue(DtoC(StoD((_cAlias)->C2_EMISSAO)))
			oSection1:Cell("XX_PRODUTO") :SetValue((_cAlias)->D4_COD)
			oSection1:Cell("XX_DESC")    :SetValue(Posicione("SB1",1,xFilial("SB1")+(_cAlias)->D4_COD,"B1_DESC"))
			oSection1:Cell("XX_OP")      :SetValue((_cAlias)->D4_OP)
			oSection1:Cell("XX_QTD")     :SetValue((_cAlias)->D4_QUANT)

			//C2_NCLIENT
			SC2->( dbSeek( xFilial() + (_cAlias)->D4_OP ) )
			SC6->( dbSeek( xFilial() + SC2->C2_PEDIDO + SC2->C2_ITEMPV ) )

			oSection1:Cell("XX_EMP")     :SetValue(" Cli: "      + SC2->C2_NCLIENT                             )
			oSection1:Cell("XX_SALDO")   :SetValue(" OF: "       + SC2->C2_PEDIDO + ' Item: ' + SC2->C2_ITEMPV )
			oSection1:Cell("XX_NECESS")  :SetValue(" Data OTD: " + DtoC(SC6->C6_XXDTDEF)                       )
			oSection1:Cell("XX_DTPC")    :SetValue("")
			oSection1:Cell("XX_PEDIDO")  :SetValue("")
			oSection1:Cell("XX_SALDOPC") :SetValue("")

			oSection1:PrintLine()


			dbSelectArea(_cAlias)
			dbSkip()

			//oSection1:PrintLine()
			oReport:SkipLine()

			If cProduto <> (_cAlias)->D4_COD

				//oSection1:PrintLine()
				//oReport:SkipLine()

				oSection1:Cell("XX_DATA")    :SetValue("")
				oSection1:Cell("XX_PRODUTO") :SetValue("")
				oSection1:Cell("XX_DESC")    :SetValue("")
				oSection1:Cell("XX_OP")      :SetValue("")
				oSection1:Cell("XX_QTD")     :SetValue("")
				oSection1:Cell("XX_EMP")     :SetValue("")
				oSection1:Cell("XX_SALDO")   :SetValue("")
				oSection1:Cell("XX_NECESS")  :SetValue("")
				oSection1:Cell("XX_DTPC")    :SetValue("")
				oSection1:Cell("XX_PEDIDO")  :SetValue("")
				oSection1:Cell("XX_SALDOPC") :SetValue("")


				// Total de Empenhos
				cQuery := "SELECT SUM(D4_QUANT) AS D4_QUANT FROM " + RetSqlName("SD4") + " (NOLOCK)  WHERE D4_FILIAL = '" + xFilial("SD4") + "' AND D4_COD = '"+cProduto+"' AND D4_QUANT <> 0 AND D_E_L_E_T_ = '' "

				If Select("QUERYSD4") <> 0
					QUERYSD4->( dbCloseArea() )
				EndIf

				TCQUERY cQuery NEW ALIAS "QUERYSD4"


				// Data PC, Numero PC e Quantidade PC
				cQuery := "SELECT C7_QUANT, C7_QUJE, C7_DATPRF, C7_NUM FROM " + RetSqlName("SC7") + " (NOLOCK) WHERE   C7_FILIAL= '" + xFilial("SC7") + "' AND C7_PRODUTO = '"+cProduto+"' AND D_E_L_E_T_ = '' AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' ORDER BY C7_DATPRF"

				If Select("QUERYSC7") <> 0
					QUERYSC7->( dbCloseArea() )
				EndIf

				TCQUERY cQuery NEW ALIAS "QUERYSC7"

				TcSetField("QUERYSC7","C7_DATPRF"   ,"D",  8, 0)


				If oReport:nDevice == 4   // 4 == Planilha
					oSection1:Cell("XX_DATA")    :SetValue("TOTAL")
					oSection1:Cell("XX_PRODUTO") :SetValue("")
					oSection1:Cell("XX_DESC")    :SetValue("")
					oSection1:Cell("XX_OP")      :SetValue("")
					oSection1:Cell("XX_QTD")     :SetValue(Transform(nTotal,'@E 99,999,999,999.9999'))
					oSection1:Cell("XX_EMP")     :SetValue(Transform(QUERYSD4->D4_QUANT,'@E 9,999,999,999.9999'))
					oSection1:Cell("XX_SALDO")   :SetValue(Transform(nSaldoB2,'@E 9,999,999,999.9999'))
					oSection1:Cell("XX_NECESS")  :SetValue(Transform(QUERYSD4->D4_QUANT - nSaldoB2,'@E 99,999,999,999.9999'))

					nTotPC := 0
					nNumPC := 0

					If !QUERYSC7->( EOF() )  //!Empty(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)
						While !QUERYSC7->( EOF() )
							If nNumPC <> 0
								oSection1:Cell("XX_DATA")    :SetValue("")
								oSection1:Cell("XX_PRODUTO") :SetValue("")
								oSection1:Cell("XX_DESC")    :SetValue("")
								oSection1:Cell("XX_OP")      :SetValue("")
								oSection1:Cell("XX_QTD")     :SetValue("")
								oSection1:Cell("XX_EMP")     :SetValue("")
								oSection1:Cell("XX_SALDO")   :SetValue("")
								oSection1:Cell("XX_NECESS")  :SetValue("")
							EndIf
							oSection1:Cell("XX_DTPC")    :SetValue(DtoC(QUERYSC7->C7_DATPRF))
							oSection1:Cell("XX_PEDIDO")  :SetValue(QUERYSC7->C7_NUM)
							oSection1:Cell("XX_SALDOPC") :SetValue(Transform(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE,"@E 99,999.9999"))

							nTotPC += QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE
							nNumPC += 1
							QUERYSC7->( dbSkip() )
							oSection1:PrintLine()
							oReport:SkipLine()
						End
						If nNumPC > 1
							oSection1:Cell("XX_DTPC")    :SetValue("")
							oSection1:Cell("XX_PEDIDO")  :SetValue("")
							oSection1:Cell("XX_SALDOPC") :SetValue(Transform(nTotPC,'@E 99,999.9999'))
							oSection1:PrintLine()
							oReport:SkipLine()
						EndIf
					Else
						oSection1:Cell("XX_DTPC")    :SetValue("")
						oSection1:Cell("XX_PEDIDO")  :SetValue("")
						oSection1:Cell("XX_SALDOPC") :SetValue("")

						oSection1:PrintLine()
						oReport:SkipLine()
					EndIf

					nTotal   := 0
				Else
					oReport:Say( oReport:Row() , oSection1:Cell("XX_DATA"):ColPos() , "TOTAL"                                                ,oFontN )
					// Quantidade
					oReport:Say( oReport:Row() , oSection1:Cell("XX_QTD"):ColPos()   , Transform(nTotal,'@E 99,999,999,999.9999')            ,oFontN )
					oReport:Say( oReport:Row() , oSection1:Cell("XX_EMP"):ColPos()   , Transform(QUERYSD4->D4_QUANT,'@E 9,999,999,999.9999') ,oFontN )
					// Necessidade
					oReport:Say( oReport:Row() , oSection1:Cell("XX_SALDO"):ColPos() , Transform(nSaldoB2,'@E 9,999,999,999.9999') ,oFontN )
					oReport:Say( oReport:Row() , oSection1:Cell("XX_NECESS"):ColPos(), Transform(QUERYSD4->D4_QUANT - nSaldoB2,'@E 99,999,999,999.9999') ,oFontN )

					nTotPC := 0
					nNumPC := 0

					If !QUERYSC7->( EOF() )  //!Empty(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)
						While !QUERYSC7->( EOF() )
							oReport:Say( oReport:Row() , oSection1:Cell("XX_DTPC"):ColPos()   , DtoC(QUERYSC7->C7_DATPRF)            ,oFontN )
							oReport:Say( oReport:Row() , oSection1:Cell("XX_PEDIDO"):ColPos() , QUERYSC7->C7_NUM                     ,oFontN )
							oReport:Say( oReport:Row() , oSection1:Cell("XX_SALDOPC"):ColPos(), Transform(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE,"@E 99,999.9999") ,oFontN )

							nTotPC += QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE
							nNumPC += 1
							QUERYSC7->( dbSkip() )
							oSection1:PrintLine()
							oReport:SkipLine()
						End
						If nNumPC > 1
							oReport:Say( oReport:Row() , oSection1:Cell("XX_SALDOPC"):ColPos() , Transform(nTotPC,'@E 99,999.9999') ,oFontN )
							oSection1:PrintLine()
							oReport:SkipLine()
						EndIf
					Else
						oReport:Say( oReport:Row() , oSection1:Cell("XX_DTPC"):ColPos()   , "" ,oFontN )
						oReport:Say( oReport:Row() , oSection1:Cell("XX_PEDIDO"):ColPos() , "" ,oFontN )
						oReport:Say( oReport:Row() , oSection1:Cell("XX_SALDOPC"):ColPos(), "" ,oFontN )

						oSection1:PrintLine()
						oReport:SkipLine()
					EndIf

					nTotal   := 0
				EndIf

				//oReport:IncMeter()
			EndIf
		ENdif
	EndDo

	oSection1:Finish()
	oReport:EndPage()

Return


Static Function AjustaSX1(cPerg)

	DbSelectArea("SX1")
	DbSetOrder(1)
	aRegs :={}
	aAdd(aRegs, {cPerg, "01", "Data De  ?",              "", "", "mv_ch1", "D",08, 0, 0, "G", "", "MV_PAR01", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "	 ", "" , "", "","","",""})
	aAdd(aRegs, {cPerg, "02", "Data Ate ?",              "", "", "mv_ch2", "D",30, 0, 0, "G", "", "MV_PAR02", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "	 ", "" , "", "","","",""})
	aAdd(aRegs, {cPerg, "03", "Produto De  ?",           "", "", "mv_ch3", "C",30, 0, 0, "G", "", "MV_PAR03", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})
	aAdd(aRegs, {cPerg, "04", "Produto Ate ?",           "", "", "mv_ch4", "C",30, 0, 0, "G", "", "MV_PAR04", ""     , "" , "" , "" , "", "" , "", "", "", "", ""       , "", "", "", "", ""    , "", "", "", "", "", "", "", "", "SB1", "" , "", "","","",""})

//aAdd(aRegs, {cPerg, "03", "Filtrar 		 ",				  "", "", "mv_ch3", "N",03, 0, 0, "C", "", "MV_PAR03","Iguais", "" , "" , "" , "", "Diferente" , "", "", "", "", "Ambos" 		 , "", "", "", "", ""	 , "", "", "", "", "", "", "", "", ""   , "" , "", "","",""})
	fAjuSx1(cPerg,aRegs)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณEtAjuSx1  ณ Autor ณ Anderson              ณ Data ณ 30/09/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria uma pergunta usando rotina padrao                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAjuSx1(cPerg,aRegs)

	Local _nTamX1, _nTamPe, _nTamDf, j, i := 0

	DbSelectArea("SX1")
	DbSetOrder(1)

// Indo ao Primeiro Registro do SX1, apenas para descobrir o tamanho do campo com o nome da PERGUNTA
// Campo chamado X1_GRUPO
	DbGoTop()
	_nTamX1	:= Len(SX1->X1_GRUPO)
	_nTamPe	:= Len(Alltrim(cPerg))
	_nTamDf	:= _nTamX1 - _nTamPe

// Adequando o Tamanho para Efetuar a Pesquisa no SX1
	If _nTamDf > 0
		cPerg := cPerg + Space(_nTamDf)
	ElseIf _nTamDf == 0
		cPerg := cPerg
	Else
		Return()
	EndIf

// Criando Perguntas caso NAO existam no SX1
	For i:=1 to Len(aRegs)

		If !DbSeek(cPerg+aRegs[i,2])

			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()

			DbCommit()
		Endif
	Next

Return()
