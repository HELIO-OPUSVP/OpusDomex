#include "rwmake.ch"

#include "topconn.ch"
#include "TbiCode.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BOT650DT  ºAutor  ³Helio Ferreira      º Data ³  28/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programação de Ordens de Produção                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BOT650DT()

	Local aSizeAut     := MsAdvSize(,.F.,400)
	Local aObjects	   := {}
	Local _aStru       := {}
	Private cPerg      := "BOT650DT"
	Private cPerg2     := "BOT650DT2"
	Private nMinMon    := 0
	Private nCorte     := 0
	Private aOPsRosto  := {}
	Private oGetSEQ
	Private _cSEQ      :=SPACE(03)
	Private cQRY1      :=''
	Private cQRY2      :=''
	Private cQRY3      :=''

	SG1->( dbSetOrder(1) )

	If !Pergunte(cPerg,.T.)
		Return
	EndIf

//MLS 1  DESAMARRAR PEDIDO DE VENDA COM PEDIDOSIGAEEC
//cQRY1 :=" UPDATE SC5010 SET C5_PEDEXP=''  WHERE C5_PEDEXP<>'' "
//TCSQLEXEC(cQRY1)

	AAdd( aObjects, { 0,    41, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    75, .T., .F. } )

	aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
		{{3,40,95,165,217,234,268},;
		{10,40,111,145,223,268,60},;
		{5,70,160,205,295},;
		{6,34,200,215},;
		{6,34,80,113,160,185},;
		{6,34,245,268,260},;
		{10,50,150,190},;
		{273,130,190},;
		{8,45,80,103,139,173,200,235,270},;
		{133,190,144,190,289,293},;
		{142,293,140},;
		{9,47,188,148,9,146} } )

//Define MsDialog oTelaDV2 Title OemToAnsi("BOT650DT() - Manutenção de Ordens de Produção "  ) From 0,0 To 525,1200 Pixel of oMainWnd PIXEL
	Define MsDialog oTelaDV2 Title OemToAnsi("BOT650DT() - Manutenção de Ordens de Produção. "  ) From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] Pixel of oMainWnd PIXEL

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	AADD(_aStru, {"MARCA"     ,"C",02,0} )
	AADD(_aStru, {"C2_XXDTPRO","D",08,0} )
	AADD(_aStru, {"C2_XXREVIM","C",03,0} )
	AADD(_aStru, {"C2_PRIOR"  ,"C",03,0} )
	AADD(_aStru, {"C2_OP"     ,"C",11,0} )
	AADD(_aStru, {"C2_PRODUTO","C",15,0} )
	AADD(_aStru, {"C2_DESCPRO","C",60,0} )
	AADD(_aStru, {"C2_DATPRI" ,"D",08,0} )
	AADD(_aStru, {"C2_DATPRF" ,"D",08,0} )

/*If !GetMV("MV_XXINVDT")
	AADD(_aStru, {"C6_ENTRE3","D",08,0} )  // Tratado
Else
	AADD(_aStru, {"C6_ENTREG","D",08,0} )   // Tratado
EndIf
*/

	AADD(_aStru, {"ZY_DTPCP"  ,"D",08,0} )   // SZY  (Data PCP)Tratado

	AADD(_aStru, {"B1_GRUPO"  ,"C",04,0} )  // OP/DIO/COAXIAL
	AADD(_aStru, {"C2_QUANT"  ,"N",10,4} )
	AADD(_aStru, {"C2_SALDO"  ,"N",10,4} )
	AADD(_aStru, {"MINUTOS"   ,"N",12,1} )  //CONEXTORIZACOES
	AADD(_aStru, {"C2_PEDIDO" ,"C",06,0} )
	AADD(_aStru, {"C2_ITEMPV" ,"C",02,0} )
	AADD(_aStru, {"C2_CLIENT" ,"C",06,0} )
	AADD(_aStru, {"C2_NCLIENT","C",30,0} )
	AADD(_aStru, {"CORTE"     ,"N",12,6} )
//AADD(_aStru, {"C2_LOCAL"  ,"C",02,0} )
//AADD(_aStru, {"C2_DATPRF" ,"D",08,0} )
	AADD(_aStru, {"R_E_C_N_O_","N",15,0} )

	_cArqTrab := CriaTrab(_aStru,.T.)

	dbUseArea(.T.,__LocalDriver,_cArqTrab,"TRB",.F.)

//cIndex := "C2_PRIOR+DtoS(C2_DATPRI)+C2_OP"
	cIndex := "DtoS(C2_XXDTPRO)+C2_XXREVIM+C2_PRIOR+C2_OP"

	IndRegua("TRB",_cArqTrab,cIndex,,,)

	_aCampos := {}
	cMarca  		:= GetMark()

	AADD(_aCampos,{"MARCA"      ,"" ,""                 ,""                    } )
	AADD(_aCampos,{"C2_XXDTPRO" ,"" ,"Prod."            ,"@D"                  } )
	AADD(_aCampos,{"C2_XXREVIM" ,"" ,"Rev."             ,"@R"                  } )
	AADD(_aCampos,{"C2_PRIOR"   ,"" ,"Prior."           ,"@R"                  } )
	AADD(_aCampos,{"C2_OP"      ,"" ,"OP"               ,"@R"                  } )
	AADD(_aCampos,{"C2_PRODUTO" ,"" ,"Produto"          ,"@R"                  } )
	AADD(_aCampos,{"C2_DESCPRO" ,"" ,"Descrição"        ,"@R"                  } )
	AADD(_aCampos,{"C2_DATPRI"  ,"" ,"Ini.Prod"         ,"@D"                  } )
	AADD(_aCampos,{"C2_DATPRF"  ,"" ,"Fim Prod"         ,"@D"                  } )
/*
If !GetMV("MV_XXINVDT")
	AADD(_aCampos,{"C6_ENTRE3" ,"" ,"Dt. Fatura"    ,"@D"                   } )  // Tratado
Else
	AADD(_aCampos,{"C6_ENTREG"  ,"" ,"Dt. Fatura"    ,"@D"                  } )  // Tratado
EndIf
*/
	AADD(_aCampos,{"ZY_DTPCP"   ,"" ,"Dt. PCP"    		,"@D"                  } )  // SZY - Antigo C6_ENTR3 (DT Fatura)

	AADD(_aCampos,{"B1_GRUPO"   ,"" ,"Grupo"            ,"@R"                  } )
	AADD(_aCampos,{"C2_QUANT"   ,"" ,"Qtd."             ,"@E 999,999,999.9999" } )
	AADD(_aCampos,{"C2_SALDO"   ,"" ,"Saldo"            ,"@E 999,999,999.9999" } )
	AADD(_aCampos,{"MINUTOS"    ,"" ,"Minutagem"        ,"@E 99,999,999,999.9" } )
	AADD(_aCampos,{"C2_PEDIDO"  ,"" ,"Pedido"           ,"@R"                  } )
	AADD(_aCampos,{"C2_ITEMPV"  ,"" ,"Item"             ,"@R"                  } )
	AADD(_aCampos,{"C2_CLIENT"  ,"" ,"Cliente"          ,"@R"                  } )
	AADD(_aCampos,{"C2_NCLIENT" ,"" ,"Nome"             ,"@R"                  } )
	AADD(_aCampos,{"CORTE"      ,"" ,"Corte"            ,"@E 999,999,999.9"    } )
//AADD(_aCampos,{"C2_LOCAL" ,"" ,"Local"            ,"@R"                  } )
//AADD(_aCampos,{"C2_DATPRF","" ,"Fim Prod."        ,"@R"                  } )
	AADD(_aCampos,{"R_E_C_N_O_" ,"" ,"Interno"          ,"@R"                  } )

//oMark:=MsSelect():New("__SUBS"  ,"E1_OK","!E1_SALDO",aCampos  ,@lInverte,@cMarca,{35,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight})
//oMark:= MsSelect():New("TRB"    ,"MARCA",           ,_aCampos ,.F.      ,@cMarca,{25, 05 , 230 ,595})  //595
	oMark:= MsSelect():New("TRB"    ,"MARCA",           ,_aCampos ,.F.      ,@cMarca,{25, 05 , 230 ,580})

	oMark:oBrowse:oFont:= TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oMark:oBrowse:bAllMark := { || fAllMark() }
	oMark:bMark            := { || fMark()}
	oMark:oBrowse:bChange:={|| MCHANGE()}

	nMinMax := Posicione("SBM",1,xFilial("SBM")+MV_PAR11,"BM_XXPRDIA")

//nMinMaxC := nMinMax * 0.10 //Posicione("SBM",1,xFilial("SBM")+MV_PAR11,"BM_XXPRDI2")
//nMinMaxM := nMinMax * 0.90// Posicione("SBM",1,xFilial("SBM")+MV_PAR11,"BM_XXPRDIA)

	nMinMaxC :=  Posicione("SBM",1,xFilial("SBM")+MV_PAR11,"BM_XXPRDI2")
	nMinMaxM :=  Posicione("SBM",1,xFilial("SBM")+MV_PAR11,"BM_XXPRDIA")

	nPorcent := 0
	nPorcentC := 0

	nCol     := 005
	cGrupo   := Alltrim(MV_PAR11)
	@ 04,nCol Say "1 Minutagem Máxima Corte para "+cGrupo+": "   Size 100,20                              PIXEL OF oTelaDV2
	@ 15,nCol Say "2 Minutagem Máxima Montagem para "+cGrupo+": "   Size 110,20                              PIXEL OF oTelaDV2
	nCol     += 110
	@ 04-2,nCol Say oMinMax Var Transform(nMinMaxC,"@E 999,999,999.9") Size 130,50 COLOR CLR_HBLUE     PIXEL OF oTelaDV2
	oMinMax:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ 15-2,nCol Say oMinMax Var Transform(nMinMaxM,"@E 999,999,999.9") Size 130,50 COLOR CLR_HBLUE     PIXEL OF oTelaDV2
	oMinMax:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nCol += 70
	@ 04,nCol Say "3 Minutagem Corte: "   Size 100,20                                                       PIXEL OF oTelaDV2
	@ 15,nCol Say "4 Minutagem montagem: "   Size 100,20                                                       PIXEL OF oTelaDV2
	nCol += 70
	@ 04-2,nCol Say oCorte Var Transform(nCorte,"@E 999,999,999.9") Size 130,50 COLOR CLR_HBLUE   PIXEL OF oTelaDV2
	oCorte:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ 15-2,nCol Say oMinutos Var Transform(nMinMon,"@E 999,999,999.9") Size 130,50 COLOR CLR_HBLUE   PIXEL OF oTelaDV2
	oMinutos:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)


	nCol += 70
	@ 04, nCol Say "5 Porcentagem corte: "   Size 100,20                                                     PIXEL OF oTelaDV2
	@ 15, nCol Say "6 Porcentagem montagem: "   Size 100,20                                                     PIXEL OF oTelaDV2
	nCol += 80
	@ 04-2,nCol Say oPorcentC Var Transform(nPorcentC,"@E 9,999.9") + "%" Size 130,50 COLOR CLR_BLUE    PIXEL OF oTelaDV2
	oPorcentC:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ 15-2,nCol Say oPorcent Var Transform(nPorcent,"@E 9,999.9") + "%" Size 130,50 COLOR CLR_BLUE    PIXEL OF oTelaDV2
	oPorcent:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

//oLabel:nClrText := CLR_RED                    oPorcent
//oMark:=MsSelect():New("__SUBS","E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarca,{35,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight})
//oMark:oBrowse:lhasMark := .t.
//oMark:oBrowse:lCanAllmark := .t.
//oMark:oBrowse:bAllMark := { || FA040Inverte(cMarca,oValor,oQtdtit,@nValorS,@nQtdTit,@oMark,nMoedSubs,aChaveLbn,,.T.) }
//oMark:bMark := {||Fa040Exibe(@nValorS,@nQtdTit,cMarca,&(IndexKey()),oValor,oQtdTit,nMoedSubs)}
//oMark:bAval	:= {||Fa040bAval(cMarca,oValor,oQtdtit,@nValorS,@nQtdTit,@oMark,nMoedSubs,aChaveLbn)}
//oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oMark:oBrowse:Refresh()

	Filtrar()

	@ 240,010 BITMAP ResName "PMSSETAUP"    Size 15,15 ON CLICK (U_BOT650TS('UP'))   NoBorder  Pixel
	@ 240,030 BITMAP ResName "PMSSETADOWN"  Size 15,15 ON CLICK (U_BOT650TS('DOWN')) NoBorder  Pixel

	@ 235,060 MSGET oGetSEQ VAR _cSEQ  WHEN(.T.) VALID(VALIDSEQ(_cSEQ,TRB->C2_PRIOR))   SIZE 050,13    PIXEL //MLSZ

	@ 240,260 Button "Reorganizar Pri."     Size 50,13 Action ReorgPr()       Pixel
	@ 240,320 Button "Filtrar Atrasadas"    Size 50,13 Action Filtrar2()      Pixel
	@ 240,380 Button "Data PCP(Fatura)"     Size 50,13 Action fAltDTFt()      Pixel
	@ 240,440 Button "Alterar Data"         Size 50,13 Action fAltDT()        Pixel
	@ 240,500 Button "Fechar"               Size 50,13 Action fFechar()       Pixel

	Activate MsDialog oTelaDV2

//MLS 2  AMARRACAO PEDIDO DE VENDA COM PEDIDO SIGAEEC

//cQRY2 :=" UPDATE SC5010 SET C5_PEDEXP=(SELECT TOP 1 EE7_PEDIDO FROM EE7010 WHERE EE7_PEDFAT=C5_NUM AND D_E_L_E_T_='' AND EE7_FILIAL='') "
//cQRY2 +=" WHERE D_E_L_E_T_='' AND C5_FILIAL='"+xFilial("SC5")+"'  "
//cQRY2 +=" AND EXISTS (SELECT TOP 1 EE7_PEDIDO FROM EE7010 WHERE EE7_PEDFAT=C5_NUM AND D_E_L_E_T_='' AND EE7_FILIAL='')  "
//TCSQLEXEC(cQRY2)

//cQRY3 :=" UPDATE EE7010 SET EE7_STATUS='D', EE7_STTDES='Faturado' WHERE EE7_PEDFAT IN(SELECT C5_NUM FROM SC5010 WHERE C5_PEDEXP<>'' AND C5_NOTA<>'' AND D_E_L_E_T_='') "
//cQRY3 +=" AND D_E_L_E_T_='' AND  EE7_STATUS<>'D' "
//TCSQLEXEC(cQRY3)

RETURN




Static Function Filtrar(lPerg)

	Default lPerg := .F.

	Pergunte(cPerg,lPerg)

	cQuery := " SELECT " + RetSqlName("SC2") + ".*, B1_GRUPO "
	cQuery += " FROM " + RetSqlName("SC2") + " (NOLOCK), " + RetSqlName("SB1") + " (NOLOCK) "
	cQuery += " WHERE C2_FILIAL = '"+xFilial("SC2")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND C2_NUM+C2_ITEM+C2_SEQUEN >= '"+mv_par01+"' AND C2_NUM+C2_ITEM+C2_SEQUEN <= '"+mv_par02+"' "
	cQuery += " AND C2_DATPRI >= '"+DtoS(mv_par03)+"' AND C2_DATPRI <= '"+DtoS(mv_par04)+"' AND C2_CLIENT >= '"+mv_par05+"' AND C2_CLIENT <= '"+mv_par06+"' "

	If Alltrim(mv_par11) == 'DIO'
		cQuery += "AND (B1_GRUPO = 'DIO ' OR B1_GRUPO = 'DIOE') "
	Else
		If Alltrim(mv_par11) == 'CORD'
			cQuery += "AND (B1_GRUPO = 'CORD') "
		ElseIf Alltrim(mv_par11) == 'TRUE' .Or. Alltrim(mv_par11) == 'TRUN'
			cQuery += "AND (B1_GRUPO = 'TRUE' OR B1_GRUPO = 'TRUN') "
		Else
			cQuery += "AND B1_GRUPO = '"+mv_par11+"' "
		EndIf
	EndIf

	cQuery += "AND C2_PEDIDO >= '"+mv_par07+"' AND C2_PEDIDO <= '"+mv_par08+"' AND C2_DATRF = '' AND C2_PRODUTO = B1_COD "
	If mv_par14 == 1 // Incluir OPs sem data de Programação
		cQuery += "AND (C2_XXDTPRO = '' OR (C2_XXDTPRO >= '"+DtoS(mv_par12)+"' AND C2_XXDTPRO <= '"+DtoS(mv_par13)+"')) "
	Else
		cQuery += "AND C2_XXDTPRO >= '"+DtoS(mv_par12)+"' AND C2_XXDTPRO <= '"+DtoS(mv_par13)+"' "
	EndIf
	cQuery += "AND " + RetSqlName("SC2") + ".D_E_L_E_T_ = '' AND " + RetSqlName("SB1") + ".D_E_L_E_T_ = '' "

	//Ajusta paranão deixar alterar data de prograçaõ
	/*
	cQuery += " AND C2_NUM + C2_ITEM + C2_SEQUEN NOT IN ("
	cQuery += "SELECT OP FROM( "
	cQuery += "SELECT D4_OP OP,D4_COD PROD,D4_QTDEORI QTDORI, D4_QUANT QTDD4, SUM_D3QTD = ISNULL((SELECT SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
	cQuery += "	WHERE D3_XXOP    = D4_OP "
	cQuery += "	AND   D3_COD     = D4_COD "
	cQuery += "	AND   D3_LOCAL   = D4_LOCAL "
	cQuery += " AND   D3_ESTORNO = '' "
	cQuery += "	AND   D3_CF      IN ('DE4','RE4') "
	cQuery += " AND   D3_FILIAL  =  '" + xFiliaL("SD3") + "' "
	cQuery += " AND   D4_FILIAL  =  '" + xFilial("SD4") + "' "
	cQuery += " AND   SD3.D_E_L_E_T_ = ''  ),0) "
	cQuery += " FROM " + RetSqlName("SD4") + " SD4 "
	cQuery += " JOIN " + RetSqlName("SC2") + " SC2 ON SC2.D_E_L_E_T_ ='' AND SC2.C2_FILIAL = SD4.D4_FILIAL AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN = SD4.D4_OP AND C2_XXDTPRO BETWEEN '" +DtoS(mv_par12)+"' AND '"+DtoS(mv_par13)+"' "
	cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND SB1.B1_COD = SD4.D4_COD "
	cQuery += "  JOIN ( "
	cQuery += " SELECT C2_NUM + C2_ITEM RAIZOP FROM " + RetSqlName("SC2") + " SC2 WHERE SC2.D_E_L_E_T_  = '' AND SC2.C2_FILIAL ='" + xFilial("SC2") + "' AND SC2.C2_XETQIMP = 'S' AND C2_XXDTPRO BETWEEN '" +DtoS(mv_par12)+"' AND '"+DtoS(mv_par13)+"' "
	cQuery += "  GROUP BY C2_NUM + C2_ITEM "
	cQuery += "  ) TMP2 ON  TMP2.RAIZOP = LEFT(D4_OP,8) "
	cQuery += "  WHERE "
	cQuery += "  SD4.D_E_L_E_T_ ='' AND SD4.R_E_C_D_E_L_ = 0 AND SD4.D4_QUANT > 0 AND SD4.D4_XPKLIST <> 'N'  "
	cQuery += " AND SD4.D4_FILIAL  = '"+xFilial("SD4")+"' AND SD4.D4_OPORIG = '' AND SD4.D4_LOCAL = '97' "
	cQuery += " AND SB1.B1_TIPO NOT IN ('MO','PA') AND LEFT(SB1.B1_COD,3) <> 'DMS' "
	cQuery += " AND SB1.B1_GRUPO NOT IN ('FO','FOFS') "
	cQuery += " )TMP WHERE TMP.QTDORI > TMP.SUM_D3QTD "
	cQuery += " GROUP BY TMP.OP ) "
	*/

	cQuery += "ORDER BY C2_XXDTPRO, C2_XXREVIM, C2_PRIOR, C2_NUM, C2_ITEM, C2_SEQUEN "

	If Select("QUERYSC2") <> 0
		QUERYSC2->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERYSC2"

	If !TRB->( EOF() )
		dbSelectArea("TRB")
		If GetArea()[1] == "TRB"
			Zap
		EndIf
	End

	SC6->( dbSetOrder(1) )
	SZY->( dbSetOrder(1) )

	While !QUERYSC2->( EOF() )
		If !Empty(QUERYSC2->C2_PEDIDO + QUERYSC2->C2_ITEMPV)

			If SZY->( dbSeek( xFilial() + QUERYSC2->C2_PEDIDO + QUERYSC2->C2_ITEMPV ) )
				If SZY->ZY_DTPCP < mv_par09 .or. SZY->ZY_DTPCP > mv_par10  // Tratado
					QUERYSC2->( dbSkip() )
					Loop
				EndIf
			Else
				MsgStop("Pedido " + QUERYSC2->C2_PEDIDO + " item " + QUERYSC2->C2_ITEMPV + " da OP " + Subs(QUERYSC2->C2_NUM+QUERYSC2->C2_ITEM+QUERYSC2->C2_SEQUEN,1,11) + " não encontrado na Previsão de Faturamento."+Chr(13)+"Corrigir o Numero do Pedido manualmente na OP.")
				QUERYSC2->( dbSkip() )
				Loop
			EndIf

		EndIf


		If U_VALIDACAO() .or. .T.//Roda 30/07/2021
			If Alltrim(mv_par11) == 'TRUE' .Or. Alltrim(mv_par11) == 'TRUN'
				SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100T" ) )
				_QtdMinMon:= SG1->G1_QUANT

			ElseIf  Alltrim(mv_par11) == 'DROP'
				SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100DR" ) )
				_QtdMinMon:= SG1->G1_QUANT

			ElseIf Alltrim(mv_par11) == 'JUMPER'
				SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100J" ) )
				_QtdMinMon:= SG1->G1_QUANT

			ElseIf  Alltrim(mv_par11) == 'PCON'
				SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100PC" ) )
				_QtdMinMon:= SG1->G1_QUANT
			else
				SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100" ) )
				_QtdMinMon:= SG1->G1_QUANT
			Endif

		Else

			If Alltrim(mv_par11) == 'TRUE' .Or. Alltrim(mv_par11) == 'TRUN'
				SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100T" ) )
				_QtdMinMon:= SG1->G1_QUANT
			else
				SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100" ) )
				_QtdMinMon:= SG1->G1_QUANT
			Endif
		ENDIF

		SG1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO + "50010100CORTE" ) )
		_QtdMinCor:= SG1->G1_QUANT

		SB1->( dbSeek( xFilial() + QUERYSC2->C2_PRODUTO ) )

		Reclock("TRB",.T.)
		TRB->B1_GRUPO     := Posicione("SBM",1,xFilial("SBM")+QUERYSC2->B1_GRUPO,"BM_DESC")
		TRB->C2_XXDTPRO   := StoD(QUERYSC2->C2_XXDTPRO)
		TRB->C2_XXREVIM   := QUERYSC2->C2_XXREVIM
		TRB->C2_DATPRI    := StoD(QUERYSC2->C2_DATPRI)
		TRB->C2_DATPRF    := StoD(QUERYSC2->C2_DATPRF)
		TRB->ZY_DTPCP	  := SZY->ZY_DTPCP
		TRB->C2_PRIOR     := QUERYSC2->C2_PRIOR
		TRB->C2_OP        := QUERYSC2->C2_NUM+QUERYSC2->C2_ITEM+QUERYSC2->C2_SEQUEN
		TRB->C2_PRODUTO   := QUERYSC2->C2_PRODUTO
		TRB->C2_DESCPRO   := Posicione("SB1",1,xFilial("SB1")+QUERYSC2->C2_PRODUTO,"B1_DESC")
		TRB->C2_CLIENT    := QUERYSC2->C2_CLIENT
		TRB->C2_NCLIENT   := Posicione("SA1",1,xFilial("SA1")+QUERYSC2->C2_CLIENT,"A1_NOME")
		TRB->C2_PEDIDO    := QUERYSC2->C2_PEDIDO
		TRB->C2_ITEMPV    := QUERYSC2->C2_ITEMPV
		//TRB->C2_LOCAL   := QUERYSC2->C2_LOCAL
		TRB->C2_QUANT     := QUERYSC2->C2_QUANT
		TRB->C2_SALDO     := QUERYSC2->C2_QUANT-QUERYSC2->C2_QUJE

		TRB->MINUTOS      := Round((_QtdMinMon/If(Empty(SB1->B1_QB),1,SB1->B1_QB)) * (QUERYSC2->C2_QUANT-QUERYSC2->C2_QUJE),1) //MONTAGEM
		TRB->CORTE        := Round((_QtdMinCor/If(Empty(SB1->B1_QB),1,SB1->B1_QB)) * (QUERYSC2->C2_QUANT-QUERYSC2->C2_QUJE),1) //CORTE
		//Posicione("SB1",1,xFilial("SB1")+QUERYSC2->C2_PRODUTO,"B1_XXTECOR") * (QUERYSC2->C2_QUANT-QUERYSC2->C2_QUJE)

		//TRB->C2_DATPRF  := StoD(QUERYSC2->C2_DATPRF)
		TRB->R_E_C_N_O_   := QUERYSC2->R_E_C_N_O_

		If mv_par15 == 1
			If !Empty(QUERYSC2->C2_XXDTPRO)
				TRB->MARCA := cMarca
				fMark()
			EndIf
		EndIf
		TRB->( msUnlock() )
		QUERYSC2->( dbSkip() )
	End

	TRB->( dbGotop() )
	oMark:oBrowse:Refresh()

Return


Static Function Filtrar2(lPerg)

	Pergunte(cPerg,.F.)

	cQuery := "SELECT * FROM " + RetSqlName("SC2") + " (NOLOCK) WHERE C2_FILIAL = '"+xFilial("SC2")+"' AND C2_NUM+C2_ITEM+C2_SEQUEN >= '"+mv_par01+"' AND C2_NUM+C2_ITEM+C2_SEQUEN <= '"+mv_par02+"' "
	cQuery += "AND C2_DATPRF <  '"+DtoS(dDataBase)+"' AND C2_CLIENT >= '"+mv_par05+"' AND C2_CLIENT <= '"+mv_par06+"' "
	cQuery += "AND C2_PEDIDO >= '"+mv_par07+"' AND C2_PEDIDO <= '"+mv_par08+"' AND C2_DATRF = '' AND D_E_L_E_T_ = '' "

	If Select("QUERYSC2") <> 0
		QUERYSC2->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERYSC2"

	If !TRB->( EOF() )
		dbSelectArea("TRB")
		If GetArea()[1] == "TRB"
			Zap
		EndIf
	End

	While !QUERYSC2->( EOF() )
		Reclock("TRB",.T.)
		TRB->C2_XXDTPRO  := StoD(QUERYSC2->C2_XXDTPRO)
		TRB->C2_XXREVIM  := QUERYSC2->C2_XXREVIM
		TRB->C2_DATPRI   := StoD(QUERYSC2->C2_DATPRI)
		TRB->C2_DATPRF   := StoD(QUERYSC2->C2_DATPRF)
		TRB->C2_OP       := QUERYSC2->C2_NUM+QUERYSC2->C2_ITEM+QUERYSC2->C2_SEQUEN
		TRB->C2_PRODUTO  := QUERYSC2->C2_PRODUTO
		TRB->C2_DESCPRO  := Posicione("SB1",1,xFilial("SB1")+QUERYSC2->C2_PRODUTO,"B1_DESC")
		TRB->C2_CLIENT   := QUERYSC2->C2_CLIENT
		TRB->C2_NCLIENT  := Posicione("SA1",1,xFilial("SA1")+QUERYSC2->C2_CLIENT,"A1_NOME")
		TRB->C2_PEDIDO   := QUERYSC2->C2_PEDIDO
		TRB->C2_ITEMPV   := QUERYSC2->C2_ITEMPV
		//TRB->C2_LOCAL    := QUERYSC2->C2_LOCAL
		TRB->C2_QUANT    := QUERYSC2->C2_QUANT
		//TRB->C2_DATPRF   := StoD(QUERYSC2->C2_DATPRF)
		TRB->R_E_C_N_O_  := QUERYSC2->R_E_C_N_O_

		If SZY->( dbSeek( xFilial() + QUERYSC2->C2_PEDIDO + QUERYSC2->C2_ITEMPV ) )
			TRB->ZY_DTPCP    := SZY->ZY_DTPCP
		endif


		TRB->( msUnlock() )
		QUERYSC2->( dbSkip() )
	End

	TRB->( dbGotop() )
	oMark:oBrowse:Refresh()

Return


Static Function fAltDT()
	Local cNumOpAtu := ""
	Local lEmiteAviso := .F.
	SC2->( dbSetOrder(1) )

	If Pergunte(cPerg2,.T.)
		//If !Empty(mv_par01)
		TRB->( dbGoTop() )
		lImpOPs := Nil
		While !TRB->( EOF() )
			If !Empty(TRB->MARCA)
				If TRB->C2_XXDTPRO <> mv_par01 .or. (!Empty(mv_par01) .and. (TRB->C2_DATPRI <> mv_par01 .or. TRB->C2_DATPRF  <> mv_par02))

					SC2->( dbGoTo(TRB->R_E_C_N_O_) )
					/*
					If cNumOpAtu <> SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
						cNumOpAtu := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
						lEmiteAviso := .T.
						lAlteraOp := .F.
						lVldAltOp := VerPkList(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) 
						If lVldAltOp
							If SC2->C2_XETQIMP <> 'S'
								lAlteraOp := .T.	
							Else
								lAlteraOp := .F.
							EndIf
						EndIf
					Else
						lEmiteAviso := .F.
					EndIf		
					*/
					cIniNumOP := SC2->C2_NUM + SC2->C2_ITEM
					//If lAlteraOp
					While !SC2->( EOF() ) .and. SC2->C2_NUM + SC2->C2_ITEM == cIniNumOP
						//If SC2->C2_DATPRI <> mv_par01 .or. SC2->C2_XXDTPRO <> mv_par01 .or. SC2->C2_DATPRF <> mv_par01 .or. TRB->C2_DATPRI <> mv_par01 .or. TRB->C2_XXDTPRO <> mv_par01
						If Empty(SC2->C2_STATUS)
							If lImpOPS == Nil
								/*
									If MsgYesNo("Deseja imprimir as OPs não programadas?")
								lAuto    := .T.
								cImpOP   := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
								dDtExped := mv_par01
								
								aAreaSC2 := SC2->( GetArea() )
								
								U_RPCPR01C(lAuto,cImpOP,dDtExped)
								
								RestArea(aAreaSC2)
								
								lImpOPS := .T.
								
										If aScan(aOPsRosto,SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN) == 0
								AADD(aOPsRosto,SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
										EndIf
									Else
								lImpOPS := .F.
									EndIf
								*/
								lImpOPS := .F.
							Else
								If lImpOPs
									lAuto    := .T.
									cImpOP   := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
									dDtExped := mv_par01

									aAreaSC2 := SC2->( GetArea() )

									U_RPCPR01C(lAuto,cImpOP,dDtExped)

									RestArea(aAreaSC2)

									If aScan(aOPsRosto,SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN) == 0
										AADD(aOPsRosto,SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
									EndIf
								EndIf
							EndIf
						EndIf

						Pergunte(cPerg2,.F.)

						If Reclock("SC2",.F.)
							SC2->C2_XXDTPRO := mv_par01
							If !Empty(mv_par01)
								SC2->C2_DATPRI  := mv_par01
								SC2->C2_DATPRF  := mv_par02
							EndIf
							SC2->( msUnlock() )

							Reclock("TRB",.F.)
							TRB->C2_XXDTPRO := mv_par01
							If !Empty(mv_par01)
								TRB->C2_DATPRI  := mv_par01
								TRB->C2_DATPRF  := mv_par02
							EndIf
							TRB->( msUnlock() )

							SD4->( dbSetOrder(2) )
							lOPOK := .T.
							If !Empty(mv_par01)
								If SD4->( dbSeek( xFilial() + Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11) ) )
									While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11)
										Reclock("SD4",.F.)
										SD4->D4_DATA := mv_par01
										SD4->( msUnlock() )
										SD4->( dbSkip() )

										lRet := .T. // U_RESEPROD(Subs(SD4->D4_OP,1,11), SD4->D4_COD, SD4->D4_QUANT)
										If !lRet
											lOPOK := .F.
										EndIf
									End
								EndIf

								// RESERVA DE MATERIAIS. CONTINUAR FUTURAMENTE

								//If lOPOK
								//	Reclock("SC2",.F.)
								//	SC2->C2_XXRESER := "S"
								//	SC2->( msUnlock() )
								//Else
								//	Reclock("SC2",.F.)
								//	SC2->C2_XXRESER := "N"
								//	SC2->( msUnlock() )
								//EndIf
							EndIf

						Else
							MsgStop("Não foi possível alterar a OP " + Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11)+".")
						EndIf
						//EndIf
						SC2->( dbSkip() )
					End
					TRB->( dbGotop() )
					//Else
					//DbSelectArea("TRB")
					//If lEmiteAviso
					//	MsgAlert("OP " + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN +" PICKLIST INICIADO","ERRO PICKLIST")
					//Endif
					//EndIf
				EndIf
			EndIf
			TRB->( dbSkip() )
		End
		TRB->( dbGotop() )
		oMark:oBrowse:Refresh()
		//EndIf
	EndIf

Return

Static Function fAllMark()

	Local nRecno := TRB->( Recno() )

	TRB->( dbGoTop() )

	While !TRB->( EOF() )
		Reclock("TRB",.F.)
		If TRB->MARCA == cMarca
			TRB->MARCA := ''
			nMinMon    -= TRB->MINUTOS
			nCorte     -= TRB->CORTE
		Else
			TRB->MARCA := cMarca
			nMinMon   += TRB->MINUTOS
			nCorte     += TRB->CORTE
		EndIf
		TRB->( msUnlock() )
		TRB->( dbSkip() )
	End

	nPorcent := (nMinMon/nMinMaxM)*100
	nPorcentC := (nCorte/nMinMaxC)*100

	If nPorcent >= 95
		oPorcent:nClrText := CLR_RED
	Else
		oPorcent:nClrText := CLR_BLUE
	EndIf

	If nPorcentC >= 95
		oPorcentC:nClrText := CLR_RED
	Else
		oPorcentC:nClrText := CLR_BLUE
	EndIf


	oMinutos:Refresh()
	oPorcent:Refresh()
	oPorcentC:Refresh()
	oCorte:Refresh()

	TRB->( dbGoTo(nRecno) )

Return

Static Function fMark()

	If TRB->MARCA == cMarca
		nMinMon  += TRB->MINUTOS
		nCorte   += TRB->CORTE
	Else
		nMinMon  -= TRB->MINUTOS
		nCorte   -= TRB->CORTE
	EndIf

	nPorcent := (nMinMon/nMinMaxM)*100
	nPorcentC := (nCorte/nMinMaxC)*100

	If nPorcent >= 95
		oPorcent:nClrText := CLR_RED
	Else
		oPorcent:nClrText := CLR_BLUE
	EndIf

	If nPorcentC >= 95
		oPorcentC:nClrText := CLR_RED
	Else
		oPorcentC:nClrText := CLR_BLUE
	EndIf


	oMinutos:Refresh()
	oPorcent:Refresh()
	oPorcentC:Refresh()
	oCorte:Refresh()

Return

Static Function fFechar()
	Local x
	Close(oTelaDV2)

	If !Empty(aOPsRosto)
		If MsgYesNo("Deseja imprimir as folhas de rosto?")
			For x := 1 to Len(aOPsRosto)
				SC2->( dbSetOrder(1) )
				SC2->( dbSeek( xFilial() + aOPsRosto[x] ) )

				lAuto    := .T.
				cImpOP   := aOPsRosto[x]
				dDtExped := SC2->C2_XXDTPRO

				U_RPCPR01C(lAuto,cImpOP,dDtExped)
			Next x
		EndIf
	EndIf

//mls 2
//cQRY2 :=" UPDATE SC5010 SET C5_PEDEXP=(SELECT TOP 1 EE7_PEDIDO FROM EE7010 WHERE EE7_PEDFAT=C5_NUM AND D_E_L_E_T_='' AND EE7_FILIAL='') "
//cQRY2 +=" WHERE D_E_L_E_T_='' AND C5_FILIAL='"+xFilial("SC5")+"'  "
//cQRY2 +=" AND EXISTS (SELECT TOP 1 EE7_PEDIDO FROM EE7010 WHERE EE7_PEDFAT=C5_NUM AND D_E_L_E_T_='' AND EE7_FILIAL='')  "
//TCSQLEXEC(cQRY2)

Return

	*---------------------------------------------------*
STATIC FUNCTION fAltDTFt()
	*---------------------------------------------------*
	LOCAL _dDTFAT :=(date())
	LOCAL _dDTFAT2:=(date())
	LOCAL oGet1
	LOCAL oGet2
	LOCAL lOk :=.T.
	LOCAL oTelaDTFT
	Local dDtOld := Ctod("  /  /  ")
	Local dDtNew := Ctod("  /  /  ")
	Local aItEmail := {}
	_dDTFAT:=TRB->ZY_DTPCP

	IF   EMPTY(TRB->C2_PEDIDO)
		MsgStop("OP " + TRB->C2_OP + " Sem numero de Pedido de Venda."+Chr(13)+" ")
	ELSE

		Define MsDialog oTelaDTFT Title OemToAnsi("BOT650DT() - Manutenção da Data de Fatura "  ) From 0,0 To 200,440 Pixel of oMainWnd PIXEL

		@ 010,010 Say "OP " +TRB->C2_OP                                   Size 100,10  OF oTelaDTFT  PIXEL
		@ 020,010 Say substr(TRB->C2_PRODUTO+'   '+TRB->C2_DESCPRO,1,50)     Size 200,10  OF oTelaDTFT  PIXEL

		@ 033,010 Say "De   Dt.Fatura "                 Size 100,10  OF oTelaDTFT  PIXEL
		@ 033,050 MSGET oGet1 VAR _dDTFAT  WHEN(.F.)    SIZE 100,10  OF oTelaDTFT  PIXEL
		@ 043,010 Say "Para Dt.Fatura "                 Size 100,10  OF oTelaDTFT  PIXEL
		@ 043,050 MSGET oGet2 VAR _dDTFAT2 WHEN(.T.)    SIZE 100,10  OF oTelaDTFT  PIXEL

		ACTIVATE MSDIALOG oTelaDTFT CENTER ON INIT EnchoiceBar(oTelaDTFT,{||(lOk:=.T.,oTelaDTFT:End())},{||(lOk:=.F.,oTelaDTFT:End())})

		IF lOk==.T.
//===========================================================================	
			TRB->( dbGoTop() )

			While !TRB->( EOF() )
				If !Empty(TRB->MARCA)

					//********************************

					SZY->(dbSetOrder(1))
					If SZY->(dbSeek(xFilial("SZY")+TRB->C2_PEDIDO + TRB->C2_ITEMPV))
						//	nSomaItem := 0
						Do While SZY->(!Eof()) .And. SZY->ZY_FILIAL+SZY->ZY_PEDIDO+SZY->ZY_ITEM == xFilial("SZY")+TRB->C2_PEDIDO + TRB->C2_ITEMPV
							Reclock("SZY",.F.)
							if empty(SZY->ZY_PRVFAT)
								SZY->ZY_PRVFAT := _dDTFAT2
							endif
							SZY->ZY_DTPCP	:= _dDTFAT2

							SZY->( msUnlock() )

							//If Empty(SZY->ZY_NOTA)
							//	If ( SZY->ZY_DTPCP <> SZY->ZY_PRVFAT ) .And. !Empty(SZY->ZY_PRVFAT)
							//		Alert("A data do item "+SZY->ZY_ITEM+" está diferente da previsão de faturamento.")
							//		_Retorno := .F.
							//	EndIf
							//EndIf

							//nSomaItem += SZY->ZY_QUANT

							SZY->(dbSkip())
						EndDo

						Reclock("TRB",.F.)
						TRB->ZY_DTPCP:=_dDTFAT2
						TRB->( msUnlock() )

					Endif

					// ATUALIZA O C6_ENTRE3  (sera desabilitado)
					If SC6->( dbSeek( xFilial('SC6') + TRB->C2_PEDIDO + TRB->C2_ITEMPV ) )
						Reclock("SC6",.F.)
						//Grava a data de preenchimento do prazo do PCP - Osmar Ferreira 13/04/21
						If (Empty(SC6->C6_ENTRE3)) .Or. (SC6->C6_ENTRE3 <> _dDTFAT2)

							If SC6->C6_ENTRE3 <> _dDTFAT2
								dDtOld    := SC6->C6_ENTRE3
								dDtNew    := _dDTFAT2
								aaDD(aItEmail,{SC6->C6_NUM,SC6->C6_ITEM,dDtOld,dDtNew,'',''})
								//aaDD(aItEmail,{SC6->C6_NUM,SC6->C6_ITEM,dDtOld,dDtNew,'','','',''})
							EndIf

							SC6->C6_XDTPCP := Date()
							SC6->C6_XHRPCP := Time()

						EndIf
						SC6->C6_ENTRE3:=_dDTFAT2
						SC6->( msUnlock() )

						//fGrvTempo(SC6->C6_NUM)

						//	oMark:oBrowse:Refresh()
					Endif
					//********************************

				Endif
				TRB->( dbSkip() )
			EndDo

			If Len(aItEmail) > 0
				fDatMail(aItEmail)
				aItEmail := {}
			EndIf

			//===========================================================================

		ENDIF

		// Atualiza TELA com alterações
		TRB->( dbGotop() )
		oMark:oBrowse:Refresh()
		oTelaDV2:Refresh()

	ENDIF

RETURN

	*----------------------------------------------------------------------------*
USER FUNCTION BOT650TS(cBOT)
	*----------------------------------------------------------------------------*

	cRECNO:=TRB->( RECNO() )

	IF cBOT=='UP'
		_cSEQUEN :=TRB->C2_PRIOR

		TRB->(DBSKIP(-1))
		IF !TRB->(BOF())
			Reclock("TRB",.F.)
			TRB->C2_PRIOR:=_cSEQUEN
			TRB->( msUnlock() )

			Reclock("TRB",.F.)
			TRB->C2_PRIOR:=STRZERO(((VAL(_cSEQUEN))-1),3)
			TRB->( msUnlock() )

			Do While !TRB->( EOF() )
				_cSequen:=SOMA1(_cSequen)
				Reclock("TRB",.F.)
				TRB->C2_PRIOR:=_cSequen
				TRB->( msUnlock() )
				TRB->(DBSKIP())
			ENDDO
		ENDIF
	ENDIF

	IF cBOT=='DOWN'
		_cSEQUEN :=TRB->C2_PRIOR

		Reclock("TRB",.F.)
		TRB->C2_PRIOR:=SOMA1(_cSequen)
		TRB->( msUnlock() )

		TRB->(DBSKIP())

	ENDIF

	ReorgPr()
	oMark:oBrowse:Refresh()
	TRB->( dbGoTo(cRECNO) )
	_cSEQ      :=TRB->C2_PRIOR
	oGetSEQ :REFRESH()

RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION ReorgPr()
	*----------------------------------------------------------------------------*

	Local cSequen :='000'
	TRB->( dbGoTop() )
	Do While !TRB->( EOF() )
		cSequen :=SOMA1(cSequen)
		Reclock("TRB",.F.)
		TRB->C2_PRIOR:=cSequen
		TRB->( msUnlock() )
		If SC2->( dbSeek( xFilial('SC2') + TRB->C2_OP ) )
			Reclock("SC2",.F.)
			SC2->C2_PRIOR:=cSequen
			SC2->( msUnlock() )
		ENDIF
		TRB->(DBSKIP())
	ENDDO
	oMark:oBrowse:Refresh()
RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION MCHANGE()
	*----------------------------------------------------------------------------*
	_cSEQ  :=TRB->C2_PRIOR
	oGetSEQ:REFRESH()
RETURN

	*----------------------------------------------------------------------------*
STATIC FUNCTION VALIDSEQ(_cSEQ1,_cSEQ2)
	*----------------------------------------------------------------------------*
	Local _cRECNO:=TRB->( RECNO() )

	Reclock("TRB",.F.)
	TRB->C2_PRIOR:=_cSEQ1
	TRB->( msUnlock() )

	ReorgPr()
	oMark:oBrowse:Refresh()
	TRB->( dbGoTo(_cRECNO) )
	_cSEQ      :=TRB->C2_PRIOR
	oGetSEQ :REFRESH()
	oMark:oBrowse:Refresh()

RETURN



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
		//aItens[x,7] := SC5->C5_CLIENTE
		//aItens[x,8] := SC5->C5_LOJACLI
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

		cMsg := "Elaborador do pedido: "+ aElaborador[y,1] +'<br>'
		cMsg += "<br>"
		cMsg += "Alteração feita em "+Dtoc(Date())+" - "+Time()+'<br>'
		cMsg += "Por: "+ SubString(cUsuario,7,15)+'<br>'
		cMsg += "<br>"

		cMsg += "PEDIDO / ITEM"+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ' +;
			"DE"+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ' + "PARA" + '<br>'
		SA1->( dbSetOrder(01) )
		For x := 1 To Len(aItens)
			If aElaborador[y,1] == aItens[x,5]

				//SA1->(dbSeek(xFilial()+aItens[x,7]+aItens[x,8]))
				//cMsg += aItens[x,1]+" / "+aItens[x,2]+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+Dtoc(aItens[x,3])+' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+Dtoc(aItens[x,4])+;
					//		'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+aItens[x,7]+'/'+aItens[x,8]+' - '+AllTrim(SA1->A1_NOME)+'<br>'

				cMsg += aItens[x,1]+" / "+aItens[x,2]+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+Dtoc(aItens[x,3])+' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+Dtoc(aItens[x,4])+'<br>'

			EndIf
		Next x

		Sleep(4000)
		U_EnvMailto("Alteração de data (PCP) " ,cMsg,cEmail,"",)

	Next y

	RestArea(aAreaSA1)
	RestArea(aAreaSC5)

Return

//Grava o tempo entre a data de emissão e a data de lançamento da data do PCP
//Static Function fGrvTempo(cPedido)
//	Local nHH, nMM := 0
//	Local aAreaSC5 := SC5->( GetArea() )
//	SC5->( dbSetOrder(01) )
//	SC5->(dbSeek(xFilial()+cPedido))
//	If !Empty(SC5->C5_XHREMIS)
//		nHH := ((SC6->C6_XDTPCP - SC5->C5_EMISSAO) * 24) + (Val(SubStr(SC6->C6_XHRPCP,1,2)) - Val(SubStr(SC5->C5_XHREMIS,1,2)))
//		nMM := Val(SubStr(SC6->C6_XHRPCP,4,2)) - Val(SubStr(SC5->C5_XHREMIS,4,2))
//
//		If nMM >= 0
//			nMM := nMM / 100
//			nHH := nHH + nMM
//		Else
//			nMM := nMM * (-1)
//			nHH := nHH - (nMM / 60)
//			nMM := nHH - Int(nHH)
//			nHH := Int(nHH) + (nMM * 60 / 100)
//		EndIf
//
//		Reclock("SC6",.F.)
//		SC6->C6_XHRPV := nHH
//		SC6->( msUnlock() )
//	EndIf
//	RestArea(aAreaSC5)
//Return

Static Function VerPkList(cNUmOpVld)
	Local lRet := .T.
	Local cQuery := ""
	Local aAreaAtu := GetArea()

	cQuery += "SELECT OP FROM( "
	cQuery += "SELECT D4_OP OP,D4_COD PROD,D4_QTDEORI QTDORI, D4_QUANT QTDD4, SUM_D3QTD = ISNULL((SELECT SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
	cQuery += "	WHERE D3_XXOP    = D4_OP "
	cQuery += "	AND   D3_COD     = D4_COD "
	cQuery += "	AND   D3_LOCAL   = D4_LOCAL "
	cQuery += " AND   D3_ESTORNO = '' "
	cQuery += "	AND   D3_CF      IN ('DE4','RE4') "
	cQuery += " AND   D3_FILIAL  =  '" + xFiliaL("SD3") + "' "
	cQuery += " AND   D4_FILIAL  =  '" + xFilial("SD4") + "' "
	cQuery += " AND   SD3.D_E_L_E_T_ = ''  ),0) "
	cQuery += " FROM " + RetSqlName("SD4") + " SD4 "
	cQuery += " JOIN " + RetSqlName("SC2") + " SC2 ON SC2.D_E_L_E_T_ ='' AND SC2.C2_FILIAL = SD4.D4_FILIAL AND SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN = SD4.D4_OP AND C2_XXDTPRO BETWEEN '" +DtoS(mv_par12)+"' AND '"+DtoS(mv_par13)+"' "
	cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ ='' AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND SB1.B1_COD = SD4.D4_COD "
	cQuery += "  JOIN ( "
	cQuery += " SELECT C2_NUM + C2_ITEM RAIZOP FROM " + RetSqlName("SC2") + " SC2 WHERE SC2.D_E_L_E_T_  = '' AND SC2.C2_FILIAL ='" + xFilial("SC2") + "' AND SC2.C2_XETQIMP = 'S' AND C2_XXDTPRO BETWEEN '" +DtoS(mv_par12)+"' AND '"+DtoS(mv_par13)+"' "
	cQuery += "  GROUP BY C2_NUM + C2_ITEM "
	cQuery += "  ) TMP2 ON  TMP2.RAIZOP = LEFT(D4_OP,8) "
	cQuery += "  WHERE "
	cQuery += "  SD4.D_E_L_E_T_ ='' AND SD4.R_E_C_D_E_L_ = 0 AND SD4.D4_QUANT > 0 AND SD4.D4_XPKLIST <> 'N' AND SD4.D4_OP = '" + cNUmOpVld + "' "
	cQuery += " AND SD4.D4_FILIAL  = '"+xFilial("SD4")+"' AND SD4.D4_OPORIG = '' AND SD4.D4_LOCAL = '97' "
	cQuery += " AND SB1.B1_TIPO NOT IN ('MO','PA') AND LEFT(SB1.B1_COD,3) <> 'DMS' "
	cQuery += " AND SB1.B1_GRUPO NOT IN ('FO','FOFS') "
	cQuery += " )TMP WHERE TMP.QTDORI > TMP.SUM_D3QTD "
	cQuery += " GROUP BY TMP.OP "
	If Select("TVERPK")	> 0
		TVERPK->(DbCloseArea())
	Endif

	TCQUERY cQuery NEW ALIAS "TVERPK"

	If TVERPK->(!EOF())
		If Alltrim(TVERPK->OP) == Alltrim(cNUmOpVld)
			lRet := .F.
		Else
			lRet := .T.
		EndIf
	Else
		lRet := .T.
	EndIf

	If Select("TVERPK")	> 0
		TVERPK->(DbCloseArea())
	Endif
	RestArea(aAreaAtu)
Return lRet


