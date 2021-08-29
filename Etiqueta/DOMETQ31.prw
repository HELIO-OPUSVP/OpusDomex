#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ31 ºAutor  ³ Michel A. Sander   º Data ³  25/02/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 31 DE-PARA (não grava XD1)                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ31(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT1"

Local lPrinOK    := MSCBModelo("ZPL",cModelo)

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local cRotacao   := "N"      //(N,R,I,B)

Local mv_par02   := 1         //Qtd Embalagem
Local mv_par03   := 1         //Qtd Etiquetas

Local aRetAnat   := {}        //Codigos Anatel, Array
Local aCodAnat   := {}        //Codigos Anatel, Array
Local cCdAnat1   := ""        //Codigo Anatel 1
Local cCdAnat2   := ""        //Codigo Anatel 2

Private lAchou     := .T.
Private aGrpAnat   := {}     //Codigos Anatel Agrupados
Private _cSerieIni := ""

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNumSerie := ""
Default cNumPeca  := ""

mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)

	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	EndIf

EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf

//Localiza SA1
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"não localizado!")
	lAchou := .F.
EndIf

dbSelectArea("SZU")
dbSetOrder(1)
cSQL := "SELECT ZU_FILIAL,ZU_PEDIDO,ZU_ITEM,ZU_PRODUTO,ZU_TXT01,ZU_TXT02,ZU_TXT03,ZU_TXT04 "
cSQL += "FROM "+RetSqlName("SZU")+" (NOLOCK) JOIN "+RetSqlName("SC6")+" (NOLOCK) ON "
cSQl += "C6_FILIAL  = ZU_FILIAL AND "
cSQL += "C6_NUM     = ZU_PEDIDO AND "
cSQL += "C6_PRODUTO = ZU_PRODUTO AND "
cSQL += "C6_ITEM    = ZU_ITEM JOIN "+RetSqlName("SC2")+" (NOLOCK) ON "
cSQL += "C6_FILIAL  = C2_FILIAL AND "
cSQL += "C6_NUMOP   = C2_NUM AND "
cSQL += "C6_ITEMOP  = C2_ITEM WHERE "
cSQL += RetSqlName("SZU")+".D_E_L_E_T_ = '' AND " 
cSQL += RetSqlName("SC6")+".D_E_L_E_T_ = '' AND " 
cSQL += RetSqlName("SC2")+".D_E_L_E_T_ = '' AND " 
cSQL += "C2_NUM+C2_ITEM+C2_SEQUEN = '"+cNumOp+"' ORDER BY ZU_PRODUTO"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TMP",.F.,.T.)
If TMP->(Eof())
	Alert("Não existe DE-PARA de codigos para essa OP!")
	lAchou := .F.
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
   TMP->(dbCloseArea())
	Return(.T.)
EndIf

//Se impressora não identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configuração!")
	Return(.T.)
EndIf

lImprime  := .F.
a         := 3

Do While TMP->(!Eof())
   
	For nQ := 1 to 2

	   a := a + 1
	   If a > 3
	      a := 1
		  	//Chamando função da impressora ZEBRA
			MSCBPRINTER(cModelo,cPorta,,,.F.)
			MSCBChkStatus(.F.)
			MSCBLOADGRF("RDT2.GRF")
			MSCBLOADGRF("ANATEL2.GRF")
			//Inicia impressão da etiqueta
			MSCBBEGIN(1,5)
			lImprime := .T.
			nCol := 05
			nIni := 07
			nLin := 04
		EndIf
			      
	   If a == 1
	      Lin1Col1 := 004
	      Lin1Col2 := 011
	      Lin1Col3 := 032
	   ElseIf a == 2
	      Lin1Col1 := 044
	      Lin1Col2 := 051
	      Lin1Col3 := 072
		ElseIf a == 3
	      Lin1Col1 := 085
	      Lin1Col2 := 092
	      Lin1Col3 := 113
		EndIf
		
		MSCBSAY(Lin1Col1,nIni+(nLin*01)   ,TMP->ZU_TXT01                                                              ,cRotacao,"0","21,21")
		MSCBSAY(Lin1Col2,nIni+(nLin*01)   ,TMP->ZU_TXT03                                                              ,cRotacao,"0","21,21")
	
	   If a == 1
	      Lin2Col1 := 004
	      Lin2Col2 := 028
	   ElseIf a == 2
	      Lin2Col1 := 044
	      Lin2Col2 := 069
		ElseIf a == 3
	      Lin2Col1 := 085
	      Lin2Col2 := 109
		EndIf
	
		MSCBSAY(Lin2Col1,nIni+(nLin*02)   ,TMP->ZU_TXT02                                                              ,cRotacao,"0","21,21")
		MSCBSAY(Lin2Col2,nIni+(nLin*02)   ,TMP->ZU_TXT04                                                              ,cRotacao,"0","21,21")
	
	   If a == 3
			MSCBInfoEti("DOMEX","80X60")
			//Finaliza impressão da etiqueta
			MSCBEND()
			Sleep(500)
			MSCBCLOSEPRINTER()
			lImprime := .T.
		EndIf
		
	Next
	
	TMP->(dbSkip())

EndDo

If lImprime
	MSCBInfoEti("DOMEX","80X60")
	//Finaliza impressão da etiqueta
	MSCBEND()
	Sleep(500)
	MSCBCLOSEPRINTER()
EndIf
	
TMP->(dbCloseArea())

Return(.T.)