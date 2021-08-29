#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120ISC  �Autor  �Marco Aurelio-OPUS  � Data �  28/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega as informacoes da Solicitacao de Compras           ���
���          � para o pedido de compras.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120ISC                  

Local nPosOPER  	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C7_XOPER"})      //Operacao (Tes INteligente)

	//aCols[n][nPosOPER]  		:= SC1->C1_XOPER	      //Operacao (Tes INteligente)

	// MAURESI - 23/11/2020  - Adicionada valida��o para preencher o campo Opera��o
	aCols[n][nPosOPER]  		:= iif(empty(Alltrim(SC1->C1_XOPER)),"01",	SC1->C1_XOPER)      //Operacao (Tes INteligente)

Return()
