#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ99 ºAutor  ³ Michel A. Sander   º Data ³  06.09.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta HUAWEI Crystal Reports			                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ99(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT1"

Local lPrinOK    := MSCBModelo("ZPL",cModelo)

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local cRotacao   := "N"      //(N,R,I,B)

Local MVPAR02   := nQtdEmb   //Qtd Embalagem
Local MVPAR03   := nQtdEtq   //Qtd Etiquetas

Local aRetAnat:= {}        //Codigos Anatel, Array
Local aCodAnat:= {}        //Codigos Anatel, Array
Local cCdAnat1:= ""        //Codigo Anatel 1
Local cCdAnat2:= ""        //Codigo Anatel 2

Private lHuawei  :=  .f.
Private lAchou   := .T.
Private aGrpAnat := {}        //Codigos Anatel Agrupados

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNivel   := ""
Default aFilhas  := {}
Default cNumSerie := ""
Default cNumPeca  := ""

If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	EndIf
	
	//Localiza SC5
	If !Empty(SC2->C2_PEDIDO)
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
	EndIf
EndIf

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
EndIf

//Localiza SA1
If !Empty(SC2->C2_PEDIDO)
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
		lAchou := .F.
	EndIf
EndIf
// MLS     23/07/2018
If !Empty(cNumSenf)
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
		lAchou := .F.
	EndIf
ENDIF
// FIM   

If  ("HUAWEI" $ Upper(SA1->A1_NOME)) .OR.  ("FOXCONN" $ Upper(SA1->A1_NOME))  
	lHuawei := .t.
EndIf    

//Valida se Cliente é HUAWEI
If lAchou .and. !lHuawei
	Alert("Não é cliente HUAWEI!")
	lAchou := .F.
EndIf

//Localiza SB1
SB1->(DbSetOrder(1)) 
If !Empty(cNumSenf)  
   If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
   	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	   lAchou := .F.
   EndIf
ELSE
   If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO)) 
  	   Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	   lAchou := .F.
   EndIf
ENDIF   
//MAURICIO TEMPORARIO força posicionamento no sb1 não estava posicionando produto Revenda sem OP
SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))  //<--------------------------------------------------------
//
//
If lAchou
	aRetAnat := fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	If ALLTRIM(SB1->B1_TIPO) <> "PR"
		If lAchou .And. Empty(SB1->B1_XXNANAT)
			Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
			lAchou := .F.
		EndIf
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
	
	//--> Alterado por Michel A. Sander em 25.06.2014 para verificar se o tipo PR de produto está sendo impresso
	If ALLTRIM(SB1->B1_TIPO) == 'PR'
		Do Case
			Case Val(SB1->B1_XXNANAT) == 0
				cCdAnat1 := ""
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 1
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 2
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := SB1->B1_XXANAT1
				
			Case Val(SB1->B1_XXNANAT) == 3
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := SB1->B1_XXANAT2
				cCdAnat3 := SB1->B1_XXANAT3
			OtherWise
				cCdAnat1 := " E R R O "
				cCdAnat2 := " E R R O "
				Alert("Erro no tratamento dos codigos ANATEL(DOMETQ04)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+MVPAR01)
				lAchou   := .F.
				
		EndCase
	Else
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
				
			Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 1
				cCdAnat1 := aGrpAnat[1]
				cCdAnat2 := aGrpAnat[1]
				
			OtherWise
				cCdAnat1 := " E R R O "
				cCdAnat2 := " E R R O "
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ04)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+MVPAR01)
				lAchou   := .F.
				
		EndCase
	EndIf
EndIf

//Valida se Campo Descricao do Produto está preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Valida se Campo PN HUAWEI está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUCOD)
		Alert("Campo PN HUAWEI não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
		lAchou := .F.
	EndIf
EndIf

//Valida se Campo PN HUAWEI está preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUDES)
		Alert("Campo ITEM PEDIDO CLIENTE não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUDES]")
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
	Return(.T.)
EndIf

//Se impressora não identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configuração!")
	Return(.T.)
EndIf

// Verifica nivel da embalagem
aRetEmbala := U_RetEmbala(SB1->B1_COD,cNivel)
If !aRetEmbala[4]
	Alert("Emissão de etiqueta não permitida por falta de nivel da embalagem na estrutura.")
	Return(.F.)
EndIf

If lImpressao
	
   //Controla o numero da etiqueta de embalagens
	If Empty(cNumPeca)
		_cProxPeca := U_IXD1PECA()
	Else
		_cProxPeca := cNumPeca
	EndIf
	
	For _nX := 1 to Len(aFilhas)
		Reclock("XD2",.T.)
		XD2->XD2_FILIAL := xFilial("XD2")
		XD2->XD2_XXPECA := _cProxPeca
		If ValType(aFilhas[1]) == "A"
			XD2->XD2_PCFILH := aFilhas[_nX,1]
		Else
			XD2->XD2_PCFILH := aFilhas[_nX]
		EndIf
		XD2->( msUnlock() )
	Next _nX
	
	For x := 1 To MVPAR03

      If x > 1
         _cProxPeca := U_IXD1PECA()
      EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca o próximo número de sequencia da etiqueta 		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSeqEtiq := ""
		If cNivel == "1"
			cSeqEtiq := NEXTSEQ()
	   Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Próximo nivel deve manter sequencia em 1/1		 		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	      If MVPAR02 == 1
	         For nQ := 1 to Len( aFilhas ) 
					If ValType(aFilhas[1]) == "A"
						cBuscaSerie := aFilhas[nQ,1]
					Else
						cBuscaSerie := aFilhas[nQ]
					EndIf         
					If XD1->(dbSeek(xFilial()+cBuscaSerie))
					   cSeqEtiq := IIF(LEFT(ALLTRIM(XD1->XD1_SERIAL),1) == "S",Alltrim(Substr(ALLTRIM(XD1->XD1_SERIAL),2,6))+ Alltrim(Substr(ALLTRIM(XD1->XD1_SERIAL),8)),ALLTRIM(XD1->XD1_SERIAL))	 				   
					Else
					   cSeqEtiq := NEXTSEQ()
					EndIf
	         Next nQ
	      Else
				cSeqEtiq := NEXTSEQ()      
	      EndIf   
	   EndIf

		aRetEmbala       := U_RetEmbala(SB1->B1_COD,cNivel)
		
		Reclock("XD1",.T.)
		XD1->XD1_FILIAL  :=  xFilial("XD1")
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
		XD1->XD1_OCORRE  := "6"
		XD1->XD1_OP      := cNumOP
		XD1->XD1_QTDORI  := nQtdEmb
		XD1->XD1_QTDATU  := nQtdEmb
		XD1->XD1_EMBALA  := aRetEmbala[1]
		XD1->XD1_QTDEMB  := aRetEmbala[2]
		XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3])
		XD1->XD1_PESOB   := nPesoVol

		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
		EndIf

      XD1->XD1_SERIAL := cSeqEtiq
		XD1->( MsUnlock() )
		
		// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
		If Type("cDomEtDl31_CancEtq") <> "U"
			cDomEtDl31_CancEtq := XD1->XD1_XXPECA
			cDomEtDl32_CancOP  := cNumOP
			cDomEtDl33_CancEmb := cNumSenf
			cDomEtDl34_CancKit := nQtdEmb
			cDomEtDl35_CancUni := nQtdEtq
			cDomEtDl38_CancNiv := cNivel
			aDomEtDl3A_CancFil := aFilhas
			cDomEtDl39_CancPes := nPesoVol
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Montagem do código de barras 2D						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
		cSemana := WEEK->SEMANA
		cYY     := SUBSTR(cSemana,3,2)
		cWW     := StrZero(Val(SubStr(cSemana,5,2)),2)
		cSemana := cYY+cWW
		WEEK->(dbCloseArea())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Montagem dos parâmetros de saída da etiqueta 	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿                                                          	// Parametros dentro do Crystal
		cPN     := "PN: "+ALLTRIM(SC6->C6_SEUCOD)+";" 																							// MV_PAR01
		cCB_PN  := ALLTRIM(SC6->C6_SEUCOD)+";"                                                                         	// MV_PAR02
		cRev    := SPACE(01)+";"                                                                                        	// MV_PAR03
		cQty    := "Qty: "+ALLTRIM(Str(MVPAR02))+";"                                                                   	// MV_PAR04
		cCB_Qty := ALLTRIM(Str(MVPAR02))+";"                                                                           	// MV_PAR05
		cModel  := "Model: "+If(Empty(ALLTRIM(SC6->C6_XCODCTE)),ALLTRIM(SB1->B1_COD),ALLTRIM(SC6->C6_XCODCTE))+";"       	// MV_PAR06
		cDescP  := "Desc.: "+AllTrim(SB1->B1_DESC)+";"                                                                 	// MV_PAR07
		cDescSN := "SN: 19"+AllTrim(SC6->C6_SEUCOD)+"/AZ0163"+cSemana+"Q"+StrZero(MVPAR02,4)+"S"+cSeqEtiq+";" // MV_PAR08
		cCB_SN  := "19"+AllTrim(SC6->C6_SEUCOD)+"/AZ0163"+cSemana+"Q"+StrZero(MVPAR02,4)+"S"+cSeqEtiq+";"     // MV_PAR09
		cRemark := "Remark: "+ALLTRIM(SC6->C6_XDESCTE)+";"                                                                   // MV_PAR10
		cEtqDom := ALLTRIM(XD1->XD1_XXPECA)+";"                                                                           // MV_PAR11
		cDMatrix:= cCB_SN                                                                                           // MV_PAR12
		cSem	:= "Semana: "+SubStr(cSemana,1,2)+"/"+SubStr(cSemana,3,2) + "."  		                                           // MV_PAR13
		cCodBar := cPN+cCB_PN+cRev+cQty+cCB_Qty+cModel+cDescP+cDescSN+cCB_SN+cRemark+cEtqDom+cDMatrix+cSem
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Parâmetros de impressão do Crystal Reports		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	   cOptions := "2;0;1;HUAWEI99"			// Parametro 1 (2= Impressora 1=Visualiza)
	   	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		//³Executa Crystal Reports para impressão			 	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		CALLCRYS('HUAWEI99', cCodBar ,cOptions)
	
	Next x
	
EndIf

Return ( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCodNat  ºAutor  ³ Felipe Melo        º Data ³  16/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCodNat(cCodProd)

Local aRet     := {}
Local x        := 0
Local lOk      := .T.
Local cErro    := ""

Local aAreaSB1 := SB1->(GetArea())
Local aAreaSG1 := SG1->(GetArea())

Local cNEtiquetas :=''

SB1->(DbSetOrder(1))
SG1->(DbSetOrder(1))

//SB1->(DbSeek(xFilial("SB1")+cCodProd)) //MLS
//MSGALERT('DOMETQ01:'+cCodProd)        //MLS


If SG1->(DbSeek(xFilial("SG1")+cCodProd))
	cNEtiquetas := Alltrim(SB1->B1_XXNANAT)
	
	While SG1->(!Eof()) .And. AllTrim(cCodProd) == AllTrim(SG1->G1_COD)
		If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP)) .And. !Empty(SB1->B1_XXANAT1)
			//For x:=1 To SG1->G1_QUANT
			aAdd(aRet,SB1->B1_XXANAT1)
			//Next x
			//If (SG1->G1_QUANT%1) > 0
			//	lOk := .F.
			//	cErro += IIf(Empty(cErro),""," / ") + AllTrim(SG1->G1_COMP)
			//EndIf
		EndIf
		SG1->(DbSkip())
	End
EndIf

IF ALLTRIM(SB1->B1_TIPO) <> "PR"
	If Empty(cNEtiquetas)
		MsgStop('Não foi preenchido o número de códigos de Barra Anatel no produto ' + cCodProd)
	Else
		If cNEtiquetas == '0'
			If Len(aRet) <> 0
				MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 0 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
				lOk := .F.
			EndIf
		Else
			If cNEtiquetas == '1' .or. cNEtiquetas == '2'
				If Len(aRet) <> 1
					MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 1 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
					lOk := .F.
				EndIf
			Else
				If cNEtiquetas == '3'
					If Len(aRet) <> 2
						MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 2 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
						lOk := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
ENDIF

//If !lOk
//	Alert("A quantidade da(s) MP(s) "+cErro+" está(ão) com casas decimais na quantidade da estrutura e isso não é permitido!")
//EndIf

RestArea(aAreaSB1)
RestArea(aAreaSG1)

Return({lOk,aRet})

Static Function NEXTSEQ()
Local _Retorno := 0
Local nLoop    := 0
Local lLoop    := .T.
Local aAreaGER := GetArea()
Local aAreaSX6 := SX6->( GetArea() )

SX6->( Dbsetorder(1) )

//cSeqEtiq := AllTrim(GetMV("MV_XXSEQET"))
//PutMv("MV_XXSEQET",Soma1(cSeqEtiq))

If SX6->( dbSeek("  " + "MV_XXSEQET") )
	While lLoop .and. nLoop < 1000
		If RecLock("SX6",.F.) .And. lLoop
			_NextDoc        := Alltrim(SX6->X6_CONTEUD)
			SX6->X6_CONTEUD := SOMA1(_NextDoc)
			SX6->( Msunlock() )
			
			lLoop    := .F.
			_Retorno := _NextDoc
		EndIf
		nLoop ++
	End
EndIf

If Empty(_Retorno)
	aPar := {}
	aAdd(aPar,{1,"Codigo Sequencial"     ,Space(06) ,"@!"    ,"NaoVazio()",      ,,60,.T.})
	aRet := {}
	aAdd(aRet,Space(06))
	If ParamBox(aPar,"Cadastro Produto",@aRet)
		PutMv("MV_XXSEQET",aRet[1])
		_Retorno := AllTrim(aRet[1])
	Else
		lAchou := .F.
	EndIf
EndIf

If Empty(_Retorno)
	MsgYesNo('Erro no campo sequencial!')
EndIf

RestArea(aAreaSX6)
RestArea(aAreaGER)

Return _Retorno