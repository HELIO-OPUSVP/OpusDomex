#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR04  ºAutor  ³Helio Ferreira      º Data ³  18/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR04()
Private cPerg  := "RFATR04"
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

cTitulo:= "Titulo do Relatório"
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("RFATR04",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relatório exibirá XXX.")

oReport:SetLandScape()

oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"VENDEDOR"         ,,"Vendedor"            , ,006,.F.,)
TRCell():New(oSection1,"NOMEVEN"          ,,"Nome Vend."          , ,050,.F.,)
TRCell():New(oSection1,"CODCLI"           ,,"Cod. Cli."           , ,009,.F.,)
TRCell():New(oSection1,"NOMECLI"          ,,"Nome Cli."           , ,050,.F.,)
TRCell():New(oSection1,"PRODUTO"          ,,"Produto"             , ,015,.F.,)
TRCell():New(oSection1,"DESCRICAO"        ,,"Descrição"           , ,060,.F.,)
TRCell():New(oSection1,"QTDSC4"           ,,"Qtd. Prev."          , ,010,.F.,)
TRCell():New(oSection1,"VLRSC4"           ,,"Vlr. Prev."          , ,010,.F.,)
TRCell():New(oSection1,"QTDSD2"           ,,"Qtd. Venda."         , ,010,.F.,)
TRCell():New(oSection1,"VLRSD2"           ,,"Vlr. Venda."         , ,010,.F.,)
TRCell():New(oSection1,"DIFERENCA"        ,,"Vlr. Diferença."     , ,010,.F.,)

oSection1:Cell("QTDSC4")   :SetPicture("@E 999,999.9999")
oSection1:Cell("VLRSC4")   :SetPicture("@E 999,999.99")
oSection1:Cell("QTDSD2")   :SetPicture("@E 999,999.9999")
oSection1:Cell("VLRSD2")   :SetPicture("@E 999,999.99")
oSection1:Cell("DIFERENCA"):SetPicture("@E 999,999.99")

// Totalizadores

/*
oBreak1 := TRBreak():New(oSection1,oSection1:Cell("ZC_EXPEDIC"),"TOTAL DIA"          ,.F.)
TRFunction():New(oSection1:Cell("B9_TOTAL"),""                 ,"SUM",oBreak1,,"@E 999,999,999,999.99",,.F.,.T.)

oSection1:SetHeaderPage(.T.)

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
Local _cOrder   := "%A3_COD,MIN(A1_COD+A1_LOJA)%"

oReport:SetTitle(cTitulo)

BeginSql Alias _cAlias
	SELECT  A3_COD, A3_NREDUZ, SUBSTRING(A1_CGC,1,8) AS A1CNPJ, MIN(A1_COD+A1_LOJA) AS A1CODLOJ
	FROM %table:SA1% SA1, %table:SA3% SA3
	WHERE SA1.%notDel% AND SA3.%notDel%
	AND A3_COD >= %Exp:mv_par02%
	AND A3_COD <= %Exp:mv_par03%
	AND A3_COD = A1_VEND
	GROUP BY A3_COD, A3_NREDUZ, SUBSTRING(A1_CGC,1,8)
	ORDER BY %Exp:_cOrder%
EndSql

//TcSetField(_cAlias,"C4_DATA"   ,"D",  8, 0)

oSection1:EndQuery()

oSection1:Init()

dbSelectArea(_cAlias)

(_cAlias)->( dbEval({||nReg++}) )
oReport:SetMeter(nReg)

(_cAlias)->(dbGoTop())

aVetor := {}

While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	// Previsão de Vendas
	cQuery := "SELECT C4_PRODUTO, C4_XXQTDOR FROM " + RetSqlName("SC4") + " WHERE C4_XXCNPJ = '"+(_cAlias)->A1CNPJ+"' AND "
	cQuery += "C4_DATA LIKE '"+Subs(mv_par01,3,4)+Subs(mv_par01,1,2)+"%' AND D_E_L_E_T_ = '' "
	
	If Select("QUERYSC4") <> 0
		QUERYSC4->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSC4"
	
	While !QUERYSC4->( EOF() )
		
		If oReport:Cancel()
	   	oSection1:Cell("VENDEDOR")  :SetValue("Relatório Cancelado pelo Operador")
			Exit
		EndIf

		aArray := {}
		U_ExpEstru(QUERYSC4->C4_PRODUTO,@aArray)
		
		For x := 1 to Len(aArray)
			If aArray[x,2] >= mv_par04 .and. aArray[x,2] <= mv_par05
				N := aScan(aVetor,{ |aVet| aVet[1] == (_cAlias)->A3_COD .and. aVet[2] == (_cAlias)->A1CODLOJ .and. aVet[4] == aArray[x,2]   })
				
				If Empty(N)
					SB1->( dbSetOrder(1) )
					SB2->( dbSetOrder(1) )
					SB1->( dbSeek( xFilial() + aArray[x,2] ) )
             	SB2->( dbSeek( xFilial() + SB1->B1_COD + SB1->B1_LOCPAD ) )

					//            1                  2                     3                   4             5                                  6            7            8
					//            Vendedor           Cliente               CNPJ                PRODUTO       QTD.PREVISAO                       Qtd.Venda    Vlr. Unit    Diferenca
					AADD(aVetor,{ (_cAlias)->A3_COD, (_cAlias)->A1CODLOJ , (_cAlias)->A1CNPJ , aArray[x,2] , aArray[x,3] * QUERYSC4->C4_XXQTDOR,0           ,SB2->B2_CM1, 0          })
					aVetor[Len(aVetor),8] :=    (aVetor[Len(aVetor),5]*aVetor[Len(aVetor),7]) - (aVetor[Len(aVetor),6]*aVetor[Len(aVetor),7])
				Else
					aVetor[N,5] += aArray[x,3] * QUERYSC4->C4_XXQTDOR
					aVetor[N,8] :=    (aVetor[N,5]*aVetor[N,7]) - (aVetor[N,6]*aVetor[N,7])
				EndIf
			EndIf
		Next x
		
		QUERYSC4->( dbSkip() )
	End
	
	
	// Vendas Reais
	
	cQuery := "SELECT D2_COD, D2_QUANT FROM " + RetSqlName("SD2") + ", " + RetSqlName("SA1") + " WHERE A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND "
	cQuery += "SUBSTRING(A1_CGC,1,8) = '"+(_cAlias)->A1CNPJ+"' AND "
	cQuery += "D2_EMISSAO LIKE '"+Subs(mv_par01,3,4)+Subs(mv_par01,1,2)+"%' AND "+ RetSqlName("SD2") +".D_E_L_E_T_ = '' AND " + RetSqlName("SA1") +".D_E_L_E_T_ = ''
	
	If Select("QUERYSD2") <> 0
		QUERYSD2->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSD2"
	
	While !QUERYSD2->( EOF() )

		If oReport:Cancel()
	   	oSection1:Cell("VENDEDOR")  :SetValue("Relatório Cancelado pelo Operador")
			Exit
		EndIf

		aArray := {}
		U_ExpEstru(QUERYSD2->D2_COD,@aArray)
		
		For x := 1 to Len(aArray)
			If aArray[x,2] >= mv_par04 .and. aArray[x,2] <= mv_par05
				N := aScan(aVetor,{ |aVet| aVet[1] == (_cAlias)->A3_COD .and. aVet[2] == (_cAlias)->A1CODLOJ .and. aVet[4] == aArray[x,2]   })
				
				If Empty(N)
					SB1->( dbSetOrder(1) )
					SB2->( dbSetOrder(1) )
					SB1->( dbSeek( xFilial() + aArray[x,2] ) )
             	SB2->( dbSeek( xFilial() + SB1->B1_COD + SB1->B1_LOCPAD ) )

					//            1                  2                     3                   4             5                6                                    7           8
					//            Vendedor           Cliente               CNPJ                PRODUTO       QTD.PREVISAO     Qtd.Venda                            Vlr. Unit   Diferença
					AADD(aVetor,{ (_cAlias)->A3_COD, (_cAlias)->A1CODLOJ , (_cAlias)->A1CNPJ , aArray[x,2] , 0              , aArray[x,3] * QUERYSD2->D2_QUANT , SB2->B2_CM1, 0  })
					aVetor[Len(aVetor),8] :=    (aVetor[Len(aVetor),5]*aVetor[Len(aVetor),7]) - (aVetor[Len(aVetor),6]*aVetor[Len(aVetor),7])
				Else
					aVetor[N,6] += aArray[x,3] * QUERYSC4->C4_XXQTDOR
					aVetor[N,8] :=    (aVetor[N,5]*aVetor[N,7]) - (aVetor[N,6]*aVetor[N,7])
				EndIf
			EndIf
		Next x
		
		QUERYSD2->( dbSkip() )
	End
	
	oReport:IncMeter()
	
	(_cAlias)->( dbSkip() )
EndDo


aSort( aVetor,,, { |x, y| (x[1]+StrZero(x[8],10)) < (y[1]+StrZero(y[8],10)) } )

SA3->( dbSetOrder(1) )
SA1->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )

For x := 1 to Len(aVetor)
	SA3->( dbSeek( xFilial() + aVetor[x,1] ) )
	SA1->( dbSeek( xFilial() + aVetor[x,2] ) )
	SB1->( dbSeek( xFilial() + aVetor[x,4] ) )
	
	oSection1:Cell("VENDEDOR")  :SetValue(aVetor[x,1])
	oSection1:Cell("NOMEVEN")   :SetValue(SA3->A3_NREDUZ)
	oSection1:Cell("CODCLI")    :SetValue(aVetor[x,2])
	oSection1:Cell("NOMECLI")   :SetValue(SA1->A1_NREDUZ)
	oSection1:Cell("PRODUTO")   :SetValue(aVetor[x,4])
	oSection1:Cell("DESCRICAO") :SetValue(SB1->B1_DESC)
	oSection1:Cell("QTDSC4")    :SetValue(aVetor[x,5])
	oSection1:Cell("VLRSC4")    :SetValue(aVetor[x,5]*aVetor[x,7])
	oSection1:Cell("QTDSD2")    :SetValue(aVetor[x,6])
	oSection1:Cell("VLRSD2")    :SetValue(aVetor[x,6]*aVetor[x,7])
	oSection1:Cell("DIFERENCA") :SetValue(aVetor[x,8])

	
	oSection1:PrintLine()
	oReport:SkipLine()
Next x

oSection1:Finish()
oReport:EndPage()

Return
