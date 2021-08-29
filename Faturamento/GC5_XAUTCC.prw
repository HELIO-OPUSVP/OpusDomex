#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GC5_XAUTCC�Autor  �Marco Aurelo-OPUS   � Data � 26/06/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilhos para Validar Autorizacao do Cartao de Credito     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function GC5_XAUTCC()

Local lRet		:= .T.    
Local cQuery 	:= ""

If SuperGetMV("MV_XANACRE")  

	if !empty(M->C5_XAUTCC)
		if SELECT("QRY") > 0
			QRY->(dbCloseArea())
		Endif
		
		cQuery:= " SELECT * FROM "+RetSqlName("SC5")+" SC5 "
		cQuery+= " WHERE C5_XAUTCC = '"+M->C5_XAUTCC+"' "
		cQuery+= " AND D_E_L_E_T_ = '' "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)
		
		if QRY->(!Eof())
			MsgAlert("O Codigo de autorizacao "+Alltrim(M->C5_XAUTCC)+" j� foi informado na OF " + QRY->C5_NUM + ". Verifique!")
			lRet	:= .F.
		Endif
	
	Endif
Endif
      
Return(lRet)


