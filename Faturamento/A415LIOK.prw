
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A415LIOK   �Autor  � Osmar Ferreira  � Data �  16/06/2020   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida linha do cadastro de or�amentos  (SCJ / SCK)       ���
���          �  Retorna vari�vel tipo l�gica                              ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/
User Function A415LIOK
    Local aAreaSCK := GetArea()
    Local aAreaSCL := GetArea()
    Local lRetorno := .t.
    Local nMargem  := GetMV("MV_XMARGEM")  //Percentual m�nimo aceito como margem de lucro
    
    If lRetorno
        If TMP1->CK_XMARGEM > 0 .And. TMP1->CK_XMARGEM < nMargem
            MsgInfo("A Margem de Contribui��o deste item esta em "+Alltrim(Str(TMP1->CK_XMARGEM))+"%"+Chr(13)+"e esta abaixo de "+Alltrim(Str(nMargem))+"% ","A T E N � � O")
            lRetorno := .T.
        EndIf
    EndIf

    RestArea(aAreaSCL)
    RestArea(aAreaSCK)
Return(lRetorno)
