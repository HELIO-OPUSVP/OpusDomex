#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

#Define  _LF  Chr(10)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕª±±
±±∫ Programa   ≥ RFATR05   ≥ Autor ≥ Cesar Arneiro (Opus VP)             ≥ Data ≥ 29/03/18 ∫±±
±±«ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ∂±±
±±∫ Descricao  ≥ Relatorio de Vendas - Previsto x Realizado                                ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕ—ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ Analista Resp. ≥   Data   ≥ Manutencao Efetuada                                        ∫±±
±±«ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∂±±
±±∫                ≥   /  /   ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/ 
User Function RFATR05()

	Local _aSX1 := {}

	Private cPerg := "RFATR05"
	Private oReport
	Private cFilterUser
	Private oSection1
	Private oFont, oFontN
	Private cTitulo
	Private nReg := 0

	aAdd(_aSX1, {"GRUPO", "ORDEM", "PERGUNT"         , "VARIAVL", "TIPO", "TAMANHO", "DECIMAL", "GSC", "VALID", "VAR01"   , "F3" , "GRPSXG", "DEF01", "DEF02", "DEF03", "DEF04", "DEF05"})
	aAdd(_aSX1, {cPerg , "01"   , "Data de?"         , "mv_ch0" , "D"   , 08       , 0        , "G"  , ""     , "mv_par01", ""   , ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "02"   , "Data ate?"        , "mv_ch1" , "D"   , 08       , 0        , "G"  , ""     , "mv_par02", ""   , ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "03"   , "Cliente de?"      , "mv_ch2" , "C"   , 06       , 0        , "G"  , ""     , "mv_par03", "SA1", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "04"   , "Loja de?"         , "mv_ch3" , "C"   , 02       , 0        , "G"  , ""     , "mv_par04", ""   , ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "05"   , "Cliente ate?"     , "mv_ch4" , "C"   , 06       , 0        , "G"  , ""     , "mv_par05", "SA1", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "06"   , "Loja ate?"        , "mv_ch5" , "C"   , 02       , 0        , "G"  , ""     , "mv_par06", ""   , ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "07"   , "Vendedor de?"     , "mv_ch6" , "C"   , 06       , 0        , "G"  , ""     , "mv_par07", "SA3", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "08"   , "Vendedor ate?"    , "mv_ch7" , "C"   , 06       , 0        , "G"  , ""     , "mv_par08", "SA3", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "09"   , "Produto PA de?"   , "mv_ch8" , "C"   , 15       , 0        , "G"  , ""     , "mv_par09", "SB1", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "10"   , "Produto PA ate?"  , "mv_ch9" , "C"   , 15       , 0        , "G"  , ""     , "mv_par10", "SB1", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "11"   , "Componente de?"   , "mv_cha" , "C"   , 15       , 0        , "G"  , ""     , "mv_par11", "SB1", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "12"   , "Componente ate?"  , "mv_chb" , "C"   , 15       , 0        , "G"  , ""     , "mv_par12", "SB1", ""      , ""     , ""     , ""     , ""     , ""     })
	aAdd(_aSX1, {cPerg , "13"   , "Tipos de Produto?", "mv_chc" , "C"   , 50       , 0        , "G"  , ""     , "mv_par13", ""   , ""      , ""     , ""     , ""     , ""     , ""     })

	U_cf_PutSX1(cPerg, _aSX1)

	If Pergunte(cPerg, .T.)
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf

Return


Static Function ReportDef()

	Local oSection1
	Local _aOrdem := {"Cliente e Quantidade", "Cliente e Valor", "Vendedor e Quantidade", "Vendedor e Valor"}

	cTitulo := "RelatÛrio de Vendas - Previsto x Realizado"
	oFontN  := TFont():New("Times New Roman", 08, 08, , .T., , , , .T., .F.)	// Negrito
	oFont   := TFont():New("Times New Roman", 08, 08, , .F., , , , .F., .F.)

	oReport := TReport():New("RFATR05", cTitulo, cPerg, {|oReport| ReportPrin(oReport)}, "Este relatÛrio exibir· comparaÁ„o entre a Previs„o de Venda e as notas fiscais.")

	oReport:SetLandScape()

	oSection1 := TRSection():New(oReport, "", "SC4", _aOrdem, .F. /*aOrder*/, .F. /*lLoadCells*/, "" /*cTotalText*/, .F. /*lTotalInCol*/, .F. /*lHeaderPage*/, .F. /*lHeaderBreak*/)

	TRCell():New(oSection1, "C4_XXCNPJ" , , "CNPJ Cliente" , , 010, .F., )
	TRCell():New(oSection1, "A1_NREDUZ" , , "Nome Cliente" , , 030, .F., )
	TRCell():New(oSection1, "A3_COD"    , , "CÛd. Vend."   , , 010, .F., )
	TRCell():New(oSection1, "A3_NREDUZ" , , "Nome Vendedor", , 030, .F., )
	TRCell():New(oSection1, "C4_PRODUTO", , "Produto"      , , 015, .F., )
	TRCell():New(oSection1, "B1_DESC"   , , "DescriÁ„o"    , , 030, .F., )
	TRCell():New(oSection1, "C4_XXQTDOR", , "Qtd. Prev."   , , 014, .F., )
	TRCell():New(oSection1, "VLR_PREV"  , , "Valor Prev."  , , 014, .F., )
	TRCell():New(oSection1, "D2_QUANT"  , , "Qtd. Real"    , , 014, .F., )
	TRCell():New(oSection1, "D2_TOTAL"  , , "Valor Real"   , , 014, .F., )
	TRCell():New(oSection1, "DIF_QTD"   , , "Dif. Quant."  , , 014, .F., )
	TRCell():New(oSection1, "DIF_VLR"   , , "Dif. Valor"   , , 014, .F., )
	TRCell():New(oSection1, "PERCENTUAL", , "% Acerto"     , , 003, .F., )
	TRCell():New(oSection1, "B1_ORIGEM" , , "Origem"       , , 001, .F., )

	oSection1:SetHeaderPage(.T.)

	oSection1:Cell("C4_XXCNPJ"):SetHeaderAlign("CENTER")
	oSection1:Cell("C4_XXCNPJ"):SetAlign("CENTER")
	oSection1:Cell("C4_XXCNPJ"):SetSize(10)

	oSection1:Cell("A1_NREDUZ"):SetHeaderAlign("LEFT")
	oSection1:Cell("A1_NREDUZ"):SetAlign("LEFT")
	oSection1:Cell("A1_NREDUZ"):SetSize(30)

	oSection1:Cell("A3_COD"):SetHeaderAlign("CENTER")
	oSection1:Cell("A3_COD"):SetAlign("CENTER")
	oSection1:Cell("A3_COD"):SetSize(06)

	oSection1:Cell("A3_NREDUZ"):SetHeaderAlign("LEFT")
	oSection1:Cell("A3_NREDUZ"):SetAlign("LEFT")
	oSection1:Cell("A3_NREDUZ"):SetSize(30)

	oSection1:Cell("C4_PRODUTO"):SetHeaderAlign("LEFT")
	oSection1:Cell("C4_PRODUTO"):SetAlign("LEFT")
	oSection1:Cell("C4_PRODUTO"):SetSize(15)

	oSection1:Cell("C4_XXQTDOR"):SetHeaderAlign("RIGHT")
	oSection1:Cell("C4_XXQTDOR"):SetAlign("RIGHT")
	oSection1:Cell("C4_XXQTDOR"):SetSize(14)
	oSection1:Cell("C4_XXQTDOR"):SetPicture("@E 999,999,999.99")

	oSection1:Cell("VLR_PREV"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VLR_PREV"):SetAlign("RIGHT")
	oSection1:Cell("VLR_PREV"):SetSize(14)
	oSection1:Cell("VLR_PREV"):SetPicture("@E 999,999,999.99")

	oSection1:Cell("D2_QUANT"):SetHeaderAlign("RIGHT")
	oSection1:Cell("D2_QUANT"):SetAlign("RIGHT")
	oSection1:Cell("D2_QUANT"):SetSize(14)
	oSection1:Cell("D2_QUANT"):SetPicture("@E 999,999,999.99")

	oSection1:Cell("D2_TOTAL"):SetHeaderAlign("RIGHT")
	oSection1:Cell("D2_TOTAL"):SetAlign("RIGHT")
	oSection1:Cell("D2_TOTAL"):SetSize(14)
	oSection1:Cell("D2_TOTAL"):SetPicture("@E 999,999,999.99")

	oSection1:Cell("DIF_QTD"):SetHeaderAlign("RIGHT")
	oSection1:Cell("DIF_QTD"):SetAlign("RIGHT")
	oSection1:Cell("DIF_QTD"):SetSize(14)
	oSection1:Cell("DIF_QTD"):SetPicture("@E 999,999,999.99")

	oSection1:Cell("DIF_VLR"):SetHeaderAlign("RIGHT")
	oSection1:Cell("DIF_VLR"):SetAlign("RIGHT")
	oSection1:Cell("DIF_VLR"):SetSize(14)
	oSection1:Cell("DIF_VLR"):SetPicture("@E 999,999,999.99")

Return oReport


//---------------------------------------------------------
Static Function ReportPrin(oReport)

	Local oSection1 := oReport:Section(1)
	Local nOrdem    := oSection1:GetOrder()
	//Local _cOrder   := "%C4_PRODUTO%"
	//Local _aEstru   := {}
	Local _aItens   := {}
	//Local _aStruct  := {}
	//Local _nQtd     := 0
	Local _cQuery, _nI, _nPos

	Local lDebug    := .F.

	Local _nJ

// Estrutura do array _aItens
// 	[1] CÛdigo/CNPJ do cliente ou do cÛdigo do vendedor
//		[2] Quantidade total prevista
//		[3] Valor total previsto
//		[4] Quantidade total faturada
//		[5] Valor total faturado
//		[6] Diferenca de quantidade
//		[7] Diferenca de valor
//		[8] Itens
//			[ 1] CÛdigo/CNPJ do cliente
//			[ 2] Nome do cliente
//			[ 3] CÛdigo do vendedor
//			[ 4] Nome do vendedor
//			[ 5] CÛdigo do produto
//			[ 6] Quantidade prevista
//			[ 7] Valor previsto
//			[ 8] Quantidade faturada
//			[ 9] Valor faturado
//			[10] DiferenÁa de quantidade
//			[11] DiferenÁa de valor

	_cQuery := "SELECT (CASE WHEN SA1.A1_CGC = ' ' THEN SA1.A1_COD ELSE LEFT(SA1.A1_CGC,8) END) CNPJ, SA1.A1_NREDUZ, SA1.A1_VEND, ISNULL(SA3.A3_NREDUZ,'') NOME_VEND, " + _LF
	_cQuery += "			SC4.C4_PRODUTO, SB1.B1_LOCPAD, LEFT(SC4.C4_DATA,6) MESREF, SUM(SC4.C4_XXQTDOR) QTD " + _LF
	_cQuery += "FROM " + RetSQLName("SC4") + " SC4 " + _LF
	_cQuery += "	INNER JOIN " + RetSQLName("SA1") + " SA1 " + _LF
	_cQuery += "		 ON SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + _LF
	_cQuery += "		AND SA1.A1_COD     = SC4.C4_XXCLIEN " + _LF
	_cQuery += "		AND SA1.A1_LOJA    = SC4.C4_XXLOJA " + _LF
	_cQuery += "		AND SA1.A1_VEND    BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + _LF
	_cQuery += "		AND SA1.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "	INNER JOIN " + RetSQLName("SB1") + " SB1 " + _LF
	_cQuery += "		 ON SB1.B1_FILIAL  = '" + xFilial("SB1") + "' " + _LF
	_cQuery += "		AND SB1.B1_COD     = SC4.C4_PRODUTO " + _LF
	_cQuery += "		AND SB1.B1_TIPO    <> 'MO' " + _LF
	_cQuery += "		AND SB1.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "	LEFT JOIN " + RetSQLName("SA3") + " SA3 " + _LF
	_cQuery += "		 ON SA3.A3_FILIAL  = '" + xFilial("SA3") + "' " + _LF
	_cQuery += "		AND SA3.A3_COD     = SA1.A1_VEND " + _LF
	_cQuery += "		AND SA3.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "WHERE   SC4.C4_FILIAL  = '" + xFilial("SC4") + "' " + _LF
	_cQuery += "	AND SC4.C4_DATA    BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' " + _LF
	_cQuery += "	AND SC4.C4_XXCLIEN BETWEEN '" + mv_par03 + "' AND '" + mv_par05 + "' " + _LF
	_cQuery += "	AND SC4.C4_XXLOJA  BETWEEN '" + mv_par04 + "' AND '" + mv_par06 + "' " + _LF
	_cQuery += "	AND SC4.C4_XCODPA  BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' " + _LF
	_cQuery += "	AND SC4.C4_PRODUTO BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' " + _LF
	_cQuery += "	AND SC4.C4_PRODUTO <> ' ' " + _LF
	_cQuery += "	AND SC4.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "GROUP BY (CASE WHEN SA1.A1_CGC = ' ' THEN SA1.A1_COD ELSE LEFT(SA1.A1_CGC,8) END), SA1.A1_NREDUZ, SA1.A1_VEND, ISNULL(SA3.A3_NREDUZ,''), SC4.C4_PRODUTO, " + _LF
	_cQuery += "			SB1.B1_LOCPAD, LEFT(SC4.C4_DATA,6) " + _LF

	If lDebug
		AutoGrLog(_cQuery)
		MostraErro()
	EndIf

	TCQUERY _cQuery NEW ALIAS "tSC4"

	If nOrdem == 1 .Or. nOrdem == 2	// Por Cliente
		_cQuebra := "CNPJ"
	Else
		_cQuebra := "A1_VEND"
	EndIf
	tSC4->(dbGoTop())

	SB1->( dbSetOrder(1) )

	While !tSC4->(Eof())
		SB1->( dbSeek( xFilial() + tSC4->C4_PRODUTO ) )

		If !(Alltrim(SB1->B1_TIPO) $ mv_par13)
			tSC4->(dbSkip())
			Loop
		EndIf

		// Obtem o custo mÈdio do item
		_nCM := fCM1(tSC4->C4_PRODUTO, tSC4->B1_LOCPAD, tSC4->MESREF)

		// Verifica se o cliente/vendedor j· est· no array
		_nPos := aScan(_aItens, {|x| x[1] == tSC4->&(_cQuebra)})

		If _nPos == 0
			aAdd(_aItens, {tSC4->&(_cQuebra), tSC4->QTD, tSC4->QTD * _nCM, 0, 0, 0, 0, {}})
			_nPos := Len(_aItens)
		Else
			_aItens[_nPos][2] += tSC4->QTD
			_aItens[_nPos][3] += tSC4->QTD * _nCM
		EndIf

		// Verifica se o cliente + vendedor + produto j· est· no array
		_nPos2 := aScan(_aItens[_nPos][8], {|x| x[1] == tSC4->CNPJ .And. x[3] == tSC4->A1_VEND .And. x[5] == tSC4->C4_PRODUTO})

		If _nPos2 == 0
			aAdd(_aItens[_nPos][8], {tSC4->CNPJ, tSC4->A1_NREDUZ, tSC4->A1_VEND, tSC4->NOME_VEND, tSC4->C4_PRODUTO, tSC4->QTD, tSC4->QTD * _nCM, 0, 0, 0, 0})
		Else
			_aItens[_nPos][8][_nPos2][6] += tSC4->QTD
			_aItens[_nPos][8][_nPos2][7] += tSC4->QTD * _nCM
		EndIf

		tSC4->( dbSkip() )
	EndDo

	tSC4->(dbCloseArea())

	//_cQuery := "WITH ESTRUT( CODIGO, COD_PAI, COD_COMP, QTD, PERDA, DT_INI, DT_FIM, NIVEL ) AS " + _LF
	_cQuery := "WITH ESTRUT( CODIGO, COD_PAI, COD_COMP, QTD, PERDA, NIVEL ) AS " + _LF
	_cQuery += "( " + _LF
	//_cQuery += "      SELECT G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, 1 AS NIVEL " + _LF
	_cQuery += "      SELECT G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, 1 AS NIVEL " + _LF
	_cQuery += "        FROM " + RetSQLName("SG1") + " SG1 (NOLOCK) " + _LF
	_cQuery += "     WHERE SG1.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "       AND G1_FILIAL      = '" + xFilial("SG1" ) + "' " + _LF
	_cQuery += "     UNION ALL " + _LF
	//_cQuery += "      SELECT CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, G1_INI, G1_FIM, NIVEL + 1 " + _LF
	_cQuery += "      SELECT CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, NIVEL + 1 " + _LF
	_cQuery += "        FROM " + RetSQLName("SG1") + " SG1 (NOLOCK) " + _LF
	_cQuery += "     INNER JOIN ESTRUT EST " + _LF
	_cQuery += "        ON G1_COD = COD_COMP " + _LF
	_cQuery += "     WHERE SG1.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "       AND SG1.G1_FILIAL = '" + xFilial("SG1") + "' " + _LF
	_cQuery += ") " + _LF
	_cQuery += "SELECT (CASE WHEN SA1.A1_CGC = ' ' THEN SA1.A1_COD ELSE LEFT(SA1.A1_CGC,8) END) CNPJ, SA1.A1_NREDUZ, SF2.F2_VEND1, ISNULL(SA3.A3_NREDUZ,'') NOME_VEND, " + _LF
	_cQuery += "		SUM(SD2.D2_QUANT) QTD, SUM(SD2.D2_TOTAL) TOTAL, LEFT(SD2.D2_EMISSAO,6) MESREF, ISNULL(ESTR.COD_COMP,SD2.D2_COD) D2_COD, ISNULL(ESTR.QTD,0) QTD_ESTR, " + _LF
	_cQuery += "        IsNull(OPC.OPCIONAL,'') OPCIONAL, SUM(IsNull(OPC.QTDEUSO,0)) QTDEUSO " + _LF
	_cQuery += "FROM " + RetSQLName("SF2") + " SF2 " + _LF
	_cQuery += "	INNER JOIN " + RetSQLName("SD2") + " SD2 " + _LF
	_cQuery += "		 ON SD2.D2_FILIAL  = SF2.F2_FILIAL " + _LF
	_cQuery += "		AND SD2.D2_DOC     = SF2.F2_DOC " + _LF
	_cQuery += "		AND SD2.D2_SERIE   = SF2.F2_SERIE " + _LF
	_cQuery += "		AND SD2.D2_TIPO    = SF2.F2_TIPO " + _LF
	_cQuery += "		AND SD2.D2_COD     BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' " + _LF
	_cQuery += "		AND SD2.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "	INNER JOIN " + RetSQLName("SA1") + " SA1 " + _LF
	_cQuery += "		 ON SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + _LF
	_cQuery += "		AND SA1.A1_COD     = SF2.F2_CLIENTE " + _LF
	_cQuery += "		AND SA1.A1_LOJA    = SF2.F2_LOJA " + _LF
	_cQuery += "		AND SA1.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "	LEFT JOIN " + RetSQLName("SA3") + " SA3 " + _LF
	_cQuery += "		 ON SA3.A3_FILIAL  = '" + xFilial("SA3") + "' " + _LF
	_cQuery += "		AND SA3.A3_COD     = SF2.F2_VEND1 " + _LF
	_cQuery += "		AND SA3.D_E_L_E_T_ = ' ' " + _LF
	//_cQuery += "	LEFT JOIN (	SELECT A.CODIGO, A.COD_COMP, SUM(A.QTD) QTD, A.DT_INI, A.DT_FIM " + _LF
	_cQuery += "	LEFT JOIN (	SELECT A.CODIGO, A.COD_COMP, SUM(A.QTD) QTD " + _LF
	_cQuery += "				FROM ESTRUT A " + _LF
	_cQuery += "				WHERE   (	SELECT COUNT(*) " + _LF
	_cQuery += "							FROM ESTRUT B " + _LF
	_cQuery += "							WHERE   B.CODIGO  = A.CODIGO " + _LF
	_cQuery += "								AND B.COD_PAI = A.COD_COMP) = 0 " + _LF
	//_cQuery += "				GROUP BY A.CODIGO, A.COD_COMP, A.DT_INI, A.DT_FIM) ESTR " + _LF
	_cQuery += "				GROUP BY A.CODIGO, A.COD_COMP) ESTR " + _LF
	_cQuery += "		 ON ESTR.CODIGO = SD2.D2_COD " + _LF
	
	//Inicio AlteraÁ„o Osmar
_cQuery += " Left Outer Join " + _LF
_cQuery += " (	Select D2_COD PAI, B1_COD CODIGO, D4_COD OPCIONAL, SUM(D4_QTDEORI-D4_QUANT) QTDEUSO " + _LF
_cQuery += "	From " + RetSQLName("SF2") + " SF2 With(Nolock) " + _LF
_cQuery += "	Inner Join SD2010 SD2 With(Nolock) On SD2.D_E_L_E_T_ = '' And D2_FILIAL = F2_FILIAL And " + _LF
_cQuery += "										  D2_DOC = F2_DOC And D2_SERIE = F2_SERIE And D2_TIPO = F2_TIPO And " + _LF
_cQuery += "										  D2_COD Between '" + mv_par09 + "' AND '" + mv_par10 + "' " + _LF
_cQuery += "	Inner Join " + RetSQLName("SC6") + " SC6 With(Nolock) On SC6.D_E_L_E_T_ = '' And C6_FILIAL = '" + xFilial("SC6") + "' And D2_COD = C6_PRODUTO And C6_NUM = D2_PEDIDO And C6_ITEM = D2_ITEMPV " + _LF
_cQuery += "	Inner Join " + RetSQLName("SD4") + " SD4 With(Nolock) On SD4.D_E_L_E_T_ = '' And D4_FILIAL = '" + xFilial("SD4") + "' And RTRIM(Left(D4_OP,6)) = C6_NUMOP And SubString(D4_OP,7,2) = C6_ITEMOP " + _LF
_cQuery += "	Inner Join " + RetSQLName("SB1") + " SB1 With(Nolock) On SB1.D_E_L_E_T_ = '' And B1_FILIAL = '" + xFilial("SB1") + "' And B1_ALTER = D4_COD " + _LF
_cQuery += "	Where SF2.D_E_L_E_T_ = '' And F2_FILIAL = '" + xFilial("SF2") + "' And " + _LF
_cQuery += "		  F2_EMISSAO Between '" + DToS(mv_par01) + "' And '" + DToS(mv_par02) + "' And " + _LF
_cQuery += "		  F2_CLIENTE Between '" + mv_par03 + "' And '" + mv_par05 + "' And " + _LF
_cQuery += "		  F2_LOJA    Between '" + mv_par04 + "' And '" + mv_par06 + "' And " + _LF
_cQuery += "		  F2_VEND1   Between '" + mv_par07 + "' And '" + mv_par08 + "' " + _LF
_cQuery += "	Group By D2_COD, B1_COD, D4_COD " + _LF
_cQuery += ") OPC " + _LF
_cQuery += " On OPC.PAI = ESTR.CODIGO And  OPC.CODIGO = ESTR.COD_COMP " + _LF
	//Fim AlteraÁ„o Osmar	
	
	_cQuery += "WHERE   SF2.F2_FILIAL  = '" + xFilial("SF2") + "' " + _LF
	_cQuery += "	AND SF2.F2_EMISSAO BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' " + _LF
	_cQuery += "	AND SF2.F2_CLIENTE BETWEEN '" + mv_par03 + "' AND '" + mv_par05 + "' " + _LF
	_cQuery += "	AND SF2.F2_LOJA    BETWEEN '" + mv_par04 + "' AND '" + mv_par06 + "' " + _LF
	_cQuery += "	AND SF2.F2_VEND1   BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + _LF
	//_cQuery += "	AND (ISNULL(ESTR.DT_INI,'')  = '' " + _LF
	//_cQuery += "	 OR  ISNULL(ESTR.DT_INI,'') <= SF2.F2_EMISSAO) " + _LF
	//_cQuery += "	AND (ISNULL(ESTR.DT_FIM,'')  = '' " + _LF
	//_cQuery += "	 OR  ISNULL(ESTR.DT_FIM,'') >= SF2.F2_EMISSAO) " + _LF
	_cQuery += "	AND ISNULL(ESTR.COD_COMP,SD2.D2_COD) BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "' " + _LF
	_cQuery += "	AND SF2.D_E_L_E_T_ = ' ' " + _LF
	_cQuery += "GROUP BY (CASE WHEN SA1.A1_CGC = ' ' THEN SA1.A1_COD ELSE LEFT(SA1.A1_CGC,8) END), SA1.A1_NREDUZ, SF2.F2_VEND1, ISNULL(SA3.A3_NREDUZ,''), " + _LF
	_cQuery += "			LEFT(SD2.D2_EMISSAO,6), ISNULL(ESTR.COD_COMP,SD2.D2_COD), ISNULL(ESTR.QTD,0), OPC.OPCIONAL "

	If lDebug
		AutoGrLog(_cQuery)
		MostraErro()
	EndIf

	TCQUERY _cQuery NEW ALIAS "tSD2"

	If nOrdem == 1 .Or. nOrdem == 2	// Por Cliente
		_cQuebra := "CNPJ"
	Else
		_cQuebra := "F2_VEND1"
	EndIf

	tSD2->(dbGoTop())

	SB1->( dbSetOrder(1) )

	//lAternativo := .f.
	//cAlternativo := ''


	While !tSD2->( Eof() )

		SB1->( dbSeek( xFilial() + tSD2->D2_COD ) )

		//Verifica se tem produto alternativo para o item
		//If !Empty(SB1->B1_ALTER)
		//	lAternativo := .t.
		//	cAlternativo := SB1->B1_ALTER
		//EndIf

		If !(Alltrim(SB1->B1_TIPO) $ mv_par13)
			tSD2->(dbSkip())
			Loop
		EndIf


		// Obtem o custo mÈdio do item
		_nCM := fCM1(tSD2->D2_COD, Posicione("SB1", 1, xFilial("SB1") + tSD2->D2_COD, "B1_LOCPAD"), tSD2->MESREF)

		// Obtem o custo mÈdio do item opcional
		If !Empty(tSD2->OPCIONAL)
		  _nCMopc := fCM1(tSD2->OPCIONAL, Posicione("SB1", 1, xFilial("SB1") + tSD2->OPCIONAL, "B1_LOCPAD"), tSD2->MESREF)
		Else
		  _nCMopc := 0  
		EndIf


		// Verifica se o cliente/vendedor j· est· no array
		_nPos := aScan(_aItens, {|x| x[1] == tSD2->&(_cQuebra)})

		If _nPos == 0
			If !Empty(tSD2->QTD_ESTR)
				//aAdd(_aItens, {tSD2->&(_cQuebra), 0, 0, tSD2->QTD * tSD2->QTD_ESTR, (tSD2->QTD * tSD2->QTD_ESTR) * _nCM, 0, 0, {}})
				aAdd(_aItens, {tSD2->&(_cQuebra), 0, 0, tSD2->QTD * tSD2->QTD_ESTR, (((tSD2->QTD * tSD2->QTD_ESTR) - tSD2->QTDEUSO) * _nCM) + (tSD2->QTDEUSO * _nCMopc), 0, 0, {}})
			else
		  	  //aAdd(_aItens, {tSD2->&(_cQuebra), 0, 0, tSD2->QTD    ,  tSD2->QTD  * _nCM , 0, 0, {}})
				aAdd(_aItens, {tSD2->&(_cQuebra), 0, 0, tSD2->QTD    ,  ((tSD2->QTD - tSD2->QTDEUSO)  * _nCM) + (tSD2->QTDEUSO * _nCMopc) , 0, 0, {}})
			EndIf
			_nPos := Len(_aItens)
		Else
			If !Empty(tSD2->QTD_ESTR)
				_aItens[_nPos][4] +=  tSD2->QTD * tSD2->QTD_ESTR
				//_aItens[_nPos][5] += (tSD2->QTD * tSD2->QTD_ESTR) * _nCM
				_aItens[_nPos][5] += (((tSD2->QTD * tSD2->QTD_ESTR) - tSD2->QTDEUSO) * _nCM) + (tSD2->QTDEUSO * _nCMopc) 
			else
				_aItens[_nPos][4] += tSD2->QTD
				//_aItens[_nPos][5] += tSD2->QTD * _nCM
				_aItens[_nPos][5] += ((tSD2->QTD - tSD2->QTDEUSO) * _nCM) + (tSD2->QTDEUSO * _nCMopc)
			EndIf

		EndIf

		// Verifica se o cliente + vendedor + produto j· est· no array
		_nPos2 := aScan(_aItens[_nPos][8], {|x| x[1] == tSD2->CNPJ .And. x[3] == tSD2->F2_VEND1 .And. x[5] == tSD2->D2_COD})

		If _nPos2 == 0
			If !Empty(tSD2->QTD_ESTR)
				//aAdd(_aItens[_nPos][8], {tSD2->CNPJ, tSD2->A1_NREDUZ, tSD2->F2_VEND1, tSD2->NOME_VEND, tSD2->D2_COD, 0, 0, tSD2->QTD * tSD2->QTD_ESTR, (tSD2->QTD * tSD2->QTD_ESTR) * _nCM , 0, 0})
				aAdd(_aItens[_nPos][8], {tSD2->CNPJ, tSD2->A1_NREDUZ, tSD2->F2_VEND1, tSD2->NOME_VEND, tSD2->D2_COD, 0, 0,tSD2->QTD * tSD2->QTD_ESTR, (((tSD2->QTD * tSD2->QTD_ESTR)-tSD2->QTDEUSO) * _nCM) + (tSD2->QTDEUSO * _nCMopc), 0, 0})
			else
				//aAdd(_aItens[_nPos][8], {tSD2->CNPJ, tSD2->A1_NREDUZ, tSD2->F2_VEND1, tSD2->NOME_VEND, tSD2->D2_COD, 0, 0, tSD2->QTD                 , tSD2->QTD                    * _nCM , 0, 0})
				aAdd(_aItens[_nPos][8], {tSD2->CNPJ, tSD2->A1_NREDUZ, tSD2->F2_VEND1, tSD2->NOME_VEND, tSD2->D2_COD, 0, 0, tSD2->QTD, ((tSD2->QTD - tSD2->QTDEUSO) * _nCM) + (tSD2->QTDEUSO * _nCMopc) , 0, 0})
			EndIf
		Else
			If !Empty(tSD2->QTD_ESTR)
				_aItens[_nPos][8][_nPos2][8] +=  tSD2->QTD * tSD2->QTD_ESTR
				//_aItens[_nPos][8][_nPos2][9] += (tSD2->QTD * tSD2->QTD_ESTR) * _nCM
				_aItens[_nPos][8][_nPos2][9] += (((tSD2->QTD * tSD2->QTD_ESTR) - tSD2->QTDEUSO) * _nCM) + (tSD2->QTDEUSO * _nCMopc)
			else
				_aItens[_nPos][8][_nPos2][8] += tSD2->QTD
				//_aItens[_nPos][8][_nPos2][9] += tSD2->QTD * _nCM
				_aItens[_nPos][8][_nPos2][9] += ((tSD2->QTD - tSD2->QTDEUSO) * _nCM) + (tSD2->QTDEUSO * _nCMopc)
			EndIf
		EndIf

		tSD2->(dbSkip())
	EndDo

	tSD2->(dbCloseArea())

	// Ajusta o array
	For _nI := 1 To Len(_aItens)
		_aItens[_nI][6] := 0
		_aItens[_nI][7] := 0

		For _nJ := 1 To Len(_aItens[_nI][8])
			_aItens[_nI][8][_nJ][10] := (_aItens[_nI][8][_nJ][6] - _aItens[_nI][8][_nJ][8])
			_aItens[_nI][8][_nJ][11] := (_aItens[_nI][8][_nJ][7] - _aItens[_nI][8][_nJ][9])
			_aItens[_nI][6] += Abs(_aItens[_nI][8][_nJ][10])
			_aItens[_nI][7] += Abs(_aItens[_nI][8][_nJ][11])
		Next

		If nOrdem == 1 .Or. nOrdem == 3	   // Por quantidade
			_aItens[_nI][8] := aSort(_aItens[_nI][8], , , {|x, y| Abs(x[10]) > Abs(y[10]) })
		Else											// Por valor
			_aItens[_nI][8] := aSort(_aItens[_nI][8], , , {|x, y| Abs(x[11]) > Abs(y[11]) })
		EndIf
	Next
	If nOrdem == 1 .Or. nOrdem == 3	// Por quantidade
		_aItens := aSort(_aItens, , , {|x, y| x[6] > y[6]})
	Else											// Por valor
		_aItens := aSort(_aItens, , , {|x, y| x[7] > y[7]})
	EndIf

	If nOrdem == 1			// Cliente e quantidade
		oBreak1 := TRBreak():New(oSection1, oSection1:Cell("C4_XXCNPJ"), "TOTAL", .F.)

		oReport:SetTitle(cTitulo + " - Por Cliente e Dif. Quant.")
	ElseIf nOrdem == 2	// Cliente e valor
		oBreak1 := TRBreak():New(oSection1, oSection1:Cell("C4_XXCNPJ"), "TOTAL", .F.)

		oReport:SetTitle(cTitulo + " - Por Cliente e Dif. Valor")
	ElseIf nOrdem == 3	// Vendedor e quantidade
		oBreak1 := TRBreak():New(oSection1, oSection1:Cell("A3_COD"), "TOTAL", .F.)

		oReport:SetTitle(cTitulo + " - Por Vendedor e Dif. Quant.")
	Else						// Vendedor e valor
		oBreak1 := TRBreak():New(oSection1, oSection1:Cell("A3_COD"), "TOTAL", .F.)

		oReport:SetTitle(cTitulo + " - Por Vendedor e Dif. Valor")
	EndIf

// Totalizadores
	TRFunction():New(oSection1:Cell("C4_XXQTDOR"), "", "SUM", oBreak1, , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("VLR_PREV"  ), "", "SUM", oBreak1, , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("D2_QUANT"  ), "", "SUM", oBreak1, , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("D2_TOTAL"  ), "", "SUM", oBreak1, , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("DIF_QTD"   ), "", "SUM", oBreak1, , "@E 999,999,999.99", , .F., .T.)
	TRFunction():New(oSection1:Cell("DIF_VLR"   ), "", "SUM", oBreak1, , "@E 999,999,999.99", , .F., .T.)

	oSection1:Init()

	oReport:SetMeter(Len(_aItens))
	//oReport:SetMeter(_nQtd)

	SB1->( dbSetOrder(1) )

	For _nI := 1 To Len(_aItens)
		For _nJ := 1 To Len(_aItens[_nI][8])
			If oReport:Cancel()
				Exit
			EndIf

			nPercentual := 0
			If Empty(_aItens[_nI][8][_nJ][06]) .or. Empty(_aItens[_nI][8][_nJ][08])
				nPercentual := 0
			Else
				If _aItens[_nI][8][_nJ][06] >= _aItens[_nI][8][_nJ][08]
					nPercentual := (_aItens[_nI][8][_nJ][08] / _aItens[_nI][8][_nJ][06]) * 100
				Else
					//nPercentual := 100 - (((_aItens[_nI][8][_nJ][08] - _aItens[_nI][8][_nJ][06]) / _aItens[_nI][8][_nJ][06]) * 100)
					nPercentual := (_aItens[_nI][8][_nJ][06] / _aItens[_nI][8][_nJ][08]) * 100
				EndIf
			EndIf

			If nPercentual < 0
				nPercentual := 0
			EndIf

			nPercentual := Int(nPercentual)

			SB1->( dbSeek( xFilial() + _aItens[_nI][8][_nJ][05] ) )

			oSection1:Cell("C4_XXCNPJ" ):SetValue(_aItens[_nI][8][_nJ][01])
			cNomeCli := _aItens[_nI][8][_nJ][02]
			cNomeCli := Subs(cNomeCli,1,At(' ',cNomeCli)-1)
			oSection1:Cell("A1_NREDUZ" ):SetValue(cNomeCli)
			oSection1:Cell("A3_COD"    ):SetValue(_aItens[_nI][8][_nJ][03])
			oSection1:Cell("A3_NREDUZ" ):SetValue(_aItens[_nI][8][_nJ][04])
			oSection1:Cell("C4_PRODUTO"):SetValue(_aItens[_nI][8][_nJ][05])
			oSection1:Cell("B1_DESC"   ):SetValue(SB1->B1_DESC)
			oSection1:Cell("C4_XXQTDOR"):SetValue(_aItens[_nI][8][_nJ][06])
			oSection1:Cell("VLR_PREV"  ):SetValue(_aItens[_nI][8][_nJ][07])
			oSection1:Cell("D2_QUANT"  ):SetValue(_aItens[_nI][8][_nJ][08])
			oSection1:Cell("D2_TOTAL"  ):SetValue(_aItens[_nI][8][_nJ][09])
			oSection1:Cell("DIF_QTD"   ):SetValue(_aItens[_nI][8][_nJ][10])
			oSection1:Cell("DIF_VLR"   ):SetValue(_aItens[_nI][8][_nJ][11])
			oSection1:Cell("PERCENTUAL"):SetValue(nPercentual)
			oSection1:Cell("B1_ORIGEM" ):SetValue(SB1->B1_ORIGEM)

			oSection1:PrintLine()

			oReport:SkipLine()
		Next

		oReport:IncMeter()

	Next

	oSection1:Finish()
	oReport:EndPage()

Return


Static Function fCM1(_cProd, _cLocal, _cMesRef)

	//Local _dData
	Local _nRet
	Local _dAberto := GetMv("MV_ULMES") + 1

	SB2->(dbSetOrder(1))	// Filial + Produto + Armazem
	SB9->(dbSetOrder(1))	// Filial + Produto + Armazem + Data

	If _cMesRef >= Left(DToS(_dAberto), 6)
		SB2->(dbSeek(xFilial("SB2") + _cProd + _cLocal))
		_nRet := SB2->B2_CM1
	Else
		If SB9->(dbSeek(xFilial("SB9") + _cProd + _cLocal + _cMesRef))
			_nRet := SB9->B9_CM1
		Else
			_nRet := 0
		EndIf
	EndIf

Return(_nRet)
