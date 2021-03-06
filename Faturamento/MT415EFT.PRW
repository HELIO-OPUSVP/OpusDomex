#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA416BX  �Autor  �Marcos Rezende      � Data �  06/27/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para Validar se o or�amento esta aprovado ���
���          � e liberando portanto a gera��o do pedido de venda          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT415EFT()
LOCAL NOPC := PARAMIXB[1] 
Local cAlias
Local cOrcNum
Local lRet := .t.


// Parametro Logico para Habilitar(.T.)  Validaco de Credito no Orcamento.
if getmv("MV_XCRDORC") 


	cOrcNum := SCJ->CJ_NUM
	cOrcNum := subs(cOrcNum+space(9),1,9)

	SZP->(DBSETORDER(1))
	/* desativa at� ser validado

	//s� realizar a verifica��o de aprova��o caso existe
	//registro na tabela SZP, devido a esta tabela ser preenchida
	//somente quanto o crit�rio de bloqueio � atendido
	//do contr�rio o or�amento continua sendo liberado
	if szp->(dbseek(xfilial("SZP")+'O'+cOrcNum+'0001'))
		//caso encontre o registro no cdastro de bloqueios
		//verifica se a data de aprova��o esta preenchida
		IF SZP->ZP_DTAPRV>=ddatabase
			lRet := .t.
		else              
			ALERT('Or�amento bloqueado por margem, n�o poder� ser efetivado.'+chr(13)+'Contate aprovador de Or�amentos')
			lRet := .f.
		endif
	endif
	*/




	//�������������������������������������������������������������������������Ŀ
	//�Valida se a Condi�ao de Pagamento e' Cartao de Credito (risco E) e exige �
	//�preenchimento da Autorizacaoo do Cartao para Liberar Orcamento.          �
	//���������������������������������������������������������������������������
							

	cCondE := Posicione("SE4",1,xFilial("SE4") + SCJ->CJ_CONDPAG,"E4_XRISCOE")
	if cCondE
		if empty(SCJ->CJ_XAUTCC)
			MsgAlert("Or�amento Bloqueado. Aguardando c�digo de Autoriza��o do Cart�o de Cr�dito.")
			lRet := .f.
		else

			//������������������������������������������������������������������������������������������Ŀ
			//�Atualiza Flag do campo CJ_STATUS Liberacao do Orcamento - MAS - Marco Aurelio - OPUSVP    �
			//� A=Aguardando Liberacao Diretoria                                                                  �
			//� B=Aguardando Autorizacao Cartao de Credito                                               �
			//� C=Autorizado Cartao de Credito                                                           �
			//��������������������������������������������������������������������������������������������

			cQry := ""
			cQry += " update "+retsqlname('SCJ')+" SET CJ_XSTATUS = 'C' WHERE CJ_NUM='"+cOrcNum+"' "
			tcsqlexec(cQry)

			
		endif

	Endif



	//����������������������������������������������Ŀ
	//�Avalia Limite de Cr�dito do Or�amento.        �
	//�Se n�o tiver limite, n�o permite a Efetiva��o.�
	//�Marco Aurelio - MAS - OPUS                    �
	//������������������������������������������������

	//    // Parametro Logico para Habilitar(.T.)  Validaco de Credito no Orcamento.
	//    if getmv("MV_XCRDORC") 

													
		cQuery := "SELECT SUM(CK_VALOR) AS TOTORC FROM " + RetSqlName("SCK") + " WHERE CK_NUM = '"+SCJ->CJ_NUM+"' AND D_E_L_E_T_ = '' "
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "TEMP"
		_nTotOrc := TEMP->TOTORC

		nValAv	:=	_nTotOrc  	// Valor Total do Item/Orcamento a ser Avaliado
		lCredito := MaAvalCred(SCJ->CJ_CLIENTE,SCJ->CJ_LOJA,nValAv,1,.T.,"")	// Cliente,Loja,Valor,Moeda,.T.													
		

		if !lCredito
			MsgAlert("Cliente N�o possui Cr�dito para Efetivar este Or�amento."+Chr(13)+Chr(10)+"Consulte a Posi��o do Cliente!")
			lret	:= .F.
		Else
			Alert("lCredito - Possui Credito")
			lret	:= .F.
		endif


Endif



RETURN lret
