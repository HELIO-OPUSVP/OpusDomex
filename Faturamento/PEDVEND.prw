#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PEDVEND  ºAutor  ³Helio Ferreira      º Data ³  18/08/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório desenvolvido para substituir o                   º±±
±±º          ³ /ALMEIDA E PORTO/PEDVEND.RPM                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PEDVEND()
Private cPerg  := "PEDVEND"
Private oReport
Private cFilterUser
Private oSection1
Private oFont , oFontN
Private cTitulo
Private nReg := 0

If MsgYesNo("Deseja executar o NOVO Relatório baseado na tabela SZY ? ","Atenção")
   U_PEDVEND2()
   Return
EndIf

If Pergunte(cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return


Static Function ReportDef()

Local oSection1

cTitulo:= "Relatório de Acompanhamento de OR"
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("PEDVEND",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relatório exibirá XXX.")

oReport:SetLandScape()

oSection1:=TRSection():New(oReport,"","SZA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"C5_EMISSAO"     ,,"DT Emissao"            , ,008,.F.,)
TRCell():New(oSection1,"C5_NUM"         ,,"Numero OF"             , ,006,.F.,)
TRCell():New(oSection1,"A1_NREDUZ"      ,,"Cliente"               , ,030,.F.,)
TRCell():New(oSection1,"C6_ITEM"        ,,"Item OF"               , ,002,.F.,)
TRCell():New(oSection1,"C6_PRODUTO"     ,,"RDT PN"                , ,015,.F.,)
TRCell():New(oSection1,"C6_SEUCOD"      ,,"Cliente PN"            , ,020,.F.,)
TRCell():New(oSection1,"C6_DESCRI"      ,,"Descrição"             , ,060,.F.,)
TRCell():New(oSection1,"QTD"            ,,"Quantidade"            , ,012,.F.,)
TRCell():New(oSection1,"C6_ENTREG"      ,,"DT Fatura"             , ,008,.F.,)
TRCell():New(oSection1,"C6_ENTRE1"      ,,"Reprog 1"              , ,008,.F.,)
TRCell():New(oSection1,"C6_ENTRE2"      ,,"Reprog 2"              , ,008,.F.,)
TRCell():New(oSection1,"C6_ENTRE3"      ,,"Entrega Real"          , ,008,.F.,)
TRCell():New(oSection1,"B2_QATU"        ,,"Saldo Atual"           , ,010,.F.,)
TRCell():New(oSection1,"C5_ESP1"        ,,"Espec. Client."        , ,010,.F.,)

oSection1:Cell("QTD")  :SetPicture("@E 99,999.9999")

// Totalizadores
//oBreak1 := TRBreak():New(oSection1,oSection1:Cell("ZC_EXPEDIC"),"TOTAL DIA"          ,.F.)
//TRFunction():New(oSection1:Cell("B9_TOTAL"),""                 ,"SUM",oBreak1,,"@E 999,999,999,999.99",,.F.,.T.)

oSection1:SetHeaderPage(.T.)

//oSection1:Cell("C4_PRODUTO"):SetHeaderAlign("LEFT")
//oSection1:Cell("C4_PRODUTO"):SetAlign("LEFT")
//oSection1:Cell("C4_PRODUTO"):SetSize(15)

//oSection1:Cell("C4_DATA"):SetHeaderAlign("RIGHT")
//oSection1:Cell("C4_DATA"):SetAlign("RIGHT")
//oSection1:Cell("C4_DATA"):SetSize(8)

//oSection1:Cell("C4_QUANT"):SetHeaderAlign("RIGHT")
//oSection1:Cell("C4_QUANT"):SetAlign("RIGHT")
//oSection1:Cell("C4_QUANT"):SetSize(15)


Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _cOrder   := "%C6_NUM,C6_ITEM,C6_PRODUTO%"
Local _mv_par01 := "%'"+DtoS(mv_par01)+"'%"
Local _mv_par02 := "%'"+DtoS(mv_par02)+"'%"
Local _mv_par03 := "%'"+DtoS(mv_par03)+"'%"
Local _mv_par04 := "%'"+DtoS(mv_par04)+"'%"
Local _mv_par05 := "%'"+mv_par05+"'%"
Local _mv_par06 := "%'"+mv_par06+"'%"

oReport:SetTitle(cTitulo)

BeginSql Alias _cAlias
	SELECT C5_EMISSAO, C5_NUM, A1_NREDUZ, C6_ITEM, C6_PRODUTO, C6_SEUCOD, C6_DESCRI, C6_QTDVEN, C6_QTDENT, C6_ENTREG, C6_ENTRE1, C6_ENTRE2,
	C6_ENTRE3, B2_QATU, C5_ESP1
	FROM %table:SC5% SC5 (NOLOCK), %table:SA1% SA1 (NOLOCK),%table:SC6% SC6 (NOLOCK), %table:SB2% SB2 (NOLOCK), %table:SB1% SB1 (NOLOCK)
	WHERE SC5.%notDel% AND SC6.%notDel% AND SA1.%notDel% AND SB2.%notDel% AND SB1.%notDel%
	AND C5_EMISSAO >= %Exp:_mv_par01% AND C5_EMISSAO <= %Exp:_mv_par02%
	AND C5_NUM     >= %Exp:_mv_par05% AND C5_NUM     <= %Exp:_mv_par06%
	AND (B1_TIPO = 'PR' OR B1_TIPO ='MP')
	AND C6_QTDVEN <> C6_QTDENT
	AND C5_XPVTIPO = 'OF'
	
	AND C5_NUM = C6_NUM
	AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA
	AND C6_PRODUTO = B2_COD AND C6_LOCAL = B2_LOCAL
	AND C6_PRODUTO = B1_COD
	AND C5_FILIAL = %xFilial:SC5% 
	AND C6_FILIAL = %xFilial:SC6% 
	AND A1_FILIAL = %xFilial:SA1% 
	AND B2_FILIAL = %xFilial:SB2% 
	AND B1_FILIAL = %xFilial:SB1% 
	
	ORDER BY %Exp:_cOrder%
EndSql

TcSetField(_cAlias,"C5_EMISSAO"   ,"D",  8, 0)
TcSetField(_cAlias,"C6_ENTREG"    ,"D",  8, 0)
TcSetField(_cAlias,"C6_ENTRE1"    ,"D",  8, 0)
TcSetField(_cAlias,"C6_ENTRE2"    ,"D",  8, 0)
TcSetField(_cAlias,"C6_ENTRE3"    ,"D",  8, 0)
                            

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
	oSection1:Cell("C5_NUM")    :SetValue((_cAlias)->C5_NUM    )
	oSection1:Cell("A1_NREDUZ") :SetValue((_cAlias)->A1_NREDUZ )
	oSection1:Cell("C6_ITEM")   :SetValue((_cAlias)->C6_ITEM   )
	oSection1:Cell("C6_PRODUTO"):SetValue((_cAlias)->C6_PRODUTO)
	oSection1:Cell("C6_SEUCOD") :SetValue((_cAlias)->C6_SEUCOD )
	oSection1:Cell("C6_DESCRI") :SetValue((_cAlias)->C6_DESCRI )
	oSection1:Cell("QTD")       :SetValue((_cAlias)->C6_QTDVEN-(_cAlias)->C6_QTDENT)
	oSection1:Cell("C6_ENTREG") :SetValue((_cAlias)->C6_ENTREG )
	oSection1:Cell("C6_ENTRE1") :SetValue((_cAlias)->C6_ENTRE1 )
	oSection1:Cell("C6_ENTRE2") :SetValue((_cAlias)->C6_ENTRE2 )
	oSection1:Cell("C6_ENTRE3") :SetValue((_cAlias)->C6_ENTRE3 )
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
