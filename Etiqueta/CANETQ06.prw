#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CANETQ06 ºAutor  ³ Michel A. Sander   º Data ³  15/02/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cancela Etiqueta Modelo 04 MTP                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CANETQ06(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local aPar        := {}
	Local aRet        := {}
	Local nVar        := 0

	Local mv_par02    := 1         //Qtd Embalagem
	Local MVPAR03     := 1         //Qtd Etiquetas

	Local aRetAnat    := {}        //Codigos Anatel, Array
	Local aCodAnat    := {}        //Codigos Anatel, Array
	Local cCdAnat1    := ""        //Codigo Anatel 1
	Local cCdAnat2    := ""        //Codigo Anatel 2                     

	Private oOk      	:= LoadBitmap( GetResources(), "LBOK" )
	Private oNOK    	:= LoadBitmap( GetResources(), "LBNO" )
	Private lAchou    := .T.
	Private aGrpAnat  := {}     //Codigos Anatel Agrupados
	Private cNumOpBip := SPACE(11)
   Private aCaixas   := {}
   Private oList
   Private oDlg01        
   Private oNumOPBip
    
	Default cNumOP    := ""
	Default cNumSenf  := ""
	Default nQtdEmb   := 0
	Default nQtdEtq   := 0
	Default cNivel    := ""
	Default cNumSerie := ""
	Default cNumPeca  := ""
   Default aFilhas   := {}
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posição inicial da tela principal							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLin := 15
	nCol1 := 10
	nCol2 := 95
	AADD(aCaixas, { .F., Space(13), Space(15) })
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cabeçalho da OP													³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg01 TITLE OemToAnsi("Cancelamento de Etiqueta MTP Modelo 4") FROM 0,0 TO 450,400 PIXEL of oMainWnd PIXEL //300,400 PIXEL of oMainWnd PIXEL
	
	@ nLin-10,nCol1-05 TO nLin+25,nCol1+187 LABEL " Informações da Ordem de Produção "  OF oDlg01 PIXEL
	@ nLin, nCol1	SAY oTexto10 Var 'Número da OP:'    SIZE 100,10 PIXEL
	oTexto10:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
	@ nLin-2, nCol2 MSGET oNumOPBip VAR cNumOpBip  SIZE 80,12 WHEN .T. Valid ValidSer() PIXEL
	oNumOPBip:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
   nLin += 10
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BROWSE para as caixas disponíveis                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	oList := TWBrowse():New( nLin+20, nCol1-05, nLin+170, nCol1+135,,{ "", "Etiqueta", "Numero de Serie", },,oDlg01,,,,,,,,,,,,.F.,,.T.,,.F.,,,)//##"Empresa"//##"Empresa"
	oList:SetArray(aCaixas)
	oList:bLDblClick := { || aCaixas[oList:nAt,1] := !aCaixas[oList:nAt,1] } 
	oList:bLine      := { || { If( aCaixas[oList:nAT,1], oOk, oNOK ), aCaixas[oList:nAt,2], aCaixas[oList:nAT,3] } }
	nLin += 190
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Botões de controle												³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ nLin-19, nCol2+5 BUTTON oCancelar PROMPT "Finalizar" ACTION Processa( {|| oDlg01:End() } ) SIZE 100,20 PIXEL OF oDlg01
	                       
	ACTIVATE MSDIALOG oDlg01 CENTER
	
   If Len(aCaixas) == 1
      If !aCaixas[1,1] .And. Empty(aCaixas[1,2]) .And. Empty(aCaixas[1,3])
         Return
      EndIf
   EndIf
   
	MVPAR02:= nQtdEmb   //Qtd Embalagem
	MVPAR03:= nQtdEtq   //Qtd Etiquetas

	cProdFilho := ""
	If !Empty(cNumOPBip)
		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOPBip))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf

		cSC2Recno := SC2->(Recno())
		__cPedido := ""
		__cItem   := ""
		If ALLTRIM(SC2->C2_SEQUEN) == "001"
			__cPedido  := SC2->C2_PEDIDO
			__cItem    := SC2->C2_ITEMPV
			cProdFilho := SC2->C2_PRODUTO
		Else
			SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOPBip,1,8)+'001'))
			__cPedido := SC2->C2_PEDIDO
			__cItem   := SC2->C2_ITEMPV
			// Alterado Por Michel A. Sander em 15/05/2014
			// Busca Descrição da OP Filha para impressão na etiqueta
			SC2->(dbSeek(xFilial("SC2")+SUBSTR(cNumOPBip,1,11)))
			cProdFilho := SC2->C2_PRODUTO
			SC2->(dbGoto(cSC2Recno))
		EndIf

		//Localiza SC5
		If !Empty(SC2->C2_PEDIDO)
			SC5->(DbSetOrder(1))
			If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+__cPedido))
				Alert("Numero de Senf "+AllTrim(__cPedido)+" não localizado!")
				lAchou := .F.
			EndIf

			//Localiza SC6
			SC6->(DbSetOrder(1))
			If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+__cPedido+__cItem))
				Alert("Item Senf "+AllTrim(__cItem)+" não localizado!")
				lAchou := .F.
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Montagem do código de barras 2D					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cYY     := SUBSTR(cSemana,3,2)
	cWW     := StrZero(Val(SubStr(cSemana,5,2)),2)
	
	WEEK->(dbCloseArea())

	If !Empty(cNumSenf)
		//Localiza SC5
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
			Alert("Numero de Senf "+Subs(cNumSenf,1,6)+" não localizado!")
			lAchou := .F.
		EndIf

		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
			Alert("Item Senf "+Subs(cNumSenf,7,2) +" não localizado!")
			lAchou := .F.
		EndIf

		cProdFilho := SC6->C6_PRODUTO

	EndIf

	//Localiza SA1
	If !Empty(SC2->C2_PEDIDO)
		SA1->(DbSetOrder(1))
		If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
			lAchou := .F.
		EndIf
	EndIf

	//Localiza SB1
	SB1->(DbSetOrder(1))
	If lAchou .And. !SB1->(DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
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
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ06)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ06)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.

		EndCase

	EndIf

	//Valida se Campo Descricao do Produto está preenchido
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

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
		Return(.f.)
	EndIf

   lImprime := MsgYesNo("Deseja imprimir novas etiquetas após cancelamento?")

	If lImprime //Controla o numero da etiqueta de embalagens
	
		If Empty(cNumPeca)
			_cProxPeca := U_IXD1PECA()
		Else
			_cProxPeca := cNumPeca
		EndIf
	
		For _nX := 1 to Len(aFilhas)
			Reclock("XD2",.T.)
			XD2->XD2_FILIAL := xFilial("XD2")
			XD2->XD2_XXPECA := _cProxPeca
			XD2->XD2_PCFILH := aFilhas[_nX]
			XD2->( msUnlock() )
		Next _nX
	
	EndIf
	
   cCancel := ""
   
	For __nEtq := 1 To Len(aCaixas)
	
	   If !aCaixas[__nEtq,1]
	      Loop
	   EndIf

      XD1->(dbSetOrder(1))
		If XD1->(dbSeek(xFilial()+aCaixas[__nEtq,2]))

		   cCancel += XD1->XD1_XXPECA + CHR(13) + CHR(10)
		   Reclock("XD1",.F.)
		   XD1->XD1_OCORRE := "5"	// Cancelada
		   XD1->(MsUnlock())
		   
         If lImprime

				If __nEtq > 1
					_cProxPeca := U_IXD1PECA()
				EndIf
		
				aRetEmbala       := U_RetEmbala(SB1->B1_COD,cNivel)
		
				Reclock("XD1",.T.)
				XD1->XD1_FILIAL  := xFilial("XD1")
				XD1->XD1_XXPECA  := _cProxPeca
				XD1->XD1_FORNEC  := Space(06)
				XD1->XD1_LOJA    := Space(02)
				XD1->XD1_DOC     := Space(06)
				XD1->XD1_SERIE   := Space(03)
				XD1->XD1_ITEM    := ""
				XD1->XD1_COD     := SB1->B1_COD
				XD1->XD1_LOCAL   := SB1->B1_LOCPAD
				XD1->XD1_TIPO    := SB1->B1_TIPO
				XD1->XD1_LOTECT  := U_RetLotC6(cNumOP)
				XD1->XD1_DTDIGI  := dDataBase
				XD1->XD1_FORMUL  := ""
				XD1->XD1_LOCALI  := ""
				XD1->XD1_USERID  := __cUserId
				XD1->XD1_OCORRE := "6"
				XD1->XD1_OP      := cNumOP
				XD1->XD1_PV      := cNumSenf
				XD1->XD1_PESOB   := nPesoVol
				XD1->XD1_QTDORI  := nQtdEmb
				XD1->XD1_QTDATU  := nQtdEmb
				XD1->XD1_EMBALA  := aRetEmbala[1]
				XD1->XD1_QTDEMB  := aRetEmbala[2]
				XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // 3 = Nivel 3 (Volumes parar expedição não constam na estrutura)
				If !Empty(SC2->C2_PEDIDO)
					XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
				EndIf
				XD1->XD1_SERIAL  := aCaixas[__nEtq,3]
				XD1->( MsUnlock() )
		
				cMVPAR01 := U_fTratTxt(XD1->XD1_XXPECA)
				cMVPAR02 := StrZero(MVPAR02,4)+" Unidade(s)"
				cMVPAR03 := U_fTratTxt(SB1->B1_DESC)
				cMVPAR04 := "PN RDT: "+SB1->B1_COD
				cMVPAR05 := U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)
				cMVPAR06 := "PED.CLIENTE: "+U_fTratTxt(SC5->C5_ESP1)
				cMVPAR07 := "ITEM DO PEDIDO/CLIENTE: "+U_fTratTxt(SC6->C6_SEUDES)
				cMVPAR08 := "SN: "+aCaixas[__nEtq,3]
				cMVPAR09 := "SEMANA: "+cWW+"/"+cYY
				cMVPAR10 := If(Empty(aCaixas[__nEtq,3]),SPACE(10),aCaixas[__nEtq,3])
				cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"+cMVPAR08+";"+cMVPAR09+";"+cMVPAR10+";"
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
				//³Parâmetros de impressão do Crystal Reports		 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
				cOptions := "2;0;1;Layout004"			// Parametro 1 (2= Impressora 1=Visualiza)
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
				//³Executa Crystal Reports para impressão			 	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
				CALLCRYS('Layout004', cParam ,cOptions)
				Sleep(1500)
				
			EndIf
				
		EndIf
		
	Next __nEtq

   If !Empty(cCancel)
      Aviso("Canceladas","Etiquetas canceladas: "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+cCancel,{"Ok"})
   EndIf
   
Return(.T.)
                                                                            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidSer ºAutor  ³ Michel A. Sander   º Data ³  15/02/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Op e busca etiquetas para cancelamento              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidSer()

	LOCAL _lValid := .T.
   
	If Empty(cNumOpBip)
	   Return ( _lValid )
	EndIf
	
	SC2->(DbSetOrder(1))
	If SC2->(!DbSeek(xFilial("SC2")+cNumOPBip))
		Alert("Ordem de produção inválida!")
		_lValid := .F.
		cNumOpBip := SPACE(11)
		oNumOpBip:Refresh()
		Return ( _lValid )
	EndIf
   
   SB1->(dbSetOrder(1))
   If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
      If AllTrim(SB1->B1_SUBCLAS) <> "MTP"
	      Alert("Produto não pertence a classe MTP.")
			_lValid := .F.
			cNumOpBip := SPACE(11)
			oNumOpBip:Refresh()
			Return ( _lValid )
		EndIf
   EndIf
      
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	//³Busca último número de série							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
   cSQL := "SELECT * FROM XD1010 (NOLOCK) WHERE "
   cSQL += "D_E_L_E_T_='' AND XD1_OCORRE <> '5' AND XD1_OP='"+AllTrim(cNumOpBip)+"' AND XD1_NIVEMB='1'"
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"TMP",.F.,.T.)
   If TMP->(Eof())
      Alert("Não existem etiquetas nível 1 para essa OP.")
		_lValid := .F.
		cNumOpBip := SPACE(11)
		oNumOpBip:Refresh()
		TMP->(dbCloseArea())
		Return ( _lValid )
   EndIf                  
   
   aCaixas := {}
   Do While TMP->(!Eof())
      AADD( aCaixas , { .F., TMP->XD1_XXPECA, TMP->XD1_SERIAL } )
      TMP->(dbSkip())
   EndDo
   
	oList:SetArray(aCaixas)
	oList:bLine := { || { If( aCaixas[oList:nAT,1], oOk, oNOK ), aCaixas[oList:nAt,2], aCaixas[oList:nAT,3] } }
	oList:Refresh()
	oDlg01:Refresh()
			   
   TMP->(dbCloseArea())

Return _lValid
