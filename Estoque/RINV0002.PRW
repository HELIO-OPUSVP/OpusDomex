#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RINV0002  บAutor  ณJonas Pereira     บ Data ณ  06/10/2021    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de inventแrio ciclico gerencial               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RINV0002()
Private _cPerg  := "RINV0002  "
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


Static Function ReportDef()

Local oSection1

cTitulo:= "Relat๓rio Gerencial de Inventario Ciclico"
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("RINV0002",cTitulo,_cPerg,{|oReport| ReportPrin(oReport)},"Relat๓rio Gerencial de Inventario Ciclico.")

oReport:SetLandScape()

Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
Local oSection1 	:= oReport:Section(1)
Local _cFilial  	:= "%"+cFilAnt+"%"
Local lFirst := .t.

oSection1:=TRSection():New(oReport,"","ZZR",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"ZZR_PRODUT"       ,,"Produto"             , ,020                               ,.F.,)
TRCell():New(oSection1,"ZZR_DESCRI"       ,,"Descri็ใo"           , ,050                               ,.F.,)
TRCell():New(oSection1,"ZZR_TIPO"         ,,"Tipo"                , ,002                               ,.F.,)
TRCell():New(oSection1,"ZZR_LOCAL"        ,,"Almoxarifado"        , ,002                               ,.F.,)
TRCell():New(oSection1,"VALDEV"           ,,"Valor Devolu็ใo"     , ,010                               ,.F.,)
TRCell():New(oSection1,"VALREQ"           ,,"Valor Requisi็ใo"    , ,010                               ,.F.,)
TRCell():New(oSection1,"VALAJU"           ,,"Valor Ajuste"        , ,010                               ,.F.,)
TRCell():New(oSection1,"QTDITINV"         ,,"Qtd. Inventariada"   , ,010                               ,.F.,)
TRCell():New(oSection1,"QTDNINV"          ,,"Qtd. N Inventariada" , ,010                               ,.F.,)
TRCell():New(oSection1,"VLR_ARM"           ,,"Valor Armazem"      , ,010                               ,.F.,)
TRCell():New(oSection1,"QTD_ARM"           ,,"Qtd Armazem"        , ,010                               ,.F.,)
TRCell():New(oSection1,"PERCAJU"          ,,"Perc. Ajuste"        , ,010                               ,.F.,)


//TRCell():New(oSection1,"ESTOQUE"        ,,"ESTOQUE"         , ,010                               ,.F.,)


oSection1:SetHeaderPage(.T.)

Private _cAlias    := GetNextAlias()              
Private cPerFil    := mv_par02+''+mv_par01


BeginSql Alias _cAlias


	


SELECT '' AS ZZR_PRODUT, '' AS ZZR_DESCRI, '' AS ZZR_TIPO,

ZZR_LOCAL, VALDEV, VALREQ, VALAJU, QTDITINV, QTDNINV, VLR_ARM,'' AS QTD_ARM, ROUND((VALAJU / VLR_ARM)* 100,2) AS PERCAJU FROM 

(

SELECT ZZR_LOCAL, SUM(ZZR_VALDEV) AS VALDEV, SUM(ZZR_VALREQ) AS VALREQ, SUM(ZZR_VALAJU) AS VALAJU, 
(SELECT COUNT(*) FROM ZZR010 (NOLOCK) ZZCOUN WHERE ZZCOUN.ZZR_DTREAL <> '' AND ZZCOUN.ZZR_LOCAL=ZZR.ZZR_LOCAL) AS QTDITINV, 
(SELECT COUNT(*) FROM ZZR010 (NOLOCK) ZZCOUN WHERE ZZCOUN.ZZR_DTREAL = '' AND ZZCOUN.ZZR_LOCAL=ZZR.ZZR_LOCAL) AS QTDNINV,

(
SELECT ROUND(SUM(B9_VINI1),2) FROM SB9010 (NOLOCK) AS SB9 WHERE SB9.D_E_L_E_T_='' AND B9_QINI<>0 

AND B9_LOCAL=ZZR.ZZR_LOCAL AND B9_FILIAL='01' AND B9_DATA = 

(
SELECT X6_CONTEUD FROM SX6010 (NOLOCK) AS SX6 WHERE SX6.D_E_L_E_T_='' AND X6_VAR='MV_ULMES'AND X6_FIL='01'
)

) AS VLR_ARM

FROM ZZR010 (NOLOCK) AS ZZR
WHERE ZZR.D_E_L_E_T_=''

GROUP BY ZZR_LOCAL

) AS FINAL

UNION ALL



SELECT *, ROUND((VALAJU / VLR_ARM)* 100,2) AS PERCAJU FROM 

(

SELECT ZZR_PRODUT, ZZR_DESCRI, ZZR_TIPO, ZZR_LOCAL, SUM(ZZR_VALDEV) AS VALDEV, SUM(ZZR_VALREQ) AS VALREQ, SUM(ZZR_VALAJU) AS VALAJU, 

(SELECT COUNT(*) FROM ZZR010 (NOLOCK) ZZCOUN WHERE ZZCOUN.ZZR_DTREAL <> '' AND ZZCOUN.ZZR_LOCAL=ZZR.ZZR_LOCAL
AND ZZCOUN.ZZR_PRODUT=ZZR.ZZR_PRODUT) AS QTDITINV, 

(SELECT COUNT(*) FROM ZZR010 (NOLOCK) ZZCOUN WHERE ZZCOUN.ZZR_DTREAL = '' AND ZZCOUN.ZZR_LOCAL=ZZR.ZZR_LOCAL 
AND ZZCOUN.ZZR_PRODUT=ZZR.ZZR_PRODUT) AS QTDNINV, 

(
SELECT ROUND(SUM(B9_VINI1),2) FROM SB9010 (NOLOCK) AS SB9 WHERE SB9.D_E_L_E_T_='' AND B9_QINI<>0 

AND B9_LOCAL=ZZR.ZZR_LOCAL AND B9_COD= ZZR.ZZR_PRODUT AND B9_FILIAL='01' AND B9_DATA = 

(
SELECT X6_CONTEUD FROM SX6010 (NOLOCK) AS SX6 WHERE SX6.D_E_L_E_T_='' AND X6_VAR='MV_ULMES'AND X6_FIL='01'
)

) AS VLR_ARM,


(
SELECT ROUND(SUM(B9_QINI),2) FROM SB9010 (NOLOCK) AS SB9 WHERE SB9.D_E_L_E_T_='' AND B9_QINI<>0 

AND B9_LOCAL=ZZR.ZZR_LOCAL AND B9_COD= ZZR.ZZR_PRODUT AND B9_FILIAL='01' AND B9_DATA = 

(
SELECT X6_CONTEUD FROM SX6010 (NOLOCK) AS SX6 WHERE SX6.D_E_L_E_T_='' AND X6_VAR='MV_ULMES'AND X6_FIL='01'
)

) AS QTD_ARM

FROM ZZR010 (NOLOCK) AS ZZR
WHERE ZZR.D_E_L_E_T_=''

GROUP BY ZZR_LOCAL, ZZR_PRODUT, ZZR_DESCRI, ZZR_TIPO

) AS FINAL
	
	
EndSql

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
	
	//SZ1->( dbSeek( xFilial() + (_cAlias)->ZC_REQUISI ) )
	//SZB->( dbSeek( xFilial() + (_cAlias)->ZD_ESCOLA  ) )
	//SB1->( dbSeek( xFilial() + (_cAlias)->ZD_PRODUTO ) )
	If lFirst
		lFirst := .f.
		
		oSection1:Cell("ZZR_PRODUT")  :SetValue('')	
		oSection1:Cell("ZZR_DESCRI")  :SetValue('')	
		oSection1:Cell("ZZR_TIPO")    :SetValue('')	
		

		oSection1:PrintLine()
		oReport:SkipLine()

		oSection1:Cell("ZZR_PRODUT")  :SetValue('')	
		oSection1:Cell("ZZR_DESCRI")  :SetValue('')	
		oSection1:Cell("ZZR_TIPO")    :SetValue('')	
		
		oSection1:PrintLine()
		oReport:SkipLine()
	
		
		

		//oSection1:Cell("ZZR_DTPLAN")  :SetValue('TOTAL ITENS'              )	
		//oSection1:Cell("ZZR_DTREAL")  :SetValue('DEMANDA ATษ '+DTOC(DDATABASE) )	
		//oSection1:Cell("ZZR_PRODUT")  :SetValue('Itens Inventariados'           		    )	
		//oSection1:Cell("ZZR_DESCRI")  :SetValue('Percentual'								)
		//oSection1:Cell("ZZR_QTD")     :SetValue('')

		oSection1:PrintLine()
		oReport:SkipLine()
	

		oSection1:Cell("ZZR_LOCAL")  :SetValue((_cAlias)->ZZR_LOCAL        )	
		oSection1:Cell("VALDEV")     :SetValue((_cAlias)->VALDEV           )	
		oSection1:Cell("VALREQ")     :SetValue((_cAlias)->VALREQ           )	
		oSection1:Cell("VALAJU")     :SetValue((_cAlias)->VALAJU           )
		oSection1:Cell("QTDITINV")   :SetValue((_cAlias)->QTDITINV         )
		oSection1:Cell("QTDNINV")    :SetValue((_cAlias)->QTDNINV          )
		oSection1:Cell("VLR_ARM")    :SetValue((_cAlias)->VLR_ARM          )
		oSection1:Cell("QTD_ARM")    :SetValue((_cAlias)->QTD_ARM          )
		oSection1:Cell("PERCAJU")   :SetValue((_cAlias)->PERCAJU         )
		

		oSection1:PrintLine()
		oReport:SkipLine()

		
		(_cAlias)->(dbSkip())

	EndIF
	                          
 	oSection1:Cell("ZZR_PRODUT") :SetValue((_cAlias)->ZZR_PRODUT       )	
	oSection1:Cell("ZZR_DESCRI") :SetValue((_cAlias)->ZZR_DESCRI       )	
	oSection1:Cell("ZZR_TIPO")   :SetValue((_cAlias)->ZZR_TIPO         )	
	oSection1:Cell("ZZR_LOCAL")  :SetValue((_cAlias)->ZZR_LOCAL        )	
	oSection1:Cell("VALDEV")     :SetValue((_cAlias)->VALDEV           )	
	oSection1:Cell("VALREQ")     :SetValue((_cAlias)->VALREQ           )	
	oSection1:Cell("VALAJU")     :SetValue((_cAlias)->VALAJU           )
	oSection1:Cell("QTDITINV")   :SetValue((_cAlias)->QTDITINV         )
	oSection1:Cell("QTDNINV")    :SetValue((_cAlias)->QTDNINV          )
	oSection1:Cell("VLR_ARM")    :SetValue((_cAlias)->VLR_ARM          )
	oSection1:Cell("QTD_ARM")    :SetValue((_cAlias)->QTD_ARM          )
	oSection1:Cell("PERCAJU")   :SetValue((_cAlias)->PERCAJU         )	
	
	oSection1:PrintLine()
	oReport:SkipLine()
	
	oReport:IncMeter()
	(_cAlias)->(dbSkip())
EndDo
oSection1:Finish()
oReport:EndPage()

Return


Static Function fCriaPerg()
Local i, j
	aSvAlias:={Alias(),IndexOrd(),Recno()}
	i:=j:=0
	aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","M๊s de         ","","","mv_ch1","C",02,00,00,"G","((Val(Mv_Par01)>0).And.(Val(Mv_Par01)<=12))","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Ano de         ","","","mv_ch2","C",04,00,00,"G","(Len(AllTrim(Mv_Par02))==4)","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","M๊s At้        ","","","mv_ch3","C",02,00,00,"G","((Val(Mv_Par03)>0).And.(Val(Mv_Par03)<=12))","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"04","Ano At้        ","","","mv_ch4","C",04,00,00,"G","(Len(AllTrim(Mv_Par04))==4) .and. mv_par04==mv_par02","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"05","Do  Local     ?","","","mv_ch5","C",02,00,00,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"06","At้ Local     ?","","","mv_ch6","C",02,00,00,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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
