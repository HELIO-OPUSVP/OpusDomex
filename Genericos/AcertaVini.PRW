#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACERTAVINI ºAutor  ³Helio Ferreira      º Data ³  04/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa criado para validar e/ou corrigir problemas no    º±±
±±º          ³ custo médio Domex.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AcertaVini()
Private lEnd := .F.

Processa({|lEnd| ProcRun()}, 'Conferindo dos Valores Iniciais das OPs...')

Return

Static Function ProcRun()

If Pergunte("ACERTACUS",.T.)
	MsgInfo("MV_ULMES = " + DtoC(GetMV("MV_ULMES")))
	
	MsgInfo("Data final do período para fechamento: " + DtoC(mv_par02) )
	
	// Primeira parte: Corrigindo as Ops com emissão anterior a 31/12/11
	
	cQuery := "SELECT COUNT(*) AS CONTA FROM " + RetSqlName("SC2") + " WHERE D_E_L_E_T_ = '' "
	//cQuery += "AND C2_NUM = '48039' "
	cQuery += "AND C2_EMISSAO >= '"+DtoS(mv_par01-365)+"' "
   //cQuery += "ORDER BY C2_EMISSAO "
	
	//cCount := StrTran(cQuery,"SELECT * FROM","SELECT COUNT(*) AS CONTA FROM")
	//cCount := StrTran(cCount,"ORDER BY C2_EMISSAO","")
	
	If Select("CONTAGEM") <> 0
		CONTAGEM->(dbCloseArea())
	EndIf
	
	TCQUERY cQuery NEW ALIAS "CONTAGEM"
	
	ProcRegua(CONTAGEM->CONTA)
	
	//If Select("OPS") <> 0
	//	OPS->( dbCloseArea() )
	//EndIf
	
	//TCQUERY cQuery NEW ALIAS "OPS"
	
   cQuery := "SELECT C2_NUM + C2_ITEM + C2_SEQUEN AS C2_OP, D3_CF, SUM(D3_CUSTO1) AS D3_CUSTO1, D3_EMISSAO "
	cQuery += "FROM SC2010 (NOLOCK), SD3010 (NOLOCK) WHERE SC2010.D_E_L_E_T_ = '' AND SD3010.D_E_L_E_T_ = ''"
	cQuery += "AND C2_EMISSAO >= '"+DtoS(mv_par01-365)+"'                                                   "
	//cQuery += "AND C2_NUM + C2_ITEM + C2_SEQUEN = '68558 01001'                                           "
	cQuery += "AND D3_EMISSAO < '"+DtoS(mv_par01)+"' AND D3_CF IN ('RE0','RE1','DE0','DE1','PR0','PR1')     "
	cQuery += "AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D3_ESTORNO = '' AND SD3010.D_E_L_E_T_ = ''          " 
	cQuery += "GROUP BY C2_EMISSAO, C2_NUM, C2_ITEM, C2_SEQUEN , D3_CF, D3_EMISSAO, D3_NUMSEQ, D3_CHAVE     "
	cQuery += "ORDER BY C2_EMISSAO DESC, C2_NUM, C2_ITEM, C2_SEQUEN, D3_EMISSAO, D3_NUMSEQ, D3_CHAVE        "

	TCQUERY cQuery NEW ALIAS "OPS"
	
	SC2->( dbSetOrder(1) )
	__cOP := ''
	
	While !OPS->( EOF() )
		If lEnd
		   If MsgYesNo("Deseja interromper o processamento?")
		      Exit
		   EndIf
		EndIf
		If SC2->( dbSeek( xFilial() + OPS->C2_OP ) )
			C2VINI1     := 0
			dD3_EMISSAO := CtoD('')
			__cOP       := OPS->C2_OP
			
			/*
			cQuery := "SELECT D3_CF, D3_CUSTO1, D3_EMISSAO FROM " + RetSqlName("SD3") + " WHERE D3_EMISSAO < '"+DtoS(mv_par01)+"' AND D3_CF IN ('RE0','RE1','DE0','DE1','PR0','PR1') AND D3_OP = '"+OPS->C2_NUM+OPS->C2_ITEM+OPS->C2_SEQUEN+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' ORDER BY D3_NUMSEQ, D3_CHAVE "
			
			If Select("VINI") <> 0
				VINI->( dbCloseArea() )
			EndIf
			
			TCQUERY cQuery NEW ALIAS "VINI"
			
			While !VINI->( EOF() )
				If VINI->D3_CF == 'RE0' .or. VINI->D3_CF == 'RE1'
					C2VINI1     += VINI->D3_CUSTO1
					dD3_EMISSAO := StoD(VINI->D3_EMISSAO)
				EndIf
				If VINI->D3_CF == 'DE0' .or. VINI->D3_CF == 'DE1'
					C2VINI1     -= VINI->D3_CUSTO1
					dD3_EMISSAO := StoD(VINI->D3_EMISSAO)
				EndIf
				If VINI->D3_CF == 'PR0' .or. VINI->D3_CF == 'PR1'
					C2VINI1     := 0
					dD3_EMISSAO := StoD(VINI->D3_EMISSAO)
				EndIf
				VINI->( dbSkip() )
			End
			*/
			
			While !OPS->( EOF() ) .and. __cOP == OPS->C2_OP
				If OPS->D3_CF == 'RE0' .or. OPS->D3_CF == 'RE1'
					C2VINI1     += OPS->D3_CUSTO1
					dD3_EMISSAO := StoD(OPS->D3_EMISSAO)
				EndIf
				If OPS->D3_CF == 'DE0' .or. OPS->D3_CF == 'DE1'
					C2VINI1     -= OPS->D3_CUSTO1
					dD3_EMISSAO := StoD(OPS->D3_EMISSAO)
				EndIf
				If OPS->D3_CF == 'PR0' .or. OPS->D3_CF == 'PR1'
					C2VINI1     := 0
					dD3_EMISSAO := StoD(OPS->D3_EMISSAO)
				EndIf
				OPS->( dbSkip() )
			End
			
			If SC2->C2_VINI1 <> C2VINI1
				If mv_par03 == 1
					If !msgYesNo('Valor INICIAL PARA apropriação errado para a OP: ' + OPS->C2_OP + Chr(13)+'Custo SC2->C2_VINI1: ' + Transform(SC2->C2_VINI1,'@E 999,999.99') + ' Custo SD3->D3_CUSTO1: ' + Transform(C2VINI1,'@E 999,999.99')+chr(13)+'Ultimo D3_EMISSAO: '+DtoC(dD3_EMISSAO)+Chr(13)+'Continuar exibindo?')
						mv_par03 := 2
					EndIf
				EndIf
				If mv_par04 == 1
					Reclock("SC2",.F.)
					SC2->C2_VINI1 := C2VINI1
					SC2->( msUnlock() )
				EndIf
			EndIf
		EndIf
		//OPS->( dbSkip() )
		IncProc()
	End
	
	Return
	
EndIf

Return
