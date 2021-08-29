//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 07/08/13                                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//                                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório apontamento de perda                                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMPCP01()
	Private _cPerg :="DOMPCP01"+Space(02)
	Private oReport
	Private cFilterUser
	Private oSection1
	Private oFont , oFontN
	Private cTitulo

	fCriaPerg()
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

	cTitulo:= ""
	oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito
	oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

	oReport   :=TReport():New("DOMPCP01",cTitulo,""/*_cPerg*/,{|oReport| ReportPrint(oReport)},"Este relatório exibirá os apontamentos de perda da produção.")

	oReport:SetLandScape()

	oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

	TRCell():New(oSection1,"ZA_DOCUMEN"       ,,"Documento"            , ,006,.F.,)
	TRCell():New(oSection1,"ZA_DATA"          ,,"Data"                 , ,010,.F.,)
	TRCell():New(oSection1,"ZA_OP"            ,,"OP"                   , ,011,.F.,)
	TRCell():New(oSection1,"ZA_PRODUTO"       ,,"Produto"              , ,015,.F.,)
	TRCell():New(oSection1,"ZA_DESC"          ,,"Descrição Produto"    , ,030,.F.,)
	TRCell():New(oSection1,"ZA_MOTIVO"        ,,"Motivo"               , ,006,.F.,)
	TRCell():New(oSection1,"ZA_DESCPER"       ,,"Descrição Perda"      , ,020,.F.,)
	TRCell():New(oSection1,"ZA_OPERADO"       ,,"Operador"             , ,015,.F.,)
	TRCell():New(oSection1,"ZA_QTDORI"        ,,"Qtd Perda"            , ,008,.F.,)
	TRCell():New(oSection1,"ZA_SALDO"         ,,"Saldo Pagamento"      , ,008,.F.,)
	TRCell():New(oSection1,"ZA_RECURSO"       ,,"Recurso"      		   , ,008,.F.,)

	If SZA->( FieldPos("ZA_USUARIO") ) > 0
		TRCell():New(oSection1,"ZA_USUARIO"    ,,"Usuario"              , ,014,.F.,)
	EndIf

	oSection1:SetHeaderPage()

	oSection1:Cell("ZA_DOCUMEN"):SetHeaderAlign("LEFT")
	oSection1:Cell("ZA_DOCUMEN"):SetAlign("LEFT")
	oSection1:Cell("ZA_DOCUMEN"):SetSize(06)

	oSection1:Cell("ZA_DATA"):SetHeaderAlign("RIGHT")
	oSection1:Cell("ZA_DATA"):SetAlign("RIGHT")
	oSection1:Cell("ZA_DATA"):SetSize(10)

	oSection1:Cell("ZA_OP"):SetHeaderAlign("LEFT")
	oSection1:Cell("ZA_OP"):SetAlign("LEFT")
	oSection1:Cell("ZA_OP"):SetSize(11)

	oSection1:Cell("ZA_PRODUTO"):SetHeaderAlign("LEFT" )
	oSection1:Cell("ZA_PRODUTO"):SetAlign("LEFT" )
	oSection1:Cell("ZA_PRODUTO"):SetSize(15)

	oSection1:Cell("ZA_DESC"):SetHeaderAlign("LEFT" )
	oSection1:Cell("ZA_DESC"):SetAlign("LEFT" )
	oSection1:Cell("ZA_DESC"):SetSize(30)

	oSection1:Cell("ZA_MOTIVO"):SetHeaderAlign("LEFT" )
	oSection1:Cell("ZA_MOTIVO"):SetAlign("LEFT" )
	oSection1:Cell("ZA_MOTIVO"):SetSize(06)

	oSection1:Cell("ZA_DESCPER"):SetHeaderAlign("LEFT")
	oSection1:Cell("ZA_DESCPER"):SetAlign("LEFT")
	oSection1:Cell("ZA_DESCPER"):SetSize(20)

	oSection1:Cell("ZA_OPERADO"):SetHeaderAlign("LEFT")
	oSection1:Cell("ZA_OPERADO"):SetAlign("LEFT")
	oSection1:Cell("ZA_OPERADO"):SetSize(20)

	oSection1:Cell("ZA_QTDORI"):SetHeaderAlign("RIGHT")
	oSection1:Cell("ZA_QTDORI"):SetAlign("RIGHT")
	oSection1:Cell("ZA_QTDORI"):SetSize(08)
	oSection1:Cell("ZA_QTDORI"):SetPicture("@E 9999,999",08)

	oSection1:Cell("ZA_SALDO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("ZA_SALDO"):SetAlign("RIGHT")
	oSection1:Cell("ZA_SALDO"):SetSize(08)
	oSection1:Cell("ZA_SALDO"):SetPicture("@E 9999,999",08)


	oSection1:Cell("ZA_RECURSO"):SetHeaderAlign("LEFT")
	oSection1:Cell("ZA_RECURSO"):SetAlign("LEFT")
	oSection1:Cell("ZA_RECURSO"):SetSize(10)

	If SZA->( FieldPos("ZA_USUARIO") ) > 0
		oSection1:Cell("ZA_USUARIO"):SetHeaderAlign("RIGHT")
		oSection1:Cell("ZA_USUARIO"):SetAlign("RIGHT")
		oSection1:Cell("ZA_USUARIO"):SetSize(14)
		oSection1:Cell("ZA_USUARIO"):SetPicture("@R",14)
	EndIf

Return oReport

//---------------------------------------------------------

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local nOrdem    := oSection1:GetOrder()
	Local _cAlias   := GetNextAlias()
	Local _cOrder   := "%ZA_OP,ZA_PRODUTO%"

	oReport:SetTitle(cTitulo)


	If SZA->( FieldPos("ZA_USUARIO") ) > 0

		If U_VALIDACAO() .or. .T.//Roda 30/07/2021
			BeginSql Alias _cAlias
			SELECT  ZA_DOCUMEN,ZA_DATA,ZA_OP,ZA_PRODUTO,ZA_DESC,ZA_MOTIVO,ZA_DESCPER,ZA_OPERADO,ZA_SALDO,ZA_QTDORI,ZA_USUARIO,ZA_RECURSO
			FROM %table:SZA% SZA
			WHERE SZA.%notDel%
			AND ZA_DATA >= %Exp:mv_par01%
			AND ZA_DATA <= %Exp:mv_par02%
			AND ZA_OP >= %Exp:mv_par03%
			AND ZA_OP <= %Exp:mv_par04%
			AND ZA_PRODUTO >= %Exp:mv_par05%
			AND ZA_PRODUTO <= %Exp:mv_par06%
			AND ZA_FILIAL = %Exp:xFilial("SZA")%
			ORDER BY %Exp:_cOrder%
			EndSql
		Else
			BeginSql Alias _cAlias
			SELECT  ZA_DOCUMEN,ZA_DATA,ZA_OP,ZA_PRODUTO,ZA_DESC,ZA_MOTIVO,ZA_DESCPER,ZA_OPERADO,ZA_SALDO,ZA_QTDORI,ZA_USUARIO,ZA_RECURSO
			FROM %table:SZA% SZA
			WHERE SZA.%notDel%
			AND ZA_DATA >= %Exp:mv_par01%
			AND ZA_DATA <= %Exp:mv_par02%
			AND ZA_OP >= %Exp:mv_par03%
			AND ZA_OP <= %Exp:mv_par04%
			AND ZA_PRODUTO >= %Exp:mv_par05%
			AND ZA_PRODUTO <= %Exp:mv_par06%
			ORDER BY %Exp:_cOrder%
			EndSql
		Endif

	Else
		If U_VALIDACAO() .OR. .T.//Roda 30/07/2021
			BeginSql Alias _cAlias
			SELECT  ZA_DOCUMEN,ZA_DATA,ZA_OP,ZA_PRODUTO,ZA_DESC,ZA_MOTIVO,ZA_DESCPER,ZA_OPERADO,ZA_SALDO,ZA_QTDORI,ZA_RECURSO
			FROM %table:SZA% SZA
			WHERE SZA.%notDel%
			AND ZA_DATA >= %Exp:mv_par01%
			AND ZA_DATA <= %Exp:mv_par02%
			AND ZA_OP >= %Exp:mv_par03%
			AND ZA_OP <= %Exp:mv_par04%
			AND ZA_PRODUTO >= %Exp:mv_par05%
			AND ZA_PRODUTO <= %Exp:mv_par06%
			AND ZA_FILIAL = %Exp:xFilial("SZA")%
			ORDER BY %Exp:_cOrder%
			EndSql
		else
			BeginSql Alias _cAlias
			SELECT  ZA_DOCUMEN,ZA_DATA,ZA_OP,ZA_PRODUTO,ZA_DESC,ZA_MOTIVO,ZA_DESCPER,ZA_OPERADO,ZA_SALDO,ZA_QTDORI,ZA_RECURSO
			FROM %table:SZA% SZA
			WHERE SZA.%notDel%
			AND ZA_DATA >= %Exp:mv_par01%
			AND ZA_DATA <= %Exp:mv_par02%
			AND ZA_OP >= %Exp:mv_par03%
			AND ZA_OP <= %Exp:mv_par04%
			AND ZA_PRODUTO >= %Exp:mv_par05%
			AND ZA_PRODUTO <= %Exp:mv_par06%
			ORDER BY %Exp:_cOrder%
			EndSql
		Endif
	EndIf


	TcSetField(_cAlias,"ZA_DATA"   ,"D",  8, 0)
	TcSetField(_cAlias,"ZA_SALDO"  ,"N", 14, 2)
	TcSetField(_cAlias,"ZA_QTDORI" ,"N", 14, 2)

	oSection1:EndQuery()

	oSection1:Init()

	dbSelectArea(_cAlias)
	While !oReport:Cancel() .And. (_cAlias)->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf

		oSection1:Cell("ZA_DOCUMEN"):SetValue((_cAlias)->ZA_DOCUMEN)
		oSection1:Cell("ZA_DATA")   :SetValue((_cAlias)->ZA_DATA)
		oSection1:Cell("ZA_OP")     :SetValue((_cAlias)->ZA_OP)
		oSection1:Cell("ZA_PRODUTO"):SetValue((_cAlias)->ZA_PRODUTO)
		oSection1:Cell("ZA_DESC")   :SetValue((_cAlias)->ZA_DESC)
		oSection1:Cell("ZA_MOTIVO") :SetValue((_cAlias)->ZA_MOTIVO)
		oSection1:Cell("ZA_DESCPER"):SetValue((_cAlias)->ZA_DESCPER)
		oSection1:Cell("ZA_OPERADO"):SetValue((_cAlias)->ZA_OPERADO)
		oSection1:Cell("ZA_QTDORI") :SetValue((_cAlias)->ZA_QTDORI)
		oSection1:Cell("ZA_SALDO")  :SetValue((_cAlias)->ZA_SALDO)
		oSection1:Cell("ZA_RECURSO"):SetValue((_cAlias)->ZA_RECURSO)


		If SZA->( FieldPos("ZA_USUARIO") ) > 0
			oSection1:Cell("ZA_USUARIO")  :SetValue((_cAlias)->ZA_USUARIO)
		EndIf

		oSection1:PrintLine()

		dbSelectArea(_cAlias)
		dbSkip()
		oReport:IncMeter()
		oReport:SkipLine()
	EndDo
	oSection1:Finish()
	oReport:EndPage()
Return

//-----------------------------------------------------------

Static Function fCriaPerg()
	Local j
	Local i

	aSvAlias:={Alias(),IndexOrd(),Recno()}
	i:=j:=0
	aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
	AADD(aRegistros,{_cPerg,"01","Da Data         ?","","","mv_ch1","D",08,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
	AADD(aRegistros,{_cPerg,"02","Ate a Data      ?","","","mv_ch2","D",08,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
	AADD(aRegistros,{_cPerg,"03","Da OP           ?","","","mv_ch3","C",11,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SC2","","","","",""})
	AADD(aRegistros,{_cPerg,"04","Ate a OP        ?","","","mv_ch4","C",11,00,00,"G","","mv_par04",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SC2","","","","",""})
	AADD(aRegistros,{_cPerg,"05","Do Produto      ?","","","mv_ch5","C",15,00,00,"G","","mv_par05",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SB1","","","","",""})
	AADD(aRegistros,{_cPerg,"06","Ate o Produto   ?","","","mv_ch6","C",15,00,00,"G","","mv_par06",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SB1","","","","",""})

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
