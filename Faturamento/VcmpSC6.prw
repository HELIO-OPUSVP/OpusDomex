#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VCMPSC6   ºAutor  ³Helio Ferreira      º Data ³  17/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VcmpSC6()

/*
- Produto
- Quantidade
- Prc Unitário
- Cod.do Cli.
- Item PC/Cli.
- Pedido Clie.   *
- Mens.p/Nota
- Mens.p/Nota 2

Esses campos possuem informações essenciais referentes a todo o processo de venda do cliente.
O restante não teremos problemas. 

Luis Gleidson (Gleidson Pereira)
Patricia Paes (Patricia Paes)
*/

/* Comentado por Michel A. Sander em 15.05.2014 para evitar a congruência de nome de usuário na comparação da expressão contida no CNOTUSUA
// o Usuario KEROLINE PESTANA conflitava com a usuaria ANA por causa da congruencia da expressão
cNotUsua := ''
//cNotUsua += 'Keroline Pestana;'
cNotUsua += 'Wellington'

If Upper(Alltrim(Subs(cUsuario,7,14))) $ Upper(cNotUsua)
	MsgStop('Usuário sem permissão de alteração deste campo.')
	_Retorno := .F.
Else
	_Retorno := .T.
EndIf
*/

// Inserido Por Michel A. Sander em 15/05/2014 para buscar corretamente o usuário sem permissão de alteração em campos do SC6
// Caso seja necessário incluir mais usuário na proibição, utilizar nome do usuario de até 14 caracteres
// Ex: Keroline Pestana = Keroline Pesta

_Retorno := .T.
//aNotUser := {}
//AADD(aNotUser, { PADR("Gleidson Perei",14), PADR("Patricia Paes",14), PADR("Vanessa Caio",14), PADR("Keroline Pesta",14),;
//					PADR("Wellington",14), PADR("Michel Sander",14) } )
//If ASCAN(aNotUser[1],SUBSTR(cUsuario,7,14)) > 0
//   MsgStop('Usuário sem permissão de alteração nesse campo.')
//   _Retorno := .F.
//EndIf

Return _Retorno