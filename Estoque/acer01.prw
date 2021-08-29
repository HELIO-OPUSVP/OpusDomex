#include "protheus.ch"
#include "topconn.ch"
//jonas
User function Acer01()
	Local ___x


	//Local _aCabSDA    := {}
	//Local _aItSDB     := {}
	//Local _aItensSDB  := {}
	//Local _cItem      := StrZero(1,4)


	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.


	RpcSetEnv("01","02")

	//ACERTA SALDO
	cQuery := " SELECT * FROM SBF010 (NOLOCK) WHERE BF_QUANT<>0 AND D_E_L_E_T_='' AND BF_FILIAL='02' AND BF_LOCALIZ='01RECEBIMENTO' "



	If Select("INV") <> 0
		INV->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "INV"



	While INV->(!EOF())


		SB1->(DBSEEK(xfilial()+INV->BF_PRODUTO))

		SD3->( dbSetOrder(2))

		For ___x := 1 to 100
			Private _cDoc	        := U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
			If !SD3->( dbSeek(xFilial() + _cDoc) )
				Exit
			EndIf
		Next ___x

		_cDoc :=_cDoc+SPACE(09)     //DOCUMENTO 9 DIGITOS
		_cDoc :=SUBSTR(_cDoc,1,9)

		lMsErroAuto := .F.


		PRIVATE cCusMed   := GetMv("MV_CUSMED")
		PRIVATE cCadastro := "Transferencias"
		PRIVATE aRegSD3	  := {}
		PRIVATE nPerImp   := CriaVar("D3_PERIMP")


		//ConOut("Antes do a260Processa" + Time())
		If SB1->B1_APROPRI == 'I'
			cAlmoxDest := "99"
			cLocalDest := "99PROCESSO"
			cLoteDest  := "LOTE1308"
			cOcorre    := "5"
			a260Processa(INV->BF_PRODUTO,"01",INV->BF_QUANT,_cDoc,dDataBase,0,,INV->BF_LOTECTL ,StoD("20491231"),,"01RECEBIMENTO",INV->BF_PRODUTO,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
		ElseIf ALLTRIM(SB1->B1_GRUPO)=='FO' .OR. ALLTRIM(SB1->B1_GRUPO)=='FOFS'
			cAlmoxDest := "01"
			cLocalDest := "01CORTE"
			cLoteDest  := "LOTE1308"
			cOcorre    := "4"
			a260Processa(INV->BF_PRODUTO,"01",INV->BF_QUANT,_cDoc,dDataBase,0,,INV->BF_LOTECTL ,StoD("20491231"),,"01RECEBIMENTO",INV->BF_PRODUTO,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
		Else
			cAlmoxDest := "97"
			cLocalDest := "97PROCESSO"
			cLoteDest  := "LOTE1308" //U_RETLOTC6(XD1->XD1_OP)
			cOcorre    := "8"
			a260Processa(INV->BF_PRODUTO,"01",INV->BF_QUANT,_cDoc,dDataBase,0,,"LOTE1308",StoD("20491231"),,"01RECEBIMENTO",INV->BF_PRODUTO,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
		EndIf

		//ConOut("Depois do a260Processa" + Time())
		If lMsErroAuto .and. .F.

			MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
		Else
			SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
			If SD3->( dbSeek( xFilial() + _cDoc ) )
				While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)    //MLS ALTERADO MOTIVO DOCUMENTO COM 9 DIGITOS
					If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
						If SD3->D3_COD == INV->BF_PRODUTO
							If SD3->D3_EMISSAO == dDataBase
								If SD3->D3_QUANT == INV->BF_QUANT
									If Empty(SD3->D3_XXOP)
										Reclock("SD3",.F.)
										//SD3->D3_XXPECA  := XD1->XD1_XXPECA
										//SD3->D3_XXOP    := XD1->XD1_OP
										SD3->D3_USUARIO := cUsuario
										SD3->D3_HORA    := Time()
										SD3->( msUnlock() )
									EndIf
								EndIf

							EndIf
						EndIf
					endif
					SD3->( dbSkip() )
				End

			EndIf
		eNDIF

		INV->(dbSkip())
	enddo

//ACERTA ENDERECAMENTO
/*
cQuery := " SELECT * FROM SDA010 (NOLOCK) WHERE DA_SALDO<>0 AND D_E_L_E_T_='' AND DA_FILIAL='02' "



If Select("INV") <> 0
    INV->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "INV"
    

SDA->(dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")))  // DA_FILIAL + DA_NUMSEQ
While INV->(!EOF())    
    SDA->(dbSetOrder(6))
	If SDA->(dbSeek( xFilial() + INV->DA_NUMSEQ ))
		_cLocaliz := "01RECEBIMENTO"
		//Busca o próximo item no SDB.
		_cItem := '0001'
		SDB->(dbSetOrder(1))
		If SDB->(dbSeek( xFilial("SDB") + INV->DA_PRODUTO + SDA->DA_LOCAL + INV->DA_NUMSEQ))
			While xFilial("SDA") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ													
			    If _cItem < SDB->DB_ITEM
					_cItem := SDB->DB_ITEM
				EndIf
				SDB->( dbSkip() )
			End
			_cItem := StrZero(Val(_cItem)+1,4)
		EndIf

		
            _aItensSDB := {}

    		_aCabSDA := {{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
	            		{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil}}

			_aItSDB  := {;
				    	{"DB_ITEM"	  ,_cItem	       ,Nil},;
					    {"DB_ESTORNO" ,Space(01)       ,Nil},;
					    {"DB_LOCALIZ" ,_cLocaliz       ,Nil},;
					    {"DB_DATA"	  ,SDA->DA_DATA    ,Nil},;
					    {"DB_QUANT"   ,SDA->DA_SALDO   ,Nil}}
					    aadd(_aItensSDB,_aitSDB)

					    MATA265( _aCabSDA, _aItensSDB, 3)

												    //RestArea(_aAreaSD1)
					    If lMsErroAuto
						    MostraErro("\UTIL\LOG\Classificacao\")
						    MsgInfo("Erro no endereçamento automático.","A T E N Ç Ã O")
					    EndIf

	eNDIF
	INV->(dbSkip())
enddo
*/
return


User Function Acer02()


	Local cQuery := ""

	RpcSetEnv("01","01")

	cQuery += "SELECT D3_NUMSEQ, * FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_ESTORNO = '' AND D_E_L_E_T_='' AND  "
	cQuery += "D3_NUMSEQ IN "
	cQuery += "( "
	cQuery += "SELECT D3_NUMSEQ  FROM SD3010 (NOLOCK) WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_CF IN ('RE4','DE4') AND D3_ESTORNO = '' AND D_E_L_E_T_='' "
	cQuery += "GROUP BY D3_NUMSEQ "
	cQuery += "HAVING COUNT(*) = 1 "
	cQuery += ") "
	cQuery += "AND D3_XXOP <> '' "
	cQuery += "AND D3_EMISSAO >= '20210801' "
	
	MPSysOpenQuery( cQuery , "TMP")

	While !TMP->( EOF() )
		Reclock("SD3",.T.)
		SD3->D3_FILIAL  := TMP->D3_FILIAL
		SD3->D3_TM      := If(TMP->D3_TM=='499','999','499')
		SD3->D3_COD     := TMP->D3_COD
		SD3->D3_UM      := TMP->D3_UM
		SD3->D3_QUANT   := TMP->D3_QUANT
		SD3->D3_CF      := If(TMP->D3_CF=='RE4','DE4','RE4')
		SD3->D3_CONTA   := TMP->D3_CONTA
		SD3->D3_LOCAL   := If(TMP->D3_LOCAL=='01','97','01')
		SD3->D3_DOC     := TMP->D3_DOC
		SD3->D3_EMISSAO := StoD(TMP->D3_EMISSAO)
		SD3->D3_GRUPO   := TMP->D3_GRUPO
		SD3->D3_CUSTO1  := TMP->D3_CUSTO1
		SD3->D3_NUMSEQ  := TMP->D3_NUMSEQ
		SD3->D3_TIPO    := TMP->D3_TIPO
		SD3->D3_USUARIO := TMP->D3_USUARIO
		SD3->D3_CHAVE   := TMP->D3_CHAVE
		SD3->D3_SEQCALC := TMP->D3_SEQCALC
		SD3->D3_LOTECTL := U_RETLOTC6(TMP->D3_XXOP) 
		SD3->D3_DTVALID := StoD(TMP->D3_DTVALID)
		SD3->D3_LOCALIZ := TMP->D3_LOCALIZ
		SD3->D3_USERLGI := TMP->D3_USERLGI
		SD3->D3_USERLGA := TMP->D3_USERLGA
		SD3->D3_HORA    := TMP->D3_HORA
		SD3->D3_XXPECA  := TMP->D3_XXPECA
		SD3->D3_XXOP    := TMP->D3_XXOP
		SD3->( msUnlock() )

		TMP->( dbSkip() )
	End

Return
