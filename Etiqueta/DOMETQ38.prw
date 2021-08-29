#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ38 �Autor  � Michel A. Sander   � Data �  10.04.2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta Modelo 38 - Kit de Pigtail 					      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ38(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

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

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNumSerie := 1
Default cNumPeca  := ""

//����������������������������������������������������������������Ŀ
//�Posiciona no Ordem de Produ��o   										 �
//����������������������������������������������������������������Ŀ
SC2->(DbSetOrder(1))
If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+AllTrim(cNumOp)))
	Alert("Ordem de Produ��o "+AllTrim(cNumOp)+" n�o localizada!")
	lAchou := .F.
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

//Se impressora n�o identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configura��o!")
	Return(.T.)
EndIf

//����������������������������������������������������������������Ŀ
//�Consiste a quantidade de conectores na estrutura					 �
//����������������������������������������������������������������Ŀ
nEtq := 0
cSQL := "SELECT B1_SUBCLAS, B1_GRUPO, B1_DESC, G1_COD, G1_COMP, G1_XXQTET1, "
cSQL += "(SELECT B1_SUBCLAS FROM "+RetSqlName("SB1")+" SUBB1 (NOLOCK) WHERE SUBB1.D_E_L_E_T_='' AND B1_COD=G1_COMP) SUB_CLASSE "
cSQL += "FROM "+RetSqlName("SG1")+" SG1 (NOLOCK) JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COD = B1_COD WHERE "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "(SELECT B1_SUBCLAS FROM "+RetSqlName("SB1")+" TB1 (NOLOCK) WHERE TB1.D_E_L_E_T_='' AND B1_COD=G1_COMP)='KIT PIGT' AND "
cSQL += "SG1.D_E_L_E_T_ = '' AND " 
cSQL += "SB1.D_E_L_E_T_ = ''"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"ETQ",.F.,.T.)

If ETQ->(Eof())

   Aviso("Aten��o","Um ou mais Componentes da estrutura est� com a sub-classe incorreta para KIT PIGTAIL. Altere a estrutura e tente novamente.",{"Ok"})
	cTxtMsg  := " Um ou mais Componentes da estrutura est� com a sub-classe incorreta para KIT PIGTAIL. Altere a estrutura e tente novamente." + Chr(13)
	cTxtMsg  += " Estrutura  = " + ETQ->G1_COD  + Chr(13)
	cTxtMsg  += " Componente = " + ETQ->G1_COMP + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 038 - Kit Pigtail para DIO"
	cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
 	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	ETQ->(dbCloseArea())
   Return

EndIf   

//�����������������������������������������������x�[�
//�Par�metros de impress�o do Crystal Reports		 �
//�����������������������������������������������x�[�
cOptions := "2;0;1;Pigtail"			// Parametro 1 (2= Impressora 1=Visualiza)
  
ETQ->(dbGoTop())
While ETQ->(!Eof())

   SB1->(dbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+ETQ->G1_COMP))
                              
      If ETQ->G1_XXQTET1 == 0
         MsgAlert("Quantidade de etiquetas na estrutura do componente de PigTail est� zerado. Altere a quantidade e tente novamente.")
         Exit
      EndIf
               
      For nQ := 1 to nQtdEtq

	      For x := 1 to ETQ->G1_XXQTET1
	      
		      cMVPAR01 := "ANATEL "+SB1->B1_XXTPCON
		      cMVPAR02 := SB1->B1_XXANAT4
		      cMVPAR03 := SB1->B1_XXANAT4
		      cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"
		   
			   //�����������������������������������������������x�[�
			   //�Executa Crystal Reports para impress�o			 	 �
			   //�����������������������������������������������x�[�
		      CALLCRYS('Layout038', cParam ,cOptions)
	         Sleep(1000)
	         
	      Next
      
		Next
		
	EndIf
      
   ETQ->(dbSkip()) 
   
EndDo

ETQ->(dbCloseArea())

Return ( .T. )
