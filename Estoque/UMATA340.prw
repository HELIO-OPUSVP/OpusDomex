#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UMATA340  ºAutor  ³Helio Ferreira      º Data ³  27/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa substituído no menu na chamada da rotina de acertoº±±
±±º          ³ de inventários MATA340()                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UMATA340()

MATA340()

Pergunte("MTA340",.F.)

cQuery := "SELECT TOP 1 R_E_C_N_O_ FROM " + RetSqlName("SZC") + " WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' AND ZC_PRODUTO >= '"+mv_par05+"' AND ZC_PRODUTO <= '"+mv_par06+"' AND ZC_LOCAL >= '"+mv_par07+"' AND ZC_LOCAL <= '"+mv_par08+"' AND D_E_L_E_T_ = '' "

If Select("QUERYSZC") <> 0
	QUERYSZC->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZC"

If !QUERYSZC->( EOF() )
	If MsgYesNo("Existem Peças Domex de inventário coletadas para estes parametros. Deseja corrigir estas etiquetas conforme as Peças coletadas?")
		
		Processa(Procrun())
		
		MsgInfo("Processamento concluído. Peças (etiquetas) corrigidas.")
	EndIf
EndIf

Return


Static Function Procrun()

//cQuery := "UPDATE "+RetSqlName("XD1")+" SET XD1_QTDATU = 0, XD1_OCORRE = '5' FROM "+RetSqlName("XD1")+" WHERE XD1_COD + XD1_LOCAL IN "
//cQuery += "(SELECT ZC_PRODUTO + ZC_LOCAL FROM "+RetSqlName("SZC")+" WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' AND "
//cQuery += "ZC_PRODUTO >= '"+mv_par05+"' AND ZC_PRODUTO <= '"+mv_par06+"' AND ZC_LOCAL >= '"+mv_par07+"' AND ZC_LOCAL <= '"+mv_par08+"' AND "
//cQuery += "D_E_L_E_T_ = '' GROUP BY ZC_PRODUTO, ZC_LOCAL) AND D_E_L_E_T_ = '' "

//TCSQLEXEC(cQuery)  // Zerando todas as Peças

// Selectionando produtos/local inventariados
cQuery := "SELECT ZC_PRODUTO, ZC_LOCAL, MAX(ZC_CONTAGE) AS ZC_CONTAGE FROM " + RetSqlName("SZC") + " "
cQuery += "WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' AND "
cQuery += "ZC_PRODUTO >= '"+mv_par05+"' AND ZC_PRODUTO <= '"+mv_par06+"' AND ZC_LOCAL >= '"+mv_par07+"' AND ZC_LOCAL <= '"+mv_par08+"' "
cQuery += "AND D_E_L_E_T_ = '' "
cQuery += "GROUP BY ZC_PRODUTO, ZC_LOCAL "
cQuery += "ORDER BY ZC_PRODUTO, ZC_LOCAL "

If Select("SZCPRODLOC") <> 0
	SZCPRODLOC->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "SZCPRODLOC"

nContagem := 0
While !SZCPRODLOC->( EOF() )  // produtos inventariados
	nContagem += 1
	SZCPRODLOC->( dbSkip() )
End

SZCPRODLOC->( dbGoTop() )

ProcRegua(nContagem)

While !SZCPRODLOC->( EOF() )  // Produtos inventariados
	
	cQuery := "SELECT * FROM " + RetSqlName("SZC") + " "
	cQuery += "WHERE ZC_DATAINV = '"+DtoS(mv_par01)+"' "
	cQuery += "AND ZC_PRODUTO = '"+SZCPRODLOC->ZC_PRODUTO+"' AND ZC_LOCAL = '"+SZCPRODLOC->ZC_LOCAL+"' AND ZC_CONTAGE = '"+SZCPRODLOC->ZC_CONTAGE+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZC_LOTECTL, ZC_LOCALIZ "
	
	If Select("QUERYSZC") <> 0
		QUERYSZC->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSZC"
	
	If !QUERYSZC->( EOF() )
		cQuery := "UPDATE "+RetSqlName("XD1")+" SET XD1_QTDATU = 0, XD1_OCORRE = '5' FROM "+RetSqlName("XD1")+" WHERE "
		cQuery += "XD1_COD = '"+QUERYSZC->ZC_PRODUTO+"' AND XD1_LOCAL = '"+QUERYSZC->ZC_LOCAL+"' AND XD1_QTDATU <> 0 AND D_E_L_E_T_ = '' "
		
		TCSQLEXEC(cQuery)  // Zerando todas as Peças
		
		While !QUERYSZC->( EOF() )
			If SB1->( dbSeek( xFilial() + QUERYSZC->ZC_PRODUTO ) )
				If XD1->( dbSeek( xFilial() + QUERYSZC->ZC_XXPECA ) )
					Reclock("XD1",.F.)
					XD1->XD1_LOCALI := QUERYSZC->ZC_LOCALIZ
					XD1->XD1_LOCAL  := QUERYSZC->ZC_LOCAL
					XD1->XD1_QTDATU := QUERYSZC->ZC_QUANT
					XD1->XD1_OCORRE := '4'
					XD1->( msUnlock() )
				Else
					MsgStop("Peça " + QUERYSZC->ZC_XXPECA + " inventariada não encontrada na tabela de peças XD1.")
				EndIf
			Else
				MsgStop("Produto inventariado (SZC) " + QUERYSZC->ZC_PRODUTO + " não encontrado no SB1")
			EndIf
			
			QUERYSZC->( dbSkip() )
		End
	EndIf
	
	SZCPRODLOC->( dbSkip() )
	IncProc()
End

Return
