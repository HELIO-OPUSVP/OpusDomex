//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - OpusVp - 05/07/13                                                                                                        //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Rosenberger                                                                                                                         //
//Estoque Custo                                                                                                                                  //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório para identificação de movimentos à endereçar sem a origem.                                                                           //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMEST09()
Private _cPerg :="DOMEST09"+Space(02)
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

oReport := TReport():New("DOMEST09","",""/*_cPerg*/,{|oReport| ReportPrint(oReport)},"Específico Rosenberger - Endereçamento sem origem.")

oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"","SDA",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"DA_DATA"        ,"SDA","Data"           ,         ,10,.F.,)
TRCell():New(oSection1,"DA_DOC"         ,"SDA","Documento"      ,         ,06,.F.,)
TRCell():New(oSection1,"DA_PRODUTO"     ,"SDA","Produto "       ,         ,15,.F.,)
TRCell():New(oSection1,"DA_LOCAL"       ,"SDA","Local"          ,         ,02,.F.,)
TRCell():New(oSection1,"DA_SALDO"       ,"SDA","Saldo"          ,         ,14,.F.,)
TRCell():New(oSection1,"DA_LOTECTL"     ,"SDA","Lote"           ,         ,10,.F.,)
TRCell():New(oSection1,"DA_ORIGEM"      ,"SDA","Origem"         ,         ,03,.F.,)
TRCell():New(oSection1,"DA_NUMSEQ"      ,"SDA","Sequência"      ,         ,06,.F.,)

oSection1:SetHeaderPage(.T.)

oSection1:Cell("DA_DATA"   ):SetHeaderAlign("RIGHT")
oSection1:Cell("DA_DATA"   ):SetAlign("RIGHT")
oSection1:Cell("DA_DATA"   ):SetSize(14)

oSection1:Cell("DA_DOC"    ):SetHeaderAlign("LEFT")
oSection1:Cell("DA_DOC"    ):SetAlign("LEFT")
oSection1:Cell("DA_DOC"    ):SetSize(06)

oSection1:Cell("DA_PRODUTO"):SetHeaderAlign("LEFT")
oSection1:Cell("DA_PRODUTO"):SetAlign("LEFT")
oSection1:Cell("DA_PRODUTO"):SetSize(15)

oSection1:Cell("DA_LOCAL"  ):SetHeaderAlign("LEFT" )
oSection1:Cell("DA_LOCAL"  ):SetAlign("LEFT" )
oSection1:Cell("DA_LOCAL"  ):SetSize(02)

oSection1:Cell("DA_SALDO"  ):SetHeaderAlign("RIGHT")
oSection1:Cell("DA_SALDO"  ):SetAlign("RIGHT")
oSection1:Cell("DA_SALDO"  ):SetSize(14)

oSection1:Cell("DA_LOTECTL"):SetHeaderAlign("LEFT" )
oSection1:Cell("DA_LOTECTL"):SetAlign("LEFT" )
oSection1:Cell("DA_LOTECTL"):SetSize(10)

oSection1:Cell("DA_ORIGEM"):SetHeaderAlign("LEFT" )
oSection1:Cell("DA_ORIGEM"):SetAlign("LEFT" )
oSection1:Cell("DA_ORIGEM"):SetSize(03)

oSection1:Cell("DA_NUMSEQ" ):SetHeaderAlign("LEFT" )
oSection1:Cell("DA_NUMSEQ" ):SetAlign("LEFT" )
oSection1:Cell("DA_NUMSEQ" ):SetSize(06)

Return oReport

//---------------------------------------------------------

Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Private cTitulo := " Endereçamento sem origem - período de "+Dtoc(Mv_Par01)+" a "+Dtoc(Mv_Par02)+"."

oReport:SetTitle(cTitulo)

_cOrder  := "%DA_PRODUTO%"   

BeginSql Alias _cAlias
		SELECT  DA_DATA,DA_DOC,DA_PRODUTO,DA_LOCAL,DA_SALDO,DA_LOTECTL,DA_ORIGEM,DA_NUMSEQ
		FROM %table:SDA% SDA
		WHERE DA_FILIAL = %Exp:xFilial("SDA")%
      AND DA_DATA >= %Exp:mv_par01%
      AND DA_DATA <= %Exp:mv_par02%
      AND DA_PRODUTO >= %Exp:mv_par03%
      AND DA_PRODUTO <= %Exp:mv_par04%
		AND SDA.%notDel% 
		ORDER BY %Exp:_cOrder%
EndSql

TcSetField(_cAlias,"DA_DATA","D", 8, 0)

oSection1:EndQuery()

dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
    
   oSection1:Init()
    
   dbSelectArea((_cAlias)->DA_ORIGEM)
   dbGotop()
   dbSetOrder(4)
   If! dbSeek(xFilial((_cAlias)->DA_ORIGEM)+Alltrim((_cAlias)->DA_NUMSEQ)) 

	    oSection1:Cell("DA_DATA"   ):SetValue((_cAlias)->DA_DATA)
	    oSection1:Cell("DA_DOC"    ):SetValue((_cAlias)->DA_DOC)
       oSection1:Cell("DA_PRODUTO"):SetValue((_cAlias)->DA_PRODUTO)
	    oSection1:Cell("DA_LOCAL"  ):SetValue((_cAlias)->DA_LOCAL)
	    oSection1:Cell("DA_SALDO"  ):SetValue((_cAlias)->DA_SALDO)
	    oSection1:Cell("DA_LOTECTL"):SetValue((_cAlias)->DA_LOTECTL)
	    oSection1:Cell("DA_ORIGEM" ):SetValue((_cAlias)->DA_ORIGEM)
	    oSection1:Cell("DA_NUMSEQ" ):SetValue((_cAlias)->DA_NUMSEQ)
   
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
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Data de      ","","","mv_ch1","D",08,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Data ate     ","","","mv_ch2","D",08,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","Produto de   ","","","mv_ch3","C",15,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SB1","","","","",""})
AADD(aRegistros,{_cPerg,"04","Produto ate  ","","","mv_ch4","C",15,00,00,"G","","mv_par04",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","SB1","","","","",""})

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