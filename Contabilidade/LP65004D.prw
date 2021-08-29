#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP65004D     ºAutor  ³HELIO FERREIRA   º Data ³  08/06/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Usado para retorno da conta Debido to LP 650 seq 004       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP65004D()

Local _Retorno := "FALTA_CONTA"

If SF4->F4_ESTOQUE = 'S'
	If SB1->B1_TIPO == 'FP'
		_Retorno :=  '110309000000'
	EndIf
	
	If SB1->B1_TIPO == 'MA'
		_Retorno :=  '110312000000'
	EndIf
	
	If SB1->B1_TIPO == 'MC'
		_Retorno :=  '110303000000'
	EndIf
	
	If SB1->B1_TIPO == 'ME'
		_Retorno :=  '110310000000'
	EndIf
	
	If SB1->B1_TIPO == 'MP'
		_Retorno :=  '110301000000'
	EndIf
	
	If SB1->B1_TIPO == 'MS'
		_Retorno :=  '110302000000'
	EndIf
	
	If SB1->B1_TIPO == 'PA'
		_Retorno :=  '110307000000'
	EndIf
	
	If SB1->B1_TIPO == 'PI'
		_Retorno :=  '110307000000'
	EndIf
	
	If SB1->B1_TIPO == 'PR'
		_Retorno :=  '110311000000'
	EndIf
Else
	If SB1->B1_TIPO == 'FP'
		_Retorno :=  '110309000000'
	EndIf
	
	If SB1->B1_TIPO == 'MA'
		_Retorno :=  '110312000000'
	EndIf
	
	If SB1->B1_TIPO == 'MC'
		_Retorno :=  '110303000000'
	EndIf
	
	If SB1->B1_TIPO == 'ME'
		_Retorno :=  '110310000000'
	EndIf
	
	If SB1->B1_TIPO == 'MP'
		_Retorno :=  '110301000000'
	EndIf
	
	If SB1->B1_TIPO == 'MS'
		_Retorno :=  '110302000000'
	EndIf
	
	If SB1->B1_TIPO == 'PA'
		_Retorno :=  '110307000000'
	EndIf
	
	If SB1->B1_TIPO == 'PI'
		_Retorno :=  '110307000000'
	EndIf
	
	If SB1->B1_TIPO == 'PR'
		_Retorno :=  '110311000000'
	EndIf
EndIf

Return _Retorno
