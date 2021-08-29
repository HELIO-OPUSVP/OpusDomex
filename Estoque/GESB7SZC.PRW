#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeSB7SZC  ºAutor  ³Helio Ferreira      º Data ³  26/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera SB7 a partir de peças Domex coletadas no SZC          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GESB7SZC()
Local cPerg := "GESB7SZC"

cTexto := "Este programa tem como objetivo processar o arquivo de Peças Domex coletadas no inventário (SZC) "
cTexto += "e gerar os registros de inventário na tabela padrão de inventário (SB7). Também irá gerar registros "
cTexto += "com quantidade zero para os produtos/locais que não tiveram peças coletadas. "+ Chr(13) + Chr(10) + Chr(13) + Chr(10)

BatchProcess("Processa coleta de Inventário Geral - GESB7SZC.prw",cTexto,cPerg,{ || Processa({|lEnd| ProcRun() },OemToAnsi("Acessando Peças coletadas"),OemToAnsi("Gerando Inventário..."),.F.)})

Return

Static Function ProcRun()
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private nContagem   := 0
Private bkpmv_01    := mv_par01
Private bkpmv_02    := mv_par02
Private bkpmv_03    := mv_par03
Private bkpmv_04    := mv_par04
Private bkpmv_05    := mv_par05
Private bkpmv_06    := mv_par06
Private bkpmv_07    := mv_par07
Private bkpmv_08    := mv_par08
Private lGeraSZC    := .T.
Private lMostrErro  := .T.

SB7->( dbSetOrder(1) ) //B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+B7_CONTAGE

cQuery := "SELECT * FROM " + RetSqlName("SB7") + " (NOLOCK) "

cQuery += "WHERE B7_FILIAL = '01' AND B7_DATA = '"+DtoS(mv_par01)+"' "
cQuery += "AND B7_COD >= '"+mv_par03+"' AND B7_COD <= '"+mv_par04+"' AND B7_LOCAL >= '"+mv_par05+"' AND B7_LOCAL <= '"+mv_par06+"' "
cQuery += "AND D_E_L_E_T_ = '' "

If Select("QUERYSB7") <> 0
	QUERYSB7->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSB7"

If !QUERYSB7->( EOF() )
	If MsgYesNo("Já existe inventário conforme parâmetros selecionados. Deseja apagar?")
		cUpdate := "UPDATE "+RetSqlName("SB7")+" SET D_E_L_E_T_ = '*' "
		cUpdate += "WHERE B7_FILIAL = '01' AND B7_DATA = '"+DtoS(mv_par01)+"' "
		cUpdate += "AND B7_COD >= '"+mv_par03+"' AND B7_COD <= '"+mv_par04+"' AND B7_LOCAL >= '"+mv_par05+"' AND B7_LOCAL <= '"+mv_par06+"' "
		cUpdate += "AND D_E_L_E_T_ = '' "
		
		TCSQLEXEC(cUpdate)
		
		MsgInfo("Inventário (SB7) apagado.")
	Else
		lGeraSZC := .F.
	EndIf
EndIf

cQuery := "SELECT D3_COD, D3_LOCAL FROM " + RetSqlName("SD3") + " (NOLOCK) "

cQuery += "WHERE D3_FILIAL = '01' AND D3_EMISSAO = '"+DtoS(mv_par01)+"' "
cQuery += "AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
cQuery += "AND D3_DOC = 'INVENT' AND D_E_L_E_T_ = '' AND D3_ESTORNO = '' GROUP BY D3_COD, D3_LOCAL "

If Select("QUERYSD3") <> 0
	QUERYSD3->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSD3"

If !QUERYSD3->( EOF() )
	If MsgYesNo("Já existe inventário PROCESSADO conforme parâmetros selecionados (SD3/SD5/SDB). Deseja apagar?")
		cUpdate := "UPDATE "+RetSqlName("SD3")+" SET D_E_L_E_T_ = '*' "
		cUpdate += "WHERE D3_FILIAL = '01' AND D3_EMISSAO = '"+DtoS(mv_par01)+"' "
		cUpdate += "AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
		cUpdate += "AND D3_DOC = 'INVENT' AND D_E_L_E_T_ = '' "
		TCSQLEXEC(cUpdate)
		
		cUpdate := "UPDATE "+RetSqlName("SD5")+" SET D_E_L_E_T_ = '*' "
		cUpdate += "WHERE D5_FILIAL = '01' AND D5_DATA = '"+DtoS(mv_par01)+"' "
		cUpdate += "AND D5_PRODUTO >= '"+mv_par03+"' AND D5_PRODUTO <= '"+mv_par04+"' AND D5_LOCAL >= '"+mv_par05+"' AND D5_LOCAL <= '"+mv_par06+"' "
		cUpdate += "AND D5_DOC = 'INVENT' AND D_E_L_E_T_ = '' "
		TCSQLEXEC(cUpdate)
		
		cUpdate := "UPDATE "+RetSqlName("SDB")+" SET D_E_L_E_T_ = '*' "
		cUpdate += "WHERE DB_FILIAL = '01' AND DB_DATA = '"+DtoS(mv_par01)+"' "
		cUpdate += "AND DB_PRODUTO >= '"+mv_par03+"' AND DB_PRODUTO <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
		cUpdate += "AND D3_DOC = 'INVENT' AND D_E_L_E_T_ = '' "
		TCSQLEXEC(cUpdate)
		
		While !QUERYSD3->( EOF() )
			UMATA300(QUERYSD3->D3_COD,QUERYSD3->D3_COD,QUERYSD3->D3_LOCAL,QUERYSD3->D3_LOCAL)
			QUERYSD3->( dbSkip() )
		End
		MsgInfo("Processamento do inventário (SD3/SD5/SDB) apagados e Saldo atual recalculado.")
	EndIf
EndIf

If mv_par08 == 1 // em uso 2014 // .and. .f. // Inventário por produto (SZC)
	cQuery := "SELECT ZC_PRODUTO, ZC_LOCAL, MAX(ZC_CONTAGE) AS ZC_CONTAGE FROM " + RetSqlName("SZC") + " "
	cQuery += "WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' "
	cQuery += "AND ZC_PRODUTO >= '"+mv_par03+"' AND ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "GROUP BY ZC_PRODUTO, ZC_LOCAL "
	cQuery += "ORDER BY ZC_PRODUTO, ZC_LOCAL "
	
	If Select("SZCPRODLOC") <> 0
		SZCPRODLOC->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "SZCPRODLOC"
	
	While !SZCPRODLOC->( EOF() )
		nContagem += 1
		SZCPRODLOC->( dbSkip() )
	End
	
	SZCPRODLOC->( dbGoTop() )
	
	ProcRegua(nContagem)
	
	While !SZCPRODLOC->( EOF() )
		
		VoltaMVs()
		
		cQuery := "SELECT ZC_PRODUTO, ZC_LOCAL, SUM(ZC_QUANT) AS ZC_QUANT, ZC_DATAINV, ZC_LOTECTL, ZC_LOCALIZ FROM " + RetSqlName("SZC") + " "
		cQuery += "WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' "
		cQuery += "AND ZC_PRODUTO >= '"+mv_par03+"' AND ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D_E_L_E_T_ = '' AND ZC_PRODUTO = '"+SZCPRODLOC->ZC_PRODUTO+"' AND ZC_LOCAL = '"+SZCPRODLOC->ZC_LOCAL+"' AND ZC_CONTAGE = '"+SZCPRODLOC->ZC_CONTAGE+"' "
		cQuery += "GROUP BY ZC_PRODUTO, ZC_LOCAL, ZC_DATAINV, ZC_LOTECTL, ZC_LOCALIZ "
		cQuery += "ORDER BY ZC_DATAINV, ZC_PRODUTO, ZC_LOCAL, ZC_LOTECTL, ZC_LOCALIZ "
		
		If Select("QUERYSZC") <> 0
			QUERYSZC->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSZC"
		
		// B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+B7_CONTAGE
		While !QUERYSZC->( EOF() )
			If SB1->( dbSeek( xFilial() + QUERYSZC->ZC_PRODUTO ) )
				If !SB7->( dbSeek( xFilial() + QUERYSZC->ZC_DATAINV + QUERYSZC->ZC_PRODUTO + QUERYSZC->ZC_LOCAL + QUERYSZC->ZC_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + QUERYSZC->ZC_LOTECTL ) )
					_aInvent := {}
					Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")             ,Nil})
					Aadd(_aInvent,{"B7_COD"     ,QUERYSZC->ZC_PRODUTO       ,Nil})
					Aadd(_aInvent,{"B7_LOCAL"   ,QUERYSZC->ZC_LOCAL         ,Nil})
					Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO               ,Nil})
					Aadd(_aInvent,{"B7_DOC"     ,"INVENT"                   ,Nil})
					Aadd(_aInvent,{"B7_QUANT"   ,QUERYSZC->ZC_QUANT         ,Nil})
					Aadd(_aInvent,{"B7_DATA"    ,StoD(QUERYSZC->ZC_DATAINV) ,Nil})
					Aadd(_aInvent,{"B7_LOTECTL" ,QUERYSZC->ZC_LOTECTL       ,Nil})
					Aadd(_aInvent,{"B7_DTVALID" ,StoD('20491231')           ,Nil})
					Aadd(_aInvent,{"B7_LOCALIZ" ,QUERYSZC->ZC_LOCALIZ       ,Nil})
					//Aadd(_aInvent,{"B7_XXPECA"  ,QUERYSZC->ZC_XXPECA      ,Nil})
					
					lMsErroAuto := .F.
					nModulo     := 4
					
					aAreaSB1    := SB1->( GetArea() )
					cB1_MSBLQL  := SB1->B1_MSBLQL
					
					If SB1->B1_MSBLQL == '1'
						Reclock("SB1",.F.)
						SB1->B1_MSBLQL := '2'
						SB1->( msUnlock() )
					EndIf
					
					MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
					
					RestArea(aAreaSB1)
					
					If SB1->B1_MSBLQL <> cB1_MSBLQL
						Reclock("SB1",.F.)
						SB1->B1_MSBLQL := cB1_MSBLQL
						SB1->( msUnlock() )
					EndIf
					
					If lMsErroAuto
						If lMostrErro
							MostraErro()
							If MsgYesNo("Deseja continuar?")
								MsgStop("Produto SZC = " + QUERYSZC->ZC_PRODUTO)
							Else
								Return
							EndIf
						EndIf
					EndIf
				Else
					If SB7->B7_QUANT <> QUERYSZC->ZC_QUANT
						Reclock("SB7",.F.)
						SB7->B7_QUANT := QUERYSZC->ZC_QUANT
						SB7->( msUnlock() )
						//MsgStop("Quantidade do SB7 diferente da inventariada.")
					EndIf
				EndIf
			Else
				MsgStop("Produto inventariado (SZC) " + QUERYSZC->ZC_PRODUTO + " não encontrado no SB1")
			EndIf
			
			QUERYSZC->( dbSkip() )
		End
		SZCPRODLOC->( dbSkip() )
		IncProc()
	End
EndIf

If mv_par08 == 2  // inventário por etiqueta
	// Não está preparado para gerar SB7 somente para a ultima contagem. Arrumar!!!
	
	cQuery := "SELECT * FROM " + RetSqlName("SZC") + " "
	cQuery += "WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' "
	cQuery += "AND ZC_PRODUTO >= '"+mv_par03+"' AND ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	
	If Select("QUERYSZC") <> 0
		QUERYSZC->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSZC"
	
	While !QUERYSZC->( EOF() )
		nContagem += 1
		QUERYSZC->( dbSkip() )
	End
	
	QUERYSZC->( dbGoTop() )
	
	
	While !QUERYSZC->( EOF() )
		
		If SB1->( dbSeek( xFilial() + QUERYSZC->ZC_PRODUTO ) )
			
			If !SB7->( dbSeek( xFilial() + QUERYSZC->ZC_DATAINV + QUERYSZC->ZC_PRODUTO + QUERYSZC->ZC_LOCAL + QUERYSZC->ZC_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + QUERYSZC->ZC_LOTECTL ) )
				
				_aInvent := {}
				Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")             ,Nil})
				Aadd(_aInvent,{"B7_COD"     ,QUERYSZC->ZC_PRODUTO       ,Nil})
				Aadd(_aInvent,{"B7_LOCAL"   ,QUERYSZC->ZC_LOCAL         ,Nil})
				Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO               ,Nil})
				Aadd(_aInvent,{"B7_DOC"     ,"INVENT"                   ,Nil})
				Aadd(_aInvent,{"B7_QUANT"   ,QUERYSZC->ZC_QUANT         ,Nil})
				Aadd(_aInvent,{"B7_DATA"    ,StoD(QUERYSZC->ZC_DATAINV) ,Nil})
				Aadd(_aInvent,{"B7_LOTECTL" ,QUERYSZC->ZC_LOTECTL       ,Nil})
				Aadd(_aInvent,{"B7_DTVALID" ,StoD('20491231')           ,Nil})
				Aadd(_aInvent,{"B7_LOCALIZ" ,QUERYSZC->ZC_LOCALIZ       ,Nil})
				Aadd(_aInvent,{"B7_XXPECA"  ,QUERYSZC->ZC_XXPECA        ,Nil})
				
				lMsErroAuto := .F.
				nModulo     := 4
				
				aAreaSB1    := SB1->( GetArea() )
				cB1_MSBLQL  := SB1->B1_MSBLQL
				
				If SB1->B1_MSBLQL == '1'
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := '2'
					SB1->( msUnlock() )
				EndIf
				
				MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
				
				RestArea(aAreaSB1)
				
				If SB1->B1_MSBLQL <> cB1_MSBLQL
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := cB1_MSBLQL
					SB1->( msUnlock() )
				EndIf
				
				If lMsErroAuto
					If lMostrErro
						MostraErro()
						If MsgYesNo("Deseja continuar?")
							MsgStop("recno SZC = " + Str(QUERYSZC->R_E_C_N_O_))
						Else
							Return
						EndIf
					EndIf
				EndIf
			Else
				If SB7->B7_QUANT <> QUERYSZC->ZC_QUANT
					Reclock("SB7",.F.)
					SB7->B7_QUANT := QUERYSZC->ZC_QUANT
					SB7->( msUnlock() )
					//MsgStop("Quantidade do SB7 diferente da inventariada.")
				EndIf
			EndIf
		Else
			MsgStop("Produto inventariado (SZC) " + QUERYSZC->ZC_PRODUTO + " não encontrado no SB1")
		EndIf
		
		QUERYSZC->( dbSkip() )
		IncProc()
	End
EndIf


VoltaMVs()

If mv_par07 == 1  // zerar endereços somente dos produtos coletados
	cQuery := "SELECT BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, "+RetSqlName("SBF")+".R_E_C_N_O_ FROM " + RetSqlName("SBF") + ", " + RetSqlName("SB1") + " WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND BF_PRODUTO IN "
	cQuery += " ( "
	cQuery += "SELECT ZC_PRODUTO FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND ZC_DATAINV = '"+DtoS(mv_par01)+"' AND ZC_PRODUTO >= '"+mv_par03+"' AND ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' AND D_E_L_E_T_ = '' GROUP BY ZC_PRODUTO "
	cQuery += " ) "
	cQuery += "AND B1_COD = BF_PRODUTO AND B1_MSBLQL <> '1' AND BF_PRODUTO >= '"+mv_par03+"' AND BF_PRODUTO <= '"+mv_par04+"' AND BF_LOCAL >= '"+mv_par05+"' AND BF_LOCAL <= '"+mv_par06+"' AND "+RetSqlName("SBF")+".D_E_L_E_T_ = '' AND "+RetSqlName("SB1")+".D_E_L_E_T_ = '' "
	
	If Select("QUERYSBF") <> 0
		QUERYSBF->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSBF"
	While !QUERYSBF->( EOF() )
		nContagem += 1
		QUERYSBF->( dbSkip() )
	End
	QUERYSBF->( dbGoTop() )
	
	ProcRegua(nContagem)
	
	While !QUERYSBF->( EOF() )
		//If SBE->( dbSeek( xFilial() + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ ) )
		//If SBE->BE_STATUS <> '3'
		VoltaMVs()
		
		cQuery := "SELECT TOP 1 R_E_C_N_O_ FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND "
		cQuery += "ZC_PRODUTO = '"+QUERYSBF->BF_PRODUTO+"' AND ZC_LOCAL = '"+QUERYSBF->BF_LOCAL+"' AND "
		cQuery += "ZC_LOCALIZ = '"+QUERYSBF->BF_LOCALIZ+"' AND ZC_LOTECTL = '"+QUERYSBF->BF_LOTECTL+"' AND "
		cQuery += "ZC_DATAINV = '"+DtoS(mv_par01)+"' AND D_E_L_E_T_ = '' "
		
		If Select("QUERYSZC") <> 0
			QUERYSZC->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSZC"
		
		If QUERYSZC->( EOF() )
			If SB1->( dbSeek( xFilial() + QUERYSBF->BF_PRODUTO ) )
				If !SB7->( dbSeek( xFilial() + DtoS(mv_par11) + QUERYSBF->BF_PRODUTO + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + QUERYSBF->BF_LOTECTL ) )
					_aInvent := {}
					Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")          ,Nil})
					Aadd(_aInvent,{"B7_COD"     ,QUERYSBF->BF_PRODUTO    ,Nil})
					Aadd(_aInvent,{"B7_LOCAL"   ,QUERYSBF->BF_LOCAL      ,Nil})
					//Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO          ,Nil})
					Aadd(_aInvent,{"B7_DOC"     ,"INVENT"                ,Nil})
					Aadd(_aInvent,{"B7_QUANT"   ,0                       ,Nil})
					Aadd(_aInvent,{"B7_DATA"    ,mv_par11                ,Nil})
					Aadd(_aInvent,{"B7_LOTECTL" ,QUERYSBF->BF_LOTECTL    ,Nil})
					Aadd(_aInvent,{"B7_DTVALID" ,StoD('20491231')        ,Nil})
					Aadd(_aInvent,{"B7_LOCALIZ" ,QUERYSBF->BF_LOCALIZ    ,Nil})
					//Aadd(_aInvent,{"B7_XXPECA"  ,                      ,Nil})
					
					lMsErroAuto := .F.
					nModulo     := 4
					
					aAreaSB1    := SB1->( GetArea() )
					cB1_MSBLQL  := SB1->B1_MSBLQL
					
					If SB1->B1_MSBLQL == '1'
						Reclock("SB1",.F.)
						SB1->B1_MSBLQL := '2'
						SB1->( msUnlock() )
					EndIf
					
					MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
					
					RestArea(aAreaSB1)
					
					If SB1->B1_MSBLQL <> cB1_MSBLQL
						Reclock("SB1",.F.)
						SB1->B1_MSBLQL := cB1_MSBLQL
						SB1->( msUnlock() )
					EndIf
					
					If lMsErroAuto
						If lMostrErro
							MostraErro()
							If MsgYesNo("Deseja continuar?")
								MsgStop("recno SBF = " + Str(QUERYSBF->R_E_C_N_O_) + ' produto ' + QUERYSBF->BF_PRODUTO )
							Else
								Return
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		//EndIf
		//Else
		
		//EndIf
		QUERYSBF->( dbSkip() )
		IncProc("Zerando endereços/lotes não inventariados.")
	End
	
EndIf

VoltaMVs()

If mv_par07 == 2
	// zerando os endereços almoxarifados coletados
	cQuery := "SELECT BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, "+RetSqlName("SBF")+".R_E_C_N_O_ FROM " + RetSqlName("SBF") + ", "+RetSqlName("SB1") + " "
	cQuery += "WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND BF_PRODUTO+BF_LOCAL IN "
	cQuery += " ( "
	cQuery += "SELECT ZC_PRODUTO+ZC_LOCAL FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND ZC_DATAINV = '"+DtoS(mv_par01)+"' "
	cQuery += "AND ZC_PRODUTO >= '"+mv_par03+"' AND ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' "
	cQuery += "AND ZC_LOCAL <= '"+mv_par06+"' AND D_E_L_E_T_ = '' "
	cQuery += " ) "
	cQuery += "AND B1_COD = BF_PRODUTO AND BF_PRODUTO >= '"+mv_par03+"' AND BF_PRODUTO <= '"+mv_par04+"' AND BF_LOCAL >= '"+mv_par05+"' AND BF_LOCAL <= '"+mv_par06+"' AND "+RetSqlName("SBF")+".D_E_L_E_T_ = '' AND "+RetSqlName("SB1")+".D_E_L_E_T_ = '' "
	
	If Select("QUERYSBF") <> 0
		QUERYSBF->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSBF"
	While !QUERYSBF->( EOF() )
		nContagem += 1
		QUERYSBF->( dbSkip() )
	End
	QUERYSBF->( dbGoTop() )
	
	ProcRegua(nContagem)
	
	While !QUERYSBF->( EOF() ) // .and. .f.
		
		//If SBE->( dbSeek( xFilial() + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ ) )
		//If SBE->BE_STATUS <> '3'
		VoltaMVs()
		
		cQuery := "SELECT MAX(ZC_CONTAGE) AS MAXCONT FROM " + RetSqlName("SZC") + " "
		cQuery += "WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' "
		cQuery += "AND ZC_PRODUTO = '"+QUERYSBF->BF_PRODUTO+"' AND ZC_LOCAL = '"+QUERYSBF->BF_LOCAL+"' "
		cQuery += "AND D_E_L_E_T_ = '' "
		
		If Select("MAXCONT") <> 0
			MAXCONT->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "MAXCONT"
		
		cQuery := "SELECT TOP 1 R_E_C_N_O_ FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND "
		cQuery += "ZC_PRODUTO = '"+QUERYSBF->BF_PRODUTO+"' AND ZC_LOCAL = '"+QUERYSBF->BF_LOCAL+"' AND "
		cQuery += "ZC_LOCALIZ = '"+QUERYSBF->BF_LOCALIZ+"' AND ZC_LOTECTL = '"+QUERYSBF->BF_LOTECTL+"' AND "
		cQuery += "ZC_DATAINV = '"+DtoS(mv_par01)+"' AND ZC_CONTAGE = '"+MAXCONT->MAXCONT+"' AND D_E_L_E_T_ = '' "
		
		If Select("QUERYSZC") <> 0
			QUERYSZC->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSZC"
		
		If QUERYSZC->( EOF() )
			If SB1->( dbSeek( xFilial() + QUERYSBF->BF_PRODUTO ) )
				If !SB7->( dbSeek( xFilial() + DtoS(mv_par01) + QUERYSBF->BF_PRODUTO + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + QUERYSBF->BF_LOTECTL ) )
					
					_aInvent := {}
					Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")          ,Nil})
					Aadd(_aInvent,{"B7_COD"     ,QUERYSBF->BF_PRODUTO    ,Nil})
					Aadd(_aInvent,{"B7_LOCAL"   ,QUERYSBF->BF_LOCAL      ,Nil})
					//Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO          ,Nil})
					Aadd(_aInvent,{"B7_DOC"     ,"INVENT"                ,Nil})
					Aadd(_aInvent,{"B7_QUANT"   ,0                       ,Nil})
					Aadd(_aInvent,{"B7_DATA"    ,mv_par01                ,Nil})
					Aadd(_aInvent,{"B7_LOTECTL" ,QUERYSBF->BF_LOTECTL    ,Nil})
					Aadd(_aInvent,{"B7_DTVALID" ,StoD('20491231')        ,Nil})
					Aadd(_aInvent,{"B7_LOCALIZ" ,QUERYSBF->BF_LOCALIZ    ,Nil})
					//Aadd(_aInvent,{"B7_XXPECA"  ,                      ,Nil})
					
					lMsErroAuto := .F.
					nModulo     := 4
					
					aAreaSB1    := SB1->( GetArea() )
					cB1_MSBLQL  := SB1->B1_MSBLQL
					
					If SB1->B1_MSBLQL == '1'
						Reclock("SB1",.F.)
						SB1->B1_MSBLQL := '2'
						SB1->( msUnlock() )
					EndIf
					
					MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
					
					RestArea(aAreaSB1)
					
					If SB1->B1_MSBLQL <> cB1_MSBLQL
						Reclock("SB1",.F.)
						SB1->B1_MSBLQL := cB1_MSBLQL
						SB1->( msUnlock() )
					EndIf
					
					If lMsErroAuto
						If lMostrErro
							MostraErro()
							If MsgYesNo("Deseja continuar?")
								MsgStop("recno SBF = " + Str(QUERYSBF->R_E_C_N_O_) + ' produto ' + QUERYSBF->BF_PRODUTO )
							Else
								Return
							EndIf
						EndIf
					EndIf
				Else
					If SB7->B7_QUANT <> 0
						Reclock("SB7",.F.)
						SB7->B7_QUANT := 0
						SB7->( msUnlock() )
						//MsgStop("Quantidade do SB7 diferente da inventariada.")
					EndIf
				EndIf
			EndIf
		EndIf
		//Else
		
		//EndIf
		QUERYSBF->( dbSkip() )
		IncProc("Zerando endereços vazios de produtos inventariados.")
	End
	
	
	VoltaMVs()
	
	// Fazendo a conta para inventariar dos produtos não coletados no inventário
	
	cQuery := "SELECT BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, "+RetSqlName("SBF")+".R_E_C_N_O_ FROM " + RetSqlName("SBF") + ", "
	cQuery += RetSqlName("SB1") + " WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cQuery += "BF_PRODUTO+BF_LOCAL NOT IN "
	cQuery += " ( "
	cQuery += "SELECT ZC_PRODUTO+ZC_LOCAL FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND "
	cQuery += "ZC_DATAINV = '"+DtoS(mv_par01)+"' AND ZC_PRODUTO >= '"+mv_par03+"' AND "
	cQuery += "ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' AND ZC_LOCAL <= '"+mv_par06+"' AND D_E_L_E_T_ = '' "
	cQuery += " ) "
	cQuery += "AND B1_COD = BF_PRODUTO AND B1_MSBLQL <> '1' AND BF_PRODUTO >= '"+mv_par03+"' AND BF_PRODUTO <= '"+mv_par04+"' AND "
	cQuery += "BF_LOCAL >= '"+mv_par05+"' AND BF_LOCAL <= '"+mv_par06+"' AND "+RetSqlName("SBF")+".D_E_L_E_T_ = '' AND "+RetSqlName("SB1")+".D_E_L_E_T_ = '' ORDER BY BF_PRODUTO, BF_LOCAL"
	
	If Select("QUERYSBF") <> 0
		QUERYSBF->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSBF"
	While !QUERYSBF->( EOF() )
		nContagem += 1
		QUERYSBF->( dbSkip() )
	End
	QUERYSBF->( dbGoTop() )
	
	ProcRegua(nContagem)
	
	While !QUERYSBF->( EOF() )
		//If SBE->( dbSeek( xFilial() + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ ) )
		//If SBE->BE_STATUS <> '3'
		VoltaMVs()
		
		cQuery := "SELECT SUM(DB_QUANT) AS SOMAS FROM " + RetSqlName("SDB") + " WHERE DB_FILIAL = '"+xFilial("SZC")+"' AND "
		cQuery += "DB_PRODUTO = '"+QUERYSBF->BF_PRODUTO+"' AND DB_LOCAL = '"+QUERYSBF->BF_LOCAL+"' AND "
		cQuery += "DB_LOCALIZ = '"+QUERYSBF->BF_LOCALIZ+"' AND DB_LOTECTL = '"+QUERYSBF->BF_LOTECTL+"' AND "
		cQuery += "DB_DATA >= '"+DtoS(mv_par09)+"' AND DB_DATA <= '"+DtoS(mv_par10)+"' AND "
		cQuery += "DB_TM > '500' AND DB_ESTORNO = '' AND D_E_L_E_T_ = '' "
		
		If Select("QUERYSDBS") <> 0
			QUERYSDBS->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSDBS"
		
		cQuery := "SELECT SUM(DB_QUANT) AS SOMAE FROM " + RetSqlName("SDB") + " WHERE DB_FILIAL = '"+xFilial("SZC")+"' AND "
		cQuery += "DB_PRODUTO = '"+QUERYSBF->BF_PRODUTO+"' AND DB_LOCAL = '"+QUERYSBF->BF_LOCAL+"' AND "
		cQuery += "DB_LOCALIZ = '"+QUERYSBF->BF_LOCALIZ+"' AND DB_LOTECTL = '"+QUERYSBF->BF_LOTECTL+"' AND "
		cQuery += "DB_DATA >= '"+DtoS(mv_par09)+"' AND DB_DATA <= '"+DtoS(mv_par10)+"' AND "
		cQuery += "DB_TM <= '500' AND DB_ESTORNO = '' AND D_E_L_E_T_ = '' "
		
		If Select("QUERYSDBE") <> 0
			QUERYSDBE->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSDBE"
		
		If SB1->( dbSeek( xFilial() + QUERYSBF->BF_PRODUTO ) )
			If !SB7->( dbSeek( xFilial() + DtoS(mv_par11) + QUERYSBF->BF_PRODUTO + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + QUERYSBF->BF_LOTECTL ) )
				//If QUERYSZC->( EOF() )
				_aInvent := {}
				Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")                       ,Nil})
				Aadd(_aInvent,{"B7_COD"     ,QUERYSBF->BF_PRODUTO                 ,Nil})
				Aadd(_aInvent,{"B7_LOCAL"   ,QUERYSBF->BF_LOCAL                   ,Nil})
				//Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO                       ,Nil})
				Aadd(_aInvent,{"B7_DOC"     ,"INVCAL"                             ,Nil})
				
				If QUERYSDBS->SOMAS >= QUERYSDBE->SOMAE
					Aadd(_aInvent,{"B7_QUANT"   ,QUERYSDBS->SOMAS-QUERYSDBE->SOMAE ,Nil})
				Else
					Aadd(_aInvent,{"B7_QUANT"   ,0                                 ,Nil})
				EndIf
				
				If (QUERYSDBS->SOMAS-QUERYSDBE->SOMAE) <> 0
					_n := 1
				EndIf
				
				Aadd(_aInvent,{"B7_DATA"    ,mv_par11                             ,Nil})
				Aadd(_aInvent,{"B7_LOTECTL" ,QUERYSBF->BF_LOTECTL                 ,Nil})
				Aadd(_aInvent,{"B7_DTVALID" ,StoD('20491231')                     ,Nil})
				Aadd(_aInvent,{"B7_LOCALIZ" ,QUERYSBF->BF_LOCALIZ                 ,Nil})
				//Aadd(_aInvent,{"B7_XXPECA"  ,                                   ,Nil})
				
				SB2->( dbSeek( xFilial() + QUERYSBF->BF_PRODUTO + QUERYSBF->BF_LOCAL ) )
				
				cB2STATUS := SB2->B2_STATUS
				
				If SB2->B2_STATUS == '2'
					Reclock("SB2",.F.)
					SB2->B2_STATUS := '1'
					SB2->( msUnlock() )
				EndIf
				
				lMsErroAuto := .F.
				nModulo     := 4
				
				aAreaSB1    := SB1->( GetArea() )
				cB1_MSBLQL  := SB1->B1_MSBLQL
				
				If SB1->B1_MSBLQL == '1'
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := '2'
					SB1->( msUnlock() )
				EndIf
				
				MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
				
				RestArea(aAreaSB1)
				
				If SB1->B1_MSBLQL <> cB1_MSBLQL
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := cB1_MSBLQL
					SB1->( msUnlock() )
				EndIf
				
				If SB2->B2_STATUS <> cB2STATUS
					Reclock("SB2",.F.)
					SB2->B2_STATUS := cB2STATUS
					SB2->( msUnlock() )
				EndIf
				
				If lMsErroAuto
					If lMostrErro
						MostraErro()
						If MsgYesNo("Deseja continuar?")
							MsgStop("recno SBF = " + Str(QUERYSBF->R_E_C_N_O_) + ' produto ' + QUERYSBF->BF_PRODUTO )
						Else
							Return
						EndIf
					EndIf
				EndIf
			Else
				If SB7->B7_QUANT <> 0
					Reclock("SB7",.F.)
					SB7->B7_QUANT := 0
					SB7->( msUnlock() )
					//MsgStop("Quantidade do SB7 diferente da inventariada.")
				EndIf
			EndIf
		EndIf
		//EndIf
		//Else
		
		//EndIf
		QUERYSBF->( dbSkip() )
		IncProc("Calculando o saldo de prod não coletados.")
	End
EndIf


If mv_par07 == 4
	// zerando os endereços almoxarifados coletados
	cQuery := "SELECT BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, "+RetSqlName("SBF")+".R_E_C_N_O_ FROM " + RetSqlName("SBF") + ", "+RetSqlName("SB1") + " "
	cQuery += "WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND BF_LOCAL IN "
	cQuery += " ( "
	cQuery += "SELECT ZC_LOCAL FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND ZC_DATAINV = '"+DtoS(mv_par01)+"' "
	cQuery += "AND ZC_PRODUTO >= '"+mv_par03+"' AND ZC_PRODUTO <= '"+mv_par04+"' AND ZC_LOCAL >= '"+mv_par05+"' "
	cQuery += "AND ZC_LOCAL <= '"+mv_par06+"' AND D_E_L_E_T_ = '' GROUP BY ZC_LOCAL "
	cQuery += " ) "
	cQuery += "AND B1_COD = BF_PRODUTO AND BF_PRODUTO >= '"+mv_par03+"' AND BF_PRODUTO <= '"+mv_par04+"' "
	cQuery += "AND BF_LOCAL >= '"+mv_par05+"' AND BF_LOCAL <= '"+mv_par06+"' AND "+RetSqlName("SBF")+".D_E_L_E_T_ = '' AND "+RetSqlName("SB1")+".D_E_L_E_T_ = '' "
	
	If Select("QUERYSBF") <> 0
		QUERYSBF->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSBF"
	While !QUERYSBF->( EOF() )
		nContagem += 1
		QUERYSBF->( dbSkip() )
	End
	QUERYSBF->( dbGoTop() )
	
	ProcRegua(nContagem)
	
	While !QUERYSBF->( EOF() ) // .and. .f.
		//If SBE->( dbSeek( xFilial() + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ ) )
		//If SBE->BE_STATUS <> '3'
		VoltaMVs()
		
		cQuery := "SELECT MAX(ZC_CONTAGE) AS MAXCONT FROM " + RetSqlName("SZC") + " "
		cQuery += "WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' "
		cQuery += "AND ZC_PRODUTO = '"+QUERYSBF->BF_PRODUTO+"' AND ZC_LOCAL = '"+QUERYSBF->BF_LOCAL+"' "
		cQuery += "AND D_E_L_E_T_ = '' "
		
		If Select("MAXCONT") <> 0
			MAXCONT->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "MAXCONT"
		
		cQuery := "SELECT TOP 1 R_E_C_N_O_ FROM " + RetSqlName("SZC") + " WHERE ZC_FILIAL = '"+xFilial("SZC")+"' AND "
		cQuery += "ZC_PRODUTO = '"+QUERYSBF->BF_PRODUTO+"' AND ZC_LOCAL = '"+QUERYSBF->BF_LOCAL+"' AND "
		cQuery += "ZC_LOCALIZ = '"+QUERYSBF->BF_LOCALIZ+"' AND ZC_LOTECTL = '"+QUERYSBF->BF_LOTECTL+"' AND "
		cQuery += "ZC_DATAINV = '"+DtoS(mv_par01)+"' AND ZC_CONTAGE = '"+MAXCONT->MAXCONT+"' AND D_E_L_E_T_ = '' "
		
		If Select("QUERYSZC") <> 0
			QUERYSZC->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSZC"
		
		If QUERYSZC->( EOF() )
			If SB1->( dbSeek( xFilial() + QUERYSBF->BF_PRODUTO ) )
				//If !SB7->( dbSeek( xFilial() + DtoS(mv_par01) + QUERYSBF->BF_PRODUTO + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + QUERYSBF->BF_LOTECTL ) )
				
				_aInvent := {}
				Aadd(_aInvent,{"B7_FILIAL"  ,xFilial("SB7")          ,Nil})
				Aadd(_aInvent,{"B7_COD"     ,QUERYSBF->BF_PRODUTO    ,Nil})
				Aadd(_aInvent,{"B7_LOCAL"   ,QUERYSBF->BF_LOCAL      ,Nil})
				//Aadd(_aInvent,{"B7_TIPO"    ,SB1->B1_TIPO          ,Nil})
				Aadd(_aInvent,{"B7_DOC"     ,"INVENT"                ,Nil})
				Aadd(_aInvent,{"B7_QUANT"   ,0                       ,Nil})
				Aadd(_aInvent,{"B7_DATA"    ,mv_par01                ,Nil})
				Aadd(_aInvent,{"B7_LOTECTL" ,QUERYSBF->BF_LOTECTL    ,Nil})
				Aadd(_aInvent,{"B7_DTVALID" ,StoD('20491231')        ,Nil})
				Aadd(_aInvent,{"B7_LOCALIZ" ,QUERYSBF->BF_LOCALIZ    ,Nil})
				//Aadd(_aInvent,{"B7_XXPECA"  ,                      ,Nil})
				
				lMsErroAuto := .F.
				nModulo     := 4
				
				aAreaSB1    := SB1->( GetArea() )
				cB1_MSBLQL  := SB1->B1_MSBLQL
				
				If SB1->B1_MSBLQL == '1'
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := '2'
					SB1->( msUnlock() )
				EndIf
				
				MSExecAuto({|x,y| Mata270(x,y)},_aInvent,.F.,3) //3-Inclusao //5-Exclusao
				
				RestArea(aAreaSB1)
				
				If SB1->B1_MSBLQL <> cB1_MSBLQL
					Reclock("SB1",.F.)
					SB1->B1_MSBLQL := cB1_MSBLQL
					SB1->( msUnlock() )
				EndIf
				
				If lMsErroAuto
					If lMostrErro
						MostraErro()
						If MsgYesNo("Deseja continuar?")
							MsgStop("recno SBF = " + Str(QUERYSBF->R_E_C_N_O_) + ' produto ' + QUERYSBF->BF_PRODUTO )
						Else
							Return
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		//EndIf
		//Else
		
		//EndIf
		QUERYSBF->( dbSkip() )
		IncProc("Zerando endereços vazios de produtos inventariados.")
	End
	
	VoltaMVs()
	
EndIf

SBE->( dbSetOrder(1) )

Return

Static Function VoltaMVs()

mv_par01 := bkpmv_01
mv_par02 := bkpmv_02
mv_par03 := bkpmv_03
mv_par04 := bkpmv_04
mv_par05 := bkpmv_05
mv_par06 := bkpmv_06
mv_par07 := bkpmv_07
mv_par08 := bkpmv_08

Return
