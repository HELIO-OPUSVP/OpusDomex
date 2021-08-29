#include "Totvs.ch"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M461TRV   �Autor  �H�lio Ferreira/Jo�o Cozer�Data� 09/10/17 ���
�������������������������������������������������������������������������͹��
���Desc.     � A finalidade do ponto de entrada M461TRV � destravar o LOCK���
���          � da tabela "SB2 - Saldos F�sico e Financeiro" no momento da ���
���          � gera��o do Documento de Sa�da.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function M461TRV()

// http://tdn.totvs.com/display/public/PROT/M461TRV+-+Libera+a+trava+dos+registros+da+tabela+SB2

Local aSaveArea	:= GetArea()
RestArea(aSaveArea)

Return .F.