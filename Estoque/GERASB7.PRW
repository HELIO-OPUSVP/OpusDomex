#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERSB7    ºAutor  ³Helio Ferreira      º Data ³  15/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função genérica de geração de Inventário                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GERASB7(cAlmox)

Local aVetor        := {}
Local aAreaSB2      := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Private nQtd        := 0
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private lMSHelpAuto := .T.  // Para mostrar os erro na tela
Private lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro é que deu erro

Default cAlmox      := ""
Private cAlmoxarif  := cAlmox

SB1->(dbSetOrder(1))
SBF->(dbSetOrder(1))
SB7->(dbSetOrder(1))  // B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+B7_CONTAGE


If !MsgNoYes("Favor confirmar Filial e Data Base"+chr(13)+'Filial corrente: ' + cFilAnt+CHR(13)+'Database:        ' + DtoC(dDatabase) )
	MsgInfo("Processamento cancelado.")
	Return
EndIf

If MsgYesNo("Deseja rodar a rotina de Refaz Saldo Atual para todos os produtos (recomendado)?")
	MsgRun("Processando Saldo Atual de todos Produtos...","Favor Aguardar.....",{|| UMATA300() })
	
	If MsgYesNo("Reprocessamento dos saldos concluído."+chr(13)+"Deseja iniciar a geração do Registro de Inventário (SB7) com quantidade zero para todos os produtos que não tiverem inventário lançado na data de " + DtoC(dDataBase) + "?")
		Processa({|| procinv() })
	EndIf
Else
	If MsgYesNo("Deseja iniciar a geração do Registro de Inventário (SB7) com quantidade zero para todos os produtos que não tiverem inventário lançado na data de " + DtoC(dDataBase) + "?")
		Processa({|| procinv() })
	EndIf
EndIf

MsgAlert('Fim da geração dos registros com quantidade '+Alltrim(Str(nQtd))+' para todos produtos.')

Return


Static Function ProcInv()

nRecnos := 0

cCOUNT1 := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SB2") + " SB2, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ <> 'S' AND B1_RASTRO <> 'L' AND B2_COD = B1_COD AND B2_FILIAL = '"+xFilial("SB2")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SB2.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cCOUNT1 += " AND B2_LOCAL = '"+cAlmoxarif+"' "
EndIf
cCOUNT2 := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SB8") + " SB8, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ <> 'S' AND B1_RASTRO =  'L' AND B8_PRODUTO = B1_COD AND B8_FILIAL = '"+xFilial("SB8")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SB8.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cCOUNT2 += " AND B8_LOCAL = '"+cAlmoxarif+"' "
EndIf
cCOUNT3 := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SBF") + " SBF, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ =  'S' AND B1_RASTRO <> 'L' AND BF_PRODUTO = B1_COD AND BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SBF.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cCOUNT3 += " AND BF_LOCAL = '"+cAlmoxarif+"' "
EndIf
cCOUNT4 := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SBF") + " SBF, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ =  'S' AND B1_RASTRO = 'L' AND BF_PRODUTO = B1_COD AND BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SBF.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cCOUNT4 += " AND BF_LOCAL = '"+cAlmoxarif+"' "
EndIf

If Select("CONTAGEM") <> 0
	CONTAGEM->( dbCloseArea() )
EndIf

TCQUERY cCOUNT1 NEW ALIAS "CONTAGEM"
nRecnos += CONTAGEM->CONTAGEM

If Select("CONTAGEM") <> 0
	CONTAGEM->( dbCloseArea() )
EndIf

TCQUERY cCOUNT2 NEW ALIAS "CONTAGEM"
nRecnos += CONTAGEM->CONTAGEM

If Select("CONTAGEM") <> 0
	CONTAGEM->( dbCloseArea() )
EndIf

TCQUERY cCOUNT3 NEW ALIAS "CONTAGEM"
nRecnos += CONTAGEM->CONTAGEM

If Select("CONTAGEM") <> 0
	CONTAGEM->( dbCloseArea() )
EndIf

TCQUERY cCOUNT4 NEW ALIAS "CONTAGEM"
nRecnos += CONTAGEM->CONTAGEM

ProcRegua(nRecnos)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄVÄ¿
//³                                    SB2                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery1 := "SELECT B2_COD, B2_LOCAL  FROM " + RetSqlName("SB2") + " SB2, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ <> 'S' AND B1_RASTRO <> 'L' AND B2_COD = B1_COD AND B2_FILIAL = '"+xFilial("SB2")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SB2.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cQuery1 += " AND B2_LOCAL = '"+cAlmoxarif+"' ORDER BY B2_COD"
Else
	cQuery1 += " ORDER BY B2_COD"
EndIf

If Select("QUERYSB2") <> 0
	QUERYSB2->( dbCloseArea() )
EndIf

TCQUERY cQuery1 NEW ALIAS "QUERYSB2"

While !QUERYSB2->( EOF() )
	
	IncProc("Gerando SB7 com saldo do SB2...")
	
	If SB1->( dbSeek( xFilial() + QUERYSB2->B2_COD ) )
		
		If !SB7->( dbSeek( xFilial() + DtoS(dDatabase) + QUERYSB2->B2_COD + QUERYSB2->B2_LOCAL ) )
			
			aVetor := {}
			AADD( aVetor,{"B7_FILIAL" 			  ,xFilial("SB7")			   	,Nil} )
			AADD( aVetor,{"B7_DATA"            ,dDataBase                  ,Nil} )
			AADD( aVetor,{"B7_COD"             ,QUERYSB2->B2_COD           ,Nil} )
			AADD( aVetor,{"B7_LOCAL"           ,QUERYSB2->B2_LOCAL         ,Nil} )
			AADD( aVetor,{"B7_QUANT"           ,nQtd        		         ,Nil} )
			AADD( aVetor,{"B7_DOC"             ,'INVENT'                   ,Nil} )
			//AADD(aVetor,{"B7_LOTECTL"        ,SBF->BF_LOTECTL            ,Nil} )
			//AADD(aVetor,{"B7_LOCALIZ"        ,SBF->BF_LOCALIZ            ,Nil} )
			
			lBloqueado := .F.
			If SB1->B1_MSBLQL = '1'
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '2'
				SB1->( msUnlock() )
				lBloqueado := .T.
			EndIf
			
			//BEGIN transaction
			
			MSExecAuto({|x,y,z| MATA270(x,y,z)},aVetor,.f.,3)
			
			If lBloqueado
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '1'
				SB1->( msUnlock() )
			EndIf
			
			If lMSErroAuto

				MOSTRAERRO()
				lMSHelpAuto := .T.  // Para mostrar os erro na tela
				lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro é que deu erro
			Endif
			
			//END Transaction
			
		EndIf
	EndIf
	QUERYSB2->( dbSkip() )
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄVÄ¿
//³                                    SB8                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery2 := "SELECT B8_PRODUTO, B8_LOCAL, B8_LOTECTL FROM " + RetSqlName("SB8") + " SB8, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ <> 'S' AND B1_RASTRO =  'L' AND B8_PRODUTO = B1_COD AND B8_FILIAL = '"+xFilial("SB8")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SB8.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cQuery2 += " AND B8_LOCAL = '"+cAlmoxarif+"' ORDER BY B8_PRODUTO "
Else
	cQuery2 += " ORDER BY B8_PRODUTO"
EndIf

If Select("QUERYSB8") <> 0
	QUERYSB8->( dbCloseArea() )
EndIf

TCQUERY cQuery2 NEW ALIAS "QUERYSB8"

While !QUERYSB8->( EOF() )
	
	IncProc("Gerando SB7 com saldo do SB8...")
	
	If SB1->( dbSeek( xFilial() + QUERYSB8->B8_PRODUTO ) )
		
		If !SB7->( dbSeek( xFilial() + DtoS(dDatabase) + QUERYSB8->B8_PRODUTO + QUERYSB8->B8_LOCAL + Space(Len(SB7->B7_LOCALIZ)) + Space(Len(SB7->B7_NUMSERI)) + QUERYSB8->B8_LOTECTL ) )
			
			aVetor := {}
			AADD( aVetor,{"B7_FILIAL" 			  ,xFilial("SB7")			   	,Nil} )
			AADD( aVetor,{"B7_DATA"            ,dDataBase                  ,Nil} )
			AADD( aVetor,{"B7_COD"             ,QUERYSB8->B8_PRODUTO       ,Nil} )
			AADD( aVetor,{"B7_LOCAL"           ,QUERYSB8->B8_LOCAL         ,Nil} )
			AADD( aVetor,{"B7_QUANT"           ,nQtd        		         ,Nil} )
			AADD( aVetor,{"B7_DOC"             ,'INVENT'                   ,Nil} )
			AADD( aVetor,{"B7_LOTECTL"         ,QUERYSB8->B8_LOTECTL       ,Nil} )
			//AADD(aVetor,{"B7_LOCALIZ"        ,SBF->BF_LOCALIZ            ,Nil} )
			
			lBloqueado := .F.
			If SB1->B1_MSBLQL = '1'
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '2'
				SB1->( msUnlock() )
				lBloqueado := .T.
			EndIf
			
			//BEGIN transaction
			
			MSExecAuto({|x,y,z| MATA270(x,y,z)},aVetor,.f.,3)
			
			If lBloqueado
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '1'
				SB1->( msUnlock() )
			EndIf
			
			If lMSErroAuto

				MOSTRAERRO()
				lMSHelpAuto := .T.  // Para mostrar os erro na tela
				lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro é que deu erro
			Endif
			
			//END Transaction
			
		EndIf
	EndIf
	QUERYSB8->( dbSkip() )
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄVÄ¿
//³                                    SBF                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery3 := "SELECT BF_PRODUTO, BF_LOCAL, BF_LOCALIZ FROM " + RetSqlName("SBF") + " SBF, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ =  'S' AND B1_RASTRO <> 'L' AND BF_PRODUTO = B1_COD AND BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SBF.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cQuery3 += " AND BF_LOCAL = '"+cAlmoxarif+"' ORDER BY BF_PRODUTO "
Else
	cQuery3 += " ORDER BY BF_PRODUTO "
EndIf

If Select("QUERYSBF") <> 0
	QUERYSBF->( dbCloseArea() )
EndIf

TCQUERY cQuery3 NEW ALIAS "QUERYSBF"

While !QUERYSBF->( EOF() )
	
	IncProc("Gerando SB7 com saldo do SBF...")
	
	If SB1->( dbSeek( xFilial() + QUERYSBF->BF_PRODUTO ) )
		
		If !SB7->( dbSeek( xFilial() + DtoS(dDatabase) + QUERYSBF->BF_PRODUTO + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ ) )
			
			aVetor := {}
			AADD( aVetor,{"B7_FILIAL" 			  ,xFilial("SB7")			   	,Nil} )
			AADD( aVetor,{"B7_DATA"            ,dDataBase                  ,Nil} )
			AADD( aVetor,{"B7_COD"             ,QUERYSBF->BF_PRODUTO       ,Nil} )
			AADD( aVetor,{"B7_LOCAL"           ,QUERYSBF->BF_LOCAL         ,Nil} )
			AADD( aVetor,{"B7_QUANT"           ,nQtd        		         ,Nil} )
			AADD( aVetor,{"B7_DOC"             ,'INVENT'                   ,Nil} )
			//AADD(aVetor,{"B7_LOTECTL"        ,SBF->BF_LOTECTL            ,Nil} )
			AADD( aVetor,{"B7_LOCALIZ"         ,QUERYSBF->BF_LOCALIZ       ,Nil} )
			
			lBloqueado := .F.
			If SB1->B1_MSBLQL = '1'
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '2'
				SB1->( msUnlock() )
				lBloqueado := .T.
			EndIf
			
			//BEGIN transaction
			
			MSExecAuto({|x,y,z| MATA270(x,y,z)},aVetor,.f.,3)
			
			If lBloqueado
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '1'
				SB1->( msUnlock() )
			EndIf
			
			If lMSErroAuto

				MOSTRAERRO()
				lMSHelpAuto := .T.  // Para mostrar os erro na tela
				lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro é que deu erro
			Endif
			
			//END Transaction
			
		EndIf
	EndIf
	QUERYSBF->( dbSkip() )
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄVÄ¿
//³                                  SBF + LOTE                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery4 := "SELECT BF_PRODUTO, BF_LOCAL, BF_LOTECTL, BF_LOCALIZ FROM " + RetSqlName("SBF") + " SBF, " + RetSqlName("SB1") + " SB1 WHERE B1_LOCALIZ =  'S' AND B1_RASTRO = 'L' AND BF_PRODUTO = B1_COD AND BF_FILIAL = '"+xFilial("SBF")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XXINVEN = '1' AND SBF.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
If !Empty(cAlmoxarif)
	cQuery4 += " AND BF_LOCAL = '"+cAlmoxarif+"' ORDER BY BF_PRODUTO "
Else
	cQuery4 += " ORDER BY BF_PRODUTO "
EndIf

If Select("QUERYSBF") <> 0
	QUERYSBF->( dbCloseArea() )
EndIf

TCQUERY cQuery4 NEW ALIAS "QUERYSBF"

While !QUERYSBF->( EOF() )
	
	IncProc("Gerando SB7 com saldo do SBF+SB8...")
	
	If SB1->( dbSeek( xFilial() + QUERYSBF->BF_PRODUTO ) )
		
		If !SB7->( dbSeek( xFilial() + DtoS(dDatabase) + QUERYSBF->BF_PRODUTO + QUERYSBF->BF_LOCAL + QUERYSBF->BF_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + QUERYSBF->BF_LOTECTL ) )
			
			aVetor := {}
			AADD( aVetor,{"B7_FILIAL" 			  ,xFilial("SB7")			   	,Nil} )
			AADD( aVetor,{"B7_DATA"            ,dDataBase                  ,Nil} )
			AADD( aVetor,{"B7_COD"             ,QUERYSBF->BF_PRODUTO       ,Nil} )
			AADD( aVetor,{"B7_LOCAL"           ,QUERYSBF->BF_LOCAL         ,Nil} )
			AADD( aVetor,{"B7_QUANT"           ,nQtd        		         ,Nil} )
			AADD( aVetor,{"B7_DOC"             ,'INVENT'                   ,Nil} )
			AADD( aVetor,{"B7_LOTECTL"         ,QUERYSBF->BF_LOTECTL       ,Nil} )
			AADD( aVetor,{"B7_LOCALIZ"         ,QUERYSBF->BF_LOCALIZ       ,Nil} )
			
			lBloqueado := .F.
			If SB1->B1_MSBLQL = '1'
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '2'
				SB1->( msUnlock() )
				lBloqueado := .T.
			EndIf
			
			//BEGIN transaction
			
			MSExecAuto({|x,y,z| MATA270(x,y,z)},aVetor,.f.,3)
			
			If lBloqueado
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '1'
				SB1->( msUnlock() )
			EndIf
			
			If lMSErroAuto

				MOSTRAERRO()
				lMSHelpAuto := .T.  // Para mostrar os erro na tela
				lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro é que deu erro
			Endif
			
			//END Transaction
			
		EndIf
	EndIf
	QUERYSBF->( dbSkip() )
Enddo

Return


Static Function UMATA300(cProd1,cProd2,cLoc1,cLoc2)
Default cProd1 := Space(15)
Default cProd2 := Repl("z",15)
Default cLoc1  := Space(2)
Default cLoc2  := "zz"

If !Empty(cAlmoxarif)
   cLoc1  := cAlmoxarif
   cLoc2  := cAlmoxarif
EndIf

aBkpPerg := {}

//Chama pergunta ocultamente para alimentar variáveis
Pergunte("MTA300",.F.,,,,,@aBkpPerg)

//Altera conteúdo de alguma pergunta
mv_par01 := cLoc1
mv_par02 := cLoc2
mv_par03 := cProd1
mv_par04 := cProd2
mv_par05 := 2
mv_par06 := 2
mv_par07 := 2
mv_par08 := 2

//Carrega variável principal para que os parâmetros
//definido acima sejam salvos na próxima chamada
SaveMVVars(.T.)

__SaveParam("MTA300    ", aBkpPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Almoxarifado De   ?                                  ³
//³ mv_par02 - Almoxarifado Ate  ?                                  ³
//³ mv_par03 - Do produto                                           ³
//³ mv_par04 - Ate o produto                                        ³
//³ mv_par05 - Zera o Saldo da MOD?  Sim/Nao/Recalcula              ³
//³ mv_par06 - Zera o CM da MOD?  Sim/Nao/Recalcula                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Chama rotina de recalculo do saldo atual

MATA300(.T.)

Return
