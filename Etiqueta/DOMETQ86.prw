#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ86 �Autor  � Michel A. Sander   � Data �  08.11.2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta Serial Mini-Harness (Modelo 86)			          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ86(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local mv_par02    := 1         //Qtd Embalagem
	Local mv_par03    := 1         //Qtd Etiquetas

	Private lAchou    := .T.
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
		cSerieFim := If( cNumSerie == "1", 1, Val(cNumSerie) )

		Do Case
			Case SC2->C2_QUANT <=9
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
		EndCase

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
	WEEK->(dbCloseArea())

	//�����������������������������������������������x�[�
	//�Par�metros de impress�o do Crystal Reports		 �
	//�����������������������������������������������x�[�
	cOptions := "2;0;1;MiniHarness"			// Parametro 1 (2= Impressora 1=Visualiza)
	nQ 		:= 1

	For x := 1 to mv_par03

		a := 1
		For nQ := 1 to 4
			
			cMVPAR01 := cNumSerie
			cMVPAR03 := cNumSerie
			cMVPAR05 := cNumSerie
			cMVPAR07 := "F"+StrZero(a,2)
			cMVPAR08 := "F"+StrZero(a+1,2)
			cMVPAR09 := "F"+StrZero(a+2,2)
			cParam   := cMVPAR01+";"+cMVPAR03+";"+cMVPAR05+";"+cMVPAR07+";"+cMVPAR08+";"+cMVPAR09+";"

			//�����������������������������������������������x�[�
			//�Executa Crystal Reports para impress�o			 	 �
			//�����������������������������������������������x�[�
			CALLCRYS('MiniHarness', cParam ,cOptions)
			Sleep(2000)
			a += 3
			
		Next nQ
		
		cNumSerie := Soma1(cNumSerie)

	Next

Return ( .T. )