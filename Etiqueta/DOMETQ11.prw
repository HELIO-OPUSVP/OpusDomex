#include "protheus.ch"
#include "rwmake.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ11 ºAutor  ³ Michel A. Sander   º Data ³  15/05/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 11 (não grava XD1)                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ11(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT1"
Local lPrinOK    := MSCBModelo("ZPL",cModelo)
Local aPar       := {}
Local aRet       := {}
Local nVar       := 0
Local cRotacao   := "N"      //(N,R,I,B)
Local mv_par02   := 1         //Qtd Embalagem
Local mv_par03   := 1         //Qtd Etiquetas
Local x := 1
Local aRetAnat   := {}        //Codigos Anatel, Array
Local aCodAnat   := {}        //Codigos Anatel, Array
Local nLado1	 := 0
Local nLado2     := 0
Local nQ		 := 0

Private cCdAnat1   := ""        //Codigo Anatel 1
Private cCdAnat2   := ""        //Codigo Anatel 2
Private lAchou     := .T.
Private aGrpAnat   := {}     //Codigos Anatel Agrupados
Private _cSerieIni := ""
Private nReduzCol  := 3      // Variável de redução da coluna em todos os pontos de impressão (Default = 2)
Private lNovoCod   := .F.
Private lSemTraco  := .F.
Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNumSerie := ""
Default cNumPeca  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca quantidades para impressão											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)
	
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o número de série														 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	_cSerieIni:=""
	//If MV_PAR07 > 1
	//   MV_PAR07 += 1
	//EndIf
	mv_par07 -= 1
	If Len(Alltrim(SC2->C2_NUM)) <=5
		Do Case
			Case SC2->C2_QUANT <=9
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(mv_par07,1)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(mv_par07,2)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(mv_par07,3)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(mv_par07,4)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(mv_par07,5)	// MV_PAR07 Sequencial Serial
		EndCase
	Else
		Do Case
			Case SC2->C2_QUANT <=9
				_cSerieIni:= AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(mv_par07,1)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
				_cSerieIni:= AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(mv_par07,2)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
				_cSerieIni:= AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(mv_par07,3)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
				_cSerieIni:= AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(mv_par07,4)	// MV_PAR07 Sequencial Serial
				lSemTraco := .T.
				nReduzCol := 4
			Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
				_cSerieIni:= AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(mv_par07,5)	// MV_PAR07 Sequencial Serial
				lSemTraco := .T.
				nReduzCol := 4
		EndCase
		//_cSerieIni:= AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+Alltrim(STR(mv_par07))	// MV_PAR07 Sequencial Serial
		lNovoCod := .T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de sequencia de via e serie									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
cCdAnat1   := ""
cCdAnat2   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no PA																 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
Else
	If SB1->B1_GRUPO == "TRUN" .or. SB1->B1_GRUPO == "TRUE"
	   lTrunk := .T.
	Else
	   lTrunk := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no Cliente					    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"não localizado!")
	lAchou := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida descrição do produto		    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Se impressora não identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configuração!")
	
	Return(.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consiste a quantidade de conectores na estrutura					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
nEtq := 0
cSQL := "SELECT B1_GRUPO, B1_DESC, G1_COD, G1_COMP, G1_XXQTET1, G1_XXQTET2, G1_QUANT, B1_XXANAT1, SG1010.R_E_C_N_O_ AS SG1_RECNO FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COMP = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "B1_GRUPO = 'CON' ORDER BY G1_COMP"
If Select("ETQ") <> 0
   ETQ->( dbCloseArea() )
EndIf
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"ETQ",.F.,.T.)

If ETQ->(Eof())
	Aviso("Atenção","Não existe conectores na estrutura dessa OP. Verifique se os componentes do tipo conectores estão no grupo CON.",{"Ok"})
	cTxtMsg  := " Não existe conectores na estrutura dessa OP. Verifique se os componentes do tipo conectores estão no grupo CON." + Chr(13)
	cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
	cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 011 - Conector"
	cPara    := 'denis.vieira@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;fabiana.santos@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
   cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	ETQ->(dbCloseArea())
	Return
Else
   
   /* RETIRADO A PEDIDO DO DENIS em 31.01.17
	aAreaSB1 := SB1->( getArea() )
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek( xFilial() + ETQ->G1_COD )  )
		If .T. // Empty(SB1->B1_XXMETIQ) .or. Empty(SB1->B1_XXIL1) .or. Empty(SB1->B1_XXIL2)
			
			Private nMetragem := SB1->B1_XXMETIQ
			Private nILA      := SB1->B1_XXIL1
			Private nILB      := SB1->B1_XXIL2
			
			DEFINE MSDIALOG oDlgMenu02 TITLE OemToAnsi("Preenchimento temporário") FROM 0,0 TO 240,370 PIXEL
			
			nLin := 10
			@ nLin, 010	SAY oTexto1 Var 'Produto: ' + Alltrim(ETQ->G1_COD) + "-" + SB1->B1_DESC SIZE 200,200 COLOR CLR_HBLUE PIXEL
			oTexto1:oFont := TFont():New('Arial',,12,,.T.,,,,.T.,.F.)
			nLin += 25
			@ nLin, 010	SAY oTexto2 Var 'Metragem para etiqueta:'    SIZE 100,10 PIXEL
			oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
			@ nLin-2, 120 MSGET oMetragem VAR nMetragem Picture "@E 999.99"  SIZE 45,10 PIXEL
			oMetragem:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
			nLin += 20
			@ nLin, 010	SAY oTexto1 Var 'IL Lado A:'     SIZE 100,10 PIXEL
			oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
			@ nLin-2, 120 MSGET oLadoA VAR nILa  Picture "@E 999.99"  SIZE 45,10 PIXEL
			oLadoA:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
			nLin += 20
			@ nLin, 010	SAY oTexto2 Var 'IL Lado B:'     SIZE 100,10 PIXEL
			oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
			@ nLin-2, 120 MSGET oLadoB VAR nILB  Picture "@E 999.99"  SIZE 45,10 PIXEL
			oLadoB:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
			nLin += 20
			@ nLin, 090 BUTTON "Ok"      ACTION ( nOpc := 1, oDlgMenu02:End() ) SIZE 30,12 PIXEL OF oDlgMenu02
			@ nLin, 130 BUTTON "Cancela" ACTION ( nOpc := 0, oDlgMenu02:End() ) SIZE 30,12 PIXEL OF oDlgMenu02
			
			ACTIVATE MSDIALOG oDlgMenu02 CENTER
			
			If nOpc == 1
				Reclock("SB1",.F.)
				SB1->B1_XXMETIQ := nMetragem
				SB1->B1_XXIL1   := nILa
				SB1->B1_XXIL2   := nILb
				SB1->( msUnlock() )
			EndIf
			
			If Empty(SB1->B1_XXMETIQ) .or. Empty(SB1->B1_XXIL1) .or. Empty(SB1->B1_XXIL2)
			   Return
			EndIf
		EndIf
	EndIf
	RestArea(aAreaSB1)
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Consiste codigo ANATEL dos componentes da estrutura				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If !fTestaAnatel(ETQ->G1_COD,@cNumOP,@cNumSenf,.T.)
		ETQ->(dbCloseArea())
		REturn
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se lados estão inconsistentes									³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	lErro := .F.
	Do While ETQ->(!Eof())
		
		If .T. // ETQ->G1_XXQTET1 == 0 .And. ETQ->G1_XXQTET2 == 0
			
			Private nLadoA    := ETQ->G1_XXQTET1
			Private nLadoB    := ETQ->G1_XXQTET2
			
			DEFINE MSDIALOG oDlgMenu02 TITLE OemToAnsi("Preenchimento temporário") FROM 0,0 TO 240,370 PIXEL
			
			nLin := 10
			@ nLin, 010	SAY oTexto1 Var 'Produto: ' + ETQ->G1_COMP    SIZE 200,200 COLOR CLR_HBLUE PIXEL
			oTexto1:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)
			nLin += 25
			@ nLin, 010	SAY oTexto1 Var 'Qtd. Etiquetas Lado A:'     SIZE 100,10 PIXEL
			oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
			@ nLin-2, 120 MSGET oLadoA VAR nLadoA  Picture "@E 999"  SIZE 45,10 PIXEL
			oLadoA:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
			nLin += 20
			@ nLin, 010	SAY oTexto2 Var 'Qtd. Etiquetas Lado B:'     SIZE 100,10 PIXEL
			oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
			@ nLin-2, 120 MSGET oLadoB VAR nLadoB  Picture "@E 999"  SIZE 45,10 PIXEL
			oLadoB:oFont := TFont():New('Courier New',,20,,.T.,,,,.T.,.F.)
			nLin += 35
			@ nLin, 090 BUTTON "Ok"      ACTION ( nOpc := 1, oDlgMenu02:End() ) SIZE 30,12 PIXEL OF oDlgMenu02
			@ nLin, 130 BUTTON "Cancela" ACTION ( nOpc := 0, oDlgMenu02:End() ) SIZE 30,12 PIXEL OF oDlgMenu02
			
			ACTIVATE MSDIALOG oDlgMenu02 CENTER
			
			If nOpc == 1
				SG1->( dbGoTo(ETQ->SG1_RECNO) )
				If SG1->( Recno() ) == ETQ->SG1_RECNO
					Reclock("SG1",.F.)
					SG1->G1_XXQTET1 := nLadoA
					SG1->G1_XXQTET2 := nLadoB
					SG1->( msUnlock() )
				EndIf
				//lErro := .T.
			Else
				Aviso("Atenção","Conectores da estrutura estão sem o número de etiquetas para impreesão preenchido. Altere a estrutura e tente novamente.",{"Ok"})
				cTxtMsg  := " Conectores da estrutura estao com lados inconsistentes. Altere a estrutura e tente novamente." + Chr(13)
				cTxtMsg  += " Estrutura  = " + ETQ->G1_COD  + Chr(13)
				cTxtMsg  += " Componente = " + ETQ->G1_COMP + Chr(13)
				cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
				cAssunto := "Etiqueta Layout 011 - Conector"
				cPara    := 'denis.vieira@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;fabiana.santos@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
  		      cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
				cArquivo := Nil
				U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
				lErro := .T.
			EndIf
			
		EndIf
		
		ETQ->(dbSkip())
	EndDo
	
	If lErro
		ETQ->(dbCloseArea())
		Return
	Else
		ETQ->(dbGotop())
	EndIf
	
EndIf


If Empty(SB1->B1_XXIL1)
	cTxtTmp := "Campo IL lado A não preenchido! "+Chr(13)+Chr(10)+"[B1_XXIL1]"
	Alert(cTxtTmp)
	cAssunto := "Etiqueta Layout 011 - IL A"
	cTexto   := cTxtTmp + Chr(13)+Chr(10) + "Produto: " + SB1->B1_COD + " - " + SB1->B1_DESC
	cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	lAchou := .F.
EndIf

If Empty(SB1->B1_XXIL2)
	cTxtTmp := "Campo IL lado B não preenchido! "+Chr(13)+Chr(10)+"[B1_XXIL2]"
	Alert(cTxtTmp)
	
	cAssunto := "Etiqueta Layout 011 - IL B"
	cTexto   := cTxtTmp + Chr(13)+Chr(10) + "Produto: " + SB1->B1_COD + " - " + SB1->B1_DESC
	cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
 	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	lAchou := .F.
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consiste a quantidade de fibra na estrutura							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
cSQL := "SELECT COUNT(B1_COD) QTDEFIBRA FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COMP = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "B1_GRUPO = 'FO'"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"FIB",.F.,.T.)
If FIB->QTDEFIBRA <> 1
	Aviso("Atenção","A estrutura usada não possui quantidade de fibra padrão para impressão de etiquetas, ou possui mais de uma fibra na estrutura.",{"Ok"})
	cTxtMsg  := " A estrutura usada não possui quantidade de fibra padrão para impressão de etiquetas, ou possui mais de uma fibra na estrutura." + Chr(13)
	cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
	cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 011 - Conector"
	cPara    := 'denis.vieira@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;fabiana.santos@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	FIB->(dbCloseArea())
	ETQ->(dbCloseArea())
	Return
Else
	FIB->(dbCloseArea())
EndIf

lImprime  := .F.
a         := 3
nCont     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara série inicial														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Alterado Por Michel A. Sander em 24.01.2018 para permitir a soma de série com letra
/*
_cSerieIni := Val(_cSerieIni)
_cSerieIni -= 1
*/
nSerie     := _cSerieIni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara os Arrays de impressão por lado								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
aLado1     := {}
aLado2     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca o tamanho da FIBRA OTICA											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
cSQL := "SELECT B1_GRUPO, B1_DESC, G1_COD, G1_COMP, G1_XXLADO, G1_QUANT FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COMP = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "B1_GRUPO = 'FO' ORDER BY G1_COMP"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"FIB",.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem dos arrays de impressão das etiquetas						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
For nQ := 1 To nQtdEtq		// nQtdEtq = Quantidade de Etiquetas no parametro de impressão
	
	nVia1  := 1
	nVia2  := 1
	nSerie := Soma1(nSerie)
	ETQ->( dbGoTop() )
	
	Do While ETQ->(!Eof())
		
		For nLado1 := 1 to ETQ->G1_XXQTET1			// Preenche Primeiro Lado do Conector
		
			If SB1->B1_XXMETIQ == Int(SB1->B1_XXMETIQ)
			   cMasc := "@E 999"
			Else
			   If Round(SB1->B1_XXMETIQ,1) == SB1->B1_XXMETIQ
			      cMasc := "@E 999.9"
			   Else
				   cMasc := "@E 999.99"
				EndIf
			EndIf
			
			cIL := TransForm(SB1->B1_XXIL1,"9.99")
			AADD( aLado1, { "RDT", ;
			"SN:"+nSerie, ;
			Alltrim(Transform(SB1->B1_XXMETIQ,cMasc))+"M", ;
			"LADO A:IL:<"+cIL+"dB", ;
			"LADO:A", ;
			Alltrim(ETQ->B1_XXANAT1)+SPACE(1), ;
			"VIA: "+STRZERO(nVia1,2), ;
			"A" } )
			
			nVia1++
		Next nLado1
		
		If lTrunk .and. !Empty(ETQ->G1_XXQTET1)
				AADD( aLado1, { "  MUDANCA DE SERIAL", ;
				SPACE(01), ;
				SPACE(01), ;
				SPACE(01), ;
				SPACE(01), ;
				SPACE(01), ;
				SPACE(01), ;
				SPACE(01) } )
      EndIf
	
		For nLado2 := 1 to ETQ->G1_XXQTET2			// Preenche o Segundo Lado do Conector
		
			If SB1->B1_XXMETIQ == Int(SB1->B1_XXMETIQ)
			   cMasc := "@E 999"
			Else
			   If Round(SB1->B1_XXMETIQ,1) == SB1->B1_XXMETIQ
			      cMasc := "@E 999.9"
			   Else
				   cMasc := "@E 999.99"
				EndIf
			EndIf
			
			cIL := TransForm(SB1->B1_XXIL2,"9.99")
			AADD( aLado2, { "RDT", ;
			"SN:"+nSerie, ;
			Alltrim(Transform(SB1->B1_XXMETIQ,cMasc))+"M", ;
			"LADO B:IL:<"+cIL+"dB", ;
			"LADO:B", ;
			Alltrim(ETQ->B1_XXANAT1)+SPACE(1), ;
			"VIA: "+STRZERO(nVia2,2), ;
			"B" } )
			
			nVia2++
		Next nLado2
		
		If lTrunk .and. !Empty(ETQ->G1_XXQTET2)
			   AADD( aLado2, { "  MUDANCA DE SERIAL", ;
			   SPACE(01), ;
			   SPACE(01), ;
			   SPACE(01), ;
			   SPACE(01), ;
			   SPACE(01), ;
			   SPACE(01), ;
			   SPACE(01) } )
	   EndIf
	
		ETQ->(dbSkip())
		
	EndDo

Next nQ

FIB->(dbCloseArea())


If lTrunk
   //AADD( aLado1, { "  MUDANCA (LADO)", ;
   //SPACE(01), ;
   //SPACE(01), ;
   //SPACE(01), ;
   //SPACE(01), ;
   //SPACE(01), ;
   //SPACE(01), ;
   //SPACE(01) } )
   If len(aLado1) > 0
	   aLado1[Len(aLado1),1] := "  MUDANCA DE LADO"
	EndIf   
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche etiquetas vazias que sobraram	 L A D O   A				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Sobrando duas


If MOD( Len(aLado1), 3) == 1
	AADD( aLado1, { "  MUDANCA DE LADO", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
	AADD( aLado1, { "  MUDANCA DE LADO", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
EndIf
// Sobrando uma
If MOD( Len(aLado1), 3) == 2
	AADD( aLado1, { "MUDANCA DE LADO", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche etiquetas vazias que sobraram	 L A D O   B				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Sobrando duas

If MOD( Len(aLado2), 3) == 1
	AADD( aLado2, { "  MUDANCA DE LADO", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
	AADD( aLado2, { "  MUDANCA DE LADO", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
EndIf

// Sobrando uma
If MOD( Len(aLado2), 3) == 2
	AADD( aLado2, { "MUDANCA DE LADO", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³																					 ³
//³Impressão do L A D O  A														 ³
//³																					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If Len(aLado1) > 0
	
	a := 99
	x:=1
	For x := 1 to  Len(aLado1)
		
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
			nIni := 08
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

/*
			AADD( aLado1, { "RDT", ;                          1
			"SN:"+ALLTRIM(STR(nSerie)), ;                     2
			Alltrim(Transform(SB1->B1_XXMETIQ,cMasc))+"M", ;  3
			"LADO A:IL:<"+cIL+"dB", ;                         4
			"LADO:A", ;                                       5
			ETQ->B1_XXANAT1, ;                                6
			"VIA: "+STRZERO(nVia1,2), ;                       7
			"A" } )

*/

		
		MSCBSAY(Lin1Col1-nReduzCol   ,nIni+(nLin*01)   ,aLado1[x,1]                 ,cRotacao,"0","30,30") // RDT
		//MSCBSAY(Lin1Col2-nReduzCol ,nIni+(nLin*01) ,aLado1[x,2]                   ,cRotacao,"0","24,24")
		//MSCBSAY(Lin1Col3-nReduzCol ,nIni+(nLin*01) ,aLado1[x,3]                   ,cRotacao,"0","25,25")
		//MSCBSAY(Lin1Col2-nReduzCol ,nIni+(nLin*01)   ,aLado1[x,2]+' '+aLado1[x,3] ,cRotacao,"0","24,24") // OP + METRAGEM
		
		If lNovoCod
			If lSemTraco
				MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01)   ,Subs(aLado1[x,2],1,14)+Alltrim(Subs(aLado1[x,2],15,Len(aLado1[x,2]))) ,cRotacao,"0","24,24") // OP 
			Else
				MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01)   ,Subs(aLado1[x,2],1,14)+' '+Alltrim(Subs(aLado1[x,2],15,Len(aLado1[x,2]))) ,cRotacao,"0","24,24") // OP 
			EndIf
		Else
			MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01)   ,Subs(aLado1[x,2],1,11)+' '+Subs(aLado1[x,2],12) ,cRotacao,"0","24,24") // OP 
		EndIf
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
		
		MSCBSAY(Lin2Col1-nReduzCol ,nIni+(nLin*02)   ,aLado1[x,4] ,cRotacao,"0","21,21")
		MSCBSAY(Lin2Col2-nReduzCol ,nIni+(nLin*02)   ,aLado1[x,5] ,cRotacao,"0","21,21")
		
		If a == 1
			Lin3Col1 := 004
			Lin3Col2 := 029
		ElseIf a == 2
			Lin3Col1 := 044
			Lin3Col2 := 070
		ElseIf a == 3
			Lin3Col1 := 085
			Lin3Col2 := 110
		EndIf

		MSCBSAY(Lin3Col1-nReduzCol ,nIni+(nLin*2.8)   ,aLado1[x,6] + " " + aLado1[x,3],cRotacao,"0","21,21") // ANATAL + METRAGEM
		//MSCBSAY(Lin3Col1-nReduzCol ,nIni+(nLin*2.8)   ,aLado1[x,6] ,cRotacao,"0","21,21") // ANATAL + METRAGEM
		MSCBSAY(Lin3Col2-nReduzCol ,nIni+(nLin*2.8)   ,aLado1[x,7] ,cRotacao,"0","21,21") // VIA
		
		If a == 3
			MSCBInfoEti("DOMEX","80X60")
			//Finaliza impressão da etiqueta
			MSCBEND()
			Sleep(500)
			MSCBCLOSEPRINTER()
			lImprime := .T.
		EndIf
		
	Next
	
	If lImprime
		MSCBInfoEti("DOMEX","80X60")
		//Finaliza impressão da etiqueta
		MSCBEND()
		Sleep(500)
		MSCBCLOSEPRINTER()
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³																					 ³
//³Impressão do L A D O  B														 ³
//³																					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If Len(aLado2) > 0
	
	a := 99
	
	For x := 1 to Len(aLado2)
		
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
			nIni := 08
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
		
		MSCBSAY(Lin1Col1-nReduzCol   ,nIni+(nLin*01)   ,aLado2[x,1]                 ,cRotacao,"0","30,30")
		//MSCBSAY(Lin1Col2-nReduzCol ,nIni+(nLin*01)   ,aLado2[x,2]                 ,cRotacao,"0","24,24")
		//MSCBSAY(Lin1Col3-nReduzCol ,nIni+(nLin*01)   ,aLado2[x,3]                 ,cRotacao,"0","25,25")
		//MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01) ,aLado2[x,2]+' '+aLado2[x,3] ,cRotacao,"0","24,24")
		If lNovoCod
			If lSemTraco
				MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01)   ,Subs(aLado2[x,2],1,14)+Alltrim(Subs(aLado2[x,2],15,Len(aLado2[x,2]))) ,cRotacao,"0","24,24") // OP 
			Else
				MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01)   ,Subs(aLado2[x,2],1,14)+' '+Alltrim(Subs(aLado2[x,2],15,Len(aLado2[x,2]))) ,cRotacao,"0","24,24") // OP 
			EndIf
		Else
			MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01)   ,Subs(aLado2[x,2],1,11)+' '+Subs(aLado2[x,2],12) ,cRotacao,"0","24,24") // OP 
		EndIf
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
		
		MSCBSAY(Lin2Col1-nReduzCol ,nIni+(nLin*02)   ,aLado2[x,4] ,cRotacao,"0","21,21")
		MSCBSAY(Lin2Col2-nReduzCol ,nIni+(nLin*02)   ,aLado2[x,5] ,cRotacao,"0","21,21")
		
		If a == 1
			Lin3Col1 := 004
			Lin3Col2 := 029
		ElseIf a == 2
			Lin3Col1 := 044
			Lin3Col2 := 070
		ElseIf a == 3
			Lin3Col1 := 085
			Lin3Col2 := 110
		EndIf
		
		MSCBSAY(Lin3Col1-nReduzCol ,nIni+(nLin*2.8)   ,aLado2[x,6] + " " + aLado2[x,3],cRotacao,"0","21,21") // ANATAL + METRAGEM
		//MSCBSAY(Lin3Col1-nReduzCol ,nIni+(nLin*2.8)   ,aLado2[x,6] ,cRotacao,"0","21,21")
		MSCBSAY(Lin3Col2-nReduzCol ,nIni+(nLin*2.8)   ,aLado2[x,7] ,cRotacao,"0","21,21")
		
		If a == 3
			MSCBInfoEti("DOMEX","80X60")
			//Finaliza impressão da etiqueta
			MSCBEND()
			Sleep(500)
			MSCBCLOSEPRINTER()
			lImprime := .T.
		EndIf
		
	Next
	
	If lImprime
		MSCBInfoEti("DOMEX","80X60")
		//Finaliza impressão da etiqueta
		MSCBEND()
		Sleep(500)
		MSCBCLOSEPRINTER()
	EndIf
	
EndIf

ETQ->(dbCloseArea())

Return ( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fTestaAnatel ºAutor  ³ Michel Sander  º Data ³  15/05/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca codigo Anatel do componente da estrutura             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTestaAnatel(cCodPA,cNumOp,cNumSenf,lMostra)

LOCAL lAchou := .T.
Local x := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consiste codigo ANATEL do componente									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
SB1->(dbSeek(xFilial("SB1")+cCodPA))

aRetAnat  := U_fCodNat(SB1->B1_COD)
lAchou    := aRetAnat[1]
aCodAnat  := aRetAnat[2]

If Empty(SB1->B1_XXNANAT)
	If lMostra
		Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
	EndIf
	lAchou := .F.
EndIf

//Agrupando Codigos Anatel
For x:=1 To Len(aCodAnat)
	nVar := aScan(aGrpAnat,aCodAnat[x])
	If nVar == 0
		aAdd(aGrpAnat,aCodAnat[x])
	EndIf
Next x

Do Case
	Case Val(SB1->B1_XXNANAT) == 0 .And. Len(aGrpAnat) == 0
		cCdAnat1 := ""
		cCdAnat2 := ""
		
	Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
		cCdAnat1 := aGrpAnat[1]
		cCdAnat2 := ""
		
	Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
		cCdAnat1 := aGrpAnat[1]
		cCdAnat2 := aGrpAnat[1]
		
	Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
		cCdAnat1 := aGrpAnat[1]
		cCdAnat2 := aGrpAnat[2]
		
	OtherWise
		
		cCdAnat1 := " E R R O "
		cCdAnat2 := " E R R O "
		If !Empty(cNumOP)
			If lMostra
				Alert("Erro no tratamento dos codigos ANATEL."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
				lAchou := .F.
			EndIf
		ElseIf !Empty(cNumSenf)
			If lMostra
				Alert("Erro no tratamento dos codigos ANATEL."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
				lAchou := .F.
			EndIf
		EndIf
		
EndCase

Return ( lAchou )
