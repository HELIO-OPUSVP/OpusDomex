#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR03  ºAutor  ³Helio Ferreira      º Data ³  01/02/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório novo de previsão de vedas x vendas realizadas    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR03()
Private cPerg  := "RELPROD7"
Private oReport
Private cFilterUser
Private oSection1
Private oFont , oFontN
Private cTitulo

If Pergunte(cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return


Static Function ReportDef()

Local oSection1

cTitulo:= "Previsão de Vendas x Vendas Realizadas"
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("RELPROD7",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relatório exibirá uma listagem de Previsões de Vendas Realizadas.")

oReport:SetLandScape()

oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"B1_COD"       ,,"Produto"            , ,015,.F.,)
TRCell():New(oSection1,"B1_XPRVEND"   ,,"Prod.Prev.Vendas"   , ,015,.F.,)
TRCell():New(oSection1,"QUANTIDADE"   ,,"Quantidade"         , ,015,.F.,)
TRCell():New(oSection1,"VALOR"        ,,"Valor"              , ,015,.F.,)
TRCell():New(oSection1,"B1_DESC"      ,,"Descrição"          , ,060,.F.,)

oSection1:Cell("QUANTIDADE")  :SetPicture("@E 9,999,999.99")
oSection1:Cell("VALOR")       :SetPicture("@E 9,999,999.99")
		
// Totalizadores
oBreak1 := TRBreak():New(oSection1,oSection1:Cell("B1_XPRVEND"),"SUB-TOTAL"          ,.F.)  // quando mudar esse campo
TRFunction():New(oSection1:Cell("QUANTIDADE"),""              ,"SUM",oBreak1,,"@E 999,999,999,999.99",,.F.,.T.) // totaliza esse campo

oSection1:SetHeaderPage(.T.)

oSection1:Cell("B1_COD"):SetHeaderAlign("LEFT")
oSection1:Cell("B1_COD"):SetAlign("LEFT")
oSection1:Cell("B1_COD"):SetSize(15)

oSection1:Cell("QUANTIDADE"):SetHeaderAlign("RIGTH")

oSection1:Cell("VALOR"):SetHeaderAlign("RIGTH")

Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _cOrder   := "%C4_PRODUTO%"

oReport:SetTitle(cTitulo)

cQuery := "SELECT B1_COD, B1_XPRVEND, B1_DESC, C6_IPI, "
If MV_PAR05 = "N"
	cQuery += "SUM(C6_QTDVEN - C6_QTDENT)               AS QUANTIDADE, "
	cQuery += "SUM((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN) AS VALOR       "
EndIf
If MV_PAR05 = "F"
	cQuery += "SUM(C6_QTDENT)             AS QUANTIDADE, "
	cQuery += "SUM(C6_QTDENT * C6_PRCVEN) AS VALOR       "
EndIf

If MV_PAR05 = "A"
	cQuery += "SUM(C6_QTDVEN)             AS QUANTIDADE, "
	cQuery += "SUM(C6_QTDVEN * C6_PRCVEN) AS VALOR       "
EndIf
 
cQuery += "FROM " + RetSqlName("SB1") + " SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SA1")+" SA1 "
cQuery += "WHERE B1_DESC >= '"+mv_par03+"' AND B1_DESC <= '"+mv_par04+"' AND "
cQuery += "B1_COD >= '"+mv_par12+"' AND B1_COD <= '"+mv_par13+"' AND "
cQuery += "C6_DTFATUR >= '"+DtoS(mv_par06)+"' AND C6_DTFATUR <= '"+DtoS(mv_par07)+"' AND "
cQuery += "B1_COD = C6_PRODUTO AND C6_NUM = C5_NUM AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND C5_XPVTIPO = '"+mv_par14+"' AND "
cQuery += "C5_EMISSAO >= '"+DtoS(MV_PAR01)+"' AND C5_EMISSAO <= '"+DtoS(MV_PAR02)+"' AND " 
cQuery += "A1_NOME >= '"+MV_PAR08+"' AND A1_NOME <= '"+MV_PAR09+"' AND "
cQuery += "SB1.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' "

If MV_PAR05 == "F"
   cQuery += "AND C6_DATFAT <> '' "
EndIf
If MV_PAR05 == "N"
   cQuery += "AND C6_QTDENT < C6_QTDVEN"
EndIf

cQuery += "GROUP BY B1_COD, B1_XPRVEND, B1_DESC, C6_IPI "
cQuery += "ORDER BY B1_XPRVEND, B1_COD "

TCQUERY cQuery NEW ALIAS &(_cAlias)

//TcSetField(_cAlias,"C4_DATA"   ,"D",  8, 0)

oSection1:EndQuery()

oSection1:Init()

nRecnos := 0
While !(_cAlias)->(Eof())
	nRecnos++
	(_cAlias)->(dbSkip())
End

oReport:SetMeter(nRecnos)
(_cAlias)->(dbGoTop())

dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf

	oSection1:Cell("B1_COD")     :SetValue((_cAlias)->B1_COD)
	oSection1:Cell("B1_XPRVEND") :SetValue((_cAlias)->B1_XPRVEND)
	oSection1:Cell("QUANTIDADE") :SetValue((_cAlias)->QUANTIDADE)
	oSection1:Cell("VALOR")      :SetValue((_cAlias)->VALOR * (1+((_cAlias)->C6_IPI/100)))
	oSection1:Cell("B1_DESC")    :SetValue((_cAlias)->B1_DESC)
	
			
	oSection1:PrintLine()
	
	dbSelectArea(_cAlias)
	dbSkip()
	oReport:IncMeter()
	oReport:SkipLine()
EndDo
oSection1:Finish()
oReport:EndPage()

Return
