#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT381LOK  �Autor  �Helio Ferreira       � Data �  12/16/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MT381LOK()
Local _Retorno := .T.
Local nPD4_COD     := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D4_COD" } )
Local nPD4_QTDEORI := aScan(aHeader, { |aVet| Alltrim(aVet[2]) == "D4_QTDEORI"} )

If ALTERA
	If aCols[N,Len(aHeader)+1]
		If !Empty(aCols[n,nPD4_COD])
//			lPgto := U_VerPgtoOp(SD4->D4_OP,aCols[n,nPD4_COD])		// Pegava o n�mero de Op desposicionada
			lPgto := U_VerPgtoOp(cOP       ,aCols[n,nPD4_COD])    // Inserido por Michel Sander em 08.01.2015 para buscar a vari�vel de mem�ria padr�o com o n�mero da OP 
			If !lPgto
				Aviso("Aten��o","Este empenho n�o pode ser exclu�do pois j� existe pagamento deste Produto do estoque para esta OP.",{"OK"} )
				_Retorno := .F.
			EndIf
		EndIf
	EndIf
EndIf

If ALTERA
	If aCols[n,nPD4_QTDEORI] == 0 
	    Aviso("Aten��o","A quantidade empenhada original n�o pode ser zerada.",{"OK"} )
		_Retorno := .F.
	EndIf	
EndIf

Return _Retorno

