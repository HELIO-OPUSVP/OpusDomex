#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMPCP02  ºAutor  ³Helio Ferreira      º Data ³  21/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatóro de Falta de Materiais na abertura de OPs          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMPCP02()
Private _cPerg :="DOMPCP02"+Space(02)
Private oReport
Private cFilterUser
Private oSection1
Private oFont , oFontN
Private cTitulo

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

cTitulo:= "Relatóro de Falta de Materiais na abertura de OPs"
//oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito
//oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

//oSenha:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

oReport   :=TReport():New("DOMPCP02",cTitulo,_cPerg,{|oReport| ReportPrint(oReport)},"Este relatório exibirá as faltas de materiais apontadas na abertura das OPs.")

oReport:SetLandScape()

oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"ZN_DATA"          ,,"Data"             , ,008,.F.,)
TRCell():New(oSection1,"ZN_PRODUTO"       ,,"Produto"          , ,015,.F.,)
TRCell():New(oSection1,"ZN_DESC"          ,,"Descrição"        , ,060,.F.,)
TRCell():New(oSection1,"ZN_OP"            ,,"OP"               , ,011,.F.,)
TRCell():New(oSection1,"ZN_QTD"           ,,"Quantidade"       , ,020,.F.,)
TRCell():New(oSection1,"ZN_EMP"           ,,"Total Empenhos"   , ,020,.F.,)
TRCell():New(oSection1,"ZN_SALDO"         ,,"Saldo Estoque"    , ,020,.F.,)
TRCell():New(oSection1,"ZN_NECESS"        ,,"Necessidade"      , ,020,.F.,)
TRCell():New(oSection1,"ZN_DTPC"          ,,"DataPC"           , ,008,.F.,)
TRCell():New(oSection1,"ZN_PEDIDO"        ,,"Numero PC"        , ,006,.F.,)
TRCell():New(oSection1,"ZN_SALDOPC"       ,,"Saldo PC"         , ,011,.F.,)

oSection1:SetHeaderPage()

oSection1:Cell("ZN_QTD"):SetHeaderAlign("RIGHT")
oSection1:Cell("ZN_QTD"):SetAlign("RIGHT")
oSection1:Cell("ZN_QTD"):SetSize(20)

oSection1:Cell("ZN_EMP"):SetHeaderAlign("RIGHT")
oSection1:Cell("ZN_EMP"):SetAlign("RIGTH")
oSection1:Cell("ZN_EMP"):SetSize(20)

oSection1:Cell("ZN_SALDO"):SetHeaderAlign("RIGHT")
oSection1:Cell("ZN_SALDO"):SetAlign("RIGTH")
oSection1:Cell("ZN_SALDO"):SetSize(20)

oSection1:Cell("ZN_NECESS"):SetHeaderAlign("RIGHT")
oSection1:Cell("ZN_NECESS"):SetAlign("RIGTH")
oSection1:Cell("ZN_NECESS"):SetSize(20)

oSection1:Cell("ZN_DTPC"):SetHeaderAlign("RIGHT")
oSection1:Cell("ZN_DTPC"):SetAlign("RIGHT")
oSection1:Cell("ZN_DTPC"):SetSize(08)

oSection1:Cell("ZN_PEDIDO"):SetHeaderAlign("RIGHT")
oSection1:Cell("ZN_PEDIDO"):SetAlign("RIGTH")
oSection1:Cell("ZN_PEDIDO"):SetSize(06)

oSection1:Cell("ZN_SALDOPC"):SetHeaderAlign("RIGHT")
oSection1:Cell("ZN_SALDOPC"):SetAlign("RIGHT")
oSection1:Cell("ZN_SALDOPC"):SetSize(11)
//oSection1:Cell("ZN_SALDOPC"):SetPicture("@E 999,999.9999",11)

Return oReport


Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _cOrder   := "%ZN_DATA,ZN_TEXTO%"
Local nTotal    := 0
Local cProduto  := ''

oReport:SetTitle(cTitulo)

oFontN := TFont():New("Courier New",,08,,.T.,,,,.T.,.F.)// Negrito
oFont  := TFont():New("Courier New",,08,,.F.,,,,.F.,.F.)

BeginSql Alias _cAlias
	SELECT  ZN_DATA,ZN_TEXTO
	FROM %table:SZN% SZN
	WHERE SZN.%notDel%
	AND ZN_DATA >= %Exp:mv_par01%
	AND ZN_DATA <= %Exp:mv_par02%
	ORDER BY %Exp:_cOrder%
EndSql

//TcSetField(_cAlias,"ZN_DATA"   ,"D",  8, 0)

oSection1:EndQuery()

oSection1:Init()

//SD4->( dbSetOrder(1) )
SC6->( dbSetOrder(1) )

dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:Cell("ZN_DATA")    :SetValue(DtoC(StoD((_cAlias)->ZN_DATA)))
	oSection1:Cell("ZN_PRODUTO") :SetValue(Subs((_cAlias)->ZN_TEXTO,01,15))
	oSection1:Cell("ZN_DESC")    :SetValue(Posicione("SB1",1,xFilial("SB1")+Subs((_cAlias)->ZN_TEXTO,01,15),"B1_DESC"))
	oSection1:Cell("ZN_OP")      :SetValue(Subs((_cAlias)->ZN_TEXTO,16,11))
	oSection1:Cell("ZN_QTD")     :SetValue(Subs((_cAlias)->ZN_TEXTO,27,20))
	
	//C2_NCLIENT
	SC2->( dbSeek( xFilial() + Subs((_cAlias)->ZN_TEXTO,16,11) ) )
	SC6->( dbSeek( xFilial() + SC2->C2_PEDIDO + SC2->C2_ITEMPV ) )
	
	oSection1:Cell("ZN_EMP")     :SetValue(" Cli: "      + SC2->C2_NCLIENT                             )
	oSection1:Cell("ZN_SALDO")   :SetValue(" OF: "       + SC2->C2_PEDIDO + ' Item: ' + SC2->C2_ITEMPV )
	oSection1:Cell("ZN_NECESS")  :SetValue(" Data OTD: " + DtoC(SC6->C6_XXDTDEF)                       )
	oSection1:Cell("ZN_DTPC")    :SetValue("")
	oSection1:Cell("ZN_PEDIDO")  :SetValue("")
	oSection1:Cell("ZN_SALDOPC") :SetValue("")
	
	oSection1:PrintLine()
	
	nTotal   += Val(StrTran(StrTran(Subs((_cAlias)->ZN_TEXTO,27,20),'.',''),',','.'))
	cProduto := Subs((_cAlias)->ZN_TEXTO,01,15)
	
	dbSelectArea(_cAlias)
	dbSkip()
	
	//oSection1:PrintLine()
	oReport:SkipLine()
	
	If cProduto <> Subs((_cAlias)->ZN_TEXTO,01,15)
		
		//oSection1:PrintLine()
		//oReport:SkipLine()
		
		oSection1:Cell("ZN_DATA")    :SetValue("")
		oSection1:Cell("ZN_PRODUTO") :SetValue("")
		oSection1:Cell("ZN_DESC")    :SetValue("")
		oSection1:Cell("ZN_OP")      :SetValue("")
		oSection1:Cell("ZN_QTD")     :SetValue("")
		oSection1:Cell("ZN_EMP")     :SetValue("")
		oSection1:Cell("ZN_SALDO")   :SetValue("")
		oSection1:Cell("ZN_NECESS")  :SetValue("")
		oSection1:Cell("ZN_DTPC")    :SetValue("")
		oSection1:Cell("ZN_PEDIDO")  :SetValue("")
		oSection1:Cell("ZN_SALDOPC") :SetValue("")
		
		
		// Total de Empenhos
		cQuery := "SELECT SUM(D4_QUANT) AS D4_QUANT FROM " + RetSqlName("SD4") + " WHERE D4_COD = '"+cProduto+"' AND D4_QUANT <> 0 AND D_E_L_E_T_ = '' "
		
		If Select("QUERYSD4") <> 0
			QUERYSD4->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSD4"
		
		// Saldo em estoque
		SB2->( dbSeek( xFilial() + cProduto ) )
		
		nTotB2 := 0
		While !SB2->( EOF() ) .and. SB2->B2_COD == cProduto
			If SB2->B2_LOCAL <> '97'
				nTotB2 += SB2->B2_QATU
			EndIf
			SB2->( dbSkip() )
		End
		
		// Data PC, Numero PC e Quantidade PC
		cQuery := "SELECT C7_QUANT, C7_QUJE, C7_DATPRF, C7_NUM FROM " + RetSqlName("SC7") + " (NOLOCK) WHERE C7_FILIAL = '01' AND C7_PRODUTO = '"+cProduto+"' AND D_E_L_E_T_ = '' AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' ORDER BY C7_DATPRF"
		
		If Select("QUERYSC7") <> 0
			QUERYSC7->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSC7"
		
		TcSetField("QUERYSC7","C7_DATPRF"   ,"D",  8, 0)
		
		If oReport:nDevice == 4   // 4 == Planilha
			oSection1:Cell("ZN_DATA")    :SetValue("TOTAL")
			oSection1:Cell("ZN_PRODUTO") :SetValue("")
			oSection1:Cell("ZN_DESC")    :SetValue("")
			oSection1:Cell("ZN_OP")      :SetValue("")
			oSection1:Cell("ZN_QTD")     :SetValue(Transform(nTotal,'@E 99,999,999,999.9999'))
			oSection1:Cell("ZN_EMP")     :SetValue(Transform(QUERYSD4->D4_QUANT,'@E 9,999,999,999.9999'))
			oSection1:Cell("ZN_SALDO")   :SetValue(Transform(nTotB2,'@E 9,999,999,999.9999'))
			oSection1:Cell("ZN_NECESS")  :SetValue(Transform(QUERYSD4->D4_QUANT - nTotB2,'@E 99,999,999,999.9999'))
			
			nTotPC := 0
			nNumPC := 0
			
			If !QUERYSC7->( EOF() )  //!Empty(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)
				While !QUERYSC7->( EOF() )
					If nNumPC <> 0
						oSection1:Cell("ZN_DATA")    :SetValue("")
						oSection1:Cell("ZN_PRODUTO") :SetValue("")
						oSection1:Cell("ZN_DESC")    :SetValue("")
						oSection1:Cell("ZN_OP")      :SetValue("")
						oSection1:Cell("ZN_QTD")     :SetValue("")
						oSection1:Cell("ZN_EMP")     :SetValue("")
						oSection1:Cell("ZN_SALDO")   :SetValue("")
						oSection1:Cell("ZN_NECESS")  :SetValue("")
					EndIf
					oSection1:Cell("ZN_DTPC")    :SetValue(DtoC(QUERYSC7->C7_DATPRF))
					oSection1:Cell("ZN_PEDIDO")  :SetValue(QUERYSC7->C7_NUM)
					oSection1:Cell("ZN_SALDOPC") :SetValue(Transform(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE,"@E 99,999.9999"))
					
					nTotPC += QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE
					nNumPC += 1
					QUERYSC7->( dbSkip() )
					oSection1:PrintLine()
					oReport:SkipLine()
				End
				If nNumPC > 1
				   oSection1:Cell("ZN_DTPC")    :SetValue("")
					oSection1:Cell("ZN_PEDIDO")  :SetValue("")
					oSection1:Cell("ZN_SALDOPC") :SetValue(Transform(nTotPC,'@E 99,999.9999'))
					oSection1:PrintLine()
					oReport:SkipLine()
				EndIf
			Else
				oSection1:Cell("ZN_DTPC")    :SetValue("")
				oSection1:Cell("ZN_PEDIDO")  :SetValue("")
				oSection1:Cell("ZN_SALDOPC") :SetValue("")
				
				oSection1:PrintLine()
				oReport:SkipLine()
			EndIf
			
			nTotal   := 0
		Else
			oReport:Say( oReport:Row() , oSection1:Cell("ZN_DATA"):ColPos() , "TOTAL"                                                ,oFontN )
			// Quantidade
			oReport:Say( oReport:Row() , oSection1:Cell("ZN_QTD"):ColPos()   , Transform(nTotal,'@E 99,999,999,999.9999')            ,oFontN )
			oReport:Say( oReport:Row() , oSection1:Cell("ZN_EMP"):ColPos()   , Transform(QUERYSD4->D4_QUANT,'@E 9,999,999,999.9999') ,oFontN )
			// Necessidade
			oReport:Say( oReport:Row() , oSection1:Cell("ZN_SALDO"):ColPos() , Transform(nTotB2,'@E 9,999,999,999.9999') ,oFontN )
			oReport:Say( oReport:Row() , oSection1:Cell("ZN_NECESS"):ColPos(), Transform(QUERYSD4->D4_QUANT - nTotB2,'@E 99,999,999,999.9999') ,oFontN )
			
			nTotPC := 0
			nNumPC := 0
			
			If !QUERYSC7->( EOF() )  //!Empty(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE)
				While !QUERYSC7->( EOF() )
					oReport:Say( oReport:Row() , oSection1:Cell("ZN_DTPC"):ColPos()   , DtoC(QUERYSC7->C7_DATPRF)            ,oFontN )
					oReport:Say( oReport:Row() , oSection1:Cell("ZN_PEDIDO"):ColPos() , QUERYSC7->C7_NUM                     ,oFontN )
					oReport:Say( oReport:Row() , oSection1:Cell("ZN_SALDOPC"):ColPos(), Transform(QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE,"@E 99,999.9999") ,oFontN )
					
					nTotPC += QUERYSC7->C7_QUANT-QUERYSC7->C7_QUJE
					nNumPC += 1
					QUERYSC7->( dbSkip() )
					oSection1:PrintLine()
					oReport:SkipLine()
				End
				If nNumPC > 1
					oReport:Say( oReport:Row() , oSection1:Cell("ZN_SALDOPC"):ColPos() , Transform(nTotPC,'@E 99,999.9999') ,oFontN )
					oSection1:PrintLine()
					oReport:SkipLine()
				EndIf
			Else
				oReport:Say( oReport:Row() , oSection1:Cell("ZN_DTPC"):ColPos()   , "" ,oFontN )
				oReport:Say( oReport:Row() , oSection1:Cell("ZN_PEDIDO"):ColPos() , "" ,oFontN )
				oReport:Say( oReport:Row() , oSection1:Cell("ZN_SALDOPC"):ColPos(), "" ,oFontN )
				
				oSection1:PrintLine()
				oReport:SkipLine()
			EndIf
			
			nTotal   := 0
		EndIf
		
		//oReport:IncMeter()
	EndIf
	
EndDo

oSection1:Finish()
oReport:EndPage()

Return
