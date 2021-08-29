#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VD3_LOCAL()ºAutor  ³Helio Ferreira     º Data ³  09/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VD3_LOCAL()
Local _Retorno  := .T.
Local cD3_LOCAL := ""
Local aAreaGER  := GetArea()
Local aAreaSC2  := SC2->( GetArea() )

//If FunName() == "MATA260"
//   cD3_LOCAL := cLocOrig //:= cLocDest
//EndIf

If _Retorno
	If FunName() == "MATA240"  // Movimentos internos mod 1
		cD3_LOCAL := M->D3_LOCAL
		//		If cD3_LOCAL == GetMV("MV_XXLOCPR")   // Local de Processos Domex
		If cD3_LOCAL == GetMV("MV_XXLOCPR")
			If Upper(Subs(cUsuario,7,5)) <> 'HELIO' .AND. Upper(Subs(cUsuario,7,5)) <> 'DENIS' .AND. Upper(Subs(cUsuario,7,7)) <> 'LUCIANO'
				MsgStop("Não é permitido fazer movimentações internas no almox " + GetMV("MV_XXLOCPR")+".")
				_Retorno  := .F.
			ENDIF
		EndIf
	EndIf
EndIf

If _Retorno
	If FunName() == "MATA241"  // Movimentos internos mod 2
		cD3_LOCAL := M->D3_LOCAL
		//		If cD3_LOCAL == GetMV("MV_XXLOCPR")   // Local de Processos Domex
		If cD3_LOCAL == GetMV("MV_XXLOCPR")
			If Upper(Subs(cUsuario,7,5)) <> 'HELIO' .AND. Upper(Subs(cUsuario,7,5)) <> 'DENIS' .AND. Upper(Subs(cUsuario,7,7)) <> 'LUCIANO'
				MsgStop("Não é permitido fazer movimentações internas no almox " + GetMV("MV_XXLOCPR")+".")
				_Retorno  := .F.
			ENDIF
		EndIf
	EndIf
EndIf

If _Retorno
	If FunName() == "MATA260"  // Trasnferência mod 1
		cD3_LOCAL := cLocOrig         // M->D3_LOCAL
		//		If cD3_LOCAL == GetMV("MV_XXLOCPR")   // Local de Processos Domex
		If cD3_LOCAL == GetMV("MV_XXLOCPR")
			If Upper(Subs(cUsuario,7,5)) <> 'HELIO' .AND. Upper(Subs(cUsuario,7,5)) <> 'DENIS' .AND. Upper(Subs(cUsuario,7,7)) <> 'LUCIANO'
				MsgStop("Não é permitido fazer movimentações internas no almox " + GetMV("MV_XXLOCPR")+".")
				_Retorno  := .F.
			ENDIF
		EndIf
	EndIf
EndIf

If _Retorno
	If FunName() == "MATA261"  // Transferencia mod 2
		cD3_LOCAL := M->D3_LOCAL
		If cD3_LOCAL == GetMV("MV_XXLOCPR")   // Local de Processos Domex
			If Upper(Subs(cUsuario,7,5)) <> 'HELIO' .AND. Upper(Subs(cUsuario,7,5)) <> 'DENIS' .AND. Upper(Subs(cUsuario,7,5)) <> 'LUCIANO'
				MsgStop("Não é permitido fazer movimentações internas no almox " + GetMV("MV_XXLOCPR")+".")
				_Retorno  := .F.
			ENDIF
		EndIf
	EndIf
EndIf

If _Retorno
	If FunName() == "MATA250"  // Apontamentos de Produção
		If !Empty(M->D3_OP)
			SC2->( dbSetOrder(1) )
			If SC2->( dbSeek( xFilial() + Subs(M->D3_OP,1,11) ) )
				If SC2->C2_LOCAL <> M->D3_LOCAL
					If Upper(Subs(cUsuario,7,5)) <> 'HELIO' .AND. Upper(Subs(cUsuario,7,5)) <> 'DENIS'
						MsgStop("Armazem diferente do definido na abertura da Ordem de Produção.")
						_Retorno := .F.
					ENDIF
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

If Upper(Subs(cUsuario,7,5)) == 'HELIO' .OR. Upper(Subs(cUsuario,7,5)) == 'DENIS'
	_Retorno  := .T.
ENDIF

RestArea(aAreaSC2)
RestArea(aAreaGER)

Return _Retorno

