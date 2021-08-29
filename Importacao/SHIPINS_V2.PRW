#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#define PAD_LEFT   0
#define PAD_RIGHT  1
#define PAD_CENTER 2

*-----------------------------------------------------------------------*
User Function ShipIns2()
	*-----------------------------------------------------------------------*
	Local   cQuery    := ""
	Local   cAlias    :="WRK"

	Private cUser     := SubStr(cUsuario,7,15)
	Private cPerg     := "SHIPING"
	Private cQuery    := ""
	Private nLin      := 0
	Private cDesFo    := Space(030)//mls
	Private cEnd      := Space(030)//mls
	Private nCAB      := 1
	Private cDrawback :=SPACE(01)
	Private cPPB      :=SPACE(01)

	//Objetos para tamanho e tipo das fontes
	Private oFont1 := TFont():New( "Tahoma"         ,,16,,.T.,,,,,.F.)
	Private oFont2 := TFont():New( "Tahoma"         ,,08,,.T.,,,,,.F.)
	Private oFont3 := TFont():New( "Tahoma"         ,,08,,.F.,,,,,.F.)
	Private oFont4 := TFont():New( "Tahoma"         ,,10,,.F.,,,,,.F.)
	Private oFont5 := TFont():New( "Tahoma"         ,,08,,.F.,,,,,.F.)
	Private oFont6 := TFont():New( "Tahoma"         ,,06,,.F.,,,,,.F.)    // mls
	Private oPrn  := TMSPrinter():New("Impressão de Shipping Instructions")

	Private cVia    := ""
	Private cForn   := ""
	Private DesFo   := ""
	Private cEnd    := ""
	Private cPaisFo := ""
	Private cContFo := ""
	Private cTel    := ""
	Private cFax    := ""
	Private cPaym   := ""
	Private cAirDep := ""
	Private cAirDes := ""
	Private cInc    := ""
	Private cPais   := ""
	Private cAlias  := "WRK"
	Private nLin    := 0
	Private nCol    := 0
	Private nCol1,nCol2,nCol3,nCol4,nCol5,nCol6,nCol7,nCol8,nCol9,nCOL10 := 0
	Private nTotVlr :=0
	Private nTotPes :=0
	Private cDesp   :=""
	Private cAgent  :=""

	Private _cDescr :=""
	Private cDESCR1 :=""
	Private cDESCR2 :=""
	Private cDESCR3 :=""
	Private cDESCR4 :=""
	Private cDESCR5 :=""
	Private cDESCR6 :=""
	Private cDESCR7 :=""
	Private cDESCR8 :=""
	Private cDESCR9 :=""
	Private cDESCRA :=""
	Private cUM     :=""
	Private Ctipo   :=""

	Pergunte(cPerg,.T.)

	Lseg:=.f.
	npag:=1
	lfim :=.f.

	oPrn:SetUp()         // Abre opcoes para o usuario
	oPrn:SetPortrait()   // ou SetLandscape()
	oPrn:Line(nLin,150,nLin, 2330)

	*----------------------------------------------------------------------------------------------------------------*
	cQuery := " SELECT SW7.W7_PO_NUM, SW7.W7_COD_I ,SW7.W7_FABR, SW7.W7_FORN , SW7.W7_QTDE,  "
	cQuery += " SW7.W7_PRECO, SW7.W7_HAWB, SW7.W7_DI_NUM, SW7.W7_PESO, SW7.W7_NCM , "
	cQuery += " (SELECT TOP 1 SA5.A5_CODPRF FROM "+ RetSqlName("SA5")+" (NOLOCK) SA5  "
	cQuery += "        WHERE SA5.A5_PRODUTO =  SW7.W7_COD_I  "
	cQuery += "              AND SA5.A5_FORNECE = SW7.W7_FORN  "
	cQuery += "              AND SA5.A5_FABR    = SW7.W7_FABR  "
	cQuery += "              AND SA5.A5_FILIAL='"+XFILIAL('SA5')+"'  "
	cQuery += "              AND D_E_L_E_T_='' AND A5_CODPRF<>'') "
	cQuery += " AS A5_CODPRF "
	cQuery += " FROM "+ RetSqlName("SW7")+" (NOLOCK) SW7 "
	cQuery += " WHERE W7_HAWB ='"+Mv_par01+"' "
	cQuery += " AND W7_FORN+W7_FORLOJ >='"+Mv_par02+Mv_par03+"' AND W7_FORN+W7_FORLOJ<= '"+Mv_par04+Mv_par05+"' "
	cQuery += " AND SW7.D_E_L_E_T_ =''  "
	cQuery += " AND SW7.W7_FILIAL='"+XFILIAL('SW7')+"'  "
	cQuery += " ORDER BY W7_FORN,W7_COD_I  "
	*----------------------------------------------------------------------------------------------------------------*

	TcQuery cQuery Alias "WRK" New

	DbSelectArea("WRK")
	("WRK")->(DbGoTop())

	If Eof()
		Alert("Nao foi encontrado nenhum item neste Processo de Embarque!")
		DbSelectArea("WRK")
		DbCloseArea()
		Return()
	EndIf

	_cFORNECE :=SPACE(06)
	_lFIRST   :=.T.
	Do While !(eof()) .And.!Empty(WRK->W7_PO_NUM)
		IF WRK->W7_FORN <> _cFORNECE
			_cFORNECE :=WRK->W7_FORN
			IF _lFIRST==.F.
				nLin :=nLin-40
				GeraCol()
				GeraRod()
				oPrn:EndPage()
				nLin :=0
				npag :=1
			ENDIF
			nLin :=0
			npag :=1
			GeraCab()
			_lFIRST:=.F.
		ENDIF
		GERAITM()
		IF nlin >= 3000   //3000         //MLS
			npag++
			GeraCol()
			Lseg:=.t.
			_lFIRST:=.F.
			nlin :=120
			oPrn:EndPage()
			oPrn:StartPage()
		endif
		WRK->(dbskip())
	ENDDO
	//finaliza a pagina
	//if Lseg==.t.
	//   nlin :=60
	//endif
	lfim :=.t.
	GeraCol()
	GeraRod()
	oPrn:EndPage()
	oPrn:Preview()
	oPrn:End()

	if Select("WRK") >0
		WRK->(dbCloseArea())
	EndIf

RETURN

*----------------------------------------------------------------------*
Static Function GERAITM()
	oPrn    :Say(nlin, nCol,  WRK->W7_PO_NUM     ,oFont3,100) //purchase prder
	nCol    := nCol+190
	nCol1   := nCol-10
	oPrn:Say(nlin, nCol,  WRK->W7_COD_I      ,oFont3,100)  //rdt part number
	nCol    := nCol+270
	nCol2   := nCol-10
	oPrn:Say(nlin, nCol,  SUBSTR(AllTrim(WRK->A5_CODPRF),1,27) ,oFont6,100) // supply pn		mls
	NCol:= nCol+290
	nCol3:= nCol-10
	oPrn:Say(nlin, nCol,  Transform(WRK->W7_QTDE,"@E 999,999,999.99")   ,oFont3,100) //qty
	nCol:= nCol+190
	nCol4:= nCol-10
	oPrn:Say(nlin, nCol,  Transform(WRK->W7_PRECO,"@E 999.999,999.9999") ,oFont3,100)//unit eur
	nCol:= nCol+210
	nCol5:= nCol-10
	oPrn:Say(nlin, nCol, Transform(WRK->W7_QTDE*WRK->W7_PRECO,"@E 999,999,999.99"),oFont3,100) //total preco
	nTotVlr += (WRK->W7_QTDE*WRK->W7_PRECO)
	nCol:= nCol+240
	nCol6:= nCol-10
	//Data Embarque
	DbSelectArea("SW6")
	DbSetOrder(1)
	If SW6->(dbSeek( xFilial() + WRK->W7_HAWB))
		oPrn:Say(nlin, nCol, DtoC(SW6->W6_DT_EMB)     ,oFont3,100) //ship date
	Endif
	nCol  := nCol+160
	nCol7 := nCol-10
	nCol8:= nCol-10
	oPrn:Say(nlin, nCol, Transform(WRK->W7_PESO*WRK->W7_QTDE,"@E 999,999,999.9999")   ,oFont3,100) //totel net weigth
	nTotPes += (WRK->W7_PESO*WRK->W7_QTDE)
	nCol:= nCol+230
	nCol9:= nCol-10
	oPrn:Say(nlin, nCol, WRK->W7_NCM         ,oFont3,100)

	nCol:= nCol+160
	nCol10:= nCol-10
	cPPB      :=POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_XXINPPB')

	cDrawback := POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_XXDRBCK')

	IF ALLTRIM(cDrawback)<>'S'
		cDrawback:='N'
	ENDIF

	cUM       :=POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_UM')
	cTipo     :=POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_TIPO')

	oPrn:Say(nlin, nCol, cPPB         ,oFont3,100)

	nCol:= nCol+80
	oPrn:Say(nlin, nCol, cDrawback    ,oFont3,100)

	cDESCR :=ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_DESC'))
	cDESCR1:=ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_DESCR1'))
	cDESCR2:=ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_DESCR2'))
	cDESCR3:=ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_DESCR3'))
	cDESCR4:=ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_DESCR4'))
	cDESCR5:=ALLTRIM(POSICIONE('SB1',1,xFILIAL('SB1')+WRK->W7_COD_I,'B1_DESCR5'))

	nLin +=40
	oPrn:Say(nlin   , 160, cUM              ,oFont3,100) //UM
	oPrn:Say(nlin+40, 160, "Tipo: "+cTipo   ,oFont3,100) //UM

	IF !EMPTY(cDESCR)
		oPrn:Say(nlin, 370,  substr(cDESCR,1,40)  ,oFont6,100)
	ENDIF
	_cDescr :=alltrim(cDESCR1)+' '+alltrim(cDESCR2)+' '+alltrim(cDESCR3)+' '+alltrim(cDESCR4)+' '+alltrim(cDESCR5)+space(450)

	IF !EMPTY(_cDescr)
		cDESCR1:=ALLTRIM(substr(_cDescr,001,40))
		cDESCR2:=ALLTRIM(substr(_cDescr,041,40))
		cDESCR3:=ALLTRIM(substr(_cDescr,081,40))
		cDESCR4:=ALLTRIM(substr(_cDescr,121,40))
		cDESCR5:=ALLTRIM(substr(_cDescr,161,40))
		cDESCR6:=ALLTRIM(substr(_cDescr,201,40))
		cDESCR7:=ALLTRIM(substr(_cDescr,241,40))
		cDESCR8:=ALLTRIM(substr(_cDescr,281,40))
		cDESCR9:=ALLTRIM(substr(_cDescr,321,40))
		cDESCRA:=ALLTRIM(substr(_cDescr,361,40))
	ENDIF

	IF !EMPTY(cDESCR1)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR1 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR2)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR2 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR3)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR3 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR4)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR4 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR5)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR5 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR6)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR6 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR7)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR7 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR8)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR8 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCR9)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCR9 ,oFont6,100)
	ENDIF
	IF !EMPTY(cDESCRA)
		nLin +=40
		oPrn:Say(nlin, 370,  cDESCRA ,oFont6,100)
	ENDIF

	//IF nlin >= 3000   //3000         //MLS
	//	npag++
	//	nlin :=40
	//_lFIRST==.F.
	//	oPrn:EndPage()
	//	oPrn:StartPage()
	//Lseg:=.t.    <-------------------lseg

	//Iprime as colunas
	/*
	if npag>=2    //npag==2
		oPrn:Box(1367,150       ,nlin+40,2330)
		oPrn:Line(1370,nCol1    ,nLin+40, nCol1)
		oPrn:Line(1370,nCol3    ,nLin+40, nCol3)
		oPrn:Line(1370,nCol4    ,nLin+40, nCol4)
		oPrn:Line(1370,nCol5    ,nLin+40, nCol5)
		oPrn:Line(1370,nCol6    ,nLin+40, nCol6)
		oPrn:Line(1370,nCol7    ,nLin+40, nCol7)
		oPrn:Line(1370,nCol8    ,nLin+40, nCol8)
		oPrn:Line(1370,nCol9    ,nLin+40, nCol9)
		oPrn:Line(1370,nCol10   ,nLin+40, nCol10)
		oPrn:Line(1370,nCol10+70,nLin+40, nCol10+70)
	else
		oPrn:Box(0100,150       ,nlin+40, 2330)
		oPrn:Line(0100,nCol1    ,nLin+40, nCol1)
		oPrn:Line(0100,nCol3    ,nLin+40, nCol3)
		oPrn:Line(0100,nCol4    ,nLin+40, nCol4)
		oPrn:Line(0100,nCol5    ,nLin+40, nCol5)
		oPrn:Line(0100,nCol6    ,nLin+40, nCol6)
		oPrn:Line(0100,nCol7    ,nLin+40, nCol7)
		oPrn:Line(0100,nCol8    ,nLin+40, nCol8)
		oPrn:Line(0100,nCol9    ,nLin+40, nCol9)
		oPrn:Line(0100,nCol10   ,nLin+40, nCol10)
		oPrn:Line(0100,nCol10+70,nLin+40, nCol10+70)
	endif
                   //MLS
	*/
	nLin +=40
	oPrn:Line(nLin,150,nLin,2330)
	nLin +=40

	nCol := 160

Return

*-------------------------------------------------------------------------------------*
Static Function GeraCol()
	*-------------------------------------------------------------------------------------*
	//Iprime as colunas
	IF 	Lseg==.t.
		oPrn:Line(0100,nCol1    ,nLin   , nCol1)
		oPrn:Line(0100,nCol3    ,nLin   , nCol3)
		oPrn:Line(0100,nCol4    ,nLin   , nCol4)
		oPrn:Line(0100,nCol5    ,nLin   , nCol5)
		oPrn:Line(0100,nCol6    ,nLin   , nCol6)
		oPrn:Line(0100,nCol7    ,nLin   , nCol7)
		oPrn:Line(0100,nCol8    ,nLin   , nCol8)
		oPrn:Line(0100,nCol9    ,nLin   , nCol9)
		oPrn:Line(0100,nCol10   ,nLin   , nCol10)
		oPrn:Line(0100,nCol10+70,nLin   , nCol10+70)
	ELSE
		oPrn:Line(1370,nCol1,nLin, nCol1)
		oPrn:Line(1370,nCol3,nLin, nCol3)
		oPrn:Line(1370,nCol4,nLin, nCol4)
		oPrn:Line(1370,nCol5,nLin, nCol5)
		oPrn:Line(1370,nCol6,nLin, nCol6)
		oPrn:Line(1370,nCol7,nLin, nCol7)
		oPrn:Line(1370,nCol8,nLin, nCol8)
		oPrn:Line(1370,nCol9,nLin, nCol9)
		oPrn:Line(1370,nCol10,nLin, nCol10)
		oPrn:Line(1370,nCol10+70,nLin, nCol10+70)
	ENDIF

	if lfim==.t.
		oPrn:Line(nLin,150,nLin,2330)
		nLin +=40
		IF nCol5<=0
			nCol5:=600
		ENDIF

		IF nCol8<=0
			nCol8:=1200
		ENDIF
		oPrn:Say(nLin,nCol4+10,"Total",oFont2,100)
		oPrn:Say(nlin, nCol5, Transform(nTotVlr,"@E 999,999,999.99")   ,oFont2,100) //total net weigth
		oPrn:Say(nlin, nCol8, Transform(nTotPes,"@E 999,999,999.99")   ,oFont2,100) //total net weigth

		nTotVlr :=0
		nTotPes :=0

		nLin := nLin+60
	endif
	if lseg==.t.
		oPrn:Box(0100,150,nLin,2330)
	else
		oPrn:Box(1270,150,nLin,2330)
	endif


RETURN

/*********************************************
*Função utilizada para imprimir o Cabeçalho  *
*                                            *
**********************************************/

*--------------------------------------------------------------------------------------*
Static Function GeraCab()
	*--------------------------------------------------------------------------------------*

	nLin    := 0
	npag    :=1
	oPrn:StartPage()     // Inicia uma nova página
	NlIN:=nLIN+60
	nCol1:=nCol2:=nCol3:=nCol4:=nCol5:=nCol6:=nCol7:=nCol8:=nCol9:=nCOL10 := 0

	//Dados do cabeçalho
	DbSelectArea("SW6")
	DbSetOrder(1)
	If SW6->(dbSeek( xFilial() + Mv_par01 ))
		//Buscar via de transporte
		cDesp  := Alltrim(SW6->W6_DESP)
		DbSelectArea("SYQ")
		DbSetOrder(1)
		If SYQ->(DbSeek(xFilial()+SW6->W6_VIA_TRA))
			if Substr(SYQ->YQ_COD_DI, 1,1)="4"
				cVia :=" (BY AIR)"
			elseif Substr(SYQ->YQ_COD_DI, 1,1)="1"
				cVia :=" (BY SEA)"
			endif
		EndIf
		//Buscar Dados do Shipper´s
		DbSelectArea("SW2")
		DbSetOrder(1)
		if SW2->(DbSeek(xFilial()+WRK->W7_PO_NUM))
			cForn := AllTrim(SW2->W2_FORN)
			DbSelectArea("SA2")
			DbSetOrder(1)
			if SA2->(DbSeek(xFilial()+cForn))
				cDesFo := AllTrim(SA2->A2_NOME)
				cEnd   := AllTrim(SA2->A2_END)
				//busca Pais
				DbSelectArea("SYA")
				DbSetOrder(1)
				if SYA->(DbSeek(xFilial()+SA2->A2_PAIS))
					cPaisFo := AllTrim(SYA->YA_DESCR)
				endif
				cContFo := AllTrim(SA2->A2_CONTATO)
				cTel    := AllTrim(SA2->A2_TEL)
				cFax    := AllTrim(SA2->A2_FAX)
			endif
			cAgent := AllTrim(SW2->W2_FORWARD)

			//Condicao Pagamento
			DbSelectArea("SY6")
			DbSetOrder(1)
			if SY6->(DbSeek(xFilial()+SW2->W2_COND_PA))
				cPaym   := MSMM(SY6->Y6_DESC_I,AVSX3("Y6_VM_DESI",3),1)
			endif
			cInc    := AllTrim(SW2->W2_INCOTER)
			//Origem e destino
			DbSelectArea("SYR")
			DbSetOrder(3)//origem
			cAirDep := Alltrim (SW2->W2_ORIGEM)

			DbSelectArea("SYR")
			DbSetOrder(4)//origem
			if SYR->(DbSeek(xFilial()+SW2->W2_DEST))
				DbSelectArea("SY9")
				DbSetOrder(2)//origem
				if SY9->(DbSeek(xFilial()+SYR->YR_DESTINO))
					cAirDes := SY9->Y9_DESCR
				endif
			endif
		endif
	endif

	//Imprimir cabeçalho
	cFigura := "shipping.bmp" // deve estar na pasta SIGAADV ou o caminho deve ser especificado.
	oPrn:SayBitmap(200,150,cFigura,410,230)

	// Dados consignee'
	//oPrn:Say(240, 700, "SHIPPING INSTRUCTIONS (By air)",oFont1,100)

	IF xFilial("SB2")=='02'

		oPrn:Say(500, 150, "Consignee´s Name and Address",oFont2,100)
		oPrn:Say(540, 150, "Rosenberger Domex Telecomunicações LTDA",oFont2,100)
		oPrn:Say(580, 150, "Rua Campos Vargas,16 Recando dos Ypes",oFont3,100)
		oPrn:Say(620, 150, "Camanducaia - MG Brasil CEP: 37650-000",oFont3,100)
		oPrn:Say(660, 150, "CNPJ:           54.821.137/0002-17",oFont3,100)
		oPrn:Say(700, 150, "Contact Person: "+cUser+" ",oFont3,100)
		oPrn:Say(740, 150, "Department:     Foreign Trade",oFont3,100)
		oPrn:Say(780, 150, "PHO/FAX:        55 12 3221-8500",oFont3,100)
	else
		oPrn:Say(500, 150, "Consignee´s Name and Address",oFont2,100)
		oPrn:Say(540, 150, "Rosenberger Domex Telecomunicações LTDA",oFont2,100)
		oPrn:Say(580, 150, "Av. Cabletech, 601. Guamirim",oFont3,100)
		oPrn:Say(620, 150, "Caçapava - SP Brasil CEP: 12295-230",oFont3,100)
		oPrn:Say(660, 150, "CNPJ:           54.821.137/0001-36",oFont3,100)
		oPrn:Say(700, 150, "Contact Person: "+cUser+" ",oFont3,100)
		oPrn:Say(740, 150, "Department:     Foreign Trade",oFont3,100)
		oPrn:Say(780, 150, "PHO/FAX:        55 12 3221-8500",oFont3,100)
	endif
	//cabeçalho data e processo
	oPrn:Say(360, 1200, "Our Reference: "+WRK->W7_HAWB,oFont2,100)

	//Data do Processo
	DbSelectArea("SW6")
	DbSetOrder(1)
	if SW6->(DbSeek(xFilial()+WRK->W7_HAWB))
		oPrn:Say(320, 1200, "Issue Date:    "+DtoC(SW6->W6_DT_HAWB) ,oFont2,100)
	endif

	//Dados fornecedor
	oPrn:Say(500, 1200, "Shipper´s Name and Address",oFont2,100)
	oPrn:Say(540, 1200, cDesFo ,oFont2,100)
	oPrn:Say(580, 1200, cEnd   ,oFont2,100)
	oPrn:Say(620, 1200, cPais  ,oFont3,100)
	oPrn:Say(660, 1200, "Contact:   "+cContFo,oFont3,100)
	oPrn:Say(700, 1200, "Telephone: "+cTel   ,oFont3,100)
	oPrn:Say(740, 1200, "Fax:       "+cFax   ,oFont3,100)

	//Payament Terms
	oPrn:Say(920, 150,  "Payament Terms:         "+AllTrim(cPaym) ,oFont2,100)
	oPrn:Say(960, 150,  "Airport of Departure:   "+cAirDep ,oFont2,100)  //JFS 28-10-11 cAirDep ,oFont2,100)
	oPrn:Say(1000, 150, "Airport of Destination: "+cAirDes ,oFont2,100)
	//oPrn:Say(920, 1200, "Final Destination       "+cAirDes ,oFont2,100)
	oPrn:Say(960, 1200, "INCOTERM                "+cInc ,oFont2,100)
	oPrn:Say(1000, 1200,"Shipment Method         "+cVia ,oFont2,100)

	oPrn:Say(240, 700, "SHIPPING INSTRUCTIONS "+cVia,oFont1,100)

	oPrn:Line(1100,150,1100,2330)//2250

	IF nCAB==1
		oPrn:Say(1150, 450, "CONCERNING THE ABOVE MENTIONED ORDER, PLEASE TAKE FOLLOWING INSTRUCTIONS:",oFont4,100)

		oPrn:Box(1270,150,1367,2330)

		nLin :=1290
		nCol :=160

		//1 coluna
		oPrn:Say(nLin,nCol,  "Purch.Order"        ,oFont2,100)
		nCol :=nCol + 180
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		//2 coluna
		oPrn:Say(1290, nCol,  "RDT Part Number     /"    ,oFont2,100)
		nCol :=nCol + 260
		nCol :=nCol + 10
		//3 coluna
		oPrn:Say(1290, 690,  "Supply PN"          ,oFont2,100)
		nCol :=nCol + 280
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		//4coluna
		oPrn:Say(1290, nCol,  "QTY"                ,oFont2,100)
		nCol :=nCol + 180
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		//5 coluna
		oPrn:Say(1290, nCol,  "UNIT "+SW2->W2_MOEDA     ,oFont2,100)
		nCol :=nCol + 200
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		//6 coluna
		oPrn:Say(1290, nCol, "Total "+SW2->W2_MOEDA         ,oFont2,100)
		nCol :=nCol + 230
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		//7 coluna
		oPrn:Say(1290, nCol, "Ship.Date"         ,oFont2,100)
		nCol :=nCol + 150
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		// 9 coluna
		oPrn:Say(1290, nCol, "To. Net Weight"   ,oFont2,100)
		oPrn:Say(1325, nCol, "(Estimated)"       ,oFont2,10)
		nCol :=nCol + 220
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		// 10 coluna
		oPrn:Say(1290, nCol, "NCM(N."       ,oFont2,100)
		oPrn:Say(1325, nCol, "Mercosul)"      ,oFont2,100)

		// 11 coluna
		nCol :=nCol + 150
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 10
		oPrn:Say(1290, nCol, "PPB"    ,oFont2,100)
		oPrn:Say(1325, nCol, " "      ,oFont2,100)

		// 12 coluna
		nCol :=nCol + 60
		oPrn:Line(1270,nCol,1370,nCol)
		nCol :=nCol + 20
		oPrn:Say(1290, nCol, "Drawback",oFont2,100)
		oPrn:Say(1325, nCol, " "       ,oFont2,100)
	ENDIF

	nLin := 1370
	nCol := 160
Return()

/*********************************************
*Função utilizada para imprimir o Rodapé     *
*                                            *
**********************************************/

*---------------------------------------------------------------------------*
Static Function GeraRod()
	*---------------------------------------------------------------------------*
	/*
	IF nlin >= 2400            //MLS
Lseg:=.t.
nCAB   :=2
		if Select("WRK") >0
WRK->(dbCloseArea())
		EndIf
oPrn:EndPage()
nLin    := 0
oPrn:StartPage()     // Inicia uma nova página
GeraCab()
NlIN:=nLIN+60
	ELSE
nLin := 2400
	ENDIF                   //MLS
	*/
	oPrn:Line(nLin,150,nLin, 2330)
	nLin := nLin + 40
	oPrn:Say(nlin, 150, "Remarks to Shipper " ,oFont2,100)
	nLin := nLin + 40
	oPrn:Say(nlin, 406, "Shipment Documents" ,oFont2,100)
	nLin := nLin + 40
	oPrn:Say(nlin, 406, "Your Invoice needs to contain the Tariff Code/NCM and Net Weight per each item." ,oFont5,100)
	nLin := nLin + 40
	oPrn:Say(nlin, 406, "Packing List: Must be informed Gross Weight, Net weight and measures of each package, over there to inform the quantity and " ,oFont5,100)
	nLin := nLin + 40
	oPrn:Say(nlin, 406, "type of each one." ,oFont5,100)
	nLin := nLin + 40
	oPrn:Say(nlin, 406, "The supply needs to send the draft of shipment documents to us one day before the scheduled delivery date." ,oFont5,100)
	nLin := nLin + 80

	DbSelectArea("SW6")
	DbSetOrder(1)

	//dados do pedido despachante
	oPrn:Say(nlin, 406, "Air WayBill: 01 original + 02 copies. " ,oFont5,100)
	nLin := nLin + 40
	DbSelectArea("SY5")
	DbSetOrder(1)
	if SY5->(DbSeek(xFilial()+cDesp))
		oPrn:Say(nlin, 406, "AWB must state our broker data: "+AllTrim(SY5->Y5_NOME) ,oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, "Contact Person: "+Alltrim(SY5->Y5_CONTATO) ,oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, "Telephone: +55 "+AllTrim(SY5->Y5_FONE) ,oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, "Fax: +55 "+AllTrim(SY5->Y5_FAX) ,oFont5,100)
		nLin := nLin + 40
	EndIf

	//DADOS DO AGENTE DE CARGA
	DbSelectArea("SY4")
	DbSetOrder(1)
	if SY4->(DbSeek(xFilial()+cAgent))
		nLin := nLin + 60
		oPrn:Say(nlin, 406, "Our cargo agent is: "+Alltrim(SY4->Y4_NOME) ,oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, AllTrim(SY4->Y4_END) ,oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, "Fone: "+AllTrim(SY4->Y4_FONE)+" Fax: "+AllTrim(SY4->Y4_FAX),oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, AllTrim(SY4->Y4_BAIRRO)+" - "+AllTrim(SY4->Y4_CIDADE),oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, AllTrim(SY4->Y4_EMAIL) ,oFont5,100)
		nLin := nLin + 40
		oPrn:Say(nlin, 406, AllTrim(SY4->Y4_HPAGE) ,oFont5,100)
		nLin := nLin + 40
	EndIf
	nLin := nLin + 40
	oPrn:Say(nlin, 406, "Please inform us the ECCN in your Invoice",oFont5,100)

Return()
