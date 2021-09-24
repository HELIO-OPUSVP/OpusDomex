#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RINV0001  ºAutor  ³Jonas Pereira     º Data ³  24/09/2021    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de inventário ciclico operacional                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RINV0001()
Private _cPerg  := "RINV0001"
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

cTitulo:= "Relatório de Planejado x Realizado"
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("RINV0001",cTitulo,cPerg,{|oReport| ReportPrin(oReport)},"Relatório de Planejado x Realizado - Inventario Ciclico.")

oReport:SetLandScape()

/*
oSection1:Cell("C4_PRODUTO"):SetHeaderAlign("LEFT")
oSection1:Cell("C4_PRODUTO"):SetAlign("LEFT")
oSection1:Cell("C4_PRODUTO"):SetSize(15)
*/

Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
Local oSection1 	:= oReport:Section(1)
Local nOrdem    	:= oSection1:GetOrder()
Local _cFilial  	:= "%"+cFilAnt+"%"


oSection1:=TRSection():New(oReport,"","ZZR",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)
                                                          

TRCell():New(oSection1,"ZZR_DTPLAN"       ,,"Dt. Planejada"       , ,008                               ,.F.,)
TRCell():New(oSection1,"ZZR_DTREAL"       ,,"Dt. Realizada"       , ,008                               ,.F.,)
TRCell():New(oSection1,"ZZR_PRODUT"       ,,"Produto"             , ,015                               ,.F.,)
TRCell():New(oSection1,"ZZR_DESCRI"       ,,"Descrição"           , ,050                               ,.F.,)
TRCell():New(oSection1,"ZZR_TIPO"         ,,"Tipo"                , ,002                               ,.F.,)
TRCell():New(oSection1,"ZZR_LOCAL"        ,,"Almoxarifado"        , ,002                               ,.F.,)
TRCell():New(oSection1,"ZZR_CLASSI"       ,,"Classificação"       , ,002                               ,.F.,)
TRCell():New(oSection1,"ZZR_QTD"          ,,"Inventários Periodo" , ,010                               ,.F.,)
TRCell():New(oSection1,"ZZR_ULT"          ,,"Ultimo Inventário"   , ,008                               ,.F.,)


TRCell():New(oSection1,"ESTOQUE"        ,,"ESTOQUE"         , ,010                               ,.F.,)


oSection1:SetHeaderPage(.T.)

Private _cAlias    := GetNextAlias()              


BeginSql Alias _cAlias

	SELECT ZZR_DTPLAN, ZZR_DTREAL, ZZR_PRODUT, ZZR_DESCRI, ZZR_TIPO, ZZR_LOCAL, ZZR_CLASSI, 0 AS ZZR_QTD, '20210924' AS ZZR_ULT 
	FROM ZZR010 (NOLOCK)
	WHERE D_E_L_E_T_ = ''
	AND ZZR_PERIOD == %Exp:mv_par02% ++ %Exp:mv_par01% 
	AND ZZR_PRODUT >= %Exp:mv_par03%
	AND ZZR_PRODUT >= %Exp:mv_par04%                                                                                  
	AND ZZR_LOCAL  >= %Exp:mv_par05%
	AND ZZR_LOCAL  <= %Exp:mv_par06%
	AND ZZR_FILIAL == %Exp:_cFilial% 
	
	
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
	                          
	oSection1:Cell("ZZR_DTPLAN")  :SetValue((_cAlias)->ZZR_DTPLAN   )
	oSection1:Cell("ZZR_DTREAL")  :SetValue((_cAlias)->ZZR_DTREAL   )
	oSection1:Cell("ZZR_PRODUT")  :SetValue((_cAlias)->ZZR_PRODUT   )	
	oSection1:Cell("ZZR_DESCRI")  :SetValue((_cAlias)->ZZR_DESCRI   )
	oSection1:Cell("ZZR_TIPO")    :SetValue((_cAlias)->ZZR_TIPO     )
	oSection1:Cell("ZZR_LOCAL")   :SetValue((_cAlias)->ZZR_LOCAL    )
	oSection1:Cell("ZZR_CLASSI")  :SetValue((_cAlias)->ZZR_CLASSI   )                               		
	oSection1:Cell("ZZR_QTD")     :SetValue((_cAlias)->ZZR_QTD      )
	oSection1:Cell("ZZR_ULT")     :SetValue((_cAlias)->ZZR_ULT      )
	
	
	
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
AADD(aRegistros,{_cPerg,"01","Mês            ","","","mv_ch1","C",02,00,00,"G","((Val(Mv_Par01)>0).And.(Val(Mv_Par01)<=12))","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Ano            ","","","mv_ch2","C",04,00,00,"G","(Len(AllTrim(Mv_Par02))==4)","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","Do  Produto   ?","","","mv_ch3","C",15,00,00,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
AADD(aRegistros,{_cPerg,"04","Até Produto   ?","","","mv_ch4","C",15,00,00,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})
AADD(aRegistros,{_cPerg,"05","Do  Local     ?","","","mv_ch5","C",02,00,00,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"06","Até Local     ?","","","mv_ch6","C",02,00,00,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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
