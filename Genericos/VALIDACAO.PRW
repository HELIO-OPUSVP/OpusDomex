#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDACAO �Autor  �H�lio Ferreira      � Data �  15/07/21   ���
�������������������������������������������������������������������������͹��
���Desc.    � Fun��o para validar se o environment Atual � o de Valida��o ���
���         � ou algum ambiente de desenvolvimento                        ���                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VALIDACAO(cConsultor,lRetorno)
	//Local _Retorno := .F.
    Local cEnvironment := Upper(GetEnvserv())
	Local aConsultores := {}
	Default cConsultor := ""
	Default lRetorno := .F.

	AADD(aConsultores,"HELIO")
	AADD(aConsultores,"RODA")
	AADD(aConsultores,"JONAS")
	AADD(aConsultores,"MAURICIO")
	AADD(aConsultores,"OSMAR")
	AADD(aConsultores,"MAURESI")
	AADD(aConsultores,"JACKSON")

	If !Empty(cConsultor)
		If aScan(aConsultores,cConsultor) == 0
			apMsgInfo('Consultor ' + cConsultor + ' n�o cadastrado na fun��o U_VALIDACAO()')
		EndIf
	EndIf

	If cEnvironment == "VALIDACAO" .or. cEnvironment =="WEBCOL_VALIDACAO" .or. cEnvironment == "WEBCOLMG_VALIDACAO" .or. ".OPUS" $ cEnvironment .or. cEnvironment == "MAURESI" .or. cEnvironment == "COMPILA_QUENTE_VALIDACAO" .or. cEnvironment =="ricardo.opus" .or. cEnvironment == "HELIO.OPUS"
		lRetorno := .T.
	EndIf

Return lRetorno
