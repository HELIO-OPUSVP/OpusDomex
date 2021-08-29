//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 24/03/15                                                                                                                   //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//                                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Relatório para acompanhamento das OP's (versão 3)                                                                                                //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Versão 1 - DOMEST02.PRW                                                                                                                          //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMPCP06()
Private _cPerg :="DOMPCP06"+Space(02)
Private oReport
Private cFilterUser
Private oSection1
Private oSection2
Private _cArqTRB,_cInd1TRB
Private oFont , oFontN
Private cTitulo
Private _dEmissDe , _dEmissAte 
Private _dDtFatuDe , _dDtFatuAte 
Private _cNumOfDe , _cNumOfAte 
Private _dDtProdDe , _dDtProdAte 
Private _nSitOp 
Private _cTipoVenda
Private _nOP
Private _dDtEntDe , _dDtEntAte

fCriaPerg()
If Pergunte(_cPerg,.T.)

   _dEmissDe   := Mv_Par01 
   _dEmissAte  := Mv_Par02 
   _dDtFatuDe  := Mv_Par03 
   _dDtFatuAte := Mv_Par04 
   _cNumOfDe   := Mv_Par05 
   _cNumOfAte  := Mv_Par06
   _dDtProdDe  := Mv_Par07 
   _dDtProdAte := Mv_Par08
   _nSitOp     := Mv_Par09
   _cTipoVenda := Mv_Par10
   _nOP        := Mv_Par11
   _dDtEntDe   := Mv_Par12
   _dDtEntAte  := Mv_Par13

	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return

//-----------------------------------

Static Function ReportDef()
Local _cPictTit := "@E@Z 99999,999.99"
Local _cPictTot := "@E 99,999,999.99"
Local oSection1
Local oSection2
Private _nTotQtd:= 0

cTitulo:= "Acompanhamento OP -"+_cTipoVenda+"- ( "+If(_nSitOp==1,"Encerrada",If(_nSitOp==2,"Aberta",If(_nSitOp==3,"Encerrada/Aberta","OF s/ OP")))+" ) . Emissão de "+Dtoc(_dEmissDe)+" até "+Dtoc(_dEmissAte)+" - Entrega Real de "+Dtoc(_dDtEntDe)+" até "+Dtoc(_dDtEntAte)+"."
oFontN :=TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)// Negrito
oFont  :=TFont():New("Times New Roman",08,08,,.F.,,,,.F.,.F.)

oReport   :=TReport():New("DOMPCP05",cTitulo,""/*_cPerg*/,{|oReport| ReportPrint(oReport)},"Este relatório exibirá informações para acompanhamento da OP.")

oReport:SetLandScape()

oSection1:=TRSection():New(oReport,"","SC6",{},.F./*aOrder*/,.F./*lLoadCells*/,""/*cTotalText*/,.F./*lTotalInCol*/,.F./*lHeaderPage*/,.F./*lHeaderBreak*/)

TRCell():New(oSection1,"C5_EMISSAO"       ,,"Emissão"            , ,010,.F.,)
TRCell():New(oSection1,"C5_NUM"           ,,"OF"                 , ,006,.F.,)
TRCell():New(oSection1,"C6_ITEM"          ,,"Item OF"            , ,003,.F.,)
TRCell():New(oSection1,"A1_NREDUZ"        ,,"Fantasia"           , ,020,.F.,)
TRCell():New(oSection1,"C6_PRODUTO"       ,,"PN RDT"             , ,015,.F.,)
TRCell():New(oSection1,"C6_DESCRI"        ,,"Descrição"          , ,020,.F.,)
TRCell():New(oSection1,"C2_QUANT"         ,,"Qtd OP"             , ,006,.F.,)
TRCell():New(oSection1,"C6_QTDVEN"        ,,"Qtd PV"             , ,006,.F.,)
TRCell():New(oSection1,"C6_QTDENT"        ,,"Qtd Entregue"       , ,006,.F.,)
TRCell():New(oSection1,"C2_DATPRF"        ,,"Entrega"            , ,010,.F.,)
//TRCell():New(oSection1,"C2_DATRF"         ,,"Entrega Real"       , ,010,.F.,)
//TRCell():New(oSection1,"C2_EXPED"         ,,"Expedição"          , ,010,.F.,)
If !GetMV("MV_XXINVDT")
	TRCell():New(oSection1,"C6_ENTRE3"     ,,"Fatura"             , ,010,.F.,)    // Tratado
Else
	TRCell():New(oSection1,"C6_ENTREG"     ,,"Fatura"             , ,010,.F.,)    // Tratado
EndIf
TRCell():New(oSection1,"C6_SEUCOD"        ,,"PN Cliente"         , ,030,.F.,)
TRCell():New(oSection1,"C6_NUMOP"         ,,"Ordem Produção"     , ,010,.F.,)
TRCell():New(oSection1,"C6_ITEMOP"        ,,"Item OP"            , ,002,.F.,)
TRCell():New(oSection1,"C5_ESP1"          ,,"Espec.Client"       , ,034,.F.,)
TRCell():New(oSection1,"C5_TRANSP"        ,,"Transportador"      , ,006,.F.,)

oSection1:SetHeaderPage()

oSection1:Cell("C5_EMISSAO"):SetHeaderAlign("LEFT")
oSection1:Cell("C5_EMISSAO"):SetAlign("LEFT")
oSection1:Cell("C5_EMISSAO"):SetSize(10)

oSection1:Cell("C5_NUM"):SetHeaderAlign("LEFT")
oSection1:Cell("C5_NUM"):SetAlign("LEFT")
oSection1:Cell("C5_NUM"):SetSize(06)

oSection1:Cell("C6_ITEM"):SetHeaderAlign("LEFT")
oSection1:Cell("C6_ITEM"):SetAlign("LEFT")
oSection1:Cell("C6_ITEM"):SetSize(03)

oSection1:Cell("A1_NREDUZ"):SetHeaderAlign("LEFT" )
oSection1:Cell("A1_NREDUZ"):SetAlign("LEFT" )
oSection1:Cell("A1_NREDUZ"):SetSize(20)

oSection1:Cell("C6_PRODUTO"):SetHeaderAlign("LEFT" )
oSection1:Cell("C6_PRODUTO"):SetAlign("LEFT" )
oSection1:Cell("C6_PRODUTO"):SetSize(15)

oSection1:Cell("C6_DESCRI"):SetHeaderAlign("LEFT" )
oSection1:Cell("C6_DESCRI"):SetAlign("LEFT" )
oSection1:Cell("C6_DESCRI"):SetSize(20)

oSection1:Cell("C2_QUANT"):SetHeaderAlign("RIGHT")
oSection1:Cell("C2_QUANT"):SetAlign("RIGHT")
oSection1:Cell("C2_QUANT"):SetSize(06)
oSection1:Cell("C2_QUANT"):SetPicture("@ZE 999,999",06)

oSection1:Cell("C6_QTDVEN"):SetHeaderAlign("RIGHT")
oSection1:Cell("C6_QTDVEN"):SetAlign("RIGHT")
oSection1:Cell("C6_QTDVEN"):SetSize(06)
oSection1:Cell("C6_QTDVEN"):SetPicture("@ZE 999,999",06)

oSection1:Cell("C6_QTDENT"):SetHeaderAlign("RIGHT")
oSection1:Cell("C6_QTDENT"):SetAlign("RIGHT")
oSection1:Cell("C6_QTDENT"):SetSize(06)
oSection1:Cell("C6_QTDENT"):SetPicture("@ZE 999,999",06)

oSection1:Cell("C2_DATPRF"):SetHeaderAlign("RIGHT")
oSection1:Cell("C2_DATPRF"):SetAlign("RIGHT")
oSection1:Cell("C2_DATPRF"):SetSize(10)

//oSection1:Cell("C2_DATRF"):SetHeaderAlign("RIGHT")
//oSection1:Cell("C2_DATRF"):SetAlign("RIGHT")
//oSection1:Cell("C2_DATRF"):SetSize(10)

//oSection1:Cell("C2_EXPED"):SetHeaderAlign("RIGHT")
//oSection1:Cell("C2_EXPED"):SetAlign("RIGHT")
//oSection1:Cell("C2_EXPED"):SetSize(10)

If !GetMV("MV_XXINVDT")
	oSection1:Cell("C6_ENTRE3"):SetHeaderAlign("RIGHT")  // Tratado
	oSection1:Cell("C6_ENTRE3"):SetAlign("RIGHT")        // Tratado
	oSection1:Cell("C6_ENTRE3"):SetSize(10)              // Tratado
Else
	oSection1:Cell("C6_ENTREG"):SetHeaderAlign("RIGHT")  // Tratado
	oSection1:Cell("C6_ENTREG"):SetAlign("RIGHT")        // Tratado
	oSection1:Cell("C6_ENTREG"):SetSize(10)              // Tratado
EndIf

oSection1:Cell("C6_SEUCOD"):SetHeaderAlign("LEFT")
oSection1:Cell("C6_SEUCOD"):SetAlign("LEFT")
oSection1:Cell("C6_SEUCOD"):SetSize(30)

oSection1:Cell("C6_NUMOP"):SetHeaderAlign("LEFT")
oSection1:Cell("C6_NUMOP"):SetAlign("LEFT")
oSection1:Cell("C6_NUMOP"):SetSize(10)

oSection1:Cell("C6_ITEMOP"):SetHeaderAlign("LEFT")
oSection1:Cell("C6_ITEMOP"):SetAlign("LEFT")
oSection1:Cell("C6_ITEMOP"):SetSize(02)

oSection1:Cell("C5_ESP1"):SetHeaderAlign("LEFT")
oSection1:Cell("C5_ESP1"):SetAlign("LEFT")
oSection1:Cell("C5_ESP1"):SetSize(040)

oSection1:Cell("C5_TRANSP"):SetHeaderAlign("LEFT" )
oSection1:Cell("C5_TRANSP"):SetAlign("LEFT" )
oSection1:Cell("C5_TRANSP"):SetSize(06)

Return oReport

//---------------------------------------------------------

Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local nOrdem    := oSection1:GetOrder()
Local _cAlias   := GetNextAlias()
Local _nTpImpr  := oReport:nDevice
Local _cOrder   := "%C6_NUM,C6_ITEM,C6_PRODUTO%"

oReport:SetTitle(cTitulo)

Do Case
	Case _nSitOp == 1 //op encerrada
		If !GetMV("MV_XXINVDT")   // If do tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_DTFATUR,C6_ENTRE3,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C2_EXPED,C2_DATPRF,C2_DATRF,C2_QUANT,C2_QUJE,C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				,%table:SC2% SC2
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTRE3 >= %Exp:_dDtFatuDe%
				AND C6_ENTRE3 <= %Exp:_dDtFatuAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTREG >= %Exp:_dDtProdDe%
				AND C6_ENTREG <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_NUMOP = C2_NUM
				AND C6_ITEMOP = C2_ITEM
				AND C6_NUM = C2_PEDIDO
				AND C6_ITEM = C2_ITEMPV 
				AND C6_BLQ <> 'R'
				AND C2_QUANT = C2_QUJE
				AND C2_QUJE > 0
				AND C2_DATRF >= %Exp:_dDtEntDe%
				AND C2_DATRF <= %Exp:_dDtEntAte%
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				AND SC2.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		Else                   // Else do tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C2_EXPED,C2_DATPRF,C2_DATRF,C2_QUANT,C2_QUJE,C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				,%table:SC2% SC2
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTREG >= %Exp:_dDtFatuDe%
				AND C6_ENTREG <= %Exp:_dDtFatuAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTRE3 >= %Exp:_dDtProdDe%
				AND C6_ENTRE3 <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_NUMOP = C2_NUM
				AND C6_ITEMOP = C2_ITEM
				AND C6_NUM = C2_PEDIDO
				AND C6_ITEM = C2_ITEMPV
				AND C6_BLQ <> 'R'				
				AND C2_QUANT = C2_QUJE
				AND C2_QUJE > 0
				AND C2_DATRF >= %Exp:_dDtEntDe%
				AND C2_DATRF <= %Exp:_dDtEntAte%
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				AND SC2.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		EndIf              // EndIf do Tratado
	Case Mv_Par09 ==2  //op aberta
		If !GetMV("MV_XXINVDT")   // If do tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_DTFATUR,C6_ENTRE3,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C2_EXPED,C2_DATPRF,C2_DATRF,C2_QUANT,C2_QUJE,C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				,%table:SC2% SC2
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTRE3 >= %Exp:_dDtFatuDe%
				AND C6_ENTRE3 <= %Exp:_dDtFatuAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTREG >= %Exp:_dDtProdDe%
				AND C6_ENTREG <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_NUMOP = C2_NUM
				AND C6_ITEMOP = C2_ITEM
				AND C2_QUANT > C2_QUJE
				AND C6_NUM = C2_PEDIDO
				AND C6_ITEM = C2_ITEMPV
				AND C6_BLQ <> 'R'				
				AND C2_DATRF >= %Exp:_dDtEntDe%
				AND C2_DATRF <= %Exp:_dDtEntAte%
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				AND SC2.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		Else  // Else do Tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C2_EXPED,C2_DATPRF,C2_DATRF,C2_QUANT,C2_QUJE,C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				,%table:SC2% SC2
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTREG >= %Exp:_dDtFatuDe%
				AND C6_ENTREG <= %Exp:_dDtFatuAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTRE3 >= %Exp:_dDtProdDe%
				AND C6_ENTRE3 <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_NUMOP = C2_NUM
				AND C6_ITEMOP = C2_ITEM
				AND C2_QUANT > C2_QUJE
				AND C6_NUM = C2_PEDIDO
				AND C6_ITEM = C2_ITEMPV
				AND C6_BLQ <> 'R'				
				AND C2_DATRF >= %Exp:_dDtEntDe%
				AND C2_DATRF <= %Exp:_dDtEntAte%
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				AND SC2.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		EndIf  // EndIf do Tratado
	Case Mv_Par09 ==3 //Ambas Encerrada/Aberta
		If !GetMV("MV_XXINVDT")   // If do tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_DTFATUR,C6_ENTRE3,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C2_EXPED,C2_DATPRF,C2_DATRF,C2_QUANT,C2_QUJE,C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				,%table:SC2% SC2
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTRE3 >= %Exp:_dDtFatuDe%
				AND C6_ENTRE3 <= %Exp:_dDtFatuAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTREG >= %Exp:_dDtProdDe%
				AND C6_ENTREG <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_NUMOP = C2_NUM
				AND C6_ITEMOP = C2_ITEM
				AND C6_NUM = C2_PEDIDO
				AND C6_ITEM = C2_ITEMPV
				AND C6_BLQ <> 'R'				
				AND C2_DATRF >= %Exp:_dDtEntDe%
				AND C2_DATRF <= %Exp:_dDtEntAte%
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				AND SC2.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		Else  // Else do Tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C2_EXPED,C2_DATPRF,C2_DATRF,C2_QUANT,C2_QUJE,C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				,%table:SC2% SC2
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTREG >= %Exp:_dDtFatuDe%
				AND C6_ENTREG <= %Exp:_dDtFatuAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTRE3 >= %Exp:_dDtProdDe%
				AND C6_ENTRE3 <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_NUMOP = C2_NUM
				AND C6_ITEMOP = C2_ITEM
				AND C6_NUM = C2_PEDIDO
				AND C6_ITEM = C2_ITEMPV
				AND C6_BLQ <> 'R'				
				AND C2_DATRF >= %Exp:_dDtEntDe%
				AND C2_DATRF <= %Exp:_dDtEntAte%
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				AND SC2.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		EndIf  // EndIf do Tratado
	Case _nOp == 2  // 
		_cVazio:=''
		If !GetMV("MV_XXINVDT")   // If do tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_DTFATUR,C6_ENTRE3,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C6_DATFAT as C2_EXPED,C6_SUGENTR as C2_DATPRF,C6_ENTRE3 as C2_DATRF,C6_QTDVEN as C2_QUANT ,C6_QTDENT as C2_QUJE , C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTRE3 >= %Exp:_dDtFatuDe%
				AND C6_ENTRE3 <= %Exp:_dDtFatuAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTREG >= %Exp:_dDtProdDe%
				AND C6_ENTREG <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_ENTREG >= %Exp:_dDtEntDe%
				AND C6_ENTREG <= %Exp:_dDtEntAte%
				AND C6_NUMOP = %Exp:_cVazio%
				AND C6_BLQ <> 'R'				
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		Else  // Else do Tratado
			BeginSql Alias _cAlias
				SELECT  C5_EMISSAO,C5_NUM,A1_NREDUZ,C6_ITEM,C6_PRODUTO,C6_DESCRI
				,C6_QTDVEN,C6_QTDENT,C6_ENTREG,C6_SEUCOD,C6_NUMOP,C6_ITEMOP,C5_ESP1
				,C6_DATFAT as C2_EXPED,C6_SUGENTR as C2_DATPRF,C6_ENTRE3 as C2_DATRF,C6_QTDVEN as C2_QUANT ,C6_QTDENT as C2_QUJE , C5_TRANSP
				FROM %table:SB1% SB1
				,%table:SC6% SC6
				,%table:SC5% SC5
				,%table:SA1% SA1
				WHERE C5_XPVTIPO = %Exp:_cTipoVenda%
				AND C5_EMISSAO >= %Exp:_dEmissDe%
				AND C5_EMISSAO <= %Exp:_dEmissAte%
				AND C5_NUM >= %Exp:_cNumOfDe%
				AND C5_NUM <= %Exp:_cNumOfAte%
				AND C5_CLIENTE = A1_COD
				AND C5_LOJACLI = A1_LOJA
				AND C5_NUM = C6_NUM
				AND C6_ENTREG >= %Exp:_dDtEntDe%
				AND C6_ENTREG <= %Exp:_dDtEntAte%
				AND C6_QTDVEN <> C6_QTDENT
				AND C6_ENTRE3 >= %Exp:_dDtProdDe%
				AND C6_ENTRE3 <= %Exp:_dDtProdAte%
				AND C6_PRODUTO = B1_COD
				AND B1_TIPO NOT IN ('MO','SI','PR','MP')
				AND C6_ENTREG >= %Exp:_dDtEntDe%
				AND C6_ENTREG <= %Exp:_dDtEntAte%
				AND C6_NUMOP = %Exp:_cVazio%
				AND C6_BLQ <> 'R'				
				AND SB1.%notDel%
				AND SC6.%notDel%
				AND SC5.%notDel%
				AND SA1.%notDel%
				ORDER BY %Exp:_cOrder%
			EndSql
		EndIf  //EndIf do Tratado
EndCase

TcSetField(_cAlias,"C5_EMISSAO","D", 8, 0)

If !GetMV("MV_XXINVDT")
	//TcSetField(_cAlias,"C6_DTFATUR","D", 8, 0)  // Tratado
	TcSetField(_cAlias,"C6_ENTRE3","D", 8, 0)  // Tratado
Else
	TcSetField(_cAlias,"C6_ENTREG","D", 8, 0)  // Tratado
EndIf

TcSetField(_cAlias,"C2_EXPED"  ,"D", 8, 0)
TcSetField(_cAlias,"C2_DATRF"  ,"D", 8, 0)
TcSetField(_cAlias,"C2_DATPRF" ,"D", 8, 0)

oSection1:EndQuery()
_nLinha :=1
If oReport:nDevice ==4
	oSection1:Init()
EndIf

dbSelectArea(_cAlias)
While !oReport:Cancel() .And. (_cAlias)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	_nQuant:=If(Empty((_cAlias)->C2_DATRF),(_cAlias)->C2_QUANT,(_cAlias)->C2_QUJE)
	
	If oReport:nDevice == 4
		oSection1:Cell("C5_EMISSAO"):SetValue((_cAlias)->C5_EMISSAO)
		oSection1:Cell("C5_NUM"):SetValue((_cAlias)->C5_NUM)
		oSection1:Cell("A1_NREDUZ"):SetValue((_cAlias)->A1_NREDUZ)
		oSection1:Cell("C6_ITEM"):SetValue((_cAlias)->C6_ITEM)
		oSection1:Cell("C6_PRODUTO"):SetValue((_cAlias)->C6_PRODUTO)
		oSection1:Cell("C6_DESCRI"):SetValue((_cAlias)->C6_DESCRI)
		oSection1:Cell("C2_QUANT"):SetValue(_nQuant)
		oSection1:Cell("C6_QTDVEN"):SetValue((_cAlias)->C6_QTDVEN)
		oSection1:Cell("C6_QTDENT"):SetValue((_cAlias)->C6_QTDENT)
		oSection1:Cell("C2_DATPRF"):SetValue((_cAlias)->C2_DATPRF)
		//oSection1:Cell("C2_DATRF"):SetValue((_cAlias)->C2_DATRF)
		//oSection1:Cell("C2_EXPED"):SetValue((_cAlias)->C2_EXPED)
		If !GetMV("MV_XXINVDT")
			//oSection1:Cell("C6_DTFATUR"):SetValue((_cAlias)->C6_DTFATUR)  // Tratado
			oSection1:Cell("C6_ENTRE3"):SetValue((_cAlias)->C6_ENTRE3)  // Tratado
		Else
			oSection1:Cell("C6_ENTREG"):SetValue((_cAlias)->C6_ENTREG)    // Tratado
		EndIf
		oSection1:Cell("C6_SEUCOD"):SetValue((_cAlias)->C6_SEUCOD)
		oSection1:Cell("C6_NUMOP"):SetValue(Trim((_cAlias)->C6_NUMOP))
		oSection1:Cell("C6_ITEMOP"):SetValue((_cAlias)->C6_ITEMOP)
		oSection1:Cell("C5_ESP1"):SetValue((_cAlias)->C5_ESP1)
		oSection1:Cell("C5_TRANSP"):SetValue((_cAlias)->C5_TRANSP)
		oSection1:PrintLine()
	Else
		oReport:Say( oReport:Row() , oSection1:Cell("C5_EMISSAO"):ColPos() , Dtoc((_cAlias)->C5_EMISSAO) , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C5_NUM"):ColPos() , (_cAlias)->C5_NUM , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("A1_NREDUZ"):ColPos() , (_cAlias)->A1_NREDUZ , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C6_ITEM"):ColPos() , (_cAlias)->C6_ITEM , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C6_PRODUTO"):ColPos() , (_cAlias)->C6_PRODUTO , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C6_DESCRI"):ColPos() , SubStr((_cAlias)->C6_DESCRI,1,20) , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C2_QUANT"):ColPos() , TransForm(_nQuant,"@ZE 999,999") , oFont )      
		oReport:Say( oReport:Row() , oSection1:Cell("C6_QTDVEN"):ColPos() , TransForm((_cAlias)->C6_QTDVEN,"@ZE 999,999") , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C6_QTDENT"):ColPos() , TransForm((_cAlias)->C6_QTDENT,"@ZE 999,999") , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C2_DATPRF"):ColPos() , Dtoc((_cAlias)->C2_DATPRF) , oFont )
		//oReport:Say( oReport:Row() , oSection1:Cell("C2_DATRF"):ColPos() , Dtoc((_cAlias)->C2_DATRF) , oFont )
		//If !GetMV("MV_XXINVDT")
			//oReport:Say( oReport:Row() , oSection1:Cell("C2_EXPED"):ColPos() , Dtoc((_cAlias)->C2_EXPED) ,If((_cAlias)->(C6_DTFATUR < C2_EXPED) , oFontN, oFont) )  // Tratado
		//	oReport:Say( oReport:Row() , oSection1:Cell("C2_EXPED"):ColPos() , Dtoc((_cAlias)->C2_EXPED) ,If((_cAlias)->(C6_ENTRE3 < C2_EXPED) , oFontN, oFont) )  // Tratado
		//Else
		//	oReport:Say( oReport:Row() , oSection1:Cell("C2_EXPED"):ColPos() , Dtoc((_cAlias)->C2_EXPED) ,If((_cAlias)->(C6_ENTREG < C2_EXPED) , oFontN, oFont) )   // Tratado
		//EndIf
		If !GetMV("MV_XXINVDT")
			//oReport:Say( oReport:Row() , oSection1:Cell("C6_DTFATUR"):ColPos() , Dtoc((_cAlias)->C6_DTFATUR) ,If((_cAlias)->(C6_DTFATUR < C2_EXPED) , oFontN, oFont) )  // Tratado
			oReport:Say( oReport:Row() , oSection1:Cell("C6_ENTRE3"):ColPos() , Dtoc((_cAlias)->C6_ENTRE3) ,If((_cAlias)->(C6_ENTRE3 < C2_EXPED) , oFontN, oFont) )  // Tratado
		Else
			oReport:Say( oReport:Row() , oSection1:Cell("C6_ENTREG"):ColPos() , Dtoc((_cAlias)->C6_ENTREG)   ,If((_cAlias)->(C6_ENTREG  < C2_EXPED) , oFontN, oFont) )  // Tratado
		EndIf
		oReport:Say( oReport:Row() , oSection1:Cell("C6_SEUCOD"):ColPos() , (_cAlias)->C6_SEUCOD , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C6_NUMOP"):ColPos() , Trim((_cAlias)->C6_NUMOP) , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C6_ITEMOP"):ColPos() , (_cAlias)->C6_ITEMOP , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C5_ESP1"):ColPos() , SubStr((_cAlias)->C5_ESP1,1,40) , oFont )
		oReport:Say( oReport:Row() , oSection1:Cell("C5_TRANSP"):ColPos() , (_cAlias)->C5_TRANSP , oFont )
	EndIf
	
	dbSelectArea(_cAlias)
	dbSkip()
	oReport:IncMeter()
	oReport:SkipLine()
EndDo
If oReport:nDevice ==4
	oSection1:Finish()
EndIf
oReport:EndPage()
Return

//-----------------------------------------------------------

Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","Da Emissao         ?","","","mv_ch1","D",08,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Ate a Emissao      ?","","","mv_ch2","D",08,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"03","Da Fatura          ?","","","mv_ch3","D",08,00,00,"G","","mv_par03",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"04","Ate a Fatura       ?","","","mv_ch4","D",08,00,00,"G","","mv_par04",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"05","Da OF              ?","","","mv_ch5","C",06,00,00,"G","","mv_par05",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"06","Ate a OF           ?","","","mv_ch6","C",06,00,00,"G","","mv_par06",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"07","Da Producao        ?","","","mv_ch7","D",08,00,00,"G","","mv_par07",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"08","Ate a Producao     ?","","","mv_ch8","D",08,00,00,"G","","mv_par08",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
//AADD(aRegistros,{_cPerg,"09","Situacao OP        ?","","","mv_ch9","N",01,00,00,"C","","Mv_Par09","Encerrada" ,"","","","","Aberta","","","","","Encerr/Aberta","","","","","OF s/ OP","","","","","","","","",""   ,"","","","",""})
AADD(aRegistros,{_cPerg,"09","Situacao OP        ?","","","mv_ch9","N",01,00,00,"C","","Mv_Par09","Encerrada" ,"","","","","Aberta","","","","","Ambas","","","","","","","","","","","","","",""   ,"","","","",""})
AADD(aRegistros,{_cPerg,"10","Tipo Venda         ?","","","mv_chA","C",02,00,00,"C","","Mv_Par10",""    ,"","","","",""   ,"","","","","",""  ,"","","","","",""   ,"","","","","","","ZW  - ","","","","",""})
AADD(aRegistros,{_cPerg,"11","OP                 ?","","","mv_chB","N",01,00,00,"C","","Mv_Par11","Com OP" ,"","","","","Sem OP","","","","","","","","","","","","","","","","","","",""   ,"","","","",""})
AADD(aRegistros,{_cPerg,"12","Da Entrega Real    ?","","","mv_chC","D",08,00,00,"G","","mv_par12",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"13","Ate a Entrega Real ?","","","mv_chD","D",08,00,00,"G","","mv_par13",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","","","","","",""})

DbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		SX1->( MsUnlock() )
	Endif
Next i

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)