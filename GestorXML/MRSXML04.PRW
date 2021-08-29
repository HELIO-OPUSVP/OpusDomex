#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMRSXML04  บAutor  ณMarco Aurelio       บ Data ณ  15/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de XML                                           บฑฑ                 
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MRSXML04()
Private _cPerg  := Padr("MRSXML04",10)
Private oReport
Private cFilterUser
Private oSection1
Private oFont , oFontN                                                    
Private cTitulo             
Private _cCond       
Private _cOrder

fCriaPerg()
If Pergunte(_cPerg,.T.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return


Static Function ReportDef()

Local oSection1


if MV_PAR03 == 1
	_cTexto := "PENDENTES"
	_cCond	:=  '% F1_CHVNFE IS NULL %'
elseif MV_PAR03 ==2 // 	
	_cTexto := "RECEBIDOS"
	_cCond	:=  '% F1_CHVNFE IS NOT NULL %'
else	// 	
	_cTexto := "TODOS"
	_cCond	:=  '% ZZ0_DOC IS NOT NULL %'
endif

// Ordem do Relatorio
if MV_PAR04 == 1   // Data
	_cOrder := '% ZZ0_DTEMIS,ZZ0_HREMIS,ZZ0_DOC%'
elseif MV_PAR04 ==2 // 	Emitente
	_cOrder := '% ZZ0_DENOME,ZZ0_DTEMIS,ZZ0_HREMIS%'
else	// 	
	_cOrder := '% ZZ0_DOC,ZZ0_DTEMIS,ZZ0_HREMIS%'
endif

cTitulo:= "Relat๓rio de XML Lan็ados - "+ _cTexto+" -  " + dtoc(MV_PAR01) +" เ "+ dtoc(MV_PAR02)
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.) // Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("MRSXML04",cTitulo,_cPerg,{|oReport| ReportPrin(oReport)},"Este relat๓rio exibirแ os XML's Lan็ados no Sistemas.")
oReport:SetLandScape()


Return oReport

//---------------------------------------------------------

Static Function ReportPrin(oReport)
Local oSection1 := oReport:Section(1)
Local nOrdem    := oSection1:GetOrder()
Local _cFilial  := "%"+cFilAnt+"%"
Local _sDtFech  := "%"+DtoS(LastDay(mv_par01))+"%"
Local _cDoCC    := ""
Local _cAteCC   := ""

oSection1 :=TRSection():New(oReport,cTitulo,{"QRY"}) 
 
TRCell():New(oSection1,"ZZ0_STATUS"      ,,"STATUS"       	, ,015                               ,.F.,)
TRCell():New(oSection1,"ZZ0_SERIE"       ,,"SERIE"       	, ,003                               ,.F.,)
TRCell():New(oSection1,"ZZ0_DOC"         ,,"DOCUMENTO"     	, ,012                               ,.F.,)
TRCell():New(oSection1,"ZZ0_DTEMIS"      ,,"DT.EMISSAO"     , ,010                               ,.F.,)
TRCell():New(oSection1,"ZZ0_HREMIS"      ,,"HR.EMISSAO"     , ,010                               ,.F.,)
TRCell():New(oSection1,"ZZ0_LOGDT"       ,,"DT.XML SISTEMA" , ,010                               ,.F.,)
//TRCell():New(oSection1,"ZZ0_LOGHR"       ,,"HR.XML SISTEMA" , ,010                               ,.F.,)
TRCell():New(oSection1,"ZZ0_DENOME"      ,,"EMITENTE"       , ,045                               ,.F.,)
TRCell():New(oSection1,"ZZ0_CHVNFE"      ,,"CHAVE NFE"      , ,050                               ,.F.,)
TRCell():New(oSection1,"F1_DTDIGIT"      ,,"DT DIGITACAO"   , ,010                               ,.F.,)
TRCell():New(oSection1,"F1_VALBRUT"      ,,"VALOR NF"       , ,010                               ,.F.,)

TRFunction():New(oSection1:Cell("ZZ0_DOC")	,"TOTAL NOTAS","COUNT"	,      ,,"@E 999,999"				,,.T.,.F.)

oSection1:SetHeaderPage(.T.)

Private _cAlias   := GetNextAlias()

BeginSql Alias _cAlias

	SELECT ZZ0_SERIE,ZZ0_DOC,ZZ0_DTEMIS,ZZ0_HREMIS,ZZ0_LOGDT,ZZ0_LOGHR,SUBSTRING(ZZ0_DENOME,1,50) as ZZ0_DENOME,ZZ0_CHVNFE,F1_DTDIGIT,F1_VALBRUT,ZZ0_STATUS
	FROM %table:ZZ0%  ZZ0
	LEFT  JOIN %table:SF1% SF1
	ON ZZ0_CHVNFE=F1_CHVNFE AND SF1.%notDel% 
	WHERE ZZ0_DTEMIS BETWEEN %Exp:mv_par01%	AND %Exp:mv_par02% 
	AND %Exp:_cCond%   
	AND ZZ0.%notDel% 
	ORDER BY %Exp:_cOrder%  
	
EndSql

TcSetField(_cAlias,"ZZ0_DTEMIS"   ,"D",  8, 0)
TcSetField(_cAlias,"ZZ0_LOGDT"    ,"D",  8, 0)
TcSetField(_cAlias,"F1_DTDIGIT"   ,"D",  8, 0)

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
		
	oSection1:Cell("ZZ0_SERIE")	:SetValue((_cAlias)->ZZ0_SERIE  )
	oSection1:Cell("ZZ0_DOC")		:SetValue((_cAlias)->ZZ0_DOC    )
	oSection1:Cell("ZZ0_DTEMIS")  :SetValue((_cAlias)->ZZ0_DTEMIS   )
	oSection1:Cell("ZZ0_HREMIS") 	:SetValue((_cAlias)->ZZ0_HREMIS   )
	oSection1:Cell("ZZ0_LOGDT")	:SetValue((_cAlias)->ZZ0_LOGDT    )
//	oSection1:Cell("ZZ0_LOGHR")  	:SetValue((_cAlias)->ZZ0_LOGHR    )
	oSection1:Cell("ZZ0_DENOME")	:SetValue(Substr((_cAlias)->ZZ0_DENOME,1,45)    )
	oSection1:Cell("ZZ0_CHVNFE")  :SetValue((_cAlias)->ZZ0_CHVNFE    )
	oSection1:Cell("F1_DTDIGIT")  :SetValue((_cAlias)->F1_DTDIGIT    )
	oSection1:Cell("F1_VALBRUT")  :SetValue((_cAlias)->F1_VALBRUT    )

	do case
		case (_cAlias)->ZZ0_STATUS ==  "4"
			_cStat	:= "Erro pre-nota"
		case (_cAlias)->ZZ0_STATUS ==  "5"
			_cStat	:= "Pre-nota Excl."
		case (_cAlias)->ZZ0_STATUS ==  "6"
			_cStat	:= "Cancelada Sefaz"
		case (_cAlias)->ZZ0_STATUS ==  "7"
			_cStat	:= "Bloq.Valida็ใo"
		case (_cAlias)->ZZ0_STATUS ==  "8"
			_cStat	:= "Bloq. Usuario"
		OtherWise
			_cStat	:= ""																						
	EndCase

	oSection1:Cell("ZZ0_STATUS")  :SetValue(_cStat   )	
	oSection1:PrintLine()
	
	oReport:IncMeter()
	(_cAlias)->(dbSkip())
EndDo
oSection1:Finish()
oReport:EndPage()

Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCriaPerg   บAutor ณMarco Aurelio      บ Data ณ  21/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas do Relatorio                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Data De         ?","","","mv_ch1","D",08,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Data At้        ?","","","mv_ch2","D",08,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","Listar XML      ?","","","mv_ch3","N",01,00,01,"C","","mv_par03","Pendentes","Pendentes","Pendentes","","","Recebidos","Recebidos","Recebidos","","","Todos" ,"Todos","Todos","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"04","Ordem           ?","","","mv_ch4","N",01,00,01,"C","","mv_par04","Dt.Emissใo","Dt.Emissใo","Dt.Emissใo"   ,"","","Emitente","Emitente","Emitente","","","Documento" ,"Documento","Documento","","",""      ,"","","","","","","","","","","","","",""})

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

