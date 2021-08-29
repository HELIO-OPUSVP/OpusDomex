#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELMENU  ºAutor  ³Osmar Ferreira      º Data ³  02/06/20    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Acessos por usuário		                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RELMENU()

	Local oReport
	Private _cPerg :="RELMENU"

	fCriaPerg()
	If Pergunte(_cPerg,.T.)
		oReport:=ReportDef()
		oReport:PrintDialog()
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função principal Relatório.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ReportDef()
	Local oReport
	Local oSection
	//Local oBreak

	oReport:=TReport():New("RELMENU","Acessos do Usuário. " ,"RELMENU",{|oReport| PrintReport(oReport)},"Acessos do usuário")

	oReport:SetLineHeight(40)
	oReport:nFontBody:=08   // 08
	oReport:lParamPage := .F.

	oReport:SetLandscape() 	  			// Retrato
	oReport:opage:SetPaperSize(9)  	// Papel A4
//	oReport:opage:SetPaperSize(8) 	//  Papel A3
	oReport:cFontBody:='Courier New'

	oSection   :=TRSection():New(oReport,"Acessos do Usuário ",{})

	TRCell():New(oSection,"USR_ID"     ,,"ID_USUARIO"  , ,006,.F.,)
	TRCell():New(oSection,"USR_CODIGO" ,,"COD_USUARIO" , ,040,.F.,)
	TRCell():New(oSection,"USR_NOME"   ,,"NOME"        , ,050,.F.,)
	TRCell():New(oSection,"USR_DEPTO"  ,,"DEPTO"       , ,020,.F.,)
	TRCell():New(oSection,"USR_EMAIL"  ,,"E-MAIL"      , ,040,.F.,)
	TRCell():New(oSection,"USR_MSBLQL" ,,"BLOQUEADO"   , ,003,.F.,)
	TRCell():New(oSection,"USR_MODULO" ,,"ID_MODULO"   , ,006,.F.,)
	TRCell():New(oSection,"USR_CODMOD" ,,"MODULO"      , ,040,.F.,)
	TRCell():New(oSection,"M_NAME" 	   ,,"MENU"        , ,010,.F.,)
	TRCell():New(oSection,"USR_NIVEL"  ,,"NIVEL"       , ,001,.F.,)
	TRCell():New(oSection,"GR__NOME"   ,,"GRUPO"	   , ,040,.F.,)

	TRCell():New(oSection,"N_DESC"     ,,"DESCRICAO"   , ,040,.F.,)
	TRCell():New(oSection,"F_FUNCTION" ,,"FUNCAO"      , ,010,.F.,)
	//TRCell():New(oItSection,"I_TABLES"   ,,"TABELAS"     , ,050,.F.,)
	//TRCell():New(oSection,"I_ACCESS"   ,,"ACESSOS"     , ,015,.F.,)
	//TRCell():New(oSection,"I_ORDER"      ,,"ORDEM"       , ,003,.F.,)
	//TRCell():New(oSection,"I_TP_MENU"    ,,"TP_MENU"     , ,001,.F.,)

//oBreak := TRBreak():New(oSection,oSection:Cell("B1_DESC"),,.F.)
//TRFunction():New(oSection:Cell("B1_COD"),"Qtd. ítens","COUNT",,,"@E 999,999",,.T.,.F.,.F.,oSection)    // F T F

Return oReport

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função de filtro dos Dados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function PrintReport(oReport)

	//Local cPart
	//Local cFiltro    := ""
	Local nRecno     := 0
	Private _cAlias	 :=  GetNextAlias()
	Private oSection := oReport:Section(1)
	Private nOrdem   := oSection:GetOrder()

//	oReport:SetLandscape() 	 		// Retrato
//	oReport:opage:SetPaperSize(9)  	// Papel A4

	oSection:Init()
	oSection:SetTotalInLine(.F.)

	xQuery1()

	nRecno := 0
	(_cAlias)->( dbEval({|| nRecno++}) )

	(_cAlias)->( dbGoTop() )

	oReport:SetMeter(nRecno)

	dbSelectArea(_cAlias)

	While !oReport:Cancel() .And. (_cAlias)->(!Eof()) //.And. cUsuario == (_cAlias)->ID_USUARIO

		If oReport:Cancel()
			Exit
		EndIf

		If !Empty(mv_par05)
			If !(StrZero((_cAlias)->ID_MODULO,2) $ mv_par05)
				(_cAlias)->(dbSkip() )
				oReport:IncMeter()
				Loop
			EndIF
		EndIf

		oSection:Cell("USR_ID")		:SetValue((_cAlias)->ID_USUARIO  )
		oSection:Cell("USR_CODIGO")	:SetValue((_cAlias)->COD_USUARIO )
		oSection:Cell("USR_NOME")	:SetValue((_cAlias)->NOME   	 )
		oSection:Cell("USR_DEPTO")	:SetValue((_cAlias)->DEPTO  	 )
		oSection:Cell("USR_EMAIL")	:SetValue((_cAlias)->E_MAIL    	 )
		oSection:Cell("USR_MSBLQL")	:SetValue((_cAlias)->BLOQUEADO   )
		oSection:Cell("USR_MODULO")	:SetValue((_cAlias)->ID_MODULO   )
		oSection:Cell("USR_CODMOD")	:SetValue((_cAlias)->MODULO   	 )
		oSection:Cell("M_NAME")		:SetValue((_cAlias)->MENU		 )
		oSection:Cell("USR_NIVEL")	:SetValue((_cAlias)->NIVEL   	 )
		oSection:Cell("GR__NOME")   :SetValue((_cAlias)->GRUPO		 )

		oSection:Cell("N_DESC")		:SetValue((_cAlias)->DESCRICAO   )
		oSection:Cell("F_FUNCTION")	:SetValue((_cAlias)->FUNCAO  	 )
		//oItSection:Cell("I_TABLES")	:SetValue((_cAlias)->TABELAS   	 )
		//oSection:Cell("I_ACCESS")	:SetValue((_cAlias)->ACESSOS  	 )
		//oSection:Cell("I_ORDER")	:SetValue((_cAlias)->ORDEM  	 )
		//oSection:Cell("I_TP_MENU")	:SetValue((_cAlias)->TP_MENU   	 )

		oSection:PrintLine()

		oReport:IncMeter()

		(_cAlias)->(dbSkip()	)

		oReport:Skipline()
		//oReport:Thinline()
		//oReport:Skipline()

	EndDo

	oReport:EndPage()

	// Finaliza Secao e Imprime o Total Geral, Definido no TRFUNCTION
	oSection:Finish()
	////oItSection:Finish()
	oReport:EndPage()
Return


Static Function fCriaPerg()
	aSvAlias:={Alias(),IndexOrd(),Recno()}
	i:=j:=0
	aRegistros:={}
	_cPerg := PADR(_cPerg,10)
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
	AADD(aRegistros,{_cPerg,"01","Do  Usuário?     ","","","mv_ch1","C",08,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","",""})
	AADD(aRegistros,{_cPerg,"02","Nome             ","","","mv_ch2","C",08,00,00,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{_cPerg,"03","Até Usuário?     ","","","mv_ch3","C",08,00,00,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","USR","","","","",""})
	AADD(aRegistros,{_cPerg,"04","Nome             ","","","mv_ch4","C",08,00,00,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{_cPerg,"05","Módulos          ","","","mv_ch5","C",50,00,00,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query com Notas Fiscais /Itens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function xQuery1

	MakeSqlExpr(_cAlias)
	oSection:BeginQuery()
	//oItSection:BeginQuery()

	BeginSql alias _cAlias

	Select  Usuario.USR_ID As 'ID_USUARIO' , Usuario.USR_CODIGO As 'COD_USUARIO', Usuario.USR_NOME As 'NOME', 
			Usuario.USR_DEPTO As 'DEPTO', Usuario.USR_EMAIL As 'E_MAIL', 
			(Case When Usuario.USR_MSBLQL = '2' Then 'Não' Else 'Sim' End) As 'BLOQUEADO',
			Modulo.USR_MODULO As 'ID_MODULO', Modulo.USR_CODMOD As 'MODULO', Modulo.USR_NIVEL As 'NIVEL', 
			FUNCAO.F_FUNCTION As 'FUNCAO',
			(Case When ITEM.I_TP_MENU = '1' Then  MENU.N_DESC Else '   '+MENU.N_DESC End) AS 'DESCRICAO',
			GRP.GR__NOME As 'GRUPO',
			ITEM.I_TABLES As 'TABELAS', ITEM.I_ACCESS As 'ACESSOS',
			ITEM.I_ORDER As 'ORDEM', ITEM.I_TP_MENU As 'TP_MENU',
			IDMENU.M_NAME As 'MENU'
	From SYS_USR Usuario (Nolock)
	Inner Join SYS_USR_MODULE Modulo       (Nolock) On Usuario.USR_ID     = Modulo.USR_ID   And Modulo.D_E_L_E_T_ = ''				
	Left Outer Join SYS_USR_GROUPS UGRP	   (Nolock) On Usuario.USR_ID = UGRP.USR_ID And UGRP.D_E_L_E_T_ = ''
	Left Outer Join SYS_GRP_GROUP GRP	   (Nolock) On UGRP.USR_GRUPO = GRP.GR__ID And GRP.D_E_L_E_T_ = ''
	Left Outer Join MPMENU_ITEM ITEM       (Nolock) On Modulo.USR_ARQMENU = ITEM.I_ID_MENU  And ITEM.D_E_L_E_T_ = ''					
	Left Outer Join MPMENU_I18N MENU       (Nolock) On ITEM.I_ID = MENU.N_PAREN_ID And N_LANG = 1 And MENU.D_E_L_E_T_ = ''	
	Left Outer Join MPMENU_FUNCTION FUNCAO (Nolock) On ITEM.I_ID_FUNC     = FUNCAO.F_ID     And FUNCAO.D_E_L_E_T_ = ''
	Left Outer Join MPMENU_MENU IDMENU	   (Nolock) On ITEM.I_ID_MENU = IDMENU.M_ID And IDMENU.D_E_L_E_T_ = ''
	Where Usuario.D_E_L_E_T_ = ''   And   
		  Usuario.USR_ID Between %Exp:mv_par01% And %Exp:mv_par03% And     
	  	  Modulo.USR_ACESSO = 'T'   	    	    
	Order By Usuario.USR_ID, Modulo.USR_MODULO, ITEM.I_ORDER

	EndSql

	oSection:EndQuery()
	///oItSection:EndQuery()

Return(_cAlias)
