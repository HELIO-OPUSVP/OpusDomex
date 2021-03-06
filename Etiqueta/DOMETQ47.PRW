#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ47 �Autor  � Ricardo Roda       � Data �  17.12.2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta HARNESS ERICSSON avulsa      			          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P12                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ47(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local mv_par02    := 1         //Qtd Embalagem
	Local mv_par03    := 1         //Qtd Etiquetas

	Private lAchou    := .T.
	Private _aArq	  :={}
	Private aCodEtq	  :={}
	Private cLocImp  := ""

	private aPar     	:= {}
	private aRetPar   := {}     

	Default cNumOP    := ""
	Default cNumSenf  := ""
	Default nQtdEmb   := 0
	Default nQtdEtq   := 0

	Default cNumSerie := "1"
	Default cNumPeca  := ""

	


	//����������������������������������������������������������������Ŀ
	//�Busca quantidades para impress�o											 �
	//����������������������������������������������������������������Ŀ
	mv_par02:= nQtdEmb   //Qtd Embalagem
	mv_par03:=  Ceiling(nQtdEtq/3) // nQtdEtq   //Qtd Etiquetas

	If !Empty(cNumOP)
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" n�o localizada!")
			lAchou := .F.
		EndIf

	EndIf

	//����������������������������������������������������������������Ŀ
	//�Posiciona no PA																 �
	//����������������������������������������������������������������Ŀ
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n�o localizado!")
		lAchou := .F.
	EndIf

	//����������������������������������������������������������������Ŀ
	//�Posiciona no Cliente					    									 �
	//����������������������������������������������������������������Ŀ
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
		Alert("Cliente "+SC2->C2_CLIENT+"n�o localizado!")
		lAchou := .F.
	EndIf

	//����������������������������������������������������������������Ŀ
	//�Valida descri��o do produto		    									 �
	//����������������������������������������������������������������Ŀ
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto n�o est� preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

	//����������������������������������������������������������������Ŀ
	//�Valida descri��o do pedido   									 �
	//����������������������������������������������������������������Ŀ
	SC6->(DbSetOrder(1))
	If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
		Alert("Item P.V. "+AllTrim(SC2->C2_ITEMPV)+" n�o localizado!")
		lAchou := .F.
	EndIf

	//Caso algum registro n�o seja localizado, sair da rotina
	If !lAchou
		Return(.T.)
	EndIf

	//�����������������������������������������������x�[�
	//�Montagem do c�digo de barras 2D						 �
	//�����������������������������������������������x�[�
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cYYYY   := SUBSTR(cSemana,1,4)
	cWW     := STRZERO(Val(SUBSTR(cSemana,5,2)),2)
	WEEK->(dbCloseArea())

	cMVPAR01 := SC6->C6_SEUCOD
	cMVPAR02 := cYYYY+cWW
	cMVPAR03 := "Made in Brazil"
	cMVPAR04 := ALLTRIM(SC6->C6_XXRSTAT)
	cMVPAR05 := ALLTRIM(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	cMVPAR06 := "T.A."



if empty(Alltrim(cLocImp))
    aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
Endif

If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
	Return
EndIf
 
   cLocImp:= ALLTRIM(aRetPar[1])

If !CB5SetImp(cLocImp,.F.)
	MsgAlert("Local de impressao invalido!","Aviso")
	Return 
EndIf

 

	For x := 1 to mv_par03

		/*/cLocImp:= "000000"
		If !CB5SetImp(cLocImp,.F.)
			MsgAlert("Local de impressao invalido!","Aviso")
				Return .F.
			EndIf
		/*/


		//MSCBPRINTER("ZEBRA","LPT1",,,.f.,,,,,,,)
		//MSCBCHKSTATUS(.T.)
		//MSCBBEGIN(1,4)
		
		MSCBBEGIN(1,6,100)
		AADD(_aArq,""+CRLF)
		AADD(_aArq,"^MMT"+CRLF)
		AADD(_aArq,"^PW957"+CRLF)
		AADD(_aArq,"^LL0429"+CRLF)
		AADD(_aArq,"^LS0"+CRLF)

		AADD(_aArq,"^FO160,128^GFA,01280,01280,00020,:Z64:"+CRLF)
		AADD(_aArq,"eJxjYBgFIw00YICBdhEcBIAIVLc1/8B0H2sAplbrHRhCjKEOGGL8/zFMY2ANgZnRvWGDtXT7gl1SEtwLKiBioa4hgaGirI6hoiKsjFD3/Tu35/PjH33N5+fPaeiHui+AVSTQIUCEkVVUhCE0AqK3gFtic0ONNHvz7BnMvxcgzGMQZXVlFA1hDYXaW3/+w+cG+fPPm+fe4f/DAFMXEMgAtLZRJITVAepfA26LzQ2MDcbNM3ZwN0P9C7aX0SHQVSQEGi4NDf/Pz/n4f//5z//n/Gn4D3VfqKtIQGgoq2OIiAg8XJSYuBSsuJgbLDg0uHfjCRfk8HuAKcaKKYQPDKb0BwC/8Wet:632A"+CRLF)
		AADD(_aArq,"^FT31,107^A0N,21,21^FH\^FD"+cMVPAR01+"^FS"+CRLF)
		AADD(_aArq,"^FT31,144^A0N,21,21^FH\^FD"+cMVPAR02+"^FS"+CRLF)
		AADD(_aArq,"^FT109,144^A0N,21,16^FH\^FD"+cMVPAR04+cMVPAR05+cMVPAR06+"^FS"+CRLF)
		AADD(_aArq,"^FT31,183^A0N,21,19^FH\^FDMade in Brazil^FS"+CRLF)

		AADD(_aArq,"^FO480,128^GFA,01280,01280,00020,:Z64:"+CRLF)
		AADD(_aArq,"eJxjYBgFIw1wYICBdhEcsIIINMfZd2C6LxRTK/PuBgwx0RBMdf9/YIqFOkDN2LGbm3njjiruhQsbdrFDzGMNCXUVDQwIEQ0MdAgQhbiP/83r83b2HS9sfv48wfEf4j5WhkBXEVZGBwGgOtZQiF52ho3dFuwHN1RY7myw38UAN0+AMSAkQDDUITQAIsb+5z+/BeOffxWWdw/8PwBXxyrAECIaIejqEMIKdR/D5m4LBglmC8vuhh3WUPeB7GUQYRUJdHWAhAvQfX9+npf//ee//c/zJ/hh7gsJdGUNBfrD0dEBFi5MCgqLmBcssGBuaGrYvQN3uCCDf5hCDAFYxHCDwZT+AAhRS/Y=:4CCC"+CRLF)
		AADD(_aArq,"^FT355,107^A0N,21,21^FH\^FD"+cMVPAR01+"^FS"+CRLF)
		AADD(_aArq,"^FT355,144^A0N,21,21^FH\^FD"+cMVPAR02+"^FS"+CRLF)
		AADD(_aArq,"^FT433,144^A0N,21,16^FH\^FD"+cMVPAR04+cMVPAR05+cMVPAR06+"^FS"+CRLF)
		AADD(_aArq,"^FT355,183^A0N,21,19^FH\^FDMade in Brazil^FS"+CRLF)

		AADD(_aArq,"^FO800,128^GFA,01280,01280,00020,:Z64:"+CRLF)
		AADD(_aArq,"eJxjYBgFIw0wYoCBdhECLGDAcB/7R0z3cS3A1FpegCHEtKoBQ0z+P6ZWrhUwM8QTE8rM+R1LTAzEHT5AxFZ1rVi0SouraZWWBhcT1H1/51Y+P/5Rln2+vSWjPNR9C7g0FjUs0GDi0tJgWLUBoveBmGE6ww8zfnZzA/bvDgjzGLS4upi0VnCtgtr7f/7D5wz288+zW++Q/8EAU7dgEQNX02omjRVcDVD/JogVpjMwM6SzGxaIs0P9C7aXqWFRl8YKSLgA3fd/vuXj//Xzn/+3/Mn4H+q+VV0aC1at4mpaoaEBDxcXFhGHEhF2hgKBAPFyPOGCHH4HsKjDFMIDBlP6AwBgYE3b:CE88"+CRLF)
		AADD(_aArq,"^FT678,107^A0N,21,21^FH\^FD"+cMVPAR01+"^FS"+CRLF)
		AADD(_aArq,"^FT678,144^A0N,21,21^FH\^FD"+cMVPAR02+"^FS"+CRLF)
		AADD(_aArq,"^FT756,144^A0N,21,16^FH\^FD"+cMVPAR04+cMVPAR05+cMVPAR06+"^FS"+CRLF)
		AADD(_aArq,"^FT678,183^A0N,21,19^FH\^FDMade in Brazil^FS"+CRLF)

		AADD(_aArq,"^PQ"+CvALTOCHAR(nQtdEtq)+",0,1,Y^XZ"+CRLF)

		AaDd(aCodEtq,_aArq)
		
		For nY:=1 To Len(aCodEtq)
			For nP:=1 To Len(aCodEtq[nY])
				MSCBWrite(aCodEtq[nY][nP])
			Next nP
		Next nY
		MSCBEND()
		MSCBCLOSEPRINTER()
	Next

Return ( .T. )
