#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA416COR  �Autor  �Marco Aurelio       � Data �  02/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Adiciona bot�o no browse de Or�amentos de Vendas           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MA416COR()
		
			
Local aCores := {	{ 'SCJ->CJ_STATUS=="A" .and. SCJ->CJ_XSTATUS==" " ' , 'ENABLE' },; 	//Orcamento em Aberto
	{ 'SCJ->CJ_STATUS=="B" .and. SCJ->CJ_XSTATUS==" " ' , 'DISABLE'},;					//Orcamento Baixado
	{ 'SCJ->CJ_STATUS=="C" .and. SCJ->CJ_XSTATUS==" " ' , 'BR_PRETO'},;					//Orcamento Cancelado
	{ 'SCJ->CJ_STATUS=="D" .and. SCJ->CJ_XSTATUS==" " ' , 'BR_AMARELO'},;				//Orcamento nao Orcado
	{ 'SCJ->CJ_STATUS=="X" .and. SCJ->CJ_XSTATUS==" " ' , 'BR_AZUL'},;					//Orcamento bloqueado por margem
	{ 'SCJ->CJ_STATUS$"A/B/C/D/X/F" .and. SCJ->CJ_XSTATUS=="B"' , 'BR_BRANCO'},;		//B= Aguardando Autorizacao CC	//MAS-OPUS
	{ 'SCJ->CJ_STATUS$"A/B/C/D/X/F" .and. SCJ->CJ_XSTATUS=="A"' , 'BR_LARANJA'},;  		//A= Aguardando Aprovacao Diretor//MAS-OPUS
	{ 'SCJ->CJ_STATUS$"A/B/C/D/X/F" .and. SCJ->CJ_XSTATUS=="C"' , 'BR_VIOLETA'},;		//C= Cartao Autorizado	//MAS-OPUS		
	{ 'SCJ->CJ_STATUS=="F" .and. SCJ->CJ_XSTATUS==" " ' , 'BR_MARROM' }}				//Orcamento bloqueado
			
			

Return(aCores)