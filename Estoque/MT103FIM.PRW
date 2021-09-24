#include "protheus.ch"
#include "topconn.ch"
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅMT103FIM  пїЅAutor  пїЅOPUS MAURICIO     пїЅ Data пїЅ  25/11/19     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅ DescriпїЅпїЅo                                                             пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅO ponto de entrada MT103FIM encontra-se no final            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅda funпїЅпїЅo A103NFISCAL                                       пїЅпїЅпїЅ
пїЅпїЅпїЅEM QUE PONTO                                                           пїЅпїЅпїЅ 
пїЅпїЅпїЅ          пїЅApпїЅs o destravamento de todas as tabelas envolvidas na      пїЅпїЅпїЅ 
пїЅпїЅпїЅ          пїЅgravaпїЅпїЅo do documento de entrada, depois de fechar a        пїЅпїЅпїЅ 
пїЅпїЅпїЅ          пїЅoperaпїЅпїЅo realizada neste.                                   пїЅпїЅпїЅ 
пїЅпїЅпїЅ          пїЅпїЅ utilizado para realizar alguma operaпїЅпїЅo apпїЅs a gravaпїЅпїЅ    пїЅпїЅпїЅ 
пїЅпїЅпїЅ          пїЅda NFE.                                                     пїЅпїЅпїЅ
пїЅпїЅпїЅEventos                                                                пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅPrograma Fonte                                              пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅMATA103.PRW                                                 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
//FILIALMG
USER FUNCTION MT103FIM()
	Local _cQR1
	Local _cQR2
	Local aPergA930
	Local ___x, X
	Local aArea
	Local nOpcao
	Local nConfirma
	Local cFilFiltro
	Local Ne
	Local _aCabSDA    := {}
	Local _aItSDB     := {}
	Local _aItensSDB  := {}
	Local aEndereca   := {}

	If DtoS(Date()) == '20210730'  .and.  'JONAS.OPUS' $ Upper(GetEnvServer()) //.AND. xFilial("SF1") == '02'
		PARAMIXB := {}
		RpcSetEnv("01","02")
		AADD(PARAMIXB, 3)
		AADD(PARAMIXB, 1)
		//SF1->( dbGoTo(137051) )

		nConfirma := 1
		nOpcao := 3
	EndIf

	_cQR1     := ''
	_cQR2     := ''
	aPergA930 := {}
	aArea     := GetArea()
	nOpcao    := PARAMIXB[1]   // Opзгo Escolhida pelo usuario no aRotina
	nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operaзгo de gravaзгo da NFE


	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.


	IF SF1->F1_EST=='EX' // se for importaГ§ГЈo

		_cQR1 :=" UPDATE SD1010 "
		_cQR1 +=" SET D1_DESPESA=(SELECT WN_DESPICM      FROM SWN010 WITH(NOLOCK) WHERE WN_DOC+WN_SERIE+WN_PRODUTO+SUBSTRING(REPLICATE('0', 4 - LEN(WN_LINHA)) + RTrim(WN_LINHA),1,4)=D1_DOC+D1_SERIE+D1_COD+SUBSTRING(D1_ITEM,1,4) AND   D_E_L_E_T_='' )  "
		_cQR1 +=" WHERE D1_DOC='"+SF1->F1_DOC+"' AND D1_SERIE='001' AND D_E_L_E_T_=''  "
		_cQR1 +=" AND EXISTS(SELECT WN_DESPICM FROM SWN010 WHERE WN_DOC+WN_SERIE+WN_PRODUTO+SUBSTRING(REPLICATE('0', 4 - LEN(WN_LINHA)) + RTrim(WN_LINHA),1,4)=D1_DOC+D1_SERIE+D1_COD+SUBSTRING(D1_ITEM,1,4) AND   D_E_L_E_T_='' )  "
		_cQR1 +=" AND (SELECT WN_DESPICM FROM SWN010 WHERE WN_DOC+WN_SERIE+WN_PRODUTO+SUBSTRING(REPLICATE('0', 4 - LEN(WN_LINHA)) + RTrim(WN_LINHA),1,4)=D1_DOC+D1_SERIE+D1_COD+SUBSTRING(D1_ITEM,1,4) AND   D_E_L_E_T_='' )>0   "
		_cQR2 :=" UPDATE SF1010 "
		_cQR2 +=" SET F1_DESPESA=(SELECT SUM(WN_DESPICM) FROM SWN010 WITH(NOLOCK) WHERE WN_DOC+WN_SERIE=F1_DOC+F1_SERIE AND   D_E_L_E_T_='' ) "
		_cQR2 +=" WHERE F1_DOC='"+SF1->F1_DOC+"' AND F1_SERIE='001' AND D_E_L_E_T_='' "
		_cQR2 +=" AND EXISTS(SELECT SUM(WN_DESPICM) FROM SWN010 WHERE WN_DOC+WN_SERIE=F1_DOC+F1_SERIE AND   D_E_L_E_T_='' ) "
		_cQR2 +=" AND (SELECT SUM(WN_DESPICM) FROM SWN010 WHERE WN_DOC+WN_SERIE=F1_DOC+F1_SERIE AND   D_E_L_E_T_='' )>0  "

		TCSQLEXEC(_cQR1)
		TCSQLEXEC(_cQR2)

		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
		//пїЅ Parametros para reprocessar LIVRO FISCAL DE SAIDA	          пїЅ
		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		aPergA930 := {}
		AADD(aPergA930,DTOC(SF1->F1_DTDIGIT))     // Data de Emissao De
		AADD(aPergA930,DTOC(SF1->F1_DTDIGIT))     // Data de Emissao Ate
		AADD(aPergA930,1)                         // 1=Entrada, 2=Saida, 3=Ambos
		AADD(aPergA930,SF1->F1_DOC)               // Nota Fiscal De
		AADD(aPergA930,SF1->F1_DOC)               // Nota Fiscal Ate
		AADD(aPergA930,SF1->F1_SERIE)             // Serie De
		AADD(aPergA930,SF1->F1_SERIE)             // Serie Ate
		AADD(aPergA930,SF1->F1_FORNECE)           // Cliente De
		AADD(aPergA930,SF1->F1_FORNECE)           // Cliente Ate
		AADD(aPergA930,SF1->F1_LOJA)              // Loja De
		AADD(aPergA930,SF1->F1_LOJA)              // Loja Ate

		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
		//пїЅ Reprocessamento do LIVRO FISCAL DE SAIDA                      пїЅ
		//пїЅ                                                               пїЅ
		//пїЅ Param 1 = .T. ou .F. - Processamento via ExecAuto             пїЅ
		//пїЅ Param 2 = Array com os parametros de processamento            пїЅ
		//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
		//MsgRun("Reprocessando Livro Fiscal","Aguarde...",{|| MATA930(.T.,aPergA930) })

		//MATA930(.T.,aPergA930)

	EndIf

	// Transferкncia entre filiais Domex
	If ((SF1->F1_FORNECE=='900000' .AND. SF1->F1_LOJA='01' .and. fwfilial() == "02") .or. (SF1->F1_FORNECE=='004500' .AND. SF1->F1_LOJA='01' .and. fwfilial() == "01")  ) .and. nConfirma == 1 .and. nOpcao == 3

		If SF1->F1_FORNECE=='900000'
			cFilFiltro := "01"
		Else
			cFilFiltro := "02"
		EndIf

		SD1->(DBSETORDER(1))
		If SD1->(dbSeek(xFilial('SD1') + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))

			//Endereзa Material
			While SD1->(!EOF()) .AND. SD1->D1_DOC==SF1->F1_DOC  .AND. SD1->D1_SERIE==SF1->F1_SERIE .AND. SD1->D1_FORNECE==SF1->F1_FORNECE .AND. SD1->D1_LOJA==SF1->F1_LOJA

				SF4->(dbSetOrder(1))
				If SF4->(dbSeek( xFilial("SF4") + SD1->D1_TES))
					If SF4->F4_ESTOQUE == 'S'
						SB1->( dbSetOrder(1))
						SB1->( dbSeek( xFilial() + SD1->D1_COD ))
						If SB1->B1_LOCALIZ == 'S'
							If fwfilial() == "02"
								SDA->(dbSetOrder(RetOrder("SDA","DA_FILIAL+DA_NUMSEQ")))  // DA_FILIAL + DA_NUMSEQ
								If SDA->(dbSeek( xFilial() + SD1->D1_NUMSEQ ))
									If SDA->DA_SALDO != 0

										If U_Validacao() // 23/09/21

											// Tem que melhorar isso. Vai ficar lento no futuro  (tem mais um Seek desse pra baixo)
											XD1->(DBSETORDER(8))
											If XD1->(DbSeek(cFilFiltro + SD1->D1_COD + "95" + "9" )) //ARMAZEM 95 // STATUS 9

												While XD1->(!Eof()) .AND. XD1->XD1_FILIAL == cFilFiltro  .AND. XD1->XD1_COD == SD1->D1_COD .AND. XD1->XD1_LOCAL == "95" .AND. XD1->XD1_OCORRE == "9"
													If XD1->XD1_ZYNOTA  == SF1->F1_DOC .and. XD1->XD1_ZYSERIE == SF1->F1_SERIE .and. XD1->XD1_ZYDTNF  == SF1->F1_EMISSAO .AND. StrZero(VAL(XD1->XD1_ZYITNF),4) == SD1->D1_ITEM	//.AND. XD1->XD1_QTDATU  == SD1->D1_QUANT
														If Empty(XD1->XD1_OP)
															AADD(aEndereca, {SDA->DA_PRODUTO, SDA->DA_NUMSEQ, '0001', SPACE(1), "01RECEBIMENTO", SDA->DA_DATA, SDA->DA_SALDO} )
															Exit
														Else
														    Exit
														EndIf
													EndIf
													XD1->( dbSkip() )
												End
											EndIf
										Else
											AADD(aEndereca, {SDA->DA_PRODUTO, SDA->DA_NUMSEQ, '0001', SPACE(1), "01RECEBIMENTO", SDA->DA_DATA, SDA->DA_SALDO} )
										EndIf
									EndIF
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				SD1->(dbSkip())
			Enddo

			For Ne := 1 to Len(aEndereca)
				///_cLocaliz := "01RECEBIMENTO"
				//Busca o prуximo item no SDB.
				///_cItem := '0001'

				//SDB->(dbSetOrder(1))
				//If SDB->(dbSeek( xFilial("SDB") + SD1->D1_COD + "01" + SD1->D1_NUMSEQ))
				//	While xFilial("SDA") + SDA->DA_PRODUTO + SDA->DA_LOCAL + SDA->DA_NUMSEQ == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ
				//	    If _cItem < SDB->DB_ITEM
				//			_cItem := SDB->DB_ITEM
				//		EndIf
				//		SDB->( dbSkip() )
				//	End
				//	_cItem := StrZero(Val(_cItem)+1,4)
				//EndIf
				lMsErroAuto := .F.

				_aItensSDB := {}

				_aCabSDA := {{"DA_PRODUTO" , aEndereca[Ne][1] ,Nil},;
					{"DA_NUMSEQ"  , aEndereca[Ne][2]  ,Nil}}

				_aItSDB  := {;
					{"DB_ITEM"	  ,aEndereca[Ne][3]	 ,Nil},;
					{"DB_ESTORNO" ,aEndereca[Ne][4]	 ,Nil},;
					{"DB_LOCALIZ" ,aEndereca[Ne][5]	 ,Nil},;
					{"DB_DATA"	  ,aEndereca[Ne][6]	 ,Nil},;
					{"DB_QUANT"   ,aEndereca[Ne][7]	 ,Nil}}
				aadd(_aItensSDB,_aitSDB)

				MATA265( _aCabSDA, _aItensSDB, 3)

				//RestArea(_aAreaSD1)
				If lMsErroAuto .AND. .F.
					MostraErro("\UTIL\LOG\Classificacao\")
					MsgInfo("Erro no endereзamento automбtico.","A T E N З Г O")
				EndIf

			Next Ne

			SD1->(DBSETORDER(1))
			If SD1->(dbSeek(xFilial('SD1') + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))

				While SD1->(!EOF()) .AND. SD1->D1_DOC==SF1->F1_DOC  .AND. SD1->D1_SERIE==SF1->F1_SERIE .AND. SD1->D1_FORNECE==SF1->F1_FORNECE .AND. SD1->D1_LOJA==SF1->F1_LOJA

					aXD1Recno := {}
					XD1->(DBSETORDER(8))

					If XD1->(DbSeek(cFilFiltro + SD1->D1_COD + "95" + "9" )) //ARMAZEM 95 // STATUS 9

						While XD1->(!Eof()) .AND. XD1->XD1_FILIAL == cFilFiltro  .AND. XD1->XD1_COD == SD1->D1_COD .AND. XD1->XD1_LOCAL == "95" .AND. XD1->XD1_OCORRE == "9"

							If XD1->XD1_ZYNOTA  == SF1->F1_DOC .and. XD1->XD1_ZYSERIE == SF1->F1_SERIE .and. XD1->XD1_ZYDTNF  == SF1->F1_EMISSAO .AND. StrZero(VAL(XD1->XD1_ZYITNF),4) == SD1->D1_ITEM	//.AND. XD1->XD1_QTDATU  == SD1->D1_QUANT

								SB1->(DBSEEK(xfilial()+SD1->D1_COD))
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

								If cFilFiltro == '01'
									//ConOut("Antes do a260Processa" + Time())
									If U_VALIDACAO()  // Helio  16/08/21
										lTransfere := .F.
										If SB1->B1_APROPRI == 'I'
											// Definido em 23/09/21 com Sergio e Denis que materiais de apropriaзгo indireta nгo devem ser endereзado
											// e nгo se deve reaproveitar suas etiquetas
											lTransfere := .F.  // .T.
											cAlmoxDest := "01" //"99"
											cLocalDest := "01RECEBIMENTO" //"99PROCESSO"
											cLoteDest  := "LOTE1308"
											cOcorre    := "5"
											//a260Processa(XD1->XD1_COD,"01",XD1->XD1_QTDATU,_cDoc,dDataBase,0,,XD1->XD1_LOTECTL,StoD("20491231"),,"01RECEBIMENTO",XD1->XD1_COD,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
											AADD(aXD1Recno, {XD1->( Recno() ), cAlmoxDest, cLocalDest, cOcorre, cLoteDest, SD1->D1_ITEM } )
										Else
											If ALLTRIM(SB1->B1_GRUPO)=='FO' .OR. ALLTRIM(SB1->B1_GRUPO)=='FOFS'
												// Definido em 23/09/21 com Sergio e Denis que fibras nгo devem ser endereзadas
												// e nгo se deve reaproveitar suas etiquetas
												lTransfere := .F.   // .T.
												cAlmoxDest := "01"
												cLocalDest := "01RECEBIMENTO" // "01CORTE"
												cLoteDest  := "LOTE1308"
												cOcorre    := "5"
												//a260Processa(XD1->XD1_COD,"01",XD1->XD1_QTDATU,_cDoc,dDataBase,0,,XD1->XD1_LOTECTL,StoD("20491231"),,"01RECEBIMENTO",XD1->XD1_COD,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
												AADD(aXD1Recno, {XD1->( Recno() ), cAlmoxDest, cLocalDest, cOcorre, cLoteDest, SD1->D1_ITEM } )
											Else
												If !Empty(XD1->XD1_OP)
													lTransfere := .T.
													cAlmoxDest := "97"
													cLocalDest := "97PROCESSO"
													cLoteDest  := U_RETLOTC6(XD1->XD1_OP)
													cOcorre    := "8"
													a260Processa(XD1->XD1_COD,"01",XD1->XD1_QTDATU,_cDoc,dDataBase,0,,"LOTE1308",StoD("20491231"),,"01RECEBIMENTO",XD1->XD1_COD,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
												Else
													// Definido em 23/09/21 com Sergio e Denis que todo material que nгo estiver destinado a uma OP, ou seja,
													// XD1_OP em branco, nгo deve ser endereзado e nгo se deve reaproveitar suas etiquetas
													lTransfere := .F.
													cAlmoxDest := "01"
													cLocalDest := "01RECEBIMENTO"
													cLoteDest  := 'LOTE1308'
													cOcorre    := "5"  // "4"
													AADD(aXD1Recno, {XD1->( Recno() ), cAlmoxDest, cLocalDest, cOcorre, cLoteDest, SD1->D1_ITEM } )
												EndIf
											EndIf
										EndIf

										If lTransfere
											If lMsErroAuto //.and. .F.
												MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
											Else
												SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
												If SD3->( dbSeek( xFilial() + _cDoc ) )
													While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)    //MLS ALTERADO MOTIVO DOCUMENTO COM 9 DIGITOS
														If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
															If SD3->D3_COD == XD1->XD1_COD
																If SD3->D3_EMISSAO == dDataBase
																	If SD3->D3_QUANT == XD1->XD1_QTDATU
																		If Empty(SD3->D3_XXOP)
																			Reclock("SD3",.F.)
																			SD3->D3_XXPECA  := XD1->XD1_XXPECA
																			SD3->D3_XXOP    := XD1->XD1_OP
																			SD3->D3_USUARIO := Subs(cUsuario,7,14)
																			SD3->D3_HORA    := Time()
																			SD3->( msUnlock() )
																		EndIf
																	EndIf
																EndIf
															EndIf
														EndIf
														SD3->( dbSkip() )
													End

													AADD(aXD1Recno, {XD1->( Recno() ), cAlmoxDest, cLocalDest, cOcorre, cLoteDest, SD1->D1_ITEM } )
												EndIf
											EndIf
										EndIf

									Else // Else do U_VALIDACAO()
										If SB1->B1_APROPRI == 'I'
											cAlmoxDest := "99"
											cLocalDest := "99PROCESSO"
											cLoteDest  := "LOTE1308"
											cOcorre    := "5"
											a260Processa(XD1->XD1_COD,"01",XD1->XD1_QTDATU,_cDoc,dDataBase,0,,XD1->XD1_LOTECTL,StoD("20491231"),,"01RECEBIMENTO",XD1->XD1_COD,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))

										ElseIf ALLTRIM(SB1->B1_GRUPO)=='FO' .OR. ALLTRIM(SB1->B1_GRUPO)=='FOFS'
											cAlmoxDest := "01"
											cLocalDest := "01CORTE"
											cLoteDest  := "LOTE1308"
											cOcorre    := "4"
											a260Processa(XD1->XD1_COD,"01",XD1->XD1_QTDATU,_cDoc,dDataBase,0,,XD1->XD1_LOTECTL,StoD("20491231"),,"01RECEBIMENTO",XD1->XD1_COD,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
										Else
											cAlmoxDest := "97"
											cLocalDest := "97PROCESSO"
											cLoteDest  := U_RETLOTC6(XD1->XD1_OP)
											cOcorre    := "8"
											a260Processa(XD1->XD1_COD,"01",XD1->XD1_QTDATU,_cDoc,dDataBase,0,,"LOTE1308",StoD("20491231"),,"01RECEBIMENTO",XD1->XD1_COD,cAlmoxDest,cLocalDest,.F.,Nil,Nil,"MATA260",,,,,,,,,,,,,,,,,cLoteDest,StoD("20491231"))
										EndIf

										If lMsErroAuto .and. .F.
											MostraErro("\UTIL\LOG\Transferencia_Pagamento\")
										Else
											SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
											If SD3->( dbSeek( xFilial() + _cDoc ) )
												While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)    //MLS ALTERADO MOTIVO DOCUMENTO COM 9 DIGITOS
													If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
														If SD3->D3_COD == XD1->XD1_COD
															If SD3->D3_EMISSAO == dDataBase
																If SD3->D3_QUANT == XD1->XD1_QTDATU
																	If Empty(SD3->D3_XXOP)
																		Reclock("SD3",.F.)
																		SD3->D3_XXPECA  := XD1->XD1_XXPECA
																		SD3->D3_XXOP    := XD1->XD1_OP
																		SD3->D3_USUARIO := Subs(cUsuario,7,14)
																		SD3->D3_HORA    := Time()
																		SD3->( msUnlock() )
																	EndIf
																EndIf
															EndIf
														EndIf
													EndIf
													SD3->( dbSkip() )
												End

												AADD(aXD1Recno, {XD1->( Recno() ), cAlmoxDest, cLocalDest, cOcorre, cLoteDest, SD1->D1_ITEM } )
											EndIf
										EndIf

									EndIf
								EndIf

								If cFilFiltro == '02'
									cAlmoxDest := "01"
									cLocalDest := "01RECEBIMENTO"
									cOcorre    := "3"
									cLoteDest  := "LOTE1308"
									AADD(aXD1Recno, {XD1->( Recno() ), cAlmoxDest, cLocalDest, cOcorre, cLoteDest, SD1->D1_ITEM } )
								EndIf

							EndIf

							XD1->(dbskip())
						EndDo

						For x := 1 to Len(aXD1Recno)
							XD1->( dbGoTo(aXD1Recno[x][1]) )
							If XD1->( Recno() ) == aXD1Recno[x][1]
								Reclock("XD1",.F.)
								XD1->XD1_FILIAL  := fwfilial()
								XD1->XD1_LOCAL   := aXD1Recno[x][2] //SD1->D1_LOCAL
								XD1->XD1_LOCALI  := aXD1Recno[x][3]
								XD1->XD1_OCORRE  := aXD1Recno[x][4]
								XD1->XD1_LOTECT  := aXD1Recno[x][5]
								XD1->XD1_DOC     := SF1->F1_DOC
								XD1->XD1_SERIE   := SF1->F1_SERIE
								XD1->XD1_FORNEC  := SF1->F1_FORNECE
								XD1->XD1_LOJA    := SF1->F1_LOJA
								XD1->XD1_ITEM    := aXD1Recno[x][6]
								XD1->XD1_DTDIGI  := SF1->F1_DTDIGIT

								If !U_VALIDACAO() // Helio  16/08/21
									If aXD1Recno[x][4] == '5' 	//ocorrencia
										XD1->XD1_QTDATU  := 0
									EndIf
								EndIf
								XD1->(MsUnlock())
							EndIf
						Next x
					EndIF


					SD1->(dbSkip())
				Enddo
			EndIf



		EndIf

		RestArea(aArea)
	EndIf

Return( NIL )


