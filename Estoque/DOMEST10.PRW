#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  DOMEST10  บAutor  ณJonas Pereira      บ Data ณ  29/11/2021   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMEST10()
Private cPerg  := "DOMEST10  "
Private oReport
Private cFilterUser
Private oSection1
Private oFont , oFontN
Private cTitulo
Private nReg := 0


fCriaPerg()
If Pergunte(cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return


Static Function ReportDef()

Local oSection1

cTitulo:= "Saldos por OP WIP"
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("DOMEST10",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Este relat๓rio exibirแ os saldos no 97.")

oReport:SetLandScape()

oSection1:= TRSection():New(oReport,"","SB8",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)
// Corre็ใo Jonas
//oSection1 := TRSection():New(oReport,"SB8",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"B8_FILIAL"        ,,"Filial"             , ,002,.F.,)
TRCell():New(oSection1,"B8_PRODUTO"       ,,"Produto"            , ,015,.F.,)
TRCell():New(oSection1,"B1_DESC"          ,,"Descricao"          , ,015,.F.,)
TRCell():New(oSection1,"B8_LOTECTL"       ,,"OP"                 , ,010,.F.,)
TRCell():New(oSection1,"B8_SALDO"         ,,"Qtd. Atual"         , ,015,.F.,)
TRCell():New(oSection1,"B2_CM1"           ,,"Custo Medio"        , ,015,.F.,)
TRCell():New(oSection1,"B2_TOTAL"         ,,"Valor"              , ,015,.F.,)


//oSection1:Cell("B9_CM1")  :SetPicture("@E 9,999.99")
		
// Totalizadores
oBreak1 := TRBreak():New(oSection1,oSection1:Cell("B8_LOTECTL"),"VALOR OP"          ,.F.)
TRFunction():New(oSection1:Cell("B2_TOTAL"),""                 ,"SUM",oBreak1,,"@E 999,999,999,999.99",,.F.,.T.)

oBreak2 := TRBreak():New(oSection1,oSection1:Cell("B8_FILIAL"),"VALOR FILIAL"          ,.F.)
TRFunction():New(oSection1:Cell("B2_TOTAL"),""                 ,"SUM",oBreak2,,"@E 999,999,999,999.99",,.F.,.T.)



oSection1:SetHeaderPage(.T.)

oSection1:Cell("B8_FILIAL"):SetHeaderAlign("LEFT")
oSection1:Cell("B8_FILIAL"):SetAlign("LEFT")
oSection1:Cell("B8_FILIAL"):SetSize(2)

oSection1:Cell("B8_PRODUTO"):SetHeaderAlign("RIGHT")
oSection1:Cell("B8_PRODUTO"):SetAlign("RIGHT")
oSection1:Cell("B8_PRODUTO"):SetSize(15)


oSection1:Cell("B1_DESC"):SetHeaderAlign("RIGHT")
oSection1:Cell("B1_DESC"):SetAlign("RIGHT")
oSection1:Cell("B1_DESC"):SetSize(60)


oSection1:Cell("B8_LOTECTL"):SetHeaderAlign("RIGHT")
oSection1:Cell("B8_LOTECTL"):SetAlign("RIGHT")
oSection1:Cell("B8_LOTECTL"):SetSize(10)

oSection1:Cell("B8_SALDO"):SetHeaderAlign("RIGHT")
oSection1:Cell("B8_SALDO"):SetAlign("RIGHT")
oSection1:Cell("B8_SALDO"):SetSize(15)


oSection1:Cell("B2_CM1"):SetHeaderAlign("RIGHT")
oSection1:Cell("B2_CM1"):SetAlign("RIGHT")
oSection1:Cell("B2_CM1"):SetSize(15)

oSection1:Cell("B2_TOTAL"):SetHeaderAlign("RIGHT")
oSection1:Cell("B2_TOTAL"):SetAlign("RIGHT")
oSection1:Cell("B2_TOTAL"):SetSize(15)

Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _cOrder   := "%B8_FILIAL, B8_LOTECTL%"
Local _cOPS     := "%%"

If mv_par05 == 1 
	_cOPS     := "%AND C2_DATRF=''%"
ElseiF  mv_par05 == 2 
	_cOPS     := "%AND C2_DATRF<>''%"
Elseif  mv_par05 == 3
	_cOPS     := "%%"
EndIF


oReport:SetTitle(cTitulo)

BeginSql Alias _cAlias


SELECT *, B8_SALDO * CM1 AS VALOR FROM 
(
SELECT B8_FILIAL, B8_LOTECTL, B8_PRODUTO, B1_DESC, B8_SALDO, 

(

SELECT CASE WHEN round(B2_QATU,2) <= 0 or round(B2_VATU1,2) <=0 THEN 

(CASE WHEN B2_CM1 < 0 THEN 



(SELECT TOP 1 B9_CM1 FROM %table:SB9%  SB9 WHERE SB9.%notDel% AND B9_LOCAL=B8_LOCAL AND B9_FILIAL=B8_FILIAL AND B9_COD=B8_PRODUTO ORDER BY B9_DATA DESC) 


ELSE B2_CM1 END) 


ELSE ROUND(B2_VATU1/B2_QATU,2)  END AS CM1 FROM %table:SB2%  SB2 WHERE B2_COD=B8_PRODUTO AND B2_LOCAL=B8_LOCAL AND B8_FILIAL=B2_FILIAL AND SB2.%notDel%

) AS CM1

FROM %table:SB8%  SB8
INNER JOIN %table:SB1% SB1 ON B1_COD=B8_PRODUTO AND B1_FILIAL=''
WHERE SB8.%notDel%  AND B8_LOCAL='97' AND B8_SALDO>0
) AS FINAL
WHERE 	B8_FILIAL  >= %Exp:mv_par03%
	AND B8_FILIAL  <= %Exp:mv_par04%
	AND B8_PRODUTO >= %Exp:mv_par01%
	AND B8_PRODUTO <= %Exp:mv_par02%

AND B8_FILIAL++B8_LOTECTL IN 
(
select C2_FILIAL++C2_NUM++C2_ITEM from %table:SC2%  SC2 WHERE SC2.D_E_L_E_T_='' %Exp:_cOPS% GROUP BY C2_FILIAL, C2_NUM, C2_ITEM
)

ORDER BY %Exp:_cOrder%

EndSql

//TcSetField(_cAlias,"C4_DATA"   ,"D",  8, 0)

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
	
	oSection1:Cell("B8_FILIAL"):SetValue((_cAlias)->B8_FILIAL)
	oSection1:Cell("B8_PRODUTO"):SetValue((_cAlias)->B8_PRODUTO)
	oSection1:Cell("B1_DESC"):SetValue((_cAlias)->B1_DESC)
	oSection1:Cell("B8_LOTECTL"):SetValue((_cAlias)->B8_LOTECTL)
	oSection1:Cell("B8_SALDO"):SetValue((_cAlias)->B8_SALDO)
	oSection1:Cell("B2_CM1"):SetValue((_cAlias)->CM1)
	oSection1:Cell("B2_TOTAL"):SetValue((_cAlias)->VALOR)
	
	oSection1:PrintLine()
	
	dbSelectArea(_cAlias)
	dbSkip()
	oReport:IncMeter()
	oReport:SkipLine()
EndDo
oSection1:Finish()
oReport:EndPage()

(_cAlias)->( dbCloseArea() )

Return


Static Function fCriaPerg()
	aSvAlias:={Alias(),IndexOrd(),Recno()}
	i:=j:=0
	aRegistros:={}
	cPerg := PADR(cPerg,10)
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{cPerg,"01","Do  Produto   ?","","","mv_ch1","C",15,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
AADD(aRegistros,{cPerg,"02","At้ Produto   ?","","","mv_ch2","C",15,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
AADD(aRegistros,{cPerg,"03","Da Filial     ?","","","mv_ch3","C",02,00,00,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","","","",""})
AADD(aRegistros,{cPerg,"04","At้ Filial    ?","","","mv_ch4","C",02,00,00,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","","","",""})
AADD(aRegistros,{cPerg,"05","OPs           ?","","","mv_ch5","N",01,00,00,"C","","mv_par05","1 - Abertas","","","","","2 - Fechadas","","","","","3 - Ambas","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegistros,{_cPerg,"01","Do  Requisitante?","","","mv_ch1","C",08,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegistros,{_cPerg,"02","At้ Requisitante?","","","mv_ch2","C",08,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegistros,{_cPerg,"03","De  Expedi็ใo    ?","","","mv_ch3","D",08,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})

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
