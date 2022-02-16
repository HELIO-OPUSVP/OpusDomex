#Include "Protheus.ch"
#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA04   บAutor  ณHelio Ferreira      บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ  
ฑฑบAlteracao ณRFATA04   บ       ณmauresi             บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Manutencao de Previsao de Faturamento            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex - SIGAFAT                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATA04()

	Local aArea				:= GetArea()
	Local cGetOpc
	Local cLinhaOk
	Local cTudoOk
	Local cIniCpos
	Local nFreeze
	Local nMax
	Local cCampoOk
	Local cSuperApagar
	Local cApagaOk
	Local aButtons 		:= {}
	Local cQryResid		:= ""

	Private aHeader		:= {}
	Private aCols		:= {}
	Private nUsado		:= 0
	Private dGetDataAte := Date()
	Private dGetDataDe 	:= Date()
	Private cGetPedido 	:= Space(6)
	Private dGetData 	:= Date()
	Private nGetQuanti 	:= 0
	Private cComboBox1 	:= "Pedido"
	Private cComboBox2 	:= "Nใo"
	Private cGetPCli    := Space(20)
	Private cGetNCli    := Space(20)
	Private cGetElabo   := Space(15)

	Static oGetPCli
	Static oGetNCli
	Static oDlg, oGet
	Static oGetDataAte

	Static oGetDataDe
	Static oGetData
	Static oGetQuanti
	Static oGetPedido
	Static oGetElabo

	Static oGroup1
	Static oSay1
	Static oSay2
	Static oSay3, oSay4, oSay5, oSay6, oSay7, oSay8
	Static oBtnFiltro
	Static oComboBox1
	Static oComboBox2
	cMotivo				:= Space(254)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ}
	//ณDefien Grupos de usuแrios Para acessos aos Campos e Rotinas                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ}

	// Administradores
	cAdmin := "000000 - ADMINISTRADOR"
	cAdmin += "000206 - DENIS"
	cAdmin += "000211 - HELIO OPUS"
	cAdmin += "000373 - MARCO OPUS"
	cAdmin += "000709 - OSMAR OPUS"


	// Altera PCP
	cGrupo1 := cAdmin
	cGrupo1 += "000343 - CAMILA MORENO"
	cGrupo1 += "000087 - DEBORA"
	cGrupo1 += "000312 - KEROLYNE PESTANA"      // Adicionado em 17/07/2019
	cGrupo1 += "000618 - EDER"  			    // Adicionado em 19/12/2019
	cGrupo1 += "000464 - NILDA"
	cGrupo1 += "000073 - PAULO CELESTINO"      // Adicionado em 27/11/2019
	cGrupo1 += "000194 - VANESSA"
	cGrupo1 += "000931 - LIVIA RUFINO"	         // Adicionado em 17/06/2021  - Chamado 025037
	cGrupo1 += "000994 - ANDREIA BATISTA"	     // Adicionado em 29/07/2021  - Chamado 026107


	// Altera OTD
	cGrupo2 := cAdmin
	cGrupo2 += "000084 - DAYSE PACHOAL"
	cGrupo2 += "000257 - JOSE ARAUJO"
	cGrupo2 += "000909 - CAMILA CAMPOS"
	cGrupo2 += "000876 - GUILHERME PEREIRA"


	// Altera Entrega
	cGrupo3 := cAdmin
	cGrupo3 += "000265 - ALAN CEPINHO"
	cGrupo3 += "000592 - ALINE MELO"
	cGrupo3 += "000909 - CAMILA CAMPOS"
	cGrupo3 += "000602 - CLAUDIO VINICIUS"
	cGrupo3 += "000084 - DAYSE PACHOAL"
	cGrupo3 += "000621 - DENISE DAMACENO"
	cGrupo3 += "000112 - FABIANA SANTOS"
	cGrupo3 += "000157 - FARLEI SANTOS"
	cGrupo3 += "000098 - FABIO RENNO"
	cGrupo3 += "000515 - FERNANDA REIS"
	cGrupo3 += "001055 - GABRIELA PRADO"              // Adicionado em 15/12/2021 - chamado 029662
	cGrupo3 += "000053 - GEISE VALERIA"
	cGrupo3 += "000876 - GUILHERME PEREIRA"
	cGrupo3 += "000267 - HELENA FERRAZ"
	cGrupo3 += "000312 - KEROLYNE PESTANA"
	cGrupo3 += "000618 - EDER"  			    // Adicionado em 19/12/2019
	cGrupo3 += "000599 - LETICIA SOUZA"
	cGrupo3 += "000239 - LUIS OLIVEIRA"
	cGrupo3 += "000355 - MARGARETE SANTOS"
	cGrupo3 += "000753 - JULIA NABA"  	         // Adicionado em 26/10/2020  - Chamado 021660
	cGrupo3 += "000418 - MARILIA GABRIELA"
	cGrupo3 += "000589 - NATASHA SILVA"
	cGrupo3 += "000271 - SERGIO UCHIMURA"
	cGrupo3 += "000651 - WILLIANS PEREIRA"
//	cGrupo3 += "000931 - LIVIA RUFINO"	         // Adicionado em 16/06/2021  - Chamado 025037
	cGrupo3 += "001001 - IVANA VILAS BOAS"       // Adiciona em 09/08/2021  - Chamado 026406




	Aadd( aButtons, {"HISTORIC", {|| SepararPrevisao()}, "Separar Previsao"		, "Separar Previsao"	, {|| .T.}} )
	Aadd( aButtons, {"HISTORIC", {|| ExcluirPrevisao()}, "Excluir Previsao"		, "Excluir Previsao"	, {|| .T.}} )
	if __CUSERID $ cGrupo3
		Aadd( aButtons, {"HISTORIC", {|| AltDtPRV()}	, "Altera Dt Prev"  	, "Altera Dt Prev" 		, {|| .T.}} )
		Aadd( aButtons, {"HISTORIC", {|| AltDtEnt()}	, "Altera Dt Entrega"  	, "Altera Dt Entrega" 	, {|| .T.}} )
	endif
	if __CUSERID $ cGrupo1
		Aadd( aButtons, {"HISTORIC", {|| AltDtPCP()}	, "Altera Dt PCP"   	, "Altera Dt PCP" 			, {|| .T.}} )
		Aadd( aButtons, {"HISTORIC", {|| AltDtPRV()}	, "Altera Dt Prev"  	, "Altera Dt Prev" 			, {|| .T.}} )
	endif
	if __CUSERID $ cGrupo2
		Aadd( aButtons, {"HISTORIC", {|| AltDtOTD()}	, "Altera Dt OTD"   	, "Altera Dt OTD" 			, {|| .T.}} )
	endif

	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SZY"))

	SetKey(VK_F5, {|| MsgRun("Processando","Atualizando Informa็๕es",{|| Atu_aCols()})})

/*
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SZY"
		If X3USO(SX3->X3_USADO)
         // campos Desconsiderados no Browse
			If !( AllTrim(SX3->X3_CAMPO) $ ("ZY_FILIAL,ZY_DATA2,ZY_MOTOTD")  )
				nUsado ++
				aAdd(aHeader,{	AllTrim(X3Titulo()),;
								SX3->X3_CAMPO,;
								SX3->X3_PICTURE,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								SX3->X3_VALID,;
								SX3->X3_USADO,;
								SX3->X3_TIPO,;
								SX3->X3_ARQUIVO,;
								,,Nil})
			EndIf
		EndIf
		SX3->(DbSkip())
	EndDo
	
	nUsado ++ 
	aAdd(aHeader,{	AllTrim("Dt. Cliente"),;
							"C6_ENTREG",;
							"",;
							8,;
							0,;
							"",;
							SX3->X3_USADO,;
							"D",;
							"SC6",;
							,,Nil})  	

	aAdd(aCols,Array(nUsado+1))
 */  
//	aAdd(aHeader,{	AllTrim(X3Titulo()),	SX3->X3_CAMPO,	SX3->X3_PICTURE,SX3->X3_TAMANHO,	SX3->X3_DECIMAL,	SX3->X3_VALID,	SX3->X3_USADO,	SX3->X3_TIPO,SX3->X3_ARQUIVO,,,Nil})

/*
	aAdd(aHeader,{"Pedido"			,	"ZY_PEDIDO"	,	"",	6	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //1
	aAdd(aHeader,{"Item"			,	"ZY_ITEM"	,	"",	2	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //2 
	aAdd(aHeader,{"Codigo"			,	"A1_COD"	,	"",	06	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SA1",,,Nil})   
	aAdd(aHeader,{"Loja"			,	"A1_LOJA"	,	"",	02	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SA1",,,Nil})   	
	aAdd(aHeader,{"N Fantasia"		,	"A1_NREDUZ"	,	"",	20	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SA1",,,Nil})   
	aAdd(aHeader,{"Produto"			,	"ZY_PRODUTO",	"",	15	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //4     
	aAdd(aHeader,{"Desc.Produto"	,	"ZY_DESC"	,	"",	60	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //5
	aAdd(aHeader,{"Unid.Medida" 	,	"ZY_UM"		,	"",	2	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //6
	aAdd(aHeader,{"Quantidade"	 	,	"ZY_QUANT"	,	"",	11	,	4,	"",	"€€€€€€€€€€€€€€",	"N",	"SZY",,,Nil})   //7
	aAdd(aHeader,{"Qtde.Entrega"	,	"ZY_QUJE"	,	"",	11	,	4,	"",	"€€€€€€€€€€€€€€",	"N",	"SZY",,,Nil})   //8  
	aAdd(aHeader,{"Dt.PCP"	 		,	"ZY_DTPCP"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})   //11		
	aAdd(aHeader,{"Dt.Prev.Fatu"	,	"ZY_PRVFAT"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})   //9
	aAdd(aHeader,{"Dt.Entrega" 		,	"ZY_DTFATUR",	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})   //10
	aAdd(aHeader,{"Dt.OTD"			,	"ZY_DTOTD"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})	 //16 
	aAdd(aHeader,{"Dt.Cliente"		,	"C6_ENTREG"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SC6",,,Nil}) 	 //17	
	aAdd(aHeader,{"Nota Fiscal"		,	"ZY_NOTA"	,	"",	9	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})	 //12
	aAdd(aHeader,{"Serie"			,	"ZY_SERIE"	,	"",	3	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //13
	aAdd(aHeader,{"Item da Nota" 	,	"ZY_ITEMNF"	,	"",	2	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //14
//	aAdd(aHeader,{"Loc.Entrega"		,	"ZY_LOCENTR",	"",	20	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //15
	aAdd(aHeader,{"Seq"				,	"ZY_SEQ"	,	"",	3	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //3
*/

	aAdd(aHeader,{"Pedido"			,	"ZY_PEDIDO"	,	"",	6	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //1
	aAdd(aHeader,{"Item"			,	"ZY_ITEM"	,	"",	2	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //2
	aAdd(aHeader,{"N Fantasia"		,	"A1_NREDUZ"	,	"",	20	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SA1",,,Nil})
	aAdd(aHeader,{"Produto"			,	"ZY_PRODUTO",	"",	15	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //4
	aAdd(aHeader,{"Desc.Produto"	,	"ZY_DESC"	,	"",	60	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //5
	aAdd(aHeader,{"Quantidade"	 	,	"ZY_QUANT"	,	"",	11	,	4,	"",	"€€€€€€€€€€€€€€",	"N",	"SZY",,,Nil})   //7
	aAdd(aHeader,{"Dt.PCP"	 		,	"ZY_DTPCP"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})   //11
	aAdd(aHeader,{"Dt.Prev.Fatu"	,	"ZY_PRVFAT"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})   //9
	aAdd(aHeader,{"Dt.Entrega" 		,	"ZY_DTFATUR",	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})   //10
	aAdd(aHeader,{"Dt.OTD"			,	"ZY_DTOTD"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SZY",,,Nil})	 //16
	aAdd(aHeader,{"Dt.Cliente"		,	"C6_ENTREG"	,	"",	8	,	0,	"",	"€€€€€€€€€€€€€€",	"D",	"SC6",,,Nil}) 	 //17
	aAdd(aHeader,{"Nota Fiscal"		,	"ZY_NOTA"	,	"",	9	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})	 //12
	aAdd(aHeader,{"Serie"			,	"ZY_SERIE"	,	"",	3	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //13
	aAdd(aHeader,{"Item da Nota" 	,	"ZY_ITEMNF"	,	"",	2	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //14
//	aAdd(aHeader,{"Loc.Entrega"		,	"ZY_LOCENTR",	"",	20	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //15
	aAdd(aHeader,{"Seq"				,	"ZY_SEQ"	,	"",	3	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //3

	// Alterado em 06/01/2020 - Chamado 017507
	aAdd(aHeader,{"Codigo"			,	"A1_COD"	,	"",	06	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SA1",,,Nil})
	aAdd(aHeader,{"Loja"			,	"A1_LOJA"	,	"",	02	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SA1",,,Nil})
	aAdd(aHeader,{"Unid.Medida" 	,	"ZY_UM"		,	"",	2	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SZY",,,Nil})   //6
	aAdd(aHeader,{"Qtde.Entrega"	,	"ZY_QUJE"	,	"",	11	,	4,	"",	"€€€€€€€€€€€€€€",	"N",	"SZY",,,Nil})   //8

	//19/01/21 - Altera็ใo Chamado 021382
	aAdd(aHeader,{"Ped.Cliente"	,	"C5_ESP1"	,	"",	40	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SC5",,,Nil})   //
	aAdd(aHeader,{"Elaborador"	,	"C5_ELABORA",	"",	15	,	0,	"",	"€€€€€€€€€€€€€€",	"C",	"SC5",,,Nil})   //

	nUsado	:= len(aHeader)
	aAdd(aCols,Array(nUsado+1))

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Programa็ใo de Faturamento")  FROM 000, 000  TO 700, 1400 COLORS 0, 16777215 PIXEL

	@ 032, 003 GROUP oGroup1 TO 078, 649 PROMPT "Filtros" OF oDlg COLOR 0, 16777215 PIXEL
	@ 049, 009 SAY oSay1 PROMPT "Data de:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 009 MSGET oGetDataDe VAR dGetDataDe SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 049, 075 SAY oSay2 PROMPT "Data Ate:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 075 MSGET oGetDataAte VAR dGetDataAte SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 049, 140 SAY oSay3 PROMPT "Pedido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 140 MSGET oGetPedido VAR cGetPedido F3 "SC5" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 049, 205 SAY oSay4 PROMPT "Ordem:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 205 MSCOMBOBOX oComboBox1 VAR cComboBox1 ITEMS {"Pedido","Data de Previsao"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 049, 285 SAY oSay5 PROMPT "Itens Faturados:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 285 MSCOMBOBOX oComboBox2 VAR cComboBox2 ITEMS {"Nใo","Sim"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 049, 360 SAY oSay6 PROMPT "Pedido Cliente:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 360 MSGET oGetPCli VAR cGetPCli SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 049, 435 SAY oSay7 PROMPT "Nome Fantasia:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 435 MSGET oGetNCli VAR cGetNCli SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 049, 510 SAY oSay8 PROMPT "Elaborador:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 510 MSGET oGetElabo VAR cGetElabo SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL


	@ 057, 590 BUTTON oBtnFiltro PROMPT "Aplicar Filtro (F5)" ACTION {||MsgRun("Processando","Atualizando Informacoes",{|| Atu_aCols()})} SIZE 047, 012 OF oDlg PIXEL

	cGetOpc        := GD_UPDATE			// GD_INSERT+GD_DELETE+GD_UPDATE
	cLinhaOk       := "AllwaysTrue"		// Funcao executada para validar o contexto da linha atual do aCols
	cTudoOk        := "AllwaysTrue"   	// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	cIniCpos       := "+ZY_PEDIDO/ZY_SEQ/ZY_ITEM/ZY_PRODUTO/ZY_DESC/ZY_UM/ZY_PRVFAT/ZY_LOCENTR"         // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	nFreeze        := Nil               // Campos estaticos na GetDados.
	nMax           := 99999             // Numero maximo de linhas permitidas. Valor padrao 99
	cCampoOk       := "U_RFAT04A()"   	// Funcao executada na validacao do campo
	cSuperApagar   := Nil               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	cApagaOk       := Nil               // Funcao executada para validar a exclusao de uma linha do aCols

	// Define Campos Editaveis de acordo com Grupo de Acesso do usuario
	cCmpEdit	:= {}
	if __CUSERID $ cGrupo1           // PCP
		aadd(cCmpEdit,"ZY_DTPCP")
		aadd(cCmpEdit,"ZY_PRVFAT")	     // Adicionado em 22/04/2019
	endif
	if  __CUSERID $ cGrupo2      		// OTD
		aadd(cCmpEdit,"ZY_DTOTD")
	Endif
	if  __CUSERID $ cGrupo3      		// Entrega
		aadd(cCmpEdit,"ZY_PRVFAT")
		aadd(cCmpEdit,"ZY_DTFATUR")
	Endif

	oGet := MsNewGetDados():New( 080, 003, 290, 650,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,cCmpEdit,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDlg,aHeader,aCols)

	MsgRun("Processando","Atualizando Informacoes",{|| Atu_aCols()})

	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,@aButtons))

	RestArea(aArea)

Return

Static Function Atu_aCols()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO"})
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"})
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"})
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"})
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"})   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"}) 		// DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"})
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"})

	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local nI		:= 0
	Local nX		:= 0

	oGet:aCols := {}

	cQuery := "SELECT * FROM " + RetSqlName("SZY") + " SZY "
	//03/08/21 - Osmar - incluํda a filial no Join
	cQuery += "	INNER JOIN " + RetSqlName("SC6") + " SC6 ON ZY_FILIAL = C6_FILIAL And ZY_PEDIDO = C6_NUM AND ZY_ITEM = C6_ITEM "

	//19/01/21 - Altera็ใo Chamado 021382
	cQuery += "	INNER JOIN " + RetSqlName("SC5") + " SC5 ON ZY_FILIAL = C5_FILIAL And ZY_PEDIDO = C5_NUM And SC5.D_E_L_E_T_ = ''"

	cQuery += "	LEFT JOIN " + RetSqlName("SA1") + " SA1 ON C6_CLI+C6_LOJA = A1_COD+A1_LOJA "
	cQuery += "		WHERE ZY_FILIAL = '" + xFilial("SZY") + "'"
	If cComboBox2 == "Nใo"
		cQuery += "       AND ZY_NOTA = '' "
	EndIf
	cQuery += "			AND SZY.D_E_L_E_T_ <> '*' "
	cQuery += "			AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += "			AND SA1.D_E_L_E_T_ <> '*' "
	cQuery += "	AND ZY_BLQ = '' "					//  Desconsidera Itens com Eliminacao de Residuo
	cQuery += " AND ZY_PRVFAT >= '" + DtoS(dGetDataDe) + "'"
	If !Empty(DtoS(dGetDataAte))
		cQuery += " AND ZY_PRVFAT <= '" + DtoS(dGetDataAte) + "'"
	EndIf
	If !Empty(cGetPedido)
		cQuery += "AND ZY_PEDIDO = '" + cGetPedido + "'"
	EndIF
	//19/01/21 - Altera็ใo Chamado 021382
	If !Empty(cGetPCli)
		//cQuery += "AND C5_ESP1 = '" + cGetPCli + "'"
		cQuery += "AND C5_ESP1 LIKE '" + AllTrim(cGetPCli) + "%'"
	EndIf
	If !Empty(cGetNCli)
		cQuery += "AND A1_NREDUZ LIKE '" + AllTrim(cGetNCli) + "%'"
	EndIf
	If !Empty(cGetElabo)
		cQuery += "AND UPPER(C5_ELABORA) LIKE '" + AllTrim(Upper(cGetElabo)) + "%'"
	EndIf

	If cComboBox1 == "Pedido"
		cQuery += " ORDER BY ZY_PEDIDO, ZY_ITEM, ZY_SEQ "
	Else
		cQuery += " ORDER BY ZY_PRVFAT, ZY_PEDIDO, ZY_ITEM, ZY_SEQ "
	EndIf

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery ), cAlias, .F., .T. )

	While (cAlias)->(!Eof())

		If Empty((cAlias)->ZY_DTFATUR)
			SZY->(DbSetOrder(1))
			SZY->(DbGoTo((cAlias)->R_E_C_N_O_))
			If SZY->ZY_PEDIDO == (cAlias)->ZY_PEDIDO .And. SZY->ZY_ITEM == (cAlias)->ZY_ITEM
				//If RecLock("SZY",.F.)
				//	SZY->ZY_DTFATUR := Posicione("SC6",1,xFilial("SC6")+AllTrim((cAlias)->ZY_PEDIDO)+AllTrim((cAlias)->ZY_ITEM),"C6_DTFATUR")
				//	SZY->(MsUnlock())
				//EndIf
			EndIf
		EndIf

		// Alimenta Campo Novo (ZY_DTPCP)
		If Empty((cAlias)->ZY_DTPCP)
			SZY->(DbSetOrder(1))
			SZY->(DbGoTo((cAlias)->R_E_C_N_O_))
			//If SZY->ZY_PEDIDO == (cAlias)->ZY_PEDIDO .And. SZY->ZY_ITEM == (cAlias)->ZY_ITEM
			//	If RecLock("SZY",.F.)
			//		SZY->ZY_DTPCP := Posicione("SC6",1,xFilial("SC6")+AllTrim((cAlias)->ZY_PEDIDO)+AllTrim((cAlias)->ZY_ITEM),"C6_ENTRE3")
			//		SZY->(MsUnlock())
			//	EndIf
			//EndIf
		EndIf

		// Alimenta DATA OTD, quando estแ vazio com Data faturamento e Data PCP preenchidos    // 10-05-2019
		If Empty((cAlias)->ZY_DTOTD)  .and. !Empty((cAlias)->ZY_DTFATUR)  .and. !Empty((cAlias)->ZY_DTPCP)
			SZY->(DbSetOrder(1))
			SZY->(DbGoTo((cAlias)->R_E_C_N_O_))
			If SZY->ZY_PEDIDO == (cAlias)->ZY_PEDIDO .And. SZY->ZY_ITEM == (cAlias)->ZY_ITEM

				If RecLock("SZY",.F.)
					//Para Huawei usa a data de previsใo para o OTD
					If ("HUAWEI" $ Upper( (cAlias)->A1_NOME)) .Or. ("HUAWEI" $ Upper((cAlias)->A1_NREDUZ))
						SZY->ZY_DTOTD := SZY->ZY_PRVFAT
					Else
						SZY->ZY_DTOTD := SZY->ZY_DTPCP
					EndIf


					SZY->(MsUnlock())
				EndIf
			EndIf
		EndIf

		(cAlias)->(DbSkip())

	EndDo

	(cAlias)->(DbCloseArea())

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery ), cAlias, .F., .T. )

	While (cAlias)->(!Eof())

		aAdd(oGet:aCols,Array(nUsado+1))
		nX ++

		For nI := 1 to Len(aHeader)

			If aHeader[nI][8] == "D"
				If AllTrim(aHeader[nI][2]) == "C6_ENTREG"
					oGet:aCols[nX][nI] := Posicione("SC6",1,xFilial("SC6")+AllTrim(oGet:aCols[nX][nPosPEDIDO])+AllTrim(oGet:aCols[nX][nPosITEMPD]),"C6_ENTREG")
				Else
					oGet:aCols[nX][nI] := StoD(&(cAlias + "->" + aHeader[nI][2]))
				EndIf
			Else
				oGet:aCols[nX][nI] := &(cAlias + "->" + aHeader[nI][2])
			EndIf

		Next nI
		oGet:aCols[nX][nUsado+1] := .F.

		(cAlias)->(DbSkip())
	EndDo

	(cAlias)->(DbCloseArea())

	oGet:Refresh()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออัออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSepararPrevisao บAutorณMicrosiga       บ Data ณ  03/29/19   บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออฯออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Separa a Previsao do Pedido                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SepararPrevisao()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO"})
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"})
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"})
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"})
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"})   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"}) 		// DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"})
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"})
	Local cPedido      		:= oGet:aCols[oGet:nAt][nPosPEDIDO] //oGet:aCols[oGet:nAt][1]
	Local cItemPd      		:= oGet:aCols[oGet:nAt][nPosITEMPD] //oGet:aCols[oGet:nAt][2]
	Local cSeqPed      		:= oGet:aCols[oGet:nAt][nPosSEQPED] //oGet:aCols[oGet:nAt][3]

	Local cUltSeq := "001"
	Local lOk	  := .F.

	If ApMsgYesNo("Deseja separar a previsใo do pedido: " + cPedido + " - " + cItemPd)

		DbSelectArea("SZY")
		SZY->(DbSetOrder(1))

		If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd))
			While SZY->(!Eof()) .And. ZY_PEDIDO == cPedido .And. ZY_ITEM == cItemPd
				cUltSeq	:= SZY->ZY_SEQ
				SZY->(DbSkip())
			EndDO
		EndIf

		lOk := TelaPRV("Deseja separar o pedido:" + cPedido + ", item: " + cItemPd + ", sequencia: " + cSeqPed,2)     // Tela Nova
		If lOk
			If nGetQuanti >= oGet:aCols[oGet:nAt][nPosQUANT]
				Alert("Quantidade invalida para separacao, a quantidade deve ser menor que a do item original.")
				Return
			Else

				If Empty(dGetData)
					Alert("Necessario informar uma data de previsao.")
					Return
				EndIf

				DbSelectArea("SZY")
				SZY->(DbSetOrder(1))
				SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd))
				While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == cPedido .And. SZY->ZY_ITEM == cItemPd
					If SZY->ZY_PRVFAT == dGetData .And. Empty(SZY->ZY_NOTA)
						Alert("Ja existe previsao nesta data, favor utilizar outra data.")
						Return
					EndIf

					If SZY->ZY_PRVFAT > dGetData .And. Empty(SZY->ZY_NOTA)
						Alert("Jแ Existe Previsใo registrada com data Superior a Informada. Favor utilizar outra data.")
						Return
					EndIf

					SZY->(DbSkip())
				EndDO


				If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))

					RecLock("SZY",.F.)
					SZY->ZY_QUANT := SZY->ZY_QUANT - nGetQuanti
					SZY->(MsUnlock())

					RecLock("SZY",.T.)
					SZY->ZY_FILIAL	 	:= xFilial("SZY")
					SZY->ZY_PEDIDO	 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_PEDIDO"})]
					SZY->ZY_ITEM	 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_ITEM"})]
					SZY->ZY_SEQ		 	:= StrZero(Val(cUltSeq)+1,3)
					SZY->ZY_PRODUTO		:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_PRODUTO"})]
					SZY->ZY_DESC	 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_DESC"})]
					SZY->ZY_UM		 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_UM"})]
					SZY->ZY_QUANT	 	:= nGetQuanti
					SZY->ZY_QUJE	 	:= 0
					SZY->ZY_PRVFAT	 	:= dGetData
					SZY->ZY_DTFATUR 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_DTFATUR"  })]  // mauresi
					SZY->ZY_DTOTD   	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_DTOTD"  })]	 // mauresi
					SZY->ZY_DTPCP   	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_DTPCP"  })]	 // mauresi
					SZY->ZY_NOTA	 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_NOTA"  })]
					SZY->ZY_SERIE	 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_SERIE" })]
					SZY->ZY_ITEMNF	 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_ITEMNF"})]
//						SZY->ZY_LOCENTR 	:= oGet:aCols[oGet:nAt][aScan(oGet:aHeader,{|aVet| Alltrim(aVet[2]) == "ZY_LOCENTR"})]  
					SZY->(MsUnlock())
				EndIf
			EndIf


			MsgRun("Processando","Atualizando Informa็๕es",{|| Atu_aCols()})
		EndIf

	EndIf

Return

User Function RFAT04A()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO" })
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"   })
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"    })
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"  })
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"  })   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG" })    // DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"  })
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT" })
	Local nPosNOTA 			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_NOTA"   })
	Local cPedido      		:= oGet:aCols[oGet:nAt][nPosPEDIDO] //oGet:aCols[oGet:nAt][1]
	Local cItemPd      		:= oGet:aCols[oGet:nAt][nPosITEMPD] //oGet:aCols[oGet:nAt][2]
	Local cSeqPed      		:= oGet:aCols[oGet:nAt][nPosSEQPED] //oGet:aCols[oGet:nAt][3]
	Local cNota          	:= oGet:aCols[oGet:nAt][nPosNOTA  ]

	Local lRet	      		:= .F.

	Local dDtOld := Ctod("  /  /  ")
	Local dDtNew := Ctod("  /  /  ")
	Local aItEmail := {}

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))

	If !Empty(cNota)
		Alert("Nใo ้ permitido alterar itens jแ faturados")
		lRet := .F.
		Return lRet
	EndIf

	//------------------------------------------
	//  Validacao - DATA DE ENTREGA  ZY_DTFATUR
	//------------------------------------------
	If nPosDTFAT == oGet:OBROWSE:COLPOS       		//Data Entrega (Campo do Depto. Comercial)
		If Empty(oGet:aCols[oGet:nAt][nPosDTOTD])   	//mauresi nPosDTOTDC6
			If !Empty(oGet:aCols[oGet:nAt][nPosDTPCP])
				oGet:aCols[oGet:nAt][nPosDTOTD]  	:= oGet:aCols[oGet:nAt][nPosDTPCP]   // Alimenta Data OTD do Acols com Data PCP
				//oGet:aCols[oGet:nAt][nPosDTPRV] 	:= oGet:aCols[oGet:nAt][nPosDTPCP]   // Data faturamento aCols

				// Atualiza campos no SZY
				SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))
				If RecLock("SZY",.F.)
					SZY->ZY_DTOTD	 	:= oGet:aCols[oGet:nAt][nPosDTPCP]   // Preenche a Data de OTD  // mauresi
					SZY->ZY_DTFATUR 	:= M->ZY_DTFATUR
					//SZY->ZY_PRVFAT  := oGet:aCols[oGet:nAt][nPosDTPCP]   // Preenche a Data de Previsao de faturamento
					SZY->(MsUnlock())
				EndIf

				// Atualiza DATA OTD  no SC6
				SC6->(DbSeek(xFilial("SC6")+AllTrim(cPedido)+AllTrim(cItemPd)))
				If RecLock("SC6",.F.) .and. !empty(M->ZY_DTFATUR) .and. !empty(oGet:aCols[oGet:nAt][nPosDTOTD])
					//Grava a data/hora de altera็ใo no campo C6_DTFATUR (Dt. Entrega)
					//Osmar Ferreira 10/05/21
					If (Empty(SC6->C6_DTFATUR)) .Or. (SC6->C6_DTFATUR <> M->ZY_DTFATUR)
						SC6->C6_XDTCLI := Date()
						SC6->C6_XHRCLI := Time()
					Endif

					SC6->C6_XXDTDEF	:= oGet:aCols[oGet:nAt][nPosDTOTD]  // mauresi nPosDTPCP  // Preenche a Data OTD no SC6
					SC6->C6_DTFATUR	:= M->ZY_DTFATUR
					SC6->(MsUnlock())
					fGrvTempo(SC6->C6_NUM)
				EndIf
				lRet := .T.
			EndIf
		Else
			lRet	  := .T.
			SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))
			If RecLock("SZY",.F.)
				SZY->ZY_DTFATUR := M->ZY_DTFATUR
				SZY->(MsUnlock())
			EndIf
		EndIf
		//-------------------------------------------------------
		//  Validacao - DATA DE PREVISAO DE FATURAMENTO ZY_PRVFAT
		//-------------------------------------------------------
	ElseIf aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"}) == oGet:OBROWSE:COLPOS //campo previsao de faturamento

		If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))

			dGetData := M->ZY_PRVFAT
			lRet := .T.
			SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd))
			While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == cPedido .And. SZY->ZY_ITEM == cItemPd
				// Valida se existe previsao
				If SZY->ZY_PRVFAT == dGetData .And. Empty(SZY->ZY_NOTA)
					Alert("Ja existe previsao na data " + DtoC(dGetData) + " para o pedido: " + SZY->ZY_PEDIDO + ", item: " + SZY->ZY_ITEM + ". ํtem nใo foi alterado.")
					lRet := .F.
					Return lRet
				EndIf
				//valida Sequencia
				If cSeqPed > SZY->ZY_SEQ
					If SZY->ZY_PRVFAT > dGetData
						Alert("A Sequencia: " + SZY->ZY_SEQ + " esta com data superior a digitada ")
						lRet := .F.
						Return lRet
					EndIf
				EndIf

				If empty(SZY->ZY_DTPCP)
					Alert("Data PCP nใo informada para o pedido: " + SZY->ZY_PEDIDO + ", item: " + SZY->ZY_ITEM +  ". Pedido nao alterado.")
					lRet := .F.
					Return lRet
				EndIf


				SZY->(DbSkip())
			EndDO
			SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))

			// So grava a Previsao de Faturamento, se Data PCP estiver preenchido
			if !empty(SZY->ZY_DTPCP)
				If RecLock("SZY",.F.)
					SZY->ZY_PRVFAT := dGetData
					SZY->(MsUnlock())
				EndIf
			Endif
		EndIf

		//------------------------------------------
		//  Validacao - DATA PCP    ZY_DTPCP
		//------------------------------------------
	Elseif aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"}) == oGet:OBROWSE:COLPOS //campo Data PCP
		If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))

			dGetData := M->ZY_DTPCP
			lRet := .T.

			SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))
			If RecLock("SZY",.F.)
				SZY->ZY_DTPCP := dGetData
				SZY->(MsUnlock())
			EndIf

			// Atualiza DATA PCP  no SC6
			SC6->(DbSeek(xFilial("SC6")+AllTrim(cPedido)+AllTrim(cItemPd)))

			If U_VALIDACAO("OSMAR")
				If SC6->C6_ENTRE3 <> dGetData
					dDtOld := SC6->C6_ENTRE3
					dDtNew := dGetData
					aaDD(aItEmail,{SC6->C6_NUM,SC6->C6_ITEM,dDtOld,dDtNew,'',''})
				EndIf
			End

			If RecLock("SC6",.F.)
				SC6->C6_ENTRE3 := dGetData  // mauresi nPosDTPCP  // Preenche a Data OTD no SC6
				SC6->(MsUnlock())
				lRet := .T.
			EndIf

			If U_VALIDACAO("OSMAR")
				If Len(aItEmail) > 0
					fDatMail(aItEmail)
					aItEmail := {}
				EndIf
			EndIf
		EndIf

		//------------------------------------------
		//  Validacao - DATA OTD    ZY_DTOT
		//------------------------------------------
	Elseif aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"}) == oGet:OBROWSE:COLPOS //campo Data PCP
		If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))

			dGetData := M->ZY_DTOTD
			lRet := .T.

			SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))
			If RecLock("SZY",.F.)
				SZY->ZY_DTOTD := dGetData
				SZY->(MsUnlock())
			EndIf

			// Atualiza DATA OTD  no SC6
			SC6->(DbSeek(xFilial("SC6")+AllTrim(cPedido)+AllTrim(cItemPd)))
			If RecLock("SC6",.F.)
				SC6->C6_XXDTDEF := dGetData  // mauresi nPosDTPCP  // Preenche a Data OTD no SC6
				SC6->(MsUnlock())
				lRet := .T.
			EndIf

		EndIf
	Else
		// Se for qualquer outro Campo, Nao Valida a Inclusao/Alteracao
		lRet := .F.
	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออัออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExcluirPrevisao บAutorณMicrosiga       บ Data ณ  03/29/19   บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออฯออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Excluir Previsao de Faturamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExcluirPrevisao()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO"})
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"})
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"})
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"})
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"})   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"}) 		// DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"})
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"})
	Local cPedido      		:= oGet:aCols[oGet:nAt][nPosPEDIDO] //oGet:aCols[oGet:nAt][1]
	Local cItemPd      		:= oGet:aCols[oGet:nAt][nPosITEMPD] //oGet:aCols[oGet:nAt][2]
	Local cSeqPed      		:= oGet:aCols[oGet:nAt][nPosSEQPED] //oGet:aCols[oGet:nAt][3]

	Local cUltSeq 			:= "001"
	Local nQtdSeq 			:= 0

	If Val(cSeqPed) == 1
		Alert("Nใo ้ possivel excluir a previsใo com sequencia 001")
		Return
	EndIf

	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))

	If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd))
		While SZY->(!Eof()) .And. ZY_PEDIDO == cPedido .And. ZY_ITEM == cItemPd
			cUltSeq	:= SZY->ZY_SEQ
			nQtdSeq ++
			SZY->(DbSkip())
		EndDO
	EndIf

	If nQtdSeq ==1
		Alert("Nao se pode excluir, pois e a unica sequencia existente.")
		Return
	EndIf

	If cUltSeq <> cSeqPed
		Alert("Deve-se excluir sempre a ultima sequencia.")
		Return
	EndIf

	If ApMsgYesNo("Deseja realmente excluir a previsao do pedido: " + cPedido + ", item: " + cItemPd + ", sequencia: " + cSeqPed)

		DbSelectArea("SZY")
		SZY->(DbSetOrder(1))

		If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+StrZero(Val(cSeqPed)-1,3)))
			RecLock("SZY",.F.)
			SZY->ZY_QUANT := SZY->ZY_QUANT + oGet:aCols[oGet:nAt][nPosQUANT]
			SZY->(MsUnlock())
		EndIf

		If SZY->(DbSeek(xFilial("SZY")+cPedido+cItemPd+cSeqPed))
			RecLock("SZY",.F.)
			SZY->(DbDelete())
			SZY->(MsUnlock())
		EndIf

		MsgRun("Processando","Atualizando Informa็๕es",{|| Atu_aCols()})

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltData   บAutor  ณMicrosiga           บ Data ณ  03/29/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera Data de Previsao de Faturamento                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltDtPRV()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO"})
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"})
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"})
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"})
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"})   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"}) 		// DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"})
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"})
	Local cPedido      		:= oGet:aCols[oGet:nAt][nPosPEDIDO] //oGet:aCols[oGet:nAt][1]
	Local cItemPd      		:= oGet:aCols[oGet:nAt][nPosITEMPD] //oGet:aCols[oGet:nAt][2]
	Local cSeqPed      		:= oGet:aCols[oGet:nAt][nPosSEQPED] //oGet:aCols[oGet:nAt][3]

	Local lOk	  := .F.
	Local nI	  := 0
	Local lDtOk   := .T.

	For nI := 1 to Len(oGet:aCols)
//		If oGet:aCols[nI][9] <> oGet:aCols[1][9]  
		If oGet:aCols[nI][nPosDTPRV] <> oGet:aCols[1][nPosDTPRV]
			Alert("Existe mais de um dia no filtro, nใo ้ possivel alteracao")
			Return
		EndIf
	Next nI

	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))

	lOk := TelaPRV("Deseja alterar " + AllTrim(Str(Len(oGet:aCols))) + " registros da data: " + DtoC(oGet:aCols[1][nPosDTPRV]) + " ?",1)
	If lOk

		For nI := 1 to Len(oGet:aCols)
//			If SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][1]+oGet:aCols[nI][2]))
			If SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))
				lDtOk := .T.
				While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == oGet:aCols[nI][nPosPEDIDO] .And. SZY->ZY_ITEM == oGet:aCols[nI][nPosITEMPD] .And. lDtOK
					If SZY->ZY_PRVFAT == dGetData
						Alert("Ja existe previsao na data " + DtoC(dGetData) + " para o pedido: " + oGet:aCols[nI][nPosPEDIDO1] + ", item: " + oGet:aCols[nI][nPosITEMPD] + ". Pedido nao alterado.")
						lDtOk := .F.
					EndIf
					//So permite alterar Previsao, se a data PCP estiver preenchida
					If empty(SZY->ZY_DTPCP)
						Alert("Data PCP nใo informada para o pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + ". Pedido nao alterado.")
						lDtOk := .F.
					EndIf

					If oGet:aCols[nI][nPosSEQPED] > SZY->ZY_SEQ
						If SZY->ZY_PRVFAT > dGetData
							Alert("A Sequencia do pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + " esta com data de Previsใo superior a digitada. Pedido nao alterado.")
							lDtOk := .F.
						EndIf
					EndIf
					SZY->(DbSkip())
				EndDo

				SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]+oGet:aCols[nI][nPosSEQPED]))
				If lDtOk
					If RecLock("SZY",.F.)
						oGet:aCols[nI][nPosDTPRV] 	:= dGetData
						SZY->ZY_PRVFAT 				:= dGetData
						SZY->(MsUnlock())
					EndIf
				EndIf
			EndIf
		Next nI

	EndIF

Return

Static Function TelaPRV(cMsg,nOpc)

	Local oDlgAltData
	Local oBtnOk
	Local oBtnCancel
	Local oFontDescri := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
	Local oSayDescri
	Local oSayData
	Local oSayQuantidade
	Local lOk	:= .F.

	nGetQuanti := 0
	If Empty(dGetData)
		dGetData := dDataBase
	EndIf

	dGetData := dGetData + 1

	DEFINE MSDIALOG oDlgAltData TITLE "Alterar Data de Previsใo de Faturamento" FROM 000, 000  TO 200, 250 COLORS 0, 16777215 PIXEL

	@ 003, 003 SAY oSayDescri PROMPT cMsg SIZE 118, 030 OF oDlgAltData FONT oFontDescri COLORS 0, 16777215 PIXEL
	@ 038, 002 SAY oSayData PROMPT "Data de Previsใo" SIZE 054, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
	@ 045, 002 MSGET oGetData VAR dGetData SIZE 119, 010 OF oDlgAltData COLORS 0, 16777215 PIXEL
	If nOpc == 2
		@ 060, 003 SAY oSayQuantidade PROMPT "Quantidade" SIZE 062, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
		@ 068, 003 MSGET oGetQuanti VAR nGetQuanti SIZE 117, 010 PICTURE "@E 999,999,999.99" OF oDlgAltData COLORS 0, 16777215 PIXEL
	EndIf
	@ 083, 083 BUTTON oBtnCancel PROMPT "Cancelar" SIZE 037, 012 ACTION {||lOk := .F.,oDlgAltData:End()} OF oDlgAltData PIXEL
	@ 083, 003 BUTTON oBtnOk PROMPT "Confirmar" SIZE 037, 012 ACTION {||lOk := .T.,oDlgAltData:End()}OF oDlgAltData PIXEL

	ACTIVATE MSDIALOG oDlgAltData CENTERED

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltDtENT  บAutor  ณMicrosiga           บ Data ณ  03/29/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera Data ENTREGA                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltDtENT()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO"})
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"})
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"})
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"})
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"})   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"}) 		// DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"})
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"})
	Local cPedido      		:= oGet:aCols[oGet:nAt][nPosPEDIDO] //oGet:aCols[oGet:nAt][1]
	Local cItemPd      		:= oGet:aCols[oGet:nAt][nPosITEMPD] //oGet:aCols[oGet:nAt][2]
	Local cSeqPed      		:= oGet:aCols[oGet:nAt][nPosSEQPED] //oGet:aCols[oGet:nAt][3]

	Local lOk	  	:= .F.
	Local nI	  	:= 0
	Local lDtOk   	:= .T.

	For nI := 1 to Len(oGet:aCols)
		If oGet:aCols[nI][nPosDTPRV] <> oGet:aCols[1][nPosDTPRV]
			Alert("Existe mais de um dia no filtro, nao e possivel alteracao")
			Return
		EndIf
	Next nI

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))

	lOk := TelaENT("Deseja alterar " + AllTrim(Str(Len(oGet:aCols))) + " registros da data entrega: " + DtoC(oGet:aCols[1][nPosDTPRV]) + " ?",1)
	If lOk

		For nI := 1 to Len(oGet:aCols)
			If SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))
				lDtOk := .T.
				While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == oGet:aCols[nI][nPosPEDIDO] .And. SZY->ZY_ITEM == oGet:aCols[nI][nPosITEMPD] .And. lDtOK
					If SZY->ZY_DTFATUR == dGetData
						Alert("Data Entrega " + DtoC(dGetData) + " jแ informada para o pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + ". Pedido nao alterado.")
						lDtOk := .F.
					EndIf
					If oGet:aCols[nI][nPosSEQPED] > SZY->ZY_SEQ
						If SZY->ZY_DTFATUR > dGetData
							Alert("A Sequencia do pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + " esta com data Entrega superior a digitada. Pedido nao alterado.")
							lDtOk := .F.
						EndIf
					EndIf
					SZY->(DbSkip())
				EndDo

				SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]+oGet:aCols[nI][nPosSEQPED]))
				If lDtOk
					If	RecLock("SZY",.F.)
						oGet:aCols[nI][nPosDTFAT] 	:= dGetData
						oGet:aCols[nI][nPosDTOTD] 	:= SZY->ZY_DTPCP
						SZY->ZY_DTFATUR 			:= dGetData
						SZY->ZY_DTOTD				:= SZY->ZY_DTPCP

						SZY->(MsUnlock())

						// Atualiza DATA ENTREGA (C6_DTFATUR) no SC6
						SC6->(DbSeek(xFilial("SC6")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))
						If RecLock("SC6",.F.)
							//Grava a data/hora de altera็ใo no campo C6_DTFATUR (Dt. Entrega)
							//Osmar Ferreira 10/05/21
							If (Empty(SC6->C6_DTFATUR)) .Or. (SC6->C6_DTFATUR <> dGetData)
								SC6->C6_XDTCLI := Date()
								SC6->C6_XHRCLI := Time()
							Endif

							SC6->C6_DTFATUR		:= dGetData
							SC6->(MsUnlock())
							fGrvTempo(SC6->C6_NUM)
						Endif
					EndIf
				EndIf
			EndIf
		Next nI

	EndIF

Return

Static Function TelaENT(cMsg,nOpc)

	Local oDlgAltData
	Local oBtnOk
	Local oBtnCancel
	Local oFontDescri := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
	Local oSayDescri
	Local oSayData
	Local oSayQuantidade
	Local lOk	:= .F.

	nGetQuanti := 0
	If Empty(dGetData)
		dGetData := dDataBase
	EndIf

	dGetData := dGetData + 1

	DEFINE MSDIALOG oDlgAltData TITLE "Alterar Data de Entrega" FROM 000, 000  TO 200, 250 COLORS 0, 16777215 PIXEL

	@ 003, 003 SAY oSayDescri PROMPT cMsg SIZE 118, 030 OF oDlgAltData FONT oFontDescri COLORS 0, 16777215 PIXEL
	@ 038, 002 SAY oSayData PROMPT "Data Entrega" SIZE 054, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
	@ 045, 002 MSGET oGetData VAR dGetData SIZE 119, 010 OF oDlgAltData COLORS 0, 16777215 PIXEL
	//   If nOpc == 2
	//   	@ 060, 003 SAY oSayQuantidade PROMPT "Quantidade" SIZE 062, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
	//   	@ 068, 003 MSGET oGetQuanti VAR nGetQuanti SIZE 117, 010 PICTURE "@E 999,999,999.99" OF oDlgAltData COLORS 0, 16777215 PIXEL
	//   EndIf
	@ 083, 083 BUTTON oBtnCancel PROMPT "Cancelar" SIZE 037, 012 ACTION {||lOk := .F.,oDlgAltData:End()} OF oDlgAltData PIXEL
	@ 083, 003 BUTTON oBtnOk PROMPT "Confirmar" SIZE 037, 012 ACTION {||lOk := .T.,oDlgAltData:End()}OF oDlgAltData PIXEL

	ACTIVATE MSDIALOG oDlgAltData CENTERED

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltDtPCP  บAutor  ณMicrosiga           บ Data ณ  03/29/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera Data PCP                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltDtPCP()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO"})
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"})
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"})
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"})
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"})   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"}) 		// DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"})
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"})
	Local cPedido      		:= oGet:aCols[oGet:nAt][nPosPEDIDO] //oGet:aCols[oGet:nAt][1]
	Local cItemPd      		:= oGet:aCols[oGet:nAt][nPosITEMPD] //oGet:aCols[oGet:nAt][2]
	Local cSeqPed      		:= oGet:aCols[oGet:nAt][nPosSEQPED] //oGet:aCols[oGet:nAt][3]

	Local lOk	  := .F.
	Local nI	  := 0
	Local lDtOk   := .T.

	Local dDtOld := Ctod("  /  /  ")
	Local dDtNew := Ctod("  /  /  ")
	Local aItEmail := {}

	For nI := 1 to Len(oGet:aCols)
		If oGet:aCols[nI][nPosDTPRV] <> oGet:aCols[1][nPosDTPRV]
			Alert("Existe mais de um dia no filtro, nao e possivel alteracao")
			Return
		EndIf
	Next nI

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))

	lOk := TelaPCP("Deseja alterar " + AllTrim(Str(Len(oGet:aCols))) + " registros da data: " + DtoC(oGet:aCols[1][nPosDTPRV]) + " ?",1)
	If lOk

		For nI := 1 to Len(oGet:aCols)
			If SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))
				lDtOk := .T.
				While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == oGet:aCols[nI][nPosPEDIDO] .And. SZY->ZY_ITEM == oGet:aCols[nI][nPosITEMPD] .And. lDtOK
					If SZY->ZY_DTPCP == dGetData
						Alert("Data PCP " + DtoC(dGetData) + " jแ informada para o pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + ". Pedido nao alterado.")
						lDtOk := .F.
					EndIf
					If oGet:aCols[nI][nPosSEQPED] > SZY->ZY_SEQ
						If SZY->ZY_DTPCP > dGetData
							Alert("A Sequencia do pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + " esta com data PCP superior a digitada. Pedido nao alterado.")
							lDtOk := .F.
						EndIf
					EndIf
					SZY->(DbSkip())
				EndDo

				SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]+oGet:aCols[nI][nPosSEQPED]))
				If lDtOk
					If RecLock("SZY",.F.)
						oGet:aCols[nI][nPosDTPCP] := dGetData
						SZY->ZY_DTPCP 		:= dGetData
						SZY->(MsUnlock())

						// Atualiza DATA PCP (C6_ENTRE3) no SC6
						SC6->(DbSeek(xFilial("SC6")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))

						If U_VALIDACAO("OSMAR")
							If SC6->C6_ENTRE3 <> dGetData
								dDtOld := SC6->C6_ENTRE3
								dDtNew := dGetData
								aaDD(aItEmail,{SC6->C6_NUM,SC6->C6_ITEM,dDtOld,dDtNew,'',''})
							EndIf
						End

						If RecLock("SC6",.F.)
							SC6->C6_ENTRE3 := dGetData
							SC6->(MsUnlock())
						Endif
					EndIf
				EndIf
			EndIf
		Next nI

		If U_VALIDACAO("OSMAR")
			If Len(aItEmail) > 0
				fDatMail(aItEmail)
				aItEmail := {}
			EndIf
		EndIf

	EndIF

Return

Static Function TelaPCP(cMsg,nOpc)

	Local oDlgAltData
	Local oBtnOk
	Local oBtnCancel
	Local oFontDescri := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
	Local oSayDescri
	Local oSayData
	Local oSayQuantidade
	Local lOk	:= .F.

	nGetQuanti := 0
	If Empty(dGetData)
		dGetData := dDataBase
	EndIf

	dGetData := dGetData + 1

	DEFINE MSDIALOG oDlgAltData TITLE "Alterar Data PCP" FROM 000, 000  TO 200, 250 COLORS 0, 16777215 PIXEL

	@ 003, 003 SAY oSayDescri PROMPT cMsg SIZE 118, 030 OF oDlgAltData FONT oFontDescri COLORS 0, 16777215 PIXEL
	@ 038, 002 SAY oSayData PROMPT "Data PCP" SIZE 054, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
	@ 045, 002 MSGET oGetData VAR dGetData SIZE 119, 010 OF oDlgAltData COLORS 0, 16777215 PIXEL
	//   If nOpc == 2
	//   	@ 060, 003 SAY oSayQuantidade PROMPT "Quantidade" SIZE 062, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
	//   	@ 068, 003 MSGET oGetQuanti VAR nGetQuanti SIZE 117, 010 PICTURE "@E 999,999,999.99" OF oDlgAltData COLORS 0, 16777215 PIXEL
	//   EndIf
	@ 083, 083 BUTTON oBtnCancel PROMPT "Cancelar" SIZE 037, 012 ACTION {||lOk := .F.,oDlgAltData:End()} OF oDlgAltData PIXEL
	@ 083, 003 BUTTON oBtnOk PROMPT "Confirmar" SIZE 037, 012 ACTION {||lOk := .T.,oDlgAltData:End()}OF oDlgAltData PIXEL

	ACTIVATE MSDIALOG oDlgAltData CENTERED

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltDtOTD  บAutor  ณMicrosiga           บ Data ณ  03/29/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera Data OTD                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltDtOTD()

	Local nPosPEDIDO 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PEDIDO"})
	Local nPosITEMPD 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_ITEM"})
	Local nPosSEQPED 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_SEQ"})
	Local nPosQUANT			:= aScan(aHeader,{|x| Alltrim(x[2]) == "ZY_QUANT"})
	Local nPosDTFAT			:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTFATUR"})  	// ATA DE ENTREGA
	Local nPosDTPCP    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTPCP"})   	// DATA2
	Local nPosDTENTREG   	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENTREG"}) 		// DATA CLIENTE DO SC6
	Local nPosDTOTD    		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_DTOTD"})
	Local nPosDTPRV 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZY_PRVFAT"})
	Local nPosNome          := aScan(aHeader,{|x| AllTrim(x[2]) == "A1_NREDUZ"})

	Local cPedido      		:= oGet:aCols[oGet:nAt][nPosPEDIDO] //oGet:aCols[oGet:nAt][1]
	Local cItemPd      		:= oGet:aCols[oGet:nAt][nPosITEMPD] //oGet:aCols[oGet:nAt][2]
	Local cSeqPed      		:= oGet:aCols[oGet:nAt][nPosSEQPED] //oGet:aCols[oGet:nAt][3]

	//	Local cMotivo		:= Space(254)

	Local lOk	  := .F.
	Local nI	  := 0
	Local lDtOk   := .T.

	For nI := 1 to Len(oGet:aCols)
		If oGet:aCols[nI][nPosDTPRV] <> oGet:aCols[1][nPosDTPRV]
			Alert("Existe mais de um dia no filtro, nao e possivel alteracao")
			Return
		EndIf
	Next nI

	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))


	lOk := TelaOTD("Deseja alterar " + AllTrim(Str(Len(oGet:aCols))) + " registros da data: " + DtoC(oGet:aCols[1][nPosDTPRV]) + " ?",1)
	If lOk

		For nI := 1 to Len(oGet:aCols)
			If SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))
				lDtOk := .T.
				While SZY->(!Eof()) .And. SZY->ZY_PEDIDO == oGet:aCols[nI][nPosPEDIDO] .And. SZY->ZY_ITEM == oGet:aCols[nI][nPosITEMPD] .And. lDtOK
					If SZY->ZY_DTOTD == dGetData
						Alert("Data OTD " + DtoC(dGetData) + " jแ informada para o pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + ". Pedido nao alterado.")
						lDtOk := .F.
					EndIf
					If oGet:aCols[nI][nPosSEQPED] > SZY->ZY_SEQ
						If SZY->ZY_DTOTD > dGetData
							Alert("A Sequencia do pedido: " + oGet:aCols[nI][nPosPEDIDO] + ", item: " + oGet:aCols[nI][nPosITEMPD] + " esta com data OTD superior a digitada. Pedido nao alterado.")
							lDtOk := .F.
						EndIf
					EndIf
					SZY->(DbSkip())
				EndDo

				SZY->(DbSeek(xFilial("SZY")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]+oGet:aCols[nI][nPosSEQPED]))
				If lDtOk
					If RecLock("SZY",.F.)
						//Para cliente Huawei considera a data de previsใo de venda no OTD
						If ("HUAWEI" $ Upper(oGet:aCols[nI][nPosNome]))
							oGet:aCols[nI][nPosDTOTD] :=  oGet:aCols[nI][nPosDTPRV]
							SZY->ZY_DTOTD	 		  :=  oGet:aCols[nI][nPosDTPRV]
							If SZY->(FieldPos("ZY_MOTOTD")) > 0
								SZY->ZY_MOTOTD		   := Alltrim(cMotivo)			// Motivo de Alteracao do OTD
							endif
							SZY->(MsUnlock())

							// Atualiza DATA OTD (C6_XXDTDEF) no SC6
							SC6->(DbSeek(xFilial("SC6")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))
							If RecLock("SC6",.F.)
								SC6->C6_XXDTDEF 		:= oGet:aCols[nI][nPosDTPRV]
								SC6->(MsUnlock())
							Endif

						Else

							oGet:aCols[nI][nPosDTOTD] := dGetData       // MAURESI - estava  oGet:aCols[nI][9]
							SZY->ZY_DTOTD	 		  := dGetData
							If SZY->(FieldPos("ZY_MOTOTD")) > 0
								SZY->ZY_MOTOTD		   := Alltrim(cMotivo)			// Motivo de Alteracao do OTD
							endif
							SZY->(MsUnlock())

							// Atualiza DATA OTD (C6_XXDTDEF) no SC6
							SC6->(DbSeek(xFilial("SC6")+oGet:aCols[nI][nPosPEDIDO]+oGet:aCols[nI][nPosITEMPD]))
							If RecLock("SC6",.F.)
								SC6->C6_XXDTDEF 		:= dGetData
								SC6->(MsUnlock())
							Endif
						EndIf
					EndIf
				EndIf
			EndIf
		Next nI

	EndIF

Return

Static Function TelaOTD(cMsg,nOpc)

	Local oDlgAltData
	Local oBtnOk
	Local oBtnCancel
	Local oFontDescri := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
	Local oSayDescri
	Local oSayData
	Local oSayQuantidade
	Local oMotivo
	Local lOk	:= .F.
//	Local cMotivo := Space(254)

	nGetQuanti := 0

	If Empty(dGetData)
		dGetData := dDataBase
	EndIf
	dGetData := dGetData + 1

	DEFINE MSDIALOG oDlgAltData TITLE "Alterar Data OTD" FROM 000, 000  TO 200, 250 COLORS 0, 16777215 PIXEL

	@ 003, 003 SAY oSayDescri PROMPT cMsg SIZE 118, 030 OF oDlgAltData FONT oFontDescri COLORS 0, 16777215 PIXEL
	@ 038, 002 SAY oSayData PROMPT "Data OTD" SIZE 054, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
	@ 045, 002 MSGET oGetData VAR dGetData SIZE 119, 010 OF oDlgAltData COLORS 0, 16777215 PIXEL
	//   If nOpc == 2
	@ 060, 003 SAY oSayQuantidade PROMPT "Motivo:" SIZE 062, 007 OF oDlgAltData COLORS 0, 16777215 PIXEL
	@ 068, 003 MSGET oMotivo VAR cMotivo SIZE 150, 010 PICTURE "@R" OF oDlgAltData COLORS 0, 16777215 PIXEL
	//	    EndIf
	@ 083, 083 BUTTON oBtnCancel PROMPT "Cancelar" SIZE 037, 012 ACTION {||lOk := .F.,oDlgAltData:End()} OF oDlgAltData PIXEL
	@ 083, 003 BUTTON oBtnOk PROMPT "Confirmar" SIZE 037, 012 ACTION {||lOk := .T.,oDlgAltData:End()}OF oDlgAltData PIXEL

	ACTIVATE MSDIALOG oDlgAltData CENTERED

Return lOk


//Grava o tempo entre a data de emissใo e a data de lan็amento da data do PCP
Static Function fGrvTempo(cPedido)
	Local nHH, nMM := 0
	Local aAreaSC5 := SC5->( GetArea() )
	SC5->( dbSetOrder(01) )
	SC5->(dbSeek(xFilial()+cPedido))
	If (!Empty(SC5->C5_XHREMIS)) .And. (!Empty(SC6->C6_XHRCLI))
		nHH := ((SC6->C6_XDTCLI - SC5->C5_EMISSAO) * 24) + (Val(SubStr(SC6->C6_XHRCLI,1,2)) - Val(SubStr(SC5->C5_XHREMIS,1,2)))
		nMM := Val(SubStr(SC6->C6_XHRCLI,4,2)) - Val(SubStr(SC5->C5_XHREMIS,4,2))

		If nMM >= 0
			nMM := nMM / 100
			nHH := nHH + nMM
		Else
			nMM := nMM * (-1)
			nHH := nHH - (nMM / 60)
			nMM := nHH - Int(nHH)
			nHH := Int(nHH) + (nMM * 60 / 100)
		EndIf

		Reclock("SC6",.F.)
		SC6->C6_XHRPV := nHH
		SC6->( msUnlock() )
	EndIf
	RestArea(aAreaSC5)
Return


/*
Envia email informando a troca de datas 
*/
//Static Function fDatMail(cNum,cItem,dtOld,dtNew)
Static Function fDatMail(aItens)
	Local cMsg	 := ""
	Local cEmail := ""
	Local x, y	 := 0
	Local aElaborador := {}
	Local lAchou := .F.
	Local aAreaSC5 := SC5->( GetArea() )
	Local aAreaSA1 := SA1->( GetArea() )

	SC5->(dbSetOrder(01))
	For x := 1 To Len(aItens)
		SC5->(dbSeek(xFiliaL()+aItens[x,1]+aItens[x,2]))
		aItens[x,5] := SC5->C5_ELABORA
		aItens[x,6] := AllTrim(UsrRetMail(SC5->C5_USER))
	Next x

	For x := 1 To Len(aItens)
		For y := 1 To Len(aElaborador)
			If aItens[x,5] == aElaborador[y,1]
				lAchou := .T.
			EndIf
		Next y
		If !lAchou
			aaDD(aElaborador,{aItens[x,5],aItens[x,6]})
		EndIf
	Next x


	For y := 1 To Len(aElaborador)
		cEmail := "osmar@opusvp.com.br;denis.vieira@rosenbergerdomex.com.br;" + AllTrim(aElaborador[y,2])
		//cEmail := "osmar@opusvp.com.br"

		cMsg := "Elaborador do Pedido de Venda: "+ aElaborador[y,1] +'<br>'
		cMsg += "<br>"
		cMsg += "Altera็ใo feita em "+Dtoc(Date())+" - "+Time()+'<br>'
		cMsg += "Por: "+ SubString(cUsuario,7,15)+'<br>'
		cMsg += "<br>"

		cMsg += "PEDIDO / ITEM"+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ' +;
			"DE"+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ' + "PARA" + '<br>'
		SA1->( dbSetOrder(01) )
		For x := 1 To Len(aItens)
			If aElaborador[y,1] == aItens[x,5]

				cMsg += aItens[x,1]+" / "+aItens[x,2]+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+Dtoc(aItens[x,3])+' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+Dtoc(aItens[x,4])+'<br>'

			EndIf
		Next x

		Sleep(4000)
		U_EnvMailto("Altera็ใo de data (PCP) " ,cMsg,cEmail,"",)

	Next y

	RestArea(aAreaSA1)
	RestArea(aAreaSC5)

Return





