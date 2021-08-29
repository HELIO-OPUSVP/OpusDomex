#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReTesInt  ºAutor  ³Marco Aurélio       º Data ³  06/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a TES segundo o cadastro personalizado de TES      º±±
±±º          ³ inteligente                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ReTesInt(_cOper,_cCliente,_cLojaCli,_cProduto,_cTipoCli)
Local _cTes   := "999"
Local _TESINT := {_cTes,.F.,"","",0} // TES, VALIDADA OU NÃO, PEDIDO, ITEM, REGRA 1 2 OU 3
Local aAreaGER := GetArea()
Local aAreaZFM := ZFM->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )

ZFM->( dbSetOrder(1) )
If ZFM->( dbSeek(xfilial("ZFM")+_cOper+_cCliente+_cLojaCli+_cTipoCli) )

	// Busca Produto
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek(xfilial("SB1")+_cProduto) )
		if SB1->B1_TIPO $ "PA/PI" .and. SB1->B1_XXDRBCK <> "S"
			if SB1->B1_XXPROIN $ "S"  
				_TESINT[1]	:= ZFM->ZFM_TES1	// PA c/ PPB
				
				If ZFM->ZFM_VALID1 == '1'
				   _TESINT[2] := .T. 
				   _TESINT[3] := ZFM->ZFM_PV1
				   _TESINT[4] := ZFM->ZFM_IT1
				   _TESINT[5] := 1
				Else
					_TESINT[2] := .F. 
				   _TESINT[3] := ""
				   _TESINT[4] := ""
				   _TESINT[5] := 1
				EndIf
			else
				_TESINT[1]	:= ZFM->ZFM_TES2  // PA s/ PPB
				
				If ZFM->ZFM_VALID2 == '1'
				   _TESINT[2] := .T. 
				   _TESINT[3] := ZFM->ZFM_PV2
				   _TESINT[4] := ZFM->ZFM_IT2
				   _TESINT[5] := 2
				Else
					_TESINT[2] := .F. 
				   _TESINT[3] := ""
				   _TESINT[4] := ""
				   _TESINT[5] := 2
				EndIf
			endif
		elseif SB1->B1_TIPO $ "PR" .and. SB1->B1_ORIGEM <>  "0" .and. SB1->B1_XXDRBCK <> "S"
				_TESINT[1]	:= ZFM->ZFM_TES3    // Produto de Revenda Importado
				
				If ZFM->ZFM_VALID3 == '1'
				   _TESINT[2] := .T. 
				   _TESINT[3] := ZFM->ZFM_PV3
				   _TESINT[4] := ZFM->ZFM_IT3
				   _TESINT[5] := 3
				Else
					_TESINT[2] := .F. 
				   _TESINT[3] := ""
				   _TESINT[4] := ""
				   _TESINT[5] := 3
				EndIf
		elseif SB1->B1_TIPO $ "PR" .and. SB1->B1_ORIGEM == "0" .and. alltrim(SB1->B1_POSIPI) $ ZFM->ZFM_NCM4 .and. SB1->B1_XXDRBCK <> "S"
				
				_TESINT[1]	:= ZFM->ZFM_TES4    // Produto de Revenda Nacional c/ST
				
				If ZFM->ZFM_VALID4 == '1'
				   _TESINT[2] := .T. 
				   _TESINT[3] := ZFM->ZFM_PV4
				   _TESINT[4] := ZFM->ZFM_IT4
				   _TESINT[5] := 4
				Else
					_TESINT[2] := .F. 
				   _TESINT[3] := ""
				   _TESINT[4] := ""
				   _TESINT[5] := 4
				EndIf      
				
		elseif SB1->B1_TIPO $ "PR" .and. SB1->B1_ORIGEM == "0" .and. alltrim(SB1->B1_POSIPI) $ ZFM->ZFM_NCM5 .and. SB1->B1_XXDRBCK <> "S"
				
				_TESINT[1]	:= ZFM->ZFM_TES5    // Produto de Revenda Nacional s/ST
				
				If ZFM->ZFM_VALID5 == '1'
				   _TESINT[2] := .T. 
				   _TESINT[3] := ZFM->ZFM_PV5
				   _TESINT[4] := ZFM->ZFM_IT5
				   _TESINT[5] := 5
				Else
					_TESINT[2] := .F. 
				   _TESINT[3] := ""
				   _TESINT[4] := ""
				   _TESINT[5] := 5
				EndIf

	  // Operacao 02 - Remessa para Obra
		elseif SB1->B1_TIPO $ "MS#ME#MP" .and. SB1->B1_XXDRBCK <> "S"
				
				_TESINT[1]	:= ZFM->ZFM_TES7    
				
				If ZFM->ZFM_VALID7 == '1'
				   _TESINT[2] := .T. 
				   _TESINT[3] := ZFM->ZFM_PV7
				   _TESINT[4] := ZFM->ZFM_IT7
				   _TESINT[5] := 5
				Else
					_TESINT[2] := .F. 
				   _TESINT[3] := ""
				   _TESINT[4] := ""
				   _TESINT[5] := 5
				EndIf



		//	Tratamento para DRAWBAK
		elseif  SB1->B1_XXDRBCK == "S"
				
				_TESINT[1]	:= ZFM->ZFM_TES6    // Produto de Revenda Nacional s/ST
				
				If ZFM->ZFM_VALID6 == '1'
				   _TESINT[2] := .T. 
				   _TESINT[3] := ZFM->ZFM_PV6
				   _TESINT[4] := ZFM->ZFM_IT6
				   _TESINT[5] := 5
				Else
					_TESINT[2] := .F. 
				   _TESINT[3] := ""
				   _TESINT[4] := ""
				   _TESINT[5] := 5
				EndIf


		else
				_TESINT[1]	:= _cTes			   	// Mantem TES informada no PV
		endif
	else
		_TESINT[1]	:= _cTes			   			// Mantem TES informada no PV		
	endif
Endif

RestArea(aAreaZFM)
RestArea(aAreaSB1)
RestArea(aAreaGER)

Return _TESINT



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReTClas   ºAutor  ³Marco Aurélio       º Data ³  24/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a CCLASSIFICACAO de TES                            º±±
±±º          ³ inteligente                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ReTClass(_cProduto,_cTesPV)

Local aAreaGER := GetArea()
Local aAreaZFM := ZFM->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )

	// Busca Produto // TES
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek(xfilial("SB1")+_cProduto) )
	SF4->( dbSetOrder(1) )	
	SF4->( dbSeek(xfilial("SF4")+_cTesPV) ) 
	
	_cClass := SB1->B1_ORIGEM + SF4->F4_SITTRIB
	
RestArea(aAreaZFM)
RestArea(aAreaSB1)
RestArea(aAreaGER)

Return _cClass
