#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CHR_ENTER				   '<br>'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA250ETRAN บAutor  ณHelio Ferreira      บ Data ณ  15/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada executado ap๓s o apontamento de Produ็ใo. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A250ETRAN()

	Local cOP       := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + Space(2)
	Local cNumSeq   := ''
	Local cNumIDOper:= ''
	Local cDocumen  := ''
	Local _Retorno  := .T.
	Local cProdOP   := SC2->C2_PRODUTO
	Local cLocalOP  := ''
	Local aAreaGER  := GetArea()
	Local aAreaSD3  := SD3->( GetArea() )
	Local aAreaSDA  := SDA->( GetArea() )
	Local aAreaSDB  := SDB->( GetArea() )
	Local aAreaSC2  := SC2->( GetArea() )
	Local aAreaSC6  := SC6->( GetArea() )
	Local aAreaSF5  := SF5->( GetArea() )
	Local aAreaSB1  := SB1->( GetArea() )
	Local _aCabSDA  := {}
	Local _aItSDB   := {}
	Local nQtdApto  := 0

	Private lMsErroAuto := .F.
	Private cQuery      :=' '
	Private __XXNumSeq  :=' '

	/*
	If Type("_lColetor") <> "U"
	If _lColetor
	Return
	EndIf
	EndIf
	*/                    


	//jonas OP com problema na rotina padrใo
	If Alltrim(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)=="89120 01001"
		SD3->( dbSetOrder(1) )
		If SD3->( dbSeek( xFilial() + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN ) )
			While !SD3->( EOF() ) .and. SD3->D3_FILIAL + Alltrim(SD3->D3_OP) == SC2->C2_FILIAL + Alltrim(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
				If EMPTY(SD3->D3_CF) .AND.  (SD3->D3_TM)=='010'

					Reclock("SC2",.F.)
					SC2->C2_QUJE:=SC2->C2_QUJE+SD3->D3_QUANT
					SC2->( msUnlock() )

					cNumSeq 	  := ProxNum()

					Reclock("SD3",.F.)
					SD3->D3_CF		:="PR0"
					SD3->D3_NUMSEQ :=cNumSeq
					SD3->D3_LOTECTL:=SC2->C2_NUM + SC2->C2_ITEM
					SD3->( msUnlock() )


					DBSelectArea("SD5")
					DbSetOrder(1)
					Reclock("SD5",.T.)
					SD5->D5_FILIAL  := xFilial("SD5")
					SD5->D5_NUMSEQ  := cNumSeq
					SD5->D5_PRODUTO := SD3->D3_COD
					SD5->D5_LOCAL   := SD3->D3_LOCAL
					SD5->D5_DOC     := SD3->D3_DOC
					SD5->D5_OP      := SD3->D3_OP
					SD5->D5_DATA    := SD3->D3_EMISSAO
					SD5->D5_ORIGLAN := SD3->D3_TM
					SD5->D5_QUANT   := SD3->D3_QUANT
					SD5->D5_XLOTEOK := "S"
					SD5->D5_LOTECTL := SD3->D3_LOTECTL
					SD5->D5_DTVALID := StoD("20491231")
					SD5->(msUnlock())

					cNumIDOper := GetSx8Num('SDB','DB_IDOPERA'); ConfirmSX8()

					DBSelectArea("SDB")
					DbSetOrder(1)
					Reclock("SDB",.T.)
					SDB->DB_FILIAL  := xFilial("SDB")
					SDB->DB_ITEM    := "0001"
					SDB->DB_PRODUTO := SD3->D3_COD
					SDB->DB_LOCAL   := SD3->D3_LOCAL
					SDB->DB_LOCALIZ := PADR('97PROCESSO',15)
					SDB->DB_DOC     := SD3->D3_DOC
					SDB->DB_TM      := SD3->D3_TM
					SDB->DB_ORIGEM  := "SD3"
					SDB->DB_QUANT   := SD3->D3_QUANT
					SDB->DB_DATA    := SD3->D3_EMISSAO
					SDB->DB_XLOTEOK := "S"
					SDB->DB_LOTECTL := SD3->D3_LOTECTL
					SDB->DB_NUMSEQ  := SD3->D3_NUMSEQ
					SDB->DB_TIPO    := "M"
					SDB->DB_SERVIC  := "999"
					SDB->DB_ATIVID  := "ZZZ"
					SDB->DB_HRINI   := Time()
					SDB->DB_ATUEST  := "S"
					SDB->DB_STATUS  := "M"
					SDB->DB_ORDATIV := "ZZ"
					SDB->DB_IDOPERA := cNumIDOper
					SDB->( msUnlock() )


					U_CRIAP07(SD3->D3_COD, SD3->D3_LOCAL)
				Endif
				//	alert(SD3->D3_NUMSEQ)
				SD3->( dbSkip() )
			Enddo
		endIF
		RestArea(aAreaGER)
		RETURN
	//		SC2->C2_QUJE:=SC2->C2_QUJE+M->D3_QUANT 
	EndIf


	If Localiza(cProdOP)

		SD3->( dbSetOrder(1) )
		SF5->( dbSetOrder(1) )

		// Posicionando no registro do SD3 da Produ็ใo
		If SD3->( dbSeek( xFilial() + cOP ) )
			nXXQUJE := 0
			While !SD3->( EOF() ) .and. SD3->D3_FILIAL + Alltrim(SD3->D3_OP) == SC2->C2_FILIAL + Alltrim(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
				If SD3->D3_ESTORNO <> 'S'
					If SF5->( dbSeek( xFilial() + SD3->D3_TM ) )
						If SF5->F5_TIPO == 'P'  // TM de Produ็ใo

							//If Empty(SD3->D3_PECA) .or. Subs(SD3->D3_COD,1,1) == '1'
							If SD3->D3_NUMSEQ > cNumSeq
								cNumSeq   := SD3->D3_NUMSEQ
								cLocalOP  := SD3->D3_LOCAL
								nQtdApto  := SD3->D3_QUANT
							EndIf

							nXXQUJE += SD3->D3_QUANT

							SB1->( dbSeek( xFilial() + SD3->D3_COD ) )
			
						EndIf
					EndIf
				EndIf
				SD3->( dbSkip() )
			End
			// Gravando a quantidade jแ apontada no campo presonalizado
			//If nXXQUJE > SC2->C2_XXQUJE     Retirado por H้lio em 25/09/18
			//   If Reclock("SC2",.F.)
			//	   SC2->C2_XXQUJE := nXXQUJE  Retirado por H้lio em 25/09/18           // S๓ atualiza o xxquje se estiver menor que a quantidade real apontada
			//	   SC2->( msUnlock() )
			//   EndIF
			//EndIf
		EndIf

		If cLocalOP == '13'

			SDA->( dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")) )  // DA_FILIAL + DA_NUMSEQ

			If SDA->( dbSeek( xFilial() + cNumSeq ) )
				If SDA->DA_SALDO >= nQtdApto

					_cItem := '0000'

					SDB->( dbSetOrder(1) )  //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
					If SDB->(dbSeek( xFilial() + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ))
						While xFilial("SDB") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
							_cItem:=SDB->DB_ITEM
							SDB->( dbSkip() )
						End
					EndIf

					_cItem     := StrZero(Val(_cItem)+1,4)
					_aItensSDB := {}

					_aCabSDA := {;
						{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
						{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

					_aItSDB  := {;
						{"DB_ITEM"	  ,_cItem	    ,Nil},;
						{"DB_ESTORNO" ,Space(01)    ,Nil},;
						{"DB_LOCALIZ" ,'13PRODUCAO' ,Nil},;
						{"DB_DATA"	  ,dDataBase    ,Nil},;
						{"DB_QUANT"   ,nQtdApto     ,Nil}}

					aadd(_aItensSDB,_aitSDB)


					MATA265( _aCabSDA, _aItensSDB, 3)
					If lMsErroAuto
						MostraErro("\UTIL\LOG\")
						//DisarmTransaction()
						MsgInfo("Erro no endere็amento automแtico de Produ็ใo (13).","A T E N ว ร O")
					EndIf

				EndIf
			EndIf
		EndIf

		If cLocalOP == GetMV("MV_XXLOCPR")

			SDA->( dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")) )  // DA_FILIAL + DA_NUMSEQ

			If SDA->( dbSeek( xFilial() + cNumSeq ) )
				If SDA->DA_SALDO >= nQtdApto

					_cItem := '0001'

					SDB->( dbSetOrder(1) )  //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
					If SDB->(dbSeek( xFilial() + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ))
						While xFilial("SDB") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
							_cItem:=SDB->DB_ITEM
							SDB->( dbSkip() )
						End
					EndIf

					_cItem     := StrZero(Val(_cItem)+1,4)
					_aItensSDB := {}

					_aCabSDA := {;
						{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
						{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

					_aItSDB  := {;
						{"DB_ITEM"	  ,_cItem	    ,Nil},;
						{"DB_ESTORNO" ,Space(01)    ,Nil},;
						{"DB_LOCALIZ" ,'97PROCESSO' ,Nil},;
						{"DB_DATA"	  ,dDataBase    ,Nil},;
						{"DB_QUANT"   ,nQtdApto     ,Nil}}

					aadd(_aItensSDB,_aitSDB)

					//Begin TRANSACTION
					MATA265( _aCabSDA, _aItensSDB, 3)
					If lMsErroAuto
						MostraErro("\UTIL\LOG\")
						//DisarmTransaction()
						MsgInfo("Erro no endere็amento automแtico de Produ็ใo (97).","A T E N ว ร O")
					EndIf
					//End TRANSACTION
				EndIf
			EndIf
		EndIf

		If cLocalOP == '10'

			SDA->( dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")) )  // DA_FILIAL + DA_NUMSEQ

			If SDA->( dbSeek( xFilial() + cNumSeq ) )
				If SDA->DA_SALDO >= nQtdApto

					_cItem := '0001'

					SDB->( dbSetOrder(1) )  //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
					If SDB->(dbSeek( xFilial() + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ))
						While xFilial("SDB") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
							_cItem:=SDB->DB_ITEM
							SDB->( dbSkip() )
						End
					EndIf

					_cItem     := StrZero(Val(_cItem)+1,4)
					_aItensSDB := {}

					_aCabSDA := {;
						{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
						{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

					_aItSDB  := {;
						{"DB_ITEM"	  ,_cItem	    ,Nil},;
						{"DB_ESTORNO" ,Space(01)    ,Nil},;
						{"DB_LOCALIZ" ,'CQ' ,Nil},;
						{"DB_DATA"	  ,dDataBase    ,Nil},;
						{"DB_QUANT"   ,nQtdApto     ,Nil}}

					aadd(_aItensSDB,_aitSDB)

					//Begin TRANSACTION
					MATA265( _aCabSDA, _aItensSDB, 3)
					If lMsErroAuto
						MostraErro("\UTIL\LOG\")
						//DisarmTransaction()
						MsgInfo("Erro no endere็amento automแtico de Produ็ใo (10).","A T E N ว ร O")
					EndIf
					//End TRANSACTION
				EndIf
			EndIf
		EndIf
		If cLocalOP == "95" //Local de Transferencia Filial 02

			SDA->( dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")) )  // DA_FILIAL + DA_NUMSEQ

			If SDA->( dbSeek( xFilial() + cNumSeq ) )
				If SDA->DA_SALDO >= nQtdApto

					_cItem := '0001'

					SDB->( dbSetOrder(1) )  //DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
					If SDB->(dbSeek( xFilial() + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ))
						While xFilial("SDB") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
							_cItem:=SDB->DB_ITEM
							SDB->( dbSkip() )
						End
					EndIf

					_cItem     := StrZero(Val(_cItem)+1,4)
					_aItensSDB := {}

					_aCabSDA := {;
						{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
						{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

					_aItSDB  := {;
						{"DB_ITEM"	  ,_cItem	    ,Nil},;
						{"DB_ESTORNO" ,Space(01)    ,Nil},;
						{"DB_LOCALIZ" ,'95TRANSFERENCIA' ,Nil},;
						{"DB_DATA"	  ,dDataBase    ,Nil},;
						{"DB_QUANT"   ,nQtdApto     ,Nil}}

					aadd(_aItensSDB,_aitSDB)

					//Begin TRANSACTION
					MATA265( _aCabSDA, _aItensSDB, 3)
					If lMsErroAuto
						MostraErro("\UTIL\LOG\")
						//DisarmTransaction()
						MsgInfo("Erro no endere็amento automแtico de Produ็ใo (97).","A T E N ว ร O")
					EndIf
					//End TRANSACTION
				EndIf
			EndIf
		EndIf
	EndIf


	dUlmes   := GetMV("MV_ULMES")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerificando se existem consumos de lotes diferentes do numero da OP     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//MsgInfo("Antes da corre็ใo de consumos de lotes errados")

//If Select("D5PRODUTO") <> 0
//	D5PRODUTO->( dbCloseArea() )
//EndIF

//TCQUERY cQuery NEW ALIAS "D5PRODUTO"

	cQuery := "SELECT D5_OP, D5_PRODUTO, D5_LOCAL, D5_NUMSEQ, D5_DATA, R_E_C_N_O_  FROM SD5010 (NOLOCK) "
	cQuery += "WHERE D5_FILIAL = '01' AND D5_LOCAL = '97' AND D5_DATA > '"+DtoS(dUlmes)+"' AND D5_OP <> '' "
	cQuery += "AND D5_LOTECTL <> SUBSTRING(D5_OP,1,8) AND D5_ESTORNO = '' AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY R_E_C_N_O_ "

	If Select("QSD5") <> 0
		QSD5->( dbCloseArea() )
	EndIF

	TCQUERY cQuery NEW ALIAS "QSD5"

	While !QSD5->( EOF() )
		cUpdate := "UPDATE "+RetSqlName("SD3")+" SET D3_LOTECTL = SUBSTRING(D3_OP,1,8) WHERE D3_FILIAL = '01' AND D3_OP = '"+QSD5->D5_OP+"' "
		cUpdate += "AND D3_COD = '"+QSD5->D5_PRODUTO+"' AND D3_LOCAL = '"+QSD5->D5_LOCAL+"' AND D3_NUMSEQ = '"+QSD5->D5_NUMSEQ+"' "
		cUpdate += "AND D3_EMISSAO = '"+QSD5->D5_DATA+"' AND D3_ESTORNO = '' AND D_E_L_E_T_ = '' "
		TCSQLEXEC(cUpdate)

		cUpdate2 := "UPDATE "+RetSqlName("SD5")+" SET D5_LOTECTL = SUBSTRING(D5_OP,1,8) WHERE R_E_C_N_O_ = " + Str(QSD5->R_E_C_N_O_)
		TCSQLEXEC(cUpdate2)

		cUpdate3 := "UPDATE "+RetSqlName("SDB")+" SET DB_LOTECTL = '"+U_RetLotC6(QSD5->D5_OP)+"' WHERE DB_FILIAL = '01' "
		cUpdate3 += "AND DB_PRODUTO = '"+QSD5->D5_PRODUTO+"' AND DB_LOCAL = '"+QSD5->D5_LOCAL+"' AND DB_NUMSEQ = '"+QSD5->D5_NUMSEQ+"' "
		cUpdate3 += "AND DB_DATA    = '"+QSD5->D5_DATA+"' AND DB_ESTORNO = '' AND D_E_L_E_T_ = '' "
		TCSQLEXEC(cUpdate3)

		U_CRIAP07(QSD5->D5_PRODUTO, QSD5->D5_LOCAL)

		QSD5->( dbSkip() )
	End

//MsgInfo("Depois da corre็ใo de consumos de lotes errados")

	IF Select("QSD5") <> 0
		QSD5->( dbCloseArea() )
	EndIF

//If Select("D5PRODUTO") <> 0
//	D5PRODUTO->( dbCloseArea() )
//EndIF

	RestArea(aAreaSC2)
	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSD3)
	RestArea(aAreaSF5)
	RestArea(aAreaSDA)
	RestArea(aAreaSDB)
	RestArea(aAreaGER)

	U_FNUMSEQ(__XXNumSeq)

Return
