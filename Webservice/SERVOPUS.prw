#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

User Function SERVOPUS()

Local oWs := NIL

If Type("cEmpAnt") == 'U'
	RPCSetType(3)
	aAbreTab := {}
	RpcSetEnv("01","01",,,,,aAbreTab)
EndIf

oWs := WSSERVOPUS():New()

If oWs:SERVIDOPUS_ON()
	If Date() <= StoD("20170602")
		cAssunto := "ServidOpus ON (servidor Domex)"
		cTexto   := oWs:cSERVIDOPUS_ONRESULT
		cPara    := "helio.celular@opusvp.com.br"
		cCC      := Nil
		cArquivo := Nil
		
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	EndIf
	//alert('Url do Site : '+ oWs:cSERVIDOPUS_ONRESULT)
Else
	nTentativas := 0
	While Type("oWs") == 'U' .and. nTentativas <= 10
	   nTentativas++
		oWs := WSSERVOPUS():New()
	End
	
	If If(Type("oWs") == 'U',.T.,If(!oWs,.T.,.F.))
		cAssunto := "ServidOpus OFF - Tentativas: " + Alltrim(Str(nTentativas))
		cTexto   := "Data: " + DtoC(Date()) + " Hora: " + Time()
		cPara    := "helio.celular@opusvp.com.br"
		cCC      := Nil
		cArquivo := Nil
		
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	Else
	   If Date() <= StoD("20170602")
			cAssunto := "ServidOpus +- retornou na tentativa " + Alltrim(Str(nTentativas))
			cTexto   := "Data: " + DtoC(Date()) + " Hora: " + Time()
			cPara    := "helio.celular@opusvp.com.br"
			cCC      := Nil
			cArquivo := Nil
	
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		EndIf
	EndIf
Endif

Return



/* ===============================================================================
WSDL Location    http://191.255.241.246:88/SERVOPUS.apw?WSDL
Gerado em        10/13/14 15:25:47
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _WKADSPR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSERVOPUS
------------------------------------------------------------------------------- */

WSCLIENT WSSERVOPUS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD SERVIDOPUS_ON

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cSERVIDOPUS_ONRESULT      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSERVOPUS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSERVOPUS
Return

WSMETHOD RESET WSCLIENT WSSERVOPUS
	::cSERVIDOPUS_ONRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSERVOPUS
Local oClone := WSSERVOPUS():New()
	oClone:_URL          := ::_URL 
	oClone:cSERVIDOPUS_ONRESULT := ::cSERVIDOPUS_ONRESULT
Return oClone

// WSDL Method SERVIDOPUS_ON of Service WSSERVOPUS

WSMETHOD SERVIDOPUS_ON WSSEND NULLPARAM WSRECEIVE cSERVIDOPUS_ONRESULT WSCLIENT WSSERVOPUS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SERVIDOPUS_ON xmlns="http://'+Alltrim(GetMV("MV_XIPOPUS"))+'/">'
cSoap += "</SERVIDOPUS_ON>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://"+Alltrim(GetMV("MV_XIPOPUS"))+"/SERVIDOPUS_ON",; 
	"DOCUMENT","http://"+Alltrim(GetMV("MV_XIPOPUS"))+"/",,"1.031217",; 
	"http://"+Alltrim(GetMV("MV_XIPOPUS"))+"/SERVOPUS.apw")

::Init()
::cSERVIDOPUS_ONRESULT :=  WSAdvValue( oXmlRet,"_SERVIDOPUS_ONRESPONSE:_SERVIDOPUS_ONRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



