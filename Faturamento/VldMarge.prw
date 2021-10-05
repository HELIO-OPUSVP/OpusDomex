


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
Local cCodigo := ""
Local x 

nPC6_PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )

Alert(aCols[N,nPC6_PRODUTO])



Return(Nil)
