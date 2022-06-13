# include 'topconn.ch'

//
//  Rotina criada para ajustar os difsaldos.
//  Ajusta o saldo fÃ­sico com base nos saldos por endereÃ§o
//

User Function Temp004()

	//RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv( "01", "02",,,"FAT")
	__cInternet := Nil

	cQuery := "SELECT * FROM "
	cQuery += "( "
	cQuery += "SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_QATU, B2_QACLASS "
	cQuery += ",ISNULL((SELECT SUM(BF_QUANT) FROM SBF010 WHERE BF_FILIAL = B2_FILIAL AND BF_PRODUTO = B2_COD AND BF_LOCAL = B2_LOCAL AND D_E_L_E_T_ = '') ,0) AS BFQUANT "
	cQuery += ",ISNULL((SELECT SUM(DA_SALDO) FROM SDA010 WHERE DA_FILIAL = B2_FILIAL AND DA_PRODUTO = B2_COD AND DA_LOCAL = B2_LOCAL AND D_E_L_E_T_ = '') ,0) AS DASALDO "
	cQuery += "FROM SB2010 WHERE D_E_L_E_T_ = '' AND B2_LOCAL='96' "
	cQuery += ") TMP WHERE (BFQUANT + B2_QACLASS <> B2_QATU) "

	TCQUERY cQuery NEW ALIAS "TEMP004"

	While !TEMP004->( EOF() )

	
		If TEMP004->B2_FILIAL == '01'
    		TEMP004->(dbSKIP())
    		loop
		EndIf

		If TEMP004->BFQUANT + TEMP004->B2_QACLASS > TEMP004->B2_QATU
			Reclock("SD3",.T.)
			SD3->D3_FILIAL  := TEMP004->B2_FILIAL
			SD3->D3_TM      := "002"
			SD3->D3_COD     := TEMP004->B2_COD
			SD3->D3_UM      := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_UM")
			SD3->D3_QUANT   := (TEMP004->BFQUANT + TEMP004->B2_QACLASS) - TEMP004->B2_QATU
			SD3->D3_CF      := "DE0"
			SD3->D3_CONTA   := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_CONTA")
			SD3->D3_LOCAL   := TEMP004->B2_LOCAL
			SD3->D3_DOC     := "ACERTO"
			SD3->D3_EMISSAO := dDataBase
			SD3->D3_GRUPO   := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_GRUPO")
			SD3->D3_CUSTO1  := 0
			SD3->D3_NUMSEQ  := ProxNum()
			SD3->D3_TIPO    := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_TIPO")
			SD3->D3_USUARIO := "jonas.pereira"
			SD3->D3_CHAVE   := "E0"
			SD3->D3_STSERV  := "1"
			SD3->D3_GARANTI := "N"
			SD3->( msUnlock() )

			//UMATA300(TEMP004->B2_COD,TEMP004->B2_COD,TEMP004->B2_LOCAL,TEMP004->B2_LOCAL)
		Else
			
			Reclock("SD3",.T.)
			SD3->D3_FILIAL  := TEMP004->B2_FILIAL
			SD3->D3_TM      := "502"
			SD3->D3_COD     := TEMP004->B2_COD
			SD3->D3_UM      := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_UM")
			SD3->D3_QUANT   := TEMP004->B2_QATU - (TEMP004->BFQUANT + TEMP004->B2_QACLASS)
			SD3->D3_CF      := "RE0"
			SD3->D3_CONTA   := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_CONTA")
			SD3->D3_LOCAL   := TEMP004->B2_LOCAL
			SD3->D3_DOC     := "ACERTO"
			SD3->D3_EMISSAO := dDataBase
			SD3->D3_GRUPO   := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_GRUPO")
			SD3->D3_CUSTO1  := 0
			SD3->D3_NUMSEQ  := ProxNum()
			SD3->D3_TIPO    := Posicione("SB1",1,xFilial('SB1')+TEMP004->B2_COD,"B1_TIPO")
			SD3->D3_USUARIO := "jonas.pereira"
			SD3->D3_CHAVE   := "E0"
			SD3->D3_STSERV  := "1"
			SD3->D3_GARANTI := "N"
			SD3->( msUnlock() )
			
		//	UMATA300(TEMP004->B2_COD,TEMP004->B2_COD,TEMP004->B2_LOCAL,TEMP004->B2_LOCAL)
			
		EndIf

		TEMP004->( dbSkip() )
	End

	TEMP004->( dbCloseArea() )

Return

Static Function UMATA300(cProd1,cProd2,cLoc1,cLoc2)
local cProd1 := Space(15)
local cProd2 := Repl("z",15)
local cLoc1  := Space(2)
local cLoc2  := "zz"

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
