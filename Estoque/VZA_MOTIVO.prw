#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VZA_MOTIVO �Autor  �Helio Ferreira     � Data �  05/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo ZA_MOTIVO (motivo de perda)             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VZA_MOTIVO()
Local _Retorno := .T.

If !Empty(M->ZA_MOTIVO)
	//Ajustado para validar a digita��o da quanitade na tela de perda.
	if IsInCallStack("U_DOMPERDA")
		nPosProd := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_PRODUTO" } )
		nPosOP 	 := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_OP" } )
		nPosSaldo := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_SALDO" } )
		nPosDescr := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_DESCPER" } )
		nPosMovit := aScan( aHeader, {|x| Alltrim(x[2]) == "ZA_MOTIVO" } )
		M->ZA_PRODUTO := oGetdados:aCols[oGetdados:nAt][nPosProd]	
		M->ZA_OP 	  := oGetdados:aCols[oGetdados:nAt][nPosOP]
		M->ZA_SALDO   := oGetdados:aCols[oGetdados:nAt][nPosSaldo]
		//M->ZA_MOTIVO  := oGetdados:aCols[oGetdados:nAt][nPosMovit]
	EndIf
	If !Empty(M->ZA_PRODUTO)
		M->ZA_DESCPER := Tabela("43",M->ZA_MOTIVO)
		iF IsInCallStack("U_DOMPERDA")
			oGetdados:aCols[oGetdados:nAt][nPosDescr] := M->ZA_DESCPER
			M->ZA_MOTIVO := SX5->X5_CHAVE
			oGetdados:aCols[oGetdados:nAt][nPosMovit] := M->ZA_MOTIVO 
		EndIf
		If Empty(Alltrim(M->ZA_DESCPER))
			MsgStop("Motivo de Perda Informado n�o encontrado")
			M->ZA_MOTIVO := SPACE(6)		
			_Retorno := .F.
		EndIf
	Else
		MsgStop("Favor preencher o produto antes do motivo da perda.")
		_Retorno := .F.
	EndIf
Else
	M->ZA_DESCPER := Space(Len(M->ZA_DESCPER))
EndIf

Return _Retorno
