#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GC6_FATUR  �Autor  �Helio Ferreira    � Data �  06/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho criado para preencher o campo C6_XXDTDEF caso a dt ���
���          � de entrega tenha sido firmada com o Cliente.               ���
�������������������������������������������������������������������������͹��
���Uso       � SigaFat                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function GC6_DTFATUR()  // Tratado

Local _Retorno     := M->C6_DTFATUR  // Tratado
Local nPC6_XXDTDEF := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XXDTDEF" } )
Local nPC6_DTFATUR := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_DTFATUR" } )  // Tratado
Local nPC6_ENTRE   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ENTREG"  } )  // Tratado   - Data Cliente
Local nPC6_ENTR3   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ENTRE3"  } )  // Tratado   - Data PCP
/*


If !GetMV("MV_XXINVDT")  // tratado na segunda invers�o
	If !Empty(aCols[n,nPC6_ENTR3])  // Tratado
		If Empty(aCols[N,nPC6_XXDTDEF])
			If MsgYesNo('A data de Faturamento ' + DtoC(aCols[n,nPC6_ENTR3]) + ' � a acordada com o Cliente?')  // Tratado
				aCols[n,nPC6_XXDTDEF] := aCols[n,nPC6_ENTR3]  // Tratado
				apMsgInfo('Data de primeira negocia��o de Faturamento com o Cliente firmada em ' + DtoC(aCols[n,nPC6_XXDTDEF])+'.')
			EndIf
		EndIf
	Else
		apMsgStop('Antes de informar a data de Entrega, favor invormar a data de Faturamento.')
		_Retorno := CtoD('')
	EndIf
Else
	If !Empty(aCols[n,nPC6_ENTRE])  // Tratado
		If Empty(aCols[N,nPC6_XXDTDEF])
			If MsgYesNo('A data de Faturamento ' + DtoC(aCols[n,nPC6_ENTRE]) + ' � a acordada com o Cliente?')  // Tratado
				aCols[n,nPC6_XXDTDEF] := aCols[n,nPC6_ENTRE]  // Tratado
				apMsgInfo('Data de primeira negocia��o de Faturamento com o Cliente firmada em ' + DtoC(aCols[n,nPC6_XXDTDEF])+'.')
			EndIf
		EndIf
	Else
		apMsgStop('Antes de informar a data de Entrega, favor invormar a data de Faturamento.')
		_Retorno := CtoD('')
	EndIf
EndIf
*/
If Empty(aCols[n,nPC6_XXDTDEF])
// DESABILITADO Por MAURESI em 31/05/2019
//	aCols[n,nPC6_XXDTDEF] := aCols[n,nPC6_ENTR3]
EndIf
//aCols[n,nPC6_XXDTDEF] := aCols[n,nPC6_ENTRE]


Return _Retorno
