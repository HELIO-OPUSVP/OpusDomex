/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FC021CPO  �Autor  �Mauricio L Souza  � Data �    14/04/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para criar campo arq temporario           ���
���          � flxo de caixa, utiliado para gerar log nesse ponto         ���                                               ���
�������������������������������������������������������������������������͹��
���Uso       � DOMEX - OPUSVP                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Obs: basta Retornar .T. para validar a linha

*/

User Function FC021CPO()
    Local aCposAna := aClone(PARAMIXB)
    Local aRet := {}
    //AADD(aRet,{"TESTE","C",5,0} )
    // HISTORICO
    CV8->(DBSELECTAREA('CV8'))
    CV8->(DBSETORDER(1))
    RecLock("CV8",.T.)
    CV8->CV8_FILIAL := '01'
    CV8->CV8_DATA   := DATE()
    CV8->CV8_HORA   := Time()
    CV8->CV8_USER   :=  Subs(cUsuario,7,14)
    CV8->CV8_MSG    := "Execucao Fluxo de Caixa FC021CPO " + GetEnvServer()
    //CV8->CV8_DET    :=
    CV8->CV8_PROC   := 'FINC021'
    CV8->CV8_INFO   := '1'
    CV8->CV8_SBPROC :='FC021CPO'
    CV8->CV8_IDMOV  := '0002351519'
    CV8->( msUnlock() )

Return aClone(aRet)