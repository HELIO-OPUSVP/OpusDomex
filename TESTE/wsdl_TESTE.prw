#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"
#INCLUDE "TOTVS.ch"

/* ===============================================================================
WSDL Location    https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/?wsdl
Gerado em        03/25/21 12:54:04
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _LNWMMMR ; Return  // "dummy" function - Internal Use

/* -------------------------------------------------------------------------------
WSDL Service WSNfseWSService
------------------------------------------------------------------------------- */

WSCLIENT WSNfseWSService

    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD RESET
    WSMETHOD CLONE
    WSMETHOD CancelarNfse
    WSMETHOD ConsultarLoteRps
    WSMETHOD ConsultarNfseServicoPrestado
    WSMETHOD ConsultarNfseServicoTomado
    WSMETHOD ConsultarNfsePorFaixa
    WSMETHOD ConsultarNfsePorRps
    WSMETHOD RecepcionarLoteRps
    WSMETHOD GerarNfse
    WSMETHOD SubstituirNfse
    WSMETHOD RecepcionarLoteRpsSincrono

    WSDATA   _URL                      AS String
    WSDATA   _CERT                     AS String
    WSDATA   _PRIVKEY                  AS String
    WSDATA   _PASSPHRASE               AS String
    WSDATA   _HEADOUT                  AS Array of String
    WSDATA   _COOKIES                  AS Array of String
    WSDATA   cnfseCabecMsg             AS string
    WSDATA   cnfseDadosMsg             AS string
    WSDATA   coutputXML                AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNfseWSService
    ::Init()
    If !FindFunction("XMLCHILDEX")
        UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.170117A-20200331] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
    EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNfseWSService
Return

WSMETHOD RESET WSCLIENT WSNfseWSService
    ::cnfseCabecMsg      := NIL
    ::cnfseDadosMsg      := NIL
    ::coutputXML         := NIL
    ::Init()
Return

WSMETHOD CLONE WSCLIENT WSNfseWSService
    Local oClone := WSNfseWSService():New()
    oClone:_URL          := ::_URL
    oClone:_CERT         := ::_CERT
    oClone:_PRIVKEY      := ::_PRIVKEY
    oClone:_PASSPHRASE   := ::_PASSPHRASE
    oClone:cnfseCabecMsg := ::cnfseCabecMsg
    oClone:cnfseDadosMsg := ::cnfseDadosMsg
    oClone:coutputXML    := ::coutputXML
Return oClone

// WSDL Method CancelarNfse of Service WSNfseWSService

WSMETHOD CancelarNfse WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<CancelarNfseRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</CancelarNfseRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/CancelarNfse",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method ConsultarLoteRps of Service WSNfseWSService

WSMETHOD ConsultarLoteRps WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<ConsultarLoteRpsRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</ConsultarLoteRpsRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/ConsultarLoteRps",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method ConsultarNfseServicoPrestado of Service WSNfseWSService

WSMETHOD ConsultarNfseServicoPrestado WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<ConsultarNfseServicoPrestadoRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</ConsultarNfseServicoPrestadoRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/ConsultarNfseServicoPrestado",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method ConsultarNfseServicoTomado of Service WSNfseWSService

WSMETHOD ConsultarNfseServicoTomado WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<ConsultarNfseServicoTomadoRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</ConsultarNfseServicoTomadoRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/ConsultarNfseServicoTomado",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method ConsultarNfsePorFaixa of Service WSNfseWSService

WSMETHOD ConsultarNfsePorFaixa WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<ConsultarNfsePorFaixaRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</ConsultarNfsePorFaixaRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/ConsultarNfsePorFaixa",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method ConsultarNfsePorRps of Service WSNfseWSService

WSMETHOD ConsultarNfsePorRps WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<ConsultarNfsePorRpsRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</ConsultarNfsePorRpsRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/ConsultarNfsePorRps",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method RecepcionarLoteRps of Service WSNfseWSService

WSMETHOD RecepcionarLoteRps WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<RecepcionarLoteRpsRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</RecepcionarLoteRpsRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/RecepcionarLoteRps",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method GerarNfse of Service WSNfseWSService

WSMETHOD GerarNfse WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<GerarNfseRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</GerarNfseRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/GerarNfse",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method SubstituirNfse of Service WSNfseWSService

WSMETHOD SubstituirNfse WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<SubstituirNfseRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</SubstituirNfseRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,;
        "http://nfse.abrasf.org.br/SubstituirNfse",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    END WSMETHOD

    oXmlRet := NIL
Return .T.

// WSDL Method RecepcionarLoteRpsSincrono of Service WSNfseWSService

WSMETHOD RecepcionarLoteRpsSincrono WSSEND cnfseCabecMsg,cnfseDadosMsg WSRECEIVE coutputXML WSCLIENT WSNfseWSService
    Local cSoap := "" , oXmlRet

    BEGIN WSMETHOD

    cSoap += '<RecepcionarLoteRpsSincronoRequest xmlns="http://nfse.abrasf.org.br">'
    cSoap += WSSoapValue("nfseCabecMsg", ::cnfseCabecMsg, cnfseCabecMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += WSSoapValue("nfseDadosMsg", ::cnfseDadosMsg, cnfseDadosMsg , "string", .T. , .F., 0 , NIL, .F.,.F.)
    cSoap += "</RecepcionarLoteRpsSincronoRequest>"

    oXmlRet := SvcSoapCall(Self,cSoap,; 
        "http://nfse.abrasf.org.br/RecepcionarLoteRpsSincrono",;
    "DOCUMENT","http://nfse.abrasf.org.br",,,;
    "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    ::Init()
    ::coutputXML         :=  WSAdvValue( oXmlRet,"_OUTPUT:_OUTPUTXML:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

    msgalert('metodo')

    END WSMETHOD

    oXmlRet := NIL
Return .T.

//===================================================================

User Function nfsetst1()
    Local oWS


    Private  _xcFile      :='' // CONTEÚDO DO CERTIFICADO
    private  _xcSignature :='' // ASSINATURA
    cXML2 :=''
    MSGALERT('V3')

    cCAB1:='<LoteRps versao="2.00" Id="lot">'
    //cCAB1+='<NumeroLote>042</NumeroLote>'

    cTXT:=""
    cTXT+="<CpfCnpj>"
    cTXT+="<Cnpj>61980272000190</Cnpj>"
    cTXT+="</CpfCnpj>"
    cTXT+="<InscricaoMunicipal>19920</InscricaoMunicipal>"
    cTXT+="<QuantidadeRps>1</QuantidadeRps>"
    cTXT+="<ListaRps>"
    cTXT+="<Rps>"
    cTXT+='<InfDeclaracaoPrestacaoServico Id="rps">'"
    cTXT+="<Rps>"
    cTXT+="<IdentificacaoRps>"
    cTXT+="<Numero>042</Numero>"
    cTXT+="<Serie>RPS</Serie>"
    cTXT+="<Tipo>1</Tipo>"
    cTXT+="</IdentificacaoRps>"
    cTXT+="<DataEmissao>2021-03-27</DataEmissao>"
    cTXT+="<Status>1</Status>"
    cTXT+="</Rps>"
    cTXT+="<Competencia>2021-03-26</Competencia>"
    cTXT+="<Servico>"
    cTXT+="<Valores>"
    cTXT+="<ValorServicos>1.00</ValorServicos>"
    cTXT+="<ValorIss>0.30</ValorIss>"
    cTXT+="<Aliquota>0.00</Aliquota>"
    cTXT+="</Valores>"
    cTXT+="<IssRetido>2</IssRetido>"
    cTXT+="<ResponsavelRetencao>1</ResponsavelRetencao>"
    cTXT+="<ItemListaServico>17.05</ItemListaServico>"
    cTXT+="<CodigoCnae>7820500</CodigoCnae>"
    cTXT+="<CodigoTributacaoMunicipio>17.05</CodigoTributacaoMunicipio>"
    cTXT+="<Discriminacao>NOTA FISCAL PARA TESTE</Discriminacao>"
    cTXT+="<CodigoMunicipio>3524402</CodigoMunicipio>"
    cTXT+="<ExigibilidadeISS>1</ExigibilidadeISS>"
    cTXT+="<MunicipioIncidencia>3524402</MunicipioIncidencia>"
    cTXT+="</Servico>"
    cTXT+="<Prestador>"
    cTXT+="<CpfCnpj>"
    cTXT+="<Cnpj>61980272000190</Cnpj>"
    cTXT+="</CpfCnpj>"
    cTXT+="<InscricaoMunicipal>19920</InscricaoMunicipal>"
    cTXT+="</Prestador>"
    cTXT+="<Tomador>"
    cTXT+="<IdentificacaoTomador>"
    cTXT+="<CpfCnpj>"
    cTXT+="<Cnpj>61980272000190</Cnpj>"
    cTXT+="</CpfCnpj>"
    cTXT+="</IdentificacaoTomador>"
    cTXT+="<RazaoSocial>SHA COMERCIO DE ALIMENTOS LTDA</RazaoSocial>"
    cTXT+="<Endereco>"
    cTXT+="<Endereco>Avenida LUCAS NOGUEIRA GARCEZ</Endereco>"
    cTXT+="<Numero>2600</Numero>"
    cTXT+="<Bairro>CIDADE NOVA JACAREI</Bairro>"
    cTXT+="<CodigoMunicipio>3524402</CodigoMunicipio>"
    cTXT+="<Uf>SP</Uf>"
    cTXT+="<Cep>12325000</Cep>"
    cTXT+="</Endereco>"
    cTXT+="<Contato>"
    cTXT+="<Telefone>12333333</Telefone>"
    cTXT+="</Contato>"
    cTXT+="</Tomador>"
    cTXT+="<RegimeEspecialTributacao>6</RegimeEspecialTributacao>"
    cTXT+="<OptanteSimplesNacional>1</OptanteSimplesNacional>"
    cTXT+="<IncentivoFiscal>2</IncentivoFiscal>"
    cTXT+="</InfDeclaracaoPrestacaoServico>"
    cTXT+='<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
    cTXT+="<SignedInfo>"
    cTXT+='<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
    cTXT+='<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>'
    cTXT+='<Reference URI="#rps">'
    cTXT+="<Transforms>"
    cTXT+='<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>'
    cTXT+='<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
    cTXT+="</Transforms>"
    cTXT+='<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>'
    cTXT+="<DigestValue>IOlOnpt3RANfd2LVOGRIm2OFqC8=</DigestValue>"
    cTXT+="</Reference>"
    cTXT+="</SignedInfo>"
    cTXT+="<SignatureValue>uJK+7hsEJCB5HqLq6+eVmaqFTEK3boyc0RuwNw+OBj1/URAzikVBqq48VpZqsSOOcQ8rn9y4ZS2go9wciWuwPH2lq/Arn7ZwjxE0PT5Tc1P7kjtAB8g1kWLlf8KXEbmYUP17gEfXUeqZUqKa8RaJZejBiH5pxReOTCZ2GKs3WLeTv+KcvAEWgqhmJcR01Offade5/5mZQzBneiqpNbiMzFQbZV/yI2hR23AIVVqlOdeO4INYw2QyatWkLwmYGAUJIHdcsQfXjx0Br2sx6L2kK2Vy6OE+usebyT5Id1QlakRTKQE0FYhHUYgcLnT3hYWhi0HLsKeqN3RWQgnsIeZEMg==</SignatureValue>"
    cTXT+="<KeyInfo>"
    cTXT+="<X509Data>"
    cTXT+='<X509Certificate>MIIICjCCBfKgAwIBAgIQSiKXUwD6UZlgMzaWZJD/QTANBgkqhkiG9w0BAQsFADB4MQswCQYDVQQGEwJCUjETMBEGA1UEChMKSUNQLUJyYXNpbDE2MDQGA1UECxMtU2VjcmV0YXJpYSBkYSBSZWNlaXRhIEZlZGVyYWwgZG8gQnJhc2lsIC0gUkZCMRwwGgYDVQQDExNBQyBDZXJ0aXNpZ24gUkZCIEc1MB4XDTE3MTAyNDE2NDYxMFoXDTE4MTAyNDE2NDYxMFowgfgxCzAJBgNVBAYTAkJSMRMwEQYDVQQKDApJQ1AtQnJhc2lsMQswCQYDVQQIDAJTUDEPMA0GA1UEBwwGTG9yZW5hMTYwNAYDVQQLDC1TZWNyZXRhcmlhIGRhIFJlY2VpdGEgRmVkZXJhbCBkbyBCcmFzaWwgLSBSRkIxFjAUBgNVBAsMDVJGQiBlLUNOUEogQTExIjAgBgNVBAsMGUF1dGVudGljYWRvIHBvciBBUiBGQUNFU1AxQjBABgNVBAMMOVRIRSBIT1VTRSBMT1JFTkEgRVNDT0xBIERFIElESU9NQVMgTFREQSBNRTowNzkxNTMzMjAwMDE0NTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMF15jrlDvtKVvfY5VXRfn7cWDEdJQD44Ow1fmb7aNwsWSE/udSMKxr/7rcSU++DDx+MCJ/aLhXEWYJrkhtc1rBUGn/ge2S6yqHtXIT/G8yAZLHDHHDvW4qtLPmXIvbfN3SHf0xj/TeLM8xmdTJug3Jks3YwVs2QKrtLBUjtiwEIb3Y1k7v9bvBBqPCIsnZAy22nrMkchjBIs8veTFseswRbEDolzwbTovyr1mi4wql5LNHz/a9ZP8sJd3F7T00/L1PADsFqPFo9Pqz2i8NwMnHzuzXeHAeVgrlF5xx43TvJtcwserYQzUxFmjqwQGGPg13LRS/8NZVyGv8LB6akWwUCAwEAAaOCAw0wcTXT+="ggMJMIG8BgNVHREEgbQwgbGgPQYFYEwBAwSgNAQyMjgwMzE5NzMyNzA1ODc3MjgyNzAwMDAwMDAwMDAwMDAwMDAwMjIzMzc2NzYwU1NQU1CgIwYFYEwBAwKgGgQYQ0FJTyBFVUdFTklPIFJPTkRPTiBMQUhSoBkGBWBMAQMDoBAEDjA3OTE1MzMyMDAwMTQ1oBcGBWBMAQMHoA4EDDAwMDAwMDAwMDAwMIEXY2Fpb0B0aGVob3VzZWxvcmVuYS5jb20wCQYDVR0TBAIwADAfBgNVHSMEGDAWgBRTfX+dvtFh0CC62p/jiacTc1jNQjB/BgNVHSAEeDB2MHQGBmBMAQIBDDBqMGgGCCsGAQUFBwIBFlxodHRwOi8vaWNwLWJyYXNpbC5jZXJ0aXNpZ24uY29tLmJyL3JlcG9zaXRvcmlvL2RwYy9BQ19DZXJ0aXNpZ25fUkZCL0RQQ19BQ19DZXJ0aXNpZ25fUkZCLnBkZjCBvAYDVR0fBIG0MIGxMFegVaBThlFodHRwOi8vaWNwLWJyYXNpbC5jZXJ0aXNpZ24uY29tLmJyL3JlcG9zaXRvcmlvL2xjci9BQ0NlcnRpc2lnblJGQkc1L0xhdGVzdENSTC5jcmwwVqBUoFKGUGh0dHA6Ly9pY3AtYnJhc2lsLm91dHJhbGNyLmNvbS5ici9yZXBvc2l0b3Jpby9sY3IvQUNDZXJ0aXNpZ25SRkJHNS9MYXRlc3RDUkwuY3JsMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgawGCCsGAQUFBwEBBIGfMIGcMF8GCCsGAQUFBzAChlNodHRwOi8vaWNwLWJyYXNpbC5jZXJ0aXNpZ24uY29tLmJyL3JlcG9zaXRvcmlvL2NlcnRpZmljYWRvcy9BQ19DZXJ0aXNpZ25fUkZCX0c1LnA3YzA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AtYWMtY2VydGlzaWduLXJmYcTXT+="i5jZXJ0aXNpZ24uY29tLmJyMA0GCSqGSIb3DQEBCwUAA4ICAQB3UvY0zY5Q1m34vEzGHxHy4bopdWnP32GDcGLPeKh0EsTSyMUCe6uKOYOPIbXdI7NRBihwkes9LdrWV/e3X90+7zSw+sJuPqNc9T1WzjRhe1QSM29FHi58OFDsZL5Wg2EilTLZtP3KeImiAYYcv9ihnz4h69q104KxDdXH1uaDGUMzQKz6w041Ku6kZefjiwz8+6GaJpx4z6s/jPlMoWHL4jxwQOnamK3ZALdiqJv0VvSwQ9IlBsInr584y0CjSs4hs5d5+X94hNWjw+QEA8MfvhD+GAUVYdrScu7txoMTeW3Opl09RYO6jjGICy7cTw6/JgCJ6cui4nMa3h6t/ivboz+GzAYOwmMZySDw72ZPLofm2NAf3r6iZ00iSTDvyZms70br00f1IBmO8fNdgwHzNAsXjnxjpfTnOyZ0afCW0Kf/oGhECL24hjZuera95fkeJ95W+6KLXqFGnwTRBuC7vR5DedUqiSEhAPD7W7SBn6aXuKlbDYQmeu/YjIgvcjiWP/waHr5Pm9SErWvgk1B2tNJSzD0DVfVis1ZGO4CTNF/9Z+C5uj6D+BuAouxgjEAXREIUz0NGBEl+WIFrClvMfAdRqv25jG2VZBY/0JmRsrxQ1OcXpNdPhwB92ZPex+I2ZexgfRm4IrHcaltj+ez2GkAh058hsieXCh0ze0j0SA==</X509Certificate>'
    cTXT+="</X509Data>"
    cTXT+="</KeyInfo>"
    cTXT+="</Signature>"
    cTXT+="</Rps>"
    cTXT+="</ListaRps>"
    cTXT+="</LoteRps>"

    //GERAR E ASSINAR XML=======================
    nASSINAT:=0
    cXML2:=U_T206SIGN()
    MSGALERT(cXML2)

    //ASSINATURA 2

    _CCAB1:='<EnviarLoteRpsSincronoEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">'
    _CCAB1+='<LoteRps versao="2.00" Id="lot">'
    _CCAB1+='<NumeroLote>000000041</NumeroLote>'
    _CCAB1+='<CpfCnpj><Cnpj>61980272000190</Cnpj></CpfCnpj>'
    _CCAB1+='<InscricaoMunicipal>19920</InscricaoMunicipal>'
    _CCAB1+='<QuantidadeRps>1</QuantidadeRps>'
    _CCAB1+='<ListaRps>'
    //_CCAB1:='<Rps>'

    //_cRODA1:='</Rps>'
    _cRODA1:='</ListaRps>'
    _cRODA1+='</LoteRps>'
    _cRODA1+='</EnviarLoteRpsSincronoEnvio>'

    cXML2:=_CCAB1+cXML2+_cRODA1

    cXML3:=U_T206SIGN(cXML2)

    //_CCAB2:='<EnviarLoteRpsSincronoEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">'
    //_CCAB2+='<LoteRps versao="2.02" Id="lot">'
    //_CCAB2+='<NumeroLote>041</NumeroLote>'
    //_CCAB2+='<CpfCnpj><Cnpj>61980272000190</Cnpj></CpfCnpj>'
    //_CCAB2+='<InscricaoMunicipal>19920</InscricaoMunicipal>'
    // _CCAB2+='<QuantidadeRps>1</QuantidadeRps>'
    // _CCAB2+='<ListaRps>'

    //_cRODA2:='</ListaRps>'
    //_cRODA2+='</LoteRps>'
    //_cRODA2+='</EnviarLoteRpsSincronoEnvio>'



    //GERAR E ASSINAR XML=======================
    // Cria a instância da classe client
    oWs :=  WSNfseWSService():New()

    //cCAB1:='<LoteRps versao="2.00" Id="lot"><NumeroLote>041</NumeroLote>'
    //cXML3:=substr(cXML2,61,len(cXML2))
    ///////cCAB1:='<LoteRps versao="2.00" Id="lot">'   //<NumeroLote>041</NumeroLote>' //<---------

cCAB1:='<?xml version="1.0" encoding="UTF-8"?>'
cCAB1+='<cabecalho xmlns="http://www.abrasf.org.br/nfse.xsd" versao="0.01">'
cCAB1+='<versaoDados>2.00</versaoDados>'
cCAB1+='</cabecalho>'


    //cXML3:=cXML2
    oWS:cnfseCabecMsg :=cCAB1
    oWS:cnfseDadosMsg :=cXML3

    //oWS:_CERT       := _xcFile 
    oWS:_CERT       := "\certificate\Certificado_ago2020_C3rtdigi_sh@_cert.pem"//"D:\TOTVS12\01-Oficial\Protheus_Data\CERTIFICATE\certificado_ago2020_c3rtdigi_sh@_cert.pem"//_xcFile 
    oWS:_PRIVKEY    := "\certificate\Certificado_ago2020_C3rtdigi_sh@_key.pem"//_xcSignature
    oWS:_URL        := "https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php"  //"http://nfse.abrasf.org.br/RecepcionarLoteRpsSincrono"
    oWS:_PASSPHRASE := "C3rtdigi_sh@" //"Sha@61980272"
    //"https://siap.jacarei.sp.gov.br/pmjacarei/issonline/ws/index.php")

    // Habilita informações de debug no log de console
    WSDLDbgLevel(3)
    // Chama o método do Web Service

    If oWs:RecepcionarLoteRpsSincrono()
        msgalert('x1')
        //Retorno .T. //, solicitação enviada e recebida com sucesso
        MsgStop('recepcionar ok')
        //MsgStop("Fator de conversão: "+cValToChar(oWS:nConversionRateResult),"Requisição Ok")
        //MsgStop("Por exemplo, 100 reais compram "+cValToChar(100 * oWS:nConversionRateResult )+" Dólares Americanos.")
    Else
        //Retorno .F., recupera e mostra string com detalhes do erro
        MsgStop(GetWSCError(),"Erro de Processamento")
    Endif
    MsgStop(cTXT)
    MsgStop(oWS:coutputXML)
Return

//=================ASSINATURA ELETRONICA ==================================================
// BIBLIOTECAS NECESSÁRIAS
//#Include "TOTVS.ch"

//--------------------------------------------------
// ASSINA UM ARQUIVO XML DIGITALMENTE
//--------------------------------------------------
User Function T206SIGN(cXML2)
    Local cXML       As Character // CONTEÚDO XML
    Local cDigest    As Character // VALOR DE RESUMO DO ARQUIVO
    Local cSignInfo  As Character // CORPO DE INFORMAÇÕES DE ASSINATURA
    Local cPassword  As Character // SENHA PARA LEITURA DO CERTIFICADO
    Local cSignature As Character // CORPO DA ASSINATURA E CERTIFICADO
    Local aCertific  As Array     // VETOR DE CERTIFICADOS
    nASSINAT:=nASSINAT+1

    // PREPARAÇÃO DE AMBIENTE EM CASO DE ESTADO DE JOB
    If (!IsBlind())
        RPCSetEnv("01", "01")
    EndIf

    // INICIALIZAÇÃO DE VARIÁVEIS
    cPassword  := "C3rtdigi_sh@"  //"SUA_SENHA_AQUI"
    //cPassword  := "nfse000002"  //"SUA_SENHA_AQUI"
    IF nASSINAT==1
        cXML       := GetXMLFile("dirdoc", "TESTE00000041.xml")
    ELSE
        cXML       := cXML2
    ENDIF
    cXMLDIG:='<CpfCnpj><Cnpj>61980272000190</Cnpj></CpfCnpj><InscricaoMunicipal>19920</InscricaoMunicipal>'
    

cXMLDIG:='<Rps>'
cXMLDIG+='<IdentificacaoRps>'
cXMLDIG+='<Numero>000000041</Numero>'
cXMLDIG+='<Serie>RPS</Serie>'
cXMLDIG+='<Tipo>1</Tipo>'
cXMLDIG+='</IdentificacaoRps>'
cXMLDIG+='<DataEmissao>2021-04-05</DataEmissao>'
cXMLDIG+='<Status>1</Status>'
cXMLDIG+='</Rps>'
cXMLDIG+='<Competencia>2021-04-05</Competencia>'
cXMLDIG+='<Servico>'
cXMLDIG+='<Valores>'
cXMLDIG+='<ValorServicos>1.00</ValorServicos>'
cXMLDIG+='<ValorIss>0.03</ValorIss>'
cXMLDIG+='<Aliquota>3.00</Aliquota>'
cXMLDIG+='</Valores>'
cXMLDIG+='<IssRetido>2</IssRetido>'
cXMLDIG+='<ResponsavelRetencao>1</ResponsavelRetencao>'
cXMLDIG+='<ItemListaServico>17.05</ItemListaServico>'
cXMLDIG+='<CodigoCnae>7820500</CodigoCnae>'
cXMLDIG+='<CodigoTributacaoMunicipio>17.05</CodigoTributacaoMunicipio>'
cXMLDIG+='<Discriminacao>NOTA FISCAL PARA TESTE</Discriminacao>'
cXMLDIG+='<CodigoMunicipio>3524402</CodigoMunicipio>'
cXMLDIG+='<ExigibilidadeISS>1</ExigibilidadeISS>'
cXMLDIG+='<MunicipioIncidencia>3524402</MunicipioIncidencia>'
cXMLDIG+='</Servico>'
cXMLDIG+='<Prestador>'
cXMLDIG+='<CpfCnpj>'
cXMLDIG+='<Cnpj>61980272000190</Cnpj>'
cXMLDIG+='</CpfCnpj>'
cXMLDIG+='<InscricaoMunicipal>19920</InscricaoMunicipal>'
cXMLDIG+='</Prestador>'
cXMLDIG+='<Tomador>'
cXMLDIG+='<IdentificacaoTomador>'
cXMLDIG+='<CpfCnpj>'
cXMLDIG+='<Cnpj>61980272000190</Cnpj>'
cXMLDIG+='</CpfCnpj>'
cXMLDIG+='</IdentificacaoTomador>'
cXMLDIG+='<RazaoSocial>SHA COMERCIO DE ALIMENTOS LTDA</RazaoSocial>'
cXMLDIG+='<Endereco>'
cXMLDIG+='<Endereco>Ave CEZ</Endereco>'
cXMLDIG+='<Numero>2600</Numero>'
cXMLDIG+='<Bairro>CIDADE NOVA JACAREI</Bairro>'
cXMLDIG+='<CodigoMunicipio>3524402</CodigoMunicipio>'
cXMLDIG+='<Uf>SP</Uf>'
cXMLDIG+='<Cep>12325000</Cep>'
cXMLDIG+='</Endereco>'
cXMLDIG+='<Contato>'
cXMLDIG+='<Telefone>12333333</Telefone>'
cXMLDIG+='</Contato>'
cXMLDIG+='</Tomador>'
cXMLDIG+='<RegimeEspecialTributacao>6</RegimeEspecialTributacao>'
cXMLDIG+='<OptanteSimplesNacional>1</OptanteSimplesNacional>'
cXMLDIG+='<IncentivoFiscal>2</IncentivoFiscal>'
cXMLDIG+='</InfDeclaracaoPrestacaoServico>'
cXMLDIG+='</Rps>'
    cDigest    := GetDigest(cXMLDIG) //--916b2f9732c0d4aab4d6684a346af3db7eb20e81
    //cDigest    := GetDigest(cXML) //--916b2f9732c0d4aab4d6684a346af3db7eb20e81
    //cDigest    :='MXbckFSlyBwH/Imt2E7T1EG5lxA='  //   <------digest
    aCertific  := GetCertificate("\certificate", "Certificado_ago2020_C3rtdigi_sh@", cPassword)
    //aCertific  := GetCertificate("\certificate", "nfse000002", cPassword)

    cSignInfo  := GetSignInfo(Space(0), cDigest)
    cSignature := GetSignature(aCertific, cSignInfo, cPassword)

    // MONTA O XML COMPLETO
    cXML := BuildXML(cXML, cSignature)

    // SALVA O .XML COMPLETO NO CTRL+C
    CopyToClipboard(cXML)

    // ENCERRAMENTO DE AMBIENTE EM CASO DE ESTADO DE JOB
    If (!IsBlind())
        RPCClearEnv()
    EndIf
Return(cXML)

//--------------------------------------------------
// RETORNA O XML A SER ASSINADO
//--------------------------------------------------
Static Function GetXMLFile(cPath As Character, cFile As Character)
    Local oFile As Object    // OBJETO DE ACESSO AO ARQUIVO .XML
    Local cXML  As Character // CONTEÚDO DO ARQUIVO .XML

    // INICIALIZAÇÃO DE VARIÁVEIS
    cXML  := Space(0)
    oFile := FwFileReader():New(cPath + "/" + cFile) // CAMINHO ABAIXO DO ROOTPATH

    // SE FOR POSSÍVEL ABRIR O ARQUIVO, LEIA-O
    // SE NÃO, EXIBA O ERRO DE ABERTURA
    If (oFile:Open())
        cXML := oFile:FullRead() // EFETUA A LEITURA DO ARQUIVO
    Else
        Final("Couldn't find/open file: " + cPath + "/" + cFile)
    EndIf

    // NORMALIZA O XML DA ASSINATURA
    cXML := XMLSerialize(cXML)
Return (cXML)

//--------------------------------------------------
// CALCULA O VALOR DO DIGEST
//--------------------------------------------------
Static Function GetDigest(cXML As Character)
    Local cDigest As Character // VALOR DE RESUMO DO ARQUIVO

    // INICIALIZAÇÃO DE VARIÁVEIS
    cDigest := Space(0)

    // CANONIZA O XML E CALCULA O DIGEST
    cXML    := XMLSerialize(cXML)
    cDigest := Encode64(EVPDigest(cXML, 3))
    //cDigest :=SHA1(cXML,1) //teste
    //cDigest :=Encode64(cDigest)//teste
    //cErrStr :=' ' 
    //cDigest2:=EVPPrivSign( "\certificate\Certificado_ago2020_C3rtdigi_sh@_key.pem", cXML, 3,"C3rtdigi_sh@", cErrStr  )
    //cDigest2:= Encode64(cDigest2)
    //cDigest:=cDigest2
    //cDigest:='MXbckFSlyBwH/Imt2E7T1EG5lxA=</'  //<--------------------------
Return (cDigest)

//--------------------------------------------------
// RETORNA O CAMINHO PARA OS ARQUIVOS (*CA.PEM,
// *KEY.PEM E *CERT.PEM)
//--------------------------------------------------
Static Function GetCertificate(cCertPath As Character, cFileName As Character, cPassword As Character)
    Local aCertific As Array     // VETOR DE CERTIFICADOS
    Local cFullPath As Character // CAMINHO RELATIVO COMPLETO
    Local cError    As Character // ERROS DE GERAÇÃO DE CERTIFICADO
    Local lFind     As Logical   // VALIDADOR DE EXTRAÇÃO DE CERTIFICADO

    // INICIALIZAÇÃO DE VARIÁVEIS
    lFind     := .F.
    aCertific := {}
    cCertPath := cCertPath + "\"
    cFullPath := Space(0)
    cError    := Space(0)

    // PROPRIEDADES PARA ARQUIVO *.CA
    cError    := Space(0)
    cFullPath := cCertPath + cFileName + "_ca.pem"
    lFind     := File(cFullPath)

    // VERIFICA SE O ARQUIVO JÁ EXISTE,
    // CASO NÃO EFETUA A CRIAÇÃO
    If (!lFind)
        If (PFXCA2PEM(cCertPath + cFileName + ".pfx", cFullPath, @cError, cPassword))
            ConOut(Repl("-", 80))
            ConOut(MemoRead(cFullPath))
            ConOut(Repl("-", 80))
        Else
            ConOut(Repl("-", 80))
            ConOut(PadC("ERROR: Couldn't extract *_CA certificate", 80))
            ConOut(Repl("-", 80))
        EndIf
    EndIf

    // ADICIONA O CAMINHO NO RETORNO
    AAdd(aCertific, {"CA", cFullPath, lFind})

    // PROPRIEDADES PARA ARQUIVO *.KEY
    cError    := Space(0)
    cFullPath := cCertPath + cFileName + "_key.pem"
    lFind     := File(cFullPath)

    // VERIFICA SE O ARQUIVO JÁ EXISTE,
    // CASO NÃO EFETUA A CRIAÇÃO
    If (!lFind)
        If (PFXKey2PEM(cCertPath + cFileName + ".pfx", cFullPath, @cError, cPassword))
            ConOut(Repl("-", 80))
            ConOut(MemoRead(cFullPath))
            ConOut(Repl("-", 80))
        Else
            ConOut(Repl("-", 80))
            ConOut(PadC("ERROR: Couldn't extract *_KEY certificate", 80))
            ConOut(Repl("-", 80))
        EndIf
    EndIf

    // ADICIONA O CAMINHO NO RETORNO
    AAdd(aCertific, {"KEY", cFullPath, lFind})

    // PROPRIEDADES PARA ARQUIVO *.CERT
    cError    := Space(0)
    cFullPath := cCertPath + cFileName + "_cert.pem"
    lFind     := File(cFullPath)

    // VERIFICA SE O ARQUIVO *.CERT JÁ EXISTE,
    // CASO NÃO EFETUA A CRIAÇÃO
    If (!lFind)
        If (PFXCert2PEM(cCertPath + cFileName + ".pfx", cFullPath, @cError, cPassword))
            ConOut(Repl("-", 80))
            ConOut(MemoRead(cFullPath))
            ConOut(Repl("-", 80))
        Else
            ConOut(Repl("-", 80))
            ConOut(PadC("ERROR: Couldn't extract *_CERT certificate", 80))
            ConOut(Repl("-", 80))
        EndIf
    EndIf

    // ADICIONA O CAMINHO NO RETORNO
    AAdd(aCertific, {"CERT", cFullPath, lFind})

    // VERIFICA SE OS CERTIFICADOS BÁSICOS FORAM EXTRAÍDOS
    If (!aCertific[2][3] .And. !aCertific[3][3])
        Final("ERROR: Couldn't extract any certificate")
    EndIf
Return (aCertific)

//--------------------------------------------------
// CALCULA O SIGNEDINFO DA ASSINATURA
//--------------------------------------------------
Static Function GetSignInfo(cURI As Character, cDigest As Character)
    Local cSignInfo As Character // CORPO DO SIGNEDINFO

    // INICIALIZAÇÃO DE VARIÁVEIS
    cSignInfo := Space(0)

    // MONTAGEM DO SIGNEDINFO
    //cSignInfo += '<SignedInfo xmlns="http://www.w3.org/2000/09/xmldsig#">'
    cSignInfo += '<SignedInfo>'
    cSignInfo += '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
    cSignInfo += '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>'
    IF nASSINAT==1
        //cSignInfo += '<Reference URI="#rps">'  000000041
        cSignInfo += '<Reference URI="#000000041">'
    ELSE
        //cSignInfo += '<Reference URI="#lot">'
        cSignInfo += '<Reference URI="#000000041">'
    ENDIF
    cSignInfo += '<Transforms>'
    cSignInfo += '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>'
    cSignInfo += '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
    cSignInfo += '</Transforms>'
    cSignInfo += '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>'
    cSignInfo += '<DigestValue>' + cDigest + '</DigestValue>
    //cSignInfo += '<DigestValue>KGyzLXOVtokbOxSZyOOcW3FSos8=</DigestValue>'
    cSignInfo += '</Reference>'
    cSignInfo += '</SignedInfo>'

    // NORMALIZA O XML DA ASSINATURA
    cSignInfo := XMLSerialize(cSignInfo)
Return(cSignInfo)

//--------------------------------------------------
// GERA O CORPO DA ASSINATURA
//--------------------------------------------------
Static Function GetSignature(aCertific As Array, cSignInfo As Character, cPassword As Character)
    Local oFile      As Object    // OBJETO DE ACESSO AO CERTIFICADO
    Local cFile      As Character // CONTEÚDO DO CERTIFICADO
    Local cError     As Character // ERROS DURANTE A CONVERSÃO
    Local cXMLSign   As Character // CORPO .XML DA ASSINATURA
    Local cSignature As Character // ASSINATURA

        // INICIALIZAÇÃO DE VARIÁVEIS
    cFile      := Space(0)
    cError     := Space(0)
    cXMLSign   := Space(0)
    cSignature := Encode64(EVPPrivSign(aCertific[AScan(aCertific, {|aCert|aCert[1] == "KEY"})][2], cSignInfo, 3, cPassword, @cError))
    oFile      := FwFileReader():New(aCertific[AScan(aCertific, {|aCert|aCert[1] == "CERT"})][2])

    // SE FOR POSSÍVEL ABRIR O ARQUIVO, LEIA-O
    // SE NÃO, EXIBA O ERRO DE ABERTURA
    If (oFile:Open())
        cFile := oFile:FullRead() // EFETUA A LEITURA DO ARQUIVO
    Else
        Final("Couldn't find/open file: " + cCertPath)
    EndIf

    // REMOVE A LINHA "BEGIN CERTIFICATE" E "END CERTIFICATE"
    cFile := SubStr(cFile, At("BEGIN CERTIFICATE", cFile) + 22)
    cFile := SubStr(cFile, 1, At("END CERTIFICATE", cFile) - 6)
    /*
    oClone:_CERT         := ::_CERT
    oClone:_PRIVKEY      := ::_PRIVKEY
    */
     // oWS:_CERT    := cFile
     // oWS:_PRIVKEY := cSignature
    _xcFile      :=cFile // CONTEÚDO DO CERTIFICADO
    _xcSignature :=cSignature // ASSINATURA
    // GERA A ESTRUTURA DE ASSINATURA DO .XML
    /*
    cXMLSign += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
    cXMLSign += cSignInfo
    cXMLSign += '<SignatureValue>' + cSignature + '</SignatureValue>'
    cXMLSign += '<KeyInfo>'
    cXMLSign += '<X509Data>'
    cXMLSign += '<X509Certificate>' + cFile + '</X509Certificate>'
    cXMLSign += '</X509Data>'
    cXMLSign += '</KeyInfo>'
    cXMLSign += '</Signature>'*/

    cXMLSign += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
    cXMLSign += cSignInfo
    cXMLSign += '<SignatureValue>' + cSignature + '</SignatureValue>'
    cXMLSign += '<KeyInfo>'
    cXMLSign += '<X509Data>'
    cXMLSign += '<X509Certificate>' + cFile + '</X509Certificate>'
    cXMLSign += '</X509Data>'
    cXMLSign += '</KeyInfo>'
    cXMLSign += '</Signature>'
    // NORMALIZA O XML DA ASSINATURA
    cXMLSign := XMLSerialize(cXMLSign)
Return (cXMLSign)

//--------------------------------------------------
// SERIALIZA O XML NORMALIZANDO-O
//--------------------------------------------------
Static Function XMLSerialize(cXML)
    Local cError   As Character // ERROS DURANTE A CONVERSÃO
    Local cWarning As Character // AVISOS DURANTE A CONVERSÃO

    // INICIALIZAÇÃO DE VARIÁVEIS
    cError   := Space(0)
    cWarning := Space(0)

    // REMOVE SALTOS DE LINHA
    cXML := StrTran(cXML, Chr(10), Space(0))
    cXML := StrTran(cXML, Chr(13), Space(0))

    // REMOVE ESPAÇOS EM BRANCO
    While (At("> ", cXML) > 0)
        cXML := StrTran(cXML, "> ", ">")
    End

    While (At(" <", cXML) > 0)
        cXML := StrTran(cXML, " <", "<")
    End

    While (At(" </", cXML) > 0)
        cXML := StrTran(cXML, " </", "</")
    End

    // CANONIZA O XML
       cXML := XMLC14N(cXML, Space(0), @cError, @cWarning)  //mls verificar
Return (cXML)

//--------------------------------------------------
// MONTA O ARQUIVO .XML
//--------------------------------------------------
Static Function BuildXML(cXML As Character, cSignature As Character)
    Local cTag     As Character // TAG DO CORPO
    Local cNode    As Character // TAG A SER REMOVIDA
    Local cFullXML As Character // XML COMPLETO

    // INICIALIZAÇÃO DE VARIÁVEIS
    cTag     := "LoteRps"  //"nfd"
    cNode    := Space(0)
    cFullXML := Space(0)

    // REMOVE A ÚLTIMA TAG
    //cNode := SubStr(cXML, At("</" + cTag + ">", cXML) + Len(cTag) + 3)
    //cNode := SubStr(cXML, At("</" + cTag + " "   , cXML) + Len(cTag) + 3)
    //cXML  := SubStr(cXML, 1, At("</" + cTag + ">", cXML) + Len(cTag) + 2)
    //cNode :="</LoteRps>"
    //cXML  := SubStr(cXML, 1, At("</LoteRps>", cXML) - 1)//Len(cTag) + 2)  ///mla 2 para 1

    // NORMALIZA O XML DA ASSINATURA
    //cFullXML := XMLSerialize(cXML + cSignature + cNode)
    IF nASSINAT==1
        //cXML     := SubStr(cXML, 1, At("</Rps>", cXML) - 1)
        cXML     := SubStr(cXML, 1, At("</InfDeclaracaoPrestacaoServico></Rps>", cXML) +31)
        cFullXML := XMLSerialize(cXML + cSignature+"</Rps>")
    else
        //cFullXML := XMLSerialize('<EnviarLoteRpsSincronoEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">'+cXML + cSignature+'</EnviarLoteRpsSincronoEnvio>')
        cXML     := SubStr(cXML, 1, At("</EnviarLoteRpsSincronoEnvio>", cXML) - 1)//Len(cTag) + 2)  ///mla 2 para 1
        cFullXML := XMLSerialize(cXML + cSignature+"</EnviarLoteRpsSincronoEnvio>")
    endif
    msgstop(cFullXML)
Return (cFullXML)
