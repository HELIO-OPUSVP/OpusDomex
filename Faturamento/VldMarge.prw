
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDMARGE  �Autor  �Osmar Ferreira      � Data �  05/10/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a margem de lucro do pedido de venda                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VldMarge()
	Local aCusto := {}
	Local cProdVenda := ""
	Local x := 0

	For x := 1 To Len(aCols)
		nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
		cProdVenda := aCols[x,nPC6_PRODUTO]

		aCusto    := U_RetCust(cProdVenda,'N')
		nCusMedio := aCusto[1]
		cStatus   := aCusto[2]
        Alert(M->C5_NUM+"      "+cProdVenda)
		Alert(nCusMedio)
		//Alert(cStatus)

	Next x

Return(Nil)






