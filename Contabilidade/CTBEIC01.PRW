#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Topconn.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  CTBEIC01     บAutor  ณJonas Pereira   บ Data ณ  23/04/2021   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Usado para CONTABILIZAวรO OFFLINE EIC    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTBEIC01()

	Private _cPerg   := "CTBEIC01"+Space(02)

	fCriaPerg(_cPerg)

	Pergunte(_cPerg,.F.)

	cTexto := "Este programa tem o objetivo contabilizar os movimentos do modulo de importa็ใo - Easy Import Control "
	cTexto += "Os movimentos serใo contabilizados separadamente em tr๊s fontes de dados: Estoque em Transito, sem  "
	cTexto += "cobertura cambial e Notas Fiscais: "
	cTexto += "irแ apresentar em tela os lancamentos para que sejam gravados na tabela CT2 "
	

	BatchProcess("Contabiliza็ใo dos Processos de Importa็ใo (CT2)",cTexto,_cPerg,{ || Processa({|lEnd| ProcRun() },OemToAnsi("Contabiliza็ใo dos Processos de Importa็ใo (CT2)"),OemToAnsi("Contabiliza็ใo dos Processos de Importa็ใo (CT2)"),.F.)})

Return

Static Function ProcRun()

	FWMsgRun(, {|oSay| fprocNF() }, "Processando", "Processando Notas Fiscais...")
	FWMsgRun(, {|oSay| fprocET() }, "Processando", "Processos de Estoque em Transito...")
	FWMsgRun(, {|oSay| fprocSC() }, "Processando", "Processos sem cobertura...")

Return .T.


Static function fprocNF()
	local cQuery := " "

//Contabilizacao
	local aRotina := {}
	local cArquivo := "QTMP"
	local nTotal    := 0
	local lDigita   := .T.
	local cLote     := "9898"
	local cPadrao   := "980" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
	Local aLSTRec   := {}
	local nHdlPrv:= HeadProva(cLote,"CSTVEND",Alltrim(cUserName),@cArquivo)

//contabiliza็ใo de Nota fiscal de entrada
	cQuery := " "
	cQuery += "  SELECT min(R_E_C_N_O_) AS REC,  SUM(F1_VALBRUT)-SUM(F1_FOB_R) AS VLRBX FROM SF1010 (NOLOCK) "
	cQuery += " WHERE "
	cQuery += " D_E_L_E_T_='' "
	cQuery += " AND F1_HAWB<>'' "
	cQuery += " AND F1_EMISSAO BETWEEN '"+dtos(Mv_Par01)+"' AND '"+dtos(Mv_Par02)+"' "
	//cQuery += " AND F1_XDTLAN='' "
	If !Empty(mv_Par03)
		cQuery += " AND F1_HAWB='"+alltrim(mv_Par03)+"' "
	EndIF
	cQuery += "  GROUP BY F1_FORNECE, F1_LOJA "
//cQuery += " AND F1_HAWB='IMP 4389/21' "


	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QTMP"

	DbSelectArea("QTMP")
	ProcRegua(RecCount())
	DbGoTop()

	while QTMP->(!EOF())
		AADD(aLSTRec, {QTMP->REC})
		QTMP->(dbskip())
	enddo

	For Ny := 1 to len(aLSTRec)

		//chama contabiliza็ใo
		SF1->(DBGOTO(aLSTRec[Ny][1]))
		If SF1->(RECNO())==aLSTRec[Ny][1]
			// DetProva(0,"950","TSTLT","009999")
			nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CSTVEND",cLote)

			RodaProva(nHdlPrv,nTotal)

			// Envia para Lancamento Contabil
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.

		Endif

	Next Ny

	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

Return


Static function fprocET()
	local cQuery := " "

//Contabilizacao
	local aRotina := {}
	local cArquivo := "QTMP"
	local nTotal    := 0
	local lDigita   := .T.
	local cLote     := "9898"
	local cPadrao   := "981" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
	local nHdlPrv   := HeadProva(cLote,"CSTVEND",Alltrim(cUserName),@cArquivo)
    Local nRecno
	Local aLSTEnt     := {}
	Local Nj

	Private cW6_HAWB    := ""
	Private cW9_NOM_FOR := "" 
	Private cW9_FORN    := ""
	Private cW9_FORLOJ  := "" 
	Private nVAR_CAMB   := "" 
	Private nVLPROCE    := "" 
	Private nVLBAIXA    := ""
	Private cTPVAR      := ""


//contabiliza็ใo de estoque em transito
	cQuery := " "
	cQuery += " SELECT W6_HAWB, W9_NOM_FOR, W9_FORN, W9_FORLOJ, "
	cQuery += " SUM((TXFECHAMENTO * W9_FOB_TOT)-(TXPROCESSO * W9_FOB_TOT)) AS VAR_CAMB,  "
	cQuery += " CASE WHEN  SUM((TXFECHAMENTO * W9_FOB_TOT)-(TXPROCESSO * W9_FOB_TOT)) < 0 THEN 'NEG' ELSE 'POS' END TPVAR, "
	cQuery += " SUM(TXPROCESSO * W9_FOB_TOT) AS VLPROCE, "
	cQuery += " CASE WHEN W6_NF_ENT <> '' THEN SUM(W9_TX_FOB * W9_FOB_TOT) ELSE 0 END AS VLBAIXA "
	cQuery += " FROM "
	cQuery += " ( "
	cQuery += " SELECT W6_HAWB, W6_NF_ENT,W9_TX_FOB,W9_DT_EMIS, LT_DT,W9_MOE_FOB, W9_FOB_TOT, W9_NOM_FOR, W9_FORN, W9_FORLOJ, DTNF, "
	cQuery += " CASE WHEN SYEA.YE_VLCON_C IS NULL THEN 0 ELSE SYEA.YE_VLCON_C END AS TXPROCESSO, "
	cQuery += " CASE WHEN SYEB.YE_VLCON_C IS NULL THEN 0 ELSE SYEB.YE_VLCON_C END AS TXFECHAMENTO "
	cQuery += "  FROM ( "
	cQuery += " SELECT  W6_HAWB, W9_INVOICE,W9_DT_EMIS,W6_NF_ENT, W9_TX_FOB,  convert(varchar, EOMONTH(W9_DT_EMIS), 112) AS LT_DT, "
	cQuery += " W9_MOE_FOB, W9_FOB_TOT, W6_TX_FOB, W9_NOM_FOR, W9_FORN, W9_FORLOJ, "
	cQuery += " (SELECT MIN(F1_EMISSAO) FROM SF1010 (NOLOCK) WHERE D_E_L_E_T_='' AND F1_HAWB=W6_HAWB) AS DTNF "
	cQuery += " FROM SW6010 (NOLOCK) AS SW6 INNER JOIN SW9010 (NOLOCK) AS SW9 ON W9_HAWB=W6_HAWB "
	cQuery += " WHERE SW6.D_E_L_E_T_='' AND W9_DT_EMIS BETWEEN '"+dtos(Mv_Par01)+"' AND '"+dtos(Mv_Par02)+"' "
	If !Empty(mv_Par03)
		cQuery += " AND W6_HAWB='"+alltrim(mv_Par03)+"' "
	EndIF
	cQuery += " ) AS SUB "
	cQuery += " LEFT JOIN SYE010 (NOLOCK) AS SYEA ON SYEA.YE_DATA=W9_DT_EMIS AND SYEA.YE_MOEDA=W9_MOE_FOB  "
	cQuery += " LEFT JOIN SYE010 (NOLOCK) AS SYEB ON SYEB.YE_DATA=LT_DT AND SYEB.YE_MOEDA=W9_MOE_FOB  "
	cQuery += " WHERE LEFT(W9_DT_EMIS,6)<>LEFT(DTNF,6) "

	//AND W6_HAWB='IMP 4389/21      '
	cQuery += " ) AS FINAL "
	cQuery += " GROUP BY W6_NF_ENT, W6_HAWB, W9_NOM_FOR, W9_FORN, W9_FORLOJ "

	MPSysOpenQuery( cQuery , "QTMP")

	DbSelectArea("QTMP")
	
    nRecno := 0

	QTMP->( dbEval({|| nRecno++}) )

	ProcRegua(nRecno)
    
	QTMP->( DbGoTop() )


	
	while QTMP->(!EOF())
		AADD(aLSTEnt, {QTMP->W6_HAWB, QTMP->W9_NOM_FOR, QTMP->W9_FORN, QTMP->W9_FORLOJ, QTMP->VAR_CAMB, QTMP->VLPROCE, QTMP->VLBAIXA,QTMP->TPVAR })
		QTMP->(dbskip())
	enddo


	For Nj := 1 to len(aLSTEnt)


		cW6_HAWB    := aLSTEnt[Nj][1]
	    cW9_NOM_FOR := aLSTEnt[Nj][2]
	    cW9_FORN    := aLSTEnt[Nj][3]
	    cW9_FORLOJ  := aLSTEnt[Nj][4]
	    nVAR_CAMB   := aLSTEnt[Nj][5]
	    nVLPROCE    := aLSTEnt[Nj][6]
	    nVLBAIXA    := aLSTEnt[Nj][7]
	    cTPVAR      := aLSTEnt[Nj][8]

		// DetProva(0,"950","TSTLT","009999")
		nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CSTVEND",cLote)

		RodaProva(nHdlPrv,nTotal)

		// Envia para Lancamento Contabil
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.

		

	Next Nj

/*
	while QTMP->(!EOF())
		IncProc("Gerando Lan็amento Contแbil...")

		nTotal :=  DetProva(nHdlPrv,cPadrao,"CSTVEND",cLote)

		RodaProva(nHdlPrv,nTotal)

		// Envia para Lancamento Contabil
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.

        //RECLOCK DTLANC
		QTMP->(dbskip())
	enddo
*/
Return

//SEM COBERTURA CAMBIAL
Static function fprocSC()
	local cQuery := " "

    //Contabilizacao
	local aRotina   := {}
	local cArquivo  := "QTMP"
	local nTotal    := 0
	local lDigita   := .T.
	local cLote     := "9898"
	local cPadrao   := "982" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
	local nHdlPrv   := HeadProva(cLote,"CSTVEND",Alltrim(cUserName),@cArquivo)
	Local aLstSC    := {}
	Private cHAWB   := ""
	Private cFORN   := ""
	Private cFLOJA  := ""
    Private nValor  := 0




	cQuery := " "
	cQuery += " SELECT W9_FOB_TOT * W9_TX_FOB AS VALOR, W9_HAWB, W9_FORN, W9_FORLOJ FROM SW9010 (NOLOCK)
	cQuery += " WHERE W9_HAWB<>'' AND D_E_L_E_T_='' AND W9_FILIAL='01' AND W9_DIAS_PA=0
	cQuery += " AND W9_DT_EMIS BETWEEN '"+dtos(Mv_Par01)+"' AND '"+dtos(Mv_Par02)+"' "
	If !Empty(mv_Par03)
		cQuery += " AND W9_HAWB='"+alltrim(mv_Par03)+"' "
	EndIF
	cQuery += " AND W9_XDTLAN = '' "


	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QTMP"

	DbSelectArea("QTMP")
	ProcRegua(RecCount())
	DbGoTop()





	while QTMP->(!EOF())
		AADD(aLstSC, {QTMP->W9_HAWB, QTMP->W9_FORN, QTMP->W9_FORLOJ, QTMP->VALOR 	 })
		QTMP->(dbskip())
	enddo

	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf


	For Ny := 1 to len(aLstSC)

		cHAWB   := aLstSC[Ny][1]
		cFORN   := aLstSC[Ny][2]
		cFLOJA  := aLstSC[Ny][3]
		nValor  := aLstSC[Ny][4] 
		SA2->(dbSeek(xFilial("SA2")+aLstSC[Ny][2]+aLstSC[Ny][3]))
		// DetProva(0,"950","TSTLT","009999")
		nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CSTVEND",cLote)

		RodaProva(nHdlPrv,nTotal)

		// Envia para Lancamento Contabil
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.


	Next Ny


/*
	while QTMP->(!EOF())

		cHAWB   := QTMP->W9_HAWB
		cFORN   := QTMP->W9_FORN
		cFLOJA  := QTMP->W9_FORLOJ

		IncProc("Gerando Lan็amento Contแbil...")

		nTotal :=  DetProva(nHdlPrv,cPadrao,"CSTVEND",cLote)


		RodaProva(nHdlPrv,nTotal)

		// Envia para Lancamento Contabil
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.

//RECLOCK DTLANC
		QTMP->(dbskip())
	enddo

	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf
*/
Return



Static Function fCriaPerg()
	Local I
	Local J

	aSvAlias:={Alias(),IndexOrd(),Recno()}
	i:=j:=0
	aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
	AADD(aRegistros,{_cPerg,"01","Data de Emissใo de ?  ","","","mv_ch1","D",08,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{_cPerg,"02","Data de Emissใo ate ? ","","","mv_ch2","D",08,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegistros,{_cPerg,"03","Importacao          ? ","","","mv_ch3","C",15,00,00,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegistros,{_cPerg,"04","Fornecedor ate ?      ","","","mv_ch4","C",06,00,00,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})

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


User Function fConEIC(cNumImp)
	Local nRevenda := 0
	Local nIndustr := 0
	Local cConta   := ""


	cQuery := " SELECT * "
	cQuery += " FROM ( "
	cQuery += " SELECT  'IND' AS TP, SUM(FT_VALCONT) AS CUSTO FROM SF1010 (NOLOCK)  AS SF1 "
	cQuery += " INNER JOIN SD1010 (NOLOCK) SD1 ON F1_DOC=D1_DOC AND F1_FILIAL=D1_FILIAL "
	cQuery += " AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA "
	cQuery += " INNER JOIN SFT010 AS SFT ON FT_NFISCAL=D1_DOC AND FT_SERIE=D1_SERIE AND SFT.D_E_L_E_T_='' "
	cQuery += " AND D1_ITEM=FT_ITEM AND FT_CLIEFOR=D1_FORNECE "
	cQuery += " and D1_LOJA=FT_LOJA AND D1_COD=FT_PRODUTO "
	cQuery += " WHERE  SD1.D_E_L_E_T_='' AND SF1.D_E_L_E_T_='' AND F1_HAWB='"+ALLTRIM(cNumImp)+"' "
	cQuery += " AND D1_CF IN ('3101','3127','3551','3556','3949') "
	
	cQuery += " GROUP BY D1_CF "
	cQuery += " UNION ALL "
	cQuery += " SELECT  'REV', SUM(FT_VALCONT) AS CUSTO FROM SF1010 (NOLOCK)  AS SF1  "
	cQuery += " INNER JOIN SD1010 (NOLOCK) SD1 ON F1_DOC=D1_DOC AND F1_FILIAL=D1_FILIAL  "
	cQuery += " AND F1_SERIE=D1_SERIE AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA "
	cQuery += " INNER JOIN SFT010 AS SFT ON FT_NFISCAL=D1_DOC AND FT_SERIE=D1_SERIE AND SFT.D_E_L_E_T_='' "
	cQuery += " AND D1_ITEM=FT_ITEM AND FT_CLIEFOR=D1_FORNECE "
	cQuery += " and D1_LOJA=FT_LOJA AND D1_COD=FT_PRODUTO "
	cQuery += " WHERE  SD1.D_E_L_E_T_='' AND SF1.D_E_L_E_T_='' AND F1_HAWB='"+ALLTRIM(cNumImp)+"' "
	cQuery += " AND D1_CF IN ('3102','3128') "
	cQuery += " GROUP BY D1_CF "
	cQuery += " ) AS FINAL "


	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QTMP"

	While QTMP->(!EOF())

		If QTMP->TP='IND'
			nIndustr := QTMP->CUSTO
		ElseIf QTMP->TP='REV'
			nRevenda := QTMP->CUSTO
		EndIf

		QTMP->(dbskip())

	Enddo

	If nIndustr != 0 .or.  nRevenda != 0
		If nIndustr >= nRevenda
			cConta := "410108000000"
		Else
			cConta := "430150000000"
		EndIf
	EndIf

	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

return cConta


//Verifica se o processo ้ entreposto
User Function fVldEntr(cNumHAWB)
	Local aEntreposto := {}

	AADD(aEntreposto, {.f., 0})

	cQuery := " SELECT W6_PO_NUM, MIN(R_E_C_N_O_) AS MRECNO FROM SW6010 (NOLOCK) "
	cQuery += " WHERE D_E_L_E_T_='' AND LEFT(W6_PO_NUM,2)='DA' AND W6_PO_NUM IN "
	cQuery += " ( "
	cQuery += " select  W6_PO_NUM from SW6010  (NOLOCK) WHERE D_E_L_E_T_='' AND W6_PO_NUM<> '' AND W6_DT_HAWB >= '20010101' "
	cQuery += " and W6_HAWB LIKE '%"+ALLTRIM(cNumHAWB)+"%' "
	cQuery += " GROUP BY  W6_PO_NUM "
	cQuery += " ) "
	cQuery += " GROUP BY W6_PO_NUM "
	cQuery += " HAVING COUNT(*)>1 "


	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QTMP"

	If QTMP->(!EOF())
		//lEntreposto := .t.
		aEntreposto[1][1] := .t.
		aEntreposto[1][2] := QTMP->MRECNO
		QTMP->(dbskip())
	EndIf

	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

Return aEntreposto

//Retorna nome sem o ano do processo
User function fRetCod(cHAWB)
Local cCodHawb := ""
Local aDados   := U_fVldEntr(cHAWB)


If aDados[1][1]
	cCodHawb := ALLTRIM(Subs(cHAWB,1,8))+''+ALLTRIM(subs(cHAWB,12,2))
Else
	cCodHawb := ALLTRIM(subs(cHAWB,1,8))
EndIf


cCodHawb  := ALLTRIM(cCodHawb) + SPACE(1)

Return cCodHawb

/*

//Verifica se o processo MAE
User Function fVldMae(cNumHAWB)
	Local nMae := 0

	//AADD(aEntreposto, {.f., 0})

	cQuery := " SELECT W6_PO_NUM, MIN(R_E_C_N_O_) AS MRECNO FROM SW6010 (NOLOCK) "
	cQuery += " WHERE D_E_L_E_T_='' AND W6_PO_NUM IN "
	cQuery += " ( "
	cQuery += " select  W6_PO_NUM from SW6010  (NOLOCK) WHERE D_E_L_E_T_='' AND W6_PO_NUM<> '' AND W6_DT_HAWB >= '20010101' "
	cQuery += " and W6_HAWB LIKE '%"+ALLTRIM(cNumHAWB)+"%' "
	cQuery += " GROUP BY  W6_PO_NUM "
	cQuery += " ) "
	cQuery += " GROUP BY W6_PO_NUM "
	cQuery += " HAVING COUNT(*)>1 "


	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QTMP"

	If QTMP->(!EOF())
		nMae  := QTMP->MRECNO
		//aEntreposto[1][1] := .t.
		//aEntreposto[1][2] := QTMP->MRECNO
		//QTMP->(dbskip())
	EndIf

	If Select("QTMP") <> 0
		QTMP->( dbCloseArea() )
	EndIf

Return nMae
*/
