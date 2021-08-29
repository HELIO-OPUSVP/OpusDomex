#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTR01   � Autor � Helio Ferreira     � Data �  15/05/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio para rastreamente de diferen�as enter SD3 e SD5  ���
���          � Vers�o 001 - Conclu�do em 16/05/12 (ARAYA)                 ���
���          �                                                            ���
���          � Adaptado para Domex em 17/09/12                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Estoque/PCP DOMEX                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
/*/

User Function RESTR01()

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo         := "Diferen�as entre Saldo Fisico x Saldo por Lote"
	Local nLin           := 80
	Local Cabec1         := ""
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd           := {}
	Local cPerg          := "RESTR01"

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "M"
	Private nomeprog     := "RESTR01"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RESTR01"
	Private cString      := ""

	Pergunte(cPerg,.F.)

//                                                                              RETRATO
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)  // aReturn[4]=1;Retrato   -  aReturn[4]=2;Paisagem

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  13/01/12   ���
	�������������������������������������������������������������������������͹��
	���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
	���          � monta a janela com a regua de processamento.               ���
	�������������������������������������������������������������������������͹��
	���Uso       � Programa principal                                         ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem, nRegua := 0

// primeira situa��o (SD3) // quinta situa��o (SD3)
	cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SD3") + " (NOLOCK) WHERE "
	cQuery += "D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	If Select("TEMP")<>0
		TEMP->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP"
	nRegua += (TEMP->CONTAGEM * 3)

	// segunda situa��o (SD2) // sexta situa��o (SD2)
	cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SD2") + " (NOLOCK) WHERE "
	cQuery += "D2_FILIAL = '"+xFilial("SD2")+"' AND D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D2_COD >= '"+mv_par03+"' AND D2_COD <= '"+mv_par04+"' AND D2_LOCAL >= '"+mv_par05+"' AND D2_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	If Select("TEMP")<>0
		TEMP->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP"
	nRegua += (TEMP->CONTAGEM * 2)

	// terceira situa��o (SD1) // setima situa��o (SD1)
	cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SD1") + " (NOLOCK) WHERE "
	cQuery += "D1_FILIAL = '"+xFilial("SD1")+"' AND D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D1_COD >= '"+mv_par03+"' AND D1_COD <= '"+mv_par04+"' AND D1_LOCAL >= '"+mv_par05+"' AND D1_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	If Select("TEMP")<>0
		TEMP->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP"
	nRegua += (TEMP->CONTAGEM * 2)

	// quarta situa��o (SD5)
	cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SD5") + " (NOLOCK) WHERE "
	cQuery += "D5_FILIAL = '"+xFilial("SD5")+"' AND D5_DATA >= '"+DtoS(mv_par01)+"' AND D5_DATA <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D5_PRODUTO >= '"+mv_par03+"' AND D5_PRODUTO <= '"+mv_par04+"' AND D5_LOCAL >= '"+mv_par05+"' AND D5_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' "
	If Select("TEMP")<>0
		TEMP->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP"
	nRegua += TEMP->CONTAGEM

	//  (SDB)
	cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SDB") + " (NOLOCK) WHERE "
	cQuery += "DB_FILIAL = '"+xFilial("SDB")+"' AND DB_DATA >= '"+DtoS(mv_par01)+"' AND DB_DATA <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND DB_PRODUTO >= '"+mv_par03+"' AND DB_PRODUTO <= '"+mv_par04+"' AND DB_LOCAL >= '"+mv_par05+"' AND DB_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND DB_ORIGEM = 'SD3' AND DB_ESTORNO = '' AND D_E_L_E_T_ = '' "
	If Select("TEMP")<>0
		TEMP->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP"
	nRegua += TEMP->CONTAGEM

// quinta situa��o (SD3)
//cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SD3") + " WHERE D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
//cQuery += "AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
//cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
//If Select("TEMP")<>0;TEMP->( dbCloseArea() );EndIf
//TCQUERY cQuery NEW ALIAS "TEMP"
//nRegua += TEMP->CONTAGEM

// sexta situa��o (SD2)
//cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SD2") + " WHERE D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"' "
//cQuery += "AND D2_COD >= '"+mv_par03+"' AND D2_COD <= '"+mv_par04+"' AND D2_LOCAL >= '"+mv_par05+"' AND D2_LOCAL <= '"+mv_par06+"' "
//cQuery += "AND D_E_L_E_T_ = '' "
//If Select("TEMP")<>0;TEMP->( dbCloseArea() );EndIf
//TCQUERY cQuery NEW ALIAS "TEMP"
//nRegua += TEMP->CONTAGEM

// setima situa��o (SD1)
//cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SD1") + " WHERE D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' "
//cQuery += "AND D1_COD >= '"+mv_par03+"' AND D1_COD <= '"+mv_par04+"' AND D1_LOCAL >= '"+mv_par05+"' AND D1_LOCAL <= '"+mv_par06+"' "
//cQuery += "AND D_E_L_E_T_ = '' "
//If Select("TEMP")<>0;TEMP->( dbCloseArea() );EndIf
//TCQUERY cQuery NEW ALIAS "TEMP"
//nRegua += TEMP->CONTAGEM

	SetRegua(nRegua)

	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif


//�����������������Ŀ
//�Primeira situa��o�   SD3  indregua-ok
//�������������������
	@ nLin,000 pSay "An�lise da situa��o: SD3 sem SD5"
	nLin++
	SD3->( dbSetOrder(6) ) // D3_FILIAL + D3_EMISSAO
	SD5->( dbSetOrder(3) ) // D5_FILIAL + D3_NUMSEQ
	SB1->( dbSetOrder(1) )
	//SD3->( dbSeek( xFilial() + DtoS(mv_par01),.T. ) )
	bNenhum := .T.

	cQuery := "SELECT * FROM " + RetSqlName("SD3") + " WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
	If Select("QUERYSD3")<>0
		QUERYSD3->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "QUERYSD3"

	While !QUERYSD3->( EOF() ) .and. QUERYSD3->D3_EMISSAO >= DtoS(mv_par01) .and. QUERYSD3->D3_EMISSAO <= DtoS(mv_par02)
		If QUERYSD3->D3_QUANT <> 0
			If QUERYSD3->D3_COD >= mv_par03 .and. QUERYSD3->D3_COD <= mv_par04
				If QUERYSD3->D3_LOCAL >= mv_par05 .and. QUERYSD3->D3_LOCAL <= mv_par06
					If SB1->( dbSeek( xFilial() + QUERYSD3->D3_COD ) )
						If SB1->B1_RASTRO == 'L'
							If Empty(QUERYSD3->D3_LOTECTL)
								cQuery := "SELECT D5_LOTECTL FROM SD5010 WHERE D5_FILIAL = '"+xFilial("SD5")+"' AND D5_NUMSEQ = '"+QUERYSD3->D3_NUMSEQ+"' AND D5_PRODUTO = '"+QUERYSD3->D3_COD+"' AND D_E_L_E_T_ = '' GROUP BY D5_LOTECTL "
								If Select("TEMP2") <> 0
									TEMP2->( dbCloseArea() )
								EndIf
								TCQUERY cQuery NEW ALIAS "TEMP2"
								nLotes := 0
								While !TEMP2->( EOF() )
									nLotes++
									TEMP2->( dbSkip() )
								End
								TEMP2->( dbGoTop() )
								If nLotes == 1
									SD3->( dbGoTo(QUERYSD3->R_E_C_N_O_) )
									Reclock("SD3",.F.)
									SD3->D3_LOTECTL := TEMP2->D5_LOTECTL
									SD3->( msUnlock() )
								EndIf
							EndIf

							If !Empty(QUERYSD3->D3_LOTECTL)
								If !SD5->( dbSeek( xFilial() + QUERYSD3->D3_NUMSEQ + QUERYSD3->D3_COD + QUERYSD3->D3_LOCAL + QUERYSD3->D3_LOTECTL + QUERYSD3->D3_NUMLOTE ) )

									@ nLin, 000        pSay "SD3-> "
									@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSD3->D3_EMISSAO))
									@ nLin, pCol() + 2 pSay QUERYSD3->D3_COD
									@ nLin, pCol() + 2 pSay QUERYSD3->D3_LOCAL
									@ nLin, pCol() + 2 pSay Transform(QUERYSD3->D3_QUANT,PesqPict("SD3","D3_QUANT"))
									@ nLin, pCol() + 2 pSay QUERYSD3->D3_NUMSEQ
									@ nLin, pCol() + 2 pSay Transform(QUERYSD3->R_E_C_N_O_,'@E 99,999,999')
									nLin++

									If nLin > 55
										Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
										nLin := 8
									Endif
									bNenhum := .F.
								EndIf
							Else
								If Empty(SD3->D3_LOTECTL)
									If MsgYesNo('Produto: ' +Alltrim(QUERYSD3->D3_COD)+ ' - SD3->D3_LOTECTL em branco. Preencher com LOTE1308? SD3->( Recno() ) = ' + Alltrim(Str(QUERYSD3->R_E_C_N_O_)))
										SD3->( dbGoTo(QUERYSD3->R_E_C_N_O_) )
										//Reclock("SD3",.F.)
										//SD3->D3_LOTECTL := 'LOTE1308'
										//SD3->( msUnlock() )
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		QUERYSD3->( dbSkip() )
		IncRegua()
	End
	If bNenhum
		@nLin,000 pSay "N�o foram encontrados registros no SD3 sem refer�ncia no SD5"
		nLin+=2
	EndIf

	//�����������������Ŀ
	//�Segunda situa��o�   SD2   indregua OK
	//�������������������
	@ nLin,000 pSay "An�lise da situa��o: SD2 sem SD5"
	nLin++
	SD2->( dbSetOrder(5) ) // D3_FILIAL + D3_EMISSAO
	SD5->( dbSetOrder(3) ) // D5_FILIAL + D3_NUMSEQ
	SB1->( dbSetOrder(1) )
	SF4->( dbSetOrder(1) )
	//SD2->( dbSeek( xFilial() + DtoS(mv_par01),.T. ) )

	cQuery := "SELECT * FROM " + RetSqlName("SD2") + " WHERE D2_FILIAL = '"+xFilial("SD2")+"' AND D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"' "
	cQuery += "AND D2_COD >= '"+mv_par03+"' AND D2_COD <= '"+mv_par04+"' AND D2_LOCAL >= '"+mv_par05+"' AND D2_LOCAL <= '"+mv_par06+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	If Select("QUERYSD2")<>0;QUERYSD2->( dbCloseArea() );EndIf
		TCQUERY cQuery NEW ALIAS "QUERYSD2"

		bNenhum := .T.
		While !QUERYSD2->( EOF() ) .and. QUERYSD2->D2_EMISSAO >= DtoS(mv_par01) .and. QUERYSD2->D2_EMISSAO <= DtoS(mv_par02)
			If QUERYSD2->D2_QUANT <> 0
				If QUERYSD2->D2_COD >= mv_par03 .and. QUERYSD2->D2_COD <= mv_par04
					If QUERYSD2->D2_LOCAL >= mv_par05 .and. QUERYSD2->D2_LOCAL <= mv_par06
						If Rastro(QUERYSD2->D2_COD)
							If SF4->( dbSeek( xFilial() + QUERYSD2->D2_TES ) )
								If SF4->F4_ESTOQUE == 'S'
									If !SD5->( dbSeek( xFilial() + QUERYSD2->D2_NUMSEQ + QUERYSD2->D2_COD + QUERYSD2->D2_LOCAL + QUERYSD2->D2_LOTECTL + QUERYSD2->D2_NUMLOTE ) )
										@ nLin, 000        pSay "SD2-> "
										@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSD2->D2_EMISSAO))
										@ nLin, pCol() + 2 pSay QUERYSD2->D2_COD
										@ nLin, pCol() + 2 pSay QUERYSD2->D2_LOCAL
										@ nLin, pCol() + 2 pSay QUERYSD2->D2_DOC+'/'+QUERYSD2->D2_SERIE
										@ nLin, pCol() + 2 pSay Transform(QUERYSD2->D2_QUANT,PesqPict("SD2","D2_QUANT"))
										@ nLin, pCol() + 2 pSay QUERYSD2->D2_NUMSEQ
										@ nLin, pCol() + 2 pSay Transform(QUERYSD2->R_E_C_N_O_,'@E 99,999,999')
										nLin++

										If nLin > 55
											Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
											nLin := 8
										Endif
										bNenhum := .F.
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			QUERYSD2->( dbSkip() )
			IncRegua()
		End
		If bNenhum
			@nLin,000 pSay "N�o foram encontrados registros no SD2 sem refer�ncia no SD5"
			nLin+=2
		EndIf


		//�����������������Ŀ
		//�Terceira situa��o�  SD1  indregua OK
		//�������������������
		@ nLin,000 pSay "An�lise da situa��o: SD1 sem SD5"
		nLin++
		SD1->( dbSetOrder(6) ) // D1_FILIAL + D1_DTDIGIT
		SD5->( dbSetOrder(3) ) // D5_FILIAL + D3_NUMSEQ
		SB1->( dbSetOrder(1) )
		SF4->( dbSetOrder(1) )
		//SD1->( dbSeek( xFilial() + DtoS(mv_par01),.T. ) )

		cQuery := "SELECT * FROM " + RetSqlName("SD1") + " WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND D1_COD >= '"+mv_par03+"' AND D1_COD <= '"+mv_par04+"' AND D1_LOCAL >= '"+mv_par05+"' AND D1_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D_E_L_E_T_ = '' "
		If Select("QUERYSD1")<>0
			QUERYSD1->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "QUERYSD1"

		bNenhum := .T.

		While !QUERYSD1->( EOF() ) .and. QUERYSD1->D1_DTDIGIT >= DtoS(mv_par01) .and. QUERYSD1->D1_DTDIGIT <= DtoS(mv_par02)
			If QUERYSD1->D1_QUANT <> 0
				If QUERYSD1->D1_COD >= mv_par03 .and. QUERYSD1->D1_COD <= mv_par04
					If QUERYSD1->D1_LOCAL >= mv_par05 .and. QUERYSD1->D1_LOCAL <= mv_par06
						If SF4->( dbSeek( xFilial() + QUERYSD1->D1_TES ) )
							If SF4->F4_ESTOQUE == 'S'
								If Rastro(QUERYSD1->D1_COD)
									If !SD5->( dbSeek( xFilial() + QUERYSD1->D1_NUMSEQ + QUERYSD1->D1_COD + QUERYSD1->D1_LOCAL + QUERYSD1->D1_LOTECTL + QUERYSD1->D1_NUMLOTE ) )
										@ nLin, 000        pSay "SD1-> "
										@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSD1->D1_DTDIGIT))
										@ nLin, pCol() + 2 pSay QUERYSD1->D1_COD
										@ nLin, pCol() + 2 pSay QUERYSD1->D1_LOCAL
										@ nLin, pCol() + 2 pSay Transform(QUERYSD1->D1_QUANT,PesqPict("SD1","D1_QUANT"))
										@ nLin, pCol() + 2 pSay QUERYSD1->D1_NUMSEQ
										@ nLin, pCol() + 2 pSay Transform(QUERYSD1->R_E_C_N_O_,'@E 99,999,999')
										nLin++

										If nLin > 55
											Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
											nLin := 8
										Endif
										bNenhum := .F.
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			QUERYSD1->( dbSkip() )
			IncRegua()
		End
		If bNenhum
			@nLin,000 pSay "N�o foram encontrados registros no SD1 sem refer�ncia no SD5"
			nLin+=2
		EndIf

		//�����������������@
		//�Quarta situa��o�     SD5 indregua OK
		//�����������������@

		@ nLin,000 pSay "An�lise da situa��o: SD5 sem SD3, sem SD2 e SD1."
		nLin++
		SD1->( dbSetOrder(4) ) // D1_FILIAL + D1_NUMSEQ
		SD2->( dbSetOrder(4) ) // D2_FILIAL + D2_NUMSEQ
		SD3->( dbSetOrder(4) ) // D3_FILIAL + D3_NUMSEQ
		SD5->( dbSetOrder(3) ) // D5_FILIAL + D5_NUMSEQ
		SB1->( dbSetOrder(1) )
		SF4->( dbSetOrder(1) )
		//SD3->( dbSeek( xFilial() + DtoS(mv_par01),.T. ) )
		bNenhum := .T.

		cQuery := "SELECT * FROM " + RetSqlName("SD5") + " WHERE D5_FILIAL = '"+xFilial("SD5")+"' AND D5_DATA >= '"+DtoS(mv_par01)+"' AND D5_DATA <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND D5_PRODUTO >= '"+mv_par03+"' AND D5_PRODUTO <= '"+mv_par04+"' AND D5_LOCAL >= '"+mv_par05+"' AND D5_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' "

		If Select("QUERYSD5")<>0
			QUERYSD5->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "QUERYSD5"
		While !QUERYSD5->( EOF() )
			If QUERYSD5->D5_PRODUTO >= mv_par03 .and. QUERYSD5->D5_PRODUTO <= mv_par04
				If QUERYSD5->D5_LOCAL >= mv_par05 .and. QUERYSD5->D5_LOCAL <= mv_par06
					If Rastro(QUERYSD5->D5_PRODUTO)
						If SD3->( dbSeek( xFilial() + QUERYSD5->D5_NUMSEQ ) )

						Else
							If SD2->( dbSeek( xFilial() + QUERYSD5->D5_NUMSEQ ) )
								If SF4->( dbSeek( xFilial() + SD2->D2_TES ) )
									If SF4->F4_ESTOQUE <> 'S'
										@ nLin, 000        pSay "TES "+SD2->D2_TES+" N�O ATUALIZANDO ESTOQUE: SD2-> "
										@ nLin, pCol() + 2 pSay SD2->D2_DOC + '/' + SD2->D2_SERIE
										@ nLin, pCol() + 2 pSay "SD5->"
										@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSD5->D5_DATA))
										@ nLin, pCol() + 2 pSay QUERYSD5->D5_PRODUTO
										@ nLin, pCol() + 2 pSay QUERYSD5->D5_LOCAL
										@ nLin, pCol() + 2 pSay Transform(QUERYSD5->D5_QUANT,PesqPict("SD5","D5_QUANT"))
										@ nLin, pCol() + 2 pSay QUERYSD5->D5_NUMSEQ
										@ nLin, pCol() + 2 pSay Transform(QUERYSD5->R_E_C_N_O_,'@E 99,999,999')
										nLin++
									EndIf
								EndIf
							Else
								If !SD1->( dbSeek( xFilial() + QUERYSD5->D5_NUMSEQ ) )
									@ nLin, 000        pSay "SD5-> "
									@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSD5->D5_DATA))
									@ nLin, pCol() + 2 pSay QUERYSD5->D5_PRODUTO
									@ nLin, pCol() + 2 pSay QUERYSD5->D5_LOCAL
									@ nLin, pCol() + 2 pSay Transform(QUERYSD5->D5_QUANT,PesqPict("SD5","D5_QUANT"))
									@ nLin, pCol() + 2 pSay QUERYSD5->D5_NUMSEQ
									@ nLin, pCol() + 2 pSay Transform(QUERYSD5->R_E_C_N_O_,'@E 99,999,999')
									nLin++

									If nLin > 55
										Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
										nLin := 8
									Endif
									bNenhum := .F.
								Else
									If SF4->( dbSeek( xFilial() + SD1->D1_TES ) )
										If SF4->F4_ESTOQUE <> 'S'
											@ nLin, 000        pSay "TES "+SD1->D1_TES+" N�O ATUALIZANDO ESTOQUE: SD1-> "
											@ nLin, pCol() + 2 pSay SD1->D1_DOC + '/' + SD1->D1_SERIE
											@ nLin, pCol() + 2 pSay "SD5->"
											@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSD5->D5_DATA))
											@ nLin, pCol() + 2 pSay QUERYSD5->D5_PRODUTO
											@ nLin, pCol() + 2 pSay QUERYSD5->D5_LOCAL
											@ nLin, pCol() + 2 pSay Transform(QUERYSD5->D5_QUANT,PesqPict("SD5","D5_QUANT"))
											@ nLin, pCol() + 2 pSay QUERYSD5->D5_NUMSEQ
											@ nLin, pCol() + 2 pSay Transform(QUERYSD5->R_E_C_N_O_,'@E 99,999,999')
											nLin++
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			QUERYSD5->( dbSkip() )
			IncRegua()
		End
		If bNenhum
			@nLin,000 pSay "N�o foram encontrados registros no SD5 sem refer�ncia no SD3"
			nLin += 2
		EndIf


		//�����������������Ŀ
		//�Quinta situa��o�   SD3 - indregua Ok
		//�������������������
		@ nLin,000 pSay "An�lise da situa��o: SD3 diferente de SD5"
		nLin++
		SD3->( dbSetOrder(6) ) // D3_FILIAL + D3_EMISSAO
		SD5->( dbSetOrder(3) ) // D5_FILIAL + D3_NUMSEQ
		SB1->( dbSetOrder(1) )
		//SD3->( dbSeek( xFilial() + DtoS(mv_par01),.T. ) )

		cQuery := "SELECT * FROM " + RetSqlName("SD3") + " WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "

		If Select("QUERYSD3")<>0
			QUERYSD3->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "QUERYSD3"

		bNenhum := .T.
		While !QUERYSD3->( EOF() ) .and. QUERYSD3->D3_EMISSAO >= DtoS(mv_par01) .and. QUERYSD3->D3_EMISSAO <= DtoS(mv_par02)
			If QUERYSD3->D3_QUANT <> 0
				If QUERYSD3->D3_COD >= mv_par03 .and. QUERYSD3->D3_COD <= mv_par04
					If QUERYSD3->D3_LOCAL >= mv_par05 .and. QUERYSD3->D3_LOCAL <= mv_par06
						If Rastro(QUERYSD3->D3_COD)
							If SD5->( dbSeek( xFilial() + QUERYSD3->D3_NUMSEQ + QUERYSD3->D3_COD + QUERYSD3->D3_LOCAL + QUERYSD3->D3_LOTECTL + QUERYSD3->D3_NUMLOTE ) )
								If QUERYSD3->D3_QUANT <> SD5->D5_QUANT
									@ nLin, 000        pSay "SD3->"+DtoC(StoD(QUERYSD3->D3_EMISSAO))
									@ nLin, pCol() + 1 pSay "SD5->"+DtoC(SD5->D5_DATA)
									@ nLin, pCol() + 1 pSay "SD3->"+Subs(QUERYSD3->D3_COD,1,15)
									@ nLin, pCol() + 1 pSay "SD5->"+Subs(SD5->D5_PRODUTO,1,15)
									@ nLin, pCol() + 1 pSay "SD3->"+QUERYSD3->D3_LOCAL
									@ nLin, pCol() + 1 pSay "SD5->"+SD5->D5_LOCAL
									@ nLin, pCol() + 1 pSay "SD3->"+Transform(QUERYSD3->D3_QUANT,PesqPict("SD3","D3_QUANT"))
									@ nLin, pCol() + 1 pSay "SD5->"+Transform(SD5->D5_QUANT,PesqPict("SD5","D5_QUANT"))
									@ nLin, pCol() + 1 pSay "SD3->"+QUERYSD3->D3_NUMSEQ
									@ nLin, pCol() + 1 pSay "SD5->"+SD5->D5_NUMSEQ
									@ nLin, pCol() + 1 pSay "SD3->"+Transform(QUERYSD3->R_E_C_N_O_,'@E 99,999,999')
									@ nLin, pCol() + 1 pSay "SD5->"+Transform(SD5->(Recno()),'@E 99,999,999')

									nLin++

									If nLin > 55
										Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
										nLin := 8
									Endif
									bNenhum := .F.
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			QUERYSD3->( dbSkip() )
			IncRegua()
		End
		If bNenhum
			@nLin,000 pSay "N�o foram encontrados registros no SD3 com quantidade diferente do SD5"
			nLin+=2
		EndIf

		//�����������������Ŀ
		//�Sexta situa��o�      SD2 - Indregua OK
		//�������������������

		@ nLin,000 pSay "An�lise da situa��o: SD2 diferente de SD5"
		nLin++
		SD2->( dbSetOrder(5) ) // D2_FILIAL + D2_EMISSAO
		SD3->( dbSetOrder(6) ) // D3_FILIAL + D3_EMISSAO
		SD5->( dbSetOrder(3) ) // D5_FILIAL + D3_NUMSEQ
		SB1->( dbSetOrder(1) )
		//SD2->( dbSeek( xFilial() + DtoS(mv_par01) ,.T.) )

		cQuery := "SELECT * FROM " + RetSqlName("SD2") + " WHERE D2_FILIAL = '"+xFilial("SD2")+"' AND D2_EMISSAO >= '"+DtoS(mv_par01)+"' AND D2_EMISSAO <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND D2_COD >= '"+mv_par03+"' AND D2_COD <= '"+mv_par04+"' AND D2_LOCAL >= '"+mv_par05+"' AND D2_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D_E_L_E_T_ = '' "
		If Select("QUERYSD2")<>0
			QUERYSD2->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "QUERYSD2"

		SB1->( dbSetOrder(1) )
		bNenhum := .T.
		While !QUERYSD2->( EOF() ) .and. QUERYSD2->D2_EMISSAO >= DtoS(mv_par01) .and. QUERYSD2->D2_EMISSAO <= DtoS(mv_par02)
			If QUERYSD2->D2_QUANT <> 0
				If QUERYSD2->D2_COD >= mv_par03 .and. QUERYSD2->D2_COD <= mv_par04
					If QUERYSD2->D2_LOCAL >= mv_par05 .and. QUERYSD2->D2_LOCAL <= mv_par06
						If SB1->( dbSeek( xFilial() + QUERYSD2->D2_COD ) )
							If SB1->B1_RASTRO == 'L'
								If SD5->( dbSeek( xFilial() + QUERYSD2->D2_NUMSEQ + QUERYSD2->D2_COD + QUERYSD2->D2_LOCAL + QUERYSD2->D2_LOTECTL + QUERYSD2->D2_NUMLOTE ) )
									If QUERYSD2->D2_QUANT <> SD5->D5_QUANT
										@ nLin, 000        pSay "SD2->"+DtoC(QUERYSD2->D2_EMISSAO)
										@ nLin, pCol() + 2 pSay "SD5->"+DtoC(SD5->D5_DATA)
										@ nLin, pCol() + 2 pSay "SD2->"+QUERYSD2->D2_COD
										@ nLin, pCol() + 2 pSay "SD5->"+SD5->D5_PRODUTO
										@ nLin, pCol() + 2 pSay "SD2->"+QUERYSD2->D2_LOCAL
										@ nLin, pCol() + 2 pSay "SD5->"+SD5->D5_LOCAL
										@ nLin, pCol() + 2 pSay "SD2->"+Transform(QUERYSD2->D2_QUANT,PesqPict("SD3","D3_QUANT"))
										@ nLin, pCol() + 2 pSay "SD5->"+Transform(SD5->D5_QUANT,PesqPict("SD5","D5_QUANT"))
										@ nLin, pCol() + 2 pSay "SD2->"+QUERYSD2->D2_NUMSEQ
										@ nLin, pCol() + 2 pSay "SD5->"+SD5->D5_NUMSEQ
										@ nLin, pCol() + 2 pSay "SD2->"+Transform(QUERYSD2->R_E_C_N_O_,'@E 99,999,999')
										@ nLin, pCol() + 2 pSay "SD5->"+Transform(SD5->(Recno()),'@E 99,999,999')

										nLin++

										If nLin > 55
											Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
											nLin := 8
										Endif
										bNenhum := .F.
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			QUERYSD2->( dbSkip() )
			IncRegua()
		End
		If bNenhum
			@nLin,000 pSay "N�o foram encontrados registros no SD2 com quantidade diferente do SD5"
			nLin+=2
		EndIf

		//�����������������Ŀ
		//�Setima situa��o�      SD1 - Indregua OK
		//�������������������

		@ nLin,000 pSay "An�lise da situa��o: SD1 diferente de SD5"
		nLin++
		SD1->( dbSetOrder(1) ) // D1_FILIAL + D1_EMISSAO
		SD2->( dbSetOrder(5) ) // D2_FILIAL + D2_EMISSAO
		SD3->( dbSetOrder(6) ) // D3_FILIAL + D3_EMISSAO
		SD5->( dbSetOrder(3) ) // D5_FILIAL + D3_NUMSEQ
		SB1->( dbSetOrder(1) )
		//SD1->( dbSeek( xFilial() + DtoS(mv_par01) ,.T.) )
		cQuery := "SELECT * FROM " + RetSqlName("SD1") + " WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND D1_DTDIGIT >= '"+DtoS(mv_par01)+"' AND D1_DTDIGIT <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND D1_COD >= '"+mv_par03+"' AND D1_COD <= '"+mv_par04+"' AND D1_LOCAL >= '"+mv_par05+"' AND D1_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D_E_L_E_T_ = '' "
		If Select("QUERYSD1")<>0
			QUERYSD1->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "QUERYSD1"

		bNenhum := .T.
		While !QUERYSD1->( EOF() ) .and. QUERYSD1->D1_EMISSAO >= DtoS(mv_par01) .and. QUERYSD1->D1_EMISSAO <= DtoS(mv_par02)
			If QUERYSD1->D1_QUANT <> 0
				If QUERYSD1->D1_COD >= mv_par03 .and. QUERYSD1->D1_COD <= mv_par04
					If QUERYSD1->D1_LOCAL >= mv_par05 .and. QUERYSD1->D1_LOCAL <= mv_par06
						If Rastro(QUERYSD1->D1_COD)
							If SD5->( dbSeek( xFilial() + QUERYSD1->D1_NUMSEQ + QUERYSD1->D1_COD + QUERYSD1->D1_LOCAL + QUERYSD1->D1_LOTECTL + QUERYSD1->D1_NUMLOTE ) )
								If QUERYSD1->D1_QUANT <> SD5->D5_QUANT
									@ nLin, 000        pSay "SD1->"+DtoC(QUERYSD1->D1_EMISSAO)
									@ nLin, pCol() + 2 pSay "SD5->"+DtoC(SD5->D5_DATA)
									@ nLin, pCol() + 2 pSay "SD1->"+QUERYSD1->D1_COD
									@ nLin, pCol() + 2 pSay "SD5->"+SD5->D5_PRODUTO
									@ nLin, pCol() + 2 pSay "SD1->"+QUERYSD1->D1_LOCAL
									@ nLin, pCol() + 2 pSay "SD5->"+SD5->D5_LOCAL
									@ nLin, pCol() + 2 pSay "SD1->"+Transform(QUERYSD1->D1_QUANT,PesqPict("SD3","D3_QUANT"))
									@ nLin, pCol() + 2 pSay "SD5->"+Transform(SD5->D5_QUANT,PesqPict("SD5","D5_QUANT"))
									@ nLin, pCol() + 2 pSay "SD1->"+QUERYSD1->D1_NUMSEQ
									@ nLin, pCol() + 2 pSay "SD5->"+SD5->D5_NUMSEQ
									@ nLin, pCol() + 2 pSay "SD1->"+Transform(QUERYSD1->R_E_C_N_O_,'@E 99,999,999')
									@ nLin, pCol() + 2 pSay "SD5->"+Transform(SD5->(Recno()),'@E 99,999,999')

									nLin++

									If nLin > 55
										Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
										nLin := 8
									Endif
									bNenhum := .F.
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			QUERYSD1->( dbSkip() )
			IncRegua()
		End
		If bNenhum
			@nLin,000 pSay "N�o foram encontrados registros no SD1 com quantidade diferente do SD5"
			nLin+=2
		EndIf


		//�����������������Ŀ
		//�Oitava situa��o�   SD3  sem SDB
		//�������������������
		@ nLin,000 pSay "An�lise da situa��o: SD3 sem SDB"
		nLin++
		SD3->( dbSetOrder(6) ) // D3_FILIAL + D3_EMISSAO
		SDB->( dbSetOrder(1) ) // DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
		SB1->( dbSetOrder(1) )
		//SD3->( dbSeek( xFilial() + DtoS(mv_par01),.T. ) )
		bNenhum := .T.

		cQuery := "SELECT * FROM " + RetSqlName("SD3") + " WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_EMISSAO >= '"+DtoS(mv_par01)+"' AND D3_EMISSAO <= '"+DtoS(mv_par02)+"' "
		cQuery += "AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' AND D3_LOCAL >= '"+mv_par05+"' AND D3_LOCAL <= '"+mv_par06+"' "
		cQuery += "AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
		If Select("QUERYSD3")<>0;QUERYSD3->( dbCloseArea() );EndIf
			TCQUERY cQuery NEW ALIAS "QUERYSD3"

			While !QUERYSD3->( EOF() ) .and. QUERYSD3->D3_EMISSAO >= DtoS(mv_par01) .and. QUERYSD3->D3_EMISSAO <= DtoS(mv_par02)
				If QUERYSD3->D3_QUANT <> 0
					If QUERYSD3->D3_COD >= mv_par03 .and. QUERYSD3->D3_COD <= mv_par04
						If QUERYSD3->D3_LOCAL >= mv_par05 .and. QUERYSD3->D3_LOCAL <= mv_par06
							If SB1->( dbSeek( xFilial() + QUERYSD3->D3_COD ) )
								If SB1->B1_RASTRO == 'L' .and. SB1->B1_LOCALIZ == 'S'
									If !Empty(QUERYSD3->D3_LOTECTL)
										If !SDB->( dbSeek( xFilial() + QUERYSD3->D3_COD + QUERYSD3->D3_LOCAL + QUERYSD3->D3_NUMSEQ +  QUERYSD3->D3_DOC ) )

											@ nLin, 000        pSay "SD3-> "
											@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSD3->D3_EMISSAO))
											@ nLin, pCol() + 2 pSay QUERYSD3->D3_COD
											@ nLin, pCol() + 2 pSay QUERYSD3->D3_LOCAL
											@ nLin, pCol() + 2 pSay Transform(QUERYSD3->D3_QUANT,PesqPict("SD3","D3_QUANT"))
											@ nLin, pCol() + 2 pSay QUERYSD3->D3_NUMSEQ
											@ nLin, pCol() + 2 pSay Transform(QUERYSD3->R_E_C_N_O_,'@E 99,999,999')
											nLin++

											If nLin > 55
												Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
												nLin := 8
											Endif
											bNenhum := .F.
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				QUERYSD3->( dbSkip() )
				IncRegua()
			End
			If bNenhum
				@nLin,000 pSay "N�o foram encontrados registros no SD3 sem refer�ncia no SDB"
				nLin+=2
			EndIf


			//�����������������Ŀ
			//�Oitava situa��o�   SDB  sem SD3
			//�������������������
			@ nLin,000 pSay "An�lise da situa��o: SDB sem SD3"
			nLin++
			SD3->( dbSetOrder(3) ) // D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ+D3_CF
			SDB->( dbSetOrder(1) ) // DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
			SB1->( dbSetOrder(1) )
			//SD3->( dbSeek( xFilial() + DtoS(mv_par01),.T. ) )
			bNenhum := .T.

			cQuery := "SELECT * FROM " + RetSqlName("SDB") + " WHERE DB_FILIAL = '"+xFilial("SDB")+"' AND DB_DATA >= '"+DtoS(mv_par01)+"' AND DB_DATA <= '"+DtoS(mv_par02)+"' "
			cQuery += "AND DB_PRODUTO >= '"+mv_par03+"' AND DB_PRODUTO <= '"+mv_par04+"' AND DB_LOCAL >= '"+mv_par05+"' AND DB_LOCAL <= '"+mv_par06+"' "
			cQuery += "AND DB_QUANT <> 0 AND DB_ORIGEM IN ('SD3','ACE') AND DB_ESTORNO = '' AND D_E_L_E_T_ = '' "
			If Select("QUERYSDB")<>0
				QUERYSDB->( dbCloseArea() )
			EndIf
			TCQUERY cQuery NEW ALIAS "QUERYSDB"

			While !QUERYSDB->( EOF() )
				If SB1->( dbSeek( xFilial() + QUERYSDB->DB_PRODUTO ) )
					If SB1->B1_RASTRO == 'L' .and. SB1->B1_LOCALIZ == 'S'
						If QUERYSDB->DB_NUMSEQ == 'AGC551'
							n := 1
						EndIf

						If !SD3->( dbSeek( xFilial() + QUERYSDB->DB_PRODUTO + QUERYSDB->DB_LOCAL + QUERYSDB->DB_NUMSEQ ) )

							@ nLin, 000        pSay "SDB-> "
							@ nLin, pCol() + 2 pSay QUERYSDB->DB_TM
							@ nLin, pCol() + 2 pSay DtoC(StoD(QUERYSDB->DB_DATA))
							@ nLin, pCol() + 2 pSay QUERYSDB->DB_PRODUTO
							@ nLin, pCol() + 2 pSay QUERYSDB->DB_LOCAL
							@ nLin, pCol() + 2 pSay QUERYSDB->DB_LOTECTL
							@ nLin, pCol() + 2 pSay Transform(QUERYSDB->DB_QUANT,PesqPict("SD3","D3_QUANT"))
							@ nLin, pCol() + 2 pSay QUERYSDB->DB_NUMSEQ
							@ nLin, pCol() + 2 pSay Transform(QUERYSDB->R_E_C_N_O_,'@E 99,999,999')
							nLin++

							If nLin > 55
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 8
							Endif
							bNenhum := .F.
						EndIf
					EndIf
				EndIf
				QUERYSDB->( dbSkip() )
				IncRegua()
			End
			If bNenhum
				@nLin,000 pSay "N�o foram encontrados registros no SDB sem refer�ncia no SD3"
				nLin+=2
			EndIf


			SET DEVICE TO SCREEN

			If aReturn[5]==1
				dbCommitAll()
				SET PRINTER TO
				OurSpool(wnrel)
			Endif

			MS_FLUSH()

			Return
