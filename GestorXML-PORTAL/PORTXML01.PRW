
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PORTXML01  ºAutor  ³Marco Aurelio-OPUSVPº Data ³ 11/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Portal XML - Protocolo de NF                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PORTXML01(cChave)

// Define Variaveis                                          

Private _cChave    	:= cChave    //Numero da Chave que foi Amarrada
Private _cEmpresa 	:= ""
Private _cValor   	:= ""
Private _cNota		:= ""
Private _dData		:= "" 
Private _cProtocol	:= ""
Private _dtProtocol	:= "" 
Private lReturn 	:= .F.


	// Chave da NF Eletronica
//	_cChave   := cChave //  ZZ0->ZZ0_CHVNFE

	// Dados da Empresa
	_cEmpresa:=ZZ0->ZZ0_DENOME

	// Dados da Nota
	_cNota	:= ZZ0->ZZ0_SERIE + "-" + ZZ0->ZZ0_DOC
	_dData	:= DTOC(ZZ0->ZZ0_DTEMIS)
	_cValor	:= ZZ0->ZZ0_VLRTOT

	//Dados do protocolo Gerado
	_cProtocol	:=	"335577/99"	// GERAR NUMERO DE PROTOCOLO
	_dtProtocol	:=  "25/12/2019"    // DATA GRAVADA DO PROTOCOLO


	// Cria Diretorio Local para HTML
	cPath := AllTrim(GetTempPath())
	
	// Abre Protocolo no Browser
	U_FGEN009("\WORKFLOW\MODELOS\PORTALXML-Protocolo.html", 		"C:\Windows\Temp\PORTALXML-Protocolo.html")			// Abre Recibo do Financeiro

	// Envia Protocolo por email
	cTit 	:= "Rosenberger - Protocolo do Portal XML " + _cProtocol
	cMsg	:= ""
	cEmail	:= "xxxx@gmail.com"
	cArquivo:= "C:\Windows\Temp\PORTALXML-Protocolo.html"   //"\WORKFLOW\MODELOS\PORTALXML-Protocolo.html"
	U_EnvMailto(cTit,cMsg,cEmail,"",cArquivo)

Return
