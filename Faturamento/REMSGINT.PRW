#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReMsgInt  ºAutor  ³Marco Aurélio       º Data ³  18/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a Mensagem para TES Inteligente                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ReMsgInt(_cOper,_cCliente,_cLojaCli,_cProduto,_cTipoCli)
Local _cTes   := "999"
Local _TESINT := {_cTes,.F.,"","",0} // TES, VALIDADA OU NÃO, PEDIDO, ITEM, REGRA 1 2 OU 3
Local aAreaGER := GetArea()
Local aAreaZFM := ZFM->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )
Local _MsgInt  := ""

ZFM->( dbSetOrder(1) )
If ZFM->( dbSeek(xfilial("ZFM")+_cOper+_cCliente+_cLojaCli+_cTipoCli) )

	// Busca Produto
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek(xfilial("SB1")+_cProduto) )
		if SB1->B1_TIPO $ "PA"
			if SB1->B1_XXPROIN $ "S"
				_MsgInt	+=  iif(empty(ZFM->ZFM_MSG101),""," " + Alltrim(ZFM->(Formula(ZFM_MSG101))))  +  iif(empty(ZFM->ZFM_MSG102),""," " + Alltrim(ZFM->(Formula(ZFM_MSG102))))
			else
				_MsgInt	+=  iif(empty(ZFM->ZFM_MSG201),""," " + Alltrim(ZFM->(Formula(ZFM_MSG201))))  +  iif(empty(ZFM->ZFM_MSG202),""," " + Alltrim(ZFM->(Formula(ZFM_MSG202))))
			endif 
			
		elseif SB1->B1_TIPO $ "PR" .and. SB1->B1_ORIGEM <>  "0"
				_MsgInt	+=  iif(empty(ZFM->ZFM_MSG301),""," " + Alltrim(ZFM->(Formula(ZFM_MSG301))))  +  iif(empty(ZFM->ZFM_MSG302),""," " + Alltrim(ZFM->(Formula(ZFM_MSG302))))
				
		elseif SB1->B1_TIPO $ "PR" .and. SB1->B1_ORIGEM == "0" .and. alltrim(SB1->B1_POSIPI) $ ZFM->ZFM_NCM4
				_MsgInt	+=  iif(empty(ZFM->ZFM_MSG401),""," " + Alltrim(ZFM->(Formula(ZFM_MSG401))))  +  iif(empty(ZFM->ZFM_MSG402),""," " + Alltrim(ZFM->(Formula(ZFM_MSG402))))
				
		elseif SB1->B1_TIPO $ "PR" .and. SB1->B1_ORIGEM == "0" .and. alltrim(SB1->B1_POSIPI) $ ZFM->ZFM_NCM5
				_MsgInt	+=  iif(empty(ZFM->ZFM_MSG501),""," " + Alltrim(ZFM->(Formula(ZFM_MSG501))))  +  iif(empty(ZFM->ZFM_MSG502),""," " + Alltrim(ZFM->(Formula(ZFM_MSG502))))

		else
				_MsgInt	+=  ""
		endif
	
		/*
		// 16/11/2020  - Adiciona Msg do Cadastro do Produto -   Chamado #   // MAURESI 019581
		_cMsgB1 := Alltrim(SB1->(Formula(B1_MENPAD)))
		if !( _cMsgB1 $ _MsgInt)
			_MsgInt += alltrim(_cMsgB1)
		endif

       */
		//
	
	
	else
		_MsgInt	+=  ""
	endif
Endif

RestArea(aAreaZFM)
RestArea(aAreaSB1)
RestArea(aAreaGER)

Return Alltrim(_MsgInt)
