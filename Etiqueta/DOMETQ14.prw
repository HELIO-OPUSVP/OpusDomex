#include "protheus.ch"
#include "rwmake.ch"             

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ14 �Autor  � Michel A. Sander   � Data �  11.08.2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta Modelo 14 (n�o grava XD1)                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ14(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

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

Private cCdAnat1   := ""        //Codigo Anatel 1
Private cCdAnat2   := ""        //Codigo Anatel 2
Private lAchou     := .T.
Private aGrpAnat   := {}     //Codigos Anatel Agrupados
Private _cSerieIni := ""
Private nReduzCol  := 2      // Vari�vel de redu��o da coluna em todos os pontos de impress�o

Default cNumOP     := ""
Default cNumSenf   := ""
Default nQtdEmb    := 0
Default nQtdEtq    := 0
Default cNumSerie  := ""
Default cNumPeca   := ""

//����������������������������������������������������������������Ŀ
//�Busca quantidades para impress�o											 �
//����������������������������������������������������������������Ŀ
mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)
	
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" n�o localizada!")
		lAchou := .F.
	EndIf
	
	//����������������������������������������������������������������Ŀ
	//�Monta o n�mero de s�rie														 �
	//����������������������������������������������������������������Ŀ
	_cSerieIni:=ALLTRIM(SC2->C2_NUM)+SC2->C2_ITEM
	
EndIf

//����������������������������������������������������������������Ŀ
//�Variaveis de sequencia de via e serie									 �
//����������������������������������������������������������������Ŀ
cCdAnat1   := ""
cCdAnat2   := ""

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

//Se impressora n�o identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configura��o!")
	Return(.F.)
EndIf

Private nMetragem := SB1->B1_XXMETIQ
Private nILA      := SB1->B1_XXIL1
Private nILB      := SB1->B1_XXIL2

//����������������������������������������������������������������Ŀ
//�Consiste codigo ANATEL dos componentes da estrutura				 �
//����������������������������������������������������������������Ŀ
If !fTestaAnatel(SB1->B1_COD,@cNumOP,@cNumSenf,.T.)
	REturn ( .F. )
EndIf

//Caso algum registro n�o seja localizado, sair da rotina
If !lAchou
	Return(.F.)
EndIf

lImprime  := .F.
a         := 3
nCont     := 1

//����������������������������������������������������������������Ŀ
//�Prepara s�rie inicial														 �
//����������������������������������������������������������������Ŀ
nSerie    := _cSerieIni

//����������������������������������������������������������������Ŀ
//�Prepara os Arrays de impress�o por lado								 �
//����������������������������������������������������������������Ŀ
aLado1    := {}

//����������������������������������������������������������������Ŀ
//�Montagem dos arrays de impress�o das etiquetas						 �
//����������������������������������������������������������������Ŀ
For nQ := 1 To nQtdEtq		// nQtdEtq = Quantidade de Etiquetas no parametro de impress�o
	
	If SB1->B1_XXMETIQ == Int(SB1->B1_XXMETIQ)
		cMasc := "@E 999"
	Else                 
	   If Round(SB1->B1_XXMETIQ,1) == SB1->B1_XXMETIQ
	      cMasc := "@E 999.9"
	   Else
		   cMasc := "@E 999.99"
		EndIf
	EndIf
	
	cIL := ""
	AADD( aLado1, { "PRM ", ;
						  " "+ALLTRIM(nSerie), ;
						  Alltrim(Transform(SB1->B1_XXMETIQ,cMasc))+"M", ;
						  "", ;
					     "", ;
				 		  cCdAnat1, ;
						  cCdAnat2, ;
						  "" } )
			
Next nQ

//����������������������������������������������������������������Ŀ
//�Preenche etiquetas vazias que sobraram	 L A D O  UNICO 			 �
//����������������������������������������������������������������Ŀ
// Sobrando duas
If MOD( Len(aLado1), 3) == 1
	AADD( aLado1, { "  OP FINALIZADA", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
	AADD( aLado1, { "  OP FINALIZADA", ;
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
	AADD( aLado1, { "OP FINALIZADA", ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01), ;
	SPACE(01) } )
EndIf

//����������������������������������������������������������������Ŀ
//�																					 �
//�Impress�o do L A D O  UNICO												 �
//�																					 �
//����������������������������������������������������������������Ŀ

If Len(aLado1) > 0
	
	a := 99
	
	For x := 1 to Len(aLado1)
		
		a := a + 1
		If a > 3
			a := 1
			//Chamando fun��o da impressora ZEBRA
			MSCBPRINTER(cModelo,cPorta,,,.F.)
			MSCBChkStatus(.F.)
			MSCBLOADGRF("RDT2.GRF")
			MSCBLOADGRF("ANATEL2.GRF")
			//Inicia impress�o da etiqueta
			MSCBBEGIN(1,5)
			lImprime := .T.
			nIni := 08
			nLin := 04
		EndIf
		
		If a == 1
			Lin1Col1 := 004
			//Lin1Col2 := 011
			Lin1Col2 := 012
			Lin1Col3 := 032
		ElseIf a == 2
			Lin1Col1 := 044
			//Lin1Col2 := 051
			Lin1Col2 := 052
			Lin1Col3 := 072
		ElseIf a == 3
			Lin1Col1 := 085
			//Lin1Col2 := 092
			Lin1Col2 := 093
			Lin1Col3 := 113
		EndIf
		
		MSCBSAY(Lin1Col1-nReduzCol   ,nIni+(nLin*01)   ,aLado1[x,1]                 ,cRotacao,"0","30,30")
		MSCBSAY(Lin1Col2-nReduzCol   ,nIni+(nLin*01)   ,aLado1[x,2]+' '+aLado1[x,3] ,cRotacao,"0","24,24")
		
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
			Lin3Col2 := 017
		ElseIf a == 2
			Lin3Col1 := 044
			Lin3Col2 := 058
		ElseIf a == 3
			Lin3Col1 := 085
			Lin3Col2 := 098
		EndIf
		
		MSCBSAY(Lin3Col2-nReduzCol ,nIni+(nLin*1.9)   ,aLado1[x,6] ,cRotacao,"0","21,21")
		MSCBSAY(Lin3Col2-nReduzCol ,nIni+(nLin*2.8)   ,aLado1[x,7] ,cRotacao,"0","21,21")
		
		If a == 3
			MSCBInfoEti("DOMEX","80X60")
			//Finaliza impress�o da etiqueta
			MSCBEND()
			Sleep(500)
			MSCBCLOSEPRINTER()
			lImprime := .T.
		EndIf
		
	Next
	
	If lImprime
		MSCBInfoEti("DOMEX","80X60")
		//Finaliza impress�o da etiqueta
		MSCBEND()
		Sleep(500)
		MSCBCLOSEPRINTER()
	EndIf
	
EndIf

Return ( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fTestaAnatel �Autor  � Michel Sander  � Data �  15/05/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca codigo Anatel do componente da estrutura             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fTestaAnatel(cCodPA,cNumOp,cNumSenf,lMostra)

LOCAL lAchou := .T.

//����������������������������������������������������������������Ŀ
//�Consiste codigo ANATEL do componente									 �
//����������������������������������������������������������������Ŀ
SB1->(dbSeek(xFilial("SB1")+cCodPA))

aRetAnat  := U_fCodNat(SB1->B1_COD)
lAchou    := aRetAnat[1]
aCodAnat  := aRetAnat[2]

If Empty(SB1->B1_XXNANAT)
	If lMostra
		Alert("N�o foi preenchido o campo 'N� Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
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