#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VCMPSC6   �Autor  �Helio Ferreira      � Data �  17/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VcmpSC6()

/*
- Produto
- Quantidade
- Prc Unit�rio
- Cod.do Cli.
- Item PC/Cli.
- Pedido Clie.   *
- Mens.p/Nota
- Mens.p/Nota 2

Esses campos possuem informa��es essenciais referentes a todo o processo de venda do cliente.
O restante n�o teremos problemas. 

Luis Gleidson (Gleidson Pereira)
Patricia Paes (Patricia Paes)
*/

/* Comentado por Michel A. Sander em 15.05.2014 para evitar a congru�ncia de nome de usu�rio na compara��o da express�o contida no CNOTUSUA
// o Usuario KEROLINE PESTANA conflitava com a usuaria ANA por causa da congruencia da express�o
cNotUsua := ''
//cNotUsua += 'Keroline Pestana;'
cNotUsua += 'Wellington'

If Upper(Alltrim(Subs(cUsuario,7,14))) $ Upper(cNotUsua)
	MsgStop('Usu�rio sem permiss�o de altera��o deste campo.')
	_Retorno := .F.
Else
	_Retorno := .T.
EndIf
*/

// Inserido Por Michel A. Sander em 15/05/2014 para buscar corretamente o usu�rio sem permiss�o de altera��o em campos do SC6
// Caso seja necess�rio incluir mais usu�rio na proibi��o, utilizar nome do usuario de at� 14 caracteres
// Ex: Keroline Pestana = Keroline Pesta

_Retorno := .T.
//aNotUser := {}
//AADD(aNotUser, { PADR("Gleidson Perei",14), PADR("Patricia Paes",14), PADR("Vanessa Caio",14), PADR("Keroline Pesta",14),;
//					PADR("Wellington",14), PADR("Michel Sander",14) } )
//If ASCAN(aNotUser[1],SUBSTR(cUsuario,7,14)) > 0
//   MsgStop('Usu�rio sem permiss�o de altera��o nesse campo.')
//   _Retorno := .F.
//EndIf

Return _Retorno