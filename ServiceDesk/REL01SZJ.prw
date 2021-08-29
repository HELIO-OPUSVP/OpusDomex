#include "protheus.ch"
#include "topconn.ch"
#include "report.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ REL01SZJ บAutor  ณ Felipe A. Melo     บ Data ณ  04/12/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function REL01SZJ()

Local	oReport
Local	aArea     := GetArea()

Private cString := "SZJ"				// alias do arquivo principal (Base)

oReport:=ReportDef()
oReport:PrintDialog()

RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณReportDef ณ Autor ณ Tiago Malta           ณ Data ณ 09.08.11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Definicao do relatorio                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function ReportDef()

Local oReport                                               '

Local aOrd    := {"Chamado","Status","Categoria","Data Inc.","Solicitante","Departamento"}
Local cTitulo := "Relacao de Chamados - Service Desk"
Local cDescri := "Este programa irแ imprimir a rela็ใo dos chamados."+Chr(10)+Chr(13)+"Serแ impresso de acordo com os parametros solicitados pelo usuario."
Local bReport := { |oReport| fPrintReport( oReport ) }

Local oBreakPg
Local oSection1
Local cProg   := "REL01SZJ"
Local cPerg   := "REL_01_SZJ"

//Cria pergunta
//fCriaSX1(cPerg)

Pergunte( cPerg , .T. )

//-- Objeto Function
oReport:= TReport():New(cProg, cTitulo, cPerg , bReport, cDescri,.T.,,.F.,,.T.)

//-- Section
DEFINE SECTION oSection1 OF oReport TABLES "SZJ","SE1" TITLE OemToAnsi(cTitulo) TOTAL IN COLUMN ORDERS aOrd

//-- Inicio definicao do Relatorio
oReport:SetLandscape()
oSection1:SetHeaderBreak(.T.)

// CELL HEADER BORDER
DEFINE CELL HEADER BORDER OF oSection1 EDGE_BOTTOM WEIGHT 1

DEFINE CELL NAME "ZJ_FILIAL"  OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_NUMCHAM" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_PRIORID" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_STATUS"  OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_DT_INC"  OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_HR_INC"  OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_DT_FECH" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_HR_FECH" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_NOMECAT" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_ASSUNTO" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_NOMETEC" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_NOMESOL" OF oSection1 ALIAS cString
DEFINE CELL NAME "ZJ_DPTOSOL" OF oSection1 ALIAS cString

oSection1:Cell("ZJ_FILIAL"):Disable()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPrintReportบAutor  ณTiago Malta         บ Data ณ  09/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPrintReport(oReport)
'
//-- Objeto
Local oSection1 := oReport:Section(1)
Local nOrdRpt   := oSection1:GetOrder()

//-- String
Local cFiltro   := ""
Local cSitQuery := ""
Local cCatQuery := ""
Local cOrdem    := ""
Local cQrySZJ   := "SZJ"
Local oBreakFil
Local cTitFun
Local nReg      := 0
Local cPrefx    := ""
Local cAliasAux := ""

//Tratamento pra evitar error log de indices
oSection1:aOrder     := {}

oReport:CTITLE := "Rela็ใo de Chamados"

cQuery := " SELECT ZJ_FILIAL, ZJ_NUMCHAM, ZJ_PRIORID, ZJ_STATUS, ZJ_DT_INC, ZJ_HR_INC, ZJ_DT_FECH, ZJ_HR_FECH, ZJ_NOMECAT, ZJ_ASSUNTO, ZJ_NOMETEC, ZJ_NOMESOL, ZJ_DPTOSOL "
cQuery += " FROM "	+ RetSqlName("SZJ") + " SZJ "
cQuery += " WHERE SZJ.D_E_L_E_T_ = '' "

If !Empty(MV_PAR01)
cQuery += " AND Upper(ZJ_COD_SOL) = '"+Upper(MV_PAR01)+"' "
EndIf

If !Empty(MV_PAR02)
cQuery += " AND Upper(ZJ_COD_CAT) = '"+Upper(MV_PAR02)+"' "
EndIf

If !Empty(MV_PAR03)
cQuery += " AND Upper(ZJ_COD_TEC) = '"+Upper(MV_PAR03)+"' "
EndIf

If !Empty(MV_PAR04)
cQuery += " AND Upper(ZJ_DPTOSOL) LIKE '%"+Upper(MV_PAR04)+"%' "
EndIf

If !Empty(MV_PAR05)
cQuery += " AND ZJ_DT_INC >= '"+DtoS(MV_PAR05)+"' "
EndIf

If !Empty(MV_PAR06)
cQuery += " AND ZJ_DT_INC <= '"+DtoS(MV_PAR06)+"' "
EndIf

If !Empty(MV_PAR07)
cQuery += " AND ZJ_DT_FECH >= '"+DtoS(MV_PAR07)+"' "
EndIf

If !Empty(MV_PAR08)
cQuery += " AND ZJ_DT_FECH <= '"+DtoS(MV_PAR08)+"' "
EndIf

Do Case
	Case MV_PAR09 == 1
		cQuery += " AND ZJ_STATUS = 'P' "

	Case MV_PAR09 == 2
		cQuery += " AND ZJ_STATUS = 'A' "

	Case MV_PAR09 == 3
		cQuery += " AND ZJ_STATUS = 'F' "
EndCase

Do Case
	Case nOrdRpt == 1
		cQuery += " ORDER BY ZJ_NUMCHAM "
	Case nOrdRpt == 2
		cQuery += " ORDER BY ZJ_STATUS "
	Case nOrdRpt == 3
		cQuery += " ORDER BY ZJ_NOMECAT "
	Case nOrdRpt == 4
		cQuery += " ORDER BY ZJ_DT_INC "
	Case nOrdRpt == 5
		cQuery += " ORDER BY ZJ_NOMESOL "
	Case nOrdRpt == 6
		cQuery += " ORDER BY ZJ_DPTOSOL "
EndCase

cQuery 		:= ChangeQuery(cQuery)

IF Select(cQrySZJ) > 0
	(cQrySZJ)->( DBCLOSEAREA() )
ENDIF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQrySZJ)
TCSetField(cQrySZJ, "ZJ_DT_INC" , "D", 8, 0)
TCSetField(cQrySZJ, "ZJ_DT_FECH", "D", 8, 0)

Do Case
	Case nOrdRpt == 1
		DEFINE BREAK oBreakFil  OF oSection1  WHEN  oSection1:Cell("ZJ_FILIAL") TITLE OemToAnsi("Total:")
	Case nOrdRpt == 2
		DEFINE BREAK oBreakFil  OF oSection1  WHEN  oSection1:Cell("ZJ_STATUS") TITLE OemToAnsi("Total:")
	Case nOrdRpt == 3
		DEFINE BREAK oBreakFil  OF oSection1  WHEN  oSection1:Cell("ZJ_NOMECAT") TITLE OemToAnsi("Total:")
	Case nOrdRpt == 4
		DEFINE BREAK oBreakFil  OF oSection1  WHEN  oSection1:Cell("ZJ_DT_INC") TITLE OemToAnsi("Total:")
	Case nOrdRpt == 5
		DEFINE BREAK oBreakFil  OF oSection1  WHEN  oSection1:Cell("ZJ_NOMESOL") TITLE OemToAnsi("Total:")
	Case nOrdRpt == 6
		DEFINE BREAK oBreakFil  OF oSection1  WHEN  oSection1:Cell("ZJ_DPTOSOL") TITLE OemToAnsi("Total:")
EndCase

oBreakFil:OnBreak({|x,y|cTitFun:=OemToAnsi("Total:")})  //+" "+x})
oBreakFil:SetTotalText({||cTitFun})
oBreakFil:SetTotalInLine(.f.)

//-- Define o total da regua da tela de processamento do relatorio
oReport:SetMeter((cQrySZJ)->( RecCount() ))

//-- Impressao na quebra de pagina - Impressao das informacoes da Empresa e Filial
//oReport:OnPageBreak({||(oReport) })

//-- Impressao do Relatorio
oSection1:Print()

IF SELECT("SZJ") > 0
	SZJ->( DBCLOSEAREA() )
ENDIF

Return NIL   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaSX1  บAutor ณ Felipe A. Melo     บ Data ณ  18/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSX1(cPerg)

Local aPergs := {}

aAdd(aPergs,{"Cod.Solicitante"    ,"Cod.Solicitante"    ,"Cod.Solicitante"    ,"mv_ch1","C",06,00,00	,"C","","mv_par01",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","","USR",""})
aAdd(aPergs,{"Cod.Categoria"      ,"Cod.Categoria"      ,"Cod.Categoria"      ,"mv_ch2","C",06,00,00	,"G","","mv_par02",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","","Z2" ,""})
aAdd(aPergs,{"Cod.Tecnico"        ,"Cod.Tecnico"        ,"Cod.Tecnico"        ,"mv_ch3","C",06,00,00	,"G","","mv_par03",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","","Z2" ,""})
aAdd(aPergs,{"Descr.Departamento" ,"Descr.Departamento" ,"Descr.Departamento" ,"mv_ch4","C",30,00,00	,"G","","mv_par04",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","",""   ,""})
aAdd(aPergs,{"Abert.Chamado De"   ,"Abert.Chamado De"   ,"Abert.Chamado De"   ,"mv_ch5","D",08,00,00	,"G","","mv_par05",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","",""   ,""})
aAdd(aPergs,{"Abert.Chamado At้"  ,"Abert.Chamado At้"  ,"Abert.Chamado At้"  ,"mv_ch6","D",08,00,00	,"G","","mv_par06",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","",""   ,""})
aAdd(aPergs,{"Fecham.Chamado De"  ,"Fecham.Chamado De"  ,"Fecham.Chamado De"  ,"mv_ch7","D",08,00,00	,"G","","mv_par07",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","",""   ,""})
aAdd(aPergs,{"Fecham.Chamado At้" ,"Fecham.Chamado At้" ,"Fecham.Chamado At้" ,"mv_ch8","D",08,00,00	,"G","","mv_par08",""        ,""        ,""        ,"","",""              ,""              ,""              ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","",""   ,""})
aAdd(aPergs,{"Status"             ,"Status"             ,"Status"             ,"mv_ch9","N",01,00,01	,"C","","mv_par09","Pendente","Pendente","Pendente","","","Em atendimento","Em atendimento","Em atendimento","","","Fechado"       ,"Fechado"       ,"Fechado"       ,"","","Todos","Todos","Todos","","","","","","",""   ,""})

AjustaSx1(cPerg,aPergs)

Return