#Include 'Protheus.ch'
#INCLUDE "RWMAKE.ch"
#Include "TbiConn.ch"
#INCLUDE "TOPCONN.CH"


User Function SITBOPS2(lMsgRun)

	Default lMsgRun := 'F'

	If lMsgRun == 'T'
		FWMsgRun(, {|oSay| RunProc() }, "Processando", "Processando a rotina...")
	Else
		RunProc()
	EndIf

Return

Static Function RunProc()

	Local cTmpTXT := ""
	Local cLinha  := ""
	Local x:=0
	Local n:=0

	RPCSetType(3)  // Nao utilizar licensa

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"  USER 'MRP' PASSWORD 'MRP' TABLES  "SZJ" , "SZK" , "SZ4"

	SetUserDefault("000000")

	SZJ->( dbSetOrder(1) )
	SZK->( dbSetOrder(1) )
	SZ4->( dbSetOrder(1) )

	*--------------------------------------------------------------------------------------------------------------------------*

	//Static Function ProcRun2(nMaxReg)

	Private aVetorIn := {}
	Private nMaxReg :=10

	//If Type("cEmpAnt") == 'U'
	//	aAbreTab := {}
	//	RPCSetType(3)
	//	RpcSetEnv("01", "01",,,,,aAbreTab)
	//	SetUserDefault("000000")
	//EndIf

	// Enviando os chamados pendentes de envio

	cQuery := "SELECT ZJ_NUMCHAM FROM " + RetSqlName("SZJ") + " WHERE ZJ_TIPO = '1' AND ZJ_CLASSIF = '7' AND ZJ_STATUS <> 'F'  AND D_E_L_E_T_ = '' "

	If Select("QSZJ") <> 0
		QSZJ->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QSZJ"

	If !QSZJ->( EOF() )
		While !QSZJ->( EOF() )
			SZJ->( dbSetOrder(1) )
			If SZJ->( dbSeek( xFilial() + QSZJ->ZJ_NUMCHAM ) )
				cZ4_MEMO   := ""
				cInteracao := ""
				SZK->( dbSetOrder(1) ) // Interações
				If SZK->( dbSeek( xFilial() + SZJ->ZJ_NUMCHAM ) )
					nPrimeira := 1
					While !SZK->( EOF() ) .and. SZK->ZK_NUMCHAM == SZJ->ZJ_NUMCHAM
						cCaracIni := "|"
						cCaracFim := "|"
						nTamanho  := 74
						cTmpTXT   := SZK->ZK_DESCRIC
						cTmpTXT   := StrTran(              Strtran(cTmpTXT,chr(10),"")         ,chr(13),"#$#$#$")

						aTmpTXT   := StrToKarr(cTmpTXT,"#$#$#$")
						cTmpTXT   := ""
						For x := 1 to Len(aTmpTXT)
							cLinha  := aTmpTXT[x]
							If Len(cLinha) <= nTamanho
								cTmpTXT += cCaracIni + cLinha + Space(nTamanho-Len(cLinha))+cCaracFim+Chr(13)
							Else
								aLinhas := U_QuebraString(cLinha,nTamanho)
								For n := 1 to Len(aLinhas)
									cTmpTXT += cCaracIni + aLinhas[n] + Space(nTamanho-Len(aLinhas[n]))+cCaracFim+Chr(13)
								Next n
							EndIf
						Next x

						If nPrimeira == 1
							cZ4_MEMO += "+--------------------------------------------------------------------------+" + Chr(13)
						EndIf
						cZ4_MEMO +=    "|##CHAMADO:" + SZK->ZK_NUMCHAM + " INTERAÇÃO:" + SZK->ZK_NUMINTE + " | " + DtoC(SZK->ZK_DT_INC) + " | " + SZK->ZK_HR_INC + " | " + SUBS(SZK->ZK_NOMEORI,1,18) + " |" + Chr(13)
						cZ4_MEMO +=    "+--------------------------------------------------------------------------+" + Chr(13)
						cZ4_MEMO +=    cTmpTXT
						cZ4_MEMO +=    "+--------------------------------------------------------------------------+" + Chr(13)

						cInteracao := SZK->ZK_NUMINTE
						nPrimeira++
						SZK->( dbSkip() )
					End
				EndIf
				SZ4->( dbSetOrder(1) )
				If SZ4->( dbSeek( xFilial() + SZJ->ZJ_Z4COD ) )

					aVetorIn := {}
					AADD(aVetorIn,{"SZ4","Z4_CODIGO" , "######"                  })
					AADD(aVetorIn,{"SZ4","Z4_CLIENTE", "000012"                  })
					AADD(aVetorIn,{"SZ4","Z4_LOJA"   , "01"                      })
					AADD(aVetorIn,{"SZ4","Z4_NOMECLI", "DOMEX"                   })
					AADD(aVetorIn,{"SZ4","Z4_DESC"   , SZJ->ZJ_Z4DESC            })
					AADD(aVetorIn,{"SZ4","Z4_NIVEL"  , "3"                       })
					AADD(aVetorIn,{"SZ4","Z4_SUPN1"  , SZ4->Z4_SUPN1             })
					AADD(aVetorIn,{"SZ4","Z4_SUPERIO", SZJ->ZJ_Z4COD             })
					AADD(aVetorIn,{"SZ4","Z4_DTCAD"  , Date()                    })
					AADD(aVetorIn,{"SZ4","Z4_DTAUTOR", Date()                    })
					AADD(aVetorIn,{"SZ4","Z4_COBRANC", "2"                       })
					AADD(aVetorIn,{"SZ4","Z4_TXTCHAM", cZ4_MEMO                  })
					AADD(aVetorIn,{"SZ4","Z4_CHAMADO", SZJ->ZJ_NUMCHAM           })
					AADD(aVetorIn,{"SZ4","Z4_ITEMCHA", cInteracao                })
					AADD(aVetorIn,{"SZ4","Z4_RELATO" , "S"                       })
					AADD(aVetorIn,{"SZ4","Z4_MSBLQL" , "2"                       })
					AADD(aVetorIn,{"SZ4","Z4_CONSULT", SZJ->ZJ_Z4CONSU           })
					//AADD(aVetorIn,{"SZ4","Z4_SEPFAT" , "000001"                  })
					AADD(aVetorIn,{"SZ4","Z4_LINHA"  , "ZZZZZZZZZZZZZZZ"         })

					//If MsgNoYes("Deseja aguardar o envio do chamado para o SistemOpus (Yes) ou coloca-lo na fila de envio (No)")
					U_fWSOpus(aVetorIn,"R")
					//	MsgInfo("Chamado gravado com sucesso")
					//Else
					//U_GravaSZ4(aVetorIn,"R")
					//MsgInfo("Chamado colocado na fila para ser incluído no SistemOpus")
					//EndIf

				EndIf
			EndIf
			QSZJ->( dbSkip() )
		End
	EndIf


	dbSelectArea("SZ4")

	cQuery := "SELECT MAX(Z4_VERSAO) AS MAX FROM SZ4010 "
	If Select("MAXSZ4") <> 0
		MAXSZ4->(dbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "MAXSZ4"

	aVetorIn := {}
	AADD(aVetorIn,{"SZ4",Val(MAXSZ4->MAX),"Z4_CLIENTE = '000012'"})

	n := U_fWSOpus(aVetorIn,"N")

	nTentativas := 0
	While n <> 0 .and. nTentativas < nMaxReg
		nTentativas++

		MsgRun("Processando sincronização de " + Alltrim(Str(n)) + " registros.","Processamento: " + Alltrim(Str(nTentativas))+ "/"+Alltrim(Str(nMaxReg)) + " Ultimo Z4_VERSAO sinc.:" + MAXSZ4->MAX,{|| ProcRun()} )
		//ProcRun()

		cQuery := "SELECT MAX(Z4_VERSAO) AS MAX FROM SZ4010 "

		If Select("MAXSZ4") <> 0
			MAXSZ4->(dbCloseArea())
		EndIf

		TCQUERY cQuery NEW ALIAS "MAXSZ4"

		aVetorIn := {}

		AADD(aVetorIn,{"SZ4",Val(MAXSZ4->MAX),"Z4_CLIENTE = '000012'","1"})

		n := U_fWSOpus(aVetorIn,"N")

		//If n == 0
		//	MsgInfo("Sincronização concluída")
		//EndIf
	End

	StartJob( "WFLauncher", GetEnvServer(), .F., { "WFSndMsgAll", { cEmpAnt, cFilAnt } } )

	*--------------------------------------------------------------------------------------------------------------------------*
	//RESET ENVIRONMENT
	*--------------------------------------------------------------------------------------------------------------------------*
Return

	*--------------------------------------------------------------------------------------------------------------------------*
Static Function ProcRun()
Local cRet := ""

	cQuery := "SELECT MAX(Z4_VERSAO) AS MAX FROM SZ4010 "

	If Select("MAXSZ4") <> 0
		MAXSZ4->(dbCloseArea())
	EndIf

	TCQUERY cQuery NEW ALIAS "MAXSZ4"

	aVetorIn := {}

	AADD(aVetorIn,{"SZ4",Val(MAXSZ4->MAX),"Z4_CLIENTE = '000012'","1"})

	cRet := U_fWSOpus(aVetorIn,"C")

Return

	*--------------------------------------------------------------------------------------------------------------------------*
//User Function SincSZ4(lEspera)

//Default lEspera := .F.
//startjob("U_SITBOPUS",getenvserver(),lEspera )

//Return
	*--------------------------------------------------------------------------------------------------------------------------*

//User Function GravaSZ4(aVetorIn,cTipo)  // Função chamada do fonte CadSZJ.prw quando o usuário escolhe não esperar para sincronizar o envio do chamado

//startjob("U_JobGRVSZ4",getenvserver(),.F., aVetorIn,cTipo )

//Return

	*--------------------------------------------------------------------------------------------------------------------------*
//User Function JobGRVSZ4(aVetorIn,cTipo)

//aAbreTab := {}
//RPCSetType(3)
//RpcSetEnv("01", "01",,,,,aAbreTab)
//SetUserDefault("000000")

//U_fWSOpus(aVetorIn,cTipo)

//Return

	*--------------------------------------------------------------------------------------------------------------------------*
