//-----------------------------------------------------------------------------------------------------------------------------------------------//
// OpusVp - Mauricio Lima de Souza                                                                                                               //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Rosenberger                                                                                                                         //
//06/11/2014                                                                                                                                     //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório Nota Fiscal X Previsão de venda                                                                                                      //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMNFPRE()
Private _cPerg :="DOMNFPRE2"+Space(01)
Private oReport
Private cFilterUser
Private oSection1
Private oSection2
Private _cArqTRB,_cInd1TRB

fCriaPerg()
If Pergunte(_cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return

//-----------------------------------

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2

oReport := TReport():New("DOMNFPRE","",""/*_cPerg*/,{|oReport| ReportPrint(oReport)},"Específico Rosenberger - Venda X Previsao")

oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"","SD2",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"A1_CGC"      ,"SA1","CNPJ"           ,         ,14,.F.,)
TRCell():New(oSection1,"A1_NOME"     ,"SA1","Cliente"        ,         ,40,.F.,)
TRCell():New(oSection1,"C6_XXPREVI"  ,"SC6","Previsao"       ,         ,15,.F.,)
TRCell():New(oSection1,"C6_DESCRI"   ,"SC6","Descriçao"      ,         ,40,.F.,)
TRCell():New(oSection1,"C4_XXQTDOR"  ,"SC4","Qtd_Orig_pre"   ,         ,14,.F.,)
TRCell():New(oSection1,"D2_QUANT"    ,"SD2","Quantidade"     ,         ,14,.F.,)
TRCell():New(oSection1,"D2_DIF"      ,"SD2","Diferenca"      ,         ,14,.F.,)

oSection1:SetHeaderPage(.T.)

oSection1:Cell("A1_CGC"     ):SetHeaderAlign("LEFT")
oSection1:Cell("A1_CGC"     ):SetAlign("LEFT")
oSection1:Cell("A1_CGC"     ):SetSize(30)

oSection1:Cell("A1_NOME"    ):SetHeaderAlign("LEFT")
oSection1:Cell("A1_NOME"    ):SetAlign("LEFT")
oSection1:Cell("A1_NOME"    ):SetSize(80)

oSection1:Cell("C6_XXPREVI" ):SetHeaderAlign("LEFT")
oSection1:Cell("C6_XXPREVI" ):SetAlign("LEFT")
oSection1:Cell("C6_XXPREVI" ):SetSize(50)

oSection1:Cell("C6_DESCRI"  ):SetHeaderAlign("LEFT" )
oSection1:Cell("C6_DESCRI"  ):SetAlign("LEFT" )
oSection1:Cell("C6_DESCRI"  ):SetSize(70)

oSection1:Cell("C4_XXQTDOR" ):SetHeaderAlign("RIGHT")
oSection1:Cell("C4_XXQTDOR" ):SetAlign("RIGHT")
oSection1:Cell("C4_XXQTDOR" ):SetSize(40)

oSection1:Cell("D2_QUANT"   ):SetHeaderAlign("RIGHT" )
oSection1:Cell("D2_QUANT"   ):SetAlign("RIGHT" )
oSection1:Cell("D2_QUANT"   ):SetSize(40)

oSection1:Cell("D2_DIF"     ):SetHeaderAlign("RIGHT" )
oSection1:Cell("D2_DIF"     ):SetAlign("RIGHT" )
oSection1:Cell("D2_DIF"     ):SetSize(40)

Return oReport

//---------------------------------------------------------

Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _cAlias2  := GetNextAlias()
Local _cAlias3  := GetNextAlias()
Private cTitulo := " Nota Fiscal X Previsão Venda - período  "+alltrim(Mv_Par02)+" de "+alltrim(Mv_Par01)+" "

oReport:SetTitle(cTitulo)

_cOrder  := "%C6_XXPREVI%"

BeginSql Alias _cAlias
	
	
	SELECT SUBSTRING(A1_CGC,1,8) AS A1_CGC ,A1_NOME,C6_XXPREVI,C6_DESCRI,C4_XXQTDOR AS C4_XXQTDOR,SUM(D2_QUANT) AS D2_QUANT,C4_XXQTDOR-SUM(D2_QUANT) AS D2_DIF
	FROM 	     %table:SD2% D2
	INNER JOIN %table:SA1% A1 ON A1_COD=D2_CLIENTE     AND A1_LOJA=D2_LOJA
	INNER JOIN %table:SC6% C6 ON C6_NUM =D2_PEDIDO     AND C6_ITEM=D2_ITEMPV
	INNER JOIN %table:SC4% C4 ON C4_PRODUTO=C6_XXPREVI AND C4_XXCNPJ=SUBSTRING(A1_CGC,1,8) AND C4_DATA=C6_XXPREDT
	WHERE
	SUBSTRING(D2_EMISSAO,1,6)=(%Exp:mv_par01%) +(%Exp:mv_par02%)
	AND      D2_QUANT > 0  AND D2_TIPO='N'
	AND (D2_CF    IN ('5101','5102','5116','5117','5118','5119','5401','5403','5405','5922','6404')
	OR D2_CF IN ('6101','6102','6116','6117','6118','6119','6401','6403','6405','6922','6404'))
	AND D2.D_E_L_E_T_<>'*'
	AND C6.D_E_L_E_T_<>'*'
	AND A1.D_E_L_E_T_<>'*'
	AND C4.D_E_L_E_T_<>'*'
	GROUP BY SUBSTRING(A1_CGC,1,8),C6_XXPREVI,C4_XXQTDOR,A1_NOME,C6_DESCRI
	ORDER BY %Exp:_cOrder%
	
EndSql

BeginSql Alias _cAlias2
	
	SELECT SUBSTRING(A1_CGC,1,8) AS A1_CGC ,A1_NOME,D2_COD,SUM(D2_QUANT) AS D2_QUANT,0-SUM(D2_QUANT) AS D2_DIF
	FROM 	     %table:SD2% D2
	INNER JOIN %table:SA1% A1  ON A1_COD=D2_CLIENTE     AND A1_LOJA=D2_LOJA
	WHERE  D2_DOC+D2_SERIE+D2_ITEM NOT IN
	(
	SELECT D2_DOC+D2_SERIE+D2_ITEM
	FROM 	     %table:SD2% D2
	INNER JOIN %table:SA1% A1  ON A1_COD     =D2_CLIENTE AND A1_LOJA  =D2_LOJA
	INNER JOIN %table:SC6% C6  ON C6_NUM     =D2_PEDIDO  AND C6_ITEM  =D2_ITEMPV
	INNER JOIN %table:SC4% C4  ON C4_PRODUTO =C6_XXPREVI AND C4_XXCNPJ=SUBSTRING(A1_CGC,1,8) AND C4_DATA=C6_XXPREDT
	WHERE 	SUBSTRING(D2_EMISSAO,1,6)=(%Exp:mv_par01%) +(%Exp:mv_par02%)
	AND      D2_QUANT > 0  AND D2_TIPO='N'
	AND(D2_CF    IN ('5101','5102','5116','5117','5118','5119','5401','5403','5405','5922','6404')
	OR D2_CF IN ('6101','6102','6116','6117','6118','6119','6401','6403','6405','6922','6404'))
	AND D2.D_E_L_E_T_<>'*'
	AND C6.D_E_L_E_T_<>'*'
	AND A1.D_E_L_E_T_<>'*'
	AND C4.D_E_L_E_T_<>'*' )
	AND    	SUBSTRING(D2_EMISSAO,1,6)=(%Exp:mv_par01%) +(%Exp:mv_par02%)
	AND (D2_CF    IN ('5101','5102','5116','5117','5118','5119','5401','5403','5405','5922','6404')
	OR D2_CF IN ('6101','6102','6116','6117','6118','6119','6401','6403','6405','6922','6404'))
	GROUP BY SUBSTRING(A1_CGC,1,8),D2_COD,A1_NOME
	ORDER BY D2_COD
	
EndSql
*----------------------------------------------------------------------------------------------------------------------------
BeginSql Alias _cAlias3
	SELECT SUBSTRING(C4_XXCNPJ,1,8) AS C4_XXCNPJ,C4_XXNOMCL,C4_PRODUTO,B1_DESC,C4_XXQTDOR AS C4_XXQTDOR,0 AS D2_QUANT,C4_XXQTDOR AS D2_DIF
	FROM SC4010 C4
	INNER JOIN SB1010 B1 ON B1_COD=C4_PRODUTO
	WHERE C4_PRODUTO+SUBSTRING(C4_XXCNPJ,1,8)+C4_DATA NOT IN (
	SELECT C6_XXPREVI+SUBSTRING(A1_CGC,1,8)+C6_XXPREDT
	FROM SC6010  C6
	INNER JOIN SA1010 A1 ON A1_COD=C6_CLI AND A1_LOJA=C6_LOJA
	WHERE  C6_XXPREVI<>'' AND C6.D_E_L_E_T_<>'*' AND A1.D_E_L_E_T_<>'*')
	AND C4.D_E_L_E_T_<>'*'
	AND B1.D_E_L_E_T_<>'*'
	AND SUBSTRING(C4_DATA,1,6)=(%Exp:mv_par01%) +(%Exp:mv_par02%)
	ORDER BY C4_XXCNPJ,C4_PRODUTO
EndSql
*----------------------------------------------------------------------------------------------------------------------------

TcSetField(_cAlias,"D2_QUANT"  ,"N", 8, 2)
TcSetField(_cAlias,"C4_XXQTDOR","N", 8, 2)
TcSetField(_cAlias,"D2_DIF"    ,"N", 8, 2)

TcSetField(_cAlias2,"D2_QUANT"  ,"N", 8, 2)
TcSetField(_cAlias2,"C4_XXQTDOR","N", 8, 2)
TcSetField(_cAlias2,"D2_DIF"    ,"N", 8, 2)

TcSetField(_cAlias3,"D2_QUANT"  ,"N", 8, 2)
TcSetField(_cAlias3,"C4_XXQTDOR","N", 8, 2)
TcSetField(_cAlias3,"D2_DIF"    ,"N", 8, 2)

oSection1:EndQuery()

dbSelectArea(_cAlias)
dbGotop()
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:Init()
	IF (_cAlias)->D2_QUANT >0
		oSection1:Cell("A1_CGC"     ):SetValue((_cAlias)->A1_CGC)
		oSection1:Cell("A1_NOME"    ):SetValue(SUBSTR((_cAlias)->A1_NOME,1,38))
		oSection1:Cell("C6_XXPREVI" ):SetValue((_cAlias)->C6_XXPREVI)
		oSection1:Cell("C6_DESCRI"  ):SetValue(SUBSTR((_cAlias)->C6_DESCRI,1,38))
		oSection1:Cell("C4_XXQTDOR" ):SetValue((_cAlias)->C4_XXQTDOR)
		oSection1:Cell("D2_QUANT"   ):SetValue((_cAlias)->D2_QUANT)
		oSection1:Cell("D2_DIF"     ):SetValue((_cAlias)->D2_DIF)
	ENDIF
	
	oSection1:PrintLine()
	
	dbSelectArea(_cAlias)
	dbSkip()
	oReport:IncMeter()
	oReport:SkipLine()
EndDo


dbSelectArea(_cAlias2)
dbGotop()

While !oReport:Cancel() .And. (_cAlias2)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//	oSection1:Init()
	
	IF (_cAlias2)->D2_QUANT >0
		oSection1:Cell("A1_CGC"     ):SetValue((_cAlias2)->A1_CGC)
		oSection1:Cell("A1_NOME"    ):SetValue(SUBSTR((_cAlias2)->A1_NOME,1,38))
		oSection1:Cell("C6_XXPREVI" ):SetValue((_cAlias2)->D2_COD)
		cDESC := POSICIONE('SB1',1,xFILIAL('SB1')+(_cAlias2)->D2_COD,'B1_DESC')
		oSection1:Cell("C6_DESCRI"  ):SetValue(SUBSTR(cDESC,1,38))
		oSection1:Cell("C4_XXQTDOR" ):SetValue(0)
		oSection1:Cell("D2_QUANT"   ):SetValue((_cAlias2)->D2_QUANT)
		oSection1:Cell("D2_DIF"     ):SetValue((_cAlias2)->D2_DIF)
	ENDIF
	
	oSection1:PrintLine()
	
	dbSelectArea(_cAlias2)
	dbSkip()
	oReport:IncMeter()
	oReport:SkipLine()
EndDo

*----------------------------------------------------------------------------------------------------------
dbSelectArea(_cAlias3)
dbGotop()

While !oReport:Cancel() .And. (_cAlias3)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//	oSection1:Init()
	
	oSection1:Cell("A1_CGC"    ):SetValue((_cAlias3)->C4_XXCNPJ)
	oSection1:Cell("A1_NOME"   ):SetValue(SUBSTR((_cAlias3)->C4_XXNOMCL,1,38))
	oSection1:Cell("C6_XXPREVI"):SetValue((_cAlias3)->C4_PRODUTO)
	oSection1:Cell("C6_DESCRI" ):SetValue(SUBSTR((_cAlias3)->B1_DESC,1,38))
	oSection1:Cell("C4_XXQTDOR"):SetValue((_cAlias3)->C4_XXQTDOR)
	oSection1:Cell("D2_QUANT"  ):SetValue((_cAlias3)->D2_QUANT)
	oSection1:Cell("D2_DIF"    ):SetValue((_cAlias3)->D2_DIF)
	
	oSection1:PrintLine()
	
	dbSelectArea(_cAlias3)
	dbSkip()
	oReport:IncMeter()
	oReport:SkipLine()
EndDo

*----------------------------------------------------------------------------------------------------------

oSection1:Finish()
oReport:EndPage()
Return

//-----------------------------------------------------------
Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Ano          ","","","mv_ch1","C",04,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Mes          ","","","mv_ch2","C",02,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})

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
