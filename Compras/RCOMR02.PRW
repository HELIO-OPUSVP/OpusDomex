#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR02  ºAutor  ³Helio Ferreira      º Data ³  02/12/19    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Entrada de Materias por NFE                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rosenberger                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOMR02()
	Private cPerg  := "RCOMR02"
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

	Local oSection1, aOrdem

	aOrdem := {}
	AADD( aOrdem, "Por data" )

	cTitulo:= "Recebimento de compras Rosenberger"
	oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
	oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

	oReport   :=TReport():New("RCOMR02",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relatório exibirá XXX.")

	oReport:SetLandScape()
//oSection1 := TRSection():New(oReport,STR0062,{"SC7","SA2","SB1"},aOrdem)
	oSection1:=  TRSection():New(oReport,""     ,"SD1"              ,aOrdem,.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

	TRCell():New(oSection1,"D1_FORNECE"       ,,"Fornecedor"       , ,006,.F.,)
	TRCell():New(oSection1,"D1_LOJA"          ,,"Loja"             , ,002,.F.,)
	TRCell():New(oSection1,"A2_NREDUZ"        ,,"N.Fantasia"       , ,050,.F.,)
	TRCell():New(oSection1,"D1_COD"           ,,"Produto"          , ,015,.F.,)
	TRCell():New(oSection1,"B1_DESC"          ,,"Descrição"        , ,060,.F.,)
	TRCell():New(oSection1,"D1_UM"            ,,"UM"               , ,002,.F.,)
	TRCell():New(oSection1,"D1_QUANT"         ,,"Quantidade"       , ,015,.F.,)
	TRCell():New(oSection1,"D1_VUNIT"         ,,"Valor Unit."      , ,012,.F.,)
	TRCell():New(oSection1,"D1_TOTAL"         ,,"Valor Total"      , ,012,.F.,)
	TRCell():New(oSection1,"CUSTOUNIT"        ,,"Custo Unitário"   , ,012,.F.,)
	TRCell():New(oSection1,"D1_CUSTO"         ,,"Custo Total"      , ,012,.F.,)
	TRCell():New(oSection1,"D1_CF"            ,,"CFOP"             , ,005,.F.,)
	TRCell():New(oSection1,"X5_DESCRI"        ,,"Desc.CFOP"        , ,060,.F.,)
	TRCell():New(oSection1,"D1_TES"           ,,"TES"              , ,005,.F.,)
	TRCell():New(oSection1,"D1_PEDIDO"        ,,"Pedido"           , ,006,.F.,)
	TRCell():New(oSection1,"D1_ITEMPC"        ,,"Item PC"          , ,004,.F.,)
	TRCell():New(oSection1,"D1_DOC"           ,,"Documento"        , ,009,.F.,)
	TRCell():New(oSection1,"D1_EMISSAO"       ,,"Emissão"          , ,008,.F.,)
	TRCell():New(oSection1,"D1_DTDIGIT"       ,,"Data"             , ,008,.F.,)
	TRCell():New(oSection1,"B1_GRUPO"         ,,"Grupo Prod."      , ,004,.F.,)
	TRCell():New(oSection1,"D1_TIPO"          ,,"Tipo NF"          , ,001,.F.,)
	TRCell():New(oSection1,"D1_SERIE"         ,,"Serie"            , ,003,.F.,)
	TRCell():New(oSection1,"B1_TIPO"          ,,"Tipo Prod."       , ,002,.F.,)
	TRCell():New(oSection1,"F4_DUPLIC"        ,,"Financeiro"       , ,005,.F.,)
	TRCell():New(oSection1,"TRANSPORTA"       ,,"Transportadora"   , ,003,.F.,)
	TRCell():New(oSection1,"B1_SUBCLAS"       ,,"Sub Classe Prod"  , ,004,.F.,)

	oSection1:Cell("D1_QUANT")  :SetPicture("@E 9,999,999.9999")
	oSection1:Cell("D1_VUNIT")  :SetPicture("@E 9,999,999.99")
	oSection1:Cell("D1_TOTAL")  :SetPicture("@E 9,999,999.99")
	oSection1:Cell("D1_CUSTO")  :SetPicture("@E 9,999,999.99")
	oSection1:Cell("CUSTOUNIT") :SetPicture("@E 9,999,999.9999")
	oSection1:Cell("D1_CF")     :SetPicture("@R 9.999")

// Totalizadores
//oBreak1 := TRBreak():New(oSection1,oSection1:Cell("ZC_EXPEDIC"),"TOTAL DIA"          ,.F.)
//TRFunction():New(oSection1:Cell("B9_TOTAL"),""                 ,"SUM",oBreak1,,"@E 999,999,999,999.99",,.F.,.T.)

	oSection1:SetHeaderPage(.T.)

/*
oSection1:Cell("C4_PRODUTO"):SetHeaderAlign("LEFT")
oSection1:Cell("C4_PRODUTO"):SetAlign("LEFT")
oSection1:Cell("C4_PRODUTO"):SetSize(15)

oSection1:Cell("C4_DATA"):SetHeaderAlign("RIGHT")
oSection1:Cell("C4_DATA"):SetAlign("RIGHT")
oSection1:Cell("C4_DATA"):SetSize(8)

oSection1:Cell("C4_QUANT"):SetHeaderAlign("RIGHT")
oSection1:Cell("C4_QUANT"):SetAlign("RIGHT")
oSection1:Cell("C4_QUANT"):SetSize(15)
*/

Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
	Local oSection1 := oReport:Section(1)
	Local nOrdem    := oSection1:GetOrder()
	Local _cAlias   := GetNextAlias()
	Local _cOrder   := "%D1_DTDIGIT%"

	If nOrdem == 1
		_cOrder   := "%D1_DTDIGIT%"
		//_cOrder   := "D1_DTDIGIT"
	EndIf

	oReport:SetTitle(cTitulo)


	BeginSql Alias _cAlias
		SELECT  D1_FORNECE, D1_LOJA, A2_NREDUZ, D1_COD, B1_DESC, D1_UM, D1_QUANT, D1_VUNIT, D1_TOTAL, D1_CUSTO, D1_CF, D1_TES, D1_PEDIDO, D1_ITEMPC,
		D1_DOC, D1_EMISSAO, D1_DTDIGIT, B1_GRUPO, D1_TIPO, D1_SERIE, B1_TIPO, F4_DUPLIC, B1_SUBCLAS
		,(SELECT TOP 1 X5_DESCRI FROM %table:SX5% SX5 WHERE D1_CF = X5_CHAVE AND X5_FILIAL = '01' AND X5_TABELA = '13' AND SX5.%notDel% ) AS X5_DESCRI
		,ISNULL((SELECT TOP 1 A4_CGC FROM %table:SA4% SA4 WHERE A4_CGC = A2_CGC AND SA4.%notDel%),'') AS TRANSPORTA
		FROM %table:SD1% SD1, %table:SA2% SA2, %table:SB1% SB1, %table:SF4% SF4
		WHERE SD1.%notDel% AND SB1.%notDel% AND SA2.%notDel% AND SF4.%notDel%
		AND D1_COD = B1_COD AND D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA
		AND D1_TES = F4_CODIGO 
		AND D1_DTDIGIT >= %Exp:mv_par01%
		AND D1_DTDIGIT <= %Exp:mv_par02%
		AND D1_TIPO NOT IN ('D','B')
		AND D1_FILIAL  = %xFilial:SD1%
		AND B1_FILIAL  = %xFilial:SB1%
		AND A2_FILIAL  = %xFilial:SA2%
		AND F4_FILIAL  = %xFilial:SF4%
		ORDER BY %Exp:_cOrder%
	EndSql

/*
cQuery := "SELECT  D1_FORNECE, D1_LOJA, A2_NREDUZ, D1_COD, B1_DESC, D1_UM, D1_QUANT, D1_VUNIT, D1_TOTAL, D1_CUSTO, D1_CF, X5_DESCRI, D1_TES, D1_PEDIDO, D1_ITEMPC, "
cQuery += "D1_DOC, D1_EMISSAO, D1_DTDIGIT, B1_GRUPO, D1_TIPO, D1_SERIE, B1_TIPO, F4_DUPLIC, B1_SUBCLAS "
cQuery += ",ISNULL((SELECT TOP 1 A4_CGC FROM %table:SA4% SA4 WHERE A4_CGC = A2_CGC AND SA4.%notDel%),'') AS TRANSPORTA "
cQuery += "FROM " +RetTableName("SD1")+ ", "+RetTableName("SA2")+", "+RetTableName("SB1")+" , "+RetTableName("SF4")+" , "+RetTableName("SX5")+" "
cQuery += "WHERE SD1.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND SA2.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' "
cQuery += "AND D1_COD = B1_COD AND D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
cQuery += "AND D1_TES = F4_CODIGO AND F4_CF = X5_CHAVE AND X5_FILIAL = '01' AND X5_TABELA = '13' "
cQuery += "AND D1_DTDIGIT >= '"+ DtoS(mv_par01) +"'"
cQuery += "AND D1_DTDIGIT <= '"+ DtoS(mv_par02) +"'"
cQuery += "ORDER BY " + _cOrder
*/

	TcSetField(_cAlias,"D1_DTDIGIT"   ,"D",  8, 0)
	TcSetField(_cAlias,"D1_EMISSAO"   ,"D",  8, 0)

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

		If !Empty(mv_par03)
			If !(Subs((_cAlias)->D1_CF,2,3) $ mv_par03)
				dbSelectArea(_cAlias)
				dbSkip()
				oReport:IncMeter()
				Loop
			EndIf
		EndIf

		If !Empty(mv_par04)
			If Subs((_cAlias)->D1_CF,2,3) $ mv_par04
				dbSelectArea(_cAlias)
				dbSkip()
				oReport:IncMeter()
				Loop
			EndIf
		ENDIF

		oSection1:Cell("D1_FORNECE"):SetValue((_cAlias)->D1_FORNECE                      )
		oSection1:Cell("D1_LOJA")   :SetValue((_cAlias)->D1_LOJA                         )
		oSection1:Cell("A2_NREDUZ") :SetValue((_cAlias)->A2_NREDUZ                       )
		oSection1:Cell("D1_COD")    :SetValue((_cAlias)->D1_COD                          )
		oSection1:Cell("B1_DESC")   :SetValue((_cAlias)->B1_DESC                         )
		oSection1:Cell("D1_UM"   )  :SetValue((_cAlias)->D1_UM                           )
		oSection1:Cell("D1_QUANT")  :SetValue((_cAlias)->D1_QUANT                        )
		oSection1:Cell("D1_VUNIT")  :SetValue((_cAlias)->D1_VUNIT                        )
		oSection1:Cell("D1_TOTAL")  :SetValue((_cAlias)->D1_TOTAL                        )
		oSection1:Cell("D1_CUSTO")  :SetValue((_cAlias)->D1_CUSTO                        )
		oSection1:Cell("CUSTOUNIT") :SetValue((_cAlias)->D1_CUSTO / (_cAlias)->D1_QUANT  )
		oSection1:Cell("D1_CF")     :SetValue((_cAlias)->D1_CF                           )
		oSection1:Cell("X5_DESCRI") :SetValue((_cAlias)->X5_DESCRI                       )
		oSection1:Cell("D1_TES")    :SetValue((_cAlias)->D1_TES                          )
		oSection1:Cell("D1_PEDIDO") :SetValue((_cAlias)->D1_PEDIDO                       )
		oSection1:Cell("D1_ITEMPC") :SetValue((_cAlias)->D1_ITEMPC                       )
		oSection1:Cell("D1_DOC")    :SetValue((_cAlias)->D1_DOC                          )
		oSection1:Cell("D1_EMISSAO"):SetValue((_cAlias)->D1_EMISSAO                      )
		oSection1:Cell("D1_DTDIGIT"):SetValue((_cAlias)->D1_DTDIGIT                      )
		oSection1:Cell("B1_GRUPO")  :SetValue((_cAlias)->B1_GRUPO                        )
		oSection1:Cell("D1_TIPO")   :SetValue((_cAlias)->D1_TIPO                         )
		oSection1:Cell("D1_SERIE")  :SetValue((_cAlias)->D1_SERIE                        )
		oSection1:Cell("B1_TIPO")   :SetValue((_cAlias)->B1_TIPO                         )
		oSection1:Cell("F4_DUPLIC") :SetValue(If((_cAlias)->F4_DUPLIC=='S','Sim','Não')  )
		oSection1:Cell("TRANSPORTA"):SetValue(If(Empty((_cAlias)->TRANSPORTA),'Não','Sim'))
		oSection1:Cell("B1_SUBCLAS"):SetValue((_cAlias)->B1_SUBCLAS                      )

		oSection1:PrintLine()

		dbSelectArea(_cAlias)
		dbSkip()
		oReport:IncMeter()
		oReport:SkipLine()
	EndDo
	oSection1:Finish()
	oReport:EndPage()

Return
