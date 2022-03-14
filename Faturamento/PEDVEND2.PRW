#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PEDVEND2 ºAutor  ³Marco Aurelio       º Data ³  22/05/19    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºProg.ORI  ³PEDVEND  ºAutor  ³Helio Ferreira      º Data ³  18/08/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adequacao do Relatorio para usar tabela SZY                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PEDVEND2()
	Private cPerg  := "PEDVEND"
	Private oReport
	Private cFilterUser
	Private oSection1
	Private oFont , oFontN
	Private cTitulo
	Private nReg := 0

	If Pergunte(cPerg,.T.)
		oReport:=ReportDef()
		oReport:PrintDialog()
	EndIf

Return


Static Function ReportDef()

	Local oSection1

	cTitulo:= "Acompanhamento de OR (Ordem de Revenda)"
	oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
	oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

	oReport   :=TReport():New("PEDVEND2",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relatório exibirá XXX.")

	oReport:SetLandScape()

	oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

	TRCell():New(oSection1,"C5_EMISSAO"     ,,"DT Emissao"            , ,008,.F.,)
	TRCell():New(oSection1,"C5_XPVTIPO"     ,,"Tipo PV"               , ,008,.F.,)
	TRCell():New(oSection1,"C5_NUM"         ,,"Numero OF"             , ,006,.F.,)
	TRCell():New(oSection1,"A1_NREDUZ"      ,,"Cliente"               , ,030,.F.,)
	TRCell():New(oSection1,"C6_ITEM"        ,,"Item OF"               , ,002,.F.,)
	TRCell():New(oSection1,"C6_PRODUTO"     ,,"RDT PN"                , ,015,.F.,)
	TRCell():New(oSection1,"C6_SEUCOD"      ,,"Cliente PN"            , ,020,.F.,)
	TRCell():New(oSection1,"C6_DESCRI"      ,,"Descrição"             , ,060,.F.,)
	TRCell():New(oSection1,"QTD"            ,,"Quantidade"            , ,012,.F.,)
	TRCell():New(oSection1,"C6_ENTREG"      ,,"Dt.Cliente"     			, ,008,.F.,)
	TRCell():New(oSection1,"ZY_PRVFAT"      ,,"Dt.Prev.Fatu"          , ,008,.F.,)
	TRCell():New(oSection1,"B2_QATU"        ,,"Saldo Atual"           , ,010,.F.,)
	TRCell():New(oSection1,"C5_ESP1"        ,,"Espec.Client."         , ,010,.F.,)

	oSection1:Cell("QTD")  :SetPicture("@E 99,999.9999")

// Totalizadores
//oBreak1 := TRBreak():New(oSection1,oSection1:Cell("C5_EMISSAO"),"TOTAL REGISTROS"          ,.F.)
	TRFunction():New(oSection1:Cell("C5_EMISSAO"),"TOTAL dias"     ,"COUNT"	,,,"@E 999,999"			,,.T.,.F.)


	oSection1:SetHeaderPage(.T.)


Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
	Local oSection1 := oReport:Section(1)
//Local nOrdem    := oSection1:GetOrder()
	Local _cAlias   := GetNextAlias()
	Local _cOrder   := "%C6_NUM,C6_ITEM,C6_PRODUTO%"
	Local _mv_par01 := "%'"+DtoS(mv_par01)+"'%"
	Local _mv_par02 := "%'"+DtoS(mv_par02)+"'%"
//Local _mv_par03 := "%'"+DtoS(mv_par03)+"'%"
//Local _mv_par04 := "%'"+DtoS(mv_par04)+"'%"
	Local _mv_par05 := "%'"+mv_par05+"'%"
	Local _mv_par06 := "%'"+mv_par06+"'%"


	If mv_par07 == 1
		BeginSql Alias _cAlias
		SELECT C5_EMISSAO, C5_NUM, A1_NREDUZ, C6_ITEM, C6_PRODUTO, C6_SEUCOD, C6_DESCRI, C6_QTDVEN, C6_QTDENT, C6_ENTREG, C6_ENTRE3, ZY_PRVFAT, ZY_DTPCP, B2_QATU, C5_ESP1, ZY_QUANT
		FROM 	%table:SC5% SC5 (NOLOCK), 
				%table:SA1% SA1 (NOLOCK),
				%table:SC6% SC6 (NOLOCK)
						LEFT JOIN SZY010 SZY ON C6_NUM+C6_ITEM=ZY_PEDIDO+ZY_ITEM, 
				%table:SB2% SB2 (NOLOCK), 
				%table:SB1% SB1 (NOLOCK)
	
		WHERE SC5.%notDel% AND SC6.%notDel% AND SA1.%notDel% AND SB2.%notDel% AND SB1.%notDel% AND SZY.%notDel%
		AND C5_EMISSAO >= %Exp:_mv_par01% AND C5_EMISSAO <= %Exp:_mv_par02%
		AND C5_NUM     >= %Exp:_mv_par05% AND C5_NUM     <= %Exp:_mv_par06%
		AND (B1_TIPO = 'PR' OR B1_TIPO ='MP')
		AND C6_QTDVEN <> C6_QTDENT
		AND C5_XPVTIPO IN ('OF')
		AND C5_NUM = C6_NUM
		AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA
		AND C6_PRODUTO = B2_COD AND C6_LOCAL = B2_LOCAL
		AND C6_PRODUTO = B1_COD         
		AND ZY_NOTA = ''  
		AND ZY_BLQ <> 'R'
		AND C5_FILIAL = %xFilial:SC5% 
		AND A1_FILIAL = %xFilial:SA1% 
		AND C6_FILIAL = %xFilial:SC6% 
		AND B2_FILIAL = %xFilial:SB2% 
		AND B1_FILIAL = %xFilial:SB1% 
		AND ZY_FILIAL = %xFilial:SZY% 	
		ORDER BY %Exp:_cOrder%
		EndSql
	EndIf
	If mv_par07 == 2
		xTipoPV := "('SR')"
		BeginSql Alias _cAlias
		SELECT C5_EMISSAO, C5_NUM, A1_NREDUZ, C6_ITEM, C6_PRODUTO, C6_SEUCOD, C6_DESCRI, C6_QTDVEN, C6_QTDENT, C6_ENTREG, C6_ENTRE3, ZY_PRVFAT, ZY_DTPCP, B2_QATU, C5_ESP1, ZY_QUANT
		FROM 	%table:SC5% SC5 (NOLOCK), 
				%table:SA1% SA1 (NOLOCK),
				%table:SC6% SC6 (NOLOCK)
						LEFT JOIN SZY010 SZY ON C6_NUM+C6_ITEM=ZY_PEDIDO+ZY_ITEM, 
				%table:SB2% SB2 (NOLOCK), 
				%table:SB1% SB1 (NOLOCK)
	
		WHERE SC5.%notDel% AND SC6.%notDel% AND SA1.%notDel% AND SB2.%notDel% AND SB1.%notDel% AND SZY.%notDel%
		AND C5_EMISSAO >= %Exp:_mv_par01% AND C5_EMISSAO <= %Exp:_mv_par02%
		AND C5_NUM     >= %Exp:_mv_par05% AND C5_NUM     <= %Exp:_mv_par06%
		AND (B1_TIPO = 'PR' OR B1_TIPO ='MP')
		AND C6_QTDVEN <> C6_QTDENT
		AND C5_XPVTIPO IN ('SR')
		AND C5_NUM = C6_NUM
		AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA
		AND C6_PRODUTO = B2_COD AND C6_LOCAL = B2_LOCAL
		AND C6_PRODUTO = B1_COD         
		AND ZY_NOTA = ''  
		AND ZY_BLQ <> 'R'
		AND C5_FILIAL = %xFilial:SC5% 
		AND A1_FILIAL = %xFilial:SA1% 
		AND C6_FILIAL = %xFilial:SC6% 
		AND B2_FILIAL = %xFilial:SB2% 
		AND B1_FILIAL = %xFilial:SB1% 
		AND ZY_FILIAL = %xFilial:SZY% 	
		ORDER BY %Exp:_cOrder%
		EndSql
	ENDIF
	If mv_par07 == 3
		BeginSql Alias _cAlias
		SELECT C5_EMISSAO, C5_NUM, A1_NREDUZ, C6_ITEM, C6_PRODUTO, C6_SEUCOD, C6_DESCRI, C6_QTDVEN, C6_QTDENT, C6_ENTREG, C6_ENTRE3, ZY_PRVFAT, ZY_DTPCP, B2_QATU, C5_ESP1, ZY_QUANT
		FROM 	%table:SC5% SC5 (NOLOCK), 
				%table:SA1% SA1 (NOLOCK),
				%table:SC6% SC6 (NOLOCK)
						LEFT JOIN SZY010 SZY ON C6_NUM+C6_ITEM=ZY_PEDIDO+ZY_ITEM, 
				%table:SB2% SB2 (NOLOCK), 
				%table:SB1% SB1 (NOLOCK)
	
		WHERE SC5.%notDel% AND SC6.%notDel% AND SA1.%notDel% AND SB2.%notDel% AND SB1.%notDel% AND SZY.%notDel%
		AND C5_EMISSAO >= %Exp:_mv_par01% AND C5_EMISSAO <= %Exp:_mv_par02%
		AND C5_NUM     >= %Exp:_mv_par05% AND C5_NUM     <= %Exp:_mv_par06%
		AND (B1_TIPO = 'PR' OR B1_TIPO ='MP')
		AND C6_QTDVEN <> C6_QTDENT
		AND C5_XPVTIPO IN ('OF','SR')
		AND C5_NUM = C6_NUM
		AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA
		AND C6_PRODUTO = B2_COD AND C6_LOCAL = B2_LOCAL
		AND C6_PRODUTO = B1_COD         
		AND ZY_NOTA = ''  
		AND ZY_BLQ <> 'R'
		AND C5_FILIAL = %xFilial:SC5% 
		AND A1_FILIAL = %xFilial:SA1% 
		AND C6_FILIAL = %xFilial:SC6% 
		AND B2_FILIAL = %xFilial:SB2% 
		AND B1_FILIAL = %xFilial:SB1% 
		AND ZY_FILIAL = %xFilial:SZY% 	
		ORDER BY %Exp:_cOrder%
		EndSql
	ENDIF

	oReport:SetTitle(cTitulo)

	TcSetField(_cAlias,"C5_EMISSAO"   ,"D",  8, 0)
	TcSetField(_cAlias,"C6_ENTREG"    ,"D",  8, 0)
	TcSetField(_cAlias,"ZY_PRVFAT"    ,"D",  8, 0)

	oSection1:EndQuery()

	oSection1:Init()


	dbSelectArea(_cAlias)

	(_cAlias)->( dbEval({||nReg++}) )
	oReport:SetMeter(nReg)

	(_cAlias)->(dbGoTop())

	While !oReport:Cancel() .And. (_cAlias)->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf

		oSection1:Cell("C5_EMISSAO"):SetValue((_cAlias)->C5_EMISSAO)
		oSection1:Cell("C5_XPVTIPO"):SetValue((_cAlias)->C5_XPVTIPO)
		oSection1:Cell("C5_NUM")    :SetValue((_cAlias)->C5_NUM    )
		oSection1:Cell("A1_NREDUZ") :SetValue((_cAlias)->A1_NREDUZ )
		oSection1:Cell("C6_ITEM")   :SetValue((_cAlias)->C6_ITEM   )
		oSection1:Cell("C6_PRODUTO"):SetValue((_cAlias)->C6_PRODUTO)
		oSection1:Cell("C6_SEUCOD") :SetValue((_cAlias)->C6_SEUCOD )
		oSection1:Cell("C6_DESCRI") :SetValue((_cAlias)->C6_DESCRI )
		//oSection1:Cell("QTD")     :SetValue((_cAlias)->C6_QTDVEN-(_cAlias)->C6_QTDENT)
		oSection1:Cell("QTD")       :SetValue((_cAlias)->ZY_QUANT  )
		oSection1:Cell("C6_ENTREG") :SetValue((_cAlias)->C6_ENTREG )
		oSection1:Cell("ZY_PRVFAT") :SetValue((_cAlias)->ZY_PRVFAT )
		oSection1:Cell("B2_QATU")   :SetValue((_cAlias)->B2_QATU   )
		oSection1:Cell("C5_ESP1")   :SetValue((_cAlias)->C5_ESP1   )

		oSection1:PrintLine()

		dbSelectArea(_cAlias)
		dbSkip()
		oReport:IncMeter()
		oReport:SkipLine()
	EndDo
	oSection1:Finish()
	oReport:EndPage()

Return
