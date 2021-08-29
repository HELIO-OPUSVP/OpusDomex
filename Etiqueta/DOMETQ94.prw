#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ94 ºAutor  ³ Michel A. Sander   º Data ³  30/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta padrão Ericsson (não grava XD1)                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ94(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT1"

Local lPrinOK    := MSCBModelo("ZPL",cModelo)

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local cRotacao   := "N"      //(N,R,I,B)

Local MVPAR02   := 1         //Qtd Embalagem
Local MVPAR03   := 1         //Qtd Etiquetas

Local aRetAnat   := {}        //Codigos Anatel, Array
Local aCodAnat   := {}        //Codigos Anatel, Array
Local cCdAnat1   := ""        //Codigo Anatel 1
Local cCdAnat2   := ""        //Codigo Anatel 2
Local cCdAnat3   := ""        //Codigo Anatel 3
Local cNumPedido := ""   
Local cCodProdut := ""
Private lAchou   := .T.
Private aGrpAnat := {}     //Codigos Anatel Agrupados
Private lFatSZY  := .T.
Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNivel   := ""
Default aFilhas  := {}
Default cNumSerie := ""
Default cNumPeca  := ""

MVPAR02:= nQtdEmb   //Qtd Embalagem
MVPAR03:= nQtdEtq   //Qtd Etiquetas /*revisar*/

If cNivel == '2'
	If Empty(aFilhas)
		cAssunto  := "Chamada da etiqueta layout 002 com o afilhas vazio."
		cTexto    := "OP: " + cNumOP
		cPara     := "denis.vieira@rdt.com.br;michel@opusvp.com.br;helio@opusvp.com.br"
		cCC       := ""
		cArquivo  := ""
		
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	EndIf
EndIf

If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	Else	
		cCodProdut := SC2->C2_PRODUTO
	EndIf	
	
	If !Empty(SC2->C2_PEDIDO)
		cNumPedido := SC2->C2_PEDIDO
		//Localiza SC5
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			Alert("Numero de Senf "+AllTrim(SC2->C2_PEDIDO)+" não localizado!")
			lAchou := .F.
		EndIf
		
		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
			Alert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" não localizado!")
			lAchou := .F.
		EndIf
		
		//Localiza SC6
		SZY->(DbSetOrder(1))
		If lAchou .And. SZY->(DbSeek(xFilial()+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
			While !SZY->( EOF() ) .and. SZY->ZY_PEDIDO == SC2->C2_PEDIDO .and. SZY->ZY_ITEM == SC2->C2_ITEMPV .AND. !Empty(SZY->ZY_NOTA)
				SZY->( dbSkip() )
			End
			If !SZY->( EOF() ) .and. SZY->ZY_PEDIDO == SC2->C2_PEDIDO .and. SZY->ZY_ITEM == SC2->C2_ITEMPV .AND. Empty(SZY->ZY_NOTA)
				
			Else
				//Alert("Programação de Faturamento não encontrado para o item.")
				lFatSZY := .F.
			EndIf
		EndIf
	EndIf
EndIf

If !Empty(cNumSenf)
	//Localiza SC5
	SC5->(DbSetOrder(1))
	If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
		Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" não localizado!")
		lAchou := .F.
	EndIf
	
	cNumPedido := SC5->C5_NUM
	
	//Localiza SC6
	SC6->(DbSetOrder(1))
	If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
		Alert("Item Senf "+Subs(cNumSenf,7,2) +" não localizado!")
		lAchou := .F.
	Else
		cCodProdut := SC6->C6_PRODUTO
	EndIf
	
EndIf

If !Empty(cNumPedido)
	//Localiza SA1
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
		lAchou := .F.
	EndIf
EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+cCodProdut))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf

//
If lAchou
	aRetAnat := U_fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	
	If lAchou .And. Empty(SB1->B1_XXNANAT)
		Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
		lAchou := .F.
	EndIf
	
EndIf

If lAchou
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
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := ""
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 4 .And. Len(aGrpAnat) == 3
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := aGrpAnat[3]
			
		OtherWise
			cCdAnat1 := " E R R O "
			cCdAnat2 := " E R R O "
			If !Empty(cNumOP)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.
			
	EndCase
	
EndIf

//Valida se Campo Descricao do Produto está preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

/**/
//Valida se Campo PN HUAWEI está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUCOD)
		Alert("Campo PN não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
		lAchou := .F.
	EndIf
EndIf

//Valida se Campo PEDIDO CLIENTE está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC5->C5_ESP1)
		Alert("Campo PEDIDO CLIENTE não está preenchido no Cabeçalho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
		lAchou := .F.
	EndIf
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
	Return(.F.)
EndIf

//Se impressora não identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configuração!")
	Return(.F.)
EndIf

If lImpressao
	
   For x:= 1 To MVPAR03

		// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
		If Type("cErictDl31_CancEtq") <> "U"
			cErictDl31_CancEtq := cNumPeca
			cErictDl32_CancOP  := cNumOP
			cErictDl33_CancEmb := cNumSenf
			cErictDl34_CancKit := nQtdEmb
			cErictDl35_CancUni := nQtdEtq
			cErictDl38_CancNiv := cNivel
			aErictDl3A_CancFil := aFilhas
			cErictDl39_CancPes := nPesoVol
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Montagem do código de barras 2D						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
		cSemana := WEEK->SEMANA
		WEEK->(dbCloseArea())
		
		cPDF417 := "[)>06"																// [)>06
		cPDF417 += "18VLELME"                          							// 18VLELME
		cPDF417 += "1P"																	// 1P Ericsson Product No.
		cPDF417 += PADR(ALLTRIM(SC6->C6_SEUCOD),20)								// <F1>
		cPDF417 += "21P"                               							// 21P Ericsson R-State
		cPDF417 += PADR(SC6->C6_XXRSTAT,7)             							// <F2> 
		cPDF417 += "11D"																	// 11D Man.Week
		cPDF417 += PADR(cSemana,6)                      						// YYYYWW
		cPDF417 += "Q"																		// Q 
		cPDF417 += PADR(ALLTRIM(STR(nQtdEmb)),6)									// <F8> Quantity
		cPDF417 += "1V"																	// 1V
		cPDF417 += PADR("BG7",3)														// <F5> Factory Code
		cPDF417 += "1T"																	// 1T
		cPDF417 += PADR(ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM),14)		// <F9> Batch No.
		cPDF417 += "4L"																	// 4L
		cPDF417 += PADR("BRAZIL",6)													// <F17> Country Origin
		cPDF417 += "OT"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Montagem dos parâmetros de saída da etiqueta 	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		cCodBar  := ALLTRIM(SC6->C6_SEUCOD)+";"+ALLTRIM(SC6->C6_XXRSTAT)+";"+ALLTRIM(STR(nQtdEmb))+";"+ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM)+";"+"BRAZIL"+";"+"BG7"+";"
		cCodBar  += ALLTRIM(SC6->C6_SEUCOD)+";"+ALLTRIM(SC6->C6_XXRSTAT)+";"+ALLTRIM(STR(nQtdEmb))+";"+"BG7"+";"+ALLTRIM(SC2->C2_NUM)+ALLTRIM(SC2->C2_ITEM)+";"+"BRAZIL"+";"
		cCodBar  += ALLTRIM(cSemana)+";"+cPDF417
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Parâmetros de impressão do Crystal Reports		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	   //cOptions := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
	   cOptions := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
	   	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Executa Crystal Reports para impressão			 	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		CALLCRYS('ericsson', cCodBar ,cOptions)
	
	Next x
	
EndIf

Return(.T.)