#Include "PROTHEUS.CH"
  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ORCAFUNX  �Autor  �Microsiga           � Data �  08/28/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User function ProxSCJ()
	Local cPrxDoc:= ""
/*
	if SELECT("QRYB") > 0
		QRYB->(dbCloseArea())
	Endif

	cQuery:= " SELECT MAX(XD4_DOC)AS PRXDOC FROM "+RetSqlName("XD4")+" XD4 "
	cQuery+= " WHERE XD4_OP = '"+cCodOP+"' "
	cQuery+= " AND D_E_L_E_T_ = '' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYB",.T.,.T.)

	if QRYB->(!Eof())
		cPrxDoc:= STRZERO((val(QRYB->PRXDOC)+1),6)
	Endif
*/
Return cPrxDoc
