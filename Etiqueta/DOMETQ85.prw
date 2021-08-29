#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ85 �Autor  � Michel A. Sander   � Data �  08.11.2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta Cord�o Ericsson (Modelo 85)				          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ85(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

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

	cGrupo :=SB1->B1_GRUPO

	DO CASE
	CASE ALLTRIM(cGrupo)=='FLEX'
			cTipoETQ:='COAXIAL CABLE'
	CASE ALLTRIM(cGrupo)=='CORD'
			cTipoETQ:='FIBER CABLE'
	CASE ALLTRIM(cGrupo)=='TRUE'      
			cTipoETQ:='MULTIFIBER CABLE'
	OTHERWISE  
			cTipoETQ:=space(15)
	ENDCASE   

	//�����������������������������������������������x�[�
	//�Montagem do c�digo de barras 2D						 �
	//�����������������������������������������������x�[�
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	cYYYY   := SUBSTR(cSemana,1,4)
	cWW     := STRZERO(Val(SUBSTR(cSemana,5,2)),2)
	WEEK->(dbCloseArea())


	//�����������������������������������������������x�[�
	//�Par�metros de impress�o do Crystal Reports		 �
	//�����������������������������������������������x�[�
//	cOptions := "2;0;1;CordaoEricsson"			// Parametro 1 (2= Impressora 1=Visualiza)

//�����������������������������������������������x�[�
//�Par�metros de impress�o do Crystal Reports		 �
//�����������������������������������������������x�[�
	cOptions   := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
	//cOptions   := "1;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
	cNumSerie1 := SPACE(12)
	cNumSerie2 := SPACE(12)

	x := 0


	For x := 1 to mv_par03
	   //  Alert(mv_par03)
	   //Alert(nQtdEtq)
		/* Quanto � utilizado apenas para 1
		cMVPAR01 := SC6->C6_SEUCOD
		cMVPAR02 := SB1->B1_DESC
		cMVPAR03 := cYYYY+cWW
		cMVPAR04 := "MADE IN BRAZIL"
		cMVPAR05 := SC6->C6_XXRSTAT
		cMVPAR06 := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		cMVPAR07 := "T.A."
		cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"

		//�����������������������������������������������x�[�
		//�Executa Crystal Reports para impress�o			 	 �
		//�����������������������������������������������x�[�
		CALLCRYS('CordaoEricsson', cParam ,cOptions)
		*/
		
      	//x++

		//If x==2

			// Primeira Etiqueta
			cMVPAR01 := SC6->C6_SEUCOD
			//cMVPAR02 := "COAXIAL CABLE"
			cMVPAR02 := SB1->B1_DESC
			cMVPAR03 := cYYYY+cWW
			cMVPAR04 := "MADE IN BRAZIL"
			cMVPAR05 := SC6->C6_XXRSTAT
			cMVPAR06 := "T.A."
			cMVPAR07 := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			cMVPAR08 := "" //cNumSerie1
			
			// Segunda Etiqueta
			cMVPAR09 := SC6->C6_SEUCOD			
			cMVPAR10 := SB1->B1_DESC
			cMVPAR11 := cYYYY+cWW			
			cMVPAR12 := "MADE IN BRAZIL"
			cMVPAR13 := SC6->C6_XXRSTAT
			cMVPAR14 := "T.A."
			cMVPAR15 := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			cMVPAR16 := ""//cNumSerie2

			cParam := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"+cMVPAR08+";"
			cParam += cMVPAR09+";"+cMVPAR10+";"+cMVPAR11+";"+cMVPAR12+";"+cMVPAR13+";"+cMVPAR14+";"+cMVPAR15+";"+cMVPAR16+";"

			//�����������������������������������������������x�[�
			//�Executa Crystal Reports para impress�o			 	 �
			//�����������������������������������������������x�[�
			CALLCRYS('SerialEricssonX', cParam ,cOptions)

			Sleep(200)

			cNumSerie1 := SPACE(12)
			cNumSerie2 := SPACE(12)
			//x 			  := 0
				
      	//EndIf
		
	Next

Return ( .T. )
