#include 'tbiconn.ch'   //Funcoes para uso do Prepare Environment
#include 'tbicode.ch'
#include "protheus.ch"
#include "topconn.ch"
#include "totvs.ch"
#include "print.ch"
#include "font.ch"
#include "colors.ch"
#include "FIVEWIN.CH"
#include "MSOBJECT.CH
#include "rwmake.ch"

#DEFINE N_BUFFER 15000

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MRSXML22  ºAutor  ³Marco Aurelio Silva º Data ³  18/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Portal XML - Integrado ao Gestor de XML                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
User Function MRSXML22()

	Private _cChave
	Private oXXGetDad
	private _oCcnpj
	private _odEntreg
	private _dEntreg :=date()

	MsgRun("Portal XML","Inicializando Portal....",{|| fIniPortal() })
	//MsgRun("Rosenberger - Portal XML","Favor Aguardar.....",{|| fprocPortal() })
	fprocPortal()

Return

Static Function fIniPortal()

	If Type("cUsuario") == 'U'
		cRpcEmp    := "01"            // Codigo da empresa.
		cRpcFil    := "01"            // Codigo da filial.
		cEnvUser   := "Admin"         // Nome do usuario.
		cEnvPass   := "OpusDomex"     // Senha do usuario.
		cEnvMod    := "COM"           // 'COM'  // Codigo do modulo.
		cFunName   := "U_MRSXML22"    // 'RPC'  // Nome da rotina que ser setada para retorno da funo FunName().
		aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
		lShowFinal := .F.             // .F.    // Alimenta a varivel publica lMsFinalAuto.
		lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licena para a estao.
		lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando no passar a filial e realiza a abertura dos SXs.
		lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

		//RPCSetType(3)
		RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIf
Return


Static Function fprocPortal()

	PRIVATE _oChave
//	Private _cChave := '35220503618641000100550010000558371447664993'  // Space(44)
    Private _cChave := Space(44)
	Private _cCnpj  := substr(_cChave,7,14)

	Private nXXFLAG
	Private nXXITEMXML
	Private nXXPEDIDO
	Private nXXITEMPC
	Private nXXVALDESC
	Private nXXPRODXML
	Private nXXPRODUTO
	Private nXXDESCRIC
	Private nXXQTD1
	Private nXXQTD2
	Private nXXPRCUNIT
	Private nXXLOCAL
	Private nXXCC
	Private nXXFATOR
	Private nXXUM
	Private nXXTPFATOR
	Private nXXOPER
	Private nXXTES
	Private _cNF     := Space(10)
	Private _cRazao  := Space(11)
	Private _Cfornec := SPACE(40)
	Private _cCodFOR := SPACE(06)
	Private _cLojFOR := SPACE(02)
	Private _cFornec := SPACE(30)
	SA2->(DBSELECTAREA('SA2'))
	SA2->(DBSETORDER(3))
	If SA2->(DbSeek(xFilial("SA2")+_cCnpj))
		_cCodFOR := SA2->A2_COD
		_cLojFOR := SA2->A2_LOJA
		_cNomFOR := SA2->A2_NOME
		_cFornec := _cCodFOR+'-'+_cLojFOR+' '+_cNomFOR
	ENDIF

	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Rosenberger - Portal Xml - versão 17/05/22") FROM 0,0 TO 470,910 PIXEL of oMainWnd PIXEL

	@ 005, 008	SAY oTexto1   VAR OemToAnsi('Chave Eletronica NF-e ( XML )')  PIXEL SIZE 170,15
	oTexto1:oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	//@ 005, 200	SAY oTexto2   VAR OemToAnsi('CNPJ')  PIXEL SIZE 090,15    //
	//oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)


	@ 015, 008 MSGET _oChave VAR _cChave  Picture "@R 99999999999999999999999999999999999999999999"  SIZE 293,12 Valid ValidaCHV() PIXEL   //85,12
	_oChave:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)


	@ 005, 310 SAY oTexto4   VAR OemToAnsi('Entrega N.F.')  PIXEL SIZE 090,15    //
	oTexto4:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 015, 310 MSGET _odEntreg VAR _dEntreg  Picture "@R 99.999.999.9999-99"  SIZE 070,12 Valid .T. WHEN .T. PIXEL
	_odEntreg:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)

	//@ 015, 200 MSGET _oCcnpj VAR _cCNPJ  Picture "@R 99.999.999.9999-99"  SIZE 070,12  PIXEL   //85,12
	//_oCcnpj:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)
	//@ 015, 280 MSGET _oFornec VAR _cFornec  Picture "@!"  SIZE 130,12  PIXEL   //85,12
	//_oFornec:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)
	//----------------------------------------------------------------------------

	@ 030, 008	SAY oTexto2   VAR OemToAnsi('Nota Fiscal')  PIXEL SIZE 170,15
	oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 040, 08 MSGET _oNF VAR _cNF  SIZE 50,12 Valid .T. When .F. PIXEL
	_oNF:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)

	//----------------------------------------------------------------------------

	@ 030, 070	SAY oTexto3   VAR OemToAnsi('Emissor')  PIXEL SIZE 170,15
	oTexto3:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 040, 070 MSGET _oRazao VAR _cRazao  SIZE 150,12 Valid .T. WHEN .F. PIXEL
	_oRazao:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)

	@ 030, 230 SAY oTexto2   VAR OemToAnsi('CNPJ')  PIXEL SIZE 090,15    //
	oTexto2:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 040, 230 MSGET _oCcnpj VAR _cCNPJ  Picture "@R 99.999.999.9999-99"  SIZE 070,12 Valid .T. WHEN .F. PIXEL  //85,12
	_oCcnpj:oFont := TFont():New('Courier New',,14,,.T.,,,,.T.,.F.)




	//----------------------------------------------------------------------------

	//fNewGet(aPosIt1,oDialg,aItens,aUnidMed,aPrdDesc,aPrdXML)
	fNewGet()

	//@ 210,350 Button "Protocolo" Size 40,15 PIXEL OF oDlg1 ACTION PROTOCOL(_cChave)
	@ 210,400 Button "Confirmar" Size 40,15  PIXEL OF oDlg1 ACTION (Close(oDlg1))

	ACTIVATE MSDIALOG oDlg1 CENTERED

	// Se Confirmou a amarraçao do Pedido e Validação OK, permite Imprimir o Protocolo
	//if lTudoOK

	//Endif
	fSalvaZZ3()

RETURN


Static Function ValidaCHV()
	Local _lRet := .T.

	_cCnpj   :=substr(_cChave,7,14)
	_oCcnpj:Refresh()

	SA2->(DBSELECTAREA('SA2'))
	SA2->(DBSETORDER(3))
	If SA2->(DbSeek(xFilial("SA2")+_cCnpj))
		_cCodFOR := SA2->A2_COD
		_cLojFOR := SA2->A2_LOJA
		_cNomFOR := SA2->A2_NOME
		_Cfornec := _cCodFOR+'-'+_cLojFOR+' '+_cNomFOR
	ENDIF


	If !Empty(_cChave)

		ZZ0->( dbSetOrder(3) )
		If !(ZZ0->( dbSeek( xFilial() + _cChave ) ))
			MsgRun("Buscando XMLs","Chave não encontrada....",{|| U_wTrataXML( .T. ) })
		Endif

		If ZZ0->( dbSeek( xFilial() + _cChave ) )

			// Verifica se a NF está habilitada para ser lançada
			if	ZZ0->ZZ0_TIPXML == "1" .and. ZZ0->ZZ0_STATUS == "1" .and. ZZ0->ZZ0_TIPDOC == "N"
				//MyMsg("NF-e Disponivel para Amarração.",1)
				_lRet := .T.
				fCarregaNF(_cChave)
			Else
				MyMsg("Este XML não está disponível para Amarração de Pedido de Compra."+Chr(13)+Chr(10)+"Verifique com o Depto. Compras da Rosenberger.",1)
				_lRet := .F.
			ENDIF
		Else
			MyMsg("XML não foi localizado em nosso Banco de Dados.",1)
			_lRet := .F.
		EndIf

	Else
		MyMsg("A Chave Eletronica precisa ser informada.",1)
		_lRet    := .F.
	EndIf

Return(_lRet)

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
Static Function fNewGet(aSizeDlg,oDialg,aItens,aUnidMed,aPrdDesc,aPrdXML)

	// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := GD_UPDATE                                             // Nil // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local aAlter         := {"XX_TES","XX_OPER","XX_PEDIDO","XX_ITEMPC","XX_DATPRF"}
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "U_VcpoPort"                                    // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHeadXX        := {}                                              // Array do aHeader
	Local aColsXX        := {}                                              // Array do aCols

	//            X3_TITULO        , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL                      , X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(aHeadXX,{""               ,"XX_FLAG"      ,"@BMP"               ,          01,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Item XML"       ,"XX_ITEMXML"   ,"@!"                 ,          04,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Prod. XML"      ,"XX_PRODXML"   ,"@!"                 ,          10,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	//aAdd(aHeadXX,{"Produto"        ,"XX_PRODUTO"   ,"@!"                 ,          10,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Descricao"      ,"XX_DESCRIC"   ,"@!"                 ,          20,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	//aAdd(aHeadXX,{"Operacao"     ,"XX_OPER"      ,"@!"                 ,          02,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""               		       , ""        , ""        })
	//aAdd(aHeadXX,{"TES"		   ,"XX_TES"       ,"@!"                 ,          03,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Unid."          ,"XX_UM"        ,"@!"                 ,          05,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	//aAdd(aHeadXX,{"Quant. 1ª UM" ,"XX_QTD1"      ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Quant."         ,"XX_QTD2"      ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHeadXX,{"Preco Unit."    ,"XX_PRCUNIT"   ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	//aAdd(aHeadXX,{"Desconto"     ,"XX_VALDESC"   ,"@E 999,999,999.99"  ,          08,                                2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	//aAdd(aHeadXX,{"Local"        ,"XX_LOCAL"     ,"@!"                 ,          02,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , "NNR"   , "R"        , ""                 , ""         ,""                            ,"A"      , ""            				    , ""        , ""        })
	//aAdd(aHeadXX,{"C.Custo"      ,"XX_CC"        ,"@!"                 ,          06,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , "CTT"   , "R"        , ""                 , ""         ,""                            ,"A"      , ""				                , ""        , ""        })
	aAdd(aHeadXX,{"Num.PC"         ,"XX_PEDIDO"    ,"@!"                 ,          08,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , "SC7PRT", "R"        , ""                 , ""         ,""                            ,"A"      , ""                            , ""        , ""  })     //"SC7POR"
	aAdd(aHeadXX,{"It.PC"          ,"XX_ITEMPC"    ,"@!"                 ,          04,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""                            , ""        , ""  })
	aAdd(aHeadXX,{"Produto"        ,"XX_PRODUTO"   ,"@!"                 ,          15,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""                            , ""        , ""  })
	aAdd(aHeadXX,{"Prev Entrega"   ,"XX_DATPRF"    ,""                   ,          08,                                0, ""      , "€€€€€€€€€€€€€€", "D"    , ""      , "R"        , ""                 , ""         ,""                            ,"A"      , ""                            , ""        , ""  })
	//aAdd(aHeadXX,{"Fator Conversão","XX_FATOR"   ,"@E 9999.9999"       ,          09,                                4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	//aAdd(aHeadXX,{"Tipo Fator"     ,"XX_TPFATOR" ,"@R"                 ,          07,                                0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

	//Contorno
	//@ 40, 05 To 210, 410 Of oDlg1 Pixel

	oXXGetDad := MsNewGetDados():New(80,10,200,450,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHeadXX,aColsXX)
	//oXXGetDad:oBrowse:bLDblClick  := { || fXXClick()      }

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
	nXXPRODXML := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_PRODXML" })
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
	nXXPRODUTO := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_PRODUTO" })
	dXXDATPRF  := aScan(oXXGetDad:aHeader,{|x|Alltrim(x[2])=="XX_DATPRF"  })


	// Chamada para Atribuir CORES as linhas do Grid 01
	//oXXGetDad:oBrowse:lUseDefaultColors := .F.
	//oXXGetDad:oBrowse:SetBlkBackColor({|| CorGd01(oXXGetDad:nAt,8421376,aColsXX)})
	//oXXGetDad:oBrowse:Refresh()

Return



Static Function fCarregaNF(_cChave)
//alterado mauricio

	Private _cxCusto  :=space(Len(SD1->D1_CC))    // Alimenta Centro de Custo quando nao tem PC
	Private _cxLocal  :=space(Len(SD1->D1_LOCAL)) // Alimenta aRMAZEM quando nao tem PC
	Private _lTesINT  := .F.
	Private aUnidMed  := {}
	Private aPrdDesc  := {}
	Private aPrdNcm   := {}
	Private aPrdXML   := {}

	If ZZ0->( dbSeek( xFilial() + _cChave ) )

		_cNF    := ZZ0->ZZ0_DOC
		_cRazao := ZZ0->ZZ0_DENOME

		cMmXml   := ""
		cMmXml   += AllTrim(ZZ0->ZZ0_MXML)
		cMmXml   += AllTrim(ZZ0->ZZ0_MXML2)

		lEhFornec := .t.
		lProc     := .t.
		_lTagPC   := .t.
		cAviso    := ""
		cErro     := ""
		oXmlTab1  := Nil
		oXmlTab1  := XmlParser(cMmXml,"_",@cAviso,@cErro)

		Do Case
		Case !Empty(cErro)
			//XML com erro de estrutura ( Status = 2 )
			//fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		Case !Empty(cAviso)
			//XML com erro de estrutura ( Status = 2 )
			//fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		Case Empty(oXmlTab1)
			//XML com erro de estrutura ( Status = 2 )
			//fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		OtherWise
			//Prepara Objeto pra receber XML
			oNFe := oXmlTab1
			oNF  := IIf(Type("oNFe:_NfeProc")<>"U" , oNFe:_NFeProc:_NFe , oNFe:_NFe)
		EndCase

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

				/*
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
                */

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

				If _lTagPC .And. Type("oItemTemp:_Prod:_xPed") <> "U" .And. ZZ0->ZZ0_TIPDOC == "N"
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

				If _lTagPC  .And. Type("oItemTemp:_Prod:_nItemPed") <> "U" .And. ZZ0->ZZ0_TIPDOC == "N"
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
				If  _lTesINT

					IF AllTrim(GetMV("MX_MRCLASS"))	== "C"
						_cProd		:= SB1->B1_COD
						_cFornec		:= cCodCliFor
						_cLojaFor	:= cLojCliFor
						_cOper		:= "01" //cFullOper  // MAURESI - 06/09/2019
						_cTesEnt		:= U_ReTesENT(_cProd,cCodCliFor,cLojCliFor,_cOper)

						aadd(aLinha,{"D1_TES"	,_cTesEnt,Nil,Nil})
						if lCliDMX
							aadd(aLinha,{"D1_XOPER"	,_cOper	,Nil,Nil})
						else
							aadd(aLinha,{"D1_OPER"	,_cOper	,Nil,Nil})
						endif
					ELSE
						aadd(aLinha,{"D1_TES"		,""      ,Nil,Nil})
						if lCliDMX
							aadd(aLinha,{"D1_XOPER"	,"00"		,Nil,Nil})
						else
							aadd(aLinha,{"D1_OPER"	,"00"		,Nil,Nil})
						endif
					ENDIF

				else
					aadd(aLinha,{"D1_TES","",Nil,Nil})
					aadd(aLinha,{"D1_XOPER","00",Nil,Nil})

				Endif

				aAdd(aUnidMed,oItemTemp:_Prod:_uCom:TEXT  )
				aAdd(aPrdDesc,oItemTemp:_Prod:_xProd:TEXT )
				aAdd(aPrdNcm, oItemTemp:_Prod:_NCM:TEXT   )
				aAdd(aPrdXML ,cXmlProduto                 )		//	cXmlProduto := AllTrim(oItemTemp:_Prod:_cProd:TEXT)

				aadd(aItens,aLinha)

			Next x

			nD1QUANT   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_QUANT"   })
			nD1VUNIT   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_VUNIT"   })
			nD1PEDIDO  := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_PEDIDO"  })
			nD1ITEMPC  := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_ITEMPC"  })
			//nD1COD     := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_COD"     })
			//nD1QUANT   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_QUANT"   })
			//nD1TOTAL   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_TOTAL"   })
			//nD1VUNIT   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_VUNIT"   })
			//nD1VALDESC := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_VALDESC" })
			//nD1LOCAL   := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_LOCAL"   })
			//nD1CC      := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_CC"      })
			//nD1TES     := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_TES" 	  })
			//nD1OPER    := aScan(aItens[1] , { |k| AllTrim(k[1]) == "D1_XOPER"	  })

			oXXGetDad:aCols := {}
			For x := 1 to Len(aItens)
				nQtd1    := 0
				nQtd2    := aItens[x][nD1QUANT][2]
				//nFator   := aFatorCon[y,1]
				//cTpFator := aFatorCon[y,2]

				AADD(oXXGetDad:aCols,array(Len(oXXGetDad:aHeader)+1))
				oXXGetDad:aCols[x,Len(oXXGetDad:aHeader)+1] := .F.			
				oXXGetDad:aCols[x,nXXITEMXML] := StrZero(x,4)
				oXXGetDad:aCols[x,nXXPRODXML] := aPrdXML[x]
				oXXGetDad:aCols[x,nXXDESCRIC] := aPrdDesc[x]
				oXXGetDad:aCols[x,nXXUM]      := aUnidMed[x]
				oXXGetDad:aCols[x,nXXQTD2]    := nQtd2
				oXXGetDad:aCols[x,nXXPRCUNIT] := aItens[x][nD1VUNIT][2]
				//oXXGetDad:aCols[x,nXXPEDIDO]  := aItens[x][nD1PEDIDO][2]
				//oXXGetDad:aCols[x,nXXITEMPC]  := aItens[x][nD1ITEMPC][2]
				oXXGetDad:aCols[x,nXXPEDIDO]  := SPACE(06)
				oXXGetDad:aCols[x,nXXITEMPC]  := SPACE(04)
				oXXGetDad:aCols[x,nXXPRODUTO] := SPACE(15)
				If ZZ6->( dbSeek( xFilial() + _cChave + oXXGetDad:aCols[x][nXXITEMXML] ) )
					oXXGetDad:aCols[x,nXXPEDIDO]  := ZZ6->ZZ6_PEDIDO
					oXXGetDad:aCols[x,nXXITEMPC]  := ZZ6->ZZ6_ITEMPC
					oXXGetDad:aCols[x,nXXPRODUTO] := ZZ6->ZZ6_COD
					//oXXGetDad:aCols[x,dXXDATPRF]:= ZZ6->ZZ6_DATPRF
				endif

			Next x

			oXXGetDad:oBrowse:Refresh()

		ENDIF

	ENDIF



Return

Static Function MyMsg(cAviso,nOpc)
	Local oFont1 := TFont():New("Arial",,044,,.F.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("Arial",,036,,.F.,,,,,.F.,.F.)
	Local oSay1
	Local lRet:= .T.
	Local oDlg3
	Local cStartPath        := GetSrvProfString('Startpath','')
	//Local cFileErro			:= cStartPath + 'errado.jpg'
	//Local cFileok			:= cStartPath + 'certo.jpg'
	//Local cFileLogo			:= cStartPath + 'logo.png'
	Local cFileAten			:= cStartPath + 'Atencao.png'
	Local cFileInter		:= cStartPath + 'Interroga.png'


	if nOpc == 1
		DEFINE MSDIALOG oDlg3 TITLE "Aviso" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
		@ 002, 150 BITMAP oBitmap10 SIZE 150, 150 OF oDlg3 FILENAME cFileAten NOBORDER PIXEL

		@ 090, 012 SAY oSay1 PROMPT cAviso SIZE 381, 092 OF oDlg3 FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 151, 149 BUTTON oButton1 PROMPT "OK" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End() ) FONT oFont1 PIXEL
	Elseif nOpc == 2
		DEFINE MSDIALOG oDlg3 TITLE "Aviso" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
		@ 002, 150 BITMAP oBitmap10 SIZE 150, 150 OF oDlg3 FILENAME cFileInter NOBORDER PIXEL

		@ 090, 012 SAY oSay1 PROMPT cAviso SIZE 381, 092 OF oDlg3 FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 151, 090 BUTTON oButton1 PROMPT "Não" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End(),lRet:= .F. ) FONT oFont1 PIXEL
		@ 151, 210 BUTTON oButton1 PROMPT "SIM" SIZE 098, 043 OF oDlg3 ACTION ( oDlg3:End() ) FONT oFont1 PIXEL
	Endif

	ACTIVATE MSDIALOG oDlg3 CENTERED

	if nOpc == 2
		Return lRet
	Else
		Return
	Endif

RETURN

Static Function fTrtCodPrd(cCodProd,cTipoCad)

	Local cRet 			:= ""
	Local nTam 			:= 0
	Default cCodProd	:= ""
	Default cTipoCad	:= "" //1=SA5 (Fornec), 2=SA7(Cliente)

	cRet := Upper(cCodProd)
	cRet := AllTrim(cRet)

	Do Case
	Case cTipoCad == "1"
		nTam 	:= 35 //fX3Ret("A5_CODPRF","X3_TAMANHO")
	Case cTipoCad == "2"
		nTam 	:= 15 //fX3Ret("A7_CODCLI","X3_TAMANHO")
	EndCase

	cRet := Right(cRet,nTam)
	cRet := AllTrim(cRet)
	cRet := PadR(cRet,nTam)

Return(cRet)


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
±±ºPrograma  ³PROTOCOL  ºAutor  ³Marco Aurelio-OPUSVPº Data ³ 11/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PROTOCOL(cChave)

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
	cEmail	:= "marco.aurelio@opusvp.com.br"
	cArquivo:= "C:\Windows\Temp\PORTALXML-Protocolo.html"   //"\WORKFLOW\MODELOS\PORTALXML-Protocolo.html"
	U_EnvMailto(cTit,cMsg,cEmail,"",cArquivo)

Return


Static Function fSalvaZZ3()
	Local x

	Local cTab1 := AllTrim(GetMV("MX_MRALS01"))
	Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
	Local cTab3 := AllTrim(GetMV("MX_MRALS03"))
	Local cAls3 := IIf(SubStr(cTab3,1,1)=="S",SubStr(cTab3,2,2),cTab3)
	Local aArea := (cTab3)->(GetArea())

	(cTab3)->( dbSetOrder(1) )

	For x := 1 to len(oXXGetDad:aCols)
		//If !Empty(oXXGetDad:aCols[x][nXXPEDIDO]) .And. !Empty(oXXGetDad:aCols[x][nXXITEMPC])
		If (cTab3)->( dbSeek( xFilial() + (cTab1)->&(cAls1+"_CHVNFE") + oXXGetDad:aCols[x][nXXITEMXML] ) )
			Reclock(cTab3,.F.)
			(cTab3)->&(cAls3+"_PEDIDO") := oXXGetDad:aCols[x][nXXPEDIDO]
			(cTab3)->&(cAls3+"_ITEMPC") := oXXGetDad:aCols[x][nXXITEMPC]
			(cTab3)->&(cAls3+"_QTD")    := oXXGetDad:aCols[x][nXXQTD2]
			(cTab3)->&(cAls3+"_COD")    := oXXGetDad:aCols[x][nXXPRODUTO]
			//(cTab3)->&(cAls3+"_DATPRF") := oXXGetDad:aCols[x]dXXDATPRF]
			(cTab3)->( msUnlock() )
		Else
			Reclock(cTab3,.T.)
			(cTab3)->&(cAls3+"_FILIAL") := xFilial(cTab3)
			(cTab3)->&(cAls3+"_CHVNFE") := (cTab1)->&(cAls1+"_CHVNFE")
			(cTab3)->&(cAls3+"_ITEMXM") := oXXGetDad:aCols[x][nXXITEMXML]
			(cTab3)->&(cAls3+"_SEQ")    := ''
			(cTab3)->&(cAls3+"_PEDIDO") := oXXGetDad:aCols[x][nXXPEDIDO]
			(cTab3)->&(cAls3+"_ITEMPC") := oXXGetDad:aCols[x][nXXITEMPC]
			(cTab3)->&(cAls3+"_QTD")    := oXXGetDad:aCols[x][nXXQTD2]
			(cTab3)->&(cAls3+"_COD")    := oXXGetDad:aCols[x][nXXPRODUTO]
			(cTab3)->&(cAls3+"_ORIGEM") :=  "I" // G=Gestor I=Interno(Portal) P=Portal Fornecedor			
			//	(cTab3)->&(cAls3+"_DATPRF") := oXXGetDad:aCols[x]dXXDATPRF]
			(cTab3)->( msUnlock() )
		EndIf
		//EndIf
	Next x

Return


User Function FiSC7POR()
	_Retorno := .F.

	If SC7->C7_FORNECE == _cCodFOR
		IF SC7->C7_LOJA == _cLojFOR
			If SC7->C7_QUANT>SC7->C7_QUJE
				_Retorno := .T.
			EndIf
		EndIf
	ENDIF
Return _Retorno

User Function VcpoPort()  // Valida Pedido Portal
	Local _Retorno := .T.
	Local cPedido  := SC7->C7_NUM
	Local cItemPC  := SC7->C7_ITEM
	Local cProduto := SC7->C7_PRODUTO
	Local cQuery
	Local cProdXML := oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXPRODXML]
	Local cPedido  := oXXGetDad:aCols[oXXGetDad:oBrowse:nAt,nXXPEDIDO ]

	If ReadVar() == "M->XX_PEDIDO"
		IF !Empty(M->XX_PEDIDO)
			SC7->( dbSetOrder(1) )
			If SC7->( dbSeek( xFilial() + M->XX_PEDIDO ) )
				If SC7->C7_FORNECE <> _cCodFOR .or. SC7->C7_LOJA <> _cLojFOR
					cInternBkp := __cInternet
					__cInternet := Nil
					MsgStop("Pedido '"+M->XX_PEDIDO+"' não pertence ao Fornecedor " + _cCodFOR+'/'+_cLojFOR + Chr(13) + 'CNPJ: ' + _cCnpj)
					_Retorno := .F.
					__cInternet := cInternBkp
				EndIf
			Else
				cInternBkp := __cInternet
				__cInternet := Nil
				MsgStop("Pedido '"+M->XX_PEDIDO+"' inválido")
				_Retorno := .F.
				__cInternet := cInternBkp
			ENDIF
		EndIf
	ENDIF

	If ReadVar() == "M->XX_ITEMPC"
		IF !Empty(cPedido)
			SC7->( dbSetOrder(1) )
			If SC7->( dbSeek( xFilial() + cPedido + M->XX_ITEM ) )
					SA5->( dbSetOrder( RetOrder("SA5","A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF") ) )
					//If 

					cInternBkp := __cInternet
					__cInternet := Nil
					MsgStop("Pedido '"+M->XX_PEDIDO+"' não pertence ao Fornecedor " + _cCodFOR+'/'+_cLojFOR + Chr(13) + 'CNPJ: ' + _cCnpj)
					_Retorno := .F.
					__cInternet := cInternBkp
				
			Else
				cInternBkp := __cInternet
				__cInternet := Nil
				MsgStop("Pedido/Item'"+cPedido+'/'+M->XX_ITEM+"' inválido")
				_Retorno := .F.
				__cInternet := cInternBkp
			ENDIF
		else
				cInternBkp := __cInternet
				__cInternet := Nil
				MsgStop("Favor preencher o campo Pedido antes do Item")
				_Retorno := .F.
				__cInternet := cInternBkp
		EndIf
	ENDIF
Return _Retorno



// Função para Carregar Consulta Específica criada no (( Consulta Padrão))
/*
User Function zConsSC7()
//        lOk :=  u_zConsEsp("SC7", {"C7_NUM","C7_ITEM","C7_PRODUTO","C7_DESCRI","C7_QUANT","C7_PRECO","C7_TOTAL"}, " AND C7_FORNECE+C7_LOJA = '"+_cCodFOR+_cLojFOR+"' AND C7_ENCER <> 'E' AND ((C7_QUANT-C7_QUJE) > 0) AND C7_CONAPRO <> 'B' AND C7_RESIDUO  = '' ", "C7_NUM,C7_ITEM")
        lOk :=  u_zConsEsp("SC7", {"C7_NUM","C7_ITEM","C7_QUANT","XX_SALDO"}, " AND C7_FORNECE+C7_LOJA = '"+_cCodFOR+_cLojFOR+"' AND C7_ENCER <> 'E' AND ((C7_QUANT-C7_QUJE) > 0) AND C7_CONAPRO <> 'B' AND C7_RESIDUO  = '' ", "C7_NUM,C7_ITEM",{(C7_QUANT-C7_QUJE)} )

Return lOk
*/
