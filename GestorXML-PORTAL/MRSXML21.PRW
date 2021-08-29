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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MRSXML21  ºAutor  ³Marco Aurelio Silva º Data ³  18/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Portal XML - Integrado ao Gestor de XML                    º±±
±±º          ³                                                            º±±
±±º Rotinas  ³MRSXML21.PRW (principal)                                    º±±
±±º          ³MRSXMLxx.PRW (trata Exclusao Nota. Chamado pelo SD1140E     º±±
±±º          ³MRSXMLxx.PRW (Job para Baixa Email)                         º±±  
±±º          ³MRSXMLxx.PRW (Relatorio de NFs / XML)                       º±±  
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

User Function MRSXML21(cChvNfe,cStatus)

Private nRecTab1		:=	0
Private oLinkProdu
Private nTotPC      	:=	0
Private oTotPC
Private nTotNF      	:=	0
Private oTotNF
Private	nQtdNF     	:=	0
Private nAccPed     	:=	0
Private cNfRelat 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³TABELA DE CORES PROTHEUS                               ³
//³                                                       ³
//³http://erikasarti.net/html/tabela-cores/               ³
//³Private c2Leg1      := "A"              //Amarelo claro³
//³Private n2Leg1      := RGB(240,230,140) //Amarelo Claro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
Private nXXTES	    := 0  
Private nXXOPER	 := 0

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

Private nD1PEDIDO  := 0
Private nD1ITEMPC  := 0
Private nD1COD     := 0
Private nD1QUANT   := 0
Private nD1TOTAL   := 0
Private nD1VUNIT   := 0
Private nD1VALDESC := 0
Private nD1LOCAL   := 0
Private nD1CC      := 0
Private nD1TES		 := 0
Private nD1OPER	 := 0  

Private _lTagPC   := iif(AllTrim(SuperGetMv("MX_MRTAGPC",,"S")) == "S",.T.,.F.)
Private _lCodBar   	:= iif(AllTrim(SuperGetMv("MX_MRBARRA",,"N")) == "S",.T.,.F.)
                        
Default cStatus	 := ""
Default cChvNfe	 := ""

//Chamando Rotina


	if __CUSERID $ "000000/"
		PortalXmL()	//Chamando Rotina 
	else 
		MsgInfo("Rotina em Desenvolvimento.")
	endif

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³PortalXmL  ºAutor  ³Marco Aurelio Silva º Data ³  25/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
"Portal XML  -  V1.01/251019"   - Desenvolvimento Inicial
"Portal XML  -  V1.02/"
"Portal XML  -  V1.03/" 
"Portal XML  -  V1.04/" 
"Portal XML  -  V1.05/" 
"Portal XML  -  V1.06/" 
"Portal XML  -  V1.07/" 
   
*/

Static Function PortalXmL()

//Declara as variaveis
  
Private cTitCad  		:= "Portal XML  -  V4.23 / 27.09.19"
Private cStrCad  		:= ""
Private cCadastro		:= ""
Private aRotina  		:= fMenu()
Private aFixe    		:= Nil
Private cFiltrCad		:= Nil
Private aIndexCad		:= {}

Private cMRAlias01 	:= "" 	//Regitro Principal
Private cMRAlias02 	:= "" 	//Regitro Historico
Private cMRAlias03 	:= "" 	//Regitro Amarracao PC 
Private cMRAlias04 	:= "" 	//TES INTELIGENTE 
Private cMRSX5Oper 	:= "ZD"  // Tabela no SX5 com consulta padrao de Operacao de Entrada    
                        
fVerifInic()			// Verificacoes Iniciais

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exibe Filtro Inicial na Rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cTab1		:= AllTrim(GetMV("MX_MRALS01"))
	cAls1		:= IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	aRetPerg	:= {.T.,cAls1+"_STATUS = '1' "}   //{lRet,cRet}
                                
   // Chamada da Rotina
	U_VLDPORT()

//Se pergunta confirmada, executa filtro, caso contrario, sai da rotina
/*
If aRetPerg[1]
	
	cFilCad := aRetPerg[2]
	aIndexCad := {}
	
	cStrCad   := cMRAlias01
	cCadastro := cTitCad+" ["+cStrCad+"]"
	DbSelectArea(cStrCad)
	DbSetOrder(1)
	mBrowse(6,1,22,75,cStrCad,aFixe,,,,,,,,,,,,,cFilCad)
	SetMBTopFilter(cStrCad, "")
	
EndIf
  
*/

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fMenu     ºAutor  ³Marco Aurelio Silva º Data ³  25/10/19   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                                 
Static Function fMenu()

Local aRotina	:= {}

aAdd(aRotina, { OemToAnsi("Validar Pedido"		),"U_VLDPORT"         ,  0 , 2}) //4  
//aAdd(aRotina, { OemToAnsi("Exportar XML" 		)	,"U_GXNExp"       ,  0 , 2}) //3
//aAdd(aRotina, { OemToAnsi("Relatório XML" 	)	,"U_MRSXML04"     ,  0 , 2}) //4
                                                                         
Return(aRotina)


User Function VLDPORT()
	fGerTela("I") //Importação XML (Gerar Pre-nota)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerTela  ºAutor  ³Marco Aurelio Silva º Data ³  01/11/19   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGerTela(cOper)

Local oDialg
Local cPrtCad      := " Portal Gestor XML - Validar Pedido de Compra"
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Força Filtro para Somente Considerar XML Recebidos com Sucesso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cGetStatus := "1"



aAdd(aHdStatus,{cAls1+'_STATUS == "0" ','BR_AZUL'    , "XML pendente de recebimento"            })
aAdd(aHdStatus,{cAls1+'_STATUS == "1" ','BR_VERDE'   , "XML recebido com sucesso"               })
aAdd(aHdStatus,{cAls1+'_STATUS == "2" ','BR_AMARELO' , "XML recebido com erro"                  })
aAdd(aHdStatus,{cAls1+'_STATUS == "3" ','BR_LARANJA' , "XML já incluido no sistema"             })
aAdd(aHdStatus,{cAls1+'_STATUS == "4" ','BR_VERMELHO', "XML gerou erro na pre-nota"             })
aAdd(aHdStatus,{cAls1+'_STATUS == "5" ','BR_PINK'    , "XML gerou pre-nota depois foi excluida" })
aAdd(aHdStatus,{cAls1+'_STATUS == "6" ','BR_PRETO'   , "XML de cancelamento recebido"           })
aAdd(aHdStatus,{cAls1+'_STATUS == "7" ','BR_CINZA'   , "XML bloqueado pelo validador"           })
aAdd(aHdStatus,{cAls1+'_STATUS == "8" ','BR_BRANCO'  , "XML bloqueado pelo Usuario"             })

//Campos que serão apresentados no MsNewGetDados
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

// Maximizacao da tela em relação a area de trabalho
aSizeAut := MsAdvSize()
nSpceBar := 0 //Por não usar o EnchoiceBar, vou consumir o espaço dele na tela
aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4]+nSpceBar,3,3}
aObjects := {}

aAdd(aObjects,{100,055,.T.,.F.}) //Cabeçalho
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerCorpo ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerDpClicºAutor  ³Felipe Aurelio      º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGerDpClic()

Local nLinhaOK := oAAGetDad:oBrowse:nAt
Local nAAFLAG := aScan(oAAGetDad:aHeader,{|x|AllTrim(x[2])=="AA_FLAG"  })

//Marca apenas o registro em questão
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerTrtColºAutor  ³Felipe Aurelio      º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	//Marca apenas o registro em questão
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

//Tratamento de Ordenação
If nCol != nAAFLAG
	
	//Trata historico de ordenação, no maximo 3
	If Len(aOrdHead) >= 3
		While Len(aOrdHead) >= 3
			aDel(aOrdHead,1)
			aSize(aOrdHead,Len(aOrdHead)-1)
		End
	EndIf
	
	//Adicionar coluna pra ordenação
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerOrdenaºAutor  ³Felipe Aurelio      º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fAjustaVarºAutor  ³Felipe Aurelio      º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerRodap ºAutor  ³Felipe Aurelio      º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

@ aBtn02[1],aBtn02[2] Button "Validar Pedido"   	Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action ( fGerPrcImp() , oDialg:End() )
@ aBtn03[1],aBtn03[2] Button "Sair"                 Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action oDialg:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerPrcImpºAutor  ³Felipe Aurelio      º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³  Gera Pre-Nota Fiscal                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGerPrcImp()

If Len(oAAGetDad:aCols) > 0
	Processa( {|| fGerPrcXml()    },"Processando XML selecionado..." )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerPrcXmlºAutor  ³Felipe Aurelio      º Data ³  14/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerVldNFeºAutor  ³Felipe Aurelio      º Data ³  28/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//Valida Status, pois só pode executar se STATUS == 1
If lProc .And. (cTab1)->&(cAls1+"_STATUS") != "1"
	fGravaMsg(nRecTab1,11," ")
	lProc := .F.
EndIf

//Valida se XML é do tipo NF
If lProc .And. (!(cTab1)->&(cAls1+"_TIPDOC") $ "N/C/D/B/I" )      //  28/01/2018 - Adicionado tratamento para COMPLEMENTO DE ICMS
	fGravaMsg(nRecTab1,14,"4")
	lProc := .F.
EndIf

//Valida se XML é do tipo NF
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

//Identifica se é cliente ou fornecedor e o codigo correto
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
	aadd(aCabec,{"F1_FORMUL"  ,"N"  															,Nil,Nil})
	aadd(aCabec,{"F1_DOC"     ,(cTab1)->&(cAls1+"_DOC"   )  							,Nil,Nil})
	aadd(aCabec,{"F1_SERIE"   ,(cTab1)->&(cAls1+"_SERIE" )      					,Nil,Nil}) 
	
	cCndCliFor := IIf(Empty(cCndCliFor),"001",cCndCliFor)
	if !empty(_cNumPC)
		cCndCliFor :=	Posicione('SC7',1,xFilial('SC7')+_cNumPC,"C7_COND")
	endif
	aadd(aCabec,{"F1_COND"    ,cCndCliFor													,Nil,Nil})	
	aadd(aCabec,{"F1_EMISSAO" ,(cTab1)->&(cAls1+"_DTEMIS")       					,Nil,Nil})
	aadd(aCabec,{"F1_FORNECE" ,cCodCliFor                           				,Nil,Nil})
	aadd(aCabec,{"F1_LOJA"    ,cLojCliFor    												,Nil,Nil})
	aadd(aCabec,{"F1_ESPECIE" ,"SPED"                     							,Nil,Nil})
	aadd(aCabec,{"F1_CHVNFE"  ,(cTab1)->&(cAls1+"_CHVNFE")     						,Nil,Nil})      
	If SF1->(FieldPos("F1_XGESTOR"))>0
  		aadd(aCabec,{"F1_XGESTOR" ,"S"                    								,Nil,Nil})
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
			//Se campos Fator Conversao Unidade Medido OK, então calcular
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
			//Se campos Fator Conversao Unidade Medido OK, então calcular
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
		Else
			CST_Aux := ""
		EndIf
		aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})
		cAdic := IIf(Type("oItemTemp:_InfAdProd:TEXT") != "U",oItemTemp:_InfAdProd:TEXT,"")
		
		// Adiciona no aLinha, dados do Centro de Custo/Armazem quando nao existe PC amarrado
		aadd(aLinha,{"D1_LOCAL",_cxLocal,Nil,Nil})
		aadd(aLinha,{"D1_CC"   ,_cxCusto,Nil,Nil})

		// Adiciona Data de Validade do Lote com data Fixa em 31/12/2049 (Necessidade Domex)   
		_cDtValid	:= StoD("20491231")
		aadd(aLinha,{"D1_DTVALID"   ,_cDtValid,Nil,Nil})
                                                  
		// Adiciona TES INTELIGENTE DE ENTRADA 

			IF AllTrim(GetMV("MX_MRCLASS"))	== "C"
		   	_cProd		:= SB1->B1_COD     
		   	_cFornec		:= cCodCliFor
		   	_cLojaFor	:= cLojCliFor
		    	_cOper		:= "01" //cFullOper  // MAURESI - 06/09/2019
 				_cTesEnt		:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)     
			
  			  	aadd(aLinha,{"D1_TES"	,_cTesEnt,Nil,Nil})
		  		aadd(aLinha,{"D1_XOPER"	,_cOper	,Nil,Nil})        //"D1_OPER"
  			ELSE      
  				aadd(aLinha,{"D1_TES"		,""      ,Nil,Nil})  
		   	aadd(aLinha,{"D1_XOPER"	,"00"		,Nil,Nil})     ////"D1_OPER"	
  			ENDIF


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³P.E. (MRSXPE01) - Ponto de Entrada para Carregar Dados Adicionais  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("MRSXPE01")
			aMRSXPE01 := Nil
			aMRSXPE01 := ExecBlock("MRSXPE01",.F.,.F.,{cAdic})
			
			If Type("aMRSXPE01") == "A"
				For y:=1 To Len(aMRSXPE01)
					aAdd(aLinha,aMRSXPE01[y])
				Next y
			Else
				MsgAlert("PE MRSXPE01 está com erro de retorno, favor verificar.")
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Fim P.E. (MRSXPE01)                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
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
	nD1TES     := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_TES" 	  })
 	nD1OPER    := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_XOPER"	  })  ////"D1_OPER"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua Relacionamento do Pedido de Compra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lProc .And. lProcPC .And. Len(aItens) > 0
	lProc := fLinkNFxPC(aCabec,@aItens,aUnidMed,aPrdDesc,aPrdXML)
EndIf

//Executa rotina de inclusão Pre-Nota
If lProc .And. Len(aItens) > 0	
	    
	lMsErroAuto := .F.
	lMsHelpAuto := .T.


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera NF somente se for _lTESOK³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if AllTrim(GetMV("MX_MRCLASS"))	== "C"   .and. _lTESOK
		MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens,3)      //DOCUMENTO DE ENTRADA  
	else     
		MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)   // PRE-NOTA   
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
		
		cMsgErro := "PORTAL XML - Erro na execução do MsExecAuto para geração do Documento."
		cMsgNota := "Número DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
		cMsgAssu := "[Documento] Erro na Geracao do XML [PORTAL]"
		
		fWfGerXml("INTEGRACAO XML x DOCUMENTO", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl+"<br>"+cMsErro2)
		fGravaMsg(nRecTab1,98,"4",cMsgErro+" - "+cMsgNota)
		
		MsgAlert(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl + cMsErro2)
	Else 
	
				
		lProc := .T.
		ConfirmSX8()
		
		cMsgErro := "Documento Gerado Com Sucesso!"
		cMsgNota := "Número DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
		cMsgAssu := "Documento Gerado com sucesso : ["+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+"]"
		
		fWfGerXml("INTEGRACAO XML x DOCUMENTO", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl)
		fGravaMsg(nRecTab1,98,"3",cMsgErro+" - "+cMsgNota)
		
		MsgInfo(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)
		
		
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerVldCteºAutor  ³Felipe Aurelio      º Data ³  28/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//Valida Status, pois só pode executar se STATUS == 1
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
	aadd(aCabec,{"F1_TPCTE"   ,"N"                             					,Nil,Nil})
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona Produto do CTE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
	// Identifica Qual campo de ICMS está preenchido e carrega o valor
	Do Case                                  
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³MAURESI - Adicionado tratamento para usar Aliquota se ICM que vem no XML, e nao a calculada pelo sistema, ³
		//³pois é necessário usar a Aliquota do Cliente onde a mercadoria está sendo entregue.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica de Base é diferente do Valor de Servico³
	//³Se for, cria segunda linha na NFE               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_lpedag := .F.
	if cXmlVPed > 0 .and. cXmlVPed <> cXmlVServ
		cXmlVServ	:= val(AllTrim(oItemTemp2:_ICMS:_ICMS90:_vBC:TEXT))
		cXmlVPed		:= val(AllTrim(oItemTemp:_vTPrest:TEXT)) - 	val(AllTrim(oItemTemp2:_ICMS:_ICMS90:_vBC:TEXT))
		_lpedag 		:= .T.
	endif
	
	cCodCTE			:= Alltrim(GETMV("MX_MRFRETE"))  //"5010030"
	cCodCTE			+= Space(Len(SB1->B1_COD) - Len(cCodCTE) )
	
	nQtdProd			:=	1
	
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³DOMEX - Grava Chave do CTE no SD1 para  NF de Entrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    

//	If lCliDMX	
			// Grava XML do CTE no SD1 para Tratar TES Inteligente na Devolucao (Especifico DOMEX)
			if Type('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC') <> "U"
				cSerCTE1   := &('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_SERIE:TEXT' )
				cDocCTE1   := &('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNF:_NDOC:TEXT'  )		
			endif

			if Type('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE') <> "U"
				cChvCTE   := &('oNFe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT' )   
		  //	else
			//	cChvCTE   := "SEM_CHAVE"      // MAURESI - REMOVER - APENAS PARA TESTAR SE ESTA GRAVANDO
			endif
			
			If SD1->(FieldPos("D1_XDOCCTE"))>0 .and. !empty(cDocCTE1)
				aadd(aLinha,{"D1_XSERCT3",cSerCTE1,Nil,Nil})
				aadd(aLinha,{"D1_XDOCCTE",cDocCTE1,Nil,Nil})
			EndIf
			If SD1->(FieldPos("D1_XCHVCTE"))>0
				aadd(aLinha,{"D1_XCHVCTE",cChvCTE,Nil,Nil})  
			EndIf				
//	EndIf

	// MAURESI  01/10/2018	             
                                                 
	// Adiciona TES INTELIGENTE DE ENTRADA -  CTE       
	_lTESOK	:= .F. 
	_cTesEnt	:= ""
		   
		If AllTrim(GetMV("MX_MRCLASS"))	== "C"
	   	_cProd		:= cCodCTE
	   	_cFornec		:= cCodCliFor
	   	_cLojaFor	:= cLojCliFor
	    	_cOper		:= "01"
 				
 			_cTesEnt		:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper,cChvCTE)   
		  // _cOper		:= cFullOper

			if !empty(Alltrim(_cTesEnt))
  		  		_lTESOK	:= .T.
  		  	endif  				
  		EndIf	  					


	aadd(aLinha,{"D1_TES",_cTesEnt,Nil,Nil}) 
	//aadd(aLinha,{"D1_OPER",_cOper,Nil,Nil})  
	
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

//Executa rotina de inclusão Pre-Nota
If lProc .And. Len(aItens) > 0
	
	lMsErroAuto := .F.
	lMsHelpAuto := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera NF somente se for _lTESOK³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(GetMV("MX_MRCLASS"))	== "C"   .and. _lTESOK
		MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens,3)      //DOCUMENTO DE ENTRADA      
//		MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)   // execauto 1      -  PRE-NOTA FUNCIONANDO		 
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
		
		cMsgErro := "Erro na execução do MsExecAuto para geração do Documento ( CTE )."
		cMsgNota := "Número DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
		cMsgAssu := "[Documento] Erro na importação do XML de CTE"
		
		fWfGerXml("INTEGRACAO XML x DOCUMENTO - CTE", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl+"<br>"+cMsErro2)
		fGravaMsg(nRecTab1,98,"4",cMsgErro+" - "+cMsgNota)
		
		MsgAlert(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl + cMsErro2)
		
	Else    
	

		lProc 	:= .T.
		ConfirmSX8()
		
		cMsgErro := "CTE Gerado Com Sucesso!"
		cMsgNota := "Número DOC: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
		cMsgAssu := "Documento Gerada com sucesso : ["+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+"]"
		
		fWfGerXml("INTEGRACAO XML x DOCUMENTO - CTE", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl)
		fGravaMsg(nRecTab1,98,"3",cMsgErro+" - "+cMsgNota)
		
		MsgInfo(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)
	EndIf
	
Endif

Return(lProc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fTrtCodPrdºAutor  ³Felipe Aurelio      º Data ³  12/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkNFxPCºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//Divisões dentro da tela
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

aAdd(aObjects,{100,035,.T.,.F.}) //Cabeçalho
aAdd(aObjects,{100,100,.T.,.T.}) //Corpo = Nfe e Romaneio
aAdd(aObjects,{100,020,.T.,.F.}) //Rodape
aPosObj  := MsObjSize(aInfo,aObjects)

//Variaveis do tamanho a tela
aDlgTela := {aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5]}

//Divide cabeçalho
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

//Contorno - Rodapé
fLinkRodap(aPosObj[3],oDialg,@nOpcao)

Activate MsDialog oDialg Centered

//Se confirmado
If nOpcao == 2
	
	_lProdOk := .T.		// Valida se Todos os Produtos estao Preenchidos
	_lPCOMOk := .T.		// Valida se Todos os Produtos estao Preenchidos
	_lCustOK	:= .T.		// Valida se Todos os Itens tem Centro de Custo Informado     
	_lTESOK	:= .T.		// Valida se Todos os Itens tem TES preenchido
	_lTESEXT := .T.		// Valida se Todos as TES existem na Amarracao	  
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
			
		Else
			//Alterando o nome do campo no  para não dar erro no execauto
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
		aItens[x][nD1VALDESC][2]  := Round(oXXGetDad:aCols[x][nXXVALDESC],2)
		
		// Se o Produto for VAZIO, nao pode permitir gravar
		If  empty(alltrim(oXXGetDad:aCols[x][nXXPRODUTO]))
			_lProdOk := .F.
		Endif
		
		// Se Pedido de Compra não for amarrado, Nao permitte Gravar
		if Empty(oXXGetDad:aCols[x][nXXPEDIDO])
			_lPCOMOk := .F.
		endif
				
		

			// Se TES estiver vazio, somente pode gerar PRE-NOTA 
			if Empty(oXXGetDad:aCols[x][nXXTES])
				_lTESOk := .F.       
				   aItens[x][nD1TES][2]   := Space(03) //oXXGetDad:aCols[x][nXXTES]		// MAURESI
		  	 	   aItens[x][nD1OPER][2]  := Space(02) //oXXGetDad:aCols[x][nXXOPER]				
			else
	   		// Alimenta TES - OPERACAO informados no Browse
					aItens[x][nD1TES][2]   := oXXGetDad:aCols[x][nXXTES]		// MAURESI
		  	 		aItens[x][nD1OPER][2]  := oXXGetDad:aCols[x][nXXOPER]	
			endif                   '

				
	Next x
	
	If !_lProdOk
		MsgAlert("Existe Produto sem Amarração e por isso o processo não pode ser concluido")
		lRet := .F.
	Endif
	
	// Se nao tiver Amarracao com SC e se o usuario nao estiver no parametro MX_MRUSR02, barra Inclusao
	If !_lPCOMOk
		If !(__cUserID $ Alltrim(GetMV("MX_MRUSR02")))	// "000000=Administrador
			MsgAlert("Existe Item da NF sem amarração com o Pedido de Compras. Favor verificar.   (MX_MRUSR02)")
			lRet := .F.
		endif
	Endif
	            	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava Amarração de Produto x Fornecedor³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
				SA5->A5_XXPORTA := "S" //Campo que controla o que será mostrado no portal
				EndIf
				EndIf
				Else
				Reclock("SA5",.T.)
				If SA5->(FieldPos("A5_XXPORTA"))>0
				SA5->A5_XXPORTA := "S" //Campo que controla o que será mostrado no portal
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
				
				//Esta variavel será retornata pra quem a chamou
				cCodProdut := SA5->A5_PRODUTO
				
				cVldMensag := "O produto ( "+alltrim(cCadPrdCod)+" ) Vs ( "+alltrim(cCadPrdFor)+" ) foi cadastrado na tabela Amarração Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
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
				
				//Esta variavel será retornata pra quem a chamou
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkCabc1ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fLinkCabc1(aSizeDlg,oDialg,aCabec)

Local cCbcTpNF := aCabec[1][2]
Local cCbcForn := aCabec[7][2] + " / " + aCabec[8][2] + " - " + Posicione("SA2",1,xFilial("SA2")+cLinkForCd+cLinkForLj,"A2_NOME")
Local cCbcNota := aCabec[3][2] + " / " + aCabec[4][2]

cNfRelat := cCbcNota

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Label " Cabeçalho Pré Nota Entrada " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

@ aSizeDlg[1]+010,aSizeDlg[2]+005 Say "Nota"              Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+009,aSizeDlg[2]+030 MsGet cCbcNota          Size 070 ,008 Pixel When .F. Of oDialg

@ aSizeDlg[1]+010,aSizeDlg[2]+135 Say "Tipo NF"           Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+009,aSizeDlg[2]+160 MsGet cCbcTpNF          Size 030 ,008 Pixel When .F. Of oDialg

@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Fornec."           Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+021,aSizeDlg[2]+030 MsGet cCbcForn          Size 160 ,008 Pixel When .F. Of oDialg

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkCabc2ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fLinkCabc2(aSizeDlg,oDialg)

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Label " Pesquisar Pedido de Compra " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel


//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2a Coluna   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ aSizeDlg[1]+022,aSizeDlg[2]+100 Say "Armazem"		   Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+021,aSizeDlg[2]+125 MsGet cLinkLocal        Size 040 ,008 Pixel Of oDialg F3 "NNR"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Coluna   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ aSizeDlg[1]+010,aSizeDlg[2]+170 Say "Descr."            Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+009,aSizeDlg[2]+195 MsGet cLinkDesc         Size 110 ,008 Pixel Of oDialg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Coluna   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ aSizeDlg[1]+010,aSizeDlg[2]+005 Say "Num. PC"           Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+009,aSizeDlg[2]+030 MsGet cLinkNumPC        Size 060 ,008 Pixel Of oDialg F3 "SC7"

if upper(alltrim(_lCodBar)) $ "S"
	@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Cod.Barra"		   Size 050 ,008 Pixel Of oDialg
else
	@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Produto"		   Size 050 ,008 Pixel Of oDialg
endif
@ aSizeDlg[1]+021,aSizeDlg[2]+030 MsGet oLinkProdu Var cLinkProdu        Size 060 ,008 Pixel Of oDialg F3 "SB1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Botoes      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ aSizeDlg[1]+021,aSizeDlg[2]+230 Button "Pesquisar"      Size 030 ,010 Pixel Of oDialg Action fLinkPesqu()
@ aSizeDlg[1]+021,aSizeDlg[2]+280 Button "Limpar"         Size 030 ,010 Pixel Of oDialg Action fLinkLimpa()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkPesquºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fLinkPesqu()

Local cQry   := ""
Local cQbra  := Chr(13)+Chr(10)

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
cQry += cQbra + "   C7_XOPER        AS YY_OPER, "
cQry += cQbra + "   C7_LOCAL          AS YY_LOCAL, "
cQry += cQbra + "   C7_CC             AS YY_CC,    " 
cQry += cQbra + "  (C7_QUANT-C7_QUJE-C7_QTDACLA) AS YY_SALDO "
cQry += cQbra + "   FROM "+RetSqlName("SC7")+" SC7 "
cQry += cQbra + "  WHERE D_E_L_E_T_ = '' "
cQry += cQbra + "    AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 "
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O Trecho abaixo limpa po aCols somente quando a primeira linha     ³
//³tiver um item sem o numero do PC preenchido.                       ³
//³Esta situacao acontece somente na primeira vez que acessa a rotina.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkCargaºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	
	//Carregando campos que serão visualizados no GD
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

// Restaura amarração já realizada anteriormente do ZZ3
fRestSalva()

//Carrega aCols com uma linha vazia por não teve resultado na query
QRY->(DbGoTop())

//Atualiza tela
oYYGetDad:oBrowse:nAt := 1
oYYGetDad:oBrowse:Refresh()
oYYGetDad:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkLimpaºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkItem1ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fLinkItem1(aSizeDlg,oDialg,aItens,aUnidMed,aPrdDesc,aPrdXML)


// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local cGetOpc        := GD_UPDATE                                             // Nil // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local aAlter         := {"XX_TES","XX_OPER"}
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

aAdd(aHeadXX,{"Operacao"       ,"XX_OPER"      ,"@!"                 ,          02,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""               				 , ""        , ""        })
aAdd(aHeadXX,{"TES"		     	 ,"XX_TES"       ,"@!"                 ,          03,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""                            , ""        , ""        })

aAdd(aHeadXX,{"Unid."          ,"XX_UM"        ,"@!"                 ,          05,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"Quant. 1ª UM"   ,"XX_QTD1"      ,"@E 999,999,999.99"  ,          08,fX3Ret("D1_QUANT"  ,"X3_DECIMAL"), ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"Quant. 2ª UM"   ,"XX_QTD2"      ,"@E 999,999,999.99"  ,          08,fX3Ret("D1_QTSEGUM","X3_DECIMAL"), ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"Preco Unit."    ,"XX_PRCUNIT"   ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"Desconto"       ,"XX_VALDESC"   ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"Local"          ,"XX_LOCAL"     ,"@!"                 ,          02,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , "NNR"   , "R"        , ""                 , ""         ,""                            ,"A"      , ""            				    , ""        , ""        })
aAdd(aHeadXX,{"C.Custo"        ,"XX_CC"        ,"@!"                 ,          06,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , "CTT"   , "R"        , ""                 , ""         ,""                            ,"A"      , ""				                , ""        , ""        })
aAdd(aHeadXX,{"Num.PC"         ,"XX_PEDIDO"    ,"@!"                 ,          08,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"It.PC"          ,"XX_ITEMPC"    ,"@!"                 ,          04,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"Fator Conversão","XX_FATOR"     ,"@E 9999.9999"       ,          09,                                4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHeadXX,{"Tipo Fator"     ,"XX_TPFATOR"   ,"@R"                 ,          07,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })


For y := 1 To Len(aItens)
	
	//Cria uma linha no aCols
	aAdd(aColsXX,Array(Len(aHeadXX)+1))
	nLin := Len(aColsXX)
	
	nQtd1    := 0
	nQtd2    := aItens[y][nD1QUANT][2]
	nFator   := aFatorCon[y,1]
	cTpFator := aFatorCon[y,2]  
	_cTesEnt	:= ""
	
	If !Empty(nFator)  // Se houver fator de conversão para o produto
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fXXClick  ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±º          ³Duplo Clique na Selecao de Pedidos x XML (relacionamento    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		
		//Marca itens do PC que já estejam associados a esta linha da NF
		If !Empty(oXXGetDad:aCols[nLinhaXX][nXXPEDIDO])
			For x:= 1 To Len(oYYGetDad:aCols)
				If oXXGetDad:aCols[nLinhaXX][nXXPEDIDO] == oYYGetDad:aCols[x][nYYPEDIDO] .and. oXXGetDad:aCols[nLinhaXX][nXXITEMPC] == oYYGetDad:aCols[x][nYYITEMPC]
					oYYGetDad:aCols[x][nYYFLAG]  := "LBTIK"
				EndIf
			Next x
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Marcando a legenda de produtos iguais³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obrigando a selecionar primeiro um item de NF  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validando se o produto da NF e igual ao do pedido ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _Retorno .and. lMarca
	For x := 1 to Len(oXXGetDad:aCols)
		If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
			N1 := x
			Exit
		EndIf
	Next x
	If !Empty(oXXGetDad:aCols[N1][nXXPRODUTO])
		If oYYGetDad:aCols[oYYGetDad:oBrowse:nAt][nYYLEGENDA] == '3'
				MsgStop("Produtos diferentes. Não foi possível selecionar o Pedido.")
				_Retorno := .F.
		Else
			If oXXGetDad:aCols[N1][nXXPRODUTO] <> oYYGetDad:aCols[oYYGetDad:oBrowse:nAt][nYYPRODUTO]
				MsgStop("Produto do Pedido de Compras diferente do Produto da NF.")
				_Retorno := .F.
			EndIf
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validando o fator de Conversão                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			MsgStop("Não é possível marcar um Produto sem fator de conversão.")
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validando se o produto do pedido clicado anteriormente e igual ao atual ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validando a quantidade marcada no pedido nao e Igual a ZERO             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If _Retorno .and. lMarca
	_lZero:=.F.
	For x := 1 to Len(oYYGetDad:aCols)
		If oYYGetDad:aCols[x][nYYFLAG] == "LBTIK"
			If oYYGetDad:aCols[x][NYYSALDO] == 0
				oYYGetDad:aCols[x][nYYFLAG] := "LBNO"
				MsgStop("Este Pedido não pode ser selecionado, porque seu Saldo é ZERO!!!")
				_Retorno := .F.
				_lZero:=.T.
				exit
			EndIf
		EndIf
	Next x
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validando a quantidade marcada no pedido nao e superior a NF            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		MsgStop("Os Pedidos selecionados anteriormente são suficientes para atender a NF." + Chr(13) + "Quantidade NF:" + Transform(nQtdNF,"@E 999,999.99"))
		_Retorno := .F.
	EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Aviso de Quantidade e Valor divergente do Pedido com NF                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _Retorno .and. lMarca
	nXXPrcUni := Round((oXXGetDad:aCols[N1][nXXQTD2]/oXXGetDad:aCols[N1][nXXQTD1]) * oXXGetDad:aCols[N1][nXXPRCUNIT],fX3Ret("D1_VUNIT","X3_DECIMAL"))
	nYYPrcUni := oYYGetDad:aCols[nLinhaYY][nYYPRCUNIT]
	
	If nXXPrcUni <> nYYPrcUni    
	   if _lMSG02
			MsgInfo("Preços unitários divergentes:" + Chr(13) + "NF: " + Transform(nXXPrcUni,fX3Ret("D1_VUNIT","X3_PICTURE")) + Chr(13) + "PC: " + Transform(nYYPrcUni,fX3Ret("C7_PRECO","X3_PICTURE")  ) )
		Endif
	EndIf
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Marcando o markbrowse 2                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkItem2ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
aAdd(aHead,{"Saldo 1ª UM"   ,"YY_SALDO"     ,"@E 999,999,999.99"  ,  08,       4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Requisit."     ,"YY_ENTID"     ,"@!"                 ,  06,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Local"         ,"YY_LOCAL"     ,"@!"                 ,  02,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

   aAdd(aHead,{"Operacao"      ,"YY_OPER"      ,"@!"                 ,  02,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

aAdd(aHead,{"C.Custo"       ,"YY_CC"        ,"@!"                 ,  10,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Produto TMP"   ,"YY_XPROTMP"   ,"@R"                 ,  15,       0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
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

	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_OPER"   }) ] := ""

aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="YY_CC"     }) ] := ""
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
nYYSALDO		:= aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_SALDO"   })
nYYENTID    := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_ENTID"   })
nYYLOCAL    := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_LOCAL"   })

	nYYOPER		:= aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_OPER"    })

nYYCC       := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_CC"      })
nYYXPROTMP  := aScan(oYYGetDad:aHeader,{|x|AllTrim(x[2])=="YY_XPROTMP" })
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkRodapºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	@ 280+4,260 Say "Total qtd. 1ª UM: "   Size 50,12                  PIXEL //OF oTelaDV2       //@ 250+4,245
	@ 280  ,285 Say oTotNF Var Transform(nTotNF,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2      //@ 250  ,270
	oTotNF:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)
	
	@ 280+4,355 Say "Total pedidos: "   Size 50,12                  PIXEL //OF oTelaDV2                       //@ 250+4,340
	@ 280  ,375 Say oTotPC Var Transform(nTotPC,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2 //@ 250  ,360
	oTotPC:oFont := TFont():New('Arial',,23,,.T.,,,,.T.,.F.)
else
*/
	@ (aBtn01[1])   +4,260 Say "Total qtd. 1ª UM: "   Size 50,12                  PIXEL //OF oTelaDV2       //@ 250+4,245
	@ (aBtn01[1])   +2,285 Say oTotNF Var Transform(nTotNF,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2      //@ 250  ,270
	oTotNF:oFont := TFont():New('Arial',,23,,.T.,,,,.T.,.F.)
	
	@ (aBtn01[1] +4),355 Say "Total pedidos: "   Size 50,12                  PIXEL //OF oTelaDV2                       //@ 250+4,340
	@ (aBtn01[1] +2),375 Say oTotPC Var Transform(nTotPC,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2 //@ 250  ,360
	oTotPC:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)
	
/*
	@ (aBtn01[1]-12)+3,010 Say "Total qtd. 1ª UM: "   Size 50,12                  PIXEL //OF oTelaDV2       //@ 250+4,245
	@ (aBtn01[1]-12)  ,040 Say oTotNF Var Transform(nTotNF,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2      //@ 250  ,270
	oTotNF:oFont := TFont():New('Arial',,23,,.T.,,,,.T.,.F.)
	
	@ (aBtn01[1]-12)+3,335 Say "Total pedidos: "   Size 50,12                  PIXEL //OF oTelaDV2                       //@ 250+4,340
	@ (aBtn01[1]-12)  ,365 Say oTotPC Var Transform(nTotPC,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL //OF oTelaDV2 //@ 250  ,360
	oTotPC:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)

Endif
*/                
//Botões
nLinBot := nLinPrBot
nColBot := nColPrBot
  
@ nLinBot,nColBot Button "Associar    <F4>" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fLinkAssoc()
SetKey(VK_F4, {|| fLinkAssoc() })
fIncLCBot(@nLinBot,@nColBot)     

@ nLinBot,nColBot Button "Desassociar <F5>"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fLinkDesas()
SetKey(VK_F5, {|| fLinkDesas() })
fIncLCBot(@nLinBot,@nColBot)     

//@ nLinBot,nColBot    Button "Fator Conv.  <F6>"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fFatorConv()
//SetKey(VK_F6, {|| fFatorConv() })
//fIncLCBot(@nLinBot,@nColBot)     

//@ nLinBot,nColBot Button "Tes/Operação <F7>"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fEditTes()
//SetKey(VK_F7, {|| fEditTes() })
//fIncLCBot(@nLinBot,@nColBot)
                      
@ nLinBot,nColBot Button "Salvar       <F9>"      Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action fSalvar()
SetKey(VK_F9, {|| fSalvar() })
fIncLCBot(@nLinBot,@nColBot)

@ nLinBot,nColBot Button "Fechar"      Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
fIncLCBot(@nLinBot,@nColBot)

@ nLinBot,nColBot Button "Confirmar  <Ctrl+S>"   Size aBtn04[3],aBtn04[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())
SetKey(19, {|| fSalvar() })
fIncLCBot(@nLinBot,@nColBot)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkAssocºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			MsgAlert("O item selecionado já está associado a um pedido!")
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
//	MsgAlert("ATENÇÃO: O preço unitario do produto selecionado está diferente ( XML x PC ) !")
//EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desmembra Itens do XML de Acordo com o PEDIDO DE COMPRA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
				//                                    a proporção da qtd1 nova dividida pela velha (qtd1) vezes a qtd2
				aNewArray[Len(aNewArray),nXXQTD2    ] := nProporcao * aNewArray[Len(aNewArray),nXXQTD2]
				aNewArray[Len(aNewArray),nXXQTD1    ] := oYYGetDad:aCols[nPrimPC+x-1,nYYSALDO]
				
				aNewArray[Len(aNewArray),nXXVALDESC ] := nProporcao * nDesTotItem
				
				aNewArray[ Len(aNewArray),nXXPEDIDO ] := oYYGetDad:aCols[nPrimPC+x-1][nYYPEDIDO]
				aNewArray[ Len(aNewArray),nXXITEMPC ] := oYYGetDad:aCols[nPrimPC+x-1][nYYITEMPC]
				aNewArray[ Len(aNewArray),nXXLOCAL  ] := oYYGetDad:aCols[nPrimPC+x-1][nYYLOCAL ]

					aNewArray[ Len(aNewArray),nXXOPER   ] := oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Retorna TES Inteligente³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_cOper		:= oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]
						_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)
						aNewArray[ Len(aNewArray),nXXTES    ] :=  _cTesEnt 
					//

				aNewArray[ Len(aNewArray),nXXCC     ] := oYYGetDad:aCols[nPrimPC+x-1][nYYCC    ]
				
				nDistrib     += aNewArray[Len(aNewArray),nXXQTD1   ]
				nDispDescont += aNewArray[Len(aNewArray),nXXVALDESC]
			Else
				nProporcao                            := ((nQtdNF - nDistrib)/aNewArray[Len(aNewArray),nXXQTD1])
				//                                     a proporção da qtd1 nova dividida pela velha (qtd1) vezes a qtd2
				aNewArray[Len(aNewArray),nXXQTD2    ] := nProporcao * aNewArray[Len(aNewArray),nXXQTD2]
				aNewArray[Len(aNewArray),nXXQTD1    ] := nQtdNF - nDistrib
				
				aNewArray[Len(aNewArray),nXXVALDESC ] := nDesTotItem - nDispDescont
				
				aNewArray[ Len(aNewArray),nXXPEDIDO ] := oYYGetDad:aCols[nPrimPC+x-1][nYYPEDIDO]
				aNewArray[ Len(aNewArray),nXXITEMPC ] := oYYGetDad:aCols[nPrimPC+x-1][nYYITEMPC]
				aNewArray[ Len(aNewArray),nXXLOCAL  ] := oYYGetDad:aCols[nPrimPC+x-1][nYYLOCAL ]  

					aNewArray[ Len(aNewArray),nXXOPER   ] := oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]  
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Retorna TES Inteligente³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_cOper	:= oYYGetDad:aCols[nPrimPC+x-1][nYYOPER  ]
						_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)				
				  		aNewArray[ Len(aNewArray),nXXTES    ] := _cTesEnt
					//

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

			oXXGetDad:aCols[N1,nXXOPER   ] := oYYGetDad:aCols[N2][nYYOPER  ]	 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Retorna TES Inteligente³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cOper	:= oYYGetDad:aCols[N2][nYYOPER  ]
				_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)				
				oXXGetDad:aCols[N1,nXXTES ] :=  _cTesEnt	
			// 
				
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FINAL DO ASSOCIACAO                      ³
//³Desmarca Todos os Itens e Atualiza a Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fLinkDesasºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fLinkDesas()

Local x       := 1

For x:=1 To Len(oXXGetDad:aCols)
	If oXXGetDad:aCols[x][nXXFLAG] == "LBTIK"
		oXXGetDad:aCols[x][nXXPEDIDO] := ""
		oXXGetDad:aCols[x][nXXITEMPC] := ""   

			oXXGetDad:aCols[x][nXXOPER] := ""
			oXXGetDad:aCols[x][nXXTES]  := ""				

	EndIf
Next x

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerRlcPrdºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,cCodProdut,nRecA5A7,nFator,cTipoFat)


//Variaveis do tamanho a tela
Local aDlgTela     := {000,000,410,505} //{000,000,343,505}

//Divisões dentro da tela
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
Local cTitCad      := "Amarração Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
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

//Trata campos de Conversão
If Empty(fX3Ret(cCpoUmXml,"X3_CAMPO"))
	//Campo não foi criado
	lWhenUmXml := .F.
Else
	//Campo OK
	lWhenUmXml := .T.
EndIf

//Trata campos de Conversão
If Empty(fX3Ret(cCpoFCNum,"X3_CAMPO"))
	//Campo não foi criado
	lWhenFCNum := .F.
Else
	//Campo OK
	lWhenFCNum := .T.
EndIf

//Trata campos de Conversão
If Empty(fX3Ret(cCpoFCTip,"X3_CAMPO"))
	//Campo não foi criado
	lWhenFCTip := .F.
Else
	//Campo OK
	lWhenFCTip := .T.
EndIf

//Se todos campos foram criado, então faz tratamento
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
	
	@ aDlgCorp1[1]+034,aDlgCorp1[2]+005 Say "Descrição"         Size 030 ,008 Pixel Of oDialg
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
	
	@ aDlgCorp2[1]+034,aDlgCorp2[2]+005 Say "Descrição"         Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+033,aDlgCorp2[2]+035 MsGet cCadPrdDes        Size 205 ,008 Pixel When .F. Of oDialg
	
	//Corpo 03
	@ aDlgCorp3[1], aDlgCorp3[2] To aDlgCorp3[3], aDlgCorp3[4] LABEL " Conversão Unidade Medida " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCorp3[1]+010,aDlgCorp3[2]+005 Say "Fator Conv."       Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp3[1]+009,aDlgCorp3[2]+035 MsGet nCadFatCon        Size 085 ,008 Pixel When lWhenTtCps Of oDialg Picture "@E 99,999.9999"
	
	@ aDlgCorp3[1]+010,aDlgCorp3[2]+128 Say "Tipo Conv."        Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp3[1]+009,aDlgCorp3[2]+155 ComboBox oCadTipCon Var cCadTipCon Items aCadTipCon Size 085 ,008 Pixel When lWhenTtCps Of oDialg
	
	//Rodapé / Botões
	@ aDlgRodp[1], aDlgRodp[2] To aDlgRodp[3], aDlgRodp[4] LABEL "" COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	@ aBtn01[1],aBtn01[2] Button "Processar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
	@ aBtn02[1],aBtn02[2] Button "Cancelar"  Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())
	
	Activate MsDialog oDialg Centered
	
	//Verifica se operação foi cancelada
	If nOpcao != 1
		lLoop   := .F.
		lReturn := .F.
	EndIf
	
	//Valida Produto escolhido
	If nOpcao == 1
		lReturn := fVldRlcPrd(.T.)
	EndIf
	
	//Caso lReturn OK, então sair do Loop
	If lLoop .And. lReturn
		lLoop   := .F.
	EndIf
	
End

If nOpcao == 1 .And. lReturn
	If Empty(nCadFatCon)
		MsgStop("O Fator de Conversão deve ser diferente de zero.")
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
					SA5->A5_XXPORTA := "S" //Campo que controla o que será mostrado no portal
				EndIf
			EndIf
		Else
			Reclock("SA5",.T.)
			If SA5->(FieldPos("A5_XXPORTA"))>0
				SA5->A5_XXPORTA := "S" //Campo que controla o que será mostrado no portal
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
		
		//Esta variavel será retornata pra quem a chamou
		cCodProdut := SA5->A5_PRODUTO
		
		cVldMensag := "O produto ( "+alltrim(cCadPrdCod)+" ) Vs ( "+alltrim(cXmlPrdCod)+" ) foi cadastrado na tabela Amarração Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
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
		
		//Esta variavel será retornata pra quem a chamou
		cCodProdut := SA7->A7_PRODUTO
		
		cVldMensag := "O produto ( "+alltrim(cCadPrdCod)+" ) Vs ( "+alltrim(cXmlPrdCod)+" ) foi cadastrado na tabela Amarracao Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
		fGravaMsg(nRecTab1,98," ",cVldMensag)
		
	EndIf
EndIf

Return(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fVldRlcPrdºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldRlcPrd(lVldVazio)


Local lOk  := .T.
Local lRet := .F.
Default lVldVazio := .F.

//Valida fazio caso solicitado
If lOk .And. lVldVazio .And. Empty(cCadPrdCod)
	MsgAlert("O Produto não foi informado. Informe um produto válido!")
	lOk := .F.
EndIf

//Se for vazio e não é pra validar, então sair e retornar .T., pois operação foi cancelada
If lOk .And. !lVldVazio .And. Empty(cCadPrdCod)
	cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
	cCadPrdNcm := ""
	cCadUniMed := ""
	cCadPrdDes := ""
	Return(.T.)
EndIf

SB1->(dbSetOrder(1))
If lOk .And. SB1->(!dbSeek(xFilial("SB1")+AllTrim(cCadPrdCod)))
	MsgAlert("Produto Cod.: "+alltrim(cCadPrdCod)+" não encontrado. Informe um produto válido!")
	lOk := .F.
EndIf

If lOk .And. SB1->B1_MSBLQL == "1"
	MsgAlert("Produto Cod.: "+alltrim(cCadPrdCod)+" bloqueado. Informe um produto válido!")
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg      ³fGerCabec ºAutor  ³Marco Aurelio       º Data ³  01/11/19   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGerCabec(aSizeDlg,oDialg,cOper)

Local cTab1        := AllTrim(GetMV("MX_MRALS01"))
Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

Local nQtdCpo := 8
Local nTamCpo := (aSizeDlg[4] / nQtdCpo)

//Declaração das Variáveis
//Local bSayTipDoc := {|| "Tipo Documento"}
//Local aSayTipDoc := {aSizeDlg[1]+05,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}
//Local aGetTipDoc := {aSizeDlg[1]+10,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}

//Declaração das Variáveis
//Local bSayStatus := {|| "Status"}
//Local aSayStatus := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 1)  ,  (nTamCpo*1.5)-05, 008}
//Local aGetStatus := {aSizeDlg[1]+10,   aSizeDlg[2] + (nTamCpo * 1)  ,  (nTamCpo*1.5)-05, 008}

//Declaração das Variáveis
//Local bSayComCCe := {|| "Com CCe"}
//Local aSayComCCe := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 2.5),  (nTamCpo*0.5)-05, 008}
//Local aGetComCCe := {aSizeDlg[1]+10,   aSizeDlg[2] + (nTamCpo * 2.5),  (nTamCpo*0.5)-05, 008}

//Declaração das Variáveis
//Local bSayCnpjEm := {|| "CNPJ Emitente"}
//Local aSayCnpjEm := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}
//Local aGetCnpjEm := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}

//Declaração das Variáveis
//Local bSayNomeEm := {|| "Nome Emitente"}
//Local aSayNomeEm := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}
//Local aGetNomeEm := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}

//Botão
Local aBtn01     := {aSizeDlg[1]+13,   aSizeDlg[2] + (nTamCpo * 7)  ,  nTamCpo-05, 012}

//Declaração das Variáveis
//Local bSayTipXml := {|| "Tipo XML"}
//Local aSayTipXml := {aSizeDlg[1]+27,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}
//Local aGetTipXml := {aSizeDlg[1]+37,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}

//Declaração das Variáveis
//Local bSayDtEmis := {|| "A partir Data Emissão"}
//Local aSayDtEmis := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 1)  ,  nTamCpo-05, 008}
//Local aGetDtEmis := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 1)  ,  nTamCpo-05, 008}

//Declaração das Variáveis
//Local bSaySerNFe := {|| "Serie NF"}
//Local aSaySerNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 2)  ,  nTamCpo-05, 008}
//Local aGetSerNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 2)  ,  nTamCpo-05, 008}

//Declaração das Variáveis
//Local bSayNumNFe := {|| "Numero NF"}
//Local aSayNumNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}
//Local aGetNumNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}

//Declaração das Variáveis
Local bSayChvNFe := {|| "Chave Nota Fiscal"}
Local aSayChvNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}
Local aGetChvNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}

//Botão
Local aBtn02     := {aSizeDlg[1]+35,   aSizeDlg[2] + (nTamCpo * 7)  ,  nTamCpo-05, 012}

Local aCBoxTipDoc := {}//Tipo Documento
Local aCBoxTipXml := {}//Tipo XML
Local aCBoxComCCe := {}//Com Carta de Correção
Local aCBoxStatus := {}//Status

//Opções da Pergunta
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


//Opções da Pergunta
aAdd(aCBoxTipXml,"T=Todos Tipos"     )
aAdd(aCBoxTipXml,"1=NF-e"            )
aAdd(aCBoxTipXml,"2=CT-e"            )
aAdd(aCBoxTipXml,"3=XML Pedente"     )

//Opções da Pergunta
aAdd(aCBoxComCCe,"T=Todos"           )
aAdd(aCBoxComCCe,"S=Sim"             )
aAdd(aCBoxComCCe,"N=Nao"             )

//Opções da Pergunta
aAdd(aCBoxStatus,"T=Todos Status"                           )
aAdd(aCBoxStatus,"0=XML pendente de recebimento"            )
aAdd(aCBoxStatus,"1=XML recebido com sucesso"               )
aAdd(aCBoxStatus,"2=XML recebido com erro"                  )
aAdd(aCBoxStatus,"3=XML já incluido no sistema"             )
aAdd(aCBoxStatus,"4=XML gerou erro na pre-nota"             )
aAdd(aCBoxStatus,"5=XML gerou pre-nota depois foi excluída" )
aAdd(aCBoxStatus,"6=XML de cancelamento recebido"           )
aAdd(aCBoxStatus,"7=XML bloqueado pelo validador"           )

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//oSayTipDoc  := TSay():New( aSayTipDoc[1] ,aSayTipDoc[2] ,bSayTipDoc ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayTipDoc[3] ,aSayTipDoc[4])
//oGetTipDoc  := TComboBox():New( aGetTipDoc[1],aGetTipDoc[2],{|u| IIf(Pcount()>0,cGetTipDoc:=u,cGetTipDoc)},aCBoxTipDoc,aGetTipDoc[3],aGetTipDoc[3],oDialg,,,,,,.T.)

//oSayStatus  := TSay():New( aSayStatus[1] ,aSayStatus[2] ,bSayStatus ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayStatus[3] ,aSayStatus[4])
//oGetStatus  := TComboBox():New( aGetStatus[1],aGetStatus[2],{|u| IIf(Pcount()>0,cGetStatus:=u,cGetStatus)},aCBoxStatus,aGetStatus[3],aGetStatus[3],oDialg,,,,,,.T.)

//oSayComCCe  := TSay():New( aSayComCCe[1] ,aSayComCCe[2] ,bSayComCCe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayComCCe[3] ,aSayComCCe[4])
//oGetComCCe  := TComboBox():New( aGetComCCe[1],aGetComCCe[2],{|u| IIf(Pcount()>0,cGetComCCe:=u,cGetComCCe)},aCBoxComCCe,aGetComCCe[3],aGetComCCe[3],oDialg,,,,,,.T.)

//oSayCnpjEm  := TSay():New( aSayCnpjEm[1] ,aSayCnpjEm[2] ,bSayCnpjEm ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayCnpjEm[3] ,aSayCnpjEm[4])
//oGetCnpjEm  := TGet():New( aGetCnpjEm[1] ,aGetCnpjEm[2] ,{|u| IIf(Pcount()>0,cGetCnpjEm:=u ,cGetCnpjEm )},oDialg,aGetCnpjEm[3] ,aGetCnpjEm[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//oSayNomeEm  := TSay():New( aSayNomeEm[1] ,aSayNomeEm[2] ,bSayNomeEm ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayNomeEm[3] ,aSayNomeEm[4])
//oGetNomeEm  := TGet():New( aGetNomeEm[1] ,aGetNomeEm[2] ,{|u| IIf(Pcount()>0,cGetNomeEm:=u ,cGetNomeEm )},oDialg,aGetNomeEm[3] ,aGetNomeEm[4] ,'@!'  ,/*cValid*/{|| iIf(Empty(cGetNomeEm),.T.,fGerPesqsa(cOper)) } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//----------------------------------------------------------------------------------------------
//oSayTipXml  := TSay():New( aSayTipXml[1] ,aSayTipXml[2] ,bSayTipXml ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayTipXml[3] ,aSayTipXml[4])
//oGetTipXml  := TComboBox():New( aGetTipXml[1],aGetTipXml[2],{|u| IIf(Pcount()>0,cGetTipXml:=u,cGetTipXml)},aCBoxTipXml,aGetTipXml[3],aGetTipXml[3],oDialg,,,,,,.T.)

//oSayDtEmis  := TSay():New( aSayDtEmis[1] ,aSayDtEmis[2] ,bSayDtEmis ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayDtEmis[3] ,aSayDtEmis[4])
//oGetDtEmis  := TGet():New( aGetDtEmis[1] ,aGetDtEmis[2] ,{|u| IIf(Pcount()>0,dGetDtEmis:=u ,dGetDtEmis )},oDialg,aGetDtEmis[3] ,aGetDtEmis[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//oSaySerNFe  := TSay():New( aSaySerNFe[1] ,aSaySerNFe[2] ,bSaySerNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSaySerNFe[3] ,aSaySerNFe[4])
//oGetSerNFe  := TGet():New( aGetSerNFe[1] ,aGetSerNFe[2] ,{|u| IIf(Pcount()>0,cGetSerNFe:=u ,cGetSerNFe )},oDialg,aGetSerNFe[3] ,aGetSerNFe[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//oSayNumNFe  := TSay():New( aSayNumNFe[1] ,aSayNumNFe[2] ,bSayNumNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayNumNFe[3] ,aSayNumNFe[4])
//oGetNumNFe  := TGet():New( aGetNumNFe[1] ,aGetNumNFe[2] ,{|u| IIf(Pcount()>0,cGetNumNFe:=u ,cGetNumNFe )},oDialg,aGetNumNFe[3] ,aGetNumNFe[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

oSayChvNFe  := TSay():New( aSayChvNFe[1] ,aSayChvNFe[2] ,bSayChvNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayChvNFe[3] ,aSayChvNFe[4])
oGetChvNFe  := TGet():New( aGetChvNFe[1] ,aGetChvNFe[2] ,{|u| IIf(Pcount()>0,cGetChvNFe:=u ,cGetChvNFe )},oDialg,aGetChvNFe[3] ,aGetChvNFe[4] ,'@!'  ,/*cValid*/{|| fGerPesqsa(cOper) } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)
//----------------------------------------------------------------------------------------------

//Botões
@ aBtn01[1],aBtn01[2] Button "Pesquisar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fGerPesqsa(cOper)
@ aBtn02[1],aBtn02[2] Button "Limpar"    Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fGerLimpar()

//oGetNumNFe:SetFocus()
oGetChvNFe:SetFocus()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerPesqsaºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGerPesqsa(cOper)

MsAguarde({|| fGerPrcPsq(cOper) },"Processando...","Aguarde, pesquisando ... ")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerPrcPsqºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TIPXML = '1' "      // SOMENTE XML NORMAL             
cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_STATUS = '1' "      // SOMENTE XML RECEBIDO COM SUCESSO (APTO A SER LANCADO)
cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TIPDOC = 'N' "      // SOMENTE XML TIPO NORMAL  (Desconsidera Devolucao, Complemento, Etc)
cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_CHVNFE) = '"+AllTrim(cGetChvNFe)+"' "
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
   QRY->(dbCloseArea("QRY"))
EndIf     

//Zera variavel que controla ordenação
aOrdHead := {}

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerCargGDºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	
	//Carregando campos que serão visualizados no GD
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

//Carrega aCols com uma linha vazia por não teve resultado na query
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

If Len(oAAGetDad:aCols) == 1
      fGerPrcImp()
      If Type("oDialg") == 'O'
         oDialg:End()   
      EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fGerLimparºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGerLimpar()

Local cTab1        := AllTrim(GetMV("MX_MRALS01"))
Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

	cGetChvNFe := Space(fX3Ret(cAls1+"_CHVNFE","X3_TAMANHO"))
	oGetChvNFe:Refresh()
	
	oAAGetDad:aCols := {}
	oAAGetDad:oBrowse:Refresh()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fX3Ret    ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  25/10/19   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fVerifInic()

Private cMRTabNovo := "/"
//Verifica se parametros já foram criados
//Verifica o conteúdo dos parametros
//Cria parametro caso necessário
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fPesqTab  ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fNewSX2   ºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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









//+-----------------------------------------------------------------------------------//
//|Funcao....: fHelpCpo()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
//|Funcao....: fVldChvAtv()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
cCodEst := SPEDRetEst(cCodEst)

//Se sem chave, então não precisa validar
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	TABELA DE MOTIVOS DO SEFAZ - NFE                ³
	//³	                                                ³
	//³	100 Autorizado o uso NF-e                       ³
	//³	101 Cancelamento de NF-e homologado             ³
	//³	102 Inutilização de número homologado           ³
	//³	103 Lote recebido com sucesso                   ³
	//³	104 Lote processado                             ³
	//³	105 Lote em processamento                       ³
	//³	106 Lote não localizado                         ³
	//³	107 Serviço em Operação                         ³
	//³	08 Serviço Paralisado (curto prazo)             ³
	//³	09 Serviço Paralisado (sem previsão)            ³
	//³	110 Uso Denegado                                ³
	//³	111 Consulta cadastro com uma ocorrência        ³
	//³	112 Consulta cadastro com mais de uma ocorrência³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
	//Serviço de consulta inoperando, não foi possivel consultar chave
	lRet := .T.
	cMsgCod := "999"
	cMsgDsc := "Consulta Inoperante - 999" //GetWscError(3)+" - "+GetWscError(1)
EndIf

Return({lRet,cMsgCod,cMsgDsc,cMsgPrt})

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGravaMsg()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
		cMens := "CNPJ do Emitente não está cadastrado no sistema (SA1)"
	Case nMsg == 2
		cMens := "CNPJ do Emitente não está cadastrado no sistema (SA2)"
	Case nMsg == 3
		cMens := "CNPJ do Emitente não localizado no XML"
	Case nMsg == 4
		cMens := "CNPJ do Destinatário não está cadastrado no sistema (SIGAMAT)"
	Case nMsg == 5
		cMens := "A Chave da NF-e já está registrada no sistema (Duplicidade)"
	Case nMsg == 6
		cMens := "A Chave da NF-e está cancelada no Sefaz!"
	Case nMsg == 7
		cMens := "O numero da NFe está inutilizada no Sefaz!"
	Case nMsg == 8
		cMens := "O Serviço de consulta da NFe não confirmou autorização da Chave. Verificar novamente!"
	Case nMsg == 9
		cMens := "O Serviços de consulta da NFe esta inoperante. Chave não consultada!"
	Case nMsg == 10
		cMens := "Status ajustado automaticamente, pois foi identificado que a nota já foi incluida no sistema!"
	Case nMsg == 11
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o Status diferente de 1 impediu a operação!"
	Case nMsg == 12
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML pendente de recebimento!"
	Case nMsg == 13
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML está com erro de estrutura!"
	Case nMsg == 14
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML não é do tipo NF-e!"
	Case nMsg == 90
		cMens := "XML Bloqueado por Solicitacao do Usuario!"
	Case nMsg == 98
		cMens := cTmpMsg
	Case nMsg == 99
		cMens := "Registro foi desbloqueado, validação OK!"
	Otherwise
		//Se mensagem não tratada acima, sair sem fazer nada
		Return()
EndCase

//Caso seja só mensagem, não tratar status
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
&(cAls2+"_PROTOC") := iif(!empty(alltrim(cMsgProt)),alltrim(cMsgProt),"Validação Interna")//"VALIDACAO INTERNA"
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
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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

//Verifica se CNPJ está cadastrado
If !Empty(nCadInx) .And. !Empty(nCadAls) .And. !Empty(cVarPsq)
	(nCadAls)->(DbSetOrder(nCadInx))
	If (nCadAls)->(DbSeek(xFilial(nCadAls)+cVarPsq))
		lRet := .T.
	EndIf
EndIf

Return({lRet,nCadAls})

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldCnpjDs()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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

//Verifica se chave já foi registrada!!!
cQuerys := " SELECT F1_TIPO, SF1.F1_CHVNFE, COUNT(*) QTD "
cQuerys += "   FROM "+RetSqlName("SF1")+" SF1 "
cQuerys += "  WHERE SF1.D_E_L_E_T_ = '' "
cQuerys += "    AND SF1.F1_CHVNFE = '"+cVarPsq+"' "
cQuerys += "  GROUP BY F1_TIPO, SF1.F1_CHVNFE "

If Select("TMP") <> 0 ; SQL->(dbCloseArea()) ;EndIf
TcQuery cQuerys New Alias "TMP"
TMP->(DbGoTop())

//Caso retorno maior que 0(zero) é porque nfe já foi registrada
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
			//Grava mensagem informando a alteração do status
			fGravaMsg(nRecTab1,10," ")
			
		Case TMP->QTD >= 2
			lRet := .F.
	EndCase
EndIf
TMP->(dbCloseArea())

Return(lRet)




//+-----------------------------------------------------------------------------------//
//|Funcao....: fVTipoDoc()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
Local cCFOP_D := AllTrim(SuperGetMV( "MX_MRNFDEV", , "1201/2201/1202/2202" )) //Devolução
Local cCFOP_C := AllTrim(SuperGetMV( "MX_MRNFCOM", , "1352/3101/3102/3551" )) //Complemento
Local cXXCF_B := "901/920"                                                    //Beneficiamento
Local cXXCF_D := "201/202"                                                    //Devolução

//finNFe Finalidade de emissão da NF-e
//1=Normal(N);
//2=Complementar(C);
//3=Ajuste(A);
//4=Devolução(D)/Beneficiamento(B)

//tpCTe Finalidade de emissão da CT-e
//0=Normal(N)
//1=Complemento(C)
//2=Anulação(U)
//3=Substituição(S)

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
		
		//Anulação
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "2"
			cRet := "U"
		EndIf
		
		//Substituição
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
				
				//Devolução
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
		
		//Devolução / Beneficiamento
		If Empty(cRet) .And. lDetOk //.And. lIdeOk .And. AllTrim(oIde:Text) $ " 4"
			
			//Verifica o tipo da nota fiscal
			For x:=1 To Len(oDet)
				//Beneficiamento
				If Empty(cRet) .And. SubStr(AllTrim(oDet[x]:_Prod:_CFOP:TEXT),2,3) $ cXXCF_B
					cRet := "B"
					x := Len(oDet)
				EndIf
				
				//Devolução
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
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
	MsgAlert("Erro de Conexao na conta de Email.  Método TMailManager : "   + str(__MailError))
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
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static function PopMsgCount(nMsgCount)
*-----------------------------------------------------------*

nMsgCount := 0
__MailError := __MailServer:GetNumMsgs(@nMsgCount)

Return( __MailError == 0 )

//+-----------------------------------------------------------------------------------//
//|Funcao....: fWfGerXml()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
//+-----------------------------------------------------------------------------------//


*-----------------------------------------------------------*
Static Function fWfGerXml(cTitulo, cAssunto, cMsg)
*-----------------------------------------------------------*

Local c_FileOrig := AllTrim(SuperGetMV( "MX_MR_HTML", , "\workflow\modelos\aviso_prenota.htm" )) //modelo html que será usado pra disparar os workflow
Local c_FileDest :="C:\TEMP\aviso_prenf.html"
Local _cPara := AllTrim(SuperGetMV( "MX_MR_MAIL", , "marco.aurelio@opusvp.com.br;"              )) //E-mail dos usuários que serão notificados quando uma NF for gerada
Local _cCc	 := "" 					 //E-mail dos usuários que receberao cópia 
Local cArquivo:= ""

//Veritica se arquivo HTML existe no caminho informado
If !File(c_FileOrig)
	MsgAlert("Arquivo informado no parametro MX_MR_HTML não existe"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor corrigir para envio correto do workflow.")
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
Local cToMail := AllTrim(SuperGetMV( "MX_MR_MAIL", , "marco.aurelio@opusvp.com.br;"              )) //E-mail dos usuários que serão notificados quando uma NF for gerada
Local cMdHtml := AllTrim(SuperGetMV( "MX_MR_HTML", , "\workflow\modelos\aviso_prenota.htm" )) //modelo html que será usado pra disparar os workflow

Private oHtml
Private oProcess

//Veritica se arquivo HTML existe no caminho informado
If !File(cMdHtml)
MsgAlert("Arquivo informado no parametro MX_MR_HTML não existe"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor corrigir para envio correto do workflow.")
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
//|Funcao....: fAjustHrUF()
//|Autor.....: Felipe Aurélio de Melo - felipeamelo@gmail.com
//|Data......: janeiro/fevereiro/março de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observação:
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerSA5   ºAutor  ³Marco Aurelio       º Data ³  13/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Amarracao Atraves de Tela Padrao(SA5/SA7)             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGerSA5

// Se for CTE, nao faz amarracao
if (cTab1)->&(cAls1+"_TIPXML") $ "2"
	return
endif

//Campos Customizados referente a conversão da unidade de medida
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
					cVldMensag := "O produto ( "+alltrim(cXmlPrdCod)+" ) do Fornecedor está com cadastro incompleto na tabela de relacionamento de produtos [SA5]!"
					fGravaMsg(nRecTab1,98," ",cVldMensag)
					lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,SA5->(Recno()))
				EndIf
			EndIf
		Else
			lVldProdut := .F.
			cVldMensag := "O produto ( "+alltrim(cXmlPrdCod)+" ) do Fornecedor não está cadastrado na tabela de relacionamento de produtos [SA5]!"
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
			cVldMensag := "O produto ("+cXmlPrdCod+") do Cliente não está cadastrado na tabela de relacionamento de produtos [SA7]!"
			fGravaMsg(nRecTab1,98," ",cVldMensag)
			lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut)
		EndIf
	EndIf
	
	//Valida se produto existe na tabela SA1
	If lVldProdut
		SB1->(dbSetOrder(1))
		If SB1->(!dbSeek(xFilial("SB1")+cCodProdut))
			lVldProdut := .F.
			cVldMensag := "O produto ( "+alltrim(cCodProdut)+" ) informado na rotina de produto x "+IIf(lEhFornec,"fornecedor","cliente")+" não existe no cadastro de produtos ou está com cadastro incompleto!"
			fGravaMsg(nRecTab1,98," ",cVldMensag)
		EndIf
	EndIf
	
	//Valida se produto na tabela SA1 está bloqueado
	If lVldProdut
		If SB1->B1_MSBLQL == "1"
			lVldProdut := .F.
			cVldMensag := "O produto ( "+alltrim(cCodProdut)+" ) está bloqueado no cadastro de produtos!"
			fGravaMsg(nRecTab1,98," ",cVldMensag)
		EndIf
	EndIf
	
	//Cancela operação pois tem que ajustar cadastro
	If !lVldProdut
		x := Len(oItens)
		lProc := .F.
	EndIf
	
Next x

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  
//³ 																³
//³ ##  Amarracao do FATOR DE CONVERSAO   ##  		³
//³ 																³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		MsgStop("Não é possível marcar um Produto sem fator de conversão.")
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
	MsgStop("Marque um item de NF para fazer manutenção no Fator de Conversão.")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma    ³ fArq      ³ Funcao para gravacao buffer arquivo HTML.                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fArq(c_FileOrig, c_FileDest)

Local l_Ret 	:= .T.
Local c_Buffer	:= ""
Local n_Posicao	:= 0
Local n_QtdReg	:= 0
Local n_RegAtu	:= 0

If !File(c_FileOrig)
	l_Ret := .F.
	MsgStop("Arquivo [ "+c_FileOrig+" ] não localizado.", "Não localizou")
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

@Li,((aMargem[4]/2)-25) Psay "FORMULÁRIO 1 - CONTROLE DE RECEBIMENTO DE PRODUTOS" Font ofntB12
@Li,(aMargem[4]-25) Psay "Impressão:" + Subs(DTOC(DATE()),1,6)+Subs(Alltrim(Str(Year(DATE()))),3,2)+' '+Subs(TIME(),1,5) Font ofntB10

Li++
@ Li,aMargem[2] to Li,aMargem[4]
Li++
@Li,02 Psay "Fornecedor: " + Posicione("SA2",1,xFilial("SA2")+cLinkForCd+cLinkForLj,"A2_NOME") Font ofntB10
@Li,(aMargem[4]-25) Psay "CNPJ: " + Transform(Posicione("SA2",1,xFilial("SA2")+cLinkForCd+cLinkForLj,"A2_CGC"),"@R 99.999.999/9999-99")  Font ofntB10
Li++
@Li,02 Psay "Nota Fiscal/Série: " + cNfRelat    Font ofntB10
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
@Li,nCol Psay "DESCRIÇÃO"      Font ofntB09
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
@Li,nCol Psay "APARÊNC"      Font ofntB08  //"APARÊNCIA"
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
@Li,nCol Psay "VEÍCULO"        Font ofntB08

Li++	
@ Li,aMargem[2] to Li,aMargem[4]
Li++

Return

Static Function fSalvar()
Local x

Local cTab1 := AllTrim(GetMV("MX_MRALS01")) 
Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cTab3 := AllTrim(GetMV("MX_MRALS03"))
Local cAls3 := IIf(SubStr(cTab3,1,1)=="S",SubStr(cTab3,2,2),cTab3)
Local aArea := (cTab3)->(GetArea())
    
(cTab3)->( dbSetOrder(1) )

For x := 1 to len(oXXGetDad:aCols)
   If !Empty(oXXGetDad:aCols[x][nXXPEDIDO]) .And. !Empty(oXXGetDad:aCols[x][nXXITEMPC])
      If (cTab3)->( dbSeek( xFilial() + (cTab1)->&(cAls1+"_CHVNFE") + oXXGetDad:aCols[x][nXXITEMXML] ) )
         Reclock(cTab3,.F.)
	     (cTab3)->&(cAls3+"_PEDIDO") := oXXGetDad:aCols[x][nXXPEDIDO]
	     (cTab3)->&(cAls3+"_ITEMPC") := oXXGetDad:aCols[x][nXXITEMPC]
	     (cTab3)->( msUnlock() )
	  Else
			Reclock(cTab3,.T.)
	         (cTab3)->&(cAls3+"_FILIAL") := xFilial(cTab3)
	         (cTab3)->&(cAls3+"_CHVNFE") := (cTab1)->&(cAls1+"_CHVNFE")
				(cTab3)->&(cAls3+"_ITEMXM") := oXXGetDad:aCols[x][nXXITEMXML]
				(cTab3)->&(cAls3+"_SEQ")    := ''
				(cTab3)->&(cAls3+"_PEDIDO") := oXXGetDad:aCols[x][nXXPEDIDO]
				(cTab3)->&(cAls3+"_ITEMPC") := oXXGetDad:aCols[x][nXXITEMPC]
				(cTab3)->&(cAls3+"_QTD")    := 0
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

						oXXGetDad:aCols[X,nXXOPER   ] := oYYGetDad:aCols[Y][nYYOPER  ] 
	 
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Retorna TES Inteligente³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_cOper	:= oYYGetDad:aCols[Y][nYYOPER  ]
						_cTesEnt	:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)
						oXXGetDad:aCols[X,nXXTES    ] := _cTesEnt
						// 
				
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  
//³ 																³
//³ ##  Amarra TES Inteligente  ##  		 			|		
//³ 																³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		MsgStop("Precisa haver primeiro amarração com um Produto.")
		Return
	Endif
  
	cCadOPER		:= oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXOPER]
	cCadTES		:= oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXTES]	
  //	cFullOper	:= cCadTES	// Utilizado para Gravar Operacao no retorno da TES Intigente			
	lRetFunc   := 	fGerRlcTES(cCodCliFor,cLojCliFor,cNomCliFor,cCadOPER,cCadTES)

Else
	MsgInfo("Marque um item de NF para fazer manutenção na TES INTELIGENTE.")
EndIf

Return 
                                                                                                               

Static Function fGerRlcTES(cCodCliFor,cLojCliFor,cNomCliFor,cCadOPER,cCadTES)


//Variaveis do tamanho a tela
Local aDlgTela     := {000,000,343,505} //{000,000,410,505} //{000,000,343,505}

//Divisões dentro da tela
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
Local cTitCad      := "Amarração TES Inteligente " 
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
	
	@ aDlgCorp1[1]+034,aDlgCorp1[2]+005 Say "Descrição"         Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+033,aDlgCorp1[2]+035 MsGet cCadPrdDes        Size 205 ,008 Pixel When .F. Of oDialg
	
	//Corpo 02
	@ aDlgCorp2[1], aDlgCorp2[2] To aDlgCorp2[3], aDlgCorp2[4] LABEL " Informe a Operação e TES a ser utilizada na Classificação deste Produto " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCorp2[1]+010+3,aDlgCorp2[2]+005 Say "Operacao"          Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+009+3,aDlgCorp2[2]+035 MsGet cCadOper          Size 085 ,008 Pixel When .T. Of oDialg F3 cMRSX5Oper Valid ExistCpo("SX5",cMRSX5Oper+cCadOper) //Valid(fVldRlcPrd(.F.))

	@ aDlgCorp2[1]+010+3,aDlgCorp2[2]+128 Say "TES"          		Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+009+3,aDlgCorp2[2]+155 MsGet cCadTES        	Size 085 ,008 Pixel When .T. Of oDialg F3 "SF4" Valid  ExistCpo("SF4",cCadTES)   //(Vazio() .or. fVldRlcTES()) //( Vazio() .or. ExistCpo("SF4",cCadTES)   )  //Valid(fVldRlcPrd(.F.))
	
	//Rodapé / Botões
//	@ aDlgRodp[1], aDlgRodp[2] To aDlgRodp[3], aDlgRodp[4] LABEL "" COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	@ aBtn01[1],aBtn01[2] Button "Processar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
	@ aBtn02[1],aBtn02[2] Button "Cancelar"  Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())
	
	Activate MsDialog oDialg Centered
	
	//Verifica se operação foi cancelada
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
				
	//Caso lReturn OK, então sair do Loop
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza Operacao/TES no Grid³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXOPER]	:= cCadOPER
		oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXTES]	:= cCadTES  
		cFullOper	:= cCadOPER
		oXXGetDad:Refresh()   

EndIf

Return(lReturn)
    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProg.ORI  ³fVldRlcTESºAutor  ³Felipe Aurelio      º Data ³  27/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³Marco Aurelio Silva º Data ³  13/10/15   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldRlcTES()

Local lOk  := .T.
Local lRet := .F.

If lOk .And. Empty(Alltrim(cCadTES))
	MsgAlert("TES não informada. Verifique!")
	lOk := .F.
EndIf

SF4->(dbSetOrder(1))
If lOk 
	if  SF4->(dbSeek(xFilial("SF4")+AllTrim(cCadTES)))
		if !(SF4->F4_TIPO $ "E")
	  		MsgAlert("Favor informar Somente TES de Operaçao de Entrada! " )
			lOk := .F.		 
		endif        

	else    
		MsgAlert("TES "+alltrim(cCadTES)+" não encontrada no cadastro! " )
		lOk := .F.
	Endif
EndIf

Return(lRet)
               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NoAcento  ºAutor  ³Microsiga           º Data ³  01/28/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao Extraida do Fonte  nfesefaz                         º±±
±±º          ³  Retira acentuacao                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
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
                       