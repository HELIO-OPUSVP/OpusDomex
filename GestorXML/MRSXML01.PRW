#include "totvs.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "print.ch"
#include "font.ch"
#include "colors.ch"
#include "Protheus.ch"
#include "Rwmake.ch"
#include "FIVEWIN.CH"
#include "MSOBJECT.CH

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto>;
	=> oprn:say(<nLinha>*50+100, <nColuna>*30+40, transform(<cTexto>, ''), ofntN10,,CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> FONT <oFonte>;
	=> oprn:say(<nLinha>*50+100, <nColuna>*25+40, transform(<cTexto>, ''), <oFonte>,,CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture>;
	=> oprn:say(<nLinha>*50+100, <nColuna>*30+40, transform(<cTexto>, <cPicture>), ofntN10,,CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture> FONT <oFonte>;
	=> oprn:say(<nLinha>*50+100, <nColuna>*25+40, transform(<cTexto>, <cPicture>), <oFonte>,,CLR_BLACK)

#xcommand @ <nLinha1>, <nColuna1> to <nLinha2>, <nColuna2>;
	=> oprn:box(<nLinha1>*50+100, <nColuna1>*25+40, <nLinha2>*50+100 , <nColuna2>*25+40)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMRSXML01  บAutor  ณMarco Aurelio Silva บ Data ณ  09/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบProg.ORI  ณACOMA001  บAutor  ณFelipe Aurelio      บ Data ณ  11/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gestor de XML                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ Rotinas  ณMRSXML01.PRW (principal)                                    บฑฑ
ฑฑบ          ณMRSXML02.PRW (trata Exclusao Nota. Chamado pelo SD1140e     บฑฑ
ฑฑบ          ณMRSXML03.PRW (Job para Baixa Email)                         บฑฑ  
ฑฑบ          ณMRSXML04.PRW (Relatorio de NFs / XML)                       บฑฑ  
ฑฑบ          ณMRSXML05.PRW (Funcoes Auxiliares do GestoXML )              บฑฑ   
ฑฑบ          ณMRSXML06.PRW (TES Inteligente )                             บฑฑ
ฑฑบ          ณMRSXML07.PRW (Alteracao de titulos )                        บฑฑ
ฑฑบ          ณSD1140E.PRW  (PE exclusao de Pre-NF) - OPCIONAL             บฑฑ
ฑฑบ          ณMRSXPE01.PRW (PE opcional existente na rotina ) - OPCIONAL  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Parametros.  Todos os parametros customizados comecam com MX_MR?????   antes eram MV_FM????
PE - Existe o Ponto de Entrada MRSXPE01.prw que serve para adicionar dados nas informacoes adicionais vindas no XML
*/

User Function MRSXML01(lGrvMsg,cStatus,cMensag,cChvNfe)

	Private nRecTab1		:=	0
	Private oLinkProdu
	Private nTotPC      	:=	0
	Private oTotPC
	Private nTotNF      	:=	0
	Private oTotNF
	Private	nQtdNF     	:=	0
	Private nAccPed     	:=	0
	Private cNfRelat

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTABELA DE CORES PROTHEUS                               ณ
//ณ                                                       ณ
//ณhttp://erikasarti.net/html/tabela-cores/               ณ
//ณPrivate c2Leg1      := "A"              //Amarelo claroณ
//ณPrivate n2Leg1      := RGB(240,230,140) //Amarelo Claroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Private c2Leg1     := "1"               //PaleGreen	#98FB98	(152,251,152)
	Private n2Leg1     := RGB(152,251,152)  //PaleGreen	#98FB98	(152,251,152)

	Private c2Leg2     := "2"               //Vermelho
	Private n2Leg2     := RGB(255,99,71)    //Vermelho

	Private c2Leg3     := "3"               //Salmon	#FA8072	(250,128,114)
	Private n2Leg3     := RGB(255,165,0)    //Salmon	#FA8072	(250,128,114)      //CINZA: (169,169,169)

	Private nXXFLAG    := 0
	Private nXXITEMXML := 0
	Private nXXPEDIDO  := 0
	Private nXXITEMPC  := 0
	Private nXXVALDESC := 0
	Private nXXLOCAL   := 0
	Private nXXCC      := 0
	Private nXXPRODXML := 0
	Private nXXPRODUTO := 0
	Private nXXDESCRIC := 0
	Private nXXQTD1    := 0
	Private nXXQTD2    := 0
	Private nXXPRCUNIT := 0
	Private nXXFATOR   := 0
	Private nXXUM      := 0
	Private nXXTPFATOR := 0
	Private nXXTES	   := 0
	Private nXXOPER	   := 0
	Private nXXQTDPC   := 0
	Private nXXVALFRE  := 0		// MAURESI - 11/08/2021

	Private nYYFLAG    := 0
	Private nYYPEDIDO  := 0
	Private nYYITEMPC  := 0
	Private nYYPRODUTO := 0
	Private nYYDESCRIC := 0
	Private nYYUM      := 0
	Private nYYPRCUNIT := 0
	Private nYYSALDO   := 0
	Private nYYENTID   := 0
	Private nYYLOCAL   := 0
	Private nYYOPER	 := 0
	Private nYYCC      := 0
	Private nYYLEGENDA := 0
	Private nYYXPROTMP := 0
	Private nYYDATPRF  := 0
	Private nYYVALDESC := 0		// MAURESI - 04/08/2021
	Private nYYVALFRE  := 0		// MAURESI - 11/08/2021

	Private nD1PEDIDO  := 0
	Private nD1ITEMPC  := 0
	Private nD1COD     := 0
	Private nD1QUANT   := 0
	Private nD1TOTAL   := 0
	Private nD1VUNIT   := 0
	Private nD1VALDESC := 0
	Private nD1LOCAL   := 0
	Private nD1CC      := 0
	Private nD1TES	   := 0
	Private nD1OPER	   := 0
	Private nD1VALFRE  := 0

	Private lCliSHA   := .F.
	Private lCliDmx   := .F.
	Private lCliTay   := .F.
	Private lCliDIP   := .F.
	Private nTolerancia := 10  // Tolerโncia definida pela Priscila para Produtos Grupo FO/FOFS


	Private _cxCusto  :=space(Len(SD1->D1_CC))    // Alimenta Centro de Custo quando nao tem PC
	Private _cxLocal  :=space(Len(SD1->D1_LOCAL)) // Alimenta aRMAZEM quando nao tem PC
	Private _lTagPC   := iif(AllTrim(SuperGetMv("MX_MRTAGPC",,"S")) == "S",.T.,.F.)


	Default lGrvMsg	 := .F.
	Default cStatus	 := ""
	Default cMensag	 := ""
	Default cChvNfe	 := ""

	If lGrvMsg
		nRecTab1 := fRetRcTab1(cChvNfe,cStatus)
		If !Empty(nRecTab1) .And. !Empty(cMensag)
			fGravaMsg(nRecTab1,98,cStatus,cMensag)
		EndIf
	Else
		//Valida se a EMPRESA Pode acessar a Rotina
		if  MRSACESS()
			GerXmlNF()	//Chamando Rotina
		endif

	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfRetRcTab1บAutor  ณFelipe Aurelio      บ Data ณ  17/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  09/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRetRcTab1(cChvNfe,cStatus)

	Local nRet  := 0
	Local cTab1 := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local aArea := (cTab1)->(GetArea())

	(cTab1)->(DbSetOrder(3))
	If (cTab1)->(DbSeek( xFilial() + cChvNfe ))
		If (cTab1)->&(cAls1+"_STATUS") != cStatus
			nRet := (cTab1)->(Recno())
		EndIf
	EndIf

	RestArea(aArea)

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGerXmlNF  บAutor  ณFelipe Aurelio      บ Data ณ  17/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  09/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
"Gestor XML  -  V3.01/261015"
"Gestor XML  -  V3.01/201015"
"Gestor XML  -  V3.01/301015" - Tratamento de NF Avulsa com TAG CPF
"Gestor XML  -  V3.01/041115" - Tratamento de envio IMAP/POP
"Gestor XML  -  V3.01/271115" - Aumentado Campo de Fator de Conversao SA5/SA7
"Gestor XML  -  V3.01/301115" - Aumentado Campo de Fator de Conversao SA5/SA7
"Gestor XML  -  V3.02/011215" - Criada Amarra็ใo SA5 atraves da Amarracao PC
"Gestor XML  -  V3.02/231215" - Separa pasta Processados por Data ou CNPJ atraves de parametro
"Gestor XML  -  V3.02/020316" - Cores no Pedido de Compra / Rotina de Bloqueio de XML
"Gestor XML  -  V3.03/030316" - Desmembrar Itens / Tratamento no Fator de Conversao
"Gestor XML  -  V3.03/280316" - Importacao de CTE
"Gestor XML  -  V3.03/050416" - Inclusao de Campos de Centro de Custo/Armazem no Link com Pedido de Compra.
"Gestor XML  -  V3.03/060416" - Retorno do Botao Valida TODOS.
"Gestor XML  -  V3.04/310517" - Atualiza Flag com XMLs Lancados Diretamento pelo Documento de Entrada
"Gestor XML  -  V4.00/050716" - Alteracoes incluidas para Atender SHA.
"Gestor XML  -  V4.01/060716" - Identificar NF lancada pelo GestorXML.
"Gestor XML  -  V4.02/250117" - Ajusta erro na importacao de CTE.
"Gestor XML  -  V4.03/110717" - Ajusta erro na importacao de CTE - PF.
"Gestor XML  -  V4.04/200917" - Unificacao dos Fontes SHA/Domex.
"Gestor XML  -  V4.05/19.10.17" - Unificacao dos Fontes SHA/Domex.
"Gestor XML  -  V4.10/03.07.18" - Unificacao dos Fontes Domex/HIGIEX  
"Gestor XML  -  V4.11/06.08.18" - Gera Documento de Entrada ou Pre-Nota  (MX_MRCLASS) 
"Gestor XML  -  V4.12 / 14.08.18" - Gera Documento de Entrada ou Pre-Nota  (MX_MRCLASS) 
"Gestor XML  -  V4.12 / 16.08.18" - Agrega TES Inteligente na Rotina. 
"Gestor XML  -  V4.13 / 30.08.18" - Valida Permissao de Acesso a rotina / Criado MX_MRUSR00     
"Gestor XML  -  V4.14 / 19.09.18" - Habilita Alteracao no Titulo Financeiro / Criado MX_MRUSR03 
"Gestor XML  -  V4.15 / 21.09.18" - Ajustes para Dipack 
"Gestor XML  -  V4.16 / 26.09.18" - Ajustes para HIGIEX / Criados parametros MX_MRMSG01 e MX_MRMSG02    
"Gestor XML  -  V4.16 / 19.10.18" - Somente atualizacao de Versao          
"Gestor XML  -  V4.20 / 20.03.19" - CTE - Aliquota de ICMS do Cliente  de Entrega da Mercadoria  
"Gestor XML  -  V4.21 / 24.04.19" - Adiciona D1_DTVALID com data de 31/12/2049   
"Gestor XML  -  V4.22 / 09.09.19" - Adiciona AjustaSX7() para Desabilitar Gatilho padrใo D1_OPER (que estava sobrepondo TES Inteligente)   
"Gestor XML  -  V4.25 / 04.08.21" - Rotinas para DOMEX no recebimento ( workflow, desabilitador grava็ใo de ZZ3/ZZ6)   
"Gestor XML  -  V4.26 / 16.08.21" - Ajuste de Rotinas no recebimento ( workflow, desabilitador grava็ใo de ZZ3/ZZ6)   
"Gestor XML  -  V5.00 / 23.08.21" - Habilitadas rotinas de Pre Nota no Recebimento em Producao   
"Gestor XML  -  V5.01 / 22.09.21" - Entrada de DOMEX Filial sem Pedido de Compra   
"Gestor XML  -  V5.02 / 16.02.22" - Tratamento para Filtras XML somente da Filial Logada   
"Gestor XML  -  V5.03 / 17.03.22" - Tratamento para PRECO UNITARIO DIVERGENTE   

*/

Static Function GerXmlNF()

//Declara as variaveis
	Private _lBXWeb    	:= iif(AllTrim(SuperGetMv("MX_MRBXWEB",,"S")) == "S",.T.,.F.)
	Private _lMRFiltr  	:= iif(AllTrim(SuperGetMv("MX_MRFILTR",,"S")) == "S",.T.,.F.)
	Private _lCodBar   	:= iif(AllTrim(SuperGetMv("MX_MRBARRA",,"N")) == "S",.T.,.F.)
	Private _lTESINT   	:= iif(AllTrim(SuperGetMv("MX_MRTES"  ,,"N")) == "S",.T.,.F.)
	Private _lMSG01   	:= iif(AllTrim(SuperGetMv("MX_MRMSG01",,"S")) == "S",.T.,.F.)
	Private _lMSG02   	:= iif(AllTrim(SuperGetMv("MX_MRMSG02",,"S")) == "S",.T.,.F.)
//	Private _lUsrRec	:= iif(__cUserID $ AllTrim(SuperGetMv("MX_MRMSG04",,"999999")) ,.T.,.F.)   // Usuแrio do Recebimento
	Private _lUsrRec	:= iif(__cUserID $ "000291#000378#000971#" ,.T.,.F.)   // Usuแrio do Recebimento
	//000291 - Sergio Santos      SGCCOM
	//000378 - Carlos Motta       SGCECOM
	//000971 - Lucas Ramalho      SGCECOM

	Private _lTESOK   	:= .T.
	Private _lDmxFilial := .F.   // MAURESI - 16/02/2022

	Private cTitCad  		:= "Gestor XML  -  V5.03 / 17.03.22"
	Private cStrCad  		:= ""
	Private cCadastro		:= ""
	Private aRotina  		:= fMenu()
	Private aFixe    		:= Nil
	Private aCores   		:= {}
	Private cFiltrCad		:= Nil
	Private aIndexCad		:= {}

	Private cMRAlias01 	:= "" 	//Regitro Principal
	Private cMRAlias02 	:= "" 	//Regitro Historico
	Private cMRAlias03 	:= "" 	//Regitro Amarracao PC
	Private cMRAlias04 	:= "" 	//TES INTELIGENTE
	Private cMRSX5Oper 	:= "ZD"  // Tabela no SX5 com consulta padrao de Operacao de Entrada

	// Variavel Publica para Testes nos PE de entrada de Pre-Nota/Doc.Entrada se a rotina de origem ้ a de Importacao de XML
	Public lImpXmlNF  	:= .T.

	fVerifInic()			// Verificacoes Iniciais
	fCriaSXs()   	    	// Criar SX's
	aCores := fCores()	    // Monta Legendas
	fSF1ChvNFe() 			// Atualiza Tabela com XML lancados diretamente via Documento de Entrada   // Incluido em 31/05/17
	AjustaSX7()				// Desabilita Gatilho do Campo TIPO DE OPERACAO (Padrao) do Documento de Entrada //  Incluido em 09/09/2019


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExibe Filtro Inicial na Rotinaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if _lMRFiltr
		aRetPerg := fFiltroCad()
	else
		cTab1		:= AllTrim(GetMV("MX_MRALS01"))
		cAls1		:= IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
		aRetPerg	:= {.T.,cAls1+"_STATUS = '1' "}   //{lRet,cRet}
	Endif


	//Se pergunta confirmada, executa filtro, caso contrario, sai da rotina
	If aRetPerg[1]

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณBaixa Email somente se Parametro MX_MRBXWEB  for "S"ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if _lBXWeb
			U_GXNBxa()			// Funcao que Baixa Emails
		else
			Processa( {|| fTrataXML() },"Importando XML..." )
		Endif

		cFilCad := aRetPerg[2]
		aIndexCad := {}

		cStrCad   := cMRAlias01
		cCadastro := cTitCad+" ["+cStrCad+"]"
		DbSelectArea(cStrCad)
		DbSetOrder(1)
		mBrowse(6,1,22,75,cStrCad,aFixe,,,,,aCores,,,,,,,,cFilCad)

		SetMBTopFilter(cStrCad, "")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfFiltroCadบAutor  ณFelipe Aurelio      บ Data ณ  22/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  09/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fFiltroCad()

	Local cTab1   		:= AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   		:= IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

	Local lRet      	:= .F.
	Local cRet      	:= ""
	Local aPerg     	:= {}
	Local aParam    	:= {}

	Local cPerg1Tit 	:= "Tipo XML"
	Local aPerg1Arr 	:= {}
	Local cPerg1Vld 	:= ".T."
	Local cPerg1Tam 	:= 120
	Local cPerg1Obg 	:= .T.

	Local cPerg2Tit 	:= "Tipo Documento"
	Local aPerg2Arr 	:= {}
	Local cPerg2Vld 	:= ".T."
	Local cPerg2Tam 	:= 120
	Local cPerg2Obg 	:= .T.

	Local cPerg3Tit 	:= "Tipo Status"
	Local aPerg3Arr 	:= {}
	Local cPerg3Vld 	:= ".T."
	Local cPerg3Tam 	:= 120
	Local cPerg3Obg 	:= .T.

	//Op็๕es da Pergunta 01
	aAdd(aPerg1Arr,"T=Todos Tipos"     )
	aAdd(aPerg1Arr,"1=NF-e"            )
	aAdd(aPerg1Arr,"2=CT-e"            )
	aAdd(aPerg1Arr,"3=XML Pedente"     )

	//Op็๕es da Pergunta 02
	aAdd(aPerg2Arr,"T=Todos Documentos")
	aAdd(aPerg2Arr,"N=Normal"          )
	aAdd(aPerg2Arr,"D=Devolu็ใo"       )
	aAdd(aPerg2Arr,"B=Beneficiamento"  )
	aAdd(aPerg2Arr,"C=Complementar"    )
	aAdd(aPerg2Arr,"I=Compl. ICMS"     )      //  28/01/2018 - Adicionado tratamento para COMPLEMENTO DE ICMS
	aAdd(aPerg2Arr,"A=Ajuste"          )
	aAdd(aPerg2Arr,"U=Anula็ใo"        )
	aAdd(aPerg2Arr,"S=Substitui็ใo"    )
	aAdd(aPerg2Arr,"X=Indefinido"      )

	//Op็๕es da Pergunta 03
	aAdd(aPerg3Arr,"T=Todos Status"                           )
	aAdd(aPerg3Arr,"0=XML pendente de recebimento"            )
	aAdd(aPerg3Arr,"1=XML recebido com sucesso"               )
	aAdd(aPerg3Arr,"2=XML recebido com erro"                  )
	aAdd(aPerg3Arr,"3=XML jแ incluido no sistema"             )
	aAdd(aPerg3Arr,"4=XML gerou erro na pr้-nota"             )
	aAdd(aPerg3Arr,"5=XML gerou pr้-nota depois foi excluํda" )
	aAdd(aPerg3Arr,"6=XML de cancelamento recebido"           )
	aAdd(aPerg3Arr,"7=XML bloqueado pelo validador"           )

	Private mv_par01 := "T"
	Private mv_par02 := "T"
	Private mv_par03 := "T"
	Private cParRom  := "FILTROCAD"+SM0->M0_CODIGO+SM0->M0_CODFIL

	aAdd(aPerg,{2           ,cPerg1Tit   ,mv_par01    ,	aPerg1Arr   ,cPerg1Tam   ,cPerg1Vld   ,	cPerg1Obg	})
	aAdd(aPerg,{2           ,cPerg2Tit   ,mv_par02    ,	aPerg2Arr   ,cPerg2Tam   ,cPerg2Vld   ,	cPerg2Obg	})
	aAdd(aPerg,{2           ,cPerg3Tit   ,mv_par03    ,	aPerg3Arr   ,cPerg3Tam   ,cPerg3Vld   ,	cPerg3Obg	})

	aAdd(aParam,mv_par01)
	aAdd(aParam,mv_par02)
	aAdd(aParam,mv_par03)

	If ParamBox(aPerg,"Filtro ["+cTitCad+"]",@aParam,,,,,,,cParRom,.T.,.T.)
		//--------------------------------------------------------------------------------
		Do Case
			//"T=Todos"
		Case SubStr(mv_par01,1,1) == "T"
			cRet := ""

			//1=NF-e
		Case SubStr(mv_par01,1,1) == "1"
			cRet := cAls1+"_TIPXML = '1' "

			//2=CT-e
		Case SubStr(mv_par01,1,1) == "2"
			cRet := cAls1+"_TIPXML = '2' "

			//3=XML Pendente
		Case SubStr(mv_par01,1,1) == "3"
			cRet := cAls1+"_TIPXML = '3' "

		EndCase

		//--------------------------------------------------------------------------------
		Do Case
			//T=Todos
		Case SubStr(mv_par02,1,1) == "T"
			cRet += ''

			//N=Normal
		Case SubStr(mv_par02,1,1) == "N"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'N' "

			//D=Devolucao
		Case SubStr(mv_par02,1,1) == "D"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'D' "

			//B=Beneficiamento
		Case SubStr(mv_par02,1,1) == "B"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'B' "

			//C=Complementar
		Case SubStr(mv_par02,1,1) == "C"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'C' "

			//I=Complemento ICMS                //  28/01/2018 - Adicionado tratamento para COMPLEMENTO DE ICMS
		Case SubStr(mv_par02,1,1) == "I"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'I' "


			//A=Ajuste
		Case SubStr(mv_par02,1,1) == "A"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'A' "

			//U=Anulacao
		Case SubStr(mv_par02,1,1) == "U"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'U' "

			//S=Substituicao
		Case SubStr(mv_par02,1,1) == "S"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'S' "

			//X=Indefinido
		Case SubStr(mv_par02,1,1) == "X"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_TIPDOC = 'X' "

		EndCase

		//--------------------------------------------------------------------------------
		Do Case
			//T=Todos Status
		Case SubStr(mv_par03,1,1) == "T"
			cRet += ''

			//0=XML pendente de recebimento
		Case SubStr(mv_par03,1,1) == "0"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '0' "

			//1=XML recebido com sucesso
		Case SubStr(mv_par03,1,1) == "1"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '1' "

			//2=XML recebido com erro
		Case SubStr(mv_par03,1,1) == "2"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '2' "

			//3=XML jแ incluido no sistema
		Case SubStr(mv_par03,1,1) == "3"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '3' "

			//4=XML gerou erro na pre-nota
		Case SubStr(mv_par03,1,1) == "4"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '4' "

			//5=XML gerou pre-nota depois foi excluํda
		Case SubStr(mv_par03,1,1) == "5"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '5' "

			//6=XML de cancelamento recebido
		Case SubStr(mv_par03,1,1) == "6"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '6' "

			//7=XML bloqueado pelo validador
		Case SubStr(mv_par03,1,1) == "7"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '7' "

			//8=XML bloqueado pelo Usuario
		Case SubStr(mv_par03,1,1) == "8"
			cRet += IIf(Empty(cRet),""," AND ")
			cRet := cAls1+"_STATUS = '8' "
		EndCase
		//--------------------------------------------------------------------------------

		lRet := .T.
	EndIf

Return({lRet,cRet})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNFil    บAutor  ณFelipe Aurelio      บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  09/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GXNFil()

	//Faz a pergunta e monta filtro
	Local aRetPerg := fFiltroCad()
	Local oObjMBrw := GetObjBrow()

	//Se pergunta confirmada, executa filtro, caso contrario, sai da rotina
	If aRetPerg[1]
		//Limpar filtro
		SetMBTopFilter(cStrCad, "")

		cFilCad := aRetPerg[2]
		aIndexCad := {}

		If !Empty(cFilCad)
			oObjMBrw:ResetLen()
			(cStrCad)->(DbClearFilter())

			SetMBTopFilter(cStrCad,cFilCad,,.T.)

			DbSelectArea(cStrCad)
			(cStrCad)->(dbGoTop())

			oObjMBrw:GoPgDown()
			oObjMBrw:Refresh()

			oObjMBrw:GoTop()
			oObjMBrw:Refresh()

			oObjMBrw:GoPgUp()
			oObjMBrw:Refresh()
		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfCores    บAutor  ณFelipe Aurelio      บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  09/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCores()

	Local aCores := {}
	Local cAls := AllTrim(cMRAlias01)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

	aAdd(aCores,{cAls+'_STATUS == "0" ','BR_AZUL'    })		//'BR_AZUL' 	 = XML Pendente de recebimento
	aAdd(aCores,{cAls+'_STATUS == "1" ','BR_VERDE'   })		//'BR_VERDE'    = XML Recebido com sucesso
	aAdd(aCores,{cAls+'_STATUS == "2" ','BR_AMARELO' })		//'BR_AMARELO'  = XML Recebido com erro
	aAdd(aCores,{cAls+'_STATUS == "3" ','BR_LARANJA' })		//'BR_LARANJA'  = XML jแ incluido no sistema
	aAdd(aCores,{cAls+'_STATUS == "4" ','BR_VERMELHO'})		//'BR_VERMELHO' = XML Gerou erro na pre-nota
	aAdd(aCores,{cAls+'_STATUS == "5" ','BR_PINK'    })		//'BR_PINK'     = XML Gerou pre-nota depois excluํda
	aAdd(aCores,{cAls+'_STATUS == "6" ','BR_PRETO'   })		//'BR_PRETO'    = Chave Cancelada no Sefaz
	aAdd(aCores,{cAls+'_STATUS == "7" ','BR_CINZA'   })		//'BR_CINZA'    = Chave foi bloqueada pela valida็ใo
	aAdd(aCores,{cAls+'_STATUS == "8" ','BR_BRANCO'  })		//'BR_BRANCO'   = XML bloqueado pelo usuario

Return(aCores)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNLeg    บAutor  ณFelipe Aurelio      บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GXNLeg()

	Local cCadLeg	:= "Status do Gestor XML"
	Local aLegenda	:= {}

	aAdd(aLegenda,{'BR_AZUL'     ,'XML pendente de recebimento'           })
	aAdd(aLegenda,{'BR_VERDE'    ,'XML recebido com sucesso'              })
	aAdd(aLegenda,{'BR_AMARELO'  ,'XML recebido com erro'                 })
	aAdd(aLegenda,{'BR_LARANJA'  ,'XML jแ incluido no sistema'            })
	aAdd(aLegenda,{'BR_VERMELHO' ,'XML gerou erro no Documento'           })
	aAdd(aLegenda,{'BR_PINK'     ,'XML gerou Documento e depois excluํdo'})
	aAdd(aLegenda,{'BR_PRETO'    ,'XML de cancelamento recebido'          })
	aAdd(aLegenda,{'BR_CINZA'    ,'XML bloqueado pelo validador'          })
	aAdd(aLegenda,{'BR_BRANCO'   ,'XML bloqueado pelo usuแrio'            })

	BrwLegenda(cCadLeg,"Legenda",aLegenda)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfMenu     บAutor  ณFelipe Aurelio      บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fMenu()

	Local aRotina	:= {}
	Local aSub1		:= {}
	Local aSub2		:= {}
	Local aSub3		:= {}

	// SubMenu Visualiza
	aAdd(aSub1, { OemToAnsi("Danfe"				)	,"U_GXNVis"     	,  0 , 2})
	aAdd(aSub1, { OemToAnsi("Doc.Entrada"		)	,"U_GXNVisNF"   	,  0 , 2})

	// SubMenu Ferramentas
	aAdd(aSub2, { OemToAnsi("Valida XML"		)	,"U_GXNFVL"       ,  0 , 2}) //4
//aAdd(aSub2, { OemToAnsi("Valida Pendentes"	)	,"U_GXNVLD2"      ,  0 , 2}) //4
//aAdd(aSub2, { OemToAnsi("Valida TODOS"		)	,"U_GXNVLD"       ,  0 , 2}) //4
	aAdd(aSub2, { OemToAnsi("Bloqueia XML"		)	,"U_GXNFBL"       ,  0 , 2}) //4
	aAdd(aSub2, { OemToAnsi("Exportar XML" 		)	,"U_GXNExp"       ,  0 , 2}) //3
	aAdd(aSub2, { OemToAnsi("Alterar Tipo" 		)	,"AxAltera"       ,  0 , 2}) //4
//aAdd(aSub2, { OemToAnsi("Alterar Vencto"	)	,"U_MRSXML07"     ,  0 , 2}) //4
	aAdd(aSub2, { OemToAnsi("Relat๓rio XML" 	)	,"U_MRSXML04"     ,  0 , 2}) //4

//Menu Principal

	if _lUsrRec

		aAdd(aRotina, { OemToAnsi("Filtra Browse"	),"U_GXNFil"         ,  0 , 2}) //3
		aAdd(aRotina, { OemToAnsi("Gerar Documento"	),"U_GXNImp"         ,  0 , 2}) //4
//	aAdd(aRotina, { OemToAnsi("Hist๓rico"		),"U_GXNHis"         ,  0 , 2}) //4
//	aAdd(aRotina, { OemToAnsi("Visualiza"		),aSub1 		 	 ,  0 , 2})
		aAdd(aRotina, { OemToAnsi("Ferramentas"		),aSub2     	     ,  0 , 2}) //4
//	aAdd(aRotina, { OemToAnsi("Baixar XML"		),"U_GXNBxa"         ,  0 , 2}) //3

//	if _lTESInt
//		aAdd(aRotina, { OemToAnsi("Tes Inteligente"	),"U_MRSXML06"  ,  0 , 2}) //4
//	endif

		aAdd(aRotina, { OemToAnsi("Legenda"			),"U_GXNLeg"         ,  0 , 2}) //3
//	aAdd(aRotina, { OemToAnsi("Parโmetros"		),"U_GXNPar"         ,  0 , 3}) //3

	Else
		aAdd(aRotina, { OemToAnsi("Filtra Browse"	),"U_GXNFil"         ,  0 , 2}) //3
		aAdd(aRotina, { OemToAnsi("Gerar Documento"	),"U_GXNImp"         ,  0 , 2}) //4
		aAdd(aRotina, { OemToAnsi("Hist๓rico"		),"U_GXNHis"         ,  0 , 2}) //4
		aAdd(aRotina, { OemToAnsi("Visualiza"		),aSub1 		 	 ,  0 , 2})
		aAdd(aRotina, { OemToAnsi("Ferramentas"		),aSub2     	     ,  0 , 2}) //4
		aAdd(aRotina, { OemToAnsi("Baixar XML"		),"U_GXNBxa"         ,  0 , 2}) //3

		if _lTESInt
			aAdd(aRotina, { OemToAnsi("Tes Inteligente"	),"U_MRSXML06"  ,  0 , 2}) //4
		endif

		aAdd(aRotina, { OemToAnsi("Legenda"			),"U_GXNLeg"         ,  0 , 2}) //3
		aAdd(aRotina, { OemToAnsi("Parโmetros"		),"U_GXNPar"         ,  0 , 3}) //3
	Endif

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNAju    บAutor  ณFelipe Aurelio      บ Data ณ  09/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GXNAju()
	Processa( {|| fAjustTipo()   },"Ajustando tipo ..." )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNVis    บAutor  ณFelipe Aurelio      บ Data ณ  09/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GXNVis(_cChve)

	Local cFileDes := ""
	Local cPathTmp := AllTrim(GetTempPath())

	Local cDirIni  := AllTrim(SuperGetMv("MX_MR_DXML",,"\data\GestorXml\"))
	Local cSepara  := Upper(AllTrim(SuperGetMv("MX_MRSEPAR",,"C")))

	Local cTab1    := GetMV("MX_MRALS01")
	Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

	Local cCnpjE := AllTrim((cTab1)->&(cAls1+"_DECNPJ"))
	Local cFile  := AllTrim((cTab1)->&(cAls1+"_ARQUIV"))
	Local cData  := DtoS((cTab1)->&(cAls1+"_DTEMIS"))
	Local cMes   := Substr(cData,5,2)
	Local cAno   := Substr(cData,1,4)
	Local cDia   := Substr(cData,7,2)

// Se a rotina for Chamada pelo Documento Entrada
	If FunName() $  "MATA103/MATA140/MATA910"

		dbSelectArea((cTab1))
		(cTab1)->(DbSetOrder(3))
		If (cTab1)->(DbSeek( xFilial() + SF1->F1_CHVNFE ))
			cCnpjE := AllTrim((cTab1)->&(cAls1+"_DECNPJ"))
			cFile  := AllTrim((cTab1)->&(cAls1+"_ARQUIV"))
			cData  := DtoS((cTab1)->&(cAls1+"_DTEMIS"))
			cMes   := Substr(cData,5,2)
			cAno   := Substr(cData,1,4)
			cDia   := Substr(cData,7,2)
		EndIf

	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSepara XML por   CNPJ  ou por DATAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if cSepara <> "D"
		_cCaminho := cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"
	Else
		_cCaminho := cDirIni+"processado\"+cAno+"\"+cMes+"\"+cDia+"\"
	Endif

	cFileDes := _cCaminho +AllTrim(cFile)
	cPathTmp := cPathTmp+AllTrim(cFile)

	If File(cPathTmp)
		fErase(cPathTmp)
	EndIf
	If File(cPathTmp)
		Alert("Arquivo jแ estแ aberto!")
		Return
	EndIf

	COPY File &cFileDes TO &cPathTmp
	ShellExecute("open",cPathTmp,"","", 5 )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNPar    บAutor  ณFelipe Aurelio      บ Data ณ  11/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USer Function GXNPar()

//Variaveis do tamanho a tela
	Local aDlgTela     := {}
	Local aSizeAut     := {}
	Local aInfo        := {}
	Local aObjects     := {}
	Local aPosObj      := {}
	Local cVarTemp     := ""

	Private cPrtCad    := " Parโmetros [ GESTOR XML ] "
	Private lParamOK   := .F.
	Private oBBGetDad  := Nil
	Private oDialg

//Somente o usuแrio ADMIN pode alterar os parametros
	If !(__cUserID $ "000000#"+Alltrim(GetMV("MX_MRUSR00")))	// "000000=Administrador
		MsgAlert("Somente os usuแrios Administradores do GestorXML podem ter acesso a alterar parโmetros da rotina. [ MRUSR00 ]")
		Return()
	EndIf


//Define tela em rela็ใo a area de trabalho
	aSizeAut := {0       ,;
		0       ,;
		(0700)/2,;
		(0350)/2,;
		(0700)  ,;
		(0350)  ,;
		0        }

	aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
	aObjects := {}

	aAdd(aObjects,{100,100,.T.,.T.}) //Itens Parametros
	aAdd(aObjects,{100,020,.T.,.F.}) //Rodape
	aPosObj  := MsObjSize(aInfo,aObjects)

//Variaveis do tamanho a tela
	aDlgTela := {aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5]}

// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

/*Itens     */ fParamIts(aPosObj[1],oDialg)
/*Rodap้    */ fParamRod(aPosObj[2],oDialg)

	Activate MsDialog oDialg Centered
y:=0
//Se confirmado
	If lParamOK
		SX6->(DbSetOrder(1))
		For y:=1 To Len(oBBGetDad:aCols)
			cVarTemp0 := Space(Len(xFilial()))
			cVarTemp1 := AllTrim(oBBGetDad:aCols[y, aScan(oBBGetDad:aHeader,{|x|AllTrim(x[2])=="BB_PARAMET"}) ])
			cVarTemp2 := AllTrim(oBBGetDad:aCols[y, aScan(oBBGetDad:aHeader,{|x|AllTrim(x[2])=="BB_CONTEUD"}) ])
			cVarTemp3 := AllTrim(oBBGetDad:aCols[y, aScan(oBBGetDad:aHeader,{|x|AllTrim(x[2])=="BB_DESCRIC"}) ])
			If SX6->(DbSeek( cVarTemp0 + cVarTemp1 ))
				RecLock("SX6",.F.)
			Else
				RecLock("SX6",.T.)
				SX6->X6_FIL		:= cVarTemp0
				SX6->X6_VAR 	:= cVarTemp1
				SX6->X6_TIPO	:= 'C'
				SX6->X6_PROPRI	:= 'U'
			EndIf
			SX6->X6_CONTEUD	:= cVarTemp2
			SX6->X6_CONTSPA	:= cVarTemp2
			SX6->X6_CONTENG	:= cVarTemp2
			SX6->X6_DESCRIC := cVarTemp3
			SX6->X6_DSCSPA  := cVarTemp3
			SX6->X6_DSCENG  := cVarTemp3
			SX6->(MsUnLock())
		Next y
		MsgInfo("As altera็๕es foram SALVAS com SUCESSO !!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Para que as altera็๕es tenham efeito, sair da rotina e entrar novamente.")

		//Cria Diretorio para Armazenar XML, caso nao exista
		cDirIni  := AllTrim(SuperGetMv("MX_MR_DXML",,"\data\GestorXml\"))
		MontaDir(cDirIni+"pendente\")
		MontaDir(cDirIni+"processado\")
		MontaDir(cDirIni+"recusado\")
		MontaDir(cDirIni+"Log\")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfParamIts บAutor  ณFelipe Aurelio      บ Data ณ  09/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fParamIts(aSizeDlg,oDialg)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := GD_UPDATE                                       // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHead          := {}                                              // Array do aHeader
	Local aColsBB        := {}                                              // Array do aCols
	Local aMR_Param      := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTabelas do Sistemaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aMR_Param,{"MX_MRALS01","Alias da tabela principal da rotina"                            	, fX6Ret("MX_MRALS01",""                                    )  })
	aAdd(aMR_Param,{"MX_MRALS02","Alias da tabela de historico dos XML"                           	, fX6Ret("MX_MRALS02",""                                    )  })
	aAdd(aMR_Param,{"MX_MRALS03","Alias da tabela de Amarracao dos XML"                           	, fX6Ret("MX_MRALS03",""                                    )  })
	aAdd(aMR_Param,{"MX_MRALS04","Alias da tabela de TES INTELIGENTE"                           		, fX6Ret("MX_MRALS04",""                                    )  })
	aAdd(aMR_Param,{"MX_MR_DXML","Diretorio onde serใo salvos os arquivos XML"                     	, fX6Ret("MX_MR_DXML","\data\GestorXml\"                    )  })
	aAdd(aMR_Param,{"MX_MRSEPAR","Separa XML por (C=CNPJ+Ano+Mes  /  D=Data)"                     	, fX6Ret("MX_MRSEPAR","C"                                   )  })
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณParametros do Gestorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aMR_Param,{"MX_MRBXWEB","Baixa XML de Conta de Email  (S ou N)"      					 			, fX6Ret("MX_MRBXWEB","S"                                   )  }) //MAS - 20/10/15
	aAdd(aMR_Param,{"MX_MRSCHED","Processa Automatico por Schedulle (S ou N)"           				, fX6Ret("MX_MRSCHED","N" 												)  }) //MAS - 30/09/19
	aAdd(aMR_Param,{"MX_MRFILTR","Exibe Filtro Inicial na Rotina (S ou N)"     					   	, fX6Ret("MX_MRFILTR","S"                                   )  }) //MAS - 20/10/15
	aAdd(aMR_Param,{"MX_MRMSGPC","Exibe Mensagem para Associar Pedido de Compra (S ou N)"    	   	, fX6Ret("MX_MRMSGPC","S"                                   )  }) //MAS - 20/10/15
	aAdd(aMR_Param,{"MX_MRBARRA","Pesquisa PC usando Codigo de Barras (B1_CODBAR)(S ou N)"    	   , fX6Ret("MX_MRBARRA","N"                                   )  }) //MAS - 20/10/15
	aAdd(aMR_Param,{"MX_MRTAGPC","Usar TAG NUMPC e ITEMPC do XML pra associar a NFe (S ou N)"     	, fX6Ret("MX_MRTAGPC","S"                                   )  })
	aAdd(aMR_Param,{"MX_MRCLASS","Pre-Nota (S) , Classifica (C) "                     		   		, fX6Ret("MX_MRCLASS","S"                                   )  })
	aAdd(aMR_Param,{"MX_MRTES"  ,"Utiliza Tes Inteligente (S ou N)  "   		            				, fX6Ret("MX_MRTES"  ,"N"                                   )  })
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampos / CFOP Especificos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aMR_Param,{"MX_MRSA501","Campo SA5, Unidade de Medida do arquivo XML"                    	, fX6Ret("MX_MRSA501","A5_XXUMXML"                          )  })
	aAdd(aMR_Param,{"MX_MRSA502","Campo SA5, Numero do Fator de Conversao XML x SB1"              	, fX6Ret("MX_MRSA502","A5_XXFCNUM"                          )  })
	aAdd(aMR_Param,{"MX_MRSA503","Campo SA5, Tipo do Fator de Conversao, Multiplica็ใo ou Divisใo"	, fX6Ret("MX_MRSA503","A5_XXFCTIP"                          )  })
	aAdd(aMR_Param,{"MX_MRSA701","Campo SA7, Unidade de Medida do arquivo XML"                    	, fX6Ret("MX_MRSA701","A7_XXUMXML"                          )  })
	aAdd(aMR_Param,{"MX_MRSA702","Campo SA7, Numero do Fator de Conversao XML x SB1"              	, fX6Ret("MX_MRSA702","A7_XXFCNUM"                          )  })
	aAdd(aMR_Param,{"MX_MRSA703","Campo SA7, Tipo do Fator de Conversao, Multiplica็ใo ou Divisใo"	, fX6Ret("MX_MRSA703","A7_XXFCTIP"                          )  })
	aAdd(aMR_Param,{"MX_MRNFBEN","CFOP das NF de Beneficiamento"                                   	, fX6Ret("MX_MRNFBEN","1901/1920/1916/1949"                 )  })
	aAdd(aMR_Param,{"MX_MRNFDEV","CFOP das NF de Devolu็ใo"                                       	, fX6Ret("MX_MRNFDEV","1201/2201/1202/2202"                 )  })
	aAdd(aMR_Param,{"MX_MRNFCOM","CFOP das NF de Complemento"                                     	, fX6Ret("MX_MRNFCOM","1352/3101/3102/3551"                 )  })
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConfiguracao de Email ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aMR_Param,{"MX_MR_PROT","Protocolo Utilizado ( P=POP3 /  I=IMAP ) "                      	, fX6Ret("MX_MR_PROT","P"                                   )  })
	aAdd(aMR_Param,{"MX_MRCPOP3","POP3 do servidor de e-mails pra baixar os XML."                 	, fX6Ret("MX_MRCPOP3","pop.seudominio.com.br"               )  })
	aAdd(aMR_Param,{"MX_MRPORTA","Porta para Conexao IMAP."                                       	, fX6Ret("MX_MRPORTA","143"                                 )  })
	aAdd(aMR_Param,{"MX_MR_SSL" ,"Usa Conexao SSL (Segura)   (S/N)."                               	, fX6Ret("MX_MR_SSL" ,"S"                                   )  })
	aAdd(aMR_Param,{"MX_MRCMAIL","E-MAIL da conta que receberแ os XML que serใo usados na rotina" 	, fX6Ret("MX_MRCMAIL","protheus@seudominio.com.br"          )  })
	aAdd(aMR_Param,{"MX_MRCPASS","SENHA da conta de e-mail que receberแ os XML"                   	, fX6Ret("MX_MRCPASS","senhaemail"                          )  })
	aAdd(aMR_Param,{"MX_MR_MAIL","E-MAIL das pessoas que receberใo o WF de confirma็ใo ou crํtica"	, fX6Ret("MX_MR_MAIL","xxxx@gmail.com;"              		)  })
	aAdd(aMR_Param,{"MX_MR_HTML","Arquivo modelo HTML usado no envio dos WF"                      	, fX6Ret("MX_MR_HTML","\workflow\modelos\aviso_prenota.htm" )  })
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAcesso de Usuariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
	aAdd(aMR_Param,{"MX_MRUSR00","Usuarios que podem Alterar Parametros do GestorXML"  			    	, fX6Ret("MX_MRUSR00","000000#"                             )  })
	aAdd(aMR_Param,{"MX_MRUSR01","Usuarios que podem Visualizar Tela de Flag para Relatorio"      		, fX6Ret("MX_MRUSR01","000000#"                             )  })
	aAdd(aMR_Param,{"MX_MRUSR02","Usuarios que podem Incluir NF-e sem Amarracao com PC"					, fX6Ret("MX_MRUSR02","000000#"                             )  })
	aAdd(aMR_Param,{"MX_MRUSR03","Usuarios que podem Alterar Vencimento de Titulos"						, fX6Ret("MX_MRUSR03","000000#"                             )  })
	aAdd(aMR_Param,{"MX_MRUSR04","Usuarios do Recebimento (Alguns campos sใo Desabilitados)."			, fX6Ret("MX_MRUSR04","999999#"                             )  })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRotinas Especificasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aMR_Param,{"MX_MRRECEB","Informa quem Recebeu a Carga (S ou N)  [F1_XRECEB]"              	, fX6Ret("MX_MRRECEB","N"                                   )  })
	aAdd(aMR_Param,{"MX_MRNATUR","Natureza Financeira p/Doc.Entrada(quando nao preenchido SA2)"		, fX6Ret("MX_MRNATUR","NATUREZA"                            )  })
	aAdd(aMR_Param,{"MX_MRFRETE","Produto de FRETE utilizado no CTE "                             	, fX6Ret("MX_MRFRETE","FRETE"                               )  })
	aAdd(aMR_Param,{"MX_MRPEDAG","Produto de PEDAGIO utilizado no CTE "                           	, fX6Ret("MX_MRPEDAG","PEDAGIO"                             )  })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExibe Mensgens de Alerta/Erros	  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aMR_Param,{"MX_MRMSG01","Exibe Mensagens na importacao de XML  (S/N)  "              		, fX6Ret("MX_MRMSG01","S"                                   )  })
	aAdd(aMR_Param,{"MX_MRMSG02","Exibe Mensagens na Amarracao de NF x PC (S/N) " 					, fX6Ret("MX_MRMSG02","S"                            			)  })

//Estrutura MsNewGetDados
	aAdd(aHead,{"Item"        ,"BB_ITEM"      ,"@!"                 ,           03,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Parametro"   ,"BB_PARAMET"   ,"@!"                 ,           15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Conteudo"    ,"BB_CONTEUD"   ,"@S40"               ,          250,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ," "      , ""                            , ""        , ""        })
	aAdd(aHead,{"Descri็ใo"   ,"BB_DESCRIC"   ,""                   ,          250,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

	For x:=1 To Len(aMR_Param)
		//Cria uma linha no aCols
		aAdd(aColsBB,Array(Len(aHead)+1))
		nLin := Len(aColsBB)

		//Alimenta a linha do aCols vazia
		aColsBB[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BB_ITEM"   }) ] := StrZero(x,3)
		aColsBB[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BB_PARAMET"}) ] := aMR_Param[x][1]
		aColsBB[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BB_CONTEUD"}) ] := Padr(aMR_Param[x][3],250)
		aColsBB[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BB_DESCRIC"}) ] := aMR_Param[x][2]
		aColsBB[nLin, Len(aHead)+1]                                  	 := .F.
	Next x

	oBBGetDad:=MsNewGetDados():New(aSizeDlg[1]+5,aSizeDlg[2]+5,aSizeDlg[3]-5,aSizeDlg[4]-5,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aColsBB)

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfX6Ret    บAutor  ณFelipe Aurelio      บ Data ณ  09/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fX6Ret(cPar,cCont)

	Local cRet    := ""
	Default cPar  := ""
	Default cCont := ""

	SX6->(DbSetOrder(1))
	cVarTemp0 := Space(Len(xFilial()))
	cVarTemp1 := PadR(AllTrim(cPar),10)
	If SX6->(DbSeek( cVarTemp0 + cVarTemp1 ))
		cRet := SX6->X6_CONTEUD
	Else
		cRet := cCont
	EndIf

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfParamRod บAutor  ณFelipe Aurelio      บ Data ณ  09/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fParamRod(aSizeDlg,oDialg)

	Local nTamBtn := (aSizeDlg[4]/7)
	Local aBtn01  := {aSizeDlg[1]+5,   (nTamBtn*5),   nTamBtn-5, 012}
	Local aBtn02  := {aSizeDlg[1]+5,   (nTamBtn*6),   nTamBtn-5, 012}

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Bot๕es
	@ aBtn01[1],aBtn01[2] Button "Fechar"    Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fParFechar(oDialg)
	@ aBtn02[1],aBtn02[2] Button "Confirmar" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fParConfir(oDialg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfParFecharบAutor  ณFelipe Aurelio      บ Data ณ  09/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fParFechar(oDialg)

	If SimNao("AVISO: Ao fechar, as informa็๕es nใo salvas serใo perdidas!"+Chr(13)+Chr(10)+"DESEJA sair assim mesmo?") == "S"
		lParamOK := .F.
		oDialg:End()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfParConfirบAutor  ณFelipe Aurelio      บ Data ณ  09/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fParConfir(oDialg)

	lParamOK := .T.
	oDialg:End()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNExp    บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GXNExp()
	fGerTela("E") //Exporta็ใo XML
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNImp    บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GXNImp()
	fGerTela("I") //Importa็ใo XML (Gerar Pre-nota)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerTela  บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerTela(cOper)

	Local oDialg
	Local cPrtCad      := " Gestor XML [ "+IIf(cOper=="E","Exportar Aquivo","Gerar Documento")+" ]"
	Local cTab1        := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

//Variaveis do tamanho a tela
	Local aDlgTela     := {}
	Local aSizeAut     := {}
	Local aInfo        := {}
	Local aObjects     := {}
	Local aPosObj      := {}
//----------------------------------------------------------
	Private oSayTipXml := Nil
	Private oGetTipXml := Nil
	Private cGetTipXml := "T"
	Private oSayStatus := Nil
	Private oGetStatus := Nil
	Private cGetStatus := "T"
	Private oSayComCCe := Nil
	Private oGetComCCe := Nil
	Private cGetComCCe := "T"
	Private oSayCnpjEm := Nil
	Private oGetCnpjEm := Nil
	Private cGetCnpjEm := Space(fX3Ret(cAls1+"_DECNPJ","X3_TAMANHO"))
	Private oSayNomeEm := Nil
	Private oGetNomeEm := Nil
	Private cGetNomeEm := Space(fX3Ret(cAls1+"_DENOME","X3_TAMANHO"))

	Private oSayTipDoc := Nil
	Private oGetTipDoc := Nil
	Private cGetTipDoc := "T"
	Private oSayDtEmis := Nil
	Private oGetDtEmis := Nil
	Private dGetDtEmis := StoD("")
	Private oSaySerNFe := Nil
	Private oGetSerNFe := Nil
	Private cGetSerNFe := Space(fX3Ret(cAls1+"_SERIE","X3_TAMANHO"))
	Private oSayNumNFe := Nil
	Private oGetNumNFe := Nil
	Private cGetNumNFe := Space(fX3Ret(cAls1+"_DOC","X3_TAMANHO"))

//----------------------------------------------------------
	Private oSayChvNFe := Nil
	Private oGetChvNFe := Nil
	Private cGetChvNFe := Space(fX3Ret(cAls1+"_CHVNFE","X3_TAMANHO"))

//----------------------------------------------------------
	Private oAAGetDad   := Nil
//----------------------------------------------------------
	Private aHdStatus  := {}
	Private aHeadCpos  := {}
	Private aOrdHead   := {}
	Private nCtrlClik  := 1

	Private cFullOper	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAdequa Filtros Iniciais para Tela de Geracao de PreNotaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if cOper $ "I"
		cGetStatus := "1"
	Endif

	aAdd(aHdStatus,{cAls1+'_STATUS == "0" ','BR_AZUL'    , "XML pendente de recebimento"            })
	aAdd(aHdStatus,{cAls1+'_STATUS == "1" ','BR_VERDE'   , "XML recebido com sucesso"               })
	aAdd(aHdStatus,{cAls1+'_STATUS == "2" ','BR_AMARELO' , "XML recebido com erro"                  })
	aAdd(aHdStatus,{cAls1+'_STATUS == "3" ','BR_LARANJA' , "XML jแ incluido no sistema"             })
	aAdd(aHdStatus,{cAls1+'_STATUS == "4" ','BR_VERMELHO', "XML gerou erro na pre-nota"             })
	aAdd(aHdStatus,{cAls1+'_STATUS == "5" ','BR_PINK'    , "XML gerou pre-nota depois foi excluida" })
	aAdd(aHdStatus,{cAls1+'_STATUS == "6" ','BR_PRETO'   , "XML de cancelamento recebido"           })
	aAdd(aHdStatus,{cAls1+'_STATUS == "7" ','BR_CINZA'   , "XML bloqueado pelo validador"           })
	aAdd(aHdStatus,{cAls1+'_STATUS == "8" ','BR_BRANCO'  , "XML bloqueado pelo Usuario"             })

//Campos que serใo apresentados no MsNewGetDados
	aAdd(aHeadCpos,cAls1+"_FILIAL" )
	aAdd(aHeadCpos,cAls1+"_TIPDOC" )
	aAdd(aHeadCpos,cAls1+"_TIPXML" )
	aAdd(aHeadCpos,cAls1+"_TEMCCE" )
	aAdd(aHeadCpos,cAls1+"_CHVNFE" )
	aAdd(aHeadCpos,cAls1+"_SERIE"  )
	aAdd(aHeadCpos,cAls1+"_DOC"    )
	aAdd(aHeadCpos,cAls1+"_DTEMIS" )
	aAdd(aHeadCpos,cAls1+"_HREMIS" )
	aAdd(aHeadCpos,cAls1+"_DECNPJ" )
	aAdd(aHeadCpos,cAls1+"_DENOME" )
	aAdd(aHeadCpos,cAls1+"_VLRTOT" )
	aAdd(aHeadCpos,cAls1+"_LOGDT"  )
	aAdd(aHeadCpos,cAls1+"_LOGHR"  )
	aAdd(aHeadCpos,cAls1+"_LOGUSR" )

// Maximizacao da tela em rela็ใo a area de trabalho
	aSizeAut := MsAdvSize()
	nSpceBar := 0 //Por nใo usar o EnchoiceBar, vou consumir o espa็o dele na tela
	aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4]+nSpceBar,3,3}
	aObjects := {}

	aAdd(aObjects,{100,055,.T.,.F.}) //Cabe็alho
	aAdd(aObjects,{100,100,.T.,.T.}) //Corpo
	aAdd(aObjects,{100,020,.T.,.F.}) //Rodape
	aPosObj  := MsObjSize(aInfo,aObjects)

//Variaveis do tamanho a tela
	aDlgTela := {aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5]}

// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

	fGerCabec(aPosObj[1],oDialg,cOper)	// Cabecalho
	fGerCorpo(aPosObj[2],oDialg,cOper) // Resultado
	fGerRodap(aPosObj[3],oDialg,cOper) // Rodape

	Activate MsDialog oDialg

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerCorpo บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerCorpo(aSizeDlg,oDialg,cOper)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := Nil                                             // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHead          := {}                                              // Array do aHeader
	Local aColsAA        := {}                                              // Array do aCols

//          X3_TITULO    , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO , X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(aHead,{""           ,"AA_FLAG"      ,"@BMP"               ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{""           ,"AA_STATUS"    ,"@BMP"               ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

	For x:=1 To Len(aHeadCpos)
		cX3_Descr := fX3Ret(aHeadCpos[x],"X3_TITULO" )
		cX3_Campo := fX3Ret(aHeadCpos[x],"X3_CAMPO"  )
		cX3_Tipo  := fX3Ret(aHeadCpos[x],"X3_TIPO"   )
		cX3_Pictu := fX3Ret(aHeadCpos[x],"X3_PICTURE")
		nX3_Tam01 := fX3Ret(aHeadCpos[x],"X3_TAMANHO")
		nX3_Tam02 := fX3Ret(aHeadCpos[x],"X3_DECIMAL")
		cX3_CbBox := fX3Ret(aHeadCpos[x],"X3_CBOX"   )
		aAdd(aHead,{cX3_Descr,cX3_Campo      ,cX3_Pictu            ,   nX3_Tam01,  nX3_Tam02, ""      , "€€€€€€€€€€€€€€", cX3_Tipo, ""      , "R"        , cX3_CbBox          , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	Next x

	aAdd(aHead,{"Recno"     ,"AA_RECNO"     ,""                   ,          14,          0, ""      , "€€€€€€€€€€€€€€", "N"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
	aAdd(aColsAA,Array(Len(aHead)+1))
	nLin := Len(aColsAA)

//Alimenta a linha do aCols vazia
	aColsAA[nLin, aScan(aHead,{|x|AllTrim(x[2])=="AA_FLAG"  }) ] := "LBNO"
	aColsAA[nLin, aScan(aHead,{|x|AllTrim(x[2])=="AA_STATUS"}) ] := "ENABLE"

	For y:=1 To Len(aHeadCpos)
		aColsAA[nLin, aScan(aHead,{|x|AllTrim(x[2])==aHeadCpos[y]}) ] := CriaVar(aHeadCpos[y],.F.)
	Next y

	aColsAA[nLin, Len(aHead)+1] := .F.

	oAAGetDad:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aColsAA)
	oAAGetDad:oBrowse:bLDblClick := {|| fGerDpClic() }
	oAAGetDad:oBrowse:bHeaderClick := {|x,y| fGerTrtCol(y)  }

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerDpClicบAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerDpClic()

	Local nLinhaOK := oAAGetDad:oBrowse:nAt
	Local nAAFLAG := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])=="AA_FLAG"  })

//Marca apenas o registro em questใo
	If oAAGetDad:aCols[nLinhaOK][nAAFLAG] == "LBTIK"
		oAAGetDad:aCols[nLinhaOK][nAAFLAG] := "LBNO"
	Else
		oAAGetDad:aCols[nLinhaOK][nAAFLAG] := "LBTIK"
	EndIf

//Atualiza tela
	oAAGetDad:oBrowse:nAt := nLinhaOK
	oAAGetDad:oBrowse:Refresh()
	oAAGetDad:oBrowse:SetFocus()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerTrtColบAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerTrtCol(nCol)

	Local x        := 1
	Local nLinhaOK := oAAGetDad:oBrowse:nAt
	Local nAAFLAG := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])=="AA_FLAG"})

	Default nCol      := 1

//Conta de cliques
	nCtrlClik ++

//Controla pra evitar passar por duas vezes na mesma rotina
	If nCtrlClik%2 != 0
		Return
	EndIF

	If nCol == nAAFLAG
		//Marca apenas o registro em questใo
		If oAAGetDad:aCols[nLinhaOK][nAAFLAG] == "LBTIK"
			For x:=1 To Len(oAAGetDad:aCols)
				oAAGetDad:aCols[x][nAAFLAG] := "LBNO"
			Next x
		Else
			For x:=1 To Len(oAAGetDad:aCols)
				oAAGetDad:aCols[x][nAAFLAG] := "LBTIK"
			Next x
		EndIf

	EndIf

//Tratamento de Ordena็ใo
	If nCol != nAAFLAG

		//Trata historico de ordena็ใo, no maximo 3
		If Len(aOrdHead) >= 3
			While Len(aOrdHead) >= 3
				aDel(aOrdHead,1)
				aSize(aOrdHead,Len(aOrdHead)-1)
			End
		EndIf

		//Adicionar coluna pra ordena็ใo
		aAdd(aOrdHead,nCol)

		MsAguarde({|x,y| fGerOrdena() },"Ordenando...","Aguarde, ordenando registros ... ")

	EndIf

//Atualiza tela
	oAAGetDad:oBrowse:nAt := nLinhaOK
	oAAGetDad:oBrowse:Refresh()
	oAAGetDad:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerOrdenaบAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerOrdena()

	Do Case
	Case Len(aOrdHead) == 1
		aSort(oAAGetDad:aCols,,,{|x,y| fAjustaVar(x[aOrdHead[1]])                                                                    < fAjustaVar(y[aOrdHead[1]]) })

	Case Len(aOrdHead) == 2
		aSort(oAAGetDad:aCols,,,{|x,y| fAjustaVar(x[aOrdHead[2]]) + fAjustaVar(x[aOrdHead[1]])                                      < fAjustaVar(y[aOrdHead[2]]) + fAjustaVar(y[aOrdHead[1]]) })

	Case Len(aOrdHead) == 3
		aSort(oAAGetDad:aCols,,,{|x,y| fAjustaVar(x[aOrdHead[3]]) + fAjustaVar(x[aOrdHead[2]]) + fAjustaVar(x[aOrdHead[1]])        < fAjustaVar(y[aOrdHead[3]]) + fAjustaVar(y[aOrdHead[2]]) + fAjustaVar(y[aOrdHead[1]]) })

	EndCase

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfAjustaVarบAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAjustaVar(uVar)

	Local   cRet        := ""
	Private uTipoVarTmp := uVar

	Do Case
	Case Type("uTipoVarTmp") == "D"
		cRet := DtoS(uTipoVarTmp)

	Case Type("uTipoVarTmp") == "N"
		cRet := StrZero(uTipoVarTmp,14,4)

	Case Type("uTipoVarTmp") == "L"
		cRet := IIf(uTipoVarTmp,"T","F")

	Case Type("uTipoVarTmp") == "U"
		cRet := ""

	Case Type("uTipoVarTmp") == "C"
		cRet := Upper(AllTrim(uTipoVarTmp))

	Otherwise
		cRet := ""

	EndCase

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerRodap บAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerRodap(aSizeDlg,oDialg,cOper)

	Local nQtdCpo := 8
	Local nTamBtn := (aSizeDlg[4] / nQtdCpo)
	Local aBtn00  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 4)  ,  nTamBtn-05, 012}
	Local aBtn01  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 5)  ,  nTamBtn-05, 012}
	Local aBtn02  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 6)  ,  nTamBtn-05, 012}
	Local aBtn03  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 7)  ,  nTamBtn-05, 012}

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Botoes
	@ aBtn00[1],aBtn00[2] Button "Historico"            Size aBtn00[3],aBtn00[4] Pixel Of oDialg Action fGerHistor()
	@ aBtn01[1],aBtn01[2] Button "Legenda"              Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fGerLegend()
	If cOper == "E"
		@ aBtn02[1],aBtn02[2] Button "Exportar Arquivo" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action ( fGerPrcExp() , oDialg:End() )
	Else
		@ aBtn02[1],aBtn02[2] Button "Gerar Documento"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action ( fGerPrcImp() , oDialg:End() )
	EndIf
	@ aBtn03[1],aBtn03[2] Button "Sair"                 Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action oDialg:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerHistorบAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerHistor()

	Local cTab1    := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local nPosRecn := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])=="AA_RECNO" })
	Local nLinHist := oAAGetDad:oBrowse:nAt
	Local nRecHist := oAAGetDad:aCols[nLinHist][nPosRecn]

//Posiciona no Registro que serแ exibido o Historico
	(cTab1)->(DbGoTo(nRecHist))

//Chama rotina que exibe o historico
	U_GXNHis()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerPrcImpบAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ  Gera Pre-Nota Fiscal                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerPrcImp()

	If Len(oAAGetDad:aCols) > 0
		Processa( {|| fGerPrcXml()    },"Processando XML selecionados..." )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerPrcXmlบAutor  ณFelipe Aurelio      บ Data ณ  14/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerPrcXml()

	Local x        := 0
	Local lProc    := .T.
	Local nRecTab1 := 0
	Local cTipoXml := ""
	Local oXmlTab1 := Nil

	Local cTab1        := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

	Local nAAFLAG  := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==    "AA_FLAG"  })
	Local nPosRecn := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==    "AA_RECNO" })
	Local nPosTXml := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==cAls1+"_TIPXML"})

	ProcRegua(Len(oAAGetDad:aCols))

	For x:=1 To Len(oAAGetDad:aCols)
		If oAAGetDad:aCols[x][nAAFLAG] == "LBTIK"
			IncProc()

			//Recno do registro corrente
			nRecTab1 :=  0
			nRecTab1 := oAAGetDad:aCols[x][nPosRecn]

			//Tipo do XML do registro corrente
			cTipoXml := oAAGetDad:aCols[x][nPosTXml]

			//Validando e Preparando NFe
			If cTipoXml == "1"
				//Valida XML e monta Objeto
				oXmlTab1 := Nil
				lProc    := .T.
				lProc    := fGerVldNFe(nRecTab1,@oXmlTab1)
			EndIf

			//Validando e Preparando CTe
			If cTipoXml == "2"
				//Valida XML e monta Objeto
				oXmlTab1 := Nil
				lProc    := .T.
				lProc    := fGerVldCTe(nRecTab1,@oXmlTab1)
			EndIf
		EndIf
	Next x

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerVldNFeบAutor  ณFelipe Aurelio      บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerVldNFe(nRecTab1,oXmlTab1)

	Private x         :=  0
	Private lProc     := .T.
	Private _lTagPC   := iif(AllTrim(SuperGetMv("MX_MRTAGPC",,"S")) == "S",.T.,.F.)
	Private cTab1     := AllTrim(GetMV("MX_MRALS01"))
	Private cAls1     := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Private cAviso    := ""
	Private cErro     := ""
	Private cMmXml    := ""
	Private lEhFornec := .F.
	Private cCodCliFor:= ""
	Private cLojCliFor:= ""
	Private cNomCliFor:= ""
	Private cCndCliFor:= ""
	Private cCodProdut:= ""
	Private _cNumPC	:= ""
	Private cCodNatur := AllTrim(GetMV("MX_MRNATUR"))
	Private aCabec    := {}
	Private aItens    := {}
	Private aUnidMed  := {}
	Private aPrdDesc  := {}
	Private aPrdXML	:= {}
	Private aFatorCon := {}
	Private aPrdNcm   := {}

	Private cMsgErro  := ""
	Private cMsErro2  := ""
	Private cMsgNota  := ""
	Private cMsgAssu  := ""
	Private cMsgFoCl  := ""

	Private cCpoUmXml := ""
	Private cCpoFCNum := ""
	Private cCpoFCTip := ""
	Private lFatorCnv := .F.

	Private nCadFatCon:= 0
	Private cCadTipCon:= ""
	Private cOperConv := ""
	Private nQtdProd  := 0

	Private oNFe    	:= Nil
	Private oNF     	:= Nil
	Private oItens  	:= Nil
	Private oItemTemp := Nil
	Private aMRSXPE01 := Nil

	Private _cxCusto  :=space(Len(SD1->D1_CC))    // Alimenta Centro de Custo quando nao tem PC
	Private _cxLocal  :=space(Len(SD1->D1_LOCAL)) // Alimenta aRMAZEM quando nao tem PC
	Private _lTagPC   := iif(AllTrim(SuperGetMv("MX_MRTAGPC",,"S")) == "S",.T.,.F.)


//Posiciona no registro correto
	(cTab1)->(DbGoTo(nRecTab1))

//Valida Status, pois s๓ pode executar se STATUS == 1
	If lProc .And. (cTab1)->&(cAls1+"_STATUS") != "1"
		fGravaMsg(nRecTab1,11," ")
		lProc := .F.
	EndIf

//Valida se XML ้ do tipo NF
	If lProc .And. (!(cTab1)->&(cAls1+"_TIPDOC") $ "N/C/D/B/I" )      //  28/01/2018 - Adicionado tratamento para COMPLEMENTO DE ICMS
		fGravaMsg(nRecTab1,14,"4")
		lProc := .F.
	EndIf

//Valida se XML ้ do tipo NF
	If lProc .And. (!(cTab1)->&(cAls1+"_TIPXML") $ "1" )
		fGravaMsg(nRecTab1,14,"4")
		lProc := .F.
	EndIf

//Prepara String XML para tornar em Objeto
	If lProc
		cMmXml   := ""
		cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
		cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))
		//cMmXml   := EncodeUTF8(cMmXml)
		If Empty(cMmXml)
			//XML pendente de recebimento ( Status = 0 )
			lProc := .F.
			fGravaMsg(nRecTab1,12,"0")
		EndIf
	EndIf

//Converte String XML em Objeto XML
	If lProc
		cAviso   := ""
		cErro    := ""
		oXmlTab1 := Nil
		oXmlTab1 := XmlParser(cMmXml,"_",@cAviso,@cErro)
		Do Case
		Case !Empty(cErro)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		Case !Empty(cAviso)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		Case Empty(oXmlTab1)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		OtherWise
			//Prepara Objeto pra receber XML
			oNFe := oXmlTab1
			oNF  := IIf(Type("oNFe:_NfeProc")<>"U" , oNFe:_NFeProc:_NFe , oNFe:_NFe)

		EndCase
	EndIf

//Identifica se ้ cliente ou fornecedor e o codigo correto
	If lProc
		cCodCliFor := ""
		cLojCliFor := ""
		cNomCliFor := ""
		cCndCliFor := ""
		cCodNatur  := AllTrim(GetMV("MX_MRNATUR"))
		lEhFornec  := .F.
		Do Case
		Case (cTab1)->&(cAls1+"_TIPDOC") $ "N/C/I"   //  28/01/2018 - Adicionado tratamento para COMPLEMENTO DE ICMS
			lEhFornec  := .T.
			SA2->(DbSetOrder(3))
			If SA2->(DbSeek(xFilial("SA2")+(cTab1)->&(cAls1+"_DECNPJ")))
				cCodCliFor := SA2->A2_COD
				cLojCliFor := SA2->A2_LOJA
				cNomCliFor := SA2->A2_NOME
				cCndCliFor := SA2->A2_COND
				if !empty(Alltrim(SA2->A2_NATUREZ))
					cCodNatur  := SA2->A2_NATUREZ
				endif
			Else
				fGravaMsg(nRecTab1,2,"7")
				lProc := .F.
			EndIf

		Case (cTab1)->&(cAls1+"_TIPDOC") $ "D/B"
			lEhFornec  := .F.
			SA1->(DbSetOrder(3))
			If SA1->(DbSeek(xFilial("SA1")+(cTab1)->&(cAls1+"_DECNPJ")))
				cCodCliFor := SA1->A1_COD
				cLojCliFor := SA1->A1_LOJA
				cNomCliFor := SA1->A1_NOME
				cCndCliFor := SA1->A1_COND
				if !empty(Alltrim(SA1->A1_NATUREZ))
					cCodNatur  := SA1->A1_NATUREZ
				endif
			Else
				fGravaMsg(nRecTab1,1,"7")
				lProc := .F.
			EndIf

		EndCase
	EndIf


//Verifica se Exibe Mensagem para Relacionar Produtos na TELA de PEDICO DE COMPRA ou na AMARRACAO PADRAO
	lProcPC := .F.

	_cxCusto:=space(Len(SD1->D1_CC))    // Alimenta Centro de Custo quando nao tem PC
	_cxLocal:=space(Len(SD1->D1_LOCAL)) // Alimenta aRMAZEM quando nao tem PC


	If lProc

		cMsgPC    := AllTrim(SuperGetMv("MX_MRMSGPC",,"S"))
		If cMsgPC == "S"

			(cTab1)->(DbGoTo(nRecTab1))
			//Reseta as variaveis para Exibir Mensagem
			aCabec := {}
			aadd(aCabec,{"F1_TIPO"    ,(cTab1)->&(cAls1+"_TIPDOC")                      ,Nil,Nil})
			aadd(aCabec,{"F1_FORMUL"  ,"N"                                              ,Nil,Nil})
			aadd(aCabec,{"F1_DOC"     ,(cTab1)->&(cAls1+"_DOC"   )                      ,Nil,Nil})
			aadd(aCabec,{"F1_SERIE"   ,(cTab1)->&(cAls1+"_SERIE" )                      ,Nil,Nil})

			if .T. // SimNao("Deseja relacionar a pre-nota "+Alltrim(aCabec[3,2])+" / "+Alltrim(aCabec[4,2])+" a um pedido de compra?") == "S"
				lProcPC := .T.
			ELSE
				fGerSA5()
			Endif
		Else
			fGerSA5()
		EndIf

	EndIf

//Prepara aCabec pro MsExecAuto
	If lProc
		//Posiciona no registro correto
		(cTab1)->(DbGoTo(nRecTab1))

		//Reseta as variaveis
		aCabec := {}
		aadd(aCabec,{"F1_TIPO"    ,(cTab1)->&(cAls1+"_TIPDOC")							,Nil,Nil})
		aadd(aCabec,{"F1_FORMUL"  ,"N"  												,Nil,Nil})
		aadd(aCabec,{"F1_DOC"     ,(cTab1)->&(cAls1+"_DOC"   )  						,Nil,Nil})
		aadd(aCabec,{"F1_SERIE"   ,(cTab1)->&(cAls1+"_SERIE" )      					,Nil,Nil})

		cCndCliFor := IIf(Empty(cCndCliFor),"001",cCndCliFor)
		if !empty(_cNumPC)
			cCndCliFor :=	Posicione('SC7',1,xFilial('SC7')+_cNumPC,"C7_COND")
		endif
		aadd(aCabec,{"F1_COND"    ,cCndCliFor											,Nil,Nil})
		aadd(aCabec,{"F1_EMISSAO" ,(cTab1)->&(cAls1+"_DTEMIS")       					,Nil,Nil})
		aadd(aCabec,{"F1_FORNECE" ,cCodCliFor                           				,Nil,Nil})
		aadd(aCabec,{"F1_LOJA"    ,cLojCliFor    										,Nil,Nil})
		aadd(aCabec,{"F1_ESPECIE" ,"SPED"                     							,Nil,Nil})
		aadd(aCabec,{"F1_CHVNFE"  ,(cTab1)->&(cAls1+"_CHVNFE")     						,Nil,Nil})
		If SF1->(FieldPos("F1_XGESTOR"))>0
			aadd(aCabec,{"F1_XGESTOR" ,"S"                    							,Nil,Nil})
		EndIf

		if AllTrim(GetMV("MX_MRCLASS"))	== "C"
			aadd(aCabec,{"E2_NATUREZ" ,cCodNatur                                    ,Nil,Nil})
		endif

	EndIf

//Prepara aItens pro MsExecAuto
	If lProc
		//Reseta as variaveis
		aItens := {}

		oItens := IIf(Type("oNF:_InfNfe:_Det")=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
		For x := 1 To Len(oItens)

			//------------------------------------------------------------
			//Variavel usada pra conseguir tratar via Type
			oItemTemp  := Nil
			oItemTemp  := oItens[x]

			//Reseta as variaveis
			aLinha     := {}
			nCadFatCon := 1
			cCadTipCon := "M"
			cOperConv  := ""
			nQtdProd   := 0

			cXmlProduto := AllTrim(oItemTemp:_Prod:_cProd:TEXT)
			cXmlPrdNcm := AllTrim(oItemTemp:_Prod:_NCM:TEXT)

			If lEhFornec
				//Tratando tamanho do conteudo do campo
				cXmlProduto := fTrtCodPrd(cXmlProduto,"1")

				SA5->(dbSetOrder(14))
				If SA5->(dbSeek(xFilial("SA5")+cCodCliFor+cLojCliFor+cXmlProduto))
					AADD(aFatorCon,{SA5->A5_XXFCNUM,SA5->A5_XXFCTIP})
				Else
					AADD(aFatorCon,{0,""})
				EndIf
				//Se campos Fator Conversao Unidade Medido OK, entใo calcular
				If lFatorCnv
					nCadFatCon := &("SA5->"+cCpoFCNum)
					cCadTipCon := &("SA5->"+cCpoFCTip)
				EndIf

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
			Else
				//Tratando tamanho do conteudo do campo
				cXmlProduto := fTrtCodPrd(cXmlProduto,"2")

				SA7->(dbSetOrder(3))
				SA7->(dbSeek(xFilial("SA7")+cCodCliFor+cLojCliFor+cXmlProduto))
				//Se campos Fator Conversao Unidade Medido OK, entใo calcular
				If lFatorCnv
					nCadFatCon := &("SA7->"+cCpoFCNum)
					cCadTipCon := &("SA7->"+cCpoFCTip)
				EndIf

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
			Endif

			If cCadTipCon == "D"
				cOperConv := "/"+AllTrim(Str(nCadFatCon,10,4))
			EndIf
			If cCadTipCon == "M"
				cOperConv := "*"+AllTrim(Str(nCadFatCon,10,4))
			EndIf

			nQtdProd := 0
			If !Empty(cOperConv)
				nQtdProd := Alltrim(oItemTemp:_Prod:_qCom:TEXT )+cOperConv
				nQtdProd := &(nQtdProd)
			Else
				nQtdProd := Val(oItemTemp:_Prod:_qCom:TEXT)
			EndIf


			if U_VALIDACAO()  // MAURESI - 23/09/2021  -  REPLICA PRODUTO XML PARA PRODUTO QDO FOR FILIAL DOMEX
				if _lDmxFilial
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+cXmlProduto))
				endif
			endif


			aadd(aLinha,{"D1_COD",SB1->B1_COD,Nil,Nil})

			If _lTagPC .And. Type("oItemTemp:_Prod:_xPed") <> "U" .And. (cTab1)->&(cAls1+"_TIPDOC") == "N"
				uVarTemp := Nil
				uVarTemp := Upper(AllTrim(oItemTemp:_Prod:_xPed:TEXT))
				If !Empty(uVarTemp) .And. !(uVarTemp $ "0000000000")
					uVarTemp := "0000000000"+uVarTemp
					uVarTemp := Right(uVarTemp,fX3Ret("D1_PEDIDO","X3_TAMANHO"))
					aadd(aLinha,{"D1_PEDIDO",uVarTemp,Nil,Nil})
				EndIf
			Else
				aadd(aLinha,{"D1_PEDIDO","",Nil,Nil})
			Endif

			If _lTagPC  .And. Type("oItemTemp:_Prod:_nItemPed") <> "U" .And. (cTab1)->&(cAls1+"_TIPDOC") == "N"
				uVarTemp := Nil
				uVarTemp := Upper(AllTrim(oItemTemp:_Prod:_nItemPed:TEXT))
				If !Empty(uVarTemp) .And. !(uVarTemp $ "0000000000")
					uVarTemp := "0000000000"+uVarTemp
					uVarTemp := Right(uVarTemp,fX3Ret("D1_ITEMPC","X3_TAMANHO"))
					aadd(aLinha,{"D1_ITEMPC",uVarTemp,Nil,Nil})
				EndIf
			Else
				aadd(aLinha,{"D1_ITEMPC","",Nil,Nil})
			Endif

			aadd(aLinha,{"D1_QUANT",nQtdProd,Nil,Nil})
			aadd(aLinha,{"D1_VUNIT",Val(oItemTemp:_Prod:_vUnCom:TEXT),Nil,Nil})
			aadd(aLinha,{"D1_TOTAL",Val(oItemTemp:_Prod:_vProd:TEXT) ,Nil,Nil})

			If Type("oItemTemp:_Prod:_vDesc")<> "U"
				aadd(aLinha,{"D1_VALDESC",Val(oItemTemp:_Prod:_vDesc:TEXT),Nil,Nil})
			Else
				aadd(aLinha,{"D1_VALDESC",0,Nil,Nil})
			Endif

			if U_VALIDACAO() .or. .T.     // MAURESI - Em producao - 23/08/2021
				// ADICIONA FRETE - MAURESI 18/08/2021
				If Type("oItemTemp:_Prod:_vFrete")<> "U"
					aadd(aLinha,{"D1_VALFRE",Val(oItemTemp:_Prod:_vFrete:TEXT),Nil,Nil})
				Else
					aadd(aLinha,{"D1_VALFRE",0,Nil,Nil})
				Endif
			endif


			Do Case
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS00")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS00
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS10")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS10
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS20")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS20
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS30")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS30
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS40")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS40
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS51")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS51
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS60")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS60
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS70")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS70
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS90")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS90
			EndCase

			If Type("oICM") <> "U"
				CST_Aux := Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT)
				aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})  // MAURESI 12/08/2021 - inibida linha do D1_CLASFIS abaixo
			Else
				CST_Aux := ""
			EndIf
			//aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})
			cAdic := IIf(Type("oItemTemp:_InfAdProd:TEXT") != "U",oItemTemp:_InfAdProd:TEXT,"")

			// Adiciona no aLinha, dados do Centro de Custo/Armazem quando nao existe PC amarrado
			aadd(aLinha,{"D1_LOCAL",_cxLocal,Nil,Nil})
			aadd(aLinha,{"D1_CC"   ,_cxCusto,Nil,Nil})

			// Adiciona Data de Validade do Lote com data Fixa em 31/12/2049 (Necessidade Domex)
			_cDtValid	:= StoD("20491231")
			aadd(aLinha,{"D1_DTVALID"   ,_cDtValid,Nil,Nil})

			// Adiciona TES INTELIGENTE DE ENTRADA
			If  _lTesINT

				IF AllTrim(GetMV("MX_MRCLASS"))	== "C"
					_cProd		:= SB1->B1_COD
					_cFornec	:= cCodCliFor
					_cLojaFor	:= cLojCliFor

					IF !Empty(Alltrim(cFullOper))   // MAURESI - 12/08/2020
						_cOper		:= cFullOper
					else
						_cOper		:= "01"
					Endif


					_cTesEnt	:= Alltrim( U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper) )

					// MAURESI 11/08/2021 - Retorna Falso se nใo encontrar TES.
					//if empty(Alltrim(_cTesEnt))
					//	_lTESOK := .F.
					//endif

					If !Empty(Alltrim(_cTesEnt))
						aadd(aLinha,{"D1_TES"	,Alltrim(_cTesEnt)  ,Nil,Nil})
					ELSE
						_lTESOK := .F. 											// MAURESI - 17/08/2021  -APAGAR
						aadd(aLinha,{"D1_TES"	,Alltrim(_cTesEnt)  ,Nil,Nil})	// MAURESI - 17/08/2021  -APAGAR

					EndIf

					If !Empty(Alltrim(_cOper))
						aadd(aLinha,{"D1_XOPER"	,Alltrim(_cOper)	,Nil,Nil})
					else
						_lTESOK := .F. 											// MAURESI - 17/08/2021  -APAGAR
						aadd(aLinha,{"D1_XOPER"	,Alltrim(_cOper)	,Nil,Nil})	// MAURESI - 17/08/2021  -APAGAR

					EndIf
				ELSE
					aadd(aLinha,{"D1_TES"	  ,""      ,Nil,Nil})
					aadd(aLinha,{"D1_XOPER"	  ,"00"	   ,Nil,Nil})
				ENDIF

			else
				aadd(aLinha,{"D1_TES","",Nil,Nil})
				aadd(aLinha,{"D1_XOPER","00",Nil,Nil})
			Endif



			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณP.E. (MRSXPE01) - Ponto de Entrada para Carregar Dados Adicionais  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If ExistBlock("MRSXPE01")
				aMRSXPE01 := Nil
				aMRSXPE01 := ExecBlock("MRSXPE01",.F.,.F.,{cAdic})

				If Type("aMRSXPE01") == "A"
					For y:=1 To Len(aMRSXPE01)
						aAdd(aLinha,aMRSXPE01[y])
					Next y
				Else
					MsgAlert("PE MRSXPE01 estแ com erro de retorno, favor verificar.")
				EndIf
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณFim P.E. (MRSXPE01)                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			aAdd(aUnidMed,oItemTemp:_Prod:_uCom:TEXT  )
			aAdd(aPrdDesc,oItemTemp:_Prod:_xProd:TEXT )
			aAdd(aPrdNcm, oItemTemp:_Prod:_NCM:TEXT   )
			aAdd(aPrdXML ,cXmlProduto                 )		//	cXmlProduto := AllTrim(oItemTemp:_Prod:_cProd:TEXT)

			aadd(aItens,aLinha)

		Next x

		nD1PEDIDO  := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_PEDIDO"  })
		nD1ITEMPC  := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_ITEMPC"  })
		nD1COD     := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_COD"     })
		nD1QUANT   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_QUANT"   })
		nD1TOTAL   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_TOTAL"   })
		nD1VUNIT   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_VUNIT"   })
		nD1VALDESC := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_VALDESC" })
		nD1LOCAL   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_LOCAL"   })
		nD1CC      := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_CC"      })
		nD1TES     := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_TES" 	})
		nD1OPER    := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_XOPER"	})
		nD1VALFRE  := aScan(aItens[1] , { |k| Alltrim(k[1]) == "D1_VALFRE"  })
	EndIf


	_lDmxFilial := .F.
	IF U_VALIDACAO()  // MAURESI 21/09/2021 - NAO PEDE PC PARA FILIAL ROSENBERGER

		if cCodCliFor $ "004500"		// Rosenberger MG (Filial)
			_lDmxFilial := .T.
		endif

	Endif



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua Relacionamento do Pedido de Compraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lProc .And. lProcPC .And. Len(aItens) > 0
		lProc := fLinkNFxPC(aCabec,@aItens,aUnidMed,aPrdDesc,aPrdXML)
	EndIf

//Executa rotina de inclusใo Pre-Nota
	If lProc .And. Len(aItens) > 0

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe for SHA, solicita Modalidade de Pagamentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		lMsErroAuto := .F.
		lMsHelpAuto := .T.

/*
		// MAURESI - 11/08/2021
		// Testa se existe TES sem preencher e gera Pre-Nota
		_lTESOK := .T.
		For M :=1 to len(aItens)
			if Empty(Alltrim(aItens[M,nD1TES]))
			     Alert("MAURESI - Tes em branco:" )
				_lTESOK := .F.
			endif

		Next M
*/


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGera NF somente se for _lTESOKณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cDocGerado := ""

		// Execauto de NF. CTE ้ lแ pra baixo
		if AllTrim(GetMV("MX_MRCLASS"))	== "C"   .and. _lTESOK //.and. !empty(Alltrim(nD1TES))

			MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens,3)      //DOCUMENTO DE ENTRADA
			_cDocGerado :="DOC"
		else

			MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)   // execauto 1      -  PRE-NOTA FUNCIONANDO
			_cDocGerado :="PRE"
		endif

		If lEhFornec
			cMsgFoCl := aCabec[7,2]+aCabec[8,2]
			cMsgFoCl := "Fornecedor: "+aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA2",1,xFilial("SA2")+cMsgFoCl,"A2_NREDUZ")
		Else
			cMsgFoCl := aCabec[7,2]+aCabec[8,2]
			cMsgFoCl := "Cliente: "   +aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA1",1,xFilial("SA1")+cMsgFoCl,"A1_NREDUZ")
		EndIf

		If lMsErroAuto
			lProc := .F.
			RollBackSxe()

			cMsErro2 := "<br>Arquivo: "+(cTab1)->&(cAls1+"_ARQUIV")
			cMsErro2 += "<br>Data/Hora:"   +DtoC(Date()) +" / "+ Time()
			cMsErro2 += "<br><br>Erro MsExecAuto: "
			cMsErro2 += "<br><br>"         +MostraErro("\data\GestorXml\Log\")

			cMsgErro := "Erro na execu็ใo do MsExecAuto para gera็ใo do Documento - " + _cDocGerado
			cMsgNota := "N๚mero DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
			cMsgAssu := "[Documento] Erro na importa็ใo do XML "

			fWfGerXml("INTEGRACAO XML x DOCUMENTO", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl+"<br>"+cMsErro2)
			fGravaMsg(nRecTab1,98,"4",cMsgErro+" - "+cMsgNota)

			MsgAlert(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl + cMsErro2)


			// Workflow de Erro
			cAssunto := cMsgAssu + " " + cMsgNota
			cTexto   := cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl+"<br>"+cMsErro2
			cPara    := "marco.aurelio@opusvp.com.br;"
			cCC      := ""	
			cArquivo := ""			
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)



		Else

			lProc := .T.
			ConfirmSX8()

			cArquivo := GeraXML()   // Gera o XML na pasta mapeada na mแquina do usuแrio

			cMsgErro := "Documento Gerado Com Sucesso!"
			cMsgNota := "N๚mero DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
			cMsgAssu := "Documento Gerado com sucesso : ["+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+"]"

			fWfGerXml("INTEGRACAO XML x DOCUMENTO", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl)
			fGravaMsg(nRecTab1,98,"3",cMsgErro+" - "+cMsgNota)

			MsgInfo(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)

			// mauresi - 21/06/2021
			// Envia Workflow Apos geracao de PRE-NOTA (Recebimento)
			if _cDocGerado =="PRE"  .or. _cDocGerado =="DOC"

				cAssunto := "[" +_cDocGerado + "] RDT-Recebimento - NF: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])

				cTexto 	:= "Gerado Documento  [" +_cDocGerado + "] NF: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])  + Chr(13)+ Chr(13)
				If lEhFornec
					cMsgFoCl := aCabec[7,2]+aCabec[8,2]
					cMsgFoCl := "Fornecedor: "+aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA2",1,xFilial("SA2")+cMsgFoCl,"A2_NREDUZ")
				Else
					cMsgFoCl := aCabec[7,2]+aCabec[8,2]
					cMsgFoCl := "Cliente: "   +aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA1",1,xFilial("SA1")+cMsgFoCl,"A1_NREDUZ")
				EndIf
				cTexto 	+= cMsgFoCl + Chr(13)
				cTexto   := StrTran(cTexto,Chr(13),"<br>")

				cPara    := "priscila.silva@rdt.com.br;dayana.serra@rosenbergerdomex.com.br;ludmila.guimaraes@rosenbergerdomex.com.br;"
				cCC      := "denis.vieira@rosenbergerdomex.com.br" //"marco.aurelio@opusvp.com.br;helio@opusvp.com.br"
				//cArquivo := ""

				U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

			Endif

			// AtualiZA FLAG de Libera็ใo de Etiqueta  // MAURESI
			Reclock("SF1",.F.)
			SF1->F1_XBLQXML := "S"
			SF1->(msunlock())


			//Endif


			//?????????????????????????????????????????????????????????
			//?Abre Tela de Classificacao de NF ap?s Inclus?o de Pr?-NF?
			//??????????????????????????????????????????????????????????
			if AllTrim(GetMV("MX_MRCLASS"))	== "S"

				//			nOpc := 4
				//			nOpcX := 4
				l103Class	:= .T.
				l103TolRec  := .T.
				l103Visual	:=	.F.
				l103Exclui	:= .F.
				INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
				ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)

				A103NFiscal('SF1',SF1->(RECNO()),3)

			Endif
		EndIf
	Endif

Return(lProc)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerVldCteบAutor  ณFelipe Aurelio      บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerVldCte(nRecTab1,oXmlTab1)

	Private x         :=  0
	Private lProc     := .T.
	Private _lTagPC   := iif(AllTrim(SuperGetMv("MX_MRTAGPC",,"S")) == "S",.T.,.F.)
	Private cTab1     := AllTrim(GetMV("MX_MRALS01"))
	Private cAls1     := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Private cAviso    := ""
	Private cErro     := ""
	Private cMmXml    := ""
	Private lEhFornec := .F.
	Private cCodCliFor:= ""
	Private cLojCliFor:= ""
	Private cNomCliFor:= ""
	Private cCndCliFor:= ""
	Private cCodProdut:= ""
	Private cCodNatur := AllTrim(GetMV("MX_MRNATUR"))
	Private aCabec    := {}
	Private aItens    := {}
	Private aUnidMed  := {}
	Private aPrdDesc  := {}
	Private aPrdXML	:= {}
	Private aFatorCon := {}
	Private aPrdNcm   := {}

	Private cMsgErro  := ""
	Private cMsErro2  := ""
	Private cMsgNota  := ""
	Private cMsgAssu  := ""
	Private cMsgFoCl  := ""

	Private cCpoUmXml := ""
	Private cCpoFCNum := ""
	Private cCpoFCTip := ""
	Private lFatorCnv := .F.

	Private nCadFatCon:= 0
	Private cCadTipCon:= ""
	Private cOperConv := ""
	Private nQtdProd  := 0

	Private oNFe    	:= Nil
	Private oNF     	:= Nil
	Private oItens  	:= Nil
	Private oItemTemp := Nil
	Private aMRSXPE01 := Nil

//Posiciona no registro correto
	(cTab1)->(DbGoTo(nRecTab1))

//Valida Status, pois s๓ pode executar se STATUS == 1
	If lProc .And. (cTab1)->&(cAls1+"_STATUS") != "1"
		fGravaMsg(nRecTab1,11," ")
		lProc := .F.
	EndIf

//Valida o tipo do Documento
	If lProc .And. (!(cTab1)->&(cAls1+"_TIPDOC") $ "N/C/D/B/I" )    //  28/01/2018 - Adicionado tratamento para COMPLEMENTO DE ICMS
		fGravaMsg(nRecTab1,14,"4")
		lProc := .F.
	EndIf

//Valida se XML e do tipo CTE
	If lProc .And. (!(cTab1)->&(cAls1+"_TIPXML") $ "2" )
		fGravaMsg(nRecTab1,14,"4")
		lProc := .F.
	EndIf

//Prepara String XML para tornar em Objeto
	If lProc
		cMmXml   := ""
		cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
		cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))
		If Empty(cMmXml)
			//XML pendente de recebimento ( Status = 0 )
			lProc := .F.
			fGravaMsg(nRecTab1,12,"0")
		EndIf
	EndIf

//Converte String XML em Objeto XML
	If lProc
		cAviso   := ""
		cErro    := ""
		oXmlTab1 := Nil
		oXmlTab1 := XmlParser(cMmXml,"_",@cAviso,@cErro)
		Do Case
		Case !Empty(cErro)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.
		Case !Empty(cAviso)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.
		Case Empty(oXmlTab1)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.
		OtherWise
			//Prepara Objeto pra receber XML de CTE
			oNFe := oXmlTab1
			oNF  := IIf(Type("oNFe:_CteProc")<>"U" , oNFe:_CteProc:_Cte:_InfCte:_Ide:_NCT , oNFe:_NCT)
		EndCase
	EndIf

// Carrega Dados do Fornecedor
	If lProc
		cCodCliFor := ""
		cLojCliFor := ""
		cNomCliFor := ""
		cCndCliFor := ""
		cCodNatur  := AllTrim(GetMV("MX_MRNATUR"))
		lEhFornec  := .T.
		SA2->(DbSetOrder(3))
		If SA2->(DbSeek(xFilial("SA2")+(cTab1)->&(cAls1+"_DECNPJ")))
			cCodCliFor := SA2->A2_COD
			cLojCliFor := SA2->A2_LOJA
			cNomCliFor := SA2->A2_NOME
			cCndCliFor := SA2->A2_COND
			if !empty(Alltrim(SA2->A2_NATUREZ))
				cCodNatur  := SA2->A2_NATUREZ
			endif
		Else
			fGravaMsg(nRecTab1,2,"7")
			lProc := .F.
		EndIf
	EndIf

// Cria relacionamento no SA5
	If lProc
		fGerSA5()
	endif


//Prepara aCabec pro MsExecAuto
	If lProc
		//Posiciona no registro correto
		(cTab1)->(DbGoTo(nRecTab1))

		//Reseta as variaveis
		aCabec := {}
		aadd(aCabec,{"F1_TIPO"    ,(cTab1)->&(cAls1+"_TIPDOC")     						,Nil,Nil})
		aadd(aCabec,{"F1_FORMUL"  ,"N"                       							,Nil,Nil})
		aadd(aCabec,{"F1_DOC"     ,(cTab1)->&(cAls1+"_DOC"   )							,Nil,Nil})
		aadd(aCabec,{"F1_SERIE"   ,(cTab1)->&(cAls1+"_SERIE" ) 							,Nil,Nil})
		cCndCliFor := IIf(Empty(cCndCliFor),"001",cCndCliFor)
		aadd(aCabec,{"F1_COND"    ,cCndCliFor											,Nil,Nil})
		aadd(aCabec,{"F1_EMISSAO" ,(cTab1)->&(cAls1+"_DTEMIS")     						,Nil,Nil})
		aadd(aCabec,{"F1_FORNECE" ,cCodCliFor          									,Nil,Nil})
		aadd(aCabec,{"F1_LOJA"    ,cLojCliFor        									,Nil,Nil})
		aadd(aCabec,{"F1_ESPECIE" ,"CTE"                    							,Nil,Nil})
		aadd(aCabec,{"F1_CHVNFE"  ,(cTab1)->&(cAls1+"_CHVNFE")        					,Nil,Nil})
		aadd(aCabec,{"F1_TPCTE"   ,"N"                             						,Nil,Nil})

		//cUFDEST  	:= oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
		cUFDEST   	:= &('oNFe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT' )
		aadd(aCabec,{"F1_EST"     ,cUFDEST                            						,Nil,Nil})	// MAURESI - ESTADO CTE

		If SF1->(FieldPos("F1_XGESTOR"))>0
			aadd(aCabec,{"F1_XGESTOR" ,"S"                    							,Nil,Nil})
		EndIf

		if AllTrim(GetMV("MX_MRCLASS"))	== "C"
			aadd(aCabec,{"E2_NATUREZ" ,cCodNatur               						,Nil,Nil})
		endif

	EndIf

//Prepara aItens pro MsExecAuto
	If lProc
		//Reseta as variaveis
		aItens := {}

		oItens := IIf(Type("oNFe:_CteProc:_Cte:_InfCte:_vPrest")=="O",{oNFe:_CteProc:_Cte:_InfCte:_vPrest},oNFe:_CteProc:_Cte:_InfCte:_vPrest)
		oItens2:= IIf(Type("oNFe:_CteProc:_Cte:_InfCte:_imp")   =="O",{oNFe:_CteProc:_Cte:_InfCte:_imp}   ,oNFe:_CteProc:_Cte:_InfCte:_imp)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAdiciona Produto do CTEณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		//------------------------------------------------------------
		//Variavel usada pra conseguir tratar via Type
		oItemTemp  := Nil
		oItemTemp  := oItens[1] //oItens[x]
		oItemTemp2 := oItens2[1]	//oItens2[x]	//Armazena 2o Produto usado no CTE ( quando Base eh diferente de Valor total)

		//Reseta as variaveis
		aLinha     := {}
		nCadFatCon := 1
		cCadTipCon := "M"
		cOperConv  := ""
		nQtdProd   := 0

		cXmlVServ  := val(AllTrim(oItemTemp:_vTPrest:TEXT))
		cXmlVPed	  := 0
		cXmlPICM	  := 0
		cXmlVICM	  := 0
		// Identifica Qual campo de ICMS estแ preenchido e carrega o valor
		Do Case

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณMAURESI - Adicionado tratamento para usar Aliquota se ICM que vem no XML, e nao a calculada pelo sistema, ณ
			//ณpois ้ necessแrio usar a Aliquota do Cliente onde a mercadoria estแ sendo entregue.                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Case Type("oItemTemp2:_ICMS:_ICMS00")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS00:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS00:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS00:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS10")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS10:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS10:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS10:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS20")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS20:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS20:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS20:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS30")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS30:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS30:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS30:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS40")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS40:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS40:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS40:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS51")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS51:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS51:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS51:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS60")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS60:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS60:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS60:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS70")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS70:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS70:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS70:_vICMS:TEXT))
		Case Type("oItemTemp2:_ICMS:_ICMS90")<> "U"
			cXmlVPed   := val(AllTrim(oItemTemp2:_ICMS:_ICMS90:_vBC:TEXT))
			cXmlPICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS90:_pICMS:TEXT))
			cXmlVICM   := val(AllTrim(oItemTemp2:_ICMS:_ICMS90:_vICMS:TEXT))
		EndCase

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica de Base ้ diferente do Valor de Servicoณ
		//ณSe for, cria segunda linha na NFE               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_lpedag := .F.
		if cXmlVPed > 0 .and. cXmlVPed <> cXmlVServ
			cXmlVServ	:= val(AllTrim(oItemTemp2:_ICMS:_ICMS90:_vBC:TEXT))
			cXmlVPed		:= val(AllTrim(oItemTemp:_vTPrest:TEXT)) - 	val(AllTrim(oItemTemp2:_ICMS:_ICMS90:_vBC:TEXT))
			_lpedag 		:= .T.
		endif

		cCodCTE			:= Alltrim(GETMV("MX_MRFRETE"))  //"5010030"
		cCodCTE			+= Space(Len(SB1->B1_COD) - Len(cCodCTE) )

		nQtdProd		:=	1

		aLinha:={}
		aadd(aLinha,{"D1_COD",cCodCTE,Nil,Nil})
		aadd(aLinha,{"D1_QUANT",nQtdProd,Nil,Nil})
		aadd(aLinha,{"D1_VUNIT",cXmlVServ,Nil,Nil})
		aadd(aLinha,{"D1_TOTAL",cXmlVServ,Nil,Nil})
		aadd(aLinha,{"D1_VALDESC",0,Nil,Nil})
		aadd(aLinha,{"D1_PICM",cXmlPICM,Nil,Nil})
		aadd(aLinha,{"D1_VALICM",cXmlVICM,Nil,Nil})

		CST_Aux			:= space(03)
		//aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})

		cChvCTE  := ""
		cSerCTE1 := ""
		cDocCTE1 := ""
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDOMEX - Grava Chave do CTE no SD1 para  NF de Entradaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		// Grava XML do CTE no SD1 para Tratar TES Inteligente na Devolucao (Especifico DOMEX)
		if Type('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC') <> "U"
			cSerCTE1   := &('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT' )
			cDocCTE1   := &('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT'  )
		endif

		if Type('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE') <> "U"
			cChvCTE   := &('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT' )
		endif

		If SD1->(FieldPos("D1_XDOCCTE"))>0 .and. !empty(cDocCTE1)
			aadd(aLinha,{"D1_XSERCT3",cSerCTE1,Nil,Nil})
			aadd(aLinha,{"D1_XDOCCTE",cDocCTE1,Nil,Nil})
		EndIf
		If SD1->(FieldPos("D1_XCHVCTE"))>0
			aadd(aLinha,{"D1_XCHVCTE",cChvCTE,Nil,Nil})
		EndIf




		// MAURESI  01/10/2018

		// Adiciona TES INTELIGENTE DE ENTRADA -  CTE
		_lTESOK	:= .F.
		_cTesEnt	:= ""

		If  _lTesINT
			If AllTrim(GetMV("MX_MRCLASS"))	== "C"
				_cProd		:= cCodCTE
				_cFornec	:= cCodCliFor
				_cLojaFor	:= cLojCliFor
				_cOper		:= "01"
				_cTesEnt		:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper,cChvCTE)
				// _cOper		:= cFullOper
				if !empty(Alltrim(_cTesEnt))
					_lTESOK	:= .T.
				endif
			EndIf
		Endif

		aadd(aLinha,{"D1_TES",_cTesEnt,Nil,Nil})
		//aadd(aLinha,{"D1_OPER",_cOper,Nil,Nil})

		// MAURESI - 10/08/2020 - Gravar CFOP correta (Domex)
		cCFOPCTE   := &('oNFe:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT' )

		if Substring(cCFOPCTE,1,1) == "5"
			cCFOPCTE :=  "1"+Substring(cCFOPCTE,2,3)
		else
			cCFOPCTE :=  "2"+Substring(cCFOPCTE,2,3)
		endif
		aadd(aLinha,{"D1_CF",cCFOPCTE,Nil,Nil})


		// Adiciona Data de Validade do Lote com data Fixa em 31/12/2049 (Necessidade Domex)
		_cDtValid	:= StoD("20491231")
		aadd(aLinha,{"D1_DTVALID"   ,_cDtValid,Nil,Nil})


		aadd(aItens,aLinha)

// FIM MAURESI	

		aLinha	:={}
// Cria Segunda Linha para PEDAGIO no CTE
		If _lpedag
			cCodCTE2		:= Alltrim(GETMV("MX_MRPEDAG"))  //"5010030"
			nQtdProd		:=	1
			aadd(aLinha,{"D1_COD",cCodCTE2,Nil,Nil})
			aadd(aLinha,{"D1_QUANT",nQtdProd,Nil,Nil})
			aadd(aLinha,{"D1_VUNIT",cXmlVPed,Nil,Nil})
			aadd(aLinha,{"D1_TOTAL",cXmlVPed,Nil,Nil})
			aadd(aLinha,{"D1_VALDESC",0,Nil,Nil})

			_cProd		:= cCodCTE2
			_cFornec		:= cCodCliFor
			_cLojaFor	:= cLojCliFor
			_cOper		:= "01"

			_cTesEnt		:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper,"")

			aadd(aLinha,{"D1_TES",_cTesEnt,Nil,Nil})

			aadd(aItens,aLinha)
			aLinha:={}
		endif

	EndIf

//Executa rotina de inclusใo Pre-Nota
	If lProc .And. Len(aItens) > 0

		lMsErroAuto := .F.
		lMsHelpAuto := .T.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGera NF somente se for _lTESOKณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		// Execauto de CTE
		If AllTrim(GetMV("MX_MRCLASS"))	== "C"   .and. _lTESOK
			MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens,3)      //DOCUMENTO DE ENTRADA
		Else
			MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)   // execauto 1      -  PRE-NOTA FUNCIONANDO
		EndIf

		If lEhFornec
			cMsgFoCl := aCabec[7,2]+aCabec[8,2]
			cMsgFoCl := "Fornecedor: "+aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA2",1,xFilial("SA2")+cMsgFoCl,"A2_NREDUZ")
		Else
			cMsgFoCl := aCabec[7,2]+aCabec[8,2]
			cMsgFoCl := "Cliente: "   +aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA1",1,xFilial("SA1")+cMsgFoCl,"A1_NREDUZ")
		EndIf

		If lMsErroAuto
			lProc 	:= .F.
			RollBackSxe()

			cMsErro2 := "<br>Arquivo: "+(cTab1)->&(cAls1+"_ARQUIV")
			cMsErro2 += "<br>Data/Hora:"   +DtoC(Date()) +" / "+ Time()
			cMsErro2 += "<br><br>Erro MsExecAuto: "
			cMsErro2 += "<br><br>"         +MostraErro("\data\GestorXml\Log\")

			cMsgErro := "Erro na execu็ใo do MsExecAuto para gera็ใo do Documento ( CTE )."
			cMsgNota := "N๚mero DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
			cMsgAssu := "[Documento] Erro na importa็ใo do XML de CTE"

			fWfGerXml("INTEGRACAO XML x DOCUMENTO - CTE", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl+"<br>"+cMsErro2)
			fGravaMsg(nRecTab1,98,"4",cMsgErro+" - "+cMsgNota)

			MsgAlert(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl + cMsErro2)

		Else

			lProc 	:= .T.
			ConfirmSX8()

			cMsgErro := "CTE Gerado Com Sucesso!"
			cMsgNota := "N๚mero DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
			cMsgAssu := "Documento Gerada com sucesso : ["+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+"]"

			fWfGerXml("INTEGRACAO XML x DOCUMENTO - CTE", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl)
			fGravaMsg(nRecTab1,98,"3",cMsgErro+" - "+cMsgNota)

			MsgInfo(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)
		EndIf

	Endif

Return(lProc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfTrtCodPrdบAutor  ณFelipe Aurelio      บ Data ณ  12/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTrtCodPrd(cCodProd,cTipoCad)

	Local cRet 			:= ""
	Local nTam 			:= 0
	Default cCodProd	:= ""
	Default cTipoCad	:= "" //1=SA5 (Fornec), 2=SA7(Cliente)

	cRet := Upper(cCodProd)
	cRet := AllTrim(cRet)

	Do Case
	Case cTipoCad == "1"
		nTam 	:= fX3Ret("A5_CODPRF","X3_TAMANHO")
	Case cTipoCad == "2"
		nTam 	:= fX3Ret("A7_CODCLI","X3_TAMANHO")
	EndCase

	cRet := Right(cRet,nTam)
	cRet := AllTrim(cRet)
	cRet := PadR(cRet,nTam)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkNFxPCบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLinkNFxPC(aCabec,aItens,aUnidMed,aPrdDesc,aPrdXML)

	Local lRet     := .T.
	Local aCoors   := {800,400}
	Local aSizeAut := {}
	Local aInfo    := {}
	Local aObjects := {}
	Local aPosObj  := {}

//Variaveis do tamanho a tela
	Local aDlgTela := {}
	Local aPosCb1  := {}
	Local aPosCb2  := {}
	Local aPosIt1  := {}
	Local aPosIt2  := {}

//Divis๕es dentro da tela
	Local aDlgCabc := {}
	Local aDlgCorp := {}
	Local aDlgRodp := {}

//Variaveis da Tela
	Local oDialg
	Local cPrtCad  := "Relacionamento NFe/XML com PC existente"
	Local nOpcao   := 0
	Local lExiste	:=.F.

	Private oXXGetDad  := Nil
	Private oYYGetDad  := Nil
	Private cLinkNumPC := Space(fX3Ret("C7_NUM"    ,"X3_TAMANHO"))
	Private cLinkProdu := iif( alltrim(GETMV("MX_MRBARRA")) = "S",Space(13),Space(15))  // Space(13)
	Private cLinkProd2 := ""
	Private cLinkForCd := aCabec[7][2]
	Private cLinkForLj := aCabec[8][2]
	Private cLinkRequ  :=Space(06)
	Private cLinkLocal :=Space(fX3Ret("C7_LOCAL"    ,"X3_TAMANHO"))
	Private cLinkDesc  :=Space(fX3Ret("C7_DESCRI"   ,"X3_TAMANHO"))

	aSizeAut := MsAdvSize()
	aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
	aObjects := {}

	aAdd(aObjects,{100,035,.T.,.F.}) //Cabe็alho
	aAdd(aObjects,{100,100,.T.,.T.}) //Corpo = Nfe e Romaneio
	aAdd(aObjects,{100,020,.T.,.F.}) //Rodape
	aPosObj  := MsObjSize(aInfo,aObjects)

//Variaveis do tamanho a tela
	aDlgTela := {aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5]}

//Divide cabe็alho
	aPosCb1  	:= aClone(aPosObj[1])
	aPosCb1[4] 	:= (aPosCb1[4]/2)-2
	aPosCb2  	:= aClone(aPosObj[1])
	aPosCb2[2] 	:= (aPosCb2[4]/2)+2

//Divide Itens
	aPosIt1  	:= aClone(aPosObj[2])
	aPosIt1[4] 	:= (aPosIt1[4]/2)-2
	aPosIt2  	:= aClone(aPosObj[2])
	aPosIt2[2] 	:= (aPosIt2[4]/2)+2

// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Pixel //Of oMainWnd

//Contorno - Cabec 01 - NF
	fLinkCabc1(aPosCb1,oDialg,aCabec)

//Contorno - Cabec 02 - PC
	fLinkCabc2(aPosCb2,oDialg)

//Contorno - Itens 01 - NF
	fLinkItem1(aPosIt1,oDialg,aItens,aUnidMed,aPrdDesc,aPrdXML)

//Contorno - Itens 02 - PC
	fLinkItem2(aPosIt2,oDialg)

//Contorno - Rodap้
	fLinkRodap(aPosObj[3],oDialg,@nOpcao)

	Activate MsDialog oDialg Centered

//Se confirmado
	If nOpcao == 2

		fSalvaZZ3()
		_lProdOk := .T.		// Valida se Todos os Produtos estao Preenchidos
		_lPCOMOk := .T.		// Valida se Todos os Produtos estao Preenchidos
		_lCustOK := .T.		// Valida se Todos os Itens tem Centro de Custo Informado
		_lTESOK	 := .T.		// Valida se Todos os Itens tem TES preenchido
		_lTESEXT := .T.		// Valida se Todos as TES existem na Amarracao
		_lQtdOk  := .T.
		//_cNumPC	:= ""

		//Refazendo o aitens (manipulando)

		For x:=1 To Len(oXXGetDad:aCols)

			If !Empty(oXXGetDad:aCols[x][nXXPEDIDO]) .And. !Empty(oXXGetDad:aCols[x][nXXITEMPC])

				//If nPosPCNu > 0
				aItens[x][nD1PEDIDO][2] := oXXGetDad:aCols[x][nXXPEDIDO]
				_cNumPC	:= oXXGetDad:aCols[x][nXXPEDIDO]
				//Else
				//	aadd(aItens[x],{"D1_PEDIDO",oXXGetDad:aCols[x][nXXPEDIDO],Nil,Nil})
				//EndIf

				//If nPosPCIt > 0
				aItens[x][nD1ITEMPC][2] := oXXGetDad:aCols[x][nXXITEMPC]
				//Else
				//	aadd(aItens[x],{"D1_ITEMPC",oXXGetDad:aCols[x][nXXITEMPC],Nil,Nil})
				//EndIf


				If oXXGetDad:aCols[x][nXXQTDPC] < oXXGetDad:aCols[x][nXXQTD1]  // Somente se o PC < NF
					SB1->( dbSetOrder(1) )
					SB1->( dbSeek( xFilial() + oXXGetDad:aCols[x][nXXPRODUTO] ) )
					If SB1->B1_GRUPO == "FO  " .OR. SB1->B1_GRUPO == "FOFS"
						nDif := ((oXXGetDad:aCols[x][nXXQTD1] - oXXGetDad:aCols[x][nXXQTDPC]) / oXXGetDad:aCols[x][nXXQTDPC]) * 100
						If nDif > nTolerancia
							_lQtdOk := .F.
						EndIf
					Else
						_lQtdOk := .F.
					EndIf
				EndIf

			Else
				//Alterando o nome do campo no  para nใo dar erro no execauto
				aItens[x][nD1PEDIDO][1] := "SEM_PC"
				aItens[x][nD1ITEMPC][1] := "SEM_ITEM_PC"

			EndIf

			If !Empty(oXXGetDad:aCols[x][nXXLOCAL])
				aItens[x][nD1LOCAL][2] := oXXGetDad:aCols[x][nXXLOCAL]
			Else
				aItens[x][nD1LOCAL][1] := "SEM_LOCAL"
			EndIf

			If !Empty(oXXGetDad:aCols[x][nXXCC])
				aItens[x][nD1CC][2] := oXXGetDad:aCols[x][nXXCC]
			Else
				aItens[x][nD1CC][1] := "SEM_CC"
				_lCustOK := .F.
			EndIf

			// Adiciona Produto Informado na Tela de Amarracao Pre-Nf / PC
			aItens[x][nD1COD][2] := oXXGetDad:aCols[x][nXXPRODUTO]

			// Adiciona Valor unitario na primeira unidade de medida
			nVunNovo := Round((oXXGetDad:aCols[x][nXXQTD2]/oXXGetDad:aCols[x][nXXQTD1]) * oXXGetDad:aCols[x][nXXPRCUNIT],fX3Ret("D1_VUNIT","X3_DECIMAL"))
			aItens[x][nD1VUNIT][2]   := nVunNovo

			// Adiciona Quantidade na primeira unidade de medida
			aItens[x][nD1QUANT][2]   := oXXGetDad:aCols[x][nXXQTD1]

			// Adiciona Valor total do item
			aItens[x][nD1TOTAL][2]    := Round(oXXGetDad:aCols[x][nXXQTD1] * nVunNovo,2)
//			aItens[x][nD1VALDESC][2]  := Round(oXXGetDad:aCols[x][nXXVALDESC],2)

			// MAURESI - 19/08/2021
			// Adiciona Frete
			aItens[x][nD1VALFRE][2]   := oXXGetDad:aCols[x][nXXVALFRE]



			// Se o Produto for VAZIO, nao pode permitir gravar
			If  empty(alltrim(oXXGetDad:aCols[x][nXXPRODUTO]))
				_lProdOk := .F.
			Endif

			// Se Pedido de Compra nใo for amarrado, Nao permitte Gravar
			if Empty(oXXGetDad:aCols[x][nXXPEDIDO])
				_lPCOMOk := .F.

				IF 	_lDmxFilial  .and. U_VALIDACAO()  // MAURESI - 21/09/2021
					_lPCOMOk := .T.
				endif
			endif


			if _lTesInt
				// Se TES estiver vazio, somente pode gerar PRE-NOTA
				if Empty(alltrim(oXXGetDad:aCols[x][nXXTES]))
					_lTESOk := .F.
					//	aItens[x][nD1TES][2]   := Space(03) //oXXGetDad:aCols[x][nXXTES]		// MAURESI // 13/08/2021
					//	aItens[x][nD1OPER][2]  := Space(02) //oXXGetDad:aCols[x][nXXOPER]
				else
					// Alimenta TES - OPERACAO informados no Browse
					aItens[x][nD1TES][2]   := oXXGetDad:aCols[x][nXXTES]		// MAURESI
				endif

				if Empty(alltrim(oXXGetDad:aCols[x][nXXOPER]))
					_lTESOk := .F.
					//	aItens[x][nD1TES][2]   := Space(03) //oXXGetDad:aCols[x][nXXTES]		// MAURESI // 13/08/2021
					//	aItens[x][nD1OPER][2]  := Space(02) //oXXGetDad:aCols[x][nXXOPER]
				else
					// Alimenta TES - OPERACAO informados no Browse
					aItens[x][nD1OPER][2]  := oXXGetDad:aCols[x][nXXOPER]
				endif

			endif

		Next x

		If !_lProdOk
			MsgAlert("Existe Produto sem Amarra็ใo e por isso o processo nใo pode ser concluido")
			lRet := .F.
		Endif

		// Se nao tiver Amarracao com SC e se o usuario nao estiver no parametro MX_MRUSR02, barra Inclusao
		If !_lPCOMOk
			If !(__cUserID $ Alltrim(GetMV("MX_MRUSR02")))	// "000000=Administrador
				MsgAlert("Existe Item da NF sem amarra็ใo com o Pedido de Compras. Favor verificar.   (MX_MRUSR02)")
				lRet := .F.
			endif
		Endif


		// Trata Quantidade da NF superior a quantidade do Pedido de compras. Existe tolerโncia para Fibras
		If !_lQtdOk
			MsgAlert("Existe Item da NF com quantidade superior ao Pedido de Compras")
			lRet := .F.
		EndIf


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGrava Amarra็ใo de Produto x Fornecedorณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//****************************************************************************************
		If lRet

			For x:=1 to Len(oXXGetDad:aCols)
				//nXXPRODXML
				cCadPrdFor :=	oXXGetDad:aCols[x][nXXPRODXML]	// Produto Fornecedor
				cCadPrdCod :=	oXXGetDad:aCols[x][nXXPRODUTO]	// Produto Interno
				cCadPrdDes :=	oXXGetDad:aCols[x][nXXDESCRIC]	// Descricao Produto Fornecedor

				If lEhFornec
				/*
				SA5->(dbSetOrder(1))
					If SA5->(dbSeek(xFilial("SA5")+ cCodCliFor + cLojCliFor + cCadPrdCod))
						While SA5->(!Eof()) .And. SA5->A5_FILIAL  == xFilial("SA5") ;
				.And. SA5->A5_FORNECE == cCodCliFor     ;
				.And. SA5->A5_LOJA    == cLojCliFor     ;
				.And. Rtrim(SA5->A5_PRODUTO) == Rtrim(cCadPrdCod)
								If AllTrim(SA5->A5_CODPRF) == Upper(AllTrim(cCadPrdFor))
				lExiste := .T.
				Exit
							EndIf
				SA5->(DbSkip())
						End
						If lExiste
				RecLock("SA5",.F.)
						Else
				RecLock("SA5",.T.)
							If SA5->(FieldPos("A5_XXPORTA"))>0
				SA5->A5_XXPORTA := "S" //Campo que controla o que serแ mostrado no portal
							EndIf
						EndIf
					Else
				Reclock("SA5",.T.)
						If SA5->(FieldPos("A5_XXPORTA"))>0
				SA5->A5_XXPORTA := "S" //Campo que controla o que serแ mostrado no portal
						EndIf
					Endif
				SA5->A5_FILIAL  := xFilial("SA5")
				SA5->A5_FORNECE := cCodCliFor
				SA5->A5_LOJA    := cLojCliFor
				SA5->A5_NOMEFOR := cNomCliFor
				SA5->A5_PRODUTO := cCadPrdCod
				//			SA5->A5_NOMPROD := Upper(AllTrim(cCadPrdDes))
				SA5->A5_CODPRF  := Upper(AllTrim(cCadPrdFor))
				SA5->A5_DESCPRF := Upper(AllTrim(cCadPrdDes))	// Descricao de Produto Fornecedor
				
				//If lWhenTtCps
				//&("SA5->"+cCpoUmXml) := cXmlUniMed
				//&("SA5->"+cCpoFCNum) := nCadFatCon
				//&("SA5->"+cCpoFCTip) := cCadTipCon
				//EndIf
				
				SA5->(MsUnlock())
				
				//Esta variavel serแ retornata pra quem a chamou
				cCodProdut := SA5->A5_PRODUTO
				
				cVldMensag := "O produto ( "+alltrim(cCadPrdCod)+" ) Vs ( "+alltrim(cCadPrdFor)+" ) foi cadastrado na tabela Amarra็ใo Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
				fGravaMsg(nRecTab1,98," ",cVldMensag)
				*/
				Else
					//Tratando tamanho do conteudo do campo

					SA7->(dbSetOrder(1))
					If SA7->(dbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + cCadPrdCod))
						While SA7->(!Eof()) .And. SA7->A7_FILIAL  == xFilial("SA7") ;
								.And. SA7->A7_CLIENTE == cCodCliFor     ;
								.And. SA7->A7_LOJA    == cLojCliFor     ;
								.And. SA7->A7_PRODUTO == cCadPrdCod

							If AllTrim(SA7->A7_CODCLI) == Upper(AllTrim(cCadPrdFor))
								lExiste := .T.
								Exit
							EndIf
							SA7->(DbSkip())
						End
						If lExiste
							RecLock("SA7",.F.)
						Else
							RecLock("SA7",.T.)
						EndIf
					Else
						Reclock("SA7",.T.)
					Endif

					SA7->A7_FILIAL  := xFilial("SA7")
					SA7->A7_CLIENTE := cCodCliFor
					SA7->A7_LOJA    := cLojCliFor
					SA7->A7_PRODUTO := cCadPrdCod
					SA7->A7_DESCCLI := Upper(AllTrim(cCadPrdDes))
					SA7->A7_CODCLI  := Upper(AllTrim(cCadPrdFor))
				/*
					If lWhenTtCps
				&("SA7->"+cCpoUmXml) := cXmlUniMed
				&("SA7->"+cCpoFCNum) := nCadFatCon
				&("SA7->"+cCpoFCTip) := cCadTipCon
					EndIf
				*/
					SA7->(MsUnlock())

					//Esta variavel serแ retornata pra quem a chamou
					cCodProdut := SA7->A7_PRODUTO

					cVldMensag := "O produto ( "+alltrim(cCadPrdCod)+" ) Vs ( "+alltrim(cCadPrdFor)+" ) foi cadastrado na tabela Amarracao Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
					fGravaMsg(nRecTab1,98," ",cVldMensag)
				EndIf
			Next x

		Endif

		//*********************************************************************
	Else
		lRet := .F.
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkCabc1บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinkCabc1(aSizeDlg,oDialg,aCabec)

	Local cCbcTpNF := aCabec[1][2]
	Local cCbcForn := aCabec[7][2] + " / " + aCabec[8][2] + " - " + Posicione("SA2",1,xFilial("SA2")+cLinkForCd+cLinkForLj,"A2_NOME")
	Local cCbcNota := aCabec[3][2] + " / " + aCabec[4][2]

	cNfRelat := cCbcNota

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Label " Cabe็alho Pr้ Nota Entrada " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

	@ aSizeDlg[1]+010,aSizeDlg[2]+005 Say "Nota"              Size 050 ,008 Pixel Of oDialg
	@ aSizeDlg[1]+009,aSizeDlg[2]+030 MsGet cCbcNota          Size 070 ,008 Pixel When .F. Of oDialg

	@ aSizeDlg[1]+010,aSizeDlg[2]+135 Say "Tipo NF"           Size 050 ,008 Pixel Of oDialg
	@ aSizeDlg[1]+009,aSizeDlg[2]+160 MsGet cCbcTpNF          Size 030 ,008 Pixel When .F. Of oDialg

	@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Fornec."           Size 050 ,008 Pixel Of oDialg
	@ aSizeDlg[1]+021,aSizeDlg[2]+030 MsGet cCbcForn          Size 160 ,008 Pixel When .F. Of oDialg

	MRSACESS() // Analisa acessos    //U_MRSACESS()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkCabc2บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLinkCabc2(aSizeDlg,oDialg)

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Label " Pesquisar Pedido de Compra " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ2a Coluna   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
	@ aSizeDlg[1]+022,aSizeDlg[2]+100 Say "Armazem"		   Size 050 ,008 Pixel Of oDialg
	@ aSizeDlg[1]+021,aSizeDlg[2]+125 MsGet cLinkLocal        Size 040 ,008 Pixel Of oDialg F3 "NNR"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ3a Coluna   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
	@ aSizeDlg[1]+010,aSizeDlg[2]+170 Say "Descr."            Size 050 ,008 Pixel Of oDialg
	@ aSizeDlg[1]+009,aSizeDlg[2]+195 MsGet cLinkDesc         Size 110 ,008 Pixel Of oDialg

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ1a Coluna   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู

	@ aSizeDlg[1]+010,aSizeDlg[2]+005 Say "Num. PC"           Size 050 ,008 Pixel Of oDialg
	@ aSizeDlg[1]+009,aSizeDlg[2]+030 MsGet cLinkNumPC        Size 060 ,008 Pixel Of oDialg F3 "SC7"

	if upper(alltrim(_lCodBar)) $ "S"
		@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Cod.Barra"		   Size 050 ,008 Pixel Of oDialg
	else
		@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Produto"		   Size 050 ,008 Pixel Of oDialg
	endif
	@ aSizeDlg[1]+021,aSizeDlg[2]+030 MsGet oLinkProdu Var cLinkProdu        Size 060 ,008 Pixel Of oDialg F3 "SB1"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBotoes      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
	@ aSizeDlg[1]+021,aSizeDlg[2]+230 Button "Pesquisar"      Size 030 ,010 Pixel Of oDialg Action fLinkPesqu()
	@ aSizeDlg[1]+021,aSizeDlg[2]+280 Button "Limpar"         Size 030 ,010 Pixel Of oDialg Action fLinkLimpa()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkPesquบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinkPesqu()

	Local cQry   := ""
	Local cQbra  := Chr(13)+Chr(10)


// MAURESI - 23/11/2020 - Alimenta Operacao em PC que estejam em branco
	TCSQLEXEC("UPDATE " + RetSqlName("SC7") + " SET C7_XOPER = '01' WHERE C7_XOPER='' ")



	if !empty(cLinkProdu)
		if !empty(cLinkProd2)
			cLinkProd2 += ","
		endif
		cLinkProd2 += "'"+alltrim(cLinkProdu)+"'"
	endif

	cQry := cQbra + " SELECT "
	cQry += cQbra + "   'LBNO'            AS YY_FLAG,    "
	cQry += cQbra + "   C7_NUM            AS YY_PEDIDO,  "
	cQry += cQbra + "   C7_ITEM           AS YY_ITEMPC,  "
	cQry += cQbra + "   C7_PRODUTO        AS YY_PRODUTO, "
	cQry += cQbra + "   C7_DESCRI         AS YY_DESCRIC, "
	cQry += cQbra + "   C7_DATPRF         AS YY_DATPRF,  "
	cQry += cQbra + "   C7_PRECO          AS YY_PRCUNIT, "
	cQry += cQbra + "   C7_UM             AS YY_UM,      "
	cQry += cQbra + "   C7_PRODUTO        AS YY_XPROTMP, "			// Alimenta com PRODUTO Somente para manter criado campo YY_XPROTMP
	cQry += cQbra + "   C7_CC        	  AS YY_ENTID, "				// Alimenta com CC Somente para manter criado campo YY_ENTID


	If _lTesInt
		cQry += cQbra + "   C7_XOPER        AS YY_OPER, "
	Else
		cQry += cQbra + "   '' 			      AS YY_OPER, "
	EndIf

	cQry += cQbra + "   C7_LOCAL          AS YY_LOCAL, "
	cQry += cQbra + "   C7_CC             AS YY_CC,    "

//cQry += cQbra + "  (C7_QUANT-C7_QUJE-C7_QTDACLA) AS YY_SALDO "
	cQry += cQbra + "  (C7_QUANT-C7_QUJE) AS YY_SALDO, "   //MAURESI - 23/12/2020 - DESCONSIDERA QTDA CLASSFICAR
	cQry += cQbra + "   C7_VLDESC         AS YY_VALDESC, "   //MAURESI - 04/08/2020 - VALOR DE DESCONTO
	cQry += cQbra + "   C7_VALFRE          AS YY_VALFRE "   //MAURESI - 11/08/2020 - VALOR DE FRETE
//	cQry += cQbra + "   C7_FRETE          AS YY_VALFRE "   //MAURESI - 11/08/2020 - VALOR DE FRETE


	cQry += cQbra + "   FROM "+RetSqlName("SC7")+" SC7 "
	cQry += cQbra + "  WHERE D_E_L_E_T_ = '' "

	//cQry += cQbra + "  AND  C7_FILIAL = XFILIAL() = '' " 	// MAURESI  - 16/02/2022
	
	// FILTRA SOMENTE PEDIDOS DA FILIAL CORRENTE  // MAURESI - 16/02/2022
	If cFilAnt == "01"   // MATRIZ - SP
		cQry += cQbra + "  AND  C7_FILIAL = '01' "
	ElseIf cFilAnt == '02'  //FILIAL - MG
		cQry += cQbra + "  AND  C7_FILIAL = '02' "	
	Endif

	//	cQry += cQbra + "  AND  C7_FILIAL = '"+cFilant+ "' "



	cQry += cQbra + "    AND (C7_QUANT-C7_QUJE) > 0 " //MAURESI - 23/12/2020 - DESCONSIDERA QTDA CLASSFICAR     //  
//cQry += cQbra + "    AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 "

	cQry += cQbra + "    AND C7_CONAPRO      != 'B' " //Trata item bloqueado
	cQry += cQbra + "    AND C7_RESIDUO       = ''  " //Trata item eliminado por residuo
	cQry += cQbra + "    AND C7_FORNECE       = '"+cLinkForCd+"'  "
// cQry += cQbra + "    AND C7_LOJA          = '"+cLinkForLj+"'  "
// Tratamanto para Buscar Pedidos atraves de Codigo de Barras
	if _lCodBar
		if !empty(cLinkProd2)
			cQry += cQbra + "    AND C7_PRODUTO IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" SB1  WHERE LTRIM(RTRIM(B1_CODBAR)) IN ("+cLinkProd2 +") )"
		endif
	Else
		If !Empty(cLinkProdu)
			cQry += cQbra + "    AND C7_PRODUTO  IN ("+cLinkProd2 +") "
		EndIf
	Endif
//Busca Numero do Pedido de Compras
	If !Empty(cLinkNumPC)
		cQry += cQbra + "    AND C7_NUM        LIKE '%"+AllTrim(cLinkNumPC)+"%' "
	EndIf
//Busca Numero do Armazem
	If !Empty(cLinkLocal)
		cQry += cQbra + "    AND C7_LOCAL        LIKE '%"+AllTrim(cLinkLocal)+"%' "
	EndIf

//Busca Descricao do Item
	If !Empty(cLinkDesc)
		cQry += cQbra + "    AND C7_DESCRI        LIKE '%"+AllTrim(cLinkDesc)+"%' "
	EndIf

	cQry += cQbra + "  ORDER BY C7_DESCRI,C7_DATPRF "

//Fecha Alias caso encontre
	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	EndIf

//Cria alias temporario
	TcQuery cQry New Alias "QRY"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณO Trecho abaixo limpa po aCols somente quando a primeira linha     ณ
//ณtiver um item sem o numero do PC preenchido.                       ณ
//ณEsta situacao acontece somente na primeira vez que acessa a rotina.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	if empty(  		oYYGetDad:aCols[1, aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_PEDIDO" }) ]   )
	oYYGetDad:aCols := {}
	oYYGetDad:oBrowse:Refresh()
//	Endif


//Carrega GetDados 02 com nova pesquisa
	fLinkCarga()

//Fecha Alias
	QRY->(dbCloseArea())

	oLinkProdu:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkCargaบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLinkCarga()

	Local cCmdTemp := ""
	Local nPosTemp := 0

//Carrega aCols com base no resultado da query
	QRY->(DbGoTop())
	While QRY->(!Eof())

		//Cria uma linha no aCols
		aAdd(oYYGetDad:aCols,Array(Len(oYYGetDad:aHeader)+1))
		nLin := Len(oYYGetDad:aCols)

		//Carregando campos que serใo visualizados no GD
		For y := 1 To Len(oYYGetDad:aHeader)
			If Type("QRY->"+oYYGetDad:aHeader[y][2]) <> 'U'
				If oYYGetDad:aHeader[y,8] <> 'D'
					oYYGetDad:aCols[nLin,y] := &("QRY->"+oYYGetDad:aHeader[y][2])
				Else
					oYYGetDad:aCols[nLin,y] := StoD(&("QRY->"+oYYGetDad:aHeader[y][2]))
				EndIf
			EndIf
		Next y

		oYYGetDad:aCols[nLin, Len(oYYGetDad:aHeader)+1] := .F.

		QRY->(DbSkip())
	Enddo

// Restaura amarra็ใo jแ realizada anteriormente do ZZ6 (DOMEX e ZZ3 outros clientes)
	// fRestSalva()

//Carrega aCols com uma linha vazia por nใo teve resultado na query
	QRY->(DbGoTop())

//Atualiza tela
	oYYGetDad:oBrowse:nAt := 1
	oYYGetDad:oBrowse:Refresh()
	oYYGetDad:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkLimpaบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLinkLimpa()

	cLinkNumPC := Space(fX3Ret("C7_NUM"    ,"X3_TAMANHO"))
	cLinkProdu := iif( alltrim(GETMV("MX_MRBARRA")) = "S",Space(13),Space(15)) //Space(13) //Space(fX3Ret("C7_PRODUTO","X3_TAMANHO"))
	cLinkProd2 := ""

	cLinkRequ  :=Space(06)
	cLinkLocal :=Space(fX3Ret("C7_LOCAL"    ,"X3_TAMANHO"))
	cLinkDesc  :=Space(fX3Ret("C7_DESCRI"   ,"X3_TAMANHO"))

	oYYGetDad:aCols := {}
	oYYGetDad:oBrowse:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkItem1บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinkItem1(aSizeDlg,oDialg,aItens,aUnidMed,aPrdDesc,aPrdXML)


// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := GD_UPDATE                                             // Nil // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local aAlter         := If(_lTesInt,{"XX_TES","XX_OPER"},{})
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHeadXX        := {}                                              // Array do aHeader
	Local aColsXX        := {}                                              // Array do aCols
	Local cMsgCabec      := ""

//          X3_TITULO        , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL                      , X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(aHeadXX,{""               ,"XX_FLAG"      ,"@BMP"               ,          01,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Item XML"       ,"XX_ITEMXML"   ,"@!"                 ,          04,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Prod. XML"      ,"XX_PRODXML"   ,"@!"                 ,          10,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Produto"        ,"XX_PRODUTO"   ,"@!"                 ,          10,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Descricao"      ,"XX_DESCRIC"   ,"@!"                 ,          20,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	If _lTesInt
		aAdd(aHeadXX,{"Operacao"     ,"XX_OPER"      ,"@!"                 ,          02,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , "U_fXXVldCpo()"               , ""        , ""        })
		aAdd(aHeadXX,{"TES"		     ,"XX_TES"       ,"@!"                 ,          03,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""                            , ""        , ""        })
	EndIf
	aAdd(aHeadXX,{"Unid."          ,"XX_UM"        ,"@!"                 ,          05,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Quant. 1ช UM"   ,"XX_QTD1"      ,"@E 999,999,999.99"  ,          08,fX3Ret("D1_QUANT"  ,"X3_DECIMAL"), ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Quant. 2ช UM"   ,"XX_QTD2"      ,"@E 999,999,999.99"  ,          08,fX3Ret("D1_QTSEGUM","X3_DECIMAL"), ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Preco Unit."    ,"XX_PRCUNIT"   ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Desconto"       ,"XX_VALDESC"   ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Local"          ,"XX_LOCAL"     ,"@!"                 ,          02,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , "NNR"   , "R"        , ""                 , ""         ,""                            ,"A"      , "U_fXXVldCpo()"               , ""        , ""        })
	aAdd(aHeadXX,{"C.Custo"        ,"XX_CC"        ,"@!"                 ,          06,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , "CTT"   , "R"        , ""                 , ""         ,""                            ,"A"      , "U_fXXVldCpo()"               , ""        , ""        })
	aAdd(aHeadXX,{"Num.PC"         ,"XX_PEDIDO"    ,"@!"                 ,          08,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"It.PC"          ,"XX_ITEMPC"    ,"@!"                 ,          04,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Fator Conversใo","XX_FATOR"     ,"@E 9999.9999"       ,          09,                                4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Tipo Fator"     ,"XX_TPFATOR"   ,"@R"                 ,          07,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Qtd. PC"        ,"XX_QTDPC"     ,"@E 999,999,999.99"  ,          08,fX3Ret("D1_QUANT"  ,"X3_DECIMAL"), ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Vl.Frete"       ,"XX_VALFRE"    ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })    //MAURESI - 11/08/2021


	For y := 1 To Len(aItens)

		//Cria uma linha no aCols
		aAdd(aColsXX,Array(Len(aHeadXX)+1))
		nLin := Len(aColsXX)

		nQtd1    := 0
		nQtd2    := aItens[y][nD1QUANT][2]
		nFator   := aFatorCon[y,1]
		cTpFator := aFatorCon[y,2]
		_cTesEnt	:= ""

		If !Empty(nFator)  // Se houver fator de conversใo para o produto
			If cTpFator == 'M'
				nQtd1 := Round(nQtd2 * nFator,4)
			EndIf
			If cTpFator == 'D'
				nQtd1 := Round(nQtd2 / nFator,4)
			EndIf
		EndIf

		//Alimenta as linhas do aCols vazio
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_FLAG"    }) ] := "LBNO" //"LBTIK"
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_ITEMXML" }) ] := StrZero(y,4)
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_PRODXML" }) ] := aPrdXML[y]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_PRODUTO" }) ] := aItens[y][nD1COD][2]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_DESCRIC" }) ] := aPrdDesc[y]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_UM"      }) ] := aUnidMed[y]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_QTD1"    }) ] := nQtd1
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_QTD2"    }) ] := nQtd2
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_PRCUNIT" }) ] := aItens[y][nD1VUNIT][2]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_VALDESC" }) ] := aItens[y][nD1VALDESC][2]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_LOCAL"   }) ] := aItens[y][nD1LOCAL][2]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_CC"      }) ] := aItens[y][nD1CC][2]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_PEDIDO"  }) ] := IIf(Empty(nD1PEDIDO),"",aItens[y][nD1PEDIDO][2])
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_ITEMPC"  }) ] := IIf(Empty(nD1ITEMPC),"",aItens[y][nD1ITEMPC][2])
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_FATOR"   }) ] := nFator
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_TPFATOR" }) ] := aFatorCon[y,2]
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_QTDPC"   }) ] := 0
		aColsXX[nLin, aScan(aHeadXX,{|x|AllTrim(x[2])=="XX_VALFRE"  }) ] := aItens[y][nD1VALFRE][2] // 0 // MAURESI - 11/08/2021

		aColsXX[nLin, Len(aHeadXX)+1]                                    := .F.
	Next y

	oXXGetDad:=MsNewGetDados():New(aSizeDlg[1]+5,aSizeDlg[2]+5,aSizeDlg[3]-5,aSizeDlg[4]-5,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHeadXX,aColsXX)
	oXXGetDad:oBrowse:bLDblClick  := { || fXXClick()      }

//oXXGetDad:oBrowse:bChange     := { || fXXClick()          }
//oXXGetDad:oBrowse:brClicked   := { || fXXClick()          }
//oXXGetDad:oBrowse:bLClicked   := { || Alert("bLClicked" ) }
//oXXGetDad:oBrowse:bGotFocus   := { || alert("bGotFocus" ) }
//oXXGetDad:oBrowse:brClicked   := { || alert("brClicked" ) }
//oXXGetDad:oBrowse:bline	     := { || alert("bLine" )     }

	nXXFLAG    := aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"    })
	nXXITEMXML := aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_ITEMXML" })
	nXXPEDIDO  := aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_PEDIDO"  })
	nXXITEMPC  := aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_ITEMPC"  })
	nXXVALDESC := aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_VALDESC" })
	nXXITEMPC  := aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_ITEMPC"  })
	nXXPRODXML := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_PRODXML" })
	nXXPRODUTO := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_PRODUTO" })
	nXXDESCRIC := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_DESCRIC" })
	nXXQTD1    := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_QTD1"    })
	nXXQTD2    := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_QTD2"    })
	nXXPRCUNIT := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_PRCUNIT" })
	nXXLOCAL   := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_LOCAL"   })
	nXXCC      := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_CC"      })
	nXXFATOR   := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_FATOR"   })
	nXXUM      := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_UM"      })
	nXXTPFATOR := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_TPFATOR" })
	nXXOPER    := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_OPER"    })
	nXXTES     := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_TES"     })
	nXXQTDPC   := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_QTDPC"   })
	nXXVALFRE  := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_VALFRE"  })
//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

// Chamada para Atribuir CORES as linhas do Grid 01
	oXXGetDad:oBrowse:lUseDefaultColors := .F.
	oXXGetDad:oBrowse:SetBlkBackColor({|| CorGd01(oXXGetDad:nAt,8421376,aColsXX)})
	oXXGetDad:oBrowse:Refresh()

Return


Static Function CorGd01(nLinha,nCor,aCols)

	Local nRet := 16777215
	if !Empty(oXXGetDad:aCols[nLinha,nXXPEDIDO])
		nRet := RGB(154,205,50)  // Verde
	Endif
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfXXClick  บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑบ          ณDuplo Clique na Selecao de Pedidos x XML (relacionamento    บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fXXClick()

	Local x          := 0
	Local nLinhaXX   := oXXGetDad:oBrowse:nAt
	Local nColunaXX  := oXXGetDad:oBrowse:nColPos

	nTotPC := 0
	nTotNF := 0

	//Desmarca todos os Itens, Antes de Marcar o Proximo
	For x := 1 To Len(oXXGetDad:aCols)
		oXXGetDad:aCols[x][nXXFLAG] := "LBNO"
	Next x

	//Marca Item Clicado
	oXXGetDad:aCols[nLinhaXX][nXXFLAG] := "LBTIK"

	//Desmarca todos os Itens do PC
	For x:= 1 To Len(oYYGetDad:aCols)
		oYYGetDad:aCols[x][nYYFLAG]  := "LBNO"
		If oYYGetDad:aCols[x][nYYLEGENDA] == c2Leg1 .or. oYYGetDad:aCols[x][nYYLEGENDA] == c2Leg3
			oYYGetDad:aCols[x][nYYLEGENDA] := ""
		EndIf
	Next x

	//Marca itens do PC que jแ estejam associados a esta linha da NF
	If !Empty(oXXGetDad:aCols[nLinhaXX][nXXPEDIDO])
		For x:= 1 To Len(oYYGetDad:aCols)
			If oXXGetDad:aCols[nLinhaXX][nXXPEDIDO] == oYYGetDad:aCols[x][nYYPEDIDO] .and. oXXGetDad:aCols[nLinhaXX][nXXITEMPC] == oYYGetDad:aCols[x][nYYITEMPC]
				oYYGetDad:aCols[x][nYYFLAG]  := "LBTIK"
			EndIf
		Next x
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMarcando a legenda de produtos iguaisณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If !Empty(oXXGetDad:aCols[nLinhaXX][nXXPRODUTO])
		For x:= 1 To Len(oYYGetDad:aCols)
			If oYYGetDad:aCols[x][nYYLEGENDA] <> c2Leg2
				If oXXGetDad:aCols[nLinhaXX][nXXPRODUTO] == oYYGetDad:aCols[x][nYYPRODUTO]
					oYYGetDad:aCols[x][nYYLEGENDA] := c2Leg1
				Else
					If !Empty(oYYGetDad:aCols[x][nYYXPROTMP])
						If SB1->( dbSeek( xFilial() + oYYGetDad:aCols[x][nYYXPROTMP] ) )

							cIniCod := Alltrim(SB1->B1_COD)

							If Subs(oXXGetDad:aCols[nLinhaXX][nXXPRODUTO],1,Len(cIniCod)) == cIniCod
								oYYGetDad:aCols[x][nYYLEGENDA] := c2Leg3
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next x
	Else
		For x:= 1 To Len(oYYGetDad:aCols)
			If oYYGetDad:aCols[x][nYYLEGENDA] <> c2Leg2
				SA5->(dbSetOrder(1))
				If !SA5->(dbSeek(xFilial("SA5")+cCodCliFor+cLojCliFor+oYYGetDad:aCols[x][nYYPRODUTO]))
					oYYGetDad:aCols[x][nYYLEGENDA] := c2Leg1
				EndIf
			EndIf
		Next x
	EndIf


	//Soma Itens do XML
	For x:= 1 To Len(oXXGetDad:aCols)
		If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
			nTotNF+= oXXGetDad:aCols[x][nXXQTD1]
		EndIf
	Next x


	//Atualiza tela
	oTotPC:Refresh()
	oTotNF:Refresh()
	oXXGetDad:oBrowse:nAt := nLinhaXX
	oXXGetDad:oBrowse:Refresh()
	oYYGetDad:oBrowse:Refresh()
	oXXGetDad:oBrowse:SetFocus()

Return


Static Function fYYClick()

	Local x          := 0
	Local nLinhaYY   := oYYGetDad:oBrowse:nAt
	Local _Retorno  := .T.
	Local lMark01   := .F.
	Local N1
	Local lMarca    := If(oYYGetDad:aCols[oYYGetDad:oBrowse:nAt][nYYFLAG]<>"LBTIK",.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObrigando a selecionar primeiro um item de NF  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If _Retorno .and. lMarca
		For x := 1 to Len(oXXGetDad:aCols)
			If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
				lMark01 := .T.
				Exit
			EndIf
		Next x
		If !lMark01
			MsgStop("Favor selecionar primeiro um item de NF.")
			_Retorno := .F.
		EndIf
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidando se o produto da NF e igual ao do pedido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno .and. lMarca
		For x := 1 to Len(oXXGetDad:aCols)
			If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
				N1 := x
				Exit
			EndIf
		Next x
		If !Empty(oXXGetDad:aCols[N1][nXXPRODUTO])
			If oYYGetDad:aCols[oYYGetDad:oBrowse:nAt][nYYLEGENDA] == '3'
				MsgStop("Produtos diferentes. Nใo foi possํvel selecionar o Pedido.")
				_Retorno := .F.
			Else
				If oXXGetDad:aCols[N1][nXXPRODUTO] <> oYYGetDad:aCols[oYYGetDad:oBrowse:nAt][nYYPRODUTO]
					MsgStop("Produto do Pedido de Compras diferente do Produto da NF.")
					_Retorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidando o fator de Conversใo                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno .and. lMarca
		For x := 1 to Len(oXXGetDad:aCols)
			If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
				N1 := x
				Exit
			EndIf
		Next x
		If Empty(oXXGetDad:aCols[N1][nXXFATOR])
			//lEhFornec
			//nRecTab1
			cXmlPrdCod := oXXGetDad:aCols[N1][nXXPRODXML]
			cXmlPrdDes := oXXGetDad:aCols[N1][nXXDESCRIC]
			cXmlPrdNcm := aPrdNcm[N1]
			cXmlUniMed := oXXGetDad:aCols[N1][nXXUM]
			//cCodCliFor
			//cLojCliFor
			//cNomCliFor
			cCodProdut := oYYGetDad:aCols[oYYGetDad:oBrowse:nAt,nYYPRODUTO]
			nRecA5A7   := 0
			nFator     := oXXGetDad:aCols[N1][nXXFATOR]
			cTipoFat   := ""

			lRetFunc   := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,cCodProdut,nRecA5A7,@nFator,@cTipoFat)
			If !lRetFunc
				MsgStop("Nใo ้ possํvel marcar um Produto sem fator de conversใo.")
				_Retorno := .F.
			Else
				For x := 1 to Len(oXXGetDad:aCols)
					If oXXGetDad:aCols[x][nXXPRODXML] == cXmlPrdCod
						oXXGetDad:aCols[x][nXXPRODUTO] := cCodProdut
						oXXGetDad:aCols[x][nXXFATOR  ] := nFator
						oXXGetDad:aCols[x][nXXTPFATOR] := cTipoFat
						If cTipoFat == 'M'
							oXXGetDad:aCols[x][nXXQTD1] := Round(oXXGetDad:aCols[N1][nXXQTD2] * nFator,4)
						EndIf
						If cTipoFat == 'D'
							oXXGetDad:aCols[x][nXXQTD1] := Round(oXXGetDad:aCols[N1][nXXQTD2] / nFator,4)
						EndIf
					EndIf
				Next x
				nTotNF := oXXGetDad:aCols[N1][nXXQTD1]
				oXXGetDad:Refresh()
				oTotNF:Refresh()
			EndIf
		EndIf
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidando se o produto do pedido clicado anteriormente e igual ao atual ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno .and. lMarca
		For x := 1 to Len(oYYGetDad:aCols)
			If x <> nLinhaYY
				If oYYGetDad:aCols[x][nYYFLAG] == "LBTIK"
					If oYYGetDad:aCols[x][nYYPRODUTO] <> oYYGetDad:aCols[nLinhaYY][nYYPRODUTO]
						MsgStop("Produto diferente do selecionado anteriormente.")
						_Retorno:= .F.
						Exit
					EndIf
				EndIf
			EndIf
		Next x
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidando a quantidade marcada no pedido nao e Igual a ZERO             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If _Retorno .and. lMarca
		_lZero:=.F.
		For x := 1 to Len(oYYGetDad:aCols)
			If oYYGetDad:aCols[x][nYYFLAG] == "LBTIK"
				If oYYGetDad:aCols[x][NYYSALDO] == 0
					oYYGetDad:aCols[x][nYYFLAG] := "LBNO"
					MsgStop("Este Pedido nใo pode ser selecionado, porque seu Saldo ้ ZERO!!!")
					_Retorno := .F.
					_lZero:=.T.
					exit
				EndIf
			EndIf
		Next x
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidando a quantidade marcada no pedido nao e superior a NF            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno .and. lMarca
		For x := 1 to Len(oXXGetDad:aCols)
			If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
				N1 := x
				Exit
			EndIf
		Next x
		nQtdNF  := oXXGetDad:aCols[N1][nXXQTD1]
		nAccPed := 0
		For x := 1 to Len(oYYGetDad:aCols)
			If x <> oYYGetDad:oBrowse:nAt
				If oYYGetDad:aCols[x][nYYFLAG] == "LBTIK"
					nAccPed += oYYGetDad:aCols[x][NYYSALDO]
				EndIf
			EndIf
		Next x
		If nAccPed >= nQtdNF .and. !Empty(nQtdNF)
			MsgStop("Os Pedidos selecionados anteriormente sใo suficientes para atender a NF." + Chr(13) + "Quantidade NF:" + Transform(nQtdNF,"@E 999,999.99"))
			_Retorno := .F.
		EndIf
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAviso de Quantidade e Valor divergente do Pedido com NF                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno .and. lMarca

		//Chamado #032330 - mauresi 21/03/2022
		//Trata diferenca de 0,03 na validacao PC x XML		
		if U_VALIDACAO("MAURESI",.T.,"22/03/2022")

			nXXPrcUni := Round((oXXGetDad:aCols[N1][nXXQTD2]/oXXGetDad:aCols[N1][nXXQTD1]) * oXXGetDad:aCols[N1][nXXPRCUNIT], 2 )
			nYYPrcUni := Round(oYYGetDad:aCols[nLinhaYY][nYYPRCUNIT] , 2 )

			// Se diferen็a for maior que 0,03 exibe mensagem.
			If  ABS( nXXPrcUni - nYYPrcUni) > 0.03 
				if _lMSG02
					MsgInfo("Pre็os unitแrios divergentes:" + Chr(13) + "NF: " + Transform(nXXPrcUni,fX3Ret("D1_VUNIT","X3_PICTURE")) + Chr(13) + "PC: " + Transform(nYYPrcUni,fX3Ret("C7_PRECO","X3_PICTURE")  ) + Chr(13) + Chr(13) + "Verifique os valores e refa็a a opera็ใo!")
					_Retorno:= .F.  // MAURESI - 16/03/2022
				Endif
			EndIf

		else
	
			nXXPrcUni := Round((oXXGetDad:aCols[N1][nXXQTD2]/oXXGetDad:aCols[N1][nXXQTD1]) * oXXGetDad:aCols[N1][nXXPRCUNIT],fX3Ret("D1_VUNIT","X3_DECIMAL"))
			nYYPrcUni := oYYGetDad:aCols[nLinhaYY][nYYPRCUNIT]
			
			If nXXPrcUni <> nYYPrcUni
				if _lMSG02
					MsgInfo("Pre็os unitแrios divergentes:" + Chr(13) + "NF: " + Transform(nXXPrcUni,fX3Ret("D1_VUNIT","X3_PICTURE")) + Chr(13) + "PC: " + Transform(nYYPrcUni,fX3Ret("C7_PRECO","X3_PICTURE")  ) + Chr(13) + Chr(13) + "Verifique os valores e refa็a a opera็ใo!")
					_Retorno:= .F.  // MAURESI - 16/03/2022
				Endif
			EndIf
			
		Endif

		


	EndIf




// MAURESI - 17/08/2021
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAviso de DESCONTO DIVERGENTE do Pedido com NF                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno .and. lMarca
		_nXVALDESC := oXXGetDad:aCols[N1][nXXVALDESC]
		_nYVALDESC := oYYGetDad:aCols[nLinhaYY][nYYVALDESC]

		If _nXVALDESC <> _nYVALDESC
			if _lMSG02
				MsgInfo("Desconto Divergente:" + Chr(13) + "NF: " + Transform(_nXVALDESC,fX3Ret("D1_VUNIT","X3_PICTURE")) + Chr(13) + "PC: " + Transform(_nYVALDESC,fX3Ret("C7_PRECO","X3_PICTURE")  ) )
				_Retorno:= .F.
			Endif
		EndIf
	EndIf

// MAURESI - 17/08/2021
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAviso de FRETE DIVERGENTE do Pedido com NF                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno .and. lMarca
		_nXVALFRE := oXXGetDad:aCols[N1][nXXVALFRE]
		_nYVALFRE := oYYGetDad:aCols[nLinhaYY][nYYVALFRE]

		If _nXVALFRE <> _nYVALFRE
			if _lMSG02
				MsgInfo("Valor de FRETE Divergente:" + Chr(13) + "NF: " + Transform(_nXVALFRE,fX3Ret("D1_VUNIT","X3_PICTURE")) + Chr(13) + "PC: " + Transform(_nYVALFRE,fX3Ret("C7_VALFRE","X3_PICTURE")  ) )
				_Retorno:= .F.
			Endif
		EndIf
	EndIf





//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMarcando o markbrowse 2                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _Retorno
		If oYYGetDad:aCols[nLinhaYY][nYYFLAG] == "LBTIK"
			oYYGetDad:aCols[nLinhaYY][nYYFLAG] := "LBNO"
			nTotPC-= oYYGetDad:aCols[nLinhaYY][NYYSALDO]
		Else
			oYYGetDad:aCols[nLinhaYY][nYYFLAG] := "LBTIK"
			nTotPC += oYYGetDad:aCols[nLinhaYY][NYYSALDO]
		EndIf
	EndIf

//Atualiza tela
	oYYGetDad:oBrowse:nAt := nLinhaYY
	oYYGetDad:oBrowse:Refresh()
	oYYGetDad:oBrowse:SetFocus()
	oTotPC:Refresh()
	oTotNF:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkItem2บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinkItem2(aSizeDlg,oDialg)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := Nil                                             // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHead          := {}                                              // Array do aHeader
	Local aCols          := {}                                              // Array do aCols
	Local cMsgCabec      := ""

	aAdd(aHead,{""              ,"YY_FLAG"      ,"@BMP"               ,  01,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Num.PC"        ,"YY_PEDIDO"    ,"@!"                 ,  10,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"It.PC"         ,"YY_ITEMPC"    ,"@!"                 ,  05,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Produto"       ,"YY_PRODUTO"   ,"@!"                 ,  10,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Descricao"     ,"YY_DESCRIC"   ,"@!"                 ,  20,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Dt.Entrega"    ,"YY_DATPRF"    ,"@D"                 ,  08,       0, ""      , "€€€€€€€€€€€€€€", "D"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Unid."         ,"YY_UM"        ,"@!"                 ,  05,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Preco Unit."   ,"YY_PRCUNIT"   ,"@E 999,999,999.99"  ,  08,       4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Saldo 1ช UM"   ,"YY_SALDO"     ,"@E 999,999,999.99"  ,  08,       4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Requisit."     ,"YY_ENTID"     ,"@!"                 ,  06,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Local"         ,"YY_LOCAL"     ,"@!"                 ,  02,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	If _lTesInt
		aAdd(aHead,{"Operacao"      ,"YY_OPER"      ,"@!"                 ,  02,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	EndIf
	aAdd(aHead,{"C.Custo"       ,"YY_CC"        ,"@!"                 ,  10,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Produto TMP"   ,"YY_XPROTMP"   ,"@R"                 ,  15,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"Vl.Desconto"   ,"YY_VALDESC"   ,"@E 999,999,999.99"  ,  08,       4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })        // MAURESI 11/08/2021
	aAdd(aHead,{"Vl.Frete"      ,"YY_VALFRE"    ,"@E 999,999,999.99"  ,  08,       4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })        // MAURESI 11/08/2021
	aAdd(aHead,{""              ,"YY_LEGENDA"   ,"@!"                 ,  01,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
	aAdd(aCols,Array(Len(aHead)+1))
	nLin := Len(aCols)

//Alimenta a linha do aCols vazia
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_FLAG"   }) ] := "LBNO" //"LBTIK"
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_PEDIDO" }) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_ITEMPC" }) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_PRODUTO"}) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_DESCRIC"}) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_DATPRF" }) ] := CtoD('')
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_UM"     }) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_PRCUNIT"}) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_SALDO"  }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_ENTID"  }) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_LOCAL"  }) ] := ""
	If _lTesInt
		aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_OPER"   }) ] := ""
	endif
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_CC"     }) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_VALDESC"  }) ] := 0     // MAURESI 11/08/2021
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_VALFRE"  }) ] := 0     // MAURESI 11/08/2021

	aCols[nLin, Len(aHead)+1]                                   := .F.

	oYYGetDad:=MsNewGetDados():New(aSizeDlg[1]+5,aSizeDlg[2]+5,aSizeDlg[3]-5,aSizeDlg[4]-5,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
	oYYGetDad:oBrowse:bLDblClick := {|| fYYClick() }

	nYYFLAG     := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_FLAG"    })
	nYYPEDIDO   := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_PEDIDO"  })
	nYYITEMPC   := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_ITEMPC"  })
	nYYPRODUTO  := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_PRODUTO" })
	nYYDESCRIC  := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_DESCRIC" })
	nYYDATPRF   := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_DATPRF"  })
	nYYUM       := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_UM"      })
	nYYPRCUNIT  := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_PRCUNIT" })
	nYYSALDO	:= aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_SALDO"   })
	nYYENTID    := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_ENTID"   })
	nYYLOCAL    := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_LOCAL"   })
	If _lTesInt
		nYYOPER		:= aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_OPER"    })
	endif
	nYYCC       := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_CC"      })
	nYYXPROTMP  := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_XPROTMP" })
	nYYVALDESC	:= aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_VALDESC"   })      //MAURESI  - 11/08/2021
	nYYVALFRE	:= aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_VALFRE"   })      //MAURESI  - 11/08/2021
	nYYLEGENDA  := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_LEGENDA" })

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

// Chamada para Atribuir CORES as linhas do Grid 02
	oYYGetDad:oBrowse:lUseDefaultColors := .F.
	oYYGetDad:oBrowse:SetBlkBackColor({|| CorGd02(oYYGetDad:nAt,8421376,aCols)})
	oYYGetDad:oBrowse:Refresh()

Return


Static Function CorGd02(nLinha,nCor,aCols)

	Local nRet := 16777215

	If oYYGetDad:aCols[nLinha,nYYLEGENDA] == c2Leg2
		nRet := n2Leg2
	Endif

	If oYYGetDad:aCols[nLinha,nYYLEGENDA] == c2Leg1
		nRet   := n2Leg1
	Endif

	If oYYGetDad:aCols[nLinha,nYYLEGENDA] == c2Leg3
		nRet   := n2Leg3
	Endif

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkRodapบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinkRodap(aSizeDlg,oDialg,nOpcao)

	Local nQtdCpo := 8
	Local nTamBtn := (aSizeDlg[4] / nQtdCpo)
	Local aBtn01  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 0) + (005) ,  nTamBtn-10, 012}
	Local aBtn02  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 1) + (005) ,  nTamBtn-10, 012}
	Local aBtn03  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 2) + (005) ,  nTamBtn-10, 012}
	Local aBtn04  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 3) + (005) ,  nTamBtn-10, 012}
	Local aBtn05  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 4) + (005) ,  nTamBtn-10, 012} // Fator conversao
	Local aBtn06  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 5) + (005) ,  nTamBtn-10, 012} // Boletos
	Local aBtn07  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 6) + (005) ,  nTamBtn-10, 012}
	Local aBtn08  := {aSizeDlg[1],   aSizeDlg[2] + (nTamBtn * 7) + (005) ,  nTamBtn-10, 012}

	Private nLinPrBot := 05
	Private nColPrBot := 10

//Contorno
//@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3]+10, aSizeDlg[4] Of oDialg Pixel      
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3]+8 , aSizeDlg[4] Of oDialg Pixel

// Totalizadores
/*
	If GetVersao(.F.,.F.) == "xx12"
	@ 280+4,260 Say "Total qtd. 1ช UM: "   Size 50,12                  PIXEL //OF oTelaDV2       //@ 250+4,245
	@ 280  ,285 Say oTotNF Var Transform(nTotNF,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2      //@ 250  ,270
	oTotNF:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)
	
	@ 280+4,355 Say "Total pedidos: "   Size 50,12                  PIXEL //OF oTelaDV2                       //@ 250+4,340
	@ 280  ,375 Say oTotPC Var Transform(nTotPC,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2 //@ 250  ,360
	oTotPC:oFont := TFont():New('Arial',,23,,.T.,,,,.T.,.F.)
	else
*/
	@ (aBtn01[1])   +4,260 Say "Total qtd. 1ช UM: "   Size 50,12                  PIXEL //OF oTelaDV2       //@ 250+4,245
	@ (aBtn01[1])   +2,285 Say oTotNF Var Transform(nTotNF,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2      //@ 250  ,270
	oTotNF:oFont := TFont():New('Arial',,23,,.T.,,,,.T.,.F.)

	@ (aBtn01[1] +4),355 Say "Total pedidos: "   Size 50,12                  PIXEL //OF oTelaDV2                       //@ 250+4,340
	@ (aBtn01[1] +2),375 Say oTotPC Var Transform(nTotPC,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2 //@ 250  ,360
	oTotPC:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)

/*
	@ (aBtn01[1]-12)+3,010 Say "Total qtd. 1ช UM: "   Size 50,12                  PIXEL //OF oTelaDV2       //@ 250+4,245
	@ (aBtn01[1]-12)  ,040 Say oTotNF Var Transform(nTotNF,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2      //@ 250  ,270
	oTotNF:oFont := TFont():New('Arial',,23,,.T.,,,,.T.,.F.)
	
	@ (aBtn01[1]-12)+3,335 Say "Total pedidos: "   Size 50,12                  PIXEL //OF oTelaDV2                       //@ 250+4,340
	@ (aBtn01[1]-12)  ,365 Say oTotPC Var Transform(nTotPC,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2 //@ 250  ,360
	oTotPC:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)

	Endif
*/                
//Bot๕es
	nLinBot := nLinPrBot
	nColBot := nColPrBot

	@ nLinBot,nColBot Button "Associar    <F4>" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fLinkAssoc()
	SetKey(VK_F4, {|| fLinkAssoc() })
	fIncLCBot(@nLinBot,@nColBot)

	@ nLinBot,nColBot Button "Desassociar <F5>"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fLinkDesas()
	SetKey(VK_F5, {|| fLinkDesas() })
	fIncLCBot(@nLinBot,@nColBot)

	@ nLinBot,nColBot    Button "Fator Conv.  <F6>"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fFatorConv()
	SetKey(VK_F6, {|| fFatorConv() })
	fIncLCBot(@nLinBot,@nColBot)

	If _lTesInt
//	If _lTesInt .and.  !(_lUsrRec)
		@ nLinBot,nColBot Button "Tes/Opera็ใo <F7>"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fEditTes()
		SetKey(VK_F7, {|| fEditTes() })
		fIncLCBot(@nLinBot,@nColBot)
	Else
		fIncLCBot(@nLinBot,@nColBot)
	EndIf

	@ nLinBot,nColBot Button "Salvar       <F9>"      Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action fSalvaZZ3()
	SetKey(VK_F9, {|| fSalvaZZ3() })
	fIncLCBot(@nLinBot,@nColBot)

	@ nLinBot,nColBot Button "Fechar"      Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
	fIncLCBot(@nLinBot,@nColBot)

	@ nLinBot,nColBot Button "Confirmar  <Ctrl+S>"   Size aBtn04[3],aBtn04[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())
	SetKey(19, {|| fSalvaZZ3() })
	fIncLCBot(@nLinBot,@nColBot)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkAssocบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinkAssoc()

// XML / Documento de Entrada

//Pedido de Compra
	Local nLinGD1 := 0
	Local nLinGD2 := 0
	Local aNewArray := {}

	Local x       := 1
	Local lOk     := .F.

	For x:= 1 To Len(oXXGetDad:aCols)
		If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
			If Empty(oXXGetDad:aCols[x][nXXPEDIDO]) .And. Empty(oXXGetDad:aCols[x][nXXITEMPC])
				lOk     := .T.
				nLinGD1 :=  x
			Else
				lOk     := .F.
				MsgAlert("O item selecionado jแ estแ associado a um pedido!")
			EndIf
			x := Len(oXXGetDad:aCols)
		EndIf
	Next x

	If lOk
		For x:= 1 To Len(oYYGetDad:aCols)
			If oYYGetDad:aCols[x][nYYFLAG] == "LBTIK"
				nLinGD2 :=  x
				Exit
			EndIf
		Next x
	EndIf

// Obriga Selecionar pelo menos 1 item de cada Lado
	If lOk .And. (Empty(nLinGD1) .Or. Empty(nLinGD2))
		lOk     := .F.
		MsgAlert("Favor selecionar os itens antes de clicar em associar!")
	EndIf

// Atualiza o Produto com o do Pedido de Compra. Precisa estar antes das Demais Validacoes.
	If lOk
		oXXGetDad:aCols[nLinGD1][nXXPRODUTO] := oYYGetDad:aCols[nLinGD2][nYYPRODUTO]
		_cProd	:= oYYGetDad:aCols[nLinGD2][nYYPRODUTO]	//  Variavel usada para retornar TES INTELIGENTE
		oXXGetDad:oBrowse:Refresh()
	EndIf

// Verifica Preco do Produto
//If lOk .And. AllTrim(oXXGetDad:aCols[nLinGD1][nPos1Prc]) != AllTrim(oYYGetDad:aCols[nLinGD2][nPos2Prc])
//	MsgAlert("ATENวรO: O pre็o unitario do produto selecionado estแ diferente ( XML x PC ) !")
//EndIf


// Verifica o Valor  do Desconto          // MAURESI 04/08/2021  - Trata Desconto
//If lOk .And. AllTrim(oXXGetDad:aCols[nLinGD1][nXXVALDESC]) != AllTrim(oYYGetDad:aCols[nLinGD2][nYYVALDESC])
//MsgAlert("ATENวรO: O valor do desconto estแ divergente. ( XML x PC ) !")
//EndIf

// Verifica o Valor  do FRETE          // MAURESI 11/08/2021  - Trata FRETE
//If lOk .And. AllTrim(oXXGetDad:aCols[nLinGD1][nXXVALFRE]) != AllTrim(oYYGetDad:aCols[nLinGD2][nYYVALFRE])
//MsgAlert("ATENวรO: O valor do FRETE estแ divergente. ( XML x PC ) !")
//EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDesmembra Itens do XML de Acordo com o PEDIDO DE COMPRAณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// Mais de 1 Pedido Selecionado, divide a NF na Qtds de itens
	If lOk
		nTotItem2 := 0
		nQtdPC    := 0
		nPrimPC   := 0
		For x := 1 to Len(oYYGetDad:aCols)
			If oYYGetDad:aCols[x][nYYFLAG] == "LBTIK"
				nTotItem2++
				nQtdPC += oYYGetDad:aCols[x][nYYSALDO]
				If Empty(nPrimPC)
					nPrimPC := x
				EndIf
			EndIf
		Next x

		If nQtdPC <> oXXGetDad:aCols[nLinGD1][nXXQTD1]
			if _lMSG02
				MsgInfo("Quantidades divergentes:" + Chr(13) + ;
					"NF: " + Transform(oXXGetDad:aCols[nLinGD1][nXXQTD1],fX3Ret("D1_QUANT","X3_PICTURE")) + Chr(13) + ;
					"PC: " + Transform(nQtdPC,fX3Ret("C7_QUANT","X3_PICTURE")  ) )
			Endif
		EndIf

		// Incluindo no oGetDados XX a quantidade do pedido de compras
		oXXGetDad:aCols[nLinGD1][nXXQTDPC]   := nQtdPC

		If nTotItem2 > 1

			aNewArray   := {}
			aNewItens   := {}

			aLinhaAtu   := aClone(oXXGetDad:aCols[nLinGD1])
			aLinhaItens := aClone(aItens[nLinGD1])

			For x := 1 To (nLinGD1-1)
				AADD(aNewArray,aClone(oXXGetDad:aCols[x]) )
				AADD(aNewItens,aClone(aItens[x])          )
			Next x

			nDistrib     := 0
			nDispDescont := 0
			For x := 1 to nTotItem2
				AADD(aNewArray,Aclone(aLinhaAtu)   )
				AADD(aNewItens,Aclone(aLinhaItens) )

				nDesTotItem := aNewArray[Len(aNewArray),nXXVALDESC]

				If x <> nTotItem2
					nProporcao                            := oYYGetDad:aCols[nPrimPC+x-1,nYYSALDO]/aNewArray[Len(aNewArray),nXXQTD1]
					//                                    a propor็ใo da qtd1 nova dividida pela velha (qtd1) vezes a qtd2
					aNewArray[Len(aNewArray),nXXQTD2    ] := nProporcao * aNewArray[Len(aNewArray),nXXQTD2]
					aNewArray[Len(aNewArray),nXXQTD1    ] := oYYGetDad:aCols[nPrimPC+x-1,nYYSALDO]

					aNewArray[Len(aNewArray),nXXVALDESC ] := nProporcao * nDesTotItem

					aNewArray[ Len(aNewArray),nXXPEDIDO ] := oYYGetDad:aCols[nPrimPC+x-1][nYYPEDIDO]
					aNewArray[ Len(aNewArray),nXXITEMPC ] := oYYGetDad:aCols[nPrimPC+x-1][nYYITEMPC]
					aNewArray[ Len(aNewArray),nXXLOCAL  ] := oYYGetDad:aCols[nPrimPC+x-1][nYYLOCAL ]
					if _lTesInt
						aNewArray[ Len(aNewArray),nXXOPER   ] := oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณRetorna TES Inteligenteณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						_cOper		:= oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]

						if U_VALIDACAO()  // MAURESI 23/09/2021
							if _lDmxFilial
								aNewArray[ Len(aNewArray),nXXOPER   ] := "01"
								_cOper	:= "01"
							endif
						endif

						_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)
						aNewArray[ Len(aNewArray),nXXTES    ] :=  _cTesEnt
						//
					endif
					aNewArray[ Len(aNewArray),nXXCC     ] := oYYGetDad:aCols[nPrimPC+x-1][nYYCC    ]

					nDistrib     += aNewArray[Len(aNewArray),nXXQTD1   ]
					nDispDescont += aNewArray[Len(aNewArray),nXXVALDESC]
				Else
					nProporcao                            := ((nQtdNF - nDistrib)/aNewArray[Len(aNewArray),nXXQTD1])
					//                                     a propor็ใo da qtd1 nova dividida pela velha (qtd1) vezes a qtd2
					aNewArray[Len(aNewArray),nXXQTD2    ] := nProporcao * aNewArray[Len(aNewArray),nXXQTD2]
					aNewArray[Len(aNewArray),nXXQTD1    ] := nQtdNF - nDistrib

					aNewArray[Len(aNewArray),nXXVALDESC ] := nDesTotItem - nDispDescont

					aNewArray[ Len(aNewArray),nXXPEDIDO ] := oYYGetDad:aCols[nPrimPC+x-1][nYYPEDIDO]
					aNewArray[ Len(aNewArray),nXXITEMPC ] := oYYGetDad:aCols[nPrimPC+x-1][nYYITEMPC]
					aNewArray[ Len(aNewArray),nXXLOCAL  ] := oYYGetDad:aCols[nPrimPC+x-1][nYYLOCAL ]
					if _ltesInt
						aNewArray[ Len(aNewArray),nXXOPER   ] := oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณRetorna TES Inteligenteณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						_cOper	:= oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]

						if U_VALIDACAO()  // MAURESI 23/09/2021
							if _lDmxFilial
								aNewArray[ Len(aNewArray),nXXOPER   ] := "01"
								_cOper	:= "01"
							endif
						endif

						_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)
						aNewArray[ Len(aNewArray),nXXTES    ] := _cTesEnt
						//
					endif
					aNewArray[ Len(aNewArray),nXXCC     ] := oYYGetDad:aCols[nPrimPC+x-1][nYYCC    ]

				EndIf

				If oYYGetDad:aCols[nPrimPC+x-1][nYYSALDO] > aNewArray[Len(aNewArray),nXXQTD1]
					oYYGetDad:aCols[nPrimPC+x-1][nYYSALDO] -= aNewArray[Len(aNewArray),nXXQTD1]
				Else
					oYYGetDad:aCols[nPrimPC+x-1][nYYSALDO] := 0
				EndIf

				If oYYGetDad:aCols[nPrimPC+x-1][nYYSALDO] == 0
					oYYGetDad:aCols[nPrimPC+x-1][nYYLEGENDA] := c2Leg2
				Else
					oYYGetDad:aCols[nPrimPC+x-1][nYYLEGENDA] := ""
				EndIf

			Next x

			For x := (nLinGD1+1) to Len(oXXGetDad:aCols)
				AADD(aNewArray,aClone(oXXGetDad:aCols[x]) )
				AADD(aNewItens,aClone(aItens[x])          )
			Next x

			oXXGetDad:aCols := aClone(aNewArray)
			aItens          := aClone(aNewItens)
		Else
			For x := 1 to Len(oXXGetDad:aCols)
				If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
					N1 := x
				EndIf
			Next x

			For x := 1 to Len(oYYGetDad:aCols)
				If oYYGetDad:aCols[x][nYYFLAG] == "LBTIK"
					N2 := x
				EndIf
			Next x

			oXXGetDad:aCols[N1,nXXPEDIDO ] := oYYGetDad:aCols[N2][nYYPEDIDO]
			oXXGetDad:aCols[N1,nXXITEMPC ] := oYYGetDad:aCols[N2][nYYITEMPC]
			oXXGetDad:aCols[N1,nXXLOCAL  ] := oYYGetDad:aCols[N2][nYYLOCAL ]
			if _lTesInt
				oXXGetDad:aCols[N1,nXXOPER   ] := oYYGetDad:aCols[N2][nYYOPER  ]
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณRetorna TES Inteligenteณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_cOper	:= oYYGetDad:aCols[N2][nYYOPER  ]

				if U_VALIDACAO()  // MAURESI 23/09/2021
					if _lDmxFilial
						oXXGetDad:aCols[N1,nXXOPER   ] := "01"
						_cOper	:= "01"
					endif
				endif

				_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)
				oXXGetDad:aCols[N1,nXXTES ] :=  _cTesEnt
				//
			endif
			oXXGetDad:aCols[N1,nXXCC     ] := oYYGetDad:aCols[N2][nYYCC    ]

			If oYYGetDad:aCols[N2][nYYSALDO] > oXXGetDad:aCols[N1][nXXQTD1 ]
				oYYGetDad:aCols[N2][nYYSALDO] -= oXXGetDad:aCols[N1][nXXQTD1]
			Else
				oYYGetDad:aCols[N2][nYYSALDO] := 0
			EndIf

			If oYYGetDad:aCols[N2][nYYSALDO] == 0
				oYYGetDad:aCols[N2][nYYLEGENDA] := c2Leg2
			Else
				oYYGetDad:aCols[N2][nYYLEGENDA] := ""
			EndIf

		EndIf
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFINAL DO ASSOCIACAO                      ณ
//ณDesmarca Todos os Itens e Atualiza a Telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lOk
		For x := 1 to Len(oXXGetDad:aCols)
			oXXGetDad:aCols[x][nXXFLAG] := "LBNO"
		Next x
		For x := 1 to Len(oYYGetDad:aCols)
			oYYGetDad:aCols[x][nYYFLAG] := "LBNO"
			If oYYGetDad:aCols[x][nYYLEGENDA] == c2Leg1
				oYYGetDad:aCols[x][nYYLEGENDA] := ""
			EndIf
		Next x
		nTotPC:=0
		nTotNF:=0
		oTotPC:Refresh()
		oTotNF:Refresh()

		oXXGetDad:oBrowse:Refresh()
		oYYGetDad:oBrowse:Refresh()
		oXXGetDad:Refresh()
		oYYGetDad:Refresh()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfLinkDesasบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinkDesas()

	Local x       := 1

	For x:=1 To Len(oXXGetDad:aCols)
		If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
			oXXGetDad:aCols[x][nXXPEDIDO] := ""
			oXXGetDad:aCols[x][nXXITEMPC] := ""
			if _lTesINt
				oXXGetDad:aCols[x][nXXOPER] := ""
				oXXGetDad:aCols[x][nXXTES]  := ""
			endif
		EndIf
	Next x

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerRlcPrdบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,cCodProdut,nRecA5A7,nFator,cTipoFat)


//Variaveis do tamanho a tela
	Local aDlgTela     := {000,000,410,505} //{000,000,343,505}

//Divis๕es dentro da tela
	Local aDlgCabc     := {005,005,040,250}
	Local aDlgCorp1    := {045,005,092,250}
	Local aDlgCorp2    := {097,005,144,250}
	Local aDlgCorp3    := {149,005,174,250}
	Local aDlgRodp     := {179,005,199,250}

	Local nQtdCpo      := 5
	Local nTamBtn      := (aDlgRodp[4] / nQtdCpo)
	Local aBtn01       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 3) + (005) ,  nTamBtn-10, 012}
	Local aBtn02       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 4) + (000) ,  nTamBtn-10, 012}

	Local cTab2        := AllTrim(GetMV("MX_MRALS02"))
	Local cAls2        := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)

	Local oDialg
	Local cStrCad      := AllTrim(GetMV("MX_MRALS02"))
	Local cTitCad      := "Amarra็ใo Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
	Local cPrtCad      := cTitCad+" ["+cStrCad+"]"
	Local cCpoXml      := cCodCliFor +"-"+ cLojCliFor

	Local nOpcao       := 0
	Local lExiste      := .F.
	Local lReturn      := .T.
	Local lLoop        := .T.

	Local cCpoUmXml    := AllTrim(IIf(lEhFornec,GetMV("MX_MRSA501"),GetMV("MX_MRSA701")))
	Local cCpoFCNum    := AllTrim(IIf(lEhFornec,GetMV("MX_MRSA502"),GetMV("MX_MRSA702")))
	Local cCpoFCTip    := AllTrim(IIf(lEhFornec,GetMV("MX_MRSA503"),GetMV("MX_MRSA703")))

	Local lWhenUmXml   := .F.
	Local lWhenFCNum   := .F.
	Local lWhenFCTip   := .F.
	Local lWhenTtCps   := .F.

	Default nRecA5A7   := 0
	Default nFator     := 1

	Default cCodProdut := Space(fX3Ret("B1_COD","X3_TAMANHO"))
	Private cCadPrdCod := cCodProdut
	Private cCadPrdNcm := ""
	Private cCadUniMed := ""
	Private cCadPrdDes := ""

	Private nCadFatCon := nFator
	Private oCadTipCon := Nil
	Private cCadTipCon := "M"
	Private aCadTipCon := {"M=Multiplicador","D=Divisor"}

//Trata campos de Conversใo
	If Empty(fX3Ret(cCpoUmXml,"X3_CAMPO"))
		//Campo nใo foi criado
		lWhenUmXml := .F.
	Else
		//Campo OK
		lWhenUmXml := .T.
	EndIf

//Trata campos de Conversใo
	If Empty(fX3Ret(cCpoFCNum,"X3_CAMPO"))
		//Campo nใo foi criado
		lWhenFCNum := .F.
	Else
		//Campo OK
		lWhenFCNum := .T.
	EndIf

//Trata campos de Conversใo
	If Empty(fX3Ret(cCpoFCTip,"X3_CAMPO"))
		//Campo nใo foi criado
		lWhenFCTip := .F.
	Else
		//Campo OK
		lWhenFCTip := .T.
	EndIf

//Se todos campos foram criado, entใo faz tratamento
	If lWhenUmXml .And. lWhenFCNum .And. lWhenFCTip
		lWhenTtCps := .T.
	EndIf

	While lLoop

		If Empty(nRecA5A7)
			If Empty(cCadPrdCod)
				cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
				cCadPrdNcm := "NCM"
				cCadPrdDes := "DESC"
				cCadUniMed := "UM"
				nCadFatCon := 1
				cCadTipCon := "M"
			Else
				SB1->( dbSetOrder(1) )
				SB1->( dbSeek( xFilial() + cCadPrdCod ) )
				cCadPrdNcm := SB1->B1_POSIPI
				cCadPrdDes := SB1->B1_DESC
				cCadUniMed := SB1->B1_UM
				//nCadFatCon := 1
				cCadTipCon := "M"
			EndIf
		Else
			If lEhFornec
				SA5->(DbGoTo(nRecA5A7))
				cCadPrdCod := SA5->A5_PRODUTO
				fVldRlcPrd(.F.)
				nCadFatCon := &("SA5->"+cCpoFCNum)
				cCadTipCon := &("SA5->"+cCpoFCTip)
			Else
				SA7->(DbGoTo(nRecA5A7))
				cCadPrdCod := SA7->A7_PRODUTO
				fVldRlcPrd(.F.)
				nCadFatCon := &("SA7->"+cCpoFCNum)
				cCadTipCon := &("SA7->"+cCpoFCTip)
			EndIf
		EndIf

		// Montagem da tela que serah apresentada para usuario (lay-out)
		Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Pixel //Of oMainWnd

		//Cabec
		@ aDlgCabc[1], aDlgCabc[2] To aDlgCabc[3], aDlgCabc[4] LABEL " XML: Dados do "+IIf(lEhFornec,"Fornecedor ","Cliente ") COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

		@ aDlgCabc[1]+010,aDlgCabc[2]+005 Say "Codigo"            Size 030 ,008 Pixel Of oDialg
		@ aDlgCabc[1]+009,aDlgCabc[2]+035 MsGet cCpoXml           Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCabc[1]+022,aDlgCabc[2]+005 Say "Nome"              Size 030 ,008 Pixel Of oDialg
		@ aDlgCabc[1]+021,aDlgCabc[2]+035 MsGet cNomCliFor        Size 205 ,008 Pixel When .F. Of oDialg

		//Corpo 01
		@ aDlgCorp1[1], aDlgCorp1[2] To aDlgCorp1[3], aDlgCorp1[4] LABEL " XML: Dados do Produto " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

		@ aDlgCorp1[1]+010,aDlgCorp1[2]+005 Say "Produto"           Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp1[1]+009,aDlgCorp1[2]+035 MsGet cXmlPrdCod        Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCorp1[1]+022,aDlgCorp1[2]+005 Say "NCM"               Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp1[1]+021,aDlgCorp1[2]+035 MsGet cXmlPrdNcm        Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCorp1[1]+022,aDlgCorp1[2]+128 Say "Unid.Med."         Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp1[1]+021,aDlgCorp1[2]+155 MsGet cXmlUniMed        Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCorp1[1]+034,aDlgCorp1[2]+005 Say "Descri็ใo"         Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp1[1]+033,aDlgCorp1[2]+035 MsGet cXmlPrdDes        Size 205 ,008 Pixel When .F. Of oDialg

		//Corpo 02
		@ aDlgCorp2[1], aDlgCorp2[2] To aDlgCorp2[3], aDlgCorp2[4] LABEL " Relacione o produto acima com um item do seu cadastro " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

		@ aDlgCorp2[1]+010,aDlgCorp2[2]+005 Say "Produto"           Size 030 ,008 Pixel Of oDialg
		//@ aDlgCorp2[1]+009,aDlgCorp2[2]+035 MsGet cCadPrdCod        Size 085 ,008 Pixel When (Empty(cCadPrdCod)) Of oDialg F3 "SB1" Valid(fVldRlcPrd(.F.))
		@ aDlgCorp2[1]+009,aDlgCorp2[2]+035 MsGet cCadPrdCod        Size 085 ,008 Pixel When .T. Of oDialg F3 "SB1" Valid(fVldRlcPrd(.F.))

		@ aDlgCorp2[1]+022,aDlgCorp2[2]+005 Say "NCM"               Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp2[1]+021,aDlgCorp2[2]+035 MsGet cCadPrdNcm        Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCorp2[1]+022,aDlgCorp2[2]+128 Say "Unid.Med."         Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp2[1]+021,aDlgCorp2[2]+155 MsGet cCadUniMed        Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCorp2[1]+034,aDlgCorp2[2]+005 Say "Descri็ใo"         Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp2[1]+033,aDlgCorp2[2]+035 MsGet cCadPrdDes        Size 205 ,008 Pixel When .F. Of oDialg

		//Corpo 03
		@ aDlgCorp3[1], aDlgCorp3[2] To aDlgCorp3[3], aDlgCorp3[4] LABEL " Conversใo Unidade Medida " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

		@ aDlgCorp3[1]+010,aDlgCorp3[2]+005 Say "Fator Conv."       Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp3[1]+009,aDlgCorp3[2]+035 MsGet nCadFatCon        Size 085 ,008 Pixel When lWhenTtCps Of oDialg Picture "@E 99,999.9999"

		@ aDlgCorp3[1]+010,aDlgCorp3[2]+128 Say "Tipo Conv."        Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp3[1]+009,aDlgCorp3[2]+155 ComboBox oCadTipCon Var cCadTipCon Items aCadTipCon Size 085 ,008 Pixel When lWhenTtCps Of oDialg

		//Rodap้ / Bot๕es
		@ aDlgRodp[1], aDlgRodp[2] To aDlgRodp[3], aDlgRodp[4] LABEL "" COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
		@ aBtn01[1],aBtn01[2] Button "Processar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
		@ aBtn02[1],aBtn02[2] Button "Cancelar"  Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())

		Activate MsDialog oDialg Centered

		//Verifica se opera็ใo foi cancelada
		If nOpcao != 1
			lLoop   := .F.
			lReturn := .F.
		EndIf

		//Valida Produto escolhido
		If nOpcao == 1
			lReturn := fVldRlcPrd(.T.)
		EndIf

		//Caso lReturn OK, entใo sair do Loop
		If lLoop .And. lReturn
			lLoop   := .F.
		EndIf

	End

	If nOpcao == 1 .And. lReturn
		If Empty(nCadFatCon)
			MsgStop("O Fator de Conversใo deve ser diferente de zero.")
			lReturn := .F.
		EndIf
	EndIf

	If nOpcao == 1 .And. lReturn


		//Declara variavel
		lExiste := .F.
		lReturn := .T.

		If lEhFornec
			//Tratando tamanho do conteudo do campo
			cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"1")

			SA5->(dbSetOrder(1))
			If SA5->(dbSeek(xFilial("SA5")+ cCodCliFor + cLojCliFor + cCadPrdCod))
				While SA5->(!Eof()) .And. SA5->A5_FILIAL  == xFilial("SA5") ;
						.And. SA5->A5_FORNECE == cCodCliFor     ;
						.And. SA5->A5_LOJA    == cLojCliFor     ;
						.And. SA5->A5_PRODUTO == cCadPrdCod
					If AllTrim(SA5->A5_CODPRF) == Upper(AllTrim(cXmlPrdCod))
						lExiste := .T.
						Exit
					EndIf
					SA5->(DbSkip())
				End
				If lExiste
					RecLock("SA5",.F.)
				Else
					RecLock("SA5",.T.)
					If SA5->(FieldPos("A5_XXPORTA"))>0
						SA5->A5_XXPORTA := "S" //Campo que controla o que serแ mostrado no portal
					EndIf
				EndIf
			Else
				Reclock("SA5",.T.)
				If SA5->(FieldPos("A5_XXPORTA"))>0
					SA5->A5_XXPORTA := "S" //Campo que controla o que serแ mostrado no portal
				EndIf
			Endif
			SA5->A5_FILIAL  := xFilial("SA5")
			SA5->A5_FORNECE := cCodCliFor
			SA5->A5_LOJA    := cLojCliFor
			SA5->A5_NOMEFOR := cNomCliFor
			SA5->A5_PRODUTO := cCadPrdCod
			SA5->A5_NOMPROD := Upper(AllTrim(cCadPrdDes))
			SA5->A5_CODPRF  := Upper(AllTrim(cXmlPrdCod))
			SA5->A5_DESCPRF := Upper(AllTrim(cXmlPrdDes))

			&("SA5->"+cCpoUmXml) := cXmlUniMed
			&("SA5->"+cCpoFCNum) := nCadFatCon
			&("SA5->"+cCpoFCTip) := cCadTipCon

			SA5->(MsUnlock())

			nFator   := nCadFatCon
			cTipoFat := cCadTipCon

			//Esta variavel serแ retornata pra quem a chamou
			cCodProdut := SA5->A5_PRODUTO

			cVldMensag := "O produto ( "+alltrim(cCadPrdCod)+" ) Vs ( "+alltrim(cXmlPrdCod)+" ) foi cadastrado na tabela Amarra็ใo Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
			fGravaMsg(nRecTab1,98," ",cVldMensag)

		Else
			//Tratando tamanho do conteudo do campo
			cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"2")

			SA7->(dbSetOrder(1))
			If SA7->(dbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + cCadPrdCod))
				While SA7->(!Eof()) .And. SA7->A7_FILIAL  == xFilial("SA7") ;
						.And. SA7->A7_CLIENTE == cCodCliFor     ;
						.And. SA7->A7_LOJA    == cLojCliFor     ;
						.And. SA7->A7_PRODUTO == cCadPrdCod

					If AllTrim(SA7->A7_CODCLI) == Upper(AllTrim(cXmlPrdCod))
						lExiste := .T.
						Exit
					EndIf
					SA7->(DbSkip())
				End
				If lExiste
					RecLock("SA7",.F.)
				Else
					RecLock("SA7",.T.)
				EndIf
			Else
				Reclock("SA7",.T.)
			Endif

			SA7->A7_FILIAL  := xFilial("SA7")
			SA7->A7_CLIENTE := cCodCliFor
			SA7->A7_LOJA    := cLojCliFor
			SA7->A7_PRODUTO := cCadPrdCod
			SA7->A7_DESCCLI := Upper(AllTrim(cXmlPrdDes))
			SA7->A7_CODCLI  := Upper(AllTrim(cXmlPrdCod))
			If lWhenTtCps
				&("SA7->"+cCpoUmXml) := cXmlUniMed
				&("SA7->"+cCpoFCNum) := nCadFatCon
				&("SA7->"+cCpoFCTip) := cCadTipCon
			EndIf
			SA7->(MsUnlock())

			//Esta variavel serแ retornata pra quem a chamou
			cCodProdut := SA7->A7_PRODUTO

			cVldMensag := "O produto ( "+alltrim(cCadPrdCod)+" ) Vs ( "+alltrim(cXmlPrdCod)+" ) foi cadastrado na tabela Amarracao Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
			fGravaMsg(nRecTab1,98," ",cVldMensag)

		EndIf
	EndIf

Return(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfVldRlcPrdบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldRlcPrd(lVldVazio)


	Local lOk  := .T.
	Local lRet := .F.
	Default lVldVazio := .F.

//Valida fazio caso solicitado
	If lOk .And. lVldVazio .And. Empty(cCadPrdCod)
		MsgAlert("O Produto nใo foi informado. Informe um produto vแlido!")
		lOk := .F.
	EndIf

//Se for vazio e nใo ้ pra validar, entใo sair e retornar .T., pois opera็ใo foi cancelada
	If lOk .And. !lVldVazio .And. Empty(cCadPrdCod)
		cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
		cCadPrdNcm := ""
		cCadUniMed := ""
		cCadPrdDes := ""
		Return(.T.)
	EndIf

	SB1->(dbSetOrder(1))
	If lOk .And. SB1->(!dbSeek(xFilial("SB1")+cCadPrdCod))
		MsgAlert("Produto Cod.: "+alltrim(cCadPrdCod)+" nใo encontrado. Informe um produto vแlido!")
		lOk := .F.
	EndIf

	If lOk .And. SB1->B1_MSBLQL == "1"
		MsgAlert("Produto Cod.: "+alltrim(cCadPrdCod)+" bloqueado. Informe um produto vแlido!")
		lOk := .F.
	EndIf

	If lOk
		lRet       := .T.
		cCadPrdCod := SB1->B1_COD
		cCadPrdNcm := SB1->B1_POSIPI
		cCadUniMed := SB1->B1_UM
		cCadPrdDes := SB1->B1_DESC
	Else
		lRet       := .F.
		cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
		cCadPrdNcm := ""
		cCadUniMed := ""
		cCadPrdDes := ""
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerPrcExpบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerPrcExp()


	Local cDirDest := cGetFile(,"Selecione o diret๓rio",,"",.T.,GETF_LOCALHARD+ GETF_RETDIRECTORY+GETF_NETWORKDRIVE)

	If !Empty(cDirDest)
		Processa( {|| fGerSlvXml(cDirDest)    },"Exportando XML ..." )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerSlvXmlบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerSlvXml(cDirDest)

	Local x        := 0
	Local cPath    := ""
	Local cTemp    := ""
	Local nRecn    := 0
	Local cTab1    := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local nQtdExp  := 0

	Local nAAFLAG  := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==    "AA_FLAG"  })
	Local nPosRecn := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==    "AA_RECNO" })
	Local nPosCnpj := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==cAls1+"_DECNPJ"})
	Local nPosEmis := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==cAls1+"_DTEMIS"})

	ProcRegua(Len(oAAGetDad:aCols))

	For x:=1 To Len(oAAGetDad:aCols)
		If oAAGetDad:aCols[x][nAAFLAG] == "LBTIK"
			IncProc()
			nQtdExp ++

			cPath := cDirDest

			//CNPJ
			cTemp := Alltrim(oAAGetDad:aCols[x][nPosCnpj])
			cPath += cTemp+"\"

			//ANO
			cTemp := SubStr(DtoS(oAAGetDad:aCols[x][nPosEmis]),1,4)
			cPath += cTemp+"\"

			//MES
			cTemp := SubStr(DtoS(oAAGetDad:aCols[x][nPosEmis]),5,2)
			cPath += cTemp+"\"

			//Trata variavel
			cPath := AllTrim(Upper(cPath))

			//Cria Diretorio
			MontaDir(cPath)

			//Recno do Registro corrente
			nRecn := oAAGetDad:aCols[x][nPosRecn]

			//Gerar Arquivo XML
			fGerGrvXml(cPath,nRecn)

		EndIf
	Next x

	MsgInfo("Foram exportados "+Alltrim(Str(nQtdExp))+" arquivos XML.")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerGrvXmlบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerGrvXml(cPathDest,nRecTab1)

	Local nHdl	:= 0
	Local cCRLF	:= Chr(13)+Chr(10)

	Local cTab1 := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cArqv := ""
	Local cDeth := ""
	Local cMemo := ""

//Posiciona no registro a ser validade
	(cTab1)->(DbGoTo(nRecTab1))
	cArqv := cPathDest + AllTrim((cTab1)->&(cAls1+"_CHVNFE")) + ".XML"

//Apaga arquivo caso exista
	If File(cArqv) ; fErase(cArqv) ; Endif

//Cria arquivo txt
		nHdl := fCreate(cArqv)

		cDeth := AllTrim((cTab1)->&(cAls1+"_MXML" ))
		cDeth += AllTrim((cTab1)->&(cAls1+"_MXML2"))
//cDeth := EncodeUTF8(cDeth)            
		cDeth := noacento(cDeth)

//fWrite( nHdl,cDeth+cCRLF,Len(cDeth+cCRLF ) )
		fWrite( nHdl,cDeth,Len(cDeth ) )

//Finaliza processo e fecha arquivo txt
		fClose(nHdl)

		Return cArqv

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerLegendบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerLegend()

	Local aCores     := {}

	For x:=1 To Len(aHdStatus)
		aAdd(aCores,{aHdStatus[x][2],aHdStatus[x][3]})
	Next x

	BrwLegenda(" Gestor XML ","Legenda",aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerCabec บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerCabec(aSizeDlg,oDialg,cOper)

	Local cTab1        := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

	Local nQtdCpo := 8
	Local nTamCpo := (aSizeDlg[4] / nQtdCpo)

//Declara็ใo das Variแveis
	Local bSayTipDoc := {|| "Tipo Documento"}
	Local aSayTipDoc := {aSizeDlg[1]+05,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}
	Local aGetTipDoc := {aSizeDlg[1]+10,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}

//Declara็ใo das Variแveis
	Local bSayStatus := {|| "Status"}
	Local aSayStatus := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 1)  ,  (nTamCpo*1.5)-05, 008}
	Local aGetStatus := {aSizeDlg[1]+10,   aSizeDlg[2] + (nTamCpo * 1)  ,  (nTamCpo*1.5)-05, 008}

//Declara็ใo das Variแveis
	Local bSayComCCe := {|| "Com CCe"}
	Local aSayComCCe := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 2.5),  (nTamCpo*0.5)-05, 008}
	Local aGetComCCe := {aSizeDlg[1]+10,   aSizeDlg[2] + (nTamCpo * 2.5),  (nTamCpo*0.5)-05, 008}

//Declara็ใo das Variแveis
	Local bSayCnpjEm := {|| "CNPJ Emitente"}
	Local aSayCnpjEm := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}
	Local aGetCnpjEm := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}

//Declara็ใo das Variแveis
	Local bSayNomeEm := {|| "Nome Emitente"}
	Local aSayNomeEm := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}
	Local aGetNomeEm := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}

//Botใo
	Local aBtn01     := {aSizeDlg[1]+13,   aSizeDlg[2] + (nTamCpo * 7)  ,  nTamCpo-05, 012}

//Declara็ใo das Variแveis
	Local bSayTipXml := {|| "Tipo XML"}
	Local aSayTipXml := {aSizeDlg[1]+27,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}
	Local aGetTipXml := {aSizeDlg[1]+37,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}

//Declara็ใo das Variแveis
	Local bSayDtEmis := {|| "A partir Data Emissใo"}
	Local aSayDtEmis := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 1)  ,  nTamCpo-05, 008}
	Local aGetDtEmis := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 1)  ,  nTamCpo-05, 008}

//Declara็ใo das Variแveis
	Local bSaySerNFe := {|| "Serie NF"}
	Local aSaySerNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 2)  ,  nTamCpo-05, 008}
	Local aGetSerNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 2)  ,  nTamCpo-05, 008}

//Declara็ใo das Variแveis
	Local bSayNumNFe := {|| "Numero NF"}
	Local aSayNumNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}
	Local aGetNumNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}

//Declara็ใo das Variแveis
	Local bSayChvNFe := {|| "Chave Nota Fiscal"}
	Local aSayChvNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}
	Local aGetChvNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}

//Botใo
	Local aBtn02     := {aSizeDlg[1]+35,   aSizeDlg[2] + (nTamCpo * 7)  ,  nTamCpo-05, 012}

	Local aCBoxTipDoc := {}//Tipo Documento
	Local aCBoxTipXml := {}//Tipo XML
	Local aCBoxComCCe := {}//Com Carta de Corre็ใo
	Local aCBoxStatus := {}//Status

//Op็๕es da Pergunta
	aAdd(aCBoxTipDoc,"T=Todos Documentos")
	aAdd(aCBoxTipDoc,"N=Normal"          )
	aAdd(aCBoxTipDoc,"D=Devolucao"       )
	aAdd(aCBoxTipDoc,"B=Beneficiamento"  )
	aAdd(aCBoxTipDoc,"C=Complementar"    )
	aAdd(aCBoxTipDoc,"I=ICMS"     )  //  28/01/2018 - Adicionado tratamento para COMPLEMENTO DE ICMS
	aAdd(aCBoxTipDoc,"A=Ajuste"          )
	aAdd(aCBoxTipDoc,"U=Anulacao"        )
	aAdd(aCBoxTipDoc,"S=Substituicao"    )
	aAdd(aCBoxTipDoc,"X=Indefinido"      )


//Op็๕es da Pergunta
	aAdd(aCBoxTipXml,"T=Todos Tipos"     )
	aAdd(aCBoxTipXml,"1=NF-e"            )
	aAdd(aCBoxTipXml,"2=CT-e"            )
	aAdd(aCBoxTipXml,"3=XML Pedente"     )

//Op็๕es da Pergunta
	aAdd(aCBoxComCCe,"T=Todos"           )
	aAdd(aCBoxComCCe,"S=Sim"             )
	aAdd(aCBoxComCCe,"N=Nao"             )

//Op็๕es da Pergunta
	aAdd(aCBoxStatus,"T=Todos Status"                           )
	aAdd(aCBoxStatus,"0=XML pendente de recebimento"            )
	aAdd(aCBoxStatus,"1=XML recebido com sucesso"               )
	aAdd(aCBoxStatus,"2=XML recebido com erro"                  )
	aAdd(aCBoxStatus,"3=XML jแ incluido no sistema"             )
	aAdd(aCBoxStatus,"4=XML gerou erro na pre-nota"             )
	aAdd(aCBoxStatus,"5=XML gerou pre-nota depois foi excluํda" )
	aAdd(aCBoxStatus,"6=XML de cancelamento recebido"           )
	aAdd(aCBoxStatus,"7=XML bloqueado pelo validador"           )

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

	oSayTipDoc  := TSay():New( aSayTipDoc[1] ,aSayTipDoc[2] ,bSayTipDoc ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayTipDoc[3] ,aSayTipDoc[4])
	oGetTipDoc  := TComboBox():New( aGetTipDoc[1],aGetTipDoc[2],{|u| IIf(Pcount()>0,cGetTipDoc:=u,cGetTipDoc)},aCBoxTipDoc,aGetTipDoc[3],aGetTipDoc[3],oDialg,,,,,,.T.)

	oSayStatus  := TSay():New( aSayStatus[1] ,aSayStatus[2] ,bSayStatus ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayStatus[3] ,aSayStatus[4])
	oGetStatus  := TComboBox():New( aGetStatus[1],aGetStatus[2],{|u| IIf(Pcount()>0,cGetStatus:=u,cGetStatus)},aCBoxStatus,aGetStatus[3],aGetStatus[3],oDialg,,,,,,.T.)

	oSayComCCe  := TSay():New( aSayComCCe[1] ,aSayComCCe[2] ,bSayComCCe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayComCCe[3] ,aSayComCCe[4])
	oGetComCCe  := TComboBox():New( aGetComCCe[1],aGetComCCe[2],{|u| IIf(Pcount()>0,cGetComCCe:=u,cGetComCCe)},aCBoxComCCe,aGetComCCe[3],aGetComCCe[3],oDialg,,,,,,.T.)

	oSayCnpjEm  := TSay():New( aSayCnpjEm[1] ,aSayCnpjEm[2] ,bSayCnpjEm ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayCnpjEm[3] ,aSayCnpjEm[4])
	oGetCnpjEm  := TGet():New( aGetCnpjEm[1] ,aGetCnpjEm[2] ,{|u| IIf(Pcount()>0,cGetCnpjEm:=u ,cGetCnpjEm )},oDialg,aGetCnpjEm[3] ,aGetCnpjEm[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

	oSayNomeEm  := TSay():New( aSayNomeEm[1] ,aSayNomeEm[2] ,bSayNomeEm ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayNomeEm[3] ,aSayNomeEm[4])
	oGetNomeEm  := TGet():New( aGetNomeEm[1] ,aGetNomeEm[2] ,{|u| IIf(Pcount()>0,cGetNomeEm:=u ,cGetNomeEm )},oDialg,aGetNomeEm[3] ,aGetNomeEm[4] ,'@!'  ,/*cValid*/{|| iIf(Empty(cGetNomeEm),.T.,fGerPesqsa(cOper)) } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//----------------------------------------------------------------------------------------------
	oSayTipXml  := TSay():New( aSayTipXml[1] ,aSayTipXml[2] ,bSayTipXml ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayTipXml[3] ,aSayTipXml[4])
	oGetTipXml  := TComboBox():New( aGetTipXml[1],aGetTipXml[2],{|u| IIf(Pcount()>0,cGetTipXml:=u,cGetTipXml)},aCBoxTipXml,aGetTipXml[3],aGetTipXml[3],oDialg,,,,,,.T.)

	oSayDtEmis  := TSay():New( aSayDtEmis[1] ,aSayDtEmis[2] ,bSayDtEmis ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayDtEmis[3] ,aSayDtEmis[4])
	oGetDtEmis  := TGet():New( aGetDtEmis[1] ,aGetDtEmis[2] ,{|u| IIf(Pcount()>0,dGetDtEmis:=u ,dGetDtEmis )},oDialg,aGetDtEmis[3] ,aGetDtEmis[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

	oSaySerNFe  := TSay():New( aSaySerNFe[1] ,aSaySerNFe[2] ,bSaySerNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSaySerNFe[3] ,aSaySerNFe[4])
	oGetSerNFe  := TGet():New( aGetSerNFe[1] ,aGetSerNFe[2] ,{|u| IIf(Pcount()>0,cGetSerNFe:=u ,cGetSerNFe )},oDialg,aGetSerNFe[3] ,aGetSerNFe[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

	oSayNumNFe  := TSay():New( aSayNumNFe[1] ,aSayNumNFe[2] ,bSayNumNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayNumNFe[3] ,aSayNumNFe[4])
	oGetNumNFe  := TGet():New( aGetNumNFe[1] ,aGetNumNFe[2] ,{|u| IIf(Pcount()>0,cGetNumNFe:=u ,cGetNumNFe )},oDialg,aGetNumNFe[3] ,aGetNumNFe[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

	oSayChvNFe  := TSay():New( aSayChvNFe[1] ,aSayChvNFe[2] ,bSayChvNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayChvNFe[3] ,aSayChvNFe[4])
	oGetChvNFe  := TGet():New( aGetChvNFe[1] ,aGetChvNFe[2] ,{|u| IIf(Pcount()>0,cGetChvNFe:=u ,cGetChvNFe )},oDialg,aGetChvNFe[3] ,aGetChvNFe[4] ,'@!'  ,/*cValid*/{|| fGerPesqsa(cOper) } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//----------------------------------------------------------------------------------------------

//Bot๕es
	@ aBtn01[1],aBtn01[2] Button "Pesquisar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fGerPesqsa(cOper)
	@ aBtn02[1],aBtn02[2] Button "Limpar"    Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fGerLimpar()

	// MAURESI
	if _lUsrRec
		oGetChvNFe:SetFocus()
	else
		oGetNumNFe:SetFocus()
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerPesqsaบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerPesqsa(cOper)

	MsAguarde({|| fGerPrcPsq(cOper) },"Processando...","Aguarde, pesquisando ... ")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerPrcPsqบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerPrcPsq(cOper)

//aIndexCad
	Local cTab1        := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

	Local cCpo   := " "+cAls1+"_STATUS , R_E_C_N_O_ AS AA_RECNO "
	Local cQry   := ""
	Local cQbra  := Chr(13)+Chr(10)

	For x:=1 To Len(aHeadCpos)
		If !(aHeadCpos[x] $ cCpo)
			cCpo += IIf(Empty(cCpo),"",",") + aHeadCpos[x] + " "
		EndIf
	Next

	cQry += cQbra+" SELECT " + cCpo
	cQry += cQbra+" FROM "+RetSqlName(cTab1)+" "+cTab1+"(NOLOCK)
	cQry += cQbra+" WHERE "+cTab1+".D_E_L_E_T_ = ''
//----------------------------------------------------------
	If cGetTipXml != "T"
		cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TIPXML = '"+AllTrim(cGetTipXml)+"' "
	EndIf
//----------------------------------------------------------
	If cGetStatus != "T"
		cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_STATUS = '"+AllTrim(cGetStatus)+"' "
	EndIf
//----------------------------------------------------------
	If cGetComCCe != "T"
		cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TEMCCE = '"+AllTrim(cGetComCCe)+"' "
	EndIf
//----------------------------------------------------------
	If !Empty(cGetCnpjEm)
		cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_DECNPJ) LIKE '%"+AllTrim(cGetCnpjEm)+"%' "
	EndIf
//----------------------------------------------------------
	If !Empty(cGetNomeEm)
		cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_DENOME) LIKE '%"+AllTrim(cGetNomeEm)+"%' "
	EndIf
//----------------------------------------------------------
	If cGetTipDoc != "T"
		cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TIPDOC = '"+AllTrim(cGetTipDoc)+"' "
	EndIf
//----------------------------------------------------------
	If !Empty(dGetDtEmis)
		cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_DTEMIS >= '"+DtoS(dGetDtEmis)+"' "
	EndIf
//----------------------------------------------------------
	If !Empty(cGetSerNFe)
		cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_SERIE) LIKE '%"+AllTrim(cGetSerNFe)+"%' "
	EndIf
//----------------------------------------------------------
	If !Empty(cGetNumNFe)
		cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_DOC) LIKE '%"+AllTrim(cGetNumNFe)+"%' "
	EndIf
//----------------------------------------------------------
	If !Empty(cGetChvNFe)
		cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_CHVNFE) LIKE '%"+AllTrim(cGetChvNFe)+"%' "
	EndIf
//----------------------------------------------------------

	// FILTRA SOMENTE XML DA FILIAL CORRENTE  // MAURESI - 16/02/2022
	If cFilAnt == "01"   // MATRIZ - SP
		cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_TOCNPJ) = '54821137000136' "
	ElseIf cFilAnt == '02'  //FILIAL - MG
		cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_TOCNPJ) = '54821137000217' "
	Endif

//----------------------------------------------------------
	cQry += cQbra+" ORDER BY "+cAls1+"_DTEMIS, "+cAls1+"_DECNPJ, "+cAls1+"_DOC"
//----------------------------------------------------------

//Fecha Alias caso encontre
	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	EndIf

//Cria alias temporario
	TcQuery cQry New Alias "QRY"

//Trata campos Data
	For x:=1 To Len(aHeadCpos)
		If fX3Ret(aHeadCpos[x],"X3_TIPO") == "D"
			TcSetField("QRY",aHeadCpos[x],"D",8,0)
		EndIf
	Next x

//Limpa GetDados 01
	oAAGetDad:aCols := {}
	oAAGetDad:oBrowse:Refresh()

//Carrega GetDados 01 com nova pesquisa
	fGerCargGD()

//Fecha Alias 
	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	EndIf

//QRY->(dbCloseArea())


//Zera variavel que controla ordena็ใo
	aOrdHead := {}

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerCargGDบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerCargGD()

	Local cCmdTemp := ""
	Local nPosTemp := 0
	Local nAAFLAG := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])=="AA_FLAG"  })
	Local nPosStts := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])=="AA_STATUS"})

//Carrega aCols com base no resultado da query
	QRY->(DbGoTop())
	While QRY->(!Eof())

		//Cria uma linha no aCols
		aAdd(oAAGetDad:aCols,Array(Len(oAAGetDad:aHeader)+1))
		nLin := Len(oAAGetDad:aCols)

		//Alimenta a linha do aCols vazia
		oAAGetDad:aCols[nLin, nAAFLAG] := "LBTIK"

		//Tratando legenda do status
		For y:=1 To Len(aHdStatus)
			cCmdTemp := AllTrim(aHdStatus[y][1])
			cCmdTemp := "QRY->("+cCmdTemp+")"
			If &(cCmdTemp)
				oAAGetDad:aCols[nLin, nPosStts] := aHdStatus[y][2]
				y := Len(aHdStatus)
			EndIf
		Next y

		//Carregando campos que serใo visualizados no GD
		For y:=1 To Len(aHeadCpos)
			nPosTemp := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==aHeadCpos[y]})
			oAAGetDad:aCols[nLin, nPosTemp ] := &("QRY->"+aHeadCpos[y])
		Next y

		//Adiciona Coluna Recno
		nPosTemp := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])=="AA_RECNO"})
		oAAGetDad:aCols[nLin, nPosTemp ] := QRY->AA_RECNO

		oAAGetDad:aCols[nLin, Len(oAAGetDad:aHeader)+1] := .F.

		QRY->(DbSkip())
	EndDo

//Carrega aCols com uma linha vazia por nใo teve resultado na query
	QRY->(DbGoTop())
	If QRY->(Eof())
		//Cria uma linha no aCols
		aAdd(oAAGetDad:aCols,Array(Len(oAAGetDad:aHeader)+1))
		nLin := Len(oAAGetDad:aCols)

		//Alimenta a linha do aCols vazia
		oAAGetDad:aCols[nLin, nAAFLAG] := "LBNO"

		oAAGetDad:aCols[nLin, nPosStts] := "ENABLE"

		For y:=1 To Len(aHeadCpos)
			nPosTemp := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])==aHeadCpos[y]})
			oAAGetDad:aCols[nLin, nPosTemp ] := CriaVar(aHeadCpos[y],.F.)
		Next y

		oAAGetDad:aCols[nLin, Len(oAAGetDad:aHeader)+1] := .F.
	EndIf

//Atualiza tela
	oAAGetDad:oBrowse:nAt := 1
	oAAGetDad:oBrowse:Refresh()
	oAAGetDad:oBrowse:SetFocus()

// Adicionado tratamento em 22/12/2020 para nใo gerar sozinho quando encontrar s๓ 1 registro na tela.
// Chamado 017711 - mauresi
	if !lCliDMX
		If Len(oAAGetDad:aCols) == 1
			fGerPrcImp()
			If Type("oDialg") == 'O'
				oDialg:End()
			EndIf
		EndIf
	Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfGerLimparบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGerLimpar()

	Local cTab1        := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

//----------------------------------------------------------
	cGetTipDoc := "T"
	oGetTipDoc:Refresh()
//----------------------------------------------------------
	cGetTipXml := "T"
	oGetTipXml:Refresh()
//----------------------------------------------------------
	dGetDtEmis := StoD("")
	oGetDtEmis:Refresh()
//----------------------------------------------------------
	cGetChvNFe := Space(fX3Ret(cAls1+"_CHVNFE","X3_TAMANHO"))
	oGetChvNFe:Refresh()
//----------------------------------------------------------
	cGetSerNFe := Space(fX3Ret(cAls1+"_SERIE","X3_TAMANHO"))
	oGetSerNFe:Refresh()
//----------------------------------------------------------
	cGetNumNFe := Space(fX3Ret(cAls1+"_DOC","X3_TAMANHO"))
	oGetNumNFe:Refresh()
//----------------------------------------------------------
	cGetCnpjEm := Space(fX3Ret(cAls1+"_DECNPJ","X3_TAMANHO"))
	oGetCnpjEm:Refresh()
//----------------------------------------------------------
	cGetNomeEm := Space(fX3Ret(cAls1+"_DENOME","X3_TAMANHO"))
	oGetNomeEm:Refresh()
//----------------------------------------------------------
	cGetComCCe := "T"
	oGetComCCe:Refresh()
//----------------------------------------------------------
	cGetStatus := "T"
	oGetStatus:Refresh()
//----------------------------------------------------------
	oAAGetDad:aCols := {}
	oAAGetDad:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNInc    บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GXNInc()

	Local cDirXml   := AllTrim(SuperGetMv("MX_MR_DXML",,"\data\GestorXml\"))
	Local cTipo 	:= "Arquivos XML (*.XML)       | *.XML  |"
	Local cTitulo	:= "Diแlogo de Sele็ใo de Arquivos"
	Local cDirIni	:= ""
	Local cDrive	:= ""
	Local cDir		:= ""
	Local cFile		:= ""
	Local cExten	:= ""
	Local cGetFile	:= cGetFile(cTipo,cTitulo,,cDirIni,.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE)//GETF_ONLYSERVER+GETF_RETDIRECTORY+GETF_LOCALFLOPPY
	Local cNovoDir  := ""

// Separa os componentes
	SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten )

	If !Empty(cFile)
		If !File(cGetFile)
			Alert("Erro ao localizar arquivo de origem!")
			Return
		EndIf

		//Cria pasta caso nใo exita ainda
		MontaDir(cDirXml+"pendente\")
		MontaDir(cDirXml+"processado\")
		MontaDir(cDirXml+"recusado\")

		//Local Destino Arquivo
		cNovoDir := cDirXml+"pendente\"+cFile+cExten

		If File(cNovoDir)
			Alert("Erro ao tentar anexar arquivo, XML jแ estแ na fila para processamento!")
			Return
		EndIf

		Processa( {|| fCopiaXML(cGetFile,cNovoDir)    },"Copiando XML para o server..." )
		Processa( {|| fTrataXML()                     },"Tratando XML copiado..." )

		MsgInfo("Arquivo anexado com sucesso!")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfCopiaXML บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCopiaXML(cFileOri,cFileDest)
//Copia arquivo pra servidor
	COPY File &cFileOri TO &cFileDest
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNHis    บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GXNHis()

//Variaveis do tamanho a tela
	Local aDlgTela     := {000,000,307,705}

//Divis๕es dentro da tela (Li,Ci,Lf,Cf)
	Local aDlgCabc     := {005,005,125,350}
	Local aDlgRodp     := {130,005,150,350}

	Local cTab2   := AllTrim(GetMV("MX_MRALS02"))
	Local cAls2   := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)

	Local oDialgH
	Local cStrCad    := AllTrim(GetMV("MX_MRALS02"))
	Local cTitCad    := "Hist๓rico"
	Local cPrtCad    := cTitCad+" ["+cStrCad+"]"

// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialgH Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

	fHisCabec(oDialgH,aDlgCabc)
	fHisRodap(oDialgH,aDlgRodp)

	Activate MsDialog oDialgH Centered

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfHisCabec บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fHisCabec(oDialg,aSizeDlg)

	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cTab2   := AllTrim(GetMV("MX_MRALS02"))
	Local cAls2   := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := Nil                                             // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHead          := {}                                              // Array do aHeader
	Local aCols          := {}                                              // Array do aCols
	Local aHeadCpos      := {}
	Local oGdItem02      := Nil

//Campos que serใo apresentados no MsNewGetDados
	aAdd(aHeadCpos,cAls2+"_LOGDT"  )
	aAdd(aHeadCpos,cAls2+"_LOGHR"  )
	aAdd(aHeadCpos,cAls2+"_LOGUSR" )
	aAdd(aHeadCpos,cAls2+"_MSG"    )
	aAdd(aHeadCpos,cAls2+"_CHVNFE" )
	aAdd(aHeadCpos,cAls2+"_PROTOC" )

	For x:=1 To Len(aHeadCpos)
		cX3_Descr := fX3Ret(aHeadCpos[x],"X3_TITULO" )
		cX3_Campo := fX3Ret(aHeadCpos[x],"X3_CAMPO"  )
		cX3_Tipo  := fX3Ret(aHeadCpos[x],"X3_TIPO"   )
		cX3_Pictu := fX3Ret(aHeadCpos[x],"X3_PICTURE")
		nX3_Tam01 := fX3Ret(aHeadCpos[x],"X3_TAMANHO")
		nX3_Tam02 := fX3Ret(aHeadCpos[x],"X3_DECIMAL")

		//          X3_TITULO, X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO , X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
		aAdd(aHead,{cX3_Descr,cX3_Campo      ,cX3_Pictu            ,   nX3_Tam01,  nX3_Tam02, ""      , "€€€€€€€€€€€€€€", cX3_Tipo, ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	Next x

	(cTab2)->(DbSetOrder(3))
	If (cTab2)->(DbSeek(xFilial(cTab2)+(cTab1)->&(cAls1+"_CHVNFE")))
		While (cTab2)->(!Eof()) .And. (cTab2)->&(cAls2+"_CHVNFE") == (cTab1)->&(cAls1+"_CHVNFE")

			//Cria uma linha no aCols
			aAdd(aCols,Array(Len(aHead)+1))
			nLin := Len(aCols)
			//Alimenta a linha do aCols vazia
			For y:=1 To Len(aHeadCpos)
				aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])==aHeadCpos[y]}) ] := (cTab2)->&(aHeadCpos[y])
			Next y
			aCols[nLin, Len(aHead)+1] := .F.

			(cTab2)->(DbSkip())
		End
	Else
		//Cria uma linha no aCols
		aAdd(aCols,Array(Len(aHead)+1))
		nLin := Len(aCols)
		//Alimenta a linha do aCols vazia
		For y:=1 To Len(aHeadCpos)
			aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])==aHeadCpos[y]}) ] := CriaVar(aHeadCpos[y],.F.)
		Next y
		aCols[nLin, Len(aHead)+1] := .F.
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณOrdena Historico em ordem Descrescente (Data/Hora). Adicionado em 23/10/15  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCols := aSort(aCols,,,{|x,y| dtoc(x[1])+x[2] > dtoc(y[1])+y[2] })


	oGdItem02:=MsNewGetDados():New(aSizeDlg[1]+05,aSizeDlg[2]+05,aSizeDlg[3]-05,aSizeDlg[4]-05,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfX3Ret    บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fX3Ret(cCampo,cRet)

	Default cCampo := ""
	Default cRet   := ""

	SX3->(DbSetOrder(2))
	If SX3->(MsSeek(cCampo))
		cRet := &("SX3->"+cRet)
	EndIf

	If ValType(cRet) == "C"
		cRet := AllTrim(cRet)
	EndIf

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfHisRodap บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fHisRodap(oDialg,aSizeDlg)

	Local nQtdCpo := 5
	Local nTamBtn := (aSizeDlg[4] / nQtdCpo)
	Local aBtn01  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 4)  ,  nTamBtn-10, 012}

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Bot๕es
	@ aBtn01[1],aBtn01[2] Button "Sair" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action oDialg:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfVerifInicบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fVerifInic()

	Private cMRTabNovo := "/"
//Verifica se parametros jแ foram criados
//Verifica o conte๚do dos parametros
//Cria parametro caso necessแrio
	cMRAlias01 := fPesqTab("MX_MRALS01")
	cMRTabNovo += cMRAlias01+"/"

	cMRAlias02 := fPesqTab("MX_MRALS02")
	cMRTabNovo += cMRAlias02+"/"

	cMRAlias03 := fPesqTab("MX_MRALS03")
	cMRTabNovo += cMRAlias03+"/"

	cMRAlias04 := fPesqTab("MX_MRALS04")
	cMRTabNovo += cMRAlias04+"/"


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfPesqTab  บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPesqTab(cVar)

	Local cRet     := ""
	Local aAreaSX6 := SX6->(GetArea())

//Verifica se parametro existe e busca conteudo do mesmo
	SX6->(DbSetOrder(1))
	If SX6->(DbSeek(xFilial("SX6")+cVar))
		cRet := GetMv(cVar)
	EndIf

//Valida Conteudo do Parametro
	If Empty(cRet)
		//Procura tabela disponivel
		cRet := fNewSX2()

		//Cria parametro
		If SX6->(DbSeek(xFilial("SX6")+cVar))
			RecLock("SX6",.F.)
		Else
			RecLock("SX6",.T.)
		EndIf
		SX6->X6_FIL     := ""
		SX6->X6_VAR     := cVar
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "TABELA UTILIZADA PELO GESTOR XML"
		SX6->X6_CONTEUD := cRet
		SX6->X6_PROPRI  := "U"
		SX6->(MsUnLock())
	EndIf

	RestArea(aAreaSX6)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfNewSX2   บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fNewSX2()

	Local cRet     := ""
	Local lLoop    := .T.
	Local cNewTab  := "ZZ0"
	Local aAreaSX2 := SX2->(GetArea())

	SX2->(DbSetOrder(1))
	While lLoop
		If SX2->(DbSeek(cNewTab)) .Or. cNewTab $ cMRTabNovo
			cNewTab := Soma1(cNewTab)
			Do Case
			Case SubStr(cNewTab,1,2) != "SZ" .And. SubStr(cNewTab,1,1) == "S"
				cNewTab := "ZZ0"
			Case SubStr(cNewTab,1,2) != "ZZ" .And. SubStr(cNewTab,1,1) == "Z"
				cNewTab := "P00"
			EndCase
		Else
			cRet  := cNewTab
			lLoop := .F.
		EndIf
	End

	RestArea(aAreaSX2)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfCriaSXs  บAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCriaSXs()

	Local aAreaSX2 := SX2->(GetArea())
	Local aAreaSX3 := SX3->(GetArea())
	Local aAreaSIX := SIX->(GetArea())

	fCriaSX2()
	fCriaSX3()
	fCriaSIX()

	fCriaCust()

	RestArea(aAreaSX2)
	RestArea(aAreaSX3)
	RestArea(aAreaSIX)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCriaSX2()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fCriaSX2()
	*-----------------------------------------------------------*

	Local cPath  := ""
	Local cNome  := ""
	Local aEstrut:= {}
	Local aSX2   := {}
	Local i      := 0
	Local j      := 0

	aEstrut := {"X2_CHAVE","X2_PATH"   ,"X2_ARQUIVO","X2_NOME"                     ,"X2_NOMESPA"                  ,"X2_NOMEENG"                  ,"X2_DELET","X2_MODO","X2_MODOUN","X2_MODOEMP","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO","X2_MODULO"}
	Aadd(aSX2, {cMRAlias01,""          ,""          ,"Gestor XML - Principal"      ,"Gestor XML - Principal"      ,"Gestor XML - Principal"      ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"S"      ,""        ,02       })
	Aadd(aSX2, {cMRAlias02,""          ,""          ,"Gestor XML - Historico"      ,"Gestor XML - Historico"      ,"Gestor XML - Historico"      ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"S"      ,""        ,02       })
	Aadd(aSX2, {cMRAlias03,""          ,""          ,"Gestor XML - Amarracao"      ,"Gestor XML - Amarracao"      ,"Gestor XML - Amarracao"      ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"S"      ,""        ,02       })
	Aadd(aSX2, {cMRAlias04,""          ,""          ,"Gestor XML - TES Inteligente","Gestor XML - TES Inteligente","Gestor XML - TES Inteligente",0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"S"      ,""        ,02       })

	dbSelectArea("SX2")
	dbSetOrder(1)
//dbSeek("SF1")

	cPath := SX2->X2_PATH
	cNome := Substr(SX2->X2_ARQUIVO,4,5)

	For i:= 1 To Len(aSX2)
		If !Empty(aSX2[i][1])
			If !dbSeek(aSX2[i,1])
				RecLock("SX2",.T.)
				For j:=1 To Len(aSX2[i])
					If FieldPos(aEstrut[j]) > 0
						FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
					EndIf
				Next j
				SX2->X2_PATH    := cPath
				SX2->X2_ARQUIVO := aSX2[i,1]+cNome
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfCriaSX3  บAutor  ณFelipe Aurelio      บ Data ณ  17/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  26/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCriaSX3()

	Local aSX3       := {}
	Local cAls       := ""
	Local aEstrut    := {}
	Local aCampos    := {}
	Local i          := 0
	Local j          := 0
	Local x          := 0
	Local lCriaPerg  := .F.
	Local cTipDoc    := "N=Normal;D=Devolucao;B=Beneficiamento;C=Complementar;I=ICMS;A=Ajuste;U=Anulacao;S=Substituicao;X=Indefinido"
	Local cTipXml    := "1=NF-e;2=CT-e;3=XML Pedente"

//CFOP de Entrada (inicia por 1, 2, 3) para NF-e de Saํda (tpNF=1)
//CFOP de Saํda (inicia por 5, 6, 7) para NF-e de Entrada (tpNF=0)
//CFOP de Opera็ใo com Exterior (inicia por 3 ou 7) e UF destinatแrio = EX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTABELA PRINCIPALณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCampos := {}
	cAls := AllTrim(cMRAlias01)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP                                       ,                                         ,                                          ,VALID                    ,WHEN                 ,RELACAO
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP
	aAdd(aCampos,{cAls+"_FILIAL" ,"C"      ,2            ,0            ,"Filial      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_STATUS" ,"C"      ,1            ,0            ,"Status      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_TIPDOC" ,"C"      ,1            ,0            ,"Tipo Doc.   ","@!"                  ,   cTipDoc                        ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_TIPXML" ,"C"      ,1            ,0            ,"Tipo XML    ","@!"                  ,   cTipXml                        ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_TEMCCE" ,"C"      ,1            ,0            ,"Tem CCe     ","@!"                  ,   "S=Sim;N=Nao"                  ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_CHVNFE" ,"C"      ,44           ,0            ,"Chave       ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_SERIE"  ,"C"      ,3            ,0            ,"Serie       ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_DOC"    ,"C"      ,9            ,0            ,"Nota Fiscal ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_DTEMIS" ,"D"      ,8            ,0            ,"Dt Emissao  ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_HREMIS" ,"C"      ,8            ,0            ,"Hr Emissao  ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_DEUF"   ,"C"      ,02           ,0            ,"UF          ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_DECIDAD","C"      ,30           ,0            ,"Cidade Emit.","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_DECNPJ" ,"C"      ,14           ,0            ,"CNPJ Emit.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_DENOME" ,"C"      ,50           ,0            ,"Nome Emit.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_TOCNPJ" ,"C"      ,14           ,0            ,"CNPJ Dest.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_TONOME" ,"C"      ,50           ,0            ,"Nome Dest.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_VLRTOT" ,"N"      ,16           ,4            ,"Valor Total ","@E 999,999,999.9999" ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_ARQUIV" ,"C"      ,100          ,0            ,"Arquivo     ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_MXML"   ,"M"      ,10           ,0            ,"XML     "    ,"@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_MXML2"  ,"M"      ,10           ,0            ,"XML Contin." ,"@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_LOGDT"  ,"D"      ,8            ,0            ,"LOG Data    ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_LOGHR"  ,"C"      ,8            ,0            ,"LOG Hora    ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})
	aAdd(aCampos,{cAls+"_LOGUSR" ,"C"      ,30           ,0            ,"LOG Usuario ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""					})

//Conforme array acima, monta array abaixo
	aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
	For x:=1 To Len(aCampos)
		If aCampos[x][1] $ cAls+"_FILIAL"+"/"+cAls+"_STATUS"
			Aadd(aSX3,{	cMRAlias01     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€€   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	cMRAlias01     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		EndIF
	Next


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTABELA DE HISTORICOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCampos := {}
	cAls := AllTrim(cMRAlias02)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP
	aAdd(aCampos,{cAls+"_FILIAL" ,"C"      ,2            ,0            ,"Filial      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_DTEMIS" ,"D"      ,8            ,0            ,"Dt Emissao  ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_DECNPJ" ,"C"      ,14           ,0            ,"CNPJ Emit.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_CHVNFE" ,"C"      ,44           ,0            ,"Chave       ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_PROTOC" ,"C"      ,30           ,0            ,"Protocolo   ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_MSG"    ,"C"      ,200          ,0            ,"Mensagem    ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_ARQUIV" ,"C"      ,100          ,0            ,"Arquivo     ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_MXML"   ,"M"      ,10           ,0            ,"XML         ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_LOGDT"  ,"D"      ,8            ,0            ,"LOG Data    ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_LOGHR"  ,"C"      ,8            ,0            ,"LOG Hora    ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_LOGUSR" ,"C"      ,30           ,0            ,"LOG Usuario ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})

//Conforme array acima, monta array abaixo
	aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
	For x:=1 To Len(aCampos)
		If aCampos[x][1] $ cAls+"_FILIAL"
			Aadd(aSX3,{	cMRAlias02     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€€   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	cMRAlias02     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		EndIF
	Next


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTABELA DE AMARRACAO DE PC ณ 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCampos := {}
	cAls := AllTrim(cMRAlias03)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP
	aAdd(aCampos,{cAls+"_FILIAL" ,"C"      ,2            ,0            ,"Filial      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_CHVNFE" ,"C"      ,44           ,0            ,"Chave       ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_ITEMXM" ,"C"      ,04           ,0            ,"Item XML    ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_SEQ"    ,"C"      ,02           ,0            ,"Sequencia   ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_PEDIDO" ,"C"      ,06           ,0            ,"PC          ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_ITEMPC" ,"C"      ,04           ,0            ,"Item PC     ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{cAls+"_QTD"    ,"N"      ,12           ,4            ,"Quantidade  ","@E 99,999,999,999.99",   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})

//Conforme array acima, monta array abaixo
	aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
	For x:=1 To Len(aCampos)
		If aCampos[x][1] $ cAls+"_FILIAL"
			Aadd(aSX3,{	cMRAlias03     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€€   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	cMRAlias03     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		EndIF
	Next


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTABELA DE TES INTELIGENTE    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCampos := {}
	cAls := AllTrim(cMRAlias04)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP
	aAdd(aCampos,{cAls+"_FILIAL" ,"C"      ,2            ,0            ,"Filial      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_TIPO"   ,"C"      ,2            ,0            ,"Tp. Operacao","@!"                  ,   ""                             ,cMRSX5Oper    ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })   // Consulta Generica Padrao de OPERACAO DE ENTRADA
	aAdd(aCampos,{cAls+"_FORNEC" ,"C"      ,6            ,0            ,"Fornecedor  ","@!"                  ,   ""                             ,"SA2"         ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_LOJAFO" ,"C"      ,2            ,0            ,"Loja Fornece","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_CODPRO" ,"C"      ,15           ,0            ,"Cod.Produto ","@!"                  ,   ""                             ,"SB1"         ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_TES1"   ,"C"      ,3            ,0            ,"TES 1       ","@9"                  ,   ""                             ,"SF4"         ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_VALID1" ,"C"      ,1            ,0            ,"Validada ?  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_NF1"    ,"C"      ,6            ,0            ,"Num. NF     ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_IT1"    ,"C"      ,2            ,0            ,"Item NF     ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_ID1"    ,"C"      ,6            ,0            ,"ID Validacao","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_NOME1"  ,"C"      ,100          ,0            ,"Nome Valida ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_DT1"    ,"D"      ,8            ,0            ,"Dt Validacao","@D"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_CTE"    ,"C"      ,1            ,0            ,"Operacao CTE","@!"                  ,   "S=Sim;N=Nao"                  ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_CFOP1"  ,"C"      ,50           ,0            ,"CFO CTE TES1","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_TES2"   ,"C"      ,3            ,0            ,"TES 2       ","@9"                  ,   ""                             ,"SF4"         ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_CFOP2"  ,"C"      ,50           ,0            ,"CFO CTE TES2","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
	aAdd(aCampos,{cAls+"_MSBLQL" ,"C"      ,1            ,0            ,"Bloqueado   ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })

//Conforme array acima, monta array abaixo
	aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
	For x:=1 To Len(aCampos)
		If aCampos[x][1] $ cAls+"_FILIAL"
			Aadd(aSX3,{	cMRAlias04     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€€   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	cMRAlias04     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		EndIF
	Next



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTABELA AMARRACAO FORNECEDOR X PRODUTO (SA5)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCampos := {}
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP
	aAdd(aCampos,{"A5_XXUMXML" ,"C"      ,2            ,0            ,"UM XML      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{"A5_XXFCNUM" ,"N"      ,10           ,4            ,"Fat.Conv.XML","@E 9,999.9999"       ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{"A5_XXFCTIP" ,"C"      ,1            ,0            ,"Tp. Conv.XML","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})

//Conforme array acima, monta array abaixo
	aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}

// Identifica Ultimo Numero de Ordem usada na Tabela SA5
	SX3->(dbSetOrder(1))
	SX3->(dbGotop())
	SX3->(dbSeek("SA5"))
	_nX3Ordem:=0
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SA5"
		_nX3Ordem++
		SX3->(DbSkip())
	End

	For x:=1 To Len(aCampos)
		_cX3Ordem	:= StrZero(x+_nX3Ordem,2)
		If aCampos[x][1] $ "A5_FILIAL"
			Aadd(aSX3,{	"SA5"     ,_cX3Ordem    ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€€   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","          ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	"SA5"     ,_cX3Ordem    ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","          ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		EndIF
	Next


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTABELA AMARRACAO  CLIENTE X PRODUTO (SA7)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCampos := {}
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP

	aAdd(aCampos,{"A7_XXUMXML" ,"C"      ,2            ,0            ,"UM XML      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{"A7_XXFCNUM" ,"N"      ,10           ,4            ,"Fat.Conv.XML","@E 9,999.9999"       ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})
	aAdd(aCampos,{"A7_XXFCTIP" ,"C"      ,1            ,0            ,"Tp. Conv.XML","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})

//Conforme array acima, monta array abaixo
	aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}

// Identifica Ultimo Numero de Ordem usada na Tabela SA7
	SX3->(dbSetOrder(1))
	SX3->(dbGotop())
	SX3->(dbSeek("SA7"))
	_nX3Ordem:=0
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SA7"
		_nX3Ordem++
		SX3->(DbSkip())
	End

	For x:=1 To Len(aCampos)
		_cX3Ordem	:= StrZero(x+_nX3Ordem,2)
		If aCampos[x][1] $ "A7_FILIAL"
			Aadd(aSX3,{	"SA7"     ,_cX3Ordem    ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€€   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","          ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	"SA7"     ,_cX3Ordem    ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","          ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		EndIF
	Next


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDOCUMENTO DE ENTRADA - CAMPO FLAG GESTOR ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCampos := {}
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP

	aAdd(aCampos,{"F1_XGESTOR" ,"C"      ,1            ,0            ,"Gestor XML  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""					})

//Conforme array acima, monta array abaixo
	aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}

// Identifica Ultimo Numero de Ordem usada na Tabela SF1
	SX3->(dbSetOrder(1))
	SX3->(dbGotop())
	SX3->(dbSeek("SF1"))
	_nX3Ordem:=0
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SF1"
		_nX3Ordem++
		SX3->(DbSkip())
	End

	For x:=1 To Len(aCampos)
		_cX3Ordem	:= StrZero(x+_nX3Ordem,2)
		If aCampos[x][1] $ "F1_FILIAL"
			Aadd(aSX3,{	"SF1"     ,_cX3Ordem    ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€€   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","          ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		Else
			Aadd(aSX3,{	"SF1"     ,_cX3Ordem    ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"€€€€€€€€€€€€€€    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","          ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
		EndIF
	Next




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava Campos na Tabela SX3ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(2)

	For i:= 1 To Len(aSX3)
		If !Empty(aSX3[i][1])
			If !dbSeek(aSX3[i,3])
				RecLock("SX3",.T.)
				For j:=1 To Len(aSX3[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
				lCriaPerg := .T.
			EndIf
		EndIf
	Next i

//Cria Help dos campos
	If lCriaPerg
		fHelpCpo(aCampos,1,9)
	EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCriaSIX()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: 10 de setembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fCriaSIX()
	*-----------------------------------------------------------*

	Local aSIX   := {}
	Local aEstrut:= {}
	Local cAls   := ""
	Local i      := 0
	Local j      := 0

	aEstrut := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}

//------------------- PRINCIPAL -------------------
	cAls := AllTrim(cMRAlias01)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

	aAdd(aSIX,{	cMRAlias01,"1",cAls+"_FILIAL+"+cAls+"_DECNPJ+"+cAls+"_DOC",;
		"CNPJ Emit. + Nota Fiscal",;
		"CNPJ Emit. + Nota Fiscal",;
		"CNPJ Emit. + Nota Fiscal",;
		"S","",""})

	aAdd(aSIX,{	cMRAlias01,"2",cAls+"_FILIAL+"+cAls+"_DOC+"+cAls+"_SERIE",;
		"Nota Fiscal + Serie",;
		"Nota Fiscal + Serie",;
		"Nota Fiscal + Serie",;
		"S","",""})

	aAdd(aSIX,{	cMRAlias01,"3",cAls+"_FILIAL+"+cAls+"_CHVNFE",;
		"Chave",;
		"Chave",;
		"Chave",;
		"S","",""})

	aAdd(aSIX,{	cMRAlias01,"4",cAls+"_FILIAL+DTOS("+cAls+"_DTEMIS)+"+cAls+"_DECNPJ",;
		"Dt Emissao + CNPJ Emit.",;
		"Dt Emissao + CNPJ Emit.",;
		"Dt Emissao + CNPJ Emit.",;
		"S","",""})

//------------------- HISTORICO -------------------
	cAls := AllTrim(cMRAlias02)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

	aAdd(aSIX,{	cMRAlias02,"1",cAls+"_FILIAL+"+cAls+"_DECNPJ",;
		"CNPJ Emit. ",;
		"CNPJ Emit. ",;
		"CNPJ Emit. ",;
		"S","",""})

	aAdd(aSIX,{	cMRAlias02,"2",cAls+"_FILIAL+"+cAls+"_PROTOC",;
		"Protocolo",;
		"Protocolo",;
		"Protocolo",;
		"S","",""})

	aAdd(aSIX,{	cMRAlias02,"3",cAls+"_FILIAL+"+cAls+"_CHVNFE",;
		"Chave",;
		"Chave",;
		"Chave",;
		"S","",""})

	aAdd(aSIX,{	cMRAlias02,"4",cAls+"_FILIAL+DTOS("+cAls+"_DTEMIS)+"+cAls+"_DECNPJ",;
		"Dt Emissao + CNPJ Emit.",;
		"Dt Emissao + CNPJ Emit.",;
		"Dt Emissao + CNPJ Emit.",;
		"S","",""})



//------------------- AMARRACAO  -------------------
	cAls := AllTrim(cMRAlias03)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

	aAdd(aSIX,{	cMRAlias03,"1",cAls+"_FILIAL+"+cAls+"_CHVNFE+"+cAls+"_ITEMXM+"+cAls+"_SEQ" ,;
		"Chave+Item XML+ Sequencia ",;
		"Chave+Item XML+ Sequencia ",;
		"Chave+Item XML+ Sequencia ",;
		"S","",""})

	aAdd(aSIX,{	cMRAlias03,"2",cAls+"_FILIAL+"+cAls+"_CHVNFE+"+cAls+"_PEDIDO+"+cAls+"_ITEMPC" ,;
		"Chave + Pedido Compra + Item PC",;
		"Chave + Pedido Compra + Item PC",;
		"Chave + Pedido Compra + Item PC",;
		"S","",""})


//------------------- TES INTELIGENTE  -------------------
	cAls := AllTrim(cMRAlias04)
	cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

	aAdd(aSIX,{	cMRAlias04,"1",cAls+"_FILIAL+"+cAls+"_CODPRO+"+cAls+"_FORNEC+"+cAls+"_LOJAFO+"+cAls+"_TIPO" ,;
		"Produto + Fornecedor + Loja + Operacao",;
		"Produto + Fornecedor + Loja + Operacao",;
		"Produto + Fornecedor + Loja + Operacao",;
		"S","",""})


	dbSelectArea("SIX")
	dbSetOrder(1)

	For i:= 1 To Len(aSIX)
		If !Empty(aSIX[i,1])
			If !dbSeek(aSIX[i,1]+aSIX[i,2])
				RecLock("SIX",.T.)
				For j:=1 To Len(aSIX[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i

Return



Static Function fCriaCust

	X31UPDTABLE("SF1")
	X31UPDTABLE("SA5")
	X31UPDTABLE("SA7")

	X31UPDTABLE(AllTrim(GetMV("MX_MRALS01")))
	X31UPDTABLE(AllTrim(GetMV("MX_MRALS02")))
	X31UPDTABLE(AllTrim(GetMV("MX_MRALS03")))
	X31UPDTABLE(AllTrim(GetMV("MX_MRALS04")))

	If !(SF1->(FieldPos("F1_XGESTOR"))>0)
		MsgInfo("Campo F1_XGESTOR pendente de cria็ใo. Poderใo ocorrer inconsist๊ncias.")
	EndIf


Return




//+-----------------------------------------------------------------------------------//
//|Funcao....: fHelpCpo()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fHelpCpo(aCampos,nPosCpo,nPosHelp)
	*-----------------------------------------------------------*

	Local x        := 00
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpEsp := {}

	For x:=1 To Len(aCampos)
		aHelpPor := aCampos[x][nPosHelp]
		aHelpEng := aCampos[x][nPosHelp]
		aHelpEsp := aCampos[x][nPosHelp]
		PutHelp( "P"+aCampos[x][nPosCpo],aHelpPor, aHelpEng, aHelpEsp, .T. )
	Next x

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNBxa()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
User Function GXNBxa(lEhJob)
	*-----------------------------------------------------------*
	Local lRet     := .T.
	Default lEhJob := .F.

	Private _lBXWeb     := iif(AllTrim(SuperGetMv("MX_MRBXWEB",,"S"))  == "S",.T.,.F.)

	if _lBXWeb
		Processa( {|| fBaixaXML(@lRet,lEhJob)},"Baixando XML do webmail..." )
	Endif

	If lRet
		Processa( {|| fTrataXML() },"Importando XML..." )
	EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fBaixaXML()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fBaixaXML(lRet,lEhJob)
	*-----------------------------------------------------------*

	Static __MailServer
	Static __MailError
	Static __MailFormatText    := .f. // Mensagem em formato Texto
	Static __isConfirmMailRead := .f. // Se mensagem deve pedir confima็ใo de leitura

	Local nMessages    :=  0

	Local __cPop3     := AllTrim(SuperGetMV( "MX_MRCPOP3", , "pop.seudominio.com.br"		))
	Local __cAccount  := AllTrim(SuperGetMV( "MX_MRCMAIL", , "protheus@seudominio.com.br"	))
	Local __cPswEmail := AllTrim(SuperGetMV( "MX_MRCPASS", , "senhaemail"					))
	Local __cProtoc	:= AllTrim(SuperGetMV( "MX_MR_PROT", , "P"							))
	Local __cPorta	   := AllTrim(SuperGetMV( "MX_MRPORTA", , "143"							))
	Local __cSSL	   := AllTrim(SuperGetMV( "MX_MR_SSL" , , "S"							))
	Local __lSSL	   := iif(__cSSL $ "S",.T.,.F.)

	Local cFrom        := ""
	Local cTo          := ""
	Local cCc          := ""
	Local cBcc         := ""
	Local cSubject     := ""
	Local cBody        := ""

	Local nX           :=  0
	Local nY           :=  0
	Local cDirIni      := AllTrim(SuperGetMv("MX_MR_DXML",,"\data\GestorXml\"))
	Local nResp        :=  0
	Default lRet       := .T.

	aFileAtch := {}

//Cria Diretorio para Armazenar XML, caso nao exista
	MontaDir(cDirIni+"pendente\")
	MontaDir(cDirIni+"processado\")
	MontaDir(cDirIni+"recusado\")

	If lRet
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณConecta Servidor como POP ou IMAP    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if __cProtoc $ "P"
			lRet := MailPopOn(__cPop3, __cAccount, __cPswEmail, 30 )
		else
			lRet := MailImapConn ( __cPop3    , __cAccount, __cPswEmail ,,__cPorta, __lSSL)  //Conectar com servidor imap
		endif

	EndIf

//Conta quantas mensagens existem para a conta
	If lRet
		lRet := PopMsgCount(@nMessages)
	EndIf

//Pergunta
	If lRet .And. nMessages > 100 .And. lEhJob
		nResp     := 3
		nMessages := 50

	ElseIf lRet .And. nMessages > 100
		nResp := Aviso('EMAILS','Existem '+Alltrim(Str(nMessages))+' e-mails pra baixar!'+;
			Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			"Voc๊ deseja baixar:",{"Todos","Nenhum","50 e-mails"})
		Do Case
			//Nใo fazer nada
		Case nResp == 1

			//Cancelar opera็ใo
		Case nResp == 2
			lRet := .F.

			//Baixar apenas 50 e-mails
		Case nResp == 3
			nMessages := 50

			//Cancelar opera็ใo
		Otherwise
			lRet := .F.

		EndCase
	EndIf

//Carrega contador
	ProcRegua(nMessages)

	If lRet
		If nMessages > 0
			conout(" ")
			conout(Replicate("=",80))
			conout(OemtoAnsi("A conta cont้m "+StrZero(nMessages,3)+" mensagem(s)") ) //###
			conout(Replicate("=",80))

			//Recebe as mensagens e grava os arquivos XML
			For nX := 1 to nMessages

				//Processa contador
				IncProc()

				aFileAtch := {}
				cFrom     := ""
				cTo       := ""
				cCc       := ""
				cBcc      := ""
				cSubject  := ""
				cBody     := ""

				MailReceive(nX,,,,,,,aFileAtch,cDirIni+"pendente",.T.)

				For nY := 1 to Len(aFileAtch)

					If ".XML" $ Upper(aFileAtch[nY][1])
						ConOut(" ")
						ConOut(Replicate("=",80))
						ConOut("Recebido o arquivo " + aFileAtch[nY][1]) //
						ConOut(Replicate("=",80))
					Else
						fErase(aFileAtch[nY][1])
					Endif

				Next nY

			Next nX

		Else
			Conout(Replicate("=",80))
			ConOut( Time()+" - Nao existem arquivos a serem recebidos" )
			Conout(Replicate("=",80))
		Endif
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDesConecta Servidor como POP ou IMAP ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if __cProtoc $ "P"
		MailPopOff()
	else
		MailImapOff()
	endif


	__RpcCalled := Nil

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNFVL()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
User Function GXNFVL()
	*-----------------------------------------------------------*
	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cStatus := (cTab1)->&(cAls1+"_STATUS")
	Local cChvNfe := (cTab1)->&(cAls1+"_CHVNFE")
	Local cRecno  := AllTrim(Str((cTab1)->(Recno())))

	If SimNao("Chave NF-e: "+cChvNfe + Chr(13)+Chr(10) + "Confirma a valida็ใo da chave novamente ?") == "S"
		Processa( {|| fValidXML(cStatus,,cRecno) },"Validando XML novamente..." )
	EndIf

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNFBL()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
User Function GXNFBL()
	*-----------------------------------------------------------*
	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cStatus := (cTab1)->&(cAls1+"_STATUS")
	Local cChvNfe := (cTab1)->&(cAls1+"_CHVNFE")
	Local nRecTab1  := (cTab1)->(Recno())

// Bloqueia
	if cStatus $ "1"
		if SimNao("Chave NF-e: "+cChvNfe + Chr(13)+Chr(10) + "Deseja Bloquear este XML ?") == "S"
			fGravaMsg(nRecTab1,90,"8")
		endif
	elseif cStatus $ "8"
		// Desbloqueia
		if SimNao("Chave NF-e: "+cChvNfe + Chr(13)+Chr(10) + "Deseja DesBloquear este XML ?") == "S"
			fGravaMsg(nRecTab1,99,"1")
		endif
	Else
		MsgAlert("Esta Operacao nao pode ser feita")
	Endif


Return





//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNVld()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
User Function GXNVld()
	Processa( {|| fValidXML("1") },"Validando todos XML (status verde)..." )
Return

	*-----------------------------------------------------------*
User Function GXNVld2()
	Processa( {|| fValidXML("4','5','7") },"Validando XML Pendentes (status 4 / 5 / 7)..." )
Return

User Function GXNVld3()
	Processa( {|| fSF1ChvNFe() },"Validando XML em Documento de Entrada..." )
Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: fValidXML()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fValidXML(cOpcVer,cFileXML,cRecno)
	*-----------------------------------------------------------*

	Local lRet   := .T.
	Local aRet   := {}
	Local nReg   := 0
	Local cTab1  := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1  := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local aArea  := (cTab1)->(GetArea())
	Local cQuery := " SELECT *, R_E_C_N_O_ AS "+cAls1+"_RECNO FROM "+RetSqlName(cTab1)+" WHERE D_E_L_E_T_ = '' AND "+cAls1+"_STATUS IN ('"+cOpcVer+"') "
	Local cVldMensag := ""
	Default cFileXML := ""
	Default cRecno   := ""

	If !Empty(cFileXML)
		cQuery += " AND UPPER("+cAls1+"_ARQUIV) LIKE '%"+AllTrim(Upper(cFileXML))+"%' "
	EndIf

	If !Empty(cRecno)
		cQuery += " AND R_E_C_N_O_ = "+cRecno+" "
	EndIf

//Fecha area se estiver em uso
	If Select("SQL") > 0
		SQL->(dbCloseArea())
	Endif

//Monta area de trabalho executando a Query
	TcQuery cQuery ALIAS "SQL" NEW

	DbSelectArea("SQL")
	SQL->(DbGoTop())
	Count To nReg
	ProcRegua(nReg)

	SQL->(DbGoTop())
	While SQL->(!Eof())
		//Inicia variavel para validar proximo registro
		lRet := .T.

		//Processa contador
		IncProc()

		//Posiciona registro
		nRecTab1 := SQL->&(cAls1+"_RECNO")

		//Verificar se CNPJ fornecedor existe no cadastro do Fornecedores ou Clientes
		//Emitende
		If lRet
			aRet := fVldCnpjEm(nRecTab1)
			lRet := aRet[1]
			If !lRet .And. aRet[2] == "SA1"
				fGravaMsg(nRecTab1,1,"7")
			EndIf
			If !lRet .And. aRet[2] == "SA2"
				fGravaMsg(nRecTab1,2,"7")
			EndIf
			If !lRet .And. Empty(aRet[2])
				fGravaMsg(nRecTab1,3,"7")
			EndIf

		EndIf

		//Verificar se CNPJ Destinatario estแ cadastrado no sigamat, pois caso nใo encontrado, foi uma emissใo errado do fornecedor
		//Destinatario
		If lRet
			lRet := fVldCnpjDs(nRecTab1)
			If !lRet
				fGravaMsg(nRecTab1,4,"7")
			EndIf
		EndIf

		//Verificar se chave nfe nใo foi importada anteriormente, nใo podendo constar em outra nota de entrada
		If lRet
			lRet := fVldChvNFe(nRecTab1)
			If !lRet
				fGravaMsg(nRecTab1,5,"7")
			EndIf
		EndIf

		//Verificar se chave nfe estแ ativa no sefaz, se existe e se nใo foi cancelada
		If lRet
			aRet := fVldChvAtv(nRecTab1)
			lRet := aRet[1]
			Do Case
			Case !lRet .And. aRet[2] == "101"  // Cancelamento de NF-e
				fGravaMsg(nRecTab1,6,"6")

			Case !lRet .And. aRet[2] == "102"  // Inutilizacao de NF-e
				fGravaMsg(nRecTab1,7,"6")

			Case !lRet .And. aRet[2] $  "/103/104/105/106/107/108/109/110/111/112/"
				fGravaMsg(nRecTab1,8,"7")

			Case !lRet //Qualquer outro msg nใo tratada, nใo bloquear chave
				fGravaMsg(nRecTab1,98," ","ATENCAO : "+aRet[3])
				lRet := .T. //Seguir com as valida็๕es

			Case lRet .And. aRet[2] == "999"
				fGravaMsg(nRecTab1,9," ")

			Case lRet .And. aRet[2] == "100"
				cVldMensag := "Consulta Sefaz: 100 - "+AllTrim(aRet[3])
				fGravaMsg(nRecTab1,98," ",cVldMensag,aRet[4])       // Adicionado aRet[4] para Retornar Protocolo

			EndCase

		EndIf

		//Se passou pelas valida็๕es e estava como erro ao gerar pre-nf, entใo desbloqueia
		If lRet .And. SQL->&(cAls1+"_STATUS") == "4"
			fGravaMsg(nRecTab1,99,"1")
		EndIf

		//Se passou pelas valida็๕es e estava como pre-nf excluida, entใo desbloqueia
		If lRet .And. SQL->&(cAls1+"_STATUS") == "5"
			fGravaMsg(nRecTab1,99,"1")
		EndIf

		//Se passou pelas valida็๕es e estava bloqueado, entใo desbloqueia
		If lRet .And. SQL->&(cAls1+"_STATUS") == "7"
			fGravaMsg(nRecTab1,99,"1")
		EndIf

		SQL->(DbSkip())
	Enddo

//Fecha area se estiver em uso
	If Select("SQL") > 0
		SQL->(dbCloseArea())
	Endif

	RestArea(aArea)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldChvAtv()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fVldChvAtv(nRecTab1,nMsg)
	*-----------------------------------------------------------*
	Local lRet    := .F.
	Local cURL    := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMsg    := ""
	Local oWS     := Nil

	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cVarPsq := ""
	Local cCodEst := ""
	Local cMsgPrt := ""

//Posiciona no registro a ser validade
	(cTab1)->(DbGoTo(nRecTab1))
	cVarPsq := (cTab1)->&(cAls1+"_CHVNFE")

//Codigo do Estado
	cCodEst := SubStr(cVarPsq,01,02)

//NOVA FUNCAO LOBO GUARA JONAS 11/04/2019
	cCodEst := RETSGEST(cCodEst)

//DESCONTINUADA NOVA VERSAO
//cCodEst := SPEDRetEst(cCodEst)


//Se sem chave, entใo nใo precisa validar
	If Empty(cVarPsq)
		Return(.F.)
	EndIf

	oWs := WsNFeSBra():New()
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := RetIdEnti()
	oWs:cCHVNFE    := cVarPsq
	oWs:cUF        := cCodEst
	oWs:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"

	If oWs:ConsultaChaveNFE()
		lRet := .T.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ	TABELA DE MOTIVOS DO SEFAZ - NFE                ณ
		//ณ	                                                ณ
		//ณ	100 Autorizado o uso NF-e                       ณ
		//ณ	101 Cancelamento de NF-e homologado             ณ
		//ณ	102 Inutiliza็ใo de n๚mero homologado           ณ
		//ณ	103 Lote recebido com sucesso                   ณ
		//ณ	104 Lote processado                             ณ
		//ณ	105 Lote em processamento                       ณ
		//ณ	106 Lote nใo localizado                         ณ
		//ณ	107 Servi็o em Opera็ใo                         ณ
		//ณ	08 Servi็o Paralisado (curto prazo)             ณ
		//ณ	09 Servi็o Paralisado (sem previsใo)            ณ
		//ณ	110 Uso Denegado                                ณ
		//ณ	111 Consulta cadastro com uma ocorr๊ncia        ณ
		//ณ	112 Consulta cadastro com mais de uma ocorr๊nciaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		cMsgCod := AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE)
		cMsgDsc := AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE)

		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
			cMsgPrt := AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
		EndIf

		If cMsgCod == "100"
			lRet := .T.
		Else
			lRet := .F.
		EndIf

	Else
		//Servi็o de consulta inoperando, nใo foi possivel consultar chave
		lRet := .T.
		cMsgCod := "999"
		cMsgDsc := "Consulta Inoperante - 999" //GetWscError(3)+" - "+GetWscError(1)
	EndIf

Return({lRet,cMsgCod,cMsgDsc,cMsgPrt})

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGravaMsg()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fGravaMsg(nRecTab1,nMsg,cSts,cTmpMsg,cMsgProt)
	*-----------------------------------------------------------*
	Local cTab1    := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cTab2    := AllTrim(GetMV("MX_MRALS02"))
	Local cAls2    := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)
	Local cMens    := ""
	Default cSts   := ""
	Default cTmpMsg:= ""
	Default cMsgProt:=""

//Posiciona no registro a ser validade
	(cTab1)->(DbGoTo(nRecTab1))

	Do Case
	Case nMsg == 1
		cMens := "CNPJ do Emitente nใo estแ cadastrado no sistema (SA1)"
	Case nMsg == 2
		cMens := "CNPJ do Emitente nใo estแ cadastrado no sistema (SA2)"
	Case nMsg == 3
		cMens := "CNPJ do Emitente nใo localizado no XML"
	Case nMsg == 4
		cMens := "CNPJ do Destinatแrio nใo estแ cadastrado no sistema (SIGAMAT)"
	Case nMsg == 5
		cMens := "A Chave da NF-e jแ estแ registrada no sistema (Duplicidade)"
	Case nMsg == 6
		cMens := "A Chave da NF-e estแ cancelada no Sefaz!"
	Case nMsg == 7
		cMens := "O numero da NFe estแ inutilizada no Sefaz!"
	Case nMsg == 8
		cMens := "O Servi็o de consulta da NFe nใo confirmou autoriza็ใo da Chave. Verificar novamente!"
	Case nMsg == 9
		cMens := "O Servi็os de consulta da NFe esta inoperante. Chave nใo consultada!"
	Case nMsg == 10
		cMens := "Status ajustado automaticamente, pois foi identificado que a nota jแ foi incluida no sistema!"
	Case nMsg == 11
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o Status diferente de 1 impediu a opera็ใo!"
	Case nMsg == 12
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML pendente de recebimento!"
	Case nMsg == 13
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML estแ com erro de estrutura!"
	Case nMsg == 14
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML nใo ้ do tipo NF-e!"
	Case nMsg == 90
		cMens := "XML Bloqueado por Solicitacao do Usuario!"
	Case nMsg == 98
		cMens := cTmpMsg
	Case nMsg == 99
		cMens := "Registro foi desbloqueado, valida็ใo OK!"
	Otherwise
		//Se mensagem nใo tratada acima, sair sem fazer nada
		Return()
	EndCase

//Caso seja s๓ mensagem, nใo tratar status
	If !Empty(cSts)
		//Registro Corrigido
		Reclock(cTab1,.F.)
		&(cAls1+"_STATUS") := cSts
		(cTab1)->( MsUnlock() )
	EndIf

//Gravar novo registro
	Reclock(cTab2,.T.)
	&(cAls2+"_FILIAL") := (cTab1)->(&(cAls1+"_FILIAL"))
	&(cAls2+"_DTEMIS") := (cTab1)->(&(cAls1+"_DTEMIS"))
	&(cAls2+"_DECNPJ") := (cTab1)->(&(cAls1+"_DECNPJ"))
	&(cAls2+"_CHVNFE") := (cTab1)->(&(cAls1+"_CHVNFE"))
	&(cAls2+"_PROTOC") := iif(!empty(alltrim(cMsgProt)),alltrim(cMsgProt),"Valida็ใo Interna")//"VALIDACAO INTERNA"
	&(cAls2+"_MSG"   ) := cMens
	&(cAls2+"_ARQUIV") := ""
	&(cAls2+"_MXML"  ) := ""
	&(cAls2+"_LOGDT" ) := Date()
	&(cAls2+"_LOGHR" ) := Time()
	&(cAls2+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID))
	(cTab2)->( MsUnlock() )

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldCnpjEm()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fVldCnpjEm(nRecTab1)
	*-----------------------------------------------------------*
	Local lRet    := .F.
	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cTipDoc := "" //"N=Normal;D=Devolucao;B=Beneficiamento;C=Complementar;A=Ajuste;U=Anulacao;S=Substituicao;X=Indefinido"
	Local cTipXml := "" //"1=NF;2=CT;3=XML Pedente"
	Local nCadInx := 0
	Local nCadAls := ""
	Local cVarPsq := ""

//Posiciona no registro a ser validade
	(cTab1)->(DbGoTo(nRecTab1))
	cTipDoc := (cTab1)->&(cAls1+"_TIPDOC")
	cTipXml := (cTab1)->&(cAls1+"_TIPXML")
	cVarPsq := (cTab1)->&(cAls1+"_DECNPJ")

	Do Case
		//NFe - SA2
	Case cTipXml == "1" .And. cTipDoc $ "/N/C/A/"
		nCadInx := 3
		nCadAls := "SA2"

		//NFe - SA1
	Case cTipXml == "1" .And. cTipDoc $ "/D/B/"
		nCadInx := 3
		nCadAls := "SA1"

		//CTe - SA2
	Case cTipXml == "2" .And. cTipDoc $ "/N/C/U/S/"
		nCadInx := 3
		nCadAls := "SA2"

		//XML Pendente
	Case cTipXml == "3"
		nCadInx := 0
		nCadAls := ""

	EndCase

//Verifica se CNPJ estแ cadastrado
	If !Empty(nCadInx) .And. !Empty(nCadAls) .And. !Empty(cVarPsq)
		(nCadAls)->(DbSetOrder(nCadInx))
		If (nCadAls)->(DbSeek(xFilial(nCadAls)+cVarPsq))
			lRet := .T.
		EndIf
	EndIf

Return({lRet,nCadAls})

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldCnpjDs()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fVldCnpjDs(nRecTab1)
	*-----------------------------------------------------------*

	Local lRet    := .F.
	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cVarPsq := ""
	Local aAreaSM0:= SM0->(GetArea())

//Posiciona no registro a ser validade
	(cTab1)->(DbGoTo(nRecTab1))
	cVarPsq := AllTrim((cTab1)->&(cAls1+"_TOCNPJ"))

	SM0->(DbGoTop())
	While SM0->(!Eof()) .And. !lRet
		If cVarPsq == SM0->M0_CGC
			lRet := .T.
		EndIf
		SM0->(DbSkip())
	End

	RestArea(aAreaSM0)

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldChvNFe()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fVldChvNFe()
	*-----------------------------------------------------------*
	Local lRet    := .T.
	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cVarPsq := ""
	Local cQuerys := ""

//Posiciona no registro a ser validade
	(cTab1)->(DbGoTo(nRecTab1))
	cVarPsq := AllTrim((cTab1)->&(cAls1+"_CHVNFE"))

//Verifica se chave jแ foi registrada!!!
	cQuerys := " SELECT F1_TIPO, SF1.F1_CHVNFE, COUNT(*) QTD "
	cQuerys += "   FROM "+RetSqlName("SF1")+" SF1 "
	cQuerys += "  WHERE SF1.D_E_L_E_T_ = '' "
	cQuerys += "    AND SF1.F1_CHVNFE = '"+cVarPsq+"' "
	cQuerys += "  GROUP BY F1_TIPO, SF1.F1_CHVNFE "

	If Select("TMP") <> 0 ; SQL->(dbCloseArea()) ;EndIf
		TcQuery cQuerys New Alias "TMP"
		TMP->(DbGoTop())

//Caso retorno maior que 0(zero) ้ porque nfe jแ foi registrada
		If TMP->(!Eof())
			Do Case
			Case TMP->QTD == 0
				lRet := .T.

			Case TMP->QTD == 1
				lRet := .T.
				//Ajusta o status
				RecLock(cTab1,.F.)
				&(cAls1+"_STATUS") := "3"
				&(cAls1+"_TIPDOC") := TMP->F1_TIPO
				(cTab1)->(MsUnLock())
				//Grava mensagem informando a altera็ใo do status
				fGravaMsg(nRecTab1,10," ")

			Case TMP->QTD >= 2
				lRet := .F.
			EndCase
		EndIf
		TMP->(dbCloseArea())

		Return(lRet)



		*-----------------------------------------------------------*
Static Function fSF1ChvNFe()
	*-----------------------------------------------------------*
	Local _aXArea := GetArea()
	Local lRet    := .T.
	Local cTab1   := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cCpo    := " "+cAls1+"_CHVNFE , R_E_C_N_O_ AS AA_RECNO "
	Local cCpoSeek:= " TMP->"+cAls1+"_CHVNFE "
	Local cVarPsq := ""
	Local cQuerys := ""

//Posiciona no registro a ser validado
//(cTab1)->(DbGoTo(nRecTab1))
//cVarPsq := AllTrim((cTab1)->&(cAls1+"_CHVNFE"))

	cQuerys := " SELECT " + cCpo
	cQuerys += " FROM "+RetSqlName(cTab1)+" "+cTab1+"(NOLOCK)
	cQuerys += " WHERE "+cTab1+".D_E_L_E_T_ = ''  AND "  + cTab1+"_STATUS = '1' "

	If Select("TMP") <> 0 ; SQL->(dbCloseArea()) ;EndIf
		TcQuery cQuerys New Alias "TMP"
		TMP->(DbGoTop())

		SF1->(DbSetOrder(8)) // F1_FILIAL + F1_CHVNFE
		While !TMP->(Eof())

			if SF1->(DBseek(xfilial()+&(cCpoSeek)))

		/*
		//Ajusta o status
		RecLock(cTab1,.F.)
		&(cAls1+"_STATUS") := "3"
		&(cAls1+"_TIPDOC") := TMP->F1_TIPO
		(cTab1)->(MsUnLock())
		*/
				//Grava mensagem informando a altera??o do status
				//			fGravaMsg(nRecTab1,10," ")
				fGravaMsg(TMP->AA_RECNO,10,"3")
			Endif
			TMP->(dbSkip())

		Enddo

		TMP->(dbCloseArea())

		RestArea(_aXArea)

		Return(lRet)



//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNTrt()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//

User Function GXNTrt()

	Processa( {|| fTrataXML() },"Tratando XML baixado..." )

Return



//+-----------------------------------------------------------------------------------//
//|Funcao....: wTrataXML()
//|Autor.....: Marco Aur้lio Silva - OPUS
//|Data......: 27/09/2019 
//|Descricao.: Chama a Rotina fTrataXML via Schedulle (para atender Portal) 
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//

User Function wTrataXML()

//	If GetMV("MX_MRSCHED")=='S'

	If Type("cEmpAnt") == 'U'
		RPCSetType(3)  // Nao utilizar licensa
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES  "SC1" , "SC7" , "SA2"
		SetUserDefault("000000")
	ENDIF

	fTrataXML(.T.)  // indica que Eh Job

//	Endif

return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fTrataXML()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//

Static Function fTrataXML(lEhJob)

	Local cErro      	:= ""
	Local cAviso     	:= ""
	Local cFile      	:= ""
	Local cExt       	:= ""
	Local cVar       	:= ""
	Local cDirIni    	:= AllTrim(SuperGetMv("MX_MR_DXML",,"\data\GestorXml\"))
	Local aDir     		:= Directory( cDirIni+"pendente\" + "*.*", "H" )
	Local cSepara  		:= Upper(AllTrim(SuperGetMv("MX_MRSEPAR",,"C")))
	Local i
	Local cTab1      	:= GetMV("MX_MRALS01")
	Local cTab2      	:= GetMV("MX_MRALS02")
	Local cAls       	:= IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cAls2      	:= IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)

	Local cTipo      	:= ""
	Local cVersao    	:= ""
	Local cCnpjE     	:= ""
	Local cNomeE     	:= ""
	Local cCnpjD     	:= ""
	Local cNomeD     	:= ""
	Local cChNFE     	:= ""
	Local cNF        	:= ""
	Local cSerie     	:= ""
	Local cTotal     	:= ""
	Local cTipoDoc   	:= ""
	Local cData      	:= ""
	Local cHora      	:= ""
	Local cProtoc    	:= ""
	Local cTexto     	:= ""

	Local nHdlArq    	:= 0
	Local xBuffer    	:= ""
	Local lLoop      	:= .T.

	Local cHora    		:= ""
	Local cUF      		:=	""
	Local cCid     		:= ""

	Private oXml     	:= NIL
	Private oEvento  	:= Nil
	Private oRetEven 	:= Nil

//MAURESI - 27/09/19
	Private _lMSG01   	:= iif(AllTrim(SuperGetMv("MX_MRMSG01",,"S")) == "S",.T.,.F.)
	Private _lMSG02   	:= iif(AllTrim(SuperGetMv("MX_MRMSG02",,"S")) == "S",.T.,.F.)

	Default lEhJob		:= .F.

//Carrega contador
	ProcRegua(Len(aDir))

	For i:=1 to Len(aDir)

		//Processa contador
		IncProc()

		cFile := AllTrim(aDir[i][1])  //nome arquivo
		oXML  := XmlParserFile( cDirIni+"pendente\"+cFile ,"_" , @cAviso,@cErro )

		//Carrega XML numa string
		nHdlArq :=FOPEN(cDirIni+"pendente\"+cFile,2+64)
		nTamArq :=FSEEK(nHdlArq,0,2)
		xBuffer :=Space(nTamArq)
		FSEEK(nHdlArq,0,0)
		FREAD(nHdlArq,@xBuffer,nTamArq)
		FCLOSE(nHdlArq)

		If Empty(cAviso) .AND. Empty(cErro)

			Do Case
			Case Type('oXML:_NFEPROC') <> "U"

				If Type('oXML:_NFEPROC:_RETCONSRECINFE') <> "U"

					if _lMSG01
						if lEhJob
							Conout("Aten็ใo o XML " + cFile + " ้ de Retorno de Consulta de Recibo e nใo serแ processado.  Arquivo Movido Para Pasta Recusados !")
						Else
							MsgInfo("Aten็ใo o XML " + cFile + " ้ de Retorno de Consulta de Recibo e nใo serแ processado.  Arquivo Movido Para Pasta Recusados !")
						Endif
					Endif
					//move o arquivo de pasta
					fRename(cDirIni+"pendente\"+cFile,cDirIni+"recusado\"+cFile)
					Loop
				Endif

				cTipo    := "NFE"
				cChNFE   := &('oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT'         )
				cVersao  := &('oXML:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT'             )

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณSe nใo existir a TAG _CNPJ  significa que a a NF ้ emitida por Pessoa Fisica, e neste caso ณ
				//ณa estrutura do XML ้ diferente.Possui a TAG CPF que deve ser carregada no lugar do CNPJ.   ณ
				//ณExiste ainda uma outra TAG chamada AVULSA que ainda nao tratada neste program              ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				If Type('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT') <> 'U'
					cCnpjE   := &('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT'     )
				Else
					cCnpjE   := &('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT' 	)
				Endif
				cNomeE   := &('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT'        )

				// Pessoa Fisica Pula
				If Type('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT') <> 'U'
					cCnpjD   := &('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT'         )
					cCnpjD2  := &('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT'         )
				Else
					cCnpjD:='RECUSADO'
					cCnpjD2:='RECUSADO'
				Endif
				cNomeD   := &('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_XNOME:TEXT'        )
				cNF      := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT'           )
				cSerie   := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT'         )
				cTotal   := &('oXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT')
				cTipoDoc := fVTipoDoc(oXML,cTipo)
				If Type('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT') <> "U"
					cData    := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT'       )
				Else
					cData    := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT'      )
				EndIf
				cProtoc  := ""
				cTexto   := ""

				cUF      := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				If Type('oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT') <> "U"
					cHora    := oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT
					cHora    := SubStr(cHora,12)
				Else
					cHora    := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT
					cHora    := SubStr(cHora,12)
				EndIf

			Case Type('oXML:_CTEPROC') <> "U"
				cTipo    := "CTE"
				cChNFE   := &('oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT'         )
				cVersao  := &('oXML:_CTEPROC:_CTE:_INFCTE:_VERSAO:TEXT'             )

				// Verifica se Existe TAG CNPJ ou CPF no EMITENTE
				if Type('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ') <> "U"
					cCnpjE   := &('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT'      )
				elseif Type('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CPF') <> "U"
					cCnpjE   := &('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CPF:TEXT'       )
				endif
				cNomeE   := &('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT'        )


				// Verifica se Existe TAG CNPJ ou CPF no REMETENTE
				if Type('oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ') <> "U"
					cCnpjD   := &('oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT'       )
				elseif Type('oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CPF') <> "U"
					cCnpjD   := &('oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CPF:TEXT'        )
				endif
				cNomeD   := &('oXML:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT'         )

				// Verifica se Existe TAG CNPJ ou CPF no DESTINATARIO
				if Type('oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ') <> "U"
					cCnpjD2  := &('oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT'      )
				elseif Type('oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF') <> "U"
					cCnpjD2  := &('oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF:TEXT'       )
				endif
				cNomeD2  := &('oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT'        )

				cNF      := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT'           )
				cSerie   := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT'         )
				cCFOPCTE := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT'         )		//mauresi 10/08/2020
				cTotal   := &('oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT'    )
				cTipoDoc := fVTipoDoc(oXML,cTipo)
				cData    := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT'         )
				cProtoc  := ""
				cTexto   := ""
				cUFDEST  := oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT    // MAURESI - 17/08/2020

				cUF      := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				cHora    := oXML:_CTEPROC:_PROTCTE:_INFPROT:_DHRECBTO:TEXT
				cHora    := SubStr(cHora,12)

			Case Type('oXML:_PROCCANCNFE') <> "U"
				cTipo := "CAN"
				cChNFE   := &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_CHNFE:TEXT'     )
				cVersao  := &('oXML:_PROCCANCNFE:_CANCNFE:_VERSAO:TEXT'             )
				cCnpjE   := SubStr(cChNFE,07,14)
				cNomeE   := ""
				cCnpjD   := ""
				cNomeD   := ""
				cNF      := ""
				cSerie   := ""
				cTotal   := ""
				cTipoDoc := ""
				cData    := &('oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_DHRECBTO:TEXT')
				cProtoc  := &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_NPROT:TEXT'      )
				cTexto   := &('oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_XMOTIVO:TEXT' )
				cTexto   += "-"
				cTexto   += &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_XJUST:TEXT'      )
				cUF      := ""
				cCid     := ""
				cHora    := ""

			Case Type('oXML:_PROCEVENTONFE') <> "U"
				cTipo    := "CCE"

				oEvento  := Nil
				oRetEven := Nil

				If      Type('oXML:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO') != "U"
					oEvento  := oXML:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO:_RETENVEVENTO:_RETEVENTO
				Elseif  Type('oXML:_PROCEVENTONFE:_EVENTO') != "U"
					oEvento  := oXML:_PROCEVENTONFE:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO
				Elseif  Type('oXML:_PROCEVENTONFE:_ENVEVENTO:_EVENTO') != "U"
					oEvento  := oXML:_PROCEVENTONFE:_ENVEVENTO:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO //:_RETEVENTO
				Else
					oEvento  := oXML:_PROCEVENTONFE:_ENVEVENTO:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO:_RETEVENTO
				EndIf

				cChNFE   := oEvento:_INFEVENTO:_CHNFE:TEXT
				cVersao  := oXML:_PROCEVENTONFE:_VERSAO:TEXT
				cCnpjE   := SubStr(cChNFE,07,14)
				cNomeE   := ""
				cCnpjD   := ""
				cNomeD   := ""
				cCnpjD2  := ""
				cNomeD2  := ""
				cNF      := ""
				cSerie   := ""
				cTotal   := ""
				cTipoDoc := ""
				cData    := oEvento:_INFEVENTO:_DHEVENTO:TEXT
				cProtoc  := oRetEven:_INFEVENTO:_NPROT:TEXT

				If Type('oEvento:_INFEVENTO:_DETEVENTO:_XJUST') <> "U"
					cTexto   := &('oEvento:_INFEVENTO:_DETEVENTO:_DESCEVENTO:TEXT')
					If "CANCELAMENTO" $ Upper(cTexto)
						cTipo := "CAN"
					EndIf
					cTexto   += "-"
					cTexto   += &('oEvento:_INFEVENTO:_DETEVENTO:_XJUST:TEXT')
				Else
					cTexto   := &('oEvento:_INFEVENTO:_DETEVENTO:_XCORRECAO:TEXT')
				EndIf
				cUF      := ""
				cCid     := ""
				cHora    := ""

			Otherwise
				cTipo := "XXX"

			EndCase

			lOk := .f.
			If !Empty(cCnpjD)	// CNPJ Destinatario deve Existir no SIGAMAT da empresa
				nReg := SM0->(Recno())
				SM0->(dbGoTop())
				While SM0->(!Eof())
					If AllTrim(SM0->M0_CGC)$AllTrim(cCnpjD)
						lOk := .t.
						Exit
					Endif

					// Valida se o Campo CnpjD2 esta no Sigamat (Usado para tratar alguns CTE)  - MAS - 06/07/16
					If AllTrim(SM0->M0_CGC)$AllTrim(cCnpjD2)
						cCnpjD   := cCnpjD2
						cNomeD   := cNomeD2
						lOk := .t.
						Exit
					Endif
					SM0->(dbSkip(1))
				Enddo
				SM0->(dbGoTo(nReg))
			Endif

			If !lOk .And. Type('oXML:_PROCEVENTONFE') == "U" .Or. cCnpjD=='RECUSADO'

				if _lMSG01
					if lEhJob
						Conout("Aten็ใo o XML " + cFile + " Nใo foi emitido para  "+allTrim(SM0->M0_NOME)+ ".  Arquivo Movido Para Pasta Recusados !")
					Else
						MsgInfo("Aten็ใo o XML " + cFile + " Nใo foi emitido para  "+allTrim(SM0->M0_NOME)+ ".  Arquivo Movido Para Pasta Recusados !")
					Endif
				Endif
				//move o arquivo de pasta
				fRename(cDirIni+"pendente\"+cFile,cDirIni+"recusado\"+cFile)
				Loop
			Endif

			cData  := StrTran(Substr(cData,1,10),"-","")
			cMes   := Substr(cData,5,2)
			cAno   := Substr(cData,1,4)
			cDia   := Substr(cData,7,2)

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSepara XML por   CNPJ  ou por DATAณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			if cSepara == "C"
				_cCaminho := cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"
			Else
				_cCaminho := cDirIni+"processado\"+cAno+"\"+cMes+"\"+cDia+"\"
			Endif

			//cria os diretorios
			//			MontaDir(cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\")
			MontaDir(_cCaminho)

			//Tratamento pra mover arquivos com o nome duplicado
			//			If File(cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"+cFile)
			If File(_cCaminho+cFile)
				lLoop := .T.
				cSeq  := "001"
				While lLoop
					cNewFile := SubStr(cFile,1,Rat(".XML",cFile)-1)+"-"+cSeq+".XML"
					//					If File(cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"+cNewFile)
					If File(_cCaminho+cNewFile)
						cSeq  := Soma1(cSeq)
					Else
						lLoop := .F.
					EndIf
				End
			Else
				cNewFile := cFile
			EndIf

			//move o arquivo de pasta
			//			fRename(cDirIni+"pendente\"+cFile,cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"+cNewFile)
			fRename(cDirIni+"pendente\"+cFile,_cCaminho+cNewFile)

			ConOut(" ")
			ConOut(Replicate("=",80))
			ConOut("Recebido o arquivo " + cDirIni+"pendente\"+cNewFile)
			ConOut(Replicate("=",80))

			//Grava registro na tabela principal apenas se for NF ou CT
			//Demais XML deve ser localizado a chave principal e gravar em mensagens do XML principal (Cancelamento, Carta de Corre็ใo e duplicidades de XML)
			Do Case

				//Grava em Mensagens - Extrutura do XML nใo identificado
			Case cTipo == "XXX"

				//Grava em Mensagens - Carta de Corre็ใo ou Cancelamento
			Case cTipo $ "/CCE/CAN/"

				//Verifica se existe chave na tabela principal e caso nใo exista, gravar um breve cadastro com _STATUS == 0 e TIPXML == 3
				//Caso exista, gravar flag dizendo que tem carta de corre็ใo ou NFe foi cancelada
				(cTab1)->(DbSetOrder(3))
				If (cTab1)->( DbSeek(xFilial(cTab1)+cChNFE) )
					Reclock(cTab1,.F.)

					//Ajusta valores conforme tipo do XML
					If cTipo == "CCE" ; &(cAls+"_TEMCCE") := "S" ; EndIf
						If cTipo == "CAN" ; &(cAls+"_STATUS") := "6" ; EndIf

							(cTab1)->( MsUnlock() )
						Else
							Reclock(cTab1,.T.)

							&(cAls+"_FILIAL") := xFilial(cTab1)
							&(cAls+"_STATUS") := "0"                       //(0=XML Pendente de recebimento)
							&(cAls+"_TEMCCE") := "N"                       //(N=Nao)
							&(cAls+"_TIPDOC") := "X"                       //(N=Normal;D=Devolucao;B=Benefic.;X=Desconhecido)
							&(cAls+"_TIPXML") := "3"                       //(1=NF / 2=CT / 3=XML Pedente)
							&(cAls+"_DECNPJ") := cCnpjE
							&(cAls+"_CHVNFE") := cChNFE
							&(cAls+"_ARQUIV") := cNewFile
							&(cAls+"_LOGDT")  := Date()
							&(cAls+"_LOGHR")  := Time()
							&(cAls+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID))

							//Ajusta valores conforme tipo do XML
							If cTipo == "CCE" ; &(cAls+"_TEMCCE") := "S" ; EndIf
								If cTipo == "CAN" ; &(cAls+"_STATUS") := "6" ; EndIf

									(cTab1)->( MsUnlock() )
								EndIf

								//Independente se XML ja foi recebido ou nใo, gravar novo registro
								Reclock(cTab2,.T.)
								&(cAls2+"_FILIAL") := xFilial(cTab2)
								&(cAls2+"_DTEMIS") := StoD(cData)
								&(cAls2+"_HREMIS") := cHora
								&(cAls2+"_DECNPJ") := cCnpjE
								&(cAls2+"_CHVNFE") := cChNFE
								&(cAls2+"_PROTOC") := cProtoc
								&(cAls2+"_MSG"   ) := cTexto
								&(cAls2+"_ARQUIV") := cNewFile
								&(cAls2+"_MXML"  ) := xBuffer
								&(cAls2+"_LOGDT" ) := Date()
								&(cAls2+"_LOGHR" ) := Time()
								&(cAls2+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID))
								(cTab2)->( MsUnlock() )

								//Grava Chave Principal
							Case cTipo $ "/NFE/CTE/"

								lGravaReg := .F.

								//Verifica se chave jแ existe
								(cTab1)->(DbSetOrder(3))
								If (cTab1)->(DbSeek(xFilial(cTab1)+cChNFE))
									//Verifica se deve atualizar informa็๕es da tabela principal
									//Somente se for tipo 3
									If (cTab1)->(&(cAls+"_TIPXML")) == "3"
										lGravaReg := .T.
										Reclock(cTab1,.F.)
										&(cAls+"_STATUS") := IIf(&(cAls+"_STATUS")=="0","1",&(cAls+"_STATUS"))
									Else
										//Gravar mensagem que XML chegou em duplicidade
									EndIf
								Else
									lGravaReg := .T.
									Reclock(cTab1,.T.)
									&(cAls+"_TEMCCE") := "N" //Definir como N somente na inclusใo
									&(cAls+"_STATUS") := "1" //1=XML Recebido com sucesso
								EndIf

								//Grava informa็๕es na tabela
								If lGravaReg
									&(cAls+"_FILIAL") := xFilial(cTab1)
									&(cAls+"_TIPDOC") := cTipoDoc
									&(cAls+"_TIPXML") := IIf(cTipo=="NFE","1","2") //(1=NF / 2=CT)
									&(cAls+"_SERIE" ) := StrZero(Val(cSerie),3)
									&(cAls+"_DOC"   ) := StrZero(Val(cNF   ),9)
									&(cAls+"_DTEMIS") := StoD(cData)
									&(cAls+"_HREMIS") := cHora
									&(cAls+"_DEUF"  ) := cUF
									&(cAls+"_DECIDAD"):= cCid
									&(cAls+"_DECNPJ") := cCnpjE
									&(cAls+"_DENOME") := cNomeE
									&(cAls+"_TOCNPJ") := cCnpjD
									&(cAls+"_TONOME") := cNomeD
									&(cAls+"_VLRTOT") := Val(cTotal)
									&(cAls+"_CHVNFE") := cChNFE
									&(cAls+"_ARQUIV") := cNewFile
									&(cAls+"_MXML"  ) := IIf(Len(xBuffer)>65530,SubStr(xBuffer,1    ,65530       ),xBuffer)
									&(cAls+"_MXML2" ) := IIf(Len(xBuffer)>65530,SubStr(xBuffer,65531,Len(xBuffer)),""     )
									&(cAls+"_LOGDT" ) := Date()
									&(cAls+"_LOGHR" ) := Time()
									&(cAls+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID))
									(cTab1)->( MsUnlock() )
								EndIf
								cVldSts := (cTab1)->(&(cAls+"_STATUS"))
								cVldRec := AllTrim(Str((cTab1)->(Recno())))
								fValidXML(cVldSts,,cVldRec)
							EndCase
							cAviso := ""
							cErro  := ""
						Else
							//AQUI - Mover XML pra uma pasta onde ficarใo os XML com erro de estrutura
							Conout(Replicate("=",80))
							ConOut( cAviso+" - "+cErro )
							Conout(Replicate("=",80))
							cAviso := ""
							cErro  := ""
						EndIf
					Next i

					Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVTipoDoc()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
					*-----------------------------------------------------------*
Static Function fVTipoDoc(oXML,cTipoXML)
	*-----------------------------------------------------------*
	Local cRet    := ""
	Local oDet    := Nil
	Local oIde    := Nil
	Local lDetOk  := .F.
	Local lIdeOk  := .F.
	Local cCFOP_B := AllTrim(SuperGetMV( "MX_MRNFBEN", , "1901/1920/1916/1949" )) //Beneficiamento
	Local cCFOP_D := AllTrim(SuperGetMV( "MX_MRNFDEV", , "1201/2201/1202/2202" )) //Devolu็ใo
	Local cCFOP_C := AllTrim(SuperGetMV( "MX_MRNFCOM", , "1352/3101/3102/3551" )) //Complemento
	Local cXXCF_B := "901/920"                                                    //Beneficiamento
	Local cXXCF_D := "201/202"                                                    //Devolu็ใo

//finNFe Finalidade de emissใo da NF-e
//1=Normal(N);
//2=Complementar(C);
//3=Ajuste(A);
//4=Devolu็ใo(D)/Beneficiamento(B)

//tpCTe Finalidade de emissใo da CT-e
//0=Normal(N)
//1=Complemento(C)
//2=Anula็ใo(U)
//3=Substitui็ใo(S)

	Private oNF  := oXML

	Do Case
	Case cTipoXML == "CTE"
		lIdeOk := .F.

		If !lIdeOk .And. Type("oNF:_CTeProc:_CTe:_InfCTe:_IDE:_TpCTe") != "U"
			oIde := oNF:_CTeProc:_CTe:_InfCTe:_IDE:_TpCTe
			lIdeOk := .T.
		EndIf

		//Normal
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "0"
			cRet := "N"
		EndIf

		//Complementar
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "1"
			cRet := "C"
		EndIf

		//Anula็ใo
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "2"
			cRet := "U"
		EndIf

		//Substitui็ใo
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "3"
			cRet := "S"
		EndIf

		If Empty(cRet)
			cRet := "X"
		EndIf

	Case cTipoXML == "NFE"
		lIdeOk := .F.
		lDetOk := .F.

		If !lIdeOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_IDE:_finNFe") != "U"
			oIde := oNF:_NfeProc:_Nfe:_InfNfe:_Ide:_finNFe
			lIdeOk := .T.
		EndIf

		If !lDetOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_Det") == "A"
			oDet := oNF:_NfeProc:_Nfe:_InfNfe:_Det
			lDetOk := .T.
		EndIf

		If !lDetOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_Det") == "O"
			oDet := {oNF:_NfeProc:_Nfe:_InfNfe:_Det}
			lDetOk := .T.
		EndIf

		//Verifica CFOP caso parametro preenchido
		If Empty(cRet) .And. lDetOk
			//Verifica o tipo da nota fiscal
			For x:=1 To Len(oDet)

				//Beneficiamento
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_B .And. !Empty(cCFOP_B)
					cRet := "B"
					x := Len(oDet)
				EndIf

				//Devolu็ใo
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_D .And. !Empty(cCFOP_D)
					cRet := "D"
					x := Len(oDet)
				EndIf

				//Complemento
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_C .And. !Empty(cCFOP_C)
					cRet := "C"
					x := Len(oDet)
				EndIf

			Next x
		EndIf

		//Normal
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "1"
			cRet := "N"
		EndIf

		//Complementar
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "2"
			cRet := "C"
		EndIf

		//Ajuste
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "3"
			cRet := "A"
		EndIf

		//Devolu็ใo / Beneficiamento
		If Empty(cRet) .And. lDetOk //.And. lIdeOk .And. AllTrim(oIde:Text) $ " 4"

			//Verifica o tipo da nota fiscal
			For x:=1 To Len(oDet)
				//Beneficiamento
				If Empty(cRet) .And. SubStr(AllTrim(oDet[x]:_Prod:_CFOP:TEXT),2,3) $ cXXCF_B
					cRet := "B"
					x := Len(oDet)
				EndIf

				//Devolu็ใo
				If Empty(cRet) .And. SubStr(AllTrim(oDet[x]:_Prod:_CFOP:TEXT),2,3) $ cXXCF_D
					cRet := "D"
					x := Len(oDet)
				EndIf
			Next x

		EndIf

		//Normal
		If Empty(cRet) .And. lIdeOk .And. !Empty(oIde:Text)
			cRet := "N"
		EndIf

		If Empty(cRet)
			cRet := "X"
		EndIf

	Otherwise

	EndCase

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MailReceive()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function MailReceive(anMsgNumber, acFrom, acTo, acCc, acBcc, acSubject, acBody, aaFiles, acPath, alDelete, alUseTLSMail, alUseSSLMail)
	*-----------------------------------------------------------*

	local oMessage
	local nInd
	local nCount
	local cFilename
	local aAttInfo

	default acFrom := ""
	default acTo := ""
	default acCc := ""
	default acBcc := ""
	default acSubject := ""
	default acBody := ""
	default acPath  := ""
	default alDelete := .f.
	default aaFiles := { }
	default alUseTLSMail := .f.
	default alUseSSLMail := .f.

	oMessage := TMailMessage():New()
	oMessage:Clear()
	__MailError := oMessage:Receive(__MailServer, anMsgNumber)
	if __MailError == 0
		acFrom := oMessage:cFrom
		acTo := oMessage:cTo
		acCc := oMessage:cCc
		acBcc := oMessage:cBcc
		acSubject := oMessage:cSubject
		acBody := oMessage:cBody

		nCount := 0
		for nInd := 1 to oMessage:getAttachCount()
			aAttInfo := oMessage:getAttachInfo(nInd)
			//Somente arquivo .XML
			If ".XML" $ Upper(aAttInfo[1])
				if empty(aAttInfo[1])
					aAttInfo[1] := "ATT.DAT"
				endif
				cFilename := acPath + "\" + aAttInfo[1]
				while file(cFilename)
					nCount++
					cFilename := acPath + "\" + substr(aAttInfo[1], 1, at(".", aAttInfo[1]) - 1) + strZero(nCount, 3) +;
						substr(aAttInfo[1], at(".", aAttInfo[1]))
				enddo
				nHandle := FCreate(cFilename)
				if nHandle == 0
					__MailError := 2000
					return .f.
				endif
				FWrite(nHandle, oMessage:getAttach(nInd))
				FClose(nHandle)
				aAdd(aaFiles, { cFilename, aAttInfo[2]})
			EndIf
		Next nInd

		if alDelete
			__MailServer:DeleteMsg(anMsgNumber)
		endif
	endif

return( __MailError == 0 )

//+-----------------------------------------------------------------------------------//
//|Funcao....: MailPopOn()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function MailPopOn(cServer,cUser,cPassword,nTimeOut)
	*-----------------------------------------------------------*

	Default nTimeOut := 30

	__MailError	 := 0
	if valType(__MailServer) == "U"
		__MailServer := TMailManager():New()
	endif


	__MailServer:SetUseTLS( .T. )  // MAS - Adicionao DOMEX - EXCHANGE

	__MailServer:Init(cServer, '', cUSer, cPassword )
	__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
	__MailError := __MailServer:PopConnect( )

Return( __MailError == 0 )

//+-----------------------------------------------------------------------------------//
//|Funcao....: MailPopOff()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function MailPopOff()
	*-----------------------------------------------------------*

	__MailError := __MailServer:PopDisconnect()

Return( __MailError == 0 )





	*-----------------------------------------------------------*
//aqui vai conectar com imap
Static Function MailImapConn ( cServer, cUser, cPassword, nTimeOut , cPortRec, lSSL)
	*-----------------------------------------------------------*
	Local nResult := 0
	Default nTimeOut := 15

	__MailError	 := 0
	If ValType(__MailServer) == "U"
		__MailServer := TMailManager():New()
	Endif
//TMailManager(): Init ( < cMailServer>, < cSmtpServer>, < cAccount>, < cPassword>, [ nMailPort], [ nSmtpPort] )
	if lSSL
		__MailServer:SetUseSSL( lSSL )
	endif
	__MailServer:Init(AllTrim(cServer),'', AllTrim(cUSer), AllTrim(cPassword) ,Val(cPortRec))
	__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
	__MailError := __MailServer:ImapConnect()

	If __MailError <> 0
		MsgAlert("Erro de Conexao na conta de Email.  M้todo TMailManager : "   + str(__MailError))
	Endif

Return( __MailError == 0 )


//desconectar o IMAP
	*-----------------------------------------------------------*
Static Function MailImapOff()
	*-----------------------------------------------------------*
	__MailError := __MailServer:ImapDisconnect()
Return( __MailError == 0 )


//+-----------------------------------------------------------------------------------//
//|Funcao....: PopMsgCount()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static function PopMsgCount(nMsgCount)
	*-----------------------------------------------------------*

	nMsgCount := 0
	__MailError := __MailServer:GetNumMsgs(@nMsgCount)

Return( __MailError == 0 )

//+-----------------------------------------------------------------------------------//
//|Funcao....: fWfGerXml()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//


	*-----------------------------------------------------------*
Static Function fWfGerXml(cTitulo, cAssunto, cMsg)
	*-----------------------------------------------------------*

	Local c_FileOrig := AllTrim(SuperGetMV( "MX_MR_HTML", , "\workflow\modelos\aviso_prenota.htm" )) //modelo html que serแ usado pra disparar os workflow
	Local c_FileDest :="C:\TEMP\aviso_prenf.html"
	Local _cPara := AllTrim(SuperGetMV( "MX_MR_MAIL", , "xxxx@gmail.com;"              )) //E-mail dos usuแrios que serใo notificados quando uma NF for gerada
	Local _cCc	 := "" 					 //E-mail dos usuแrios que receberao c๓pia
	Local cArquivo:= ""

//Veritica se arquivo HTML existe no caminho informado
	If !File(c_FileOrig)
		MsgAlert("Arquivo informado no parametro MX_MR_HTML nใo existe"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor corrigir para envio correto do workflow.")
		Return
	EndIf

//_cPara := AllTrim(UsrRetMail(__cUserID))
	_cTitMail:=  cAssunto
	c_texto	:= "" //cMsg

	Mensag := cMsg
	DataEnv:= "" //ddatabase

	fArq(c_FileOrig, c_FileDest)

	U_MRSMailto(_cTitMail,c_texto,_cPara,_cCc,"")

Return



/*

*-----------------------------------------------------------*
Static Function fWfGerXml(cTitulo, cAssunto, cMsg)
*-----------------------------------------------------------*

Local cToFull := ""
Local cToMail := AllTrim(SuperGetMV( "MX_MR_MAIL", , "xxxx@gmail.com;"              )) //E-mail dos usuแrios que serใo notificados quando uma NF for gerada
Local cMdHtml := AllTrim(SuperGetMV( "MX_MR_HTML", , "\workflow\modelos\aviso_prenota.htm" )) //modelo html que serแ usado pra disparar os workflow

Private oHtml
Private oProcess

//Veritica se arquivo HTML existe no caminho informado
	If !File(cMdHtml)
MsgAlert("Arquivo informado no parametro MX_MR_HTML nใo existe"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor corrigir para envio correto do workflow.")
Return
	EndIf

cToFull := AllTrim(UsrRetMail(__cUserID))
cToFull += IIf(Empty(cToFull),"",";")+cToMail

oProcess:=TWFProcess():New("00001",OemToAnsi(cTitulo))
oProcess:NewTask("000001",cMdHtml)
oHtml:=oProcess:oHtml

oProcess:ClientName(cUserName)
oProcess:cTo      := cToFull
oProcess:UserSiga := "000000"
oProcess:cSubject := cAssunto

oProcess:oHtml:ValByName( "Mensag"			, cMsg			)
oProcess:oHtml:ValByName( "DataEnv"			, DtoC(Date())	)

//Envia e-mail
oProcess:Start()
oProcess:Finish()

Return

*/

//+-----------------------------------------------------------------------------------//
//|Funcao....: fWfGerXml()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------------------------*
Static Function fAjustTipo()
	*-----------------------------------------------------------*

	Local cTab1    := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local aArea    := (cTab1)->(GetArea())
	Local nRecno   := 0
	Local cTipoDoc := ""
	Local cQuery   := " SELECT R_E_C_N_O_ AS "+cAls1+"_RECNO FROM "+RetSqlName(cTab1)+" WHERE D_E_L_E_T_ = '' AND "+cAls1+"_STATUS != '3' "
	Private oXML   := Nil

//Fecha area se estiver em uso
	If Select("SQL") > 0 ; SQL->(dbCloseArea()) ; Endif

//Monta area de trabalho executando a Query
		TcQuery cQuery ALIAS "SQL" NEW

		DbSelectArea("SQL")
		SQL->(DbGoTop())
		Count To nReg
		ProcRegua(nReg)

		SQL->(DbGoTop())
		While SQL->(!Eof())

			//Processa contador
			IncProc()

			//Posiciona no registro
			nRecno := SQL->&(cAls1+"_RECNO")
			(cTab1)->(DbGoTo(nRecno))

			//Prepara String XML para tornar em Objeto
			cMmXml   := ""
			cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
			cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))

			cAviso   := ""
			cErro    := ""
			oXML     := Nil
			oXML     := XmlParser(cMmXml,"_",@cAviso,@cErro)

			If Type('oXML:_NFEPROC') <> "U"
				cTipoDoc := ""
				cTipoDoc := fVTipoDoc(oXML,"NFE")

				If !Empty(cTipoDoc)
					Reclock(cTab1,.F.)
					&(cAls1+"_TIPDOC") := cTipoDoc
					(cTab1)->( MsUnlock() )
				EndIf
			EndIf

			SQL->(DbSkip())
		End

		Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fAjustHrUF()
//|Autor.....: Felipe Aur้lio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/mar็o de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observa็ใo:
//+-----------------------------------------------------------------------------------//
		*-----------------------------------------------------------*
Static Function fAjustHrUF()
	*-----------------------------------------------------------*

	Local cTab1    := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local aArea    := (cTab1)->(GetArea())
	Local nRecno   := 0
	Local cTipo    := ""
	Local cHora    := ""
	Local cUF      := ""
	Local cCid     := ""
	Local cQuery   := " SELECT R_E_C_N_O_ AS "+cAls1+"_RECNO FROM "+RetSqlName(cTab1)+" WHERE D_E_L_E_T_ = '' AND "+cAls1+"_DEUF = '' "
	Private oXML   := Nil

//Fecha area se estiver em uso
	If Select("SQL") > 0
		SQL->(dbCloseArea())
	Endif

//Monta area de trabalho executando a Query
	TcQuery cQuery ALIAS "SQL" NEW

	DbSelectArea("SQL")
	SQL->(DbGoTop())
	Count To nReg
	ProcRegua(nReg)

	SQL->(DbGoTop())
	While SQL->(!Eof())

		//Processa contador
		IncProc()

		//Limpa variaveis
		cTipo    := ""
		cHora    := ""
		cUF      := ""
		cCid     := ""

		//Posiciona no registro
		nRecno := SQL->&(cAls1+"_RECNO")
		(cTab1)->(DbGoTo(nRecno))

		//Prepara String XML para tornar em Objeto
		cMmXml   := ""
		cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
		cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))

		cAviso   := ""
		cErro    := ""
		oXML     := Nil
		oXML     := XmlParser(cMmXml,"_",@cAviso,@cErro)

		If Empty(cAviso) .AND. Empty(cErro)
			Do Case
			Case Type('oXML:_NFEPROC') <> "U"
				cTipo    := "NFE"
				cUF      := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				If Type('oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT') <> "U"
					cData    := oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT
					cHora    := SubStr(cData,12)
				Else
					cData    := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT
					cHora    := SubStr(cData,12)
				EndIf

			Case Type('oXML:_CTEPROC') <> "U"
				cTipo    := "CTE"
				cUF      := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				cData    := oXML:_CTEPROC:_PROTCTE:_INFPROT:_DHRECBTO:TEXT
				cHora    := SubStr(cData,12)

			Case Type('oXML:_PROCCANCNFE') <> "U"
				cTipo := "CAN"
				cUF      := ""
				cCid     := ""
				cData    := oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_DHRECBTO:TEXT
				cHora    := ""

			Case Type('oXML:_PROCEVENTONFE') <> "U"
				cTipo    := "CCE"
				cUF      := ""
				cCid     := ""
				cData    := oEvento:_INFEVENTO:_DHEVENTO:TEXT
				cHora    := ""

			Otherwise
				cTipo := "XXX"

			EndCase

			If (cTipo $ "NFE/CTE")
				Reclock(cTab1,.F.)
				&(cAls1+"_HREMIS ") := cHora
				&(cAls1+"_DEUF   ") := cUF
				&(cAls1+"_DECIDAD") := cCid
				(cTab1)->( MsUnlock() )
			EndIf

		EndIf

		SQL->(DbSkip())
	End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณGXNVisNF  บAutor  ณMarco Aurelio Silva บ Data ณ  23/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza o Documento fiscal, caso haja.                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GXNVisNF()

	Local aArea    := GetArea()
	Local cTab1		:= AllTrim(GetMV("MX_MRALS01"))
	Local cAls1		:= IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cPref    := "NF-e"
	Local cTAG     := "NFE"

// Necessario para Visualizar NF de entrada
	if (cTab1)->&(cAls1+"_TIPXML") == "1"		// NF-e = Modelo:55
		cPref   := "NF-e"
		cTAG    := "NFE"
	ElseIf (cTab1)->&(cAls1+"_TIPXML") == "2"	// CT-e = Modelo:57
		cPref   := "CT-e"
		cTAG    := "CTE"
	EndIf

	cChaveXml := (cTab1)->&(cAls1+"_CHVNFE")

	DbSelectArea("SF1")
	DbSetOrder(8)

	If DbSeek(xFilial("SF1")+cChaveXml)
		nReg := SF1->(Recno())
		cCadastro:= "Gestor XML - Visualizar Documento Entrada"
		A103NFiscal("SF1",SF1->(Recno()),2,.F.,.F.)
	Else
		Aviso("Aten็ใo","Documento de Entrada nใo localizado.",{"OK"},2)
	EndIf

	RestArea(aArea)

Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGerSA5   บAutor  ณMarco Aurelio       บ Data ณ  13/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Amarracao Atraves de Tela Padrao(SA5/SA7)             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGerSA5

// Se for CTE, nao faz amarracao
	if (cTab1)->&(cAls1+"_TIPXML") $ "2"
		return
	endif

//Campos Customizados referente a conversใo da unidade de medida
	lFatorCnv := .F.
	cCpoUmXml := AllTrim(IIf(lEhFornec,GetMV("MX_MRSA501"),GetMV("MX_MRSA701")))
	cCpoFCNum := AllTrim(IIf(lEhFornec,GetMV("MX_MRSA502"),GetMV("MX_MRSA702")))
	cCpoFCTip := AllTrim(IIf(lEhFornec,GetMV("MX_MRSA503"),GetMV("MX_MRSA703")))

	If !Empty(fX3Ret(cCpoUmXml,"X3_CAMPO")) .And.;
			!Empty(fX3Ret(cCpoFCNum,"X3_CAMPO")) .And.;
			!Empty(fX3Ret(cCpoFCTip,"X3_CAMPO"))
		lFatorCnv := .T.
	EndIf

	oItens := IIf(Type("oNF:_InfNfe:_Det")=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
	For x := 1 To Len(oItens)

		//------------------------------------------------------------
		//Variavel usada pra conseguir tratar via Type
		oItemTemp  := Nil
		oItemTemp  := oItens[x]
		//------------------------------------------------------------

		cXmlPrdCod := AllTrim(oItemTemp:_Prod:_cProd:TEXT)
		cXmlPrdDes := AllTrim(oItemTemp:_Prod:_xProd:TEXT)
		cXmlPrdNcm := AllTrim(oItemTemp:_Prod:_NCM:TEXT  )
		cXmlUniMed := AllTrim(oItemTemp:_Prod:_uCom:TEXT )
		cCodProdut := ""
		lVldProdut := .T.
		cVldMensag := ""

		If lEhFornec
			//Tratando tamanho do conteudo do campo
			cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"1")

			SA5->(DbSetOrder(14))
			If SA5->(DbSeek(xFilial("SA5") + cCodCliFor + cLojCliFor + cXmlPrdCod  ))
				cCodProdut := SA5->A5_PRODUTO
				If lFatorCnv
					If Empty(&("SA5->"+cCpoUmXml)) .Or. Empty(&("SA5->"+cCpoFCNum)) .Or. Empty(&("SA5->"+cCpoFCTip)) .Or. AllTrim(cXmlUniMed) != AllTrim(&("SA5->"+cCpoUmXml))
						lVldProdut := .F.
						cVldMensag := "O produto ( "+alltrim(cXmlPrdCod)+" ) do Fornecedor estแ com cadastro incompleto na tabela de relacionamento de produtos [SA5]!"
						fGravaMsg(nRecTab1,98," ",cVldMensag)
						lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,SA5->(Recno()))
					EndIf
				EndIf
			Else
				lVldProdut := .F.
				cVldMensag := "O produto ( "+alltrim(cXmlPrdCod)+" ) do Fornecedor nใo estแ cadastrado na tabela de relacionamento de produtos [SA5]!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)
				lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,Nil)
			EndIf
		Else
			//Tratando tamanho do conteudo do campo
			cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"2")

			SA7->(DbSetOrder(3))
			If SA7->(DbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + cXmlPrdCod  ))
				cCodProdut := SA7->A7_PRODUTO
				If lFatorCnv
					If Empty(&("SA7->"+cCpoUmXml)) .Or. Empty(&("SA7->"+cCpoFCNum)) .Or. Empty(&("SA7->"+cCpoFCTip)) .Or. AllTrim(cXmlUniMed) != AllTrim(&("SA7->"+cCpoUmXml))
						lVldProdut := .F.
						cVldMensag := "O produto ("+cXmlPrdCod+") do Cliente esta com cadastro incompleto na tabela de relacionamento de produtos [SA7]!"
						fGravaMsg(nRecTab1,98," ",cVldMensag)
						lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,SA7->(Recno()))
					EndIf
				EndIf
			Else
				lVldProdut := .F.
				cVldMensag := "O produto ("+cXmlPrdCod+") do Cliente nใo estแ cadastrado na tabela de relacionamento de produtos [SA7]!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)
				lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut)
			EndIf
		EndIf

		//Valida se produto existe na tabela SA1
		If lVldProdut
			SB1->(dbSetOrder(1))
			If SB1->(!dbSeek(xFilial("SB1")+cCodProdut))
				lVldProdut := .F.
				cVldMensag := "O produto ( "+alltrim(cCodProdut)+" ) informado na rotina de produto x "+IIf(lEhFornec,"fornecedor","cliente")+" nใo existe no cadastro de produtos ou estแ com cadastro incompleto!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)
			EndIf
		EndIf

		//Valida se produto na tabela SA1 estแ bloqueado
		If lVldProdut
			If SB1->B1_MSBLQL == "1"
				lVldProdut := .F.
				cVldMensag := "O produto ( "+alltrim(cCodProdut)+" ) estแ bloqueado no cadastro de produtos!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)
			EndIf
		EndIf

		//Cancela opera็ใo pois tem que ajustar cadastro
		If !lVldProdut
			x := Len(oItens)
			lProc := .F.
		EndIf

	Next x

Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ  
//ณ 																ณ
//ณ ##  Amarracao do FATOR DE CONVERSAO   ##  		ณ
//ณ 																ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fFatorConv()
	Local N1 := 0

	For x := 1 to Len(oXXGetDad:aCols)
		If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
			N1 := x
			Exit
		EndIf
	Next x

	If !Empty(N1)
		//lEhFornec
		//nRecTab1
		cXmlPrdCod := oXXGetDad:aCols[N1][nXXPRODXML]
		cXmlPrdDes := oXXGetDad:aCols[N1][nXXDESCRIC]
		cXmlPrdNcm := aPrdNcm[N1]
		cXmlUniMed := oXXGetDad:aCols[N1][nXXUM]
		//cCodCliFor
		//cLojCliFor
		//cNomCliFor
		cCodProdut := oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXPRODUTO]
		nRecA5A7   := 0
		nFator     := oXXGetDad:aCols[N1][nXXFATOR]
		cTipoFat   := ""

		lRetFunc   := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,nRecA5A7,@nFator,@cTipoFat)
		If !lRetFunc
			MsgStop("Nใo ้ possํvel marcar um Produto sem fator de conversใo.")
			_Retorno := .F.
		Else
			For x := 1 to Len(oXXGetDad:aCols)
				If oXXGetDad:aCols[x][nXXPRODXML] == cXmlPrdCod
					oXXGetDad:aCols[x][nXXPRODUTO] := cCodProdut
					oXXGetDad:aCols[x][nXXFATOR  ] := nFator
					oXXGetDad:aCols[x][nXXTPFATOR] := cTipoFat
					If cTipoFat == 'M'
						oXXGetDad:aCols[x][nXXQTD1] := Round(oXXGetDad:aCols[x][nXXQTD2] * nFator,4)
					EndIf
					If cTipoFat == 'D'
						oXXGetDad:aCols[x][nXXQTD1] := Round(oXXGetDad:aCols[x][nXXQTD2] / nFator,4)
					EndIf
				EndIf
			Next x
			nTotNF := oXXGetDad:aCols[N1][nXXQTD1]
			oXXGetDad:Refresh()
			oTotNF:Refresh()
		EndIf
	Else
		MsgStop("Marque um item de NF para fazer manuten็ใo no Fator de Conversใo.")
	EndIf

Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ  
//ณ 																ณ
//ณ ##  Validacao de Campo  ##  							ณ
//ณ 																ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function fXXVldCpo()
	Local _Retorno := .T.
	Local cCampo   := Alltrim(ReadVar())
	Local N        := oXXGetDad:oBrowse:nAt

	If cCampo == "M->XX_CC"
		If Empty(oXXGetDad:aCols[N,nXXPEDIDO])
			_Retorno := ExistCpo('CTT')
		Else
			MsgStop("Nใo ้ possํvel alterar o Centro de Custos quando existe associa็ใo a um Pedido de Compras.")
			_Retorno := .F.
		EndIf
		If _Retorno
			For _nx := (N+1) to Len(oXXGetDad:aCols)
				If Empty(oXXGetDad:aCols[_nx,nXXPEDIDO])
					oXXGetDad:aCols[_nx,nXXCC] := M->XX_CC
				EndIf
			Next _nx
			oXXGetDad:Refresh()
		EndIf
	EndIf

	If cCampo == "M->XX_LOCAL"
		If Empty(oXXGetDad:aCols[N,nXXPEDIDO])
			_Retorno := ExistCpo('NNR')
		Else
			MsgStop("Nใo ้ possํvel alterar o Almoxarifado quando existe associa็ใo a um Pedido de Compras.")
			_Retorno := .F.
		EndIf
		If _Retorno
			For _nx := (N+1) to Len(oXXGetDad:aCols)
				If Empty(oXXGetDad:aCols[_nx,nXXPEDIDO])
					oXXGetDad:aCols[_nx,nXXLOCAL] := M->XX_LOCAL
				EndIf
			Next _nx
			oXXGetDad:Refresh()
		EndIf
	EndIf

Return _Retorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma    ณ fArq      ณ Funcao para gravacao buffer arquivo HTML.                    บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fArq(c_FileOrig, c_FileDest)

	Local l_Ret 	:= .T.
	Local c_Buffer	:= ""
	Local n_Posicao	:= 0
	Local n_QtdReg	:= 0
	Local n_RegAtu	:= 0

	If !File(c_FileOrig)
		l_Ret := .F.
		MsgStop("Arquivo [ "+c_FileOrig+" ] nใo localizado.", "Nใo localizou")
	Else

		Ft_fuse( c_FileOrig ) 		// Abre o arquivo
		Ft_FGoTop()
		n_QtdReg := Ft_fLastRec()
		nHandle	:= MSFCREATE( c_FileDest )

		///////////////////////////////////
		// Carregar o array com os itens //
		///////////////////////////////////
		While !ft_fEof() .And. l_Ret
			c_Buffer := ft_fReadln()

			FWrite(nHandle, &("'" + c_Buffer + "'"))
			c_texto += &("'" + c_Buffer + "'")
			ft_fSkip()
		Enddo
		FClose(nHandle)
	EndIf

Return l_Ret


Static Function fRelNF()

	print oprn preview

	oprn:SetLandscape() // SetLandscape() ou SetPortrait()

	define font ofntN08  name "Courier New" /*bold*/ size 0,08 of oprn
	define font ofntB08  name "Courier New" bold     size 0,08 of oprn

	define font ofntN09  name "Courier New" /*bold*/ size 0,09 of oprn
	define font ofntB09  name "Courier New" bold     size 0,09 of oprn

	define font ofntN10  name "Courier New" /*bold*/ size 0,10 of oprn
	define font ofntB10  name "Courier New" bold     size 0,10 of oprn

	define font ofntN11  name "Courier New" /*bold*/ size 0,11 of oprn
	define font ofntB11  name "Courier New" bold     size 0,11 of oprn

	define font ofntN12  name "Courier New" /*bold*/ size 0,12 of oprn
	define font ofntB12  name "Courier New" bold     size 0,12 of oprn

	Private li       := 0     // 93
	Private aMargem := {00,00,46,126}   // 61

	Cabec()

	nItem := 0
	For _nX := 1 to Len(oXXGetDad:aCols)
		nItem++
		If lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIf

		@Li,00 Psay oXXGetDad:aCols[_nX,aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_ITEMXML" })]  Font ofntN08
		@Li,04 Psay oXXGetDad:aCols[_nX,aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_PRODXML" })]  Font ofntN08
		@Li,13 Psay Substr(oXXGetDad:aCols[_nX,aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_DESCRIC" })],1,46)  Font ofntN08
		@Li,46 Psay Transform(oXXGetDad:aCols[_nX,aScan(oXXGetDad:aHeader,{|x|AllTrim(x[2])=="XX_QTD2"    })],"@E 999,999.9999")  Font ofntN08

		Li++
		@ Li,aMargem[2] to Li,aMargem[4]
		Li++

		If nItem >= 19
			nItem := 0

			oprn:EndPage()
			oprn:StartPage()

			Cabec()
		EndIf
	Next _nX

	For _nY := _nX to 19
		Li++
		@ Li,aMargem[2] to Li,aMargem[4]
		Li++
	Next _nY

	endprint

	ofntN08:end()
	ofntN09:end()
	ofntN10:end()
	ofntN11:end()
	ofntN12:end()

	ofntB08:end()
	ofntB09:end()
	ofntB10:end()
	ofntB11:end()
	ofntB12:end()

Return NIL


Static Function Cabec()

	li       := 0     // 93
	@ Li,aMargem[2] to Li,aMargem[4]
	Li++

	cLogoTp		:= GetSrvProfString("Startpath","") + "lgrl01.bmp"				//Insira o caminho do Logo da empresa, na variavel cLogoTp.
	oprn:SayBitmap(120, 070,cLogoTp,0300,0100 )	       	//Logo

	@Li,((aMargem[4]/2)-25) Psay "FORMULมRIO 1 - CONTROLE DE RECEBIMENTO DE PRODUTOS" Font ofntB12
	@Li,(aMargem[4]-25) Psay "Impressใo:" + Subs(DTOC(DATE()),1,6)+Subs(Alltrim(Str(Year(DATE()))),3,2)+' '+Subs(TIME(),1,5) Font ofntB10

	Li++
	@ Li,aMargem[2] to Li,aMargem[4]
	Li++
	@Li,02 Psay "Fornecedor: " + Posicione("SA2",1,xFilial("SA2")+cLinkForCd+cLinkForLj,"A2_NOME") Font ofntB10
	@Li,(aMargem[4]-25) Psay "CNPJ: " + Transform(Posicione("SA2",1,xFilial("SA2")+cLinkForCd+cLinkForLj,"A2_CGC"),"@R 99.999.999/9999-99")  Font ofntB10
	Li++
	@Li,02 Psay "Nota Fiscal/S้rie: " + cNfRelat    Font ofntB10
	@Li,(aMargem[4]-25) Psay "Local:___________"  Font ofntB10
	Li++
	@Li,02 Psay "Data Recebimento:  ____/____/____" Font ofntB10
	@Li,(aMargem[4]-25) Psay "Hora: _____:_____"                 Font ofntB10
	Li++
	@ Li,aMargem[2] to Li,aMargem[4]
	Li++

	oPr := oprn

	@ aMargem[1],aMargem[2] to aMargem[3],aMargem[4]

	nLinIni := 06
	nLinFim := aMargem[3]

	incLinini := 0
	incCol    := 10

	nCol := 0 //1
	@Li,nCol Psay "ITEM"           Font ofntB09
	nCol += 4 //4
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "COD.PROD."      Font ofntB09
	nCol += 9 //7
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "DESCRIวรO"      Font ofntB09
	nCol += 33
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "QTD. NF"        Font ofntB09
	nCol += 10
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "QTD.RECEBIDA"  Font ofntB08
	nCol += 9
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "DT.FABRIC" Font ofntB08  //"DT.FABRIC/LOTE"
	nCol += 07
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "VALIDADE"       Font ofntB08
	nCol += 08
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "TEMPERAT."    Font ofntB08  //"TEMPERATURA"
	nCol += 07
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "COR"            Font ofntB08
	nCol += 04
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "ODOR"           Font ofntB08
	nCol += 04
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "APARสNC"      Font ofntB08  //"APARสNCIA"
	nCol += 06
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "EMBALA."      Font ofntB08
	nCol += 06
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "ROTUL."      Font ofntB08
	nCol += 06
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "ENTREG."     Font ofntB08
	nCol += 06
	oprn:box((nLinIni*50+100)+incLinini, nCol*25+40-incCol, nLinFim*50+100 , nCol*25+40-incCol)
	@Li,nCol Psay "VEอCULO"        Font ofntB08

	Li++
	@ Li,aMargem[2] to Li,aMargem[4]
	Li++

Return

Static Function fSalvaZZ3()

	Local x

	Local cTab1 := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cTab3 := AllTrim(GetMV("MX_MRALS03"))
	Local cAls3 := IIf(SubStr(cTab3,1,1)=="S",SubStr(cTab3,2,2),cTab3)
	Local aArea := (cTab3)->(GetArea())

	// MAURESI - DESABILITADO TEMPORARIAMENTE - DOMEX - 14/07/2021
	if .t.
		return
	endif


	(cTab3)->( dbSetOrder(1) )

	For x := 1 to len(oXXGetDad:aCols)
		If !Empty(oXXGetDad:aCols[x][nXXPEDIDO]) .And. !Empty(oXXGetDad:aCols[x][nXXITEMPC])
			If (cTab3)->( dbSeek( xFilial() + (cTab1)->&(cAls1+"_CHVNFE") + oXXGetDad:aCols[x][nXXITEMXML] ) )
				Reclock(cTab3,.F.)
				(cTab3)->&(cAls3+"_PEDIDO") := oXXGetDad:aCols[x][nXXPEDIDO]
				(cTab3)->&(cAls3+"_ITEMPC") := oXXGetDad:aCols[x][nXXITEMPC]
				(cTab3)->&(cAls3+"_QTD")    := oXXGetDad:aCols[x][nXXQTD1]
				(cTab3)->( msUnlock() )
			Else
				Reclock(cTab3,.T.)
				(cTab3)->&(cAls3+"_FILIAL") := xFilial(cTab3)
				(cTab3)->&(cAls3+"_CHVNFE") := (cTab1)->&(cAls1+"_CHVNFE")
				(cTab3)->&(cAls3+"_ITEMXM") := oXXGetDad:aCols[x][nXXITEMXML]
				(cTab3)->&(cAls3+"_SEQ")    := ''
				(cTab3)->&(cAls3+"_PEDIDO") := oXXGetDad:aCols[x][nXXPEDIDO]
				(cTab3)->&(cAls3+"_ITEMPC") := oXXGetDad:aCols[x][nXXITEMPC]
				(cTab3)->&(cAls3+"_QTD")    := oXXGetDad:aCols[x][nXXQTD1]
				(cTab3)->( msUnlock() )
			EndIf
		EndIf
	Next x

Return


Static Function fRestSalva()
	Local x, y
	Local cTab1 := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cTab3 := AllTrim(GetMV("MX_MRALS03"))
	Local cAls3 := IIf(SubStr(cTab3,1,1)=="S",SubStr(cTab3,2,2),cTab3)

	(cTab3)->( dbSetOrder(2) )

	For Y := 1 to Len(oYYGetDad:aCols)
		If (cTab3)->( dbSeek( xFilial() + (cTab1)->&(cAls1+"_CHVNFE") + oYYGetDad:aCols[Y,nYYPEDIDO] + oYYGetDad:aCols[Y,nYYITEMPC]) )
			For X := 1 to Len(oXXGetDad:aCols)
				If oXXGetDad:aCols[x][nXXITEMXML] == (cTab3)->&(cAls3+"_ITEMXM")
					If Empty(oXXGetDad:aCols[X][nXXPEDIDO]) .And. Empty(oXXGetDad:aCols[X][nXXITEMPC])

						oXXGetDad:aCols[X][nXXPEDIDO] := oYYGetDad:aCols[Y,nYYPEDIDO]
						oXXGetDad:aCols[X][nXXITEMPC] := oYYGetDad:aCols[Y,nYYITEMPC]

						oXXGetDad:aCols[X,nXXLOCAL  ] := oYYGetDad:aCols[Y][nYYLOCAL ]
						if _lTesInt
							oXXGetDad:aCols[X,nXXOPER   ] := oYYGetDad:aCols[Y][nYYOPER  ]

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณRetorna TES Inteligenteณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							_cOper	:= oYYGetDad:aCols[Y][nYYOPER  ]
							if U_VALIDACAO()  // MAURESI 23/09/2021
								if _lDmxFilial
									_cOper	:= "01"
								endif
							endif
							_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)
							oXXGetDad:aCols[X,nXXTES    ] := _cTesEnt
							//
						endif
						oXXGetDad:aCols[X,nXXCC     ] := oYYGetDad:aCols[Y][nYYCC    ]

						If oYYGetDad:aCols[Y][nYYSALDO] > oXXGetDad:aCols[X][nXXQTD1 ]
							oYYGetDad:aCols[Y][nYYSALDO] -= oXXGetDad:aCols[X][nXXQTD1]
						Else
							oYYGetDad:aCols[Y][nYYSALDO] := 0
						EndIf

						If oYYGetDad:aCols[Y][nYYSALDO] == 0
							oYYGetDad:aCols[Y][nYYLEGENDA] := c2Leg2
						Else
							oYYGetDad:aCols[Y][nYYLEGENDA] := ""
						EndIf
					EndIf
				EndIf
			Next y
		EndIf
	Next x

Return

Static Function fIncLCBot(nLinBot,nColBot)
	Local aPos := {}
	Local nLin, nCol, nIncLin, nIncCol
	nIncLin := 15
	nIncCol := 150

	nLin := nLinPrBot
	nCol := nColPrBot

	AADD(aPos,{nLin,nCol})
	nLin += nIncLin
	AADD(aPos,{nLin,nCol})
	nLin -= nIncLin
	nCol += nIncCol
	AADD(aPos,{nLin,nCol})
	nLin += nIncLin
	AADD(aPos,{nLin,nCol})
	nLin -= nIncLin
	nCol += nIncCol
	AADD(aPos,{nLin,nCol})
	nLin += nIncLin
	AADD(aPos,{nLin,nCol})
	nLin -= nIncLin
	nCol += nIncCol
	AADD(aPos,{nLin,nCol})
	nLin += nIncLin
	AADD(aPos,{nLin,nCol})
	nLin -= nIncLin
	nCol += nIncCol
	AADD(aPos,{nLin,nCol})
	nLin += nIncLin
	AADD(aPos,{nLin,nCol})
	nLin -= nIncLin
	nCol += nIncCol

	n := aScan(aPos,{ |aVet| aVet[1] == nLinBot .and. aVet[2] == nColBot  })

	nLinBot := aPos[n+1,1]
	nColBot := aPos[n+1,2]

Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ  
//ณ 																ณ
//ณ ##  Amarra TES Inteligente  ##  		 			|		
//ณ 																ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function fEditTes()

	Local N1 := 0
	Private cCadTES
	Private cCadOPER

	For x := 1 to Len(oXXGetDad:aCols)
		If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
			N1 := x
			Exit
		EndIf
	Next x

	If !Empty(N1)

		cCodProdut := oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXPRODUTO]
		if empty(Alltrim(cCodProdut))
			MsgStop("Precisa haver primeiro amarra็ใo com um Produto.")
			Return
		Endif

		cCadOPER		:= oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXOPER]
		cCadTES		:= oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXTES]
		cFullOper	:= cCadOPER	// Utilizado para Gravar Operacao no retorno da TES Intigente
		lRetFunc   := 	fGerRlcTES(cCodCliFor,cLojCliFor,cNomCliFor,cCadOPER,cCadTES)

	Else
		MsgInfo("Marque um item de NF para fazer manuten็ใo na TES INTELIGENTE.")
	EndIf

Return


Static Function fGerRlcTES(cCodCliFor,cLojCliFor,cNomCliFor,cCadOPER,cCadTES)


	//Variaveis do tamanho a tela
	Local aDlgTela     := {000,000,343,505} //{000,000,410,505} //{000,000,343,505}

	//Divis๕es dentro da tela
	Local aDlgCabc     := {005,005,040,250}
	Local aDlgCorp1    := {045,005,092,250}
	Local aDlgCorp2    := {097,005,130,250} //{097,005,144,250}
	Local aDlgCorp3    := {149,005,174,250}
	Local aDlgRodp     := {145,005,165,250}  //{179,005,199,250}

	Local nQtdCpo      := 5
	Local nTamBtn      := (aDlgRodp[4] / nQtdCpo)
	Local aBtn01       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 3) + (005) ,  nTamBtn-10, 012}
	Local aBtn02       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 4) + (000) ,  nTamBtn-10, 012}

	Local cTab4        := AllTrim(GetMV("MX_MRALS04"))
	Local cAls4        := IIf(SubStr(cTab4,1,1)=="S",SubStr(cTab4,2,2),cTab4)

	Local oDialg
	Local cStrCad      := AllTrim(GetMV("MX_MRALS04"))
	Local cTitCad      := "Amarra็ใo TES Inteligente "
	Local cPrtCad      := cTitCad+" ["+cStrCad+"]"
	Local cCpoXml      := cCodCliFor +"-"+ cLojCliFor

	Local _cFornec		 := cCodCliFor
	Local _cLojaFor    := cLojCliFor

	Local nOpcao       := 0
	Local lExiste      := .F.
	Local lReturn      := .T.
	Local lLoop        := .T.

	Default cCodProdut := Space(fX3Ret("B1_COD","X3_TAMANHO"))
	Private cCadPrdCod := cCodProdut
	//Private cCadTES	 := ""
	//Private cCadOPER	 := ""
	Private cCadPrdDes := ""


	While lLoop

		If Empty(cCadPrdCod)
			cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
			cCadPrdDes := "DESC"
		Else
			SB1->( dbSetOrder(1) )
			SB1->( dbSeek( xFilial() + cCadPrdCod ) )
			cCadPrdDes := SB1->B1_DESC
		EndIf

		if empty(cCadTES) .or. empty(cCadOPER)
			cCadTES	:= Space(03)
			cCadOPER	:= Space(02)
		endif

		// Montagem da tela que serah apresentada para usuario (lay-out)
		Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Pixel //Of oMainWnd

		//Cabec
		@ aDlgCabc[1], aDlgCabc[2] To aDlgCabc[3], aDlgCabc[4] LABEL " XML: Dados do Fornecedor " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

		@ aDlgCabc[1]+010,aDlgCabc[2]+005 Say "Codigo"            Size 030 ,008 Pixel Of oDialg
		@ aDlgCabc[1]+009,aDlgCabc[2]+035 MsGet cCpoXml           Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCabc[1]+022,aDlgCabc[2]+005 Say "Nome"              Size 030 ,008 Pixel Of oDialg
		@ aDlgCabc[1]+021,aDlgCabc[2]+035 MsGet cNomCliFor        Size 205 ,008 Pixel When .F. Of oDialg

		//Corpo 01
		@ aDlgCorp1[1], aDlgCorp1[2] To aDlgCorp1[3], aDlgCorp1[4] LABEL " XML: Dados do Produto " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

		@ aDlgCorp1[1]+010,aDlgCorp1[2]+005 Say "Produto"           Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp1[1]+009,aDlgCorp1[2]+035 MsGet cCadPrdCod        Size 085 ,008 Pixel When .F. Of oDialg

		@ aDlgCorp1[1]+034,aDlgCorp1[2]+005 Say "Descri็ใo"         Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp1[1]+033,aDlgCorp1[2]+035 MsGet cCadPrdDes        Size 205 ,008 Pixel When .F. Of oDialg

		//Corpo 02
		@ aDlgCorp2[1], aDlgCorp2[2] To aDlgCorp2[3], aDlgCorp2[4] LABEL " Informe a Opera็ใo e TES a ser utilizada na Classifica็ใo deste Produto " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

		@ aDlgCorp2[1]+010+3,aDlgCorp2[2]+005 Say "Operacao"          Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp2[1]+009+3,aDlgCorp2[2]+035 MsGet cCadOper          Size 085 ,008 Pixel When .T. Of oDialg F3 cMRSX5Oper Valid ExistCpo("SX5",cMRSX5Oper+cCadOper) //Valid(fVldRlcPrd(.F.))

		@ aDlgCorp2[1]+010+3,aDlgCorp2[2]+128 Say "TES"          		Size 030 ,008 Pixel Of oDialg
		@ aDlgCorp2[1]+009+3,aDlgCorp2[2]+155 MsGet cCadTES        	Size 085 ,008 Pixel When .T. Of oDialg F3 "SF4" Valid  ExistCpo("SF4",cCadTES)   //(Vazio() .or. fVldRlcTES()) //( Vazio() .or. ExistCpo("SF4",cCadTES)   )  //Valid(fVldRlcPrd(.F.))

		//Rodap้ / Bot๕es
//	@ aDlgRodp[1], aDlgRodp[2] To aDlgRodp[3], aDlgRodp[4] LABEL "" COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
		@ aBtn01[1],aBtn01[2] Button "Processar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
		@ aBtn02[1],aBtn02[2] Button "Cancelar"  Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())

		Activate MsDialog oDialg Centered

		//Verifica se opera็ใo foi cancelada
		If nOpcao != 1
			lLoop   := .F.
			lReturn := .F.
		EndIf

		//Valida TES / OPERACAO
		If nOpcao == 1 .And. lReturn
			If Empty(cCadOper) .or. Empty(cCadTES)
				MsgStop("Ambos os campos devem estar preenchidos.")
				lReturn := .F.
			EndIf
		EndIf

		//Caso lReturn OK, entใo sair do Loop
		If lLoop .And. lReturn
			lLoop   := .F.
		EndIf

	End


	If nOpcao == 1 .And. lReturn

		lExiste := .F.
		lReturn := .T.

		(cTab4)->( dbSetOrder(1) )
		If (cTab4)->( dbSeek(xfilial(cTab4)+cCadPrdCod+cCodCliFor+cLojCliFor+cCadOper) )
			RecLock(cTab4,.F.)
			(cTab4)->&(cAls4+"_TES1") 		:= cCadTES
			(cTab4)->&(cAls4+"_NOME1") 	:= UsrRetName(__cUserID)
			(cTab4)->&(cAls4+"_DT1") 		:= date()
		Else
			RecLock(cTab4,.T.)
			(cTab4)->&(cAls4+"_FILIAL") 	:= xfilial(cTab4)
			(cTab4)->&(cAls4+"_TIPO") 		:= cCadOper
			(cTab4)->&(cAls4+"_FORNEC") 	:= cCodCliFor
			(cTab4)->&(cAls4+"_LOJAFO") 	:= cLojCliFor
			(cTab4)->&(cAls4+"_CODPRO") 	:= cCadPrdCod
			(cTab4)->&(cAls4+"_TES1") 		:= cCadTES
			(cTab4)->&(cAls4+"_NOME1") 	:= UsrRetName(__cUserID)
			(cTab4)->&(cAls4+"_DT1") 		:= date()
		endif
		(cTab4)->( msUnlock() )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza Operacao/TES no Gridณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXOPER]	:= cCadOPER
		oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXTES]	:= cCadTES
		cFullOper	:= cCadOPER
		oXXGetDad:Refresh()

	EndIf

Return(lReturn)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProg.ORI  ณfVldRlcTESบAutor  ณFelipe Aurelio      บ Data ณ  27/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณMarco Aurelio Silva บ Data ณ  13/10/15   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldRlcTES()

	Local lOk  := .T.
	Local lRet := .F.

	If lOk .And. Empty(Alltrim(cCadTES))
		MsgAlert("TES nใo informada. Verifique!")
		lOk := .F.
	EndIf

	SF4->(dbSetOrder(1))
	If lOk
		if  SF4->(dbSeek(xFilial("SF4")+AllTrim(cCadTES)))
			if !(SF4->F4_TIPO $ "E")
				MsgAlert("Favor informar Somente TES de Opera็ao de Entrada! " )
				lOk := .F.
			endif

		else
			MsgAlert("TES "+alltrim(cCadTES)+" nใo encontrada no cadastro! " )
			lOk := .F.
		Endif
	EndIf

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNoAcento  บAutor  ณMicrosiga           บ Data ณ  01/28/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao Extraida do Fonte  nfesefaz                         บฑฑ
ฑฑบ          ณ  Retira acentuacao                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static FUNCTION NoAcento(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "แ้ํ๓๚"+"มษอำฺ"
	Local cCircu := "โ๊๎๔๛"+"ยสฮิÛ"
	Local cTrema := "ไ๋๏๖ü"+"ฤหฯึÜ"
	Local cCrase := "เ่์๒๙"+"ภศฬาู"
	Local cTio   := "ใ๕รี"
	Local cCecid := "็ว"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next

	If cMaior$ cString
		cString := strTran( cString, cMaior, "" )
	EndIf
	If cMenor$ cString
		cString := strTran( cString, cMenor, "" )
	EndIf

	cString := StrTran( cString, CRLF, " " )

Return cString



/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFun…o    ณ AjustaSX7ณ Autor ณ Marco Aurelio-OPUS 	  ณ Data ณ 09/09/19 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณ Ajuste de gatilhos 						                      ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ Uso      ณ GestorXML		                        				  		  |ฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX7()

	Local aAreaSX7 := SX7->(GetArea())
	Local cCondic  := '.F.'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Altera็ใo da condi็ใo do gatilho do campo CK_PRODUTO - SEQ: 001		 	 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SX7->(dbSeek(PADR("D1_OPER",10)+"001")) .And. Trim(Upper(SX7->X7_CONDIC)) <> cCondic
		RecLock("SX7",.F.)
		SX7->X7_CONDIC := ".F."
		SX7->(MsUnlock())
	EndIf

	If SX7->(dbSeek(PADR("D1_OPER",10)+"002")) .And. Trim(Upper(SX7->X7_CONDIC)) <> cCondic
		RecLock("SX7",.F.)
		SX7->X7_CONDIC := ".F."
		SX7->(MsUnlock())
	EndIf

	RestArea(aAreaSX7)

Return


//======================================================================================================================

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFun…o    ณ MRSACESSณ Autor ณ Marco Aurelio-OPUS 	  ณ Data ณ 27/09/19 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณ Valida Permissao de Acesso ao Sistema                      ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ Uso      ณ GestorXML		                        				  		  |ฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


Static Function MRSACESS

//Private lCliSHA   := .F.
//Private lCliDmx  	:= .F.
//Private lCliTay   := .F.
//Private lCliDIP   := .F.

	_lAcesso 	:= .F.
	dvalidade	:= "20180101"
	alAcesso		:= {}
	_DiasMsg		:= 30

// Variavel Criada /  CNPJ autorizado  / Data de Expiracao
	AADD( alAcesso,{"lCliSHA"		,"6198027200"			,"20191231"} )  	//SHA ALIMENTOS
//	AADD( alAcesso,{"lCliDmx"		,"54821137000136"		,"20221231"} )		//DOMEX - 54821137000136
	AADD( alAcesso,{"lCliDmx"		,"54821137000"			,"20221231"} )		//DOMEX - 54821137000136
	AADD( alAcesso,{"lCliTay"		,"55284939000117"		,"20191231"} )  	//TAY-Higiex - 55.284.939/0001-17
	AADD( alAcesso,{"lCliDIP"		,"1452030000"			,"20191231"} )  	//DIPACK - 14.520.300/0001-06

// Cria variaveis Logicas
	For i:= 1 to len(alAcesso)
		&(alAcesso[i,1])	:=    iif( alAcesso[i,2]     $ SM0->M0_CGC ,.T.,.F.)
	Next i

// Verifica se o CNPJ eh permitido
	For i:= 1 to len(alAcesso)
		if &(alAcesso[i,1])
			dvalidade	:= alAcesso[i,3]
			_lAcesso 	:= .T.
		endif
	Next i

// Calcula dias para Expirar Utilizacao
	_dDiasVld := Stod(dvalidade) - date()

	if _lAcesso
		if _dDiasVld >= 0 .and.  _dDiasVld < _DiasMsg
			msgInfo("O GestorXML precisa ser atualizado em at้ "+Alltrim(Str(_dDiasVld))+" dias."+Chr(13)+Chr(10)+"Procure a Consultoria!")
		elseif _dDiasVld < 0
			msgStop("O GestorXML estแ desatualizado a  "+Str(_dDiasVld)+" dias."+Chr(13)+Chr(10)+"Procure a Consultoria!")
			_lAcesso 	:= .F.
		endif
	else
		msgStop("Empresa nใo habilitada para acessar o GestorXML."+Chr(13)+Chr(10)+"Consulte a Consultoria OPUSVP.")
		_lAcesso 	:= .F.
	Endif

Return (_lAcesso)


Static Function RETSGEST(cEst)
	Local cSigla 	:= ""
	Local nPos     := 0
	Local aOptions := {}


	AADD(aOptions,{'11','RO'})
	AADD(aOptions,{'12','AC'})
	AADD(aOptions,{'13','AM'})
	AADD(aOptions,{'14','RR'})
	AADD(aOptions,{'15','PA'})
	AADD(aOptions,{'16','AP'})
	AADD(aOptions,{'17','TO'})
	AADD(aOptions,{'21','MA'})
	AADD(aOptions,{'22','PI'})
	AADD(aOptions,{'23','CE'})
	AADD(aOptions,{'24','RN'})
	AADD(aOptions,{'25','PB'})
	AADD(aOptions,{'26','PE'})
	AADD(aOptions,{'27','AL'})
	AADD(aOptions,{'28','SE'})
	AADD(aOptions,{'29','BA'})
	AADD(aOptions,{'31','MG'})
	AADD(aOptions,{'32','ES'})
	AADD(aOptions,{'33','RJ'})
	AADD(aOptions,{'35','SP'})
	AADD(aOptions,{'41','PR'})
	AADD(aOptions,{'42','SC'})
	AADD(aOptions,{'43','RS'})
	AADD(aOptions,{'50','MS'})
	AADD(aOptions,{'51','MT'})
	AADD(aOptions,{'52','GO'})
	AADD(aOptions,{'53','DF'})

	nPos := ASCAN(aOptions, {|aVal| aVal[1] == cEst})

	If nPos > 0
		cSigla := aOptions[nPos][2]
	End


Return cSigla

Static Function GeraXML()

	Local cAno := Alltrim(Str(Year(dDataBase)))
	Local cMes := Alltrim(Str(Month(dDataBase)))
	Local cDia := Alltrim(Str(Day(dDataBase)))
//	Local cPath := "C:\TEMP\" + cAno + "\" + cMes + "\" + cDia + "\"
	Local cPath := "J:\" + cAno + "\" + cMes + "\" + cDia + "\"

	MontaDir(cPath)

	cRetorno := fGerGrvXml(cPath,ZZ0->(Recno()))

	If !File(cRetorno)
		apMsgInfo("Nใo foi possํvel gravar o XML na pasta " + cPath)
	EndIf

Return cRetorno
