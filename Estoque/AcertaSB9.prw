#include "rwmake.ch"
#include "topconn.ch"

User Function AcertaSB9()

cTexto := "Este programa tem o objetivo de calcular o saldos dos produtos nas datas em que foram realizados os fechamentos de estoque "
cTexto += "no intervalo de datas dos parâmetros e comparar com os saldos iniciais do próximo período (SB9) gerados pelo sistema. Caso os "
cTexto += "saldos em quantidade ou valor calculados pelos movimentos do estoque (função CalcEst()) estejam diferentes do SB9, esta rotina "
cTexto += "irá apresentar os saldos calculados e os gravados no SB9 e dará a possibilidade de alteração imediata. Caso não deseje efetuar "
cTexto += "a alteração, será possível cancelar a continuação do programa. ESTE PROGRAMA DEVERÁ SER EXECUTADO APÓS O FECHAMENTO PARA VALIDAR "
cTexto += "SE O MESMO FOI FEITO CORRETAMENTE."

BatchProcess("Acerto dos Saldos Iniciais (SB9)",cTexto,"ACERTASB9",{ || Processa({|lEnd| ProcRun() },OemToAnsi("Acerto dos Saldos Iniciais (SB9)"),OemToAnsi("Varrendo os fechamentos de estoque (SB9)"),.F.)})

Return

Static Function ProcRun()
Private lCorrige := .T.

SBJ->( dbSetOrder(1) )

cQuery := "SELECT COUNT(*) AS NTOTAL FROM SB9010 WHERE B9_FILIAL = '"+xFilial("SB9")+"' AND B9_DATA >= '"+DtoS(mv_par01)+"' AND B9_DATA <= '"+DtoS(mv_par02)+"' AND D_E_L_E_T_ = '' "
cQuery += " AND B9_COD >= '"+mv_par03+"' AND B9_COD <= '"+mv_par04+"' "

If Select("CONTAGEM") <> 0
	CONTAGEM->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "CONTAGEM"

PROCREGUA(CONTAGEM->NTOTAL)

cQuery := "SELECT R_E_C_N_O_ FROM SB9010 WHERE B9_FILIAL = '"+xFilial("SB9")+"' AND B9_DATA >= '"+DtoS(mv_par01)+"' AND B9_DATA <= '"+DtoS(mv_par02)+"' AND D_E_L_E_T_ = '' "
cQuery += " AND B9_COD >= '"+mv_par03+"' AND B9_COD <= '"+mv_par04+"' "

If Select("QUERYSB9") <> 0
	QUERYSB9->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSB9"

While !QUERYSB9->( EOF() )
	SB9->( dbGoTo(QUERYSB9->R_E_C_N_O_) )
	If SB9->( Recno() ) == QUERYSB9->R_E_C_N_O_
		cProduto := SB9->B9_COD
		cLocal   := SB9->B9_LOCAL
		dData    := (SB9->B9_DATA + 1)
		nQini    := SB9->B9_QINI
		nVini    := SB9->B9_VINI1
		
		If Reclock("SB9",.F.)
			SB9->( dbDelete() )
			SB9->( msUnlock() )
			aSaldoEst := CalcEst(cProduto, cLocal, dData )
			TCSQLEXEC("UPDATE SB9010 SET D_E_L_E_T_ = '', R_E_C_D_E_L_ = 0 WHERE R_E_C_N_O_ = "+Str(QUERYSB9->R_E_C_N_O_) )
			SB9->( dbGoTo(QUERYSB9->R_E_C_N_O_) )
			If SB9->( Recno() ) == QUERYSB9->R_E_C_N_O_
				If aSaldoEst[1] <> nQini .or. aSaldoEst[2] <> nVini
					lCorrige := .T.
					If mv_par05 == 1
						If !MsgYesNo('Produto: '+SB9->B9_COD+' Local: '+SB9->B9_LOCAL+' Data: '+DtoC(SB9->B9_DATA)+Chr(13)+'Qtd SB9: ' + Alltrim(Str(SB9->B9_QINI)) + ' Qtd Calc: ' + Alltrim(Str(aSaldoEst[1])) + ' Vlr SB9 ' + Alltrim(Str(SB9->B9_VINI1)) + ' Vlr Calc: ' + Alltrim(Str(aSaldoEst[2]))+Chr(13)+'Deseja corrigir o SB9 Recno(): '+Alltrim(Str(SB9->(Recno())))+'?','')
							lCorrige := .F.
						EndIf
					EndIf
					If lCorrige
						Reclock("SB9",.F.)
						SB9->B9_QINI  := aSaldoEst[1]
						SB9->B9_VINI1 := aSaldoEst[2]
						SB9->( msUnlock() )
					Else
						If MsgYesNo('Deseja sair do programa?','')
							Return
						EndIf
					EndIf
				EndIf
				If Rastro(SB9->B9_COD) .and. lCorrige
					nQtdB8 := 0

					cQuery := "SELECT * FROM "+RetSqlName("SB8")+" WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_PRODUTO = '"+SB9->B9_COD+"' AND B8_LOCAL = '"+SB9->B9_LOCAL+"' AND D_E_L_E_T_ = '' "
					
					If Select("QUERYSB8") <> 0
						QUERYSB8->( dbCloseArea() )
					EndIf
					
					TCQUERY cQuery NEW ALIAS "QUERYSB8"
					
					While !QUERYSB8->( EOF() )
						cProduto  := QUERYSB8->B8_PRODUTO
						cLocal    := QUERYSB8->B8_LOCAL
						cLoteCtl  := QUERYSB8->B8_LOTECTL
						cLote     := QUERYSB8->B8_NUMLOTE
						cLocaliza := ''
						cNumSerie := ''
						
						If SBJ->( dbSeek( xFilial() + cProduto + cLocal + cLoteCtl + cLote + DtoS(SB9->B9_DATA) ) )
							nRecSBJ := SBJ->( Recno() )
						Else
							nRecSBJ := 0
						EndIf
						
						If !Empty(nRecSBJ)
							If Reclock("SBJ",.F.)
								SBJ->( dbDelete() )
								SBJ->( msUnlock() )
							Else
								MsgStop('Não foi possível travar o SBJ, recno: ' + Str(SBJ->( Recno() )))
								If MsgYesNo('Deseja sair do programa?','')
									Return
								EndIf
							EndIf
						EndIf
						
						aSaldo    := CalcEstL(cProduto, cLocal, dData,cLoteCtl,cLote,cLocaliza,cNumSerie)
						
						If !Empty(nRecSBJ)
						   TCSQLEXEC("UPDATE SBJ010 SET D_E_L_E_T_ = '', R_E_C_D_E_L_ = 0 WHERE R_E_C_N_O_ = "+Str(nRecSBJ) )
						EndIf

						If QUERYSB8->B8_SALDO <> aSaldo[1]
					   		//Alert('Difsaldo - Saldo por lote diferente do saldo físico')
						EndIf

						nQtdB8 += aSaldo[1]

						QUERYSB8->( dbSkip() )
					End
					   
					If nQtdB8 <> aSaldoEst[1]
					   //Alert('Difsaldo - Saldo por lote diferente do saldo físico')
					EndIf
				EndIf
			Else
				MsgStop('Recno não encontrado no SB9: ' + Str(QUERYSB9->R_E_C_N_O_))
				If MsgYesNo('Deseja sair do programa?','')
					Return
				EndIf
			EndIf
		Else
			MsgStop('Não foi possível travar o SB9')
			If MsgYesNo('Deseja sair do programa?','')
				Return
			EndIf
		EndIf
	Else
		MsgStop('Recno não encontrado no SB9: ' + Str(QUERYSB9->R_E_C_N_O_))
		If MsgYesNo('Deseja sair do programa?','')
			Return
		EndIf
	EndIf
	QUERYSB9->( dbSkip() )
	IncProc()
End

MsgStop('Fim da execução da validação.')

Return
