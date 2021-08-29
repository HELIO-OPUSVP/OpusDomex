#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "xmlxfun.ch"
#include "tryexception.ch"

User Function RPROD2_NEW()

Local cPerg		:= "RELPRO"
Local cNomArq	:= "Listagem"+"-"+DtoS(dDataBase)+"-"+STRTRAN(TIME(),":","")
Local cDirPad	:= "C:\windows\temp\"
Local cTitulo	:= "Emissão de listagem de pedido"
Local cDescr    := "Esta rotina tem como objetivo criar um arquivo no formato XLS. "
Local cTipoArq  := "XLS"
Local nOpcPad   := 1 	// 1 = gerar arquivo e abrir / 2 = somente gerar aquivo em disco
Local cMsgProc  := "Aguarde. Gerando relatorio ..."

Private aDadosImp  := {}
Private aDadosSel  := {}
Private oXML       := Nil
PRIVATE aReturn    := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
                                          	
	  	U_XMLPerg(cPerg,;   // cPerg
					cDirPad,;
					{|lEnd, cArquivo| GERAEXCEL(cArquivo) },;
					cTitulo,;
					cNomArq,;
					cDescr,;
					cTipoArq,;
					nOpcPad,;
					cMsgProc)

Return


Static Function GERAEXCEL(cArquivo)
	
	Private oCab01:=CellStyle():New("oCab01")
			oCab01:SetHAlign("Center")
			oCab01:SetFont("Calibri", 11, "#FFFFFF", .T.)
			oCab01:SetInterior("#4169E1", "Solid") 
			oCab01:SetBorder("Top")
			oCab01:SetBorder("Right")
			oCab01:SetBorder("Left")
	
	Private oDet01:=CellStyle():New("oDet01")
			oDet01:SetHAlign("Left")
			oDet01:SetFont("Calibri", 11, "#000000", .F.)
			oDet01:SetInterior("#FFFFFF", "Solid") 
			oDet01:SetBorder("Bottom")
			oDet01:SetBorder("Right")
			oDet01:SetBorder("Left")
	
	Private oDet02:= CellStyle():New("oDet02")
			oDet02:SetHAlign("Left")
			oDet02:SetFont("Calibri", 11, "#000000", .F.)
			oDet02:SetInterior("#F0F8FF", "Solid") 
			oDet02:SetBorder("Bottom")
			oDet02:SetBorder("Right")
			oDet02:SetBorder("Left")
	
	Private oDet01N:= CellStyle():New("oDet01N")
			oDet01N:SetHAlign("Left")
			oDet01N:SetFont("Calibri", 11, "#000000", .T.)
			oDet01N:SetInterior("#FFFFFF", "Solid") 
			oDet01N:SetBorder("Bottom")
			oDet01N:SetBorder("Right")
			oDet01N:SetBorder("Left")
	
	Private oDet02N:= CellStyle():New("oDet02N")
			oDet02N:SetHAlign("Left")
			oDet02N:SetFont("Calibri", 11, "#000000", .T.)
			oDet02N:SetInterior("#F0F8FF", "Solid") 
			oDet02N:SetBorder("Bottom")
			oDet02N:SetBorder("Right")
			oDet02N:SetBorder("Left")
		
	Private oDet01R:= CellStyle():New("oDet01R")
			oDet01R:SetHAlign("Left")
			oDet01R:SetFont("Calibri", 11, "#000000", .F.)
			oDet01R:SetInterior("#FFFFFF", "Solid") 
			oDet01R:SetBorder("Bottom")
			oDet01R:SetBorder("Right")
			oDet01R:SetBorder("Left")
			oDet01R:SetNumberFormat("R$#,##0.00_);[Red](R$#,##0.00)")
	
	Private oDet02R:= CellStyle():New("oDet02R")
			oDet02R:SetHAlign("Left")
			oDet02R:SetFont("Calibri", 11, "#000000", .F.)
			oDet02R:SetInterior("#F0F8FF", "Solid") 
			oDet02R:SetBorder("Bottom")
			oDet02R:SetBorder("Right")
			oDet02R:SetBorder("Left")	
			oDet02R:SetNumberFormat("R$#,##0.00_);[Red](R$#,##0.00)")
	
	
	Private aDadosImp := {}      

	oXML := ExcelXML():New()
	oXML:SetPageSetup(2,.T.,.F.,0,0,0,0,0,0)
	oXML:SetPrintSetup(9,43) 
	oXML:SetFolder(1) 
	oXML:SetFolderName("Listagem de Pedidos") 
	
	oXML:SetFreezeRow(1)
	oXML:SetFilter(1,1,1,22)

	oXML:SetColSize(	{"150"		,"150"	,"80"			,"240"				,"140"		,"240"			,"100"			,"130"				,"130"			,"130"			,"130"			,"130"		,"150"					,"150"			,"300"			,"200"	,"100"		,"100"		,"150"			,"200"			,"150","150"	 })
	oXML:addrow("24",	{"Emissão"	,"OF"	,"Item da OF"	,"Nome do Cliente"	,"Codigo"	,"Produto"		,"Cod. Cliente"	,"Item do Cliente"	,"Quantidade"	,"Valor s/IPI"	,"Valor c/Imp"	,"Total"	,"Previsao Faturamento"	,"Data Entrega"	,"Pedido do Cliente","Lote"	,"Shipment"	,"Sequencia","Nota Fiscal"	,"Elaborador"	,"OTD","Status Vendas"},;
						{oCab01		,oCab01	,oCab01			,oCab01				,oCab01		,oCab01			,oCab01			,oCab01				,oCab01			,oCab01			,oCab01			,oCab01		,oCab01					,oCab01			,oCab01			    ,oCab01	,oCab01		,oCab01		,oCab01			,oCab01			,oCab01,oCab01})
	//oXML:addrow("20",	{"OF"	,"Item"	,"Nota Fiscal"	,"Cod. Cliente"	,"Nome Cliente"	,"Codigo"	,"Produto"	,"Quantidade"	,"Valor s/IPI"	,"Valor c/Imp."	,"Total"	,"Data Entrega"	,"Previsao Faturamento"	,"Observacao"	,"Lote"	,"Sequencia"},;
	//					{oCab01	,oCab01	,oCab01			,oCab01			,oCab01			,oCab01		,oCab01		,oCab01			,oCab01			,oCab01			,oCab01		,oCab01			,oCab01					,oCab01			,oCab01	,oCab01		})
	
	Processa( {|lEnd| ImpDados()}, "Imprimindo relatorio...", "Aguarde...", .T.) 

	cXML := oXML:GetXML(cArquivo)

Return(cXML)

Static Function ImpDados()
	
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local lCor	 := .F.
	Local nReg	 := 0
	
	cQuery := "SELECT	SB1.B1_COD, "
	cQuery += "		SC5.C5_EMISSAO, "
	cQuery += "		SC5.C5_NUM, 	"
	cQuery += "		SC5.C5_TRANSP, 	"
	cQuery += "		SC6.C6_NOTA, 	"
	cQuery += "		SC6.C6_SEUDES, 	"
	cQuery += "		SC6.C6_DESCRI, 	"
	cQuery += "		SC6.C6_SEUCOD, 	"
	cQuery += "		SC6.C6_ITEM,	"
	cQuery += "		SA1.A1_NOME, 	"
	cQuery += "		SA1.A1_NREDUZ, 	"
	cQuery += "		SC6.C6_QTDENT, 	"
	cQuery += "		SC6.C6_PRCVEN, 	"
	cQuery += "		SC6.C6_IPI, 	"
	cQuery += "		SC6.C6_DTFATUR, "
	cQuery += "		SC6.C6_ENTRE3, 	"
	cQuery += "		SC5.C5_ESP1, 	"
	cQuery += "		SC6.C6_QTDVEN,	"
	cQuery += "		SZY.ZY_QUANT,	"
	cQuery += "		SZY.ZY_QUJE,	"
	cQuery += "		SC6.C6_LOTECTL,	"
	cQuery += "		SZY.ZY_SEQ,		"
	cQuery += "		SZY.ZY_PRVFAT,	"
	cQuery += "		SZY.ZY_NOTA,	"
	cQuery += "		SZY.ZY_DTOTD,	"
	cQuery += "		SC6.C6_XXSHIPM,	"
	cQuery += "		SC5.C5_ELABORA,	"
	cQuery += " 	SZY.ZY_DTFATUR, "
	cQuery += " 	SC5.C5_XXLIBCO "
	cQuery += "	FROM " + RetSqlName("SB1") + " SB1 (NOLOCK)	"
	cQuery += "		INNER JOIN " + RetSqlName("SC6") + " SC6 (NOLOCK) ON SC6.C6_PRODUTO = SB1.B1_COD AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SB1.B1_FILIAL	= '"+xFilial("SB1")+"' "
	cQuery += "		INNER JOIN " + RetSqlName("SC5") + " SC5 (NOLOCK) ON SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL		"
	cQuery += "		INNER JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI	"
  //Osmar 03/08/21
  //cQuery += "		INNER JOIN " + RetSqlName("SZY") + " SZY (NOLOCK) ON SZY.ZY_FILIAL = SC5.C5_FILIAL AND SZY.ZY_PEDIDO = SC5.C5_NUM AND SZY.ZY_ITEM = SC6.C6_ITEM AND SZY.ZY_PRODUTO = SC6.C6_PRODUTO	"
	cQuery += "		INNER JOIN " + RetSqlName("SZY") + " SZY (NOLOCK) ON SZY.ZY_FILIAL = SC5.C5_FILIAL AND SZY.ZY_PEDIDO = SC5.C5_NUM AND SZY.ZY_ITEM = SC6.C6_ITEM "

	cQuery += "	WHERE	"
	cQuery += "		SB1.D_E_L_E_T_ = ''	"
	cQuery += "		AND SC6.D_E_L_E_T_ = ''	"
	cQuery += "		AND SC5.D_E_L_E_T_ = ''	"
	cQuery += "		AND SA1.D_E_L_E_T_ = ''	"
	cQuery += "		AND SZY.D_E_L_E_T_ = ''	"
	cQuery += "		AND SC6.C6_BLQ <> 'R'	"
	cQuery += "		AND SB1.B1_DESC BETWEEN '" + AllTrim(MV_PAR03) + "' AND '" + AllTrim(MV_PAR04) + "'	"
	cQuery += "		AND SB1.B1_COD BETWEEN '" + AllTrim(MV_PAR12) + "' AND '" + AllTrim(MV_PAR13) + "'	"
	If !Empty(AllTrim(MV_PAR14))
		cQuery += "		AND SC5.C5_XPVTIPO = '" + AllTrim(MV_PAR14) + "'	"
	EndIf
	If MV_PAR05 == "F" 
		cQuery += "	AND SZY.ZY_NOTA <> ''	"
		//cQuery += "	AND SC6.C6_DATFAT BETWEEN '" + DtoS(MV_PAR10) + "' AND '" + DtoS(MV_PAR11) + "'	"
	EndIf
	If MV_PAR05 == "N"
		cQuery += "	AND SZY.ZY_NOTA = ''	"
		cQuery += "	AND SC6.C6_QTDENT < SC6.C6_QTDVEN	"
	Endif
	cQuery += "		AND SC5.C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "'	"
	//cQuery += "		AND SC6.C6_DTFATUR BETWEEN '" + DtoS(MV_PAR06) + "' AND '" + DtoS(MV_PAR07) + "'	"
	cQuery += "		AND SA1.A1_NOME BETWEEN '" + AllTrim(MV_PAR08) + "' AND '" + AllTrim(MV_PAR09) + "'	"
	cQuery += "		AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'	"
	cQuery += "		AND SC6.C6_FILIAL = '" + xFilial("SC6") + "'	"
	cQuery += "		AND SC5.C5_FILIAL = '" + xFilial("SC5") + "'	"
	cQuery += "		AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'	"	
	cQuery += "		AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "'	"	
	cQuery += "		AND SZY.ZY_PRVFAT BETWEEN '" + DtoS(MV_PAR10) + "' AND '" + DtoS(MV_PAR11) + "'	"

	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
	
	nReg := 0
	(cAlias)->( dbEval({||nReg++}) )
	
	ProcRegua(nReg)
	
	(cAlias)->(DbGoTop())
	While ((cAlias)->(!Eof()))
		IncProc()
		If lCor
								//{"Emissão"						,"OF"				,"Item da OF"		,"Nome do Cliente"				,"Codigo"					,"Produto"						,"Cod. Cliente"					,"Item do Cliente"				,"Quantidade"		,"Valor s/IPI"			,"Valor c/Imp"									,"Total"																,"Previsao Faturamento"					 ,"Data Entrega"						  	,"Pedido do Cliente"		,"Lote"							,"Shipment"					  ,"Sequencia"					,"Nota Fiscal"		,"Elaborador"					, "OTD"}
			oXml:addrow("20",	{DtoC(StoD((cAlias)->C5_EMISSAO))	,(cAlias)->C5_NUM	,(cAlias)->C6_ITEM	,SUBS((cAlias)->A1_NOME,1,30)	,AllTrim((cAlias)->B1_COD)	,AllTrim((cAlias)->C6_DESCRI)	,Alltrim((cAlias)->C6_SEUCOD)	,AllTrim((cAlias)->C6_SEUDES)	,(cAlias)->ZY_QUANT	,(cAlias)->C6_PRCVEN	,(cAlias)->C6_PRCVEN*(((cAlias)->C6_IPI/100)+1)	,(cAlias)->ZY_QUANT * ((cAlias)->C6_PRCVEN*(((cAlias)->C6_IPI/100)+1)) 	,Alltrim(DtoC(StoD((cAlias)->ZY_PRVFAT))),Alltrim(DtoC(StoD((cAlias)->ZY_DTFATUR)))	,Alltrim((cAlias)->C5_ESP1)	,Alltrim((cAlias)->C6_LOTECTL)	,Alltrim((cAlias)->C6_XXSHIPM),Alltrim((cAlias)->ZY_SEQ)	,(cAlias)->ZY_NOTA	,Alltrim((cAlias)->C5_ELABORA)	,DtoC(StoD((cAlias)->ZY_DTOTD)),iif((cAlias)->C5_XXLIBCO=="S","Liberado","Bloqueado")},;
								{oDet01								,oDet01N			,oDet01				,oDet01							,oDet01						,oDet01							,oDet01							,oDet01							,oDet01				,oDet01R				,oDet01R										,oDet01R																,oDet01									 ,oDet01									,oDet01						,oDet01							,oDet01						,oDet01							,oDet01				,oDet01							,oDet01						  ,oDet01})	
		Else		
			oXml:addrow("20",	{DtoC(StoD((cAlias)->C5_EMISSAO))	,(cAlias)->C5_NUM	,(cAlias)->C6_ITEM	,SUBS((cAlias)->A1_NOME,1,30)	,AllTrim((cAlias)->B1_COD)	,AllTrim((cAlias)->C6_DESCRI)	,Alltrim((cAlias)->C6_SEUCOD)	,AllTrim((cAlias)->C6_SEUDES)	,(cAlias)->ZY_QUANT	,(cAlias)->C6_PRCVEN	,(cAlias)->C6_PRCVEN*(((cAlias)->C6_IPI/100)+1)	,(cAlias)->ZY_QUANT * ((cAlias)->C6_PRCVEN*(((cAlias)->C6_IPI/100)+1)) 	,Alltrim(DtoC(StoD((cAlias)->ZY_PRVFAT))),Alltrim(DtoC(StoD((cAlias)->ZY_DTFATUR)))	,Alltrim((cAlias)->C5_ESP1)	,Alltrim((cAlias)->C6_LOTECTL)	,Alltrim((cAlias)->C6_XXSHIPM),Alltrim((cAlias)->ZY_SEQ)	,(cAlias)->ZY_NOTA	,Alltrim((cAlias)->C5_ELABORA)	,DtoC(StoD((cAlias)->ZY_DTOTD)),iif((cAlias)->C5_XXLIBCO=="S","Liberado","Bloqueado")},;
								{oDet02								,oDet02N			,oDet02				,oDet02							,oDet02						,oDet02							,oDet02					,oDet02							,oDet02				,oDet02R				,oDet02R												,oDet02R																,oDet02									 ,oDet02									,oDet02						,oDet02							,oDet02						  ,oDet02						,oDet02				,oDet02							,oDet02  					   ,oDet02  })
		EndIf
		lCor:=iif(lCor,.F.,.T.)
		(cAlias)->(DbSkip())
	EndDO
	
	(cAlias)->(DbCloseArea())
	

Return ()
