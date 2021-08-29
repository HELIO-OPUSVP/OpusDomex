#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"                                                 
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMPCP03  ºAutor  ³Helio Ferreira      º Data ³  30/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMPCP03()
Private cPerg  := "DOMPCP03"
Private oReport
Private cFilterUser
Private oSection1
Private oFont , oFontN
Private cTitulo

//U_DOMEST01()

If Pergunte(cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return


Static Function ReportDef()

Local _cPictTit := "@E@Z 99999,999.99"
Local _cPictTot := "@E 99,999,999.99"
Local oSection1

cTitulo:= "Previsão de Vendas"
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito 
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("DOMPCP01",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relatório exibirá os apontamentos de perda da produção.")

oReport:SetLandScape()

oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"C4_XXCOD"         ,,"Codigo"             , ,008,.F.,)
TRCell():New(oSection1,"C4_PRODUTO"       ,,"Produto"            , ,017,.F.,)
TRCell():New(oSection1,"C4_DATA"          ,,"Data"               , ,010,.F.,)
TRCell():New(oSection1,"C4_QUANT"         ,,"Qtd. Atual"         , ,017,.F.,)
TRCell():New(oSection1,"C4_XXQTDOR"       ,,"Qtd. Inicial"       , ,017,.F.,)
TRCell():New(oSection1,"C4_XXCLIEN"       ,,"Cliente"            , ,008,.F.,)
TRCell():New(oSection1,"C4_XXLOJA"        ,,"Loja"               , ,004,.F.,)
TRCell():New(oSection1,"C4_XXNOMCL"       ,,"Nome"               , ,062,.F.,)
TRCell():New(oSection1,"C4_OBS"           ,,"Observação"         , ,062,.F.,)

oSection1:SetHeaderPage(.T.)

oSection1:Cell("C4_XXCOD"):SetHeaderAlign("LEFT")                          
oSection1:Cell("C4_XXCOD"):SetAlign("LEFT")
oSection1:Cell("C4_XXCOD"):SetSize(08)

oSection1:Cell("C4_PRODUTO"):SetHeaderAlign("LEFT")
oSection1:Cell("C4_PRODUTO"):SetAlign("LEFT")
oSection1:Cell("C4_PRODUTO"):SetSize(17)

oSection1:Cell("C4_DATA"):SetHeaderAlign("RIGHT")
oSection1:Cell("C4_DATA"):SetAlign("RIGHT")
oSection1:Cell("C4_DATA"):SetSize(10)

oSection1:Cell("C4_QUANT"):SetHeaderAlign("RIGHT")
oSection1:Cell("C4_QUANT"):SetAlign("RIGHT")
oSection1:Cell("C4_QUANT"):SetSize(17)

oSection1:Cell("C4_XXQTDOR"):SetHeaderAlign("RIGHT")
oSection1:Cell("C4_XXQTDOR"):SetAlign("RIGHT")
oSection1:Cell("C4_XXQTDOR"):SetSize(17)

oSection1:Cell("C4_XXCLIEN"):SetHeaderAlign("LEFT")
oSection1:Cell("C4_XXCLIEN"):SetAlign("LEFT")
oSection1:Cell("C4_XXCLIEN"):SetSize(08)

oSection1:Cell("C4_XXLOJA"):SetHeaderAlign("LEFT")
oSection1:Cell("C4_XXLOJA"):SetAlign("LEFT")
oSection1:Cell("C4_XXLOJA"):SetSize(04)

oSection1:Cell("C4_XXNOMCL"):SetHeaderAlign("LEFT")
oSection1:Cell("C4_XXNOMCL"):SetAlign("LEFT")
oSection1:Cell("C4_XXNOMCL"):SetSize(55)

Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _cOrder   := "%C4_PRODUTO%"

oReport:SetTitle(cTitulo)

BeginSql Alias _cAlias
         SELECT  *
	      FROM %table:SC4% SC4
         WHERE SC4.%notDel%
         AND C4_XXCLIEN+C4_XXLOJA >= %Exp:mv_par01+mv_par02%
         AND C4_XXCLIEN+C4_XXLOJA <= %Exp:mv_par03+mv_par04%
         AND C4_DATA >= %Exp:mv_par05%
         AND C4_DATA <= %Exp:mv_par06%
         AND C4_PRODUTO >= %Exp:mv_par07%
         AND C4_PRODUTO <= %Exp:mv_par08%
       ORDER BY %Exp:_cOrder%
EndSql

TcSetField(_cAlias,"C4_DATA"   ,"D",  8, 0)

oSection1:EndQuery()

oSection1:Init()

dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf

   oSection1:Cell("C4_XXCOD")  :SetValue((_cAlias)->C4_XXCOD)
   oSection1:Cell("C4_PRODUTO"):SetValue((_cAlias)->C4_PRODUTO)
	oSection1:Cell("C4_DATA")   :SetValue((_cAlias)->C4_DATA)
	oSection1:Cell("C4_QUANT")  :SetValue((_cAlias)->C4_QUANT)
	oSection1:Cell("C4_XXQTDOR"):SetValue((_cAlias)->C4_XXQTDOR)
	oSection1:Cell("C4_XXCLIEN"):SetValue((_cAlias)->C4_XXCLIEN)
	oSection1:Cell("C4_XXLOJA") :SetValue((_cAlias)->C4_XXLOJA)
	oSection1:Cell("C4_XXNOMCL"):SetValue(substr((_cAlias)->C4_XXNOMCL,1,55))
	oSection1:Cell("C4_OBS")    :SetValue((_cAlias)->C4_OBS)
	
   oSection1:PrintLine()
	
	dbSelectArea(_cAlias)
	dbSkip()
   oReport:IncMeter()
   oReport:SkipLine()
EndDo
oSection1:Finish()
oReport:EndPage()

Return