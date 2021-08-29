#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWSOpus  บAutor  ณHelio Ferreira       บ Data ณ  13/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Gen้rica de chamada do WebService OpusVP            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fWSOpus(aVetorIn,cTipo)
	Local oWs      := NIL
	Local cParam1  := "USUARIO"
	Local cParam2  := "SENHA"
	Local cVetorIN := ""
	Local _Retorno := 0
	Local x

	cVetorIn := cTipo + VtoC(aVetorIn)

	oWs := WSSINCTABOPUS():New()

	oWs:MtRetTabelas(cParam1,cParam2,cVetorIn)
    //If oWs:MtRetTabelas(cParam1,cParam2,cVetorIn)
    //If Type("oWs:oWSMTRETTABELASRESULT:nNRet_ValLog") <> "U" 

	If oWs:oWSMTRETTABELASRESULT:nNRet_ValLog == 1

		_cVetorOut := oWs:oWSMTRETTABELASRESULT:ccVetorOut

		aVetorOut  := CtoV(_cVetorOut)

		If cTipo == "C" //.or. cTipo == "R"

			_Retorno   := Len(aVetorOut)

			aExports    := {}
			cCamposUPD  := ""
			_cZ4RetCham := ""
			_nRecnoMEMO := 0
			_cZ4LINHA   := ""

			If Len(aVetorOut) > 0
				For x := 1 to Len(aVetorOut)
					nTemp := aScan(aExports,{ |aVet| aVet[1] == aVetorOut[x,2]} )
					If nTemp == 0
						cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName(aVetorOut[x,1]) + " WHERE Z4_EXPORT = '"+StrZero(aVetorOut[x,2],10)+"' "
						If Select("QUERYSZ4") <> 0
							QUERYSZ4->( dbCloseArea() )
						EndIf
						TCQUERY cQuery NEW ALIAS "QUERYSZ4"
						If QUERYSZ4->( EOF() )
							dbSelectArea(aVetorOut[x,1])
							Reclock(aVetorOut[x,1],.T.)
							Z4_EXPORT := StrZero(aVetorOut[x,2],10)
							msUnlock()

							nRecno := Recno()
							AADD(aExports,{aVetorOut[x,2],nRecno})
						Else
							nRecno := QUERYSZ4->R_E_C_N_O_
							AADD(aExports,{aVetorOut[x,2],nRecno})
						EndIf
					Else
						nRecno := aExports[nTemp,2]
					EndIf

					If SZ4->( FieldPos(aVetorOut[x,3]) ) == 0 .and. aVetorOut[x,3] <> "D_E_L_E_T_"
						MsgStop("Campo " + aVetorOut[x,3] + " nใo criado neste ambiente!" )
						Return
						//Exit
					EndIf

					If !Empty(aVetorOut[x,4])
						If ValType(aVetorOut[x,4]) == "C"
							If Alltrim(aVetorOut[x,3]) <> "Z4_RETCHAM" //.and. Alltrim(aVetorOut[x,3]) <> "Z4_LINHA"
								_cContOut := fTrataRet(aVetorOut[x,4])
								cCamposUPD +=  Alltrim(aVetorOut[x,3]) + " = '" + StrTran(_cContOut,"'","") + "',"
							Else
								If Alltrim(aVetorOut[x,3]) == "Z4_RETCHAM"
									_cZ4RetCham := fTrataRet(aVetorOut[x,4])
								EndIf
								//If Alltrim(aVetorOut[x,3]) <> "Z4_LINHA"
								//	_cZ4LINHA   := fTrataRet(aVetorOut[x,4])
								//EndIf
							EndIf
						Else
							If ValType(aVetorOut[x,4]) == "N"
								cCamposUPD += Alltrim(aVetorOut[x,3]) + " = " + Str(aVetorOut[x,4]) + ","
							Else
								If ValType(aVetorOut[x,4]) == "D"
									cCamposUPD += Alltrim(aVetorOut[x,3]) + " = " + DtoS(aVetorOut[x,4]) + ","
								EndIf
							EndIf
						EndIf
					EndIf

					If x == Len(aVetorOut)
						cCamposUPD := Subs(cCamposUPD,1,Len(cCamposUPD)-1)
						TCSQLEXEC("UPDATE " + RetSqlName(aVetorOut[x,1]) + " SET " + cCamposUPD + " WHERE R_E_C_N_O_ = " + Str(nRecno))
						cCamposUPD := ""
						If aVetorOut[x,1] == "SZ4"
							If !Empty(_cZ4RetCham)
								SZ4->( dbGoTo(nRecno) )
								Reclock("SZ4",.F.)
								SZ4->Z4_RETCHAM := _cZ4RetCham
								SZ4->( msUnlock() )
								_cZ4RetCham     := ""
							EndIf
							//If !Empty(_cZ4LINHA)
							//	SZ4->( dbGoTo(nRecno) )
							//	Reclock("SZ4",.F.)
							//	SZ4->Z4_LINHA := _cZ4LINHA
							//	SZ4->( msUnlock() )
							//	_cZ4LINHA     := ""
							//EndIf
						EndIf
					Else
						If aVetorOut[x,2] <> aVetorOut[x+1,2]
							cCamposUPD := Subs(cCamposUPD,1,Len(cCamposUPD)-1)
							//TCSQLEXEC("UPDATE " + RetSqlName(aVetorOut[x,1]) + " SET " + cCamposUPD + " WHERE R_E_C_N_O_ = " + Str(nRecno))
							TCSQLEXEC("UPDATE " + RetSqlName(aVetorOut[x,1]) + " SET " + cCamposUPD + " WHERE R_E_C_N_O_ = " + Str(nRecno))
							cCamposUPD := ""
							If aVetorOut[x,1] == "SZ4"
								If !Empty(_cZ4RetCham)
									SZ4->( dbGoTo(nRecno) )
									Reclock("SZ4",.F.)
									SZ4->Z4_RETCHAM := _cZ4RetCham
									SZ4->( msUnlock() )
									_cZ4RetCham     := ""
								EndIf
							EndIf
						EndIf
					EndIf

					// Mudando o Status do chamado sincronizado
					SZ4->( dbGoto(nRecno) )
					If !Empty(SZ4->Z4_CHAMADO)
						SZJ->( dbSetOrder(1) )
						If SZJ->( dbSeek( xFilial() + SZ4->Z4_CHAMADO ) )
							If SZJ->ZJ_CLASSIF == '7'	// Chamado com pend๊ncia de envio para o sistema Opus
								Reclock("SZJ",.F.)
								SZJ->ZJ_CLASSIF := '3'
								SZJ->( msUnlock() )

								Reclock("SZK",.T.)
								SZK->ZK_FILIAL  := xFilial("SZK")
								SZK->ZK_NUMCHAM := SZJ->ZJ_NUMCHAM
								SZK->ZK_NUMINTE := U_fZKITEM(SZJ->ZJ_NUMCHAM)
								SZK->ZK_DT_INC  := Date()
								SZK->ZK_HR_INC  := Time()
								SZK->ZK_ORIGEM  := "T"
								SZK->ZK_COD_ORI := __cUserID
								SZK->ZK_NOMEORI := UsrRetName("000000")
								SZK->ZK_DESCRIC := "Confirma็ใo de envio do chamado para Consultoria OpusVP."
								SZK->( msUnlock() )

							EndIf
						EndIf
					EndIf

				Next x
			EndIf

			U_ATUCHAMA()   // Fun็ใo que atualiza os chamados como retorno Opus
		Else
			If cTipo == "N"
				//MsgYesNo("aVetorOut[1] " + aVetorOut[1,1]      )
				//MsgYesNo("aVetorOut[2] " + aVetorOut[1,2]      )
				//MsgYesNo("aVetorOut[3] " + Str(aVetorOut[1,3]) )
				_Retorno := aVetorOut[1,3]
			EndIf
		EndIf
	Else
		//MsgInfo("Login para atualiza็ใo dos projetos nใo efetuado. IP ServidOpus: " + GetMV("MV_XIPOPUS"))
	EndIf
//Else
//	MsgInfo("Login para atualiza็ใo dos projetos nใo efetuado")
//EndIf
//Else
//	MsgYesNo('Erro de Execu็ใo : '+GetWSCError())
//Endif

Return _Retorno



/* ===============================================================================
WSDL Location    http://191.255.241.246:88/SINCTABOPUS.apw?WSDL
Gerado em        10/01/14 23:06:10
Observa็๕es      C๓digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera็๕es neste arquivo podem causar funcionamento incorreto
                 e serใo perdidas caso o c๓digo-fonte seja gerado novamente.
=============================================================================== */

User Function _QSNJQQN ; Return  // "dummy" function - Internal Use

/* -------------------------------------------------------------------------------
WSDL Service WSSINCTABOPUS
------------------------------------------------------------------------------- */

	WSCLIENT WSSINCTABOPUS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD MTRETTABELAS

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCREC_COD                 AS string
	WSDATA   cCREC_PASS                AS string
	WSDATA   cCVETORIN                 AS string
	WSDATA   oWSMTRETTABELASRESULT     AS SINCTABOPUS_SINCTABOPUSOUT

	ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSINCTABOPUS
::Init()
	If !FindFunction("XMLCHILDEX")
	UserException("O C๓digo-Fonte Client atual requer os executแveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o C๓digo-Fonte novamente utilizando o Build atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSINCTABOPUS
	::oWSMTRETTABELASRESULT := SINCTABOPUS_SINCTABOPUSOUT():New()
Return

WSMETHOD RESET WSCLIENT WSSINCTABOPUS
	::cCREC_COD          := NIL 
	::cCREC_PASS         := NIL 
	::cCVETORIN          := NIL 
	::oWSMTRETTABELASRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSINCTABOPUS
Local oClone := WSSINCTABOPUS():New()
	oClone:_URL          := ::_URL 
	oClone:cCREC_COD     := ::cCREC_COD
	oClone:cCREC_PASS    := ::cCREC_PASS
	oClone:cCVETORIN     := ::cCVETORIN
	oClone:oWSMTRETTABELASRESULT :=  IIF(::oWSMTRETTABELASRESULT = NIL , NIL ,::oWSMTRETTABELASRESULT:Clone() )
Return oClone

// WSDL Method MTRETTABELAS of Service WSSINCTABOPUS

WSMETHOD MTRETTABELAS WSSEND cCREC_COD,cCREC_PASS,cCVETORIN WSRECEIVE oWSMTRETTABELASRESULT WSCLIENT WSSINCTABOPUS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MTRETTABELAS xmlns="http://'+Alltrim(GetMV("MV_XIPOPUS"))+'/">'
cSoap += WSSoapValue("CREC_COD", ::cCREC_COD, cCREC_COD , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CREC_PASS", ::cCREC_PASS, cCREC_PASS , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CVETORIN", ::cCVETORIN, cCVETORIN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MTRETTABELAS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://"+Alltrim(GetMV("MV_XIPOPUS"))+"/MTRETTABELAS",; 
	"DOCUMENT","http://"+Alltrim(GetMV("MV_XIPOPUS"))+"/",,"1.031217",; 
	"http://"+Alltrim(GetMV("MV_XIPOPUS"))+"/SINCTABOPUS.apw")

::Init()
::oWSMTRETTABELASRESULT:SoapRecv( WSAdvValue( oXmlRet,"_MTRETTABELASRESPONSE:_MTRETTABELASRESULT","SINCTABOPUSOUT",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure SINCTABOPUSOUT

WSSTRUCT SINCTABOPUS_SINCTABOPUSOUT
	WSDATA   cCVETOROUT                AS string
	WSDATA   nNRET_VALLOG              AS integer
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT SINCTABOPUS_SINCTABOPUSOUT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT SINCTABOPUS_SINCTABOPUSOUT
Return

WSMETHOD CLONE WSCLIENT SINCTABOPUS_SINCTABOPUSOUT
	Local oClone := SINCTABOPUS_SINCTABOPUSOUT():NEW()
	oClone:cCVETOROUT           := ::cCVETOROUT
	oClone:nNRET_VALLOG         := ::nNRET_VALLOG
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT SINCTABOPUS_SINCTABOPUSOUT
	::Init()
If oResponse = NIL ; Return ; Endif
	::cCVETOROUT         :=  WSAdvValue( oResponse,"_CVETOROUT","string",NIL,"Property cCVETOROUT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNRET_VALLOG       :=  WSAdvValue( oResponse,"_NRET_VALLOG","integer",NIL,"Property nNRET_VALLOG as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return


Static Function VtoC(aVetorIN)
Local _Retorno := ""
Local x,y

// # = " aspas duplas
// ~ = , virgula

	For x := 1 to Len(aVetorIN)
   _Retorno += '{'
		For y := 1 to Len(aVetorIN[x])
			If Valtype(aVetorIN[x,y]) == 'C'
        _Retorno += "C"+StrTran(aVetorIN[x,y],',','~')
			EndIf
			If Valtype(aVetorIN[x,y]) == 'N'
        _Retorno += "N"+Alltrim(Str(aVetorIN[x,y]))
			EndIf
			If Valtype(aVetorIN[x,y]) == 'D'
        _Retorno += "D"+DtoS(aVetorIN[x,y])
			EndIf
     
			If y <> Len(aVetorIN[x])
        _Retorno += ','
			EndIf
		Next y
   _Retorno += '}'
	Next x

Return _Retorno


Static Function CtoV(cVetorIN)
Local _Retorno := {}
Local x, y
Local nPIni  := 0
Local nPFiM  := 0
Local aLinha := {}

// # = " aspas duplas
// ~ = , virgula

	For x := 1 to Len(cVetorIN)
		If Subs(cVetorIN,x,1) == '{'  // Abrindo array
      nPIni := x+1
		EndIf
   
		If Subs(cVetorIN,x,1) == '}'  // Fechando array
      nPFim := x-1
		EndIf
   
		If nPIni <> 0 .and. nPFim <> 0
      aLinha := {}
      cLinha := ','+Subs(cVetorIN,nPIni,nPFim-nPIni+1)+','
      
			For y := 1 to Len(cLinha)-1
				If Subs(cLinha,y,1) == ','
            nY2 := AT(",",Subs(cLinha,y+1))
					If Subs(cLinha,y+1,1) == "C"
               AADD(aLinha,StrTran(Subs(cLinha,y+2,nY2-2),'~',','))
					EndIf
					If Subs(cLinha,y+1,1) == "N"
               AADD(aLinha,Val(Subs(cLinha,y+2,nY2-2)))
					EndIf
					If Subs(cLinha,y+1,1) == "D"
               AADD(aLinha,StoD(Subs(cLinha,y+2,nY2-2)))
					EndIf
				EndIf
			Next y
      
      AADD(_Retorno,aLinha)
      
      nPIni :=  0
      nPFim :=  0
		EndIf
   
	Next x

Return _Retorno

Static Function fTrataRet(_cVetorOut)
Local _Retorno := _cVetorOut

	If Valtype(_cVetorOut) == "C"
   _Retorno := StrTran(_Retorno,"/%/&/*/@/!/'/","{")
   _Retorno := StrTran(_Retorno,"\%\&\*\@\!\'\","}")
	EndIf

Return _Retorno
