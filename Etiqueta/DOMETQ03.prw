#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ03 �Autor  � Felipe A. Melo     � Data �  30/01/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Layout 02                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ03(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca,lFinalOp)

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

Private lAchou   := .T.
Private lNokia   := .F.
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
Default lFinalOp  := .F.

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

dbSelectArea("SC5")

dbSetOrder(1)
dbSelectArea("SC6")
dbSetOrder(1)
dbSelectArea("SC2")
dbSetOrder(1)
dbSelectArea("SZY")
dbSetOrder(1)

If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		MsgAlert("Numero O.P. "+AllTrim(cNumOP)+" n�o localizada!","Erro")
		lAchou := .F.
	EndIf
	
	If !Empty(SC2->C2_PEDIDO)
		//Localiza SC5
		SC5->(DbSetOrder(1))
		If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
			MsgAlert("Numero de Senf "+AllTrim(SC2->C2_PEDIDO)+" n�o localizado!","Erro")
			lAchou := .F.
		EndIf
		
		//Localiza SC6
		SC6->(DbSetOrder(1))
		If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
			MsgAlert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" n�o localizado!","Erro")
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
				//Alert("Programa��o de Faturamento n�o encontrado para o item.")
				lFatSZY := .F.
			EndIf
		EndIf
	EndIf
EndIf

If !Empty(cNumSenf)
	//Localiza SC5
	SC5->(DbSetOrder(1))
	If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+Subs(cNumSenf,1,6) ))
		MsgAlert("Numero de Senf "+Subs(cNumSenf,1,6)+" n�o localizado!","Erro")
		lAchou := .F.
	EndIf
	
	//Localiza SC6
	SC6->(DbSetOrder(1))
	If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+Subs(cNumSenf,1,8) ))
		MsgAlert("Item Senf "+Subs(cNumSenf,7,2) +" n�o localizado!","Erro")
		lAchou := .F.
	EndIf
EndIf

If !Empty(SC2->C2_PEDIDO) .OR. !Empty(cNumSenf)//If !Empty(SC2->C2_PEDIDO) //MLS, N�O ESTAVA POSICIONANDO NO SA1
	//Localiza SA1
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		MsgAlert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" n�o localizado!","Erro")
		lAchou := .F.
	EndIf
EndIf

//Localiza SB1
// Michel Sander em 12.01.2017 posicionar produto de acordo com OP ou SENF
If !Empty(cNumOp) .And. Empty(cNumSenf)
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		MsgAlert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n�o localizado!","Erro")
		lAchou := .F.
	EndIf
ElseIf !Empty(cNumSenf)
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
		MsgAlert("Produto "+AllTrim(SC6->C6_PRODUTO)+" n�o localizado!","Erro")
		lAchou := .F.
	EndIf
EndIf

//
If lAchou
	aRetAnat := fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	
	If lAchou .And. Empty(SB1->B1_XXNANAT)
		MsgAlert("N�o foi preenchido o campo 'N� Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]","Erro")
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
			
		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]     
			cCdAnat3 := ""
			
		Case Val(SB1->B1_XXNANAT) == 4 .And. Len(aGrpAnat) == 3
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			cCdAnat3 := aGrpAnat[3]
		
		//retirado do fonte em 05/04/2019	
		OtherWise 
			//cCdAnat1 := " E R R O "
			//cCdAnat2 := " E R R O "
			//If !Empty(cNumOP)
			//	Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			//ElseIf !Empty(cNumSenf)
			//	Alert("Erro no tratamento dos codigos ANATEL (DOMETQ03)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
		//	EndIf
		  //	lAchou   := .F.
			
	EndCase
	
EndIf

//Valida se Campo Descricao do Produto est� preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	MsgAlert("Campo Descricao do Produto n�o est� preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]","Erro")
	lAchou := .F.
EndIf

/**/
//Valida se Campo PN HUAWEI est� preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUCOD)
		MsgAlert("Campo PN n�o est� preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]","Erro")
		lAchou := .F.
	EndIf
EndIf

//Em 25/02/2014 foi definido que esse campo n�o ser� obrigatorio para esta etiqueta
//Valida se Campo PN HUAWEI est� preenchido
//If lAchou .And. Empty(SC6->C6_SEUDES)
//	Alert("Campo ITEM PEDIDO CLIENTE n�o est� preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUDES]")
//	lAchou := .F.
//EndIf

//Valida se Campo PEDIDO CLIENTE est� preenchido
If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC5->C5_ESP1)
		MsgAlert("Campo PEDIDO CLIENTE n�o est� preenchido no Cabe�alho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]","Erro")
		lAchou := .F.
	EndIf
EndIf

//Caso algum registro n�o seja localizado, sair da rotina
If !lAchou
	Return(.F.)
EndIf

//Se impressora n�o identificada, sair da rotina
If !lPrinOK
	MsgAlert("Erro de configura��o!","Erro")
	Return(.F.)
EndIf

// Verifica nivel da embalagem
If cNivel < "3"		// Nivel 3 n�o contem na estrutura
	aRetEmbala := U_RetEmbala(SB1->B1_COD,cNivel)
	If !aRetEmbala[4]
		MsgAlert("Emiss�o de etiqueta n�o permitida por falta de nivel da embalagem na estrutura.","Erro")
		Return(.F.)
	EndIf
EndIf

If lImpressao
	
	If lColetor
		If SUBSTR(SB1->B1_GRUPO,1,3) == "DIO"
			cPorta := "LPT3"
		EndIf
	EndIf
	
	//Chamando fun��o da impressora ZEBRA
	
	MSCBPRINTER(cModelo,cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBLOADGRF("RDT2.GRF")
	MSCBLOADGRF("ANATEL2.GRF")
	
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
		If ValType(aFilhas[_nX])  == "A"
			XD2->XD2_PCFILH := aFilhas[_nX][1]      
      Else
			XD2->XD2_PCFILH := aFilhas[_nX]
		EndIf
		XD2->( msUnlock() )
	Next _nX
	
	aRetEmbala   := U_RetEmbala(SB1->B1_COD,cNivel)
	
	//Se o nivel da embalagem foi 01 e a quantidade por embalagem for maior que 1.
	If Alltrim(cNivel) == "1" .And. aRetEmbala[2] > 1 
		If lFinalOP
			nQtdEmb := aRetEmbala[2]		
			MVPAR02:= nQtdEtq   //Qtd Embalagem
			MVPAR03:= 1   	
		Else
			nQtdEmb := aRetEmbala[2]		
			MVPAR02:= nQtdEmb   //Qtd Embalagem
			MVPAR03:= 1   		//Qtd Etiquetas /*revisar*/		
		EndIf
	EndIf

	For x := 1 To MVPAR03
		If x > 1
			_cProxPeca := U_IXD1PECA()
		EndIf
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
		XD1->XD1_OCORRE  := "6"
		XD1->XD1_OP      := cNumOP
		XD1->XD1_PV      := cNumSenf
		XD1->XD1_QTDORI  := nQtdEmb
		XD1->XD1_QTDATU  := nQtdEmb
		
		XD1->XD1_EMBALA  := aRetEmbala[1]
		XD1->XD1_QTDEMB  := aRetEmbala[2]
		XD1->XD1_NIVEMB  := If(AllTrim(cNivel)=="3",cNivel,aRetEmbala[3]) // Nivel 3 (Volumes parar expedi��o n�o constam na estrutura)
		If !Empty(SC2->C2_PEDIDO)
			XD1->XD1_PVSEP   := If(AllTrim(cNivel)=="3",SC5->C5_NUM,"")
		EndIf
		XD1->XD1_PESOB   := nPesoVol
		XD1->XD1_SERIAL  := cNumSerie
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
		
		//Inicia impress�o da etiqueta
		MSCBBEGIN(1,5)
		
		nCol := 05
		nIni := 07
		nLin := 04
		
		//Contorno/Borda
		MSCBBOX(03,05,115,88,3,"B")
		
		//Logos
		MSCBGRAFIC(10,10,"RDT2")
		MSCBGRAFIC(50,07,"ANATEL2")
		
		//MSCBSAYBAR(75 ,07               ,U_fTratTxt(XD1->XD1_XXPECA)                                                               ,"R","MB04",7.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
		  MSCBSAYBAR(75 ,07               ,U_fTratTxt(XD1->XD1_XXPECA)                                                               ,cRotacao,"MB04",7.361,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
		
		MSCBSAY(0045,nIni+(nLin*04)-1   ,StrZero(MVPAR02,4)+" Unidade(s)"                                                         ,cRotacao,"0","40,50")
		MSCBSAY(nCol,nIni+(nLin*06)-2   ,U_fTratTxt(SB1->B1_DESC)                                                                  ,cRotacao,"0","30,30")
		MSCBSAY(nCol,nIni+(nLin*07)-2   ,"PN RDT: "+U_fTratTxt(SB1->B1_COD)                                                        ,cRotacao,"0","30,30")
		lNokia := If("NOKIA" $ ALLTRIM(SA1->A1_NOME), .T., .F.)
		
		If !Empty(SC2->C2_PEDIDO) .Or. !Empty(cNumSenf)
			
			If lNokia
				MSCBSAY(nCol,nIni+(nLin*08)-2   ,U_fTratTxt("NOKIA SOLUTIONS AND NETWORKS BRASIL TELEC.")                               ,cRotacao,"0","40,40")
			Else
				MSCBSAY(nCol,nIni+(nLin*08)-2   ,U_fTratTxt(SA1->A1_NREDUZ)+" - "+U_fTratTxt(SC6->C6_SEUCOD)                               ,cRotacao,"0","30,30")
			Endif
			
			If lNokia
				MSCBSAY(nCol,nIni+(nLin*09.3)-2     ,"COD.:  "+U_fTratTxt(SC6->C6_SEUCOD)				                                       ,cRotacao,"0","40,40")
				MSCBSAY(nCol,nIni+(nLin*10.7)-2   ,"PED.CLIENTE: "+Subs(U_fTratTxt(SC5->C5_ESP1),1,45)                                       ,cRotacao,"0","30,30")
				MSCBSAY(nCol,nIni+(nLin*11.7)-2   ,"ITEM DO PEDIDO/CLIENTE: "+U_fTratTxt(SC6->C6_SEUDES)                                     ,cRotacao,"0","30,30")
			Else
				MSCBSAY(nCol,nIni+(nLin*09)-2   ,"PED.CLIENTE: "+Subs(U_fTratTxt(SC5->C5_ESP1),1,45)                                       ,cRotacao,"0","30,30")
				MSCBSAY(nCol,nIni+(nLin*10)-2   ,"ITEM DO PEDIDO/CLIENTE: "+U_fTratTxt(SC6->C6_SEUDES)                                     ,cRotacao,"0","30,30")
			EndIf
			
		EndIf
		
		MSCBSAY(nCol+80,nIni+(nLin*11),"SEMANA: "+U_fSemaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)                           ,cRotacao,"0","30,30")
		
		If Empty(cCdAnat3)
			
			If  lNokia
				If !Empty(cCdAnat1)
					MSCBSAYBAR(nCol,nIni+(nLin*13)-3 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*13)+6 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"0","30,40")
				EndIf
				
				If !Empty(cCdAnat2)
					MSCBSAYBAR(nCol,nIni+(nLin*16)-2 ,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*16)+7 ,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"0","30,40")
				EndIf
			Else
				If !Empty(cCdAnat1)
					MSCBSAYBAR(nCol,nIni+(nLin*12)-2 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*12)+7 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"0","30,40")
				EndIf
				
				If !Empty(cCdAnat2)
					MSCBSAYBAR(nCol,nIni+(nLin*15)+2 ,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*15)+11,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"0","30,40")
				EndIf
			EndIf
			
			MSCBSAY(nCol   ,nIni+(nLin*19),"INDUSTRIA BRASILEIRA"                                                                       ,cRotacao,"0","30,30")
			
			If !Empty(SC2->C2_PEDIDO)
				If !Empty(SC6->C6_XXSITE)
					MSCBSAY(nCol+75,nIni+(nLin*11)+11, "SITE     : " + SC6->C6_XXSITE							                                           ,cRotacao,"0","30,30")
				EndIf
				If lFatSZY
					MSCBSAY(nCol+75,nIni+(nLin*15)+11,"Prev.Fat.: " + DtoC(SZY->ZY_PRVFAT)					                                           ,cRotacao,"0","30,30")
				EndIf
			EndIf
			
			MSCBSAY(nCol+90,nIni+(nLin*19),"Layout 002"					                                                                   ,cRotacao,"0","30,30")
		Else
			
			If lNokia
				If !Empty(cCdAnat1)
					MSCBSAYBAR(nCol,nIni+(nLin*13)-6 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*13)+3 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"0","30,40")
				EndIf
				
				If !Empty(cCdAnat2)
					MSCBSAYBAR(nCol,nIni+(nLin*16)-5,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*16)+4,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"0","30,40")
				EndIf
				
				If !Empty(cCdAnat3)
					MSCBSAYBAR(nCol,nIni+(nLin*16)+8 ,U_fTratTxt(cCdAnat3)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*16)+17,U_fTratTxt(cCdAnat3)                                                                      ,cRotacao,"0","30,40")
				EndIf
			Else
				If !Empty(cCdAnat1)
					MSCBSAYBAR(nCol,nIni+(nLin*12)-6 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*12)+3 ,U_fTratTxt(cCdAnat1)                                                                      ,cRotacao,"0","30,40")
				EndIf
				
				If !Empty(cCdAnat2)
					MSCBSAYBAR(nCol,nIni+(nLin*15)-5,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*15)+4,U_fTratTxt(cCdAnat2)                                                                      ,cRotacao,"0","30,40")
				EndIf
				
				If !Empty(cCdAnat3)
					MSCBSAYBAR(nCol,nIni+(nLin*15)+8 ,U_fTratTxt(cCdAnat3)                                                                      ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
					MSCBSAY(nCol,nIni+(nLin*15)+17,U_fTratTxt(cCdAnat3)                                                                      ,cRotacao,"0","30,40")
				EndIf
				
			EndIf
			
			If !Empty(SC6->C6_XXSITE)
				MSCBSAY(nCol+69,nIni+(nLin*15)+11, "SITE     : " + SC6->C6_XXSITE							                                           ,cRotacao,"0","30,30")
			EndIf
			
			MSCBSAY(nCol+69,nIni+(nLin*19)-5,"INDUSTRIA BRASILEIRA"                                                                    ,cRotacao,"0","30,30")
			MSCBSAY(nCol+90,nIni+(nLin*19)  ,"Layout 002"					                                                               ,cRotacao,"0","30,30")
		EndIf
		
		MSCBInfoEti("DOMEX","80X60")
		
		//Finaliza impress�o da etiqueta
		MSCBEND()
		Sleep(500)
		
	Next x
	
	MSCBCLOSEPRINTER()
	
EndIf

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCodNat  �Autor  � Felipe Melo        � Data �  16/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCodNat(cCodProd)

Private aRet     := {}
Private x        := 0
Private lOk      := .T.
Private cErro    := ""

Private aAreaSB1 := SB1->(GetArea())
Private aAreaSG1 := SG1->(GetArea())

Private cNEtiquetas := ''

SB1->(DbSetOrder(1))
SG1->(DbSetOrder(1))

//SB1->(DbSeek(xFilial("SB1")+cCodProd)) //MLS
//MSGALERT('DOMETQ01x:'+cCodProd)        //MLS

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
                     

If Empty(cNEtiquetas)
	MsgStop('N�o foi preenchido o n�mero de c�digos de Barra Anatel no produto ' + cCodProd)
Else
	If cNEtiquetas == '0'
		If Len(aRet) <> 0
			MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a op��o de 0 c�digos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' c�digo Anatel na Estrutura do Produto.')
			lOk := .F.
		EndIf
	Else
		If cNEtiquetas == '1' .or. cNEtiquetas == '2'
			If Len(aRet) <> 1
				MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a op��o de 1 c�digos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' c�digo Anatel na Estrutura do Produto.')
				lOk := .F.
			EndIf
		Else
			If cNEtiquetas == '3'
				If Len(aRet) <> 2
					MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a op��o de 2 c�digos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' c�digo Anatel na Estrutura do Produto.')
					lOk := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
  
//If !lOk
//	Alert("A quantidade da(s) MP(s) "+cErro+" est�(�o) com casas decimais na quantidade da estrutura e isso n�o � permitido!")
//EndIf

RestArea(aAreaSB1)
RestArea(aAreaSG1)

Return({lOk,aRet})
