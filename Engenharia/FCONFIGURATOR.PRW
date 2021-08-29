#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FCONF01   ºAutor  ³Helio Ferreira      º Data ³  05/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Configurator 001 - Retorna a metragem do BS_DESPRD  º±±
±±º          ³ em valor                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FCONF01(cFamilia,cItem,cConteudo)
Local _Retorno := ""
Local aAreaGER := GetArea()
Local aAreaSBS := SBS->( GetArea() )

cFamilia  := cFamilia  + Space(Len(SBS->BS_BASE)   - Len(cFamilia)  )
cItem     := cItem     + Space(Len(SBS->BS_ID)     - Len(cItem)     )
cConteudo := cConteudo + Space(Len(SBS->BS_CODIGO) - Len(cConteudo) )

SBS->( dbSetOrder(1) )
If SBS->( dbSeek( xFilial() + cFamilia + cItem + cConteudo ) )
	
	
	_Retorno := StrTran(SBS->BS_DESCPRD,"#","")
	_Retorno := StrTran(SBS->BS_DESCPRD,"M","")
	_Retorno := StrTran(SBS->BS_DESCPRD,",",".")
	_Retorno := Val(_Retorno)
	
EndIf

RestArea(aAreaSBS)
RestArea(aAreaGER)

Return _Retorno
