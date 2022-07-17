#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "TOpconn.ch"
#include "protheus.ch"

User Function MNU02COLETOR()
	U_MNUCOLETOR("FILMG","02")
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ MNUCOLETOR   ∫Autor  ≥Helio Ferreira ∫ Data ≥  19/09/12    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                                                            ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function MNUCOLETOR(cDep, cFilDOM) // MostraFunc(OK)
	Private _cSenha  := Space(6)

	Private nOpca    := 0
	Private nSkipLin := 17
	Private nLin     := 01
	Private nCol     := 10
	Private nCol2    := 20
	Private nLargBut := 95
	Private nAltuBut := 16
	Private aAcessos := {}
	Private cStartPath := GetSrvProfString('Startpath','')
	Private cImgFundo:= ""
	Private oBtn
	Public cUsuario

	Default cDep   	:= 'REC'
	Default cFilDOM := '01'


	cDep       := Alltrim(cDep)
	cRpcEmp    := "01"            // CÛdigo da empresa.
	cRpcFil    := cFilDOM //"01"            // CÛdigo da filial.
	cEnvUser   := "Admin"         // Nome do usu·rio.
	cEnvPass   := "OpusDomex"     // Senha do usu·rio.
	cEnvMod    := "EST"           // 'FAT'  // CÛdigo do mÛdulo.
	cFunName   := "U_MNUCOLETOR"  // 'RPC'  // Nome da rotina que ser· setada para retorno da funÁ„o FunName().
	aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
	lShowFinal := .F.             // .F.    // Alimenta a vari·vel publica lMsFinalAuto.
	lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licenÁa para a estaÁ„o.
	lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando n„o passar a filial e realiza a abertura dos SXs.
	lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

//RPCSetType(3)
	RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"


	nAMaxTela := 265
	nLMaxTela := 233
	nWebPx:= 1
	nWebPx2:= 1

	cAmbiente:= UPPER(GETENVSERV())
	IF U_WEBCOL(cAmbiente)
		nWebPx:= 1.5
		nWebPx2:= 1.3
		nFont1:= 17*nWebPx
		nLargBut := 95*nWebPx
		nAltuBut := 16*nWebPx
		nSkipLin := 17*nWebPx
		nLin     := 01*nWebPx
		nCol     := 05
		nAMaxTela := 450
		nLMaxTela := 302
		nCol2    := 10

		cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-size:15% 60%;background-position: 1% 33%;background-repeat:no-repeat ;border-radius: 6px;}"
		cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-size:15% 60%;background-position: 1% 33%;background-repeat:no-repeat ;border-radius: 6px;}"
		cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-size:15% 60%;background-position: 1% 33%;background-repeat:no-repeat ;border-radius: 6px;}"
	Else
		nWebPx:= 1
		nFont1:= 17
		cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-repeat:no-repeat ;border-radius: 6px;}"
		cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-repeat:no-repeat ;border-radius: 6px;}"
		cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-repeat:no-repeat ;border-radius: 6px;}"
	Endif


	DEFINE MSDIALOG oDlgMenu02 TITLE OemToAnsi("Menu Filial " + cFilAnt) FROM 0,0 TO nAMaxTela,nLMaxTela PIXEL of oMainWnd PIXEL

	cUsuario  := ""
	aUsuarios := {}

	SX5->( dbSetOrder(1) )
	SX5->( dbSeek( xFilial() + "ZA" ) )
	While !SX5->( EOF() ) .and. SX5->X5_TABELA == "ZA"
		AADD(aUsuarios,Alltrim(SX5->X5_CHAVE))
		SX5->( dbSkip() )
	End

//AADD(aUsuarios,'Eder')
//AADD(aUsuarios,'Luis')
//AADD(aUsuarios,'Jair')
//AADD(aUsuarios,'Sergio')
//AADD(aUsuarios,'Wanda')
//AADD(aUsuarios,'Nilda')
//AADD(aUsuarios,'Denis')
//AADD(aUsuarios,'Helio')


	IF U_WEBCOL(cAmbiente)
		if Alltrim(cAmbiente) =="WEBCOL" .and. cFilDOM == '01'
			cImgFundo:= "Coletor01.jpg"
		elseif Alltrim(cAmbiente) =="WEBCOL_VALIDACAO"
			cImgFundo:= "Coletor01V.jpg"
		elseif Alltrim(cAmbiente) =="WEBCOL" .and. cFilDOM == '02'
			cImgFundo:= "Coletor02.jpg"
		elseif Alltrim(cAmbiente) =="WEBCOLMG_VALIDACAO"
			cImgFundo:= "Coletor02V.jpg"
		Endif


		oTBitmap := TBitmap():New(0,0,450,302,,cStartPath+cImgFundo,.T.,oDlgMenu02,{|| nLinUsr := 0},,.F.,.F.,,,.F.,,.T.,,.F.)
		oTBitmap:lAutoSize := .T.


	Else
		oTBitmap := TBitmap():New(-13,30,260,184,,cStartPath+"LGMID01.png",.T.,oDlgMenu02,{|| nLinUsr := 0},,.F.,.F.,,,.F.,,.T.,,.F.)
		oTBitmap:lAutoSize := .T.
	EndIf

	nLin := 35
//@ nLin, 020	SAY oTexto1 Var 'Login Coletor:'    SIZE 100,10 PIXEL
//oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin += 20
	@ nLin, nCol2	SAY oTexto2 Var 'Usu·rio:'    SIZE 30*nWebPx ,10*nWebPx  PIXEL
	oTexto2:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	@ nLin, 055 COMBOBOX oCombo1  VAR cUsuario ITEMS aUsuarios    SIZE 47*nWebPx ,12*nWebPx  VALID .T. PIXEL
	oCombo1:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	nLin += 20
	@ nLin+1, nCol2	SAY oTexto3 Var 'Senha:'    SIZE 30*nWebPx ,10*nWebPx  PIXEL
	oTexto3:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	@ nLin, 050 MSGET oSenha VAR _cSenha  Picture "@R 999999"  SIZE 52*nWebPx,12*nWebPx WHEN .T. PASSWORD Valid ValidaSenha() PIXEL
	oSenha:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
	cEstiloPsw := "QLineEdit{ border: 1px solid gray;border-radius: 5px;background-repeat:no-repeat;background-color: #ffffff;selection-background-color: #ffffff;"
	cEstiloPsw += "background-image:url(rpo:cadeado_mdi.png); "
	cEstiloPsw += "background-repeat: no-repeat;"
	cEstiloPsw += "background-attachment: fixed;"
	cEstiloPsw += "padding-left:25px; }"
	oSenha:setCSS(cEstiloPsw)

	nLin += 15*nWebPx
	@ nLin, nCol BUTTON oBtn01 PROMPT "Acessar menu" ACTION Processa( {|| oDlgMenu02:End(),If(ValidaSenha(),ColetorMenu(cDep),.F.) } ) SIZE nLargBut,nAltuBut*nWebPx PIXEL OF oDlgMenu02
	cCSSBtN1 := "QPushButton{background-image: url(rpo:bmpcpo.png);"+cPush+;
		"QPushButton:pressed {background-image: url(rpo:bmpcpo.png);"+cPressed+;
		"QPushButton:hover {background-image: url(rpo:bmpcpo.png);"+cHover
	oBtn01:setCSS(cCSSBtN1)

	nLin += 30*nWebPx
	@ nLin, nCol BUTTON oBtn02 PROMPT "Trocar senha" ACTION Processa( {|| oDlgMenu02:End(),TroSen1()} ) SIZE nLargBut,nAltuBut*nWebPx PIXEL OF oDlgMenu02
	cCSSBtN2 := "QPushButton{background-image: url(rpo:cadeado_mdi.png);"+cPush+;
		"QPushButton:pressed {background-image: url(rpo:cadeado_mdi.png);"+cPressed+;
		"QPushButton:hover {background-image: url(rpo:cadeado_mdi.png);"+cHover
	oBtn02:setCSS(cCSSBtN2)

	ACTIVATE MSDIALOG oDlgMenu02 // ON INIT EnchoiceBar( oDlgMenu01,{|| nOpca := 0,oDlgMenu01:End()},{|| nOpca := 0,oDlgMenu01:End()} ) //CENTER

Return

Static Function ColetorMenu(cDep)

	Default cDep   := 'REC'

// Validando senha
	If !ValidaSenha()
		Return
	EndIf



	nLin     := 01

// Acessos
// Rotina 01 - "SeparaÁ„o de PeÁas da filial 01"        - Filial 01
// Rotina 02 - "PV Transf. PeÁa Filial 01 p/ 04"        - Filial 01
// Rotina 03 - "Recebimento de Pecas - G1"              - Filial 01
// Rotina 04 - "Consulta PeÁas - G1"                    - Filial 04
// Rotina 05 - "Termino da Sep. do Pedido - G1"         - Filial 04
// Rotina 06 - "Termino da Sep. do Romaneio - G1"       - Filial 04
// Rotina 07 - "TransferÍncia do endereÁo das Pc - 01"  - Filial 01
// Rotina 08 - "Invent·rio de Tecidos "                 - Filial 01
// Rotina 09 - "Carregar peÁas no caminh„o"             - Filial 01
// Rotina 10 - "Apontar TOPS Cardas"                    - Filial 01
// Rotina 11 - "Entrega TOPS Malharia"                  - Filial 01
// Rotina 12 - "Cancelamento TOPS Cardas"               - Filial 01
// Rotina 13 - "DevoluÁ„o de Tops Almox"                - Filial 01
// Rotina 14 - "RecepÁ„o de PeÁas - Triagem"            - Filial 01
// Rotina 15 - "Fluxo de PeÁas - Triagem"               - Filial 01
// Rotina 16 - "Envio de Pecas para o Acabamento"       - Filial 01
// Rotina 17 - "Pecas disponivel para o CQL     "       - Filial 01
// Rotina 18 - "Entrega de material para produÁ„o"      - Filial 01
// Rotina 19 - "Empenhar peÁas na OP"                   - Filial 01

	If Upper(cDep) == 'REC'
		AADD(aAcessos, 20)
		AADD(aAcessos, 21)
		AADD(aAcessos, 22)
		AADD(aAcessos, 23)
		AADD(aAcessos, 24)
		AADD(aAcessos, 25)
	EndIf

	If Upper(cDep) == 'FILMG'
		AADD(aAcessos, 02)
		AADD(aAcessos, 03)
		AADD(aAcessos, 04)
		AADD(aAcessos, 05)
		AADD(aAcessos, 06)
		AADD(aAcessos, 07)
		AADD(aAcessos, 08)
		AADD(aAcessos, 09)
		AADD(aAcessos, 10)
		AADD(aAcessos, 11)
		AADD(aAcessos, 12)
		AADD(aAcessos, 13)
		AADD(aAcessos, 14)
		AADD(aAcessos, 15)
		AADD(aAcessos, 16)
		AADD(aAcessos, 17)
		AADD(aAcessos, 18)
		AADD(aAcessos, 19)
		AADD(aAcessos, 26)


	EndIf

//U_MostraFunc(ProcName(),'MNU01COLETOR')

	DEFINE MSDIALOG oDlgMenu01 TITLE OemToAnsi("Menu Filial " + cFilAnt) FROM 0,0 TO nAMaxTela,nLMaxTela PIXEL of oMainWnd PIXEL

	@ 00,00 SCROLLBOX oScroll VERTICAL BORDER SIZE 133*nWebPx, 118*nWebPx PIXEL OF oMainWnd

//u_WFblOpCq("10000001001")


// Rotina 20
	If aScan(aAcessos,22) <> 0
		Private oBtn03 := Nil
		@ nLin, nCol BUTTON oBtn03 PROMPT "EndereÁamento Recebimento" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW01(), U_DOMACD01())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:armazem.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:armazem.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:armazem.png);"+cHover
		oBtn03:SetCss(cCSSBtN1)
		nLin += nSkipLin
	EndIf

// Rotina 21
//If aScan(aAcessos,21) <> 0
//	@ nLin, nCol BUTTON "Etiqueta Estoque Inicial"   ACTION Processa( {|| U_DOMACD02()} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01	
//	nLin += nSkipLin
//EndIf

// Rotina 22
	If aScan(aAcessos,22) <> 0
		Private oBtn04 := Nil
		@ nLin, nCol BUTTON oBtn04 PROMPT "Invent·rio por Produto"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW03(), U_DOMACD03())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:bpmsdoca.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bpmsdoca.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bpmsdoca.png);"+cHover
		oBtn04:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,22) <> 0
		Private oBtn04 := Nil
		@ nLin, nCol BUTTON oBtn04 PROMPT "Invent·rio CÌclico (Matriz)"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW45("01"), U_DOMACD45("01"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:bpmsdoca.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bpmsdoca.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bpmsdoca.png);"+cHover
		oBtn04:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,22) <> 0
		Private oBtn04 := Nil
		@ nLin, nCol BUTTON oBtn04 PROMPT "Invent·rio CÌclico (Filial MG)"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW45("02"), U_DOMACD45("02"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:bpmsdoca.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bpmsdoca.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bpmsdoca.png);"+cHover
		oBtn04:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,22) <> 0
		Private oBtn04 := Nil
		@ nLin, nCol BUTTON oBtn04 PROMPT "PaletizaÁ„o ProduÁ„o"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW46(), U_DOMACD46())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:bpmsdoca.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bpmsdoca.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bpmsdoca.png);"+cHover
		oBtn04:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn05 := Nil
		@ nLin, nCol BUTTON oBtn05 PROMPT "Pagamento de OP" ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW05(), U_DOMACD05())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:bmpcpo.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bmpcpo.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bmpcpo.png);"+cHover

		"QPushButton{font: bold 10px Arial;background-image: url(rpo:pcoimg32.png);background-repeat:no-repeat; }"+;
			"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
		oBtn05:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,23) <> 0
		Private oBtn06 := Nil
		@ nLin, nCol BUTTON oBtn06 PROMPT "Kamban"   ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW06(), U_DOMACD06()) } ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:trmimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:trmimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:trmimg32.png);"+cHover

		oBtn06:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		oBtn06 := Nil
		@ nLin, nCol BUTTON oBtn06 PROMPT "Kamban Filial MG"   ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW43(), U_DOMACD43()) } ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:trmimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:trmimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:trmimg32.png);"+cHover
		oBtn06:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	//jonas - perda 96
	If aScan(aAcessos,23) <> 0
		Private oBtn07 := Nil
		@ nLin, nCol BUTTON oBtn07 PROMPT "Pagamento de Perdas"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW35(), U_DOMACD35())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:mdirun.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:mdirun.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:mdirun.png);"+cHover
		oBtn07:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,23) <> 0
		Private oBtn08 := Nil
		@ nLin, nCol BUTTON oBtn08 PROMPT "Invent·rio GERAL" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW18(), U_DOMACD18()) } ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:s4wb007n_mdi.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:s4wb007n_mdi.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:s4wb007n_mdi.png);"+cHover
		oBtn08:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,23) <> 0
		Private oBtn09 := Nil
		@ nLin, nCol BUTTON oBtn09 PROMPT "Pagamento de Senf"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW12(), U_DOMACD12())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:lojimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:lojimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:lojimg32.png);"+cHover
		oBtn09:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn10 := Nil
		@ nLin, nCol BUTTON oBtn10 PROMPT "TransferÍnc.Entre EndereÁos"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW10(), U_DOMACD10())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:destinos_mdi.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:destinos_mdi.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:destinos_mdi.png);"+cHover
		oBtn10:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn11 := Nil
		@ nLin, nCol BUTTON oBtn11 PROMPT "DevoluÁ„o MP p/ Estoque"      ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW14(), U_DOMACD14())}  ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover
		oBtn11:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn12 := Nil
		@ nLin, nCol BUTTON oBtn12 PROMPT "DevoluÁ„o PA/PI p/ Estoque"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW15(), U_DOMACD15())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover
		oBtn12:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn15 := Nil
		@ nLin, nCol BUTTON oBtn15 PROMPT "Aponta ProduÁ„o DIO" ACTION Processa( {||IF(U_WEBCOL(cAmbiente), U_DOMACW21(), U_DOMACD21())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:iceimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:iceimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:iceimg32.png);"+cHover
		oBtn15:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn16 := Nil
		@ nLin, nCol BUTTON oBtn16 PROMPT "PaletizaÁ„o" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW22(), U_DOMACD22())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:armimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:armimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:armimg32.png);"+cHover
		oBtn16:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn13 := Nil
		@ nLin, nCol BUTTON oBtn13 PROMPT "Reimprime Etiq. ExpediÁ„o" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW20(), U_DOMACD20())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:s4wb010n.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:s4wb010n.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:s4wb010n.png);"+cHover
		oBtn13:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn20 := Nil
		@ nLin, nCol BUTTON oBtn20 PROMPT "Montagem KIT ExpediÁ„o" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW27(), U_DOMACD27())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:qipimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:qipimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:qipimg32.png);"+cHover
		oBtn20:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0 ;

		Private oBtn22 := Nil
		@ nLin, nCol BUTTON oBtn22 PROMPT "Desmonta Embalagem" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW29(), U_DOMACD29())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgarmazem.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgarmazem.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgarmazem.png);"+cHover
		oBtn22:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn17 := Nil
		@ nLin, nCol BUTTON oBtn17 PROMPT "Faturamento de Pedidos" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW23(), U_DOMACD23())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:preco_mdi.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:preco_mdi.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:preco_mdi.png);"+cHover
		oBtn17:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		oBtn20 := Nil
		@ nLin, nCol BUTTON oBtn20 PROMPT "Conferencia de Carga" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW26(), U_DOMACD26())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:tmsimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:tmsimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:tmsimg32.png);"+cHover
		oBtn20:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn19 := Nil
		@ nLin, nCol BUTTON oBtn19 PROMPT "Etiqueta TELEFONICA"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW25(), U_DOMACD25())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:totvsprinter_spool.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:totvsprinter_spool.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:totvsprinter_spool.png);"+cHover
		oBtn19:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn35 := Nil
		@ nLin, nCol BUTTON oBtn35 PROMPT "Etiqueta OI S/A"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW36(1), U_DOMACD36(1))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:totvsprinter_spool.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:totvsprinter_spool.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:totvsprinter_spool.png);"+cHover
		oBtn35:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn35 := Nil
		@ nLin, nCol BUTTON oBtn35 PROMPT "Etiqueta V-TAL"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW36(2), U_DOMACD36(2))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:totvsprinter_spool.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:totvsprinter_spool.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:totvsprinter_spool.png);"+cHover
		oBtn35:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,23) <> 0
		Private oBtn35 := Nil
		@ nLin, nCol BUTTON oBtn35 PROMPT "Etiqueta Global"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACD47(), U_DOMACD47())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:totvsprinter_spool.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:totvsprinter_spool.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:totvsprinter_spool.png);"+cHover
		oBtn35:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,23) <> 0
		Private oBtn21 := Nil
		@ nLin, nCol BUTTON oBtn21 PROMPT "Embalagem Nivel 3"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW28(), U_DOMACD28())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:pcocube.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:pcocube.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:pcocube.png);"+cHover
		oBtn21:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn18 := Nil
		@ nLin, nCol BUTTON oBtn18 PROMPT "Embalagem para SENF" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW24(), U_DOMACD24())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:wmsimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:wmsimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:wmsimg32.png);"+cHover
		oBtn18:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn14 := Nil
		@ nLin, nCol BUTTON oBtn14 PROMPT "Embalagem"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW19(), U_DOMACD19())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:estimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:estimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:estimg32.png);"+cHover
		oBtn14:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn30 := Nil
		@ nLin, nCol BUTTON oBtn30 PROMPT "Consulta Etiqueta"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW30(), U_DOMACD30())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:bmpcons.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bmpcons.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bmpcons.png);"+cHover
		oBtn30:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn31 := Nil
		@ nLin, nCol BUTTON oBtn31 PROMPT "Entrega de Bobinas Matriz"  ACTION Processa( {||IF(U_WEBCOL(cAmbiente), U_DOMACW31(), U_DOMACD31())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:sdunew.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:sdunew.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:sdunew.png);"+cHover
		oBtn31:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,23) <> 0
		oBtn41 := Nil
		@ nLin, nCol BUTTON oBtn31 PROMPT "Entrega de Bobinas Filial MG"  ACTION Processa( {||IF(U_WEBCOL(cAmbiente), U_DOMACW41(), U_DOMACD41())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:sdunew.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:sdunew.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:sdunew.png);"+cHover
		oBtn31:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn32 := Nil
		@ nLin, nCol BUTTON oBtn32 PROMPT "DevoluÁ„o de Bobinas"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW32(), U_DOMACD32())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:sduimport.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:sduimport.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:sduimport.png);"+cHover
		oBtn32:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	//joao cozer - montagem de KIT
	If aScan(aAcessos,23) <> 0
		Private oBtn34 := Nil
		@ nLin, nCol BUTTON oBtn34 PROMPT "Montagem Kit - Obra"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW34(), U_DOMACD34())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avg_embm.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avg_embm.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avg_embm.png);"+cHover
		oBtn34:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,24) <> 0
		oBtn35 := Nil

		@ nLin, nCol BUTTON oBtn35 PROMPT "Huawei - Etiqueta Externa"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW37(), U_DOMACD37())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:BONUS.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:BONUS.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:BONUS.png);"+cHover
		oBtn35:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,25) <> 0
		Private oBtn36 := Nil

		@ nLin, nCol BUTTON oBtn36 PROMPT "DevoluÁ„o KIT PIG p/Estoque"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW38(), U_DOMACD38())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover

		oBtn36:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf



	If aScan(aAcessos,25) <> 0
		oBtn36 := Nil
		@ nLin, nCol BUTTON oBtn36 PROMPT "Pagto. OP Picklist (Matriz)"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW39("01"), U_DOMACD39("01"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover

		oBtn36:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,25) <> 0
		oBtn36 := Nil
		@ nLin, nCol BUTTON oBtn36 PROMPT "Pagto. OP Picklist (Fil.MG)"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW39("02"), U_DOMACD39("02"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover
		oBtn36:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		Private oBtn40 := Nil
		@ nLin, nCol BUTTON oBtn40 PROMPT "Re-Impres.Etq.PickList (Matriz)" ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW40(), U_DOMACD40())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:pcoimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:pcoimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:pcoimg32.png);"+cHover
		oBtn40:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,23) <> 0
		oBtn40 := Nil
		@ nLin, nCol BUTTON oBtn40 PROMPT "Re-Impres.Etq.PickList (Fil.MG)"        ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW42(), U_DOMACD42())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:pcoimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:pcoimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:pcoimg32.png);"+cHover
		oBtn40:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±± 							BOTOES DA FILIAL MG 		 				  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

	If aScan(aAcessos,15) <> 0
		Private oBtn04 := Nil
		@ nLin, nCol BUTTON oBtn04 PROMPT "PaletizaÁ„o ProduÁ„o MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW46(), U_DOMACD46())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:bpmsdoca.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bpmsdoca.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bpmsdoca.png);"+cHover
		oBtn04:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,02) <> 0
		oBtn06 := Nil
		@ nLin, nCol BUTTON oBtn06 PROMPT "SeparaÁ„o/Envio Matriz" ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW44(), U_DOMACD44()) } ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:DEVOLNF.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:DEVOLNF.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:DEVOLNF.png);"+cHover
		oBtn06:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,03) <> 0
		oBtn07 := Nil
		@ nLin, nCol BUTTON oBtn07 PROMPT "EndereÁamento Receb.MG" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW01(), U_DOMACD01())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:armazem.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:armazem.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:armazem.png);"+cHover
		oBtn07:SetCss(cCSSBtN1)
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,04) <> 0
		oBtn08 := Nil
		@ nLin, nCol BUTTON oBtn08 PROMPT "Invent·rio por Produto MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW03(), U_DOMACD03())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 := "QPushButton{background-image: url(rpo:bpmsdoca.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:bpmsdoca.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:bpmsdoca.png);"+cHover
		oBtn08:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,05) <> 0
		oBtn09 := Nil
		@ nLin, nCol BUTTON oBtn09 PROMPT "Kamban MG"   ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW06(), U_DOMACD06()) } ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:trmimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:trmimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:trmimg32.png);"+cHover

		oBtn09:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,06) <> 0
		oBtn10 := Nil
		@ nLin, nCol BUTTON oBtn10 PROMPT "Pagamento de Perdas MG"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW35(), U_DOMACD35())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:mdirun.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:mdirun.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:mdirun.png);"+cHover
		oBtn10:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,07) <> 0
		oBtn11 := Nil
		@ nLin, nCol BUTTON oBtn11 PROMPT "Pagamento de Senf MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW12(), U_DOMACD12())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:lojimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:lojimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:lojimg32.png);"+cHover
		oBtn11:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,08) <> 0
		oBtn12 := Nil
		@ nLin, nCol BUTTON oBtn12 PROMPT "Pagto.OP Picklist MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW39("02"), U_DOMACD39("02"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover

		oBtn12:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,09) <> 0
		oBtn13 := Nil
		@ nLin, nCol BUTTON oBtn13 PROMPT "Re-Impres.Etq.PickList MG"  ACTION Processa( {||  IF(U_WEBCOL(cAmbiente), U_DOMACW42(), U_DOMACD42())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:pcoimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:pcoimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:pcoimg32.png);"+cHover
		oBtn13:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,10) <> 0
		oBtn14 := Nil
		@ nLin, nCol BUTTON oBtn14 PROMPT "Devol. MP p/ Estoque MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW14(), U_DOMACD14())}  ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover
		oBtn14:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,11) <> 0
		oBtn15 := Nil
		@ nLin, nCol BUTTON oBtn15 PROMPT "Devol.PA/PI p/ Estoque MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW15(), U_DOMACD15())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgbox1.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgbox1.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgbox1.png);"+cHover
		oBtn15:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,12) <> 0
		oBtn16 := Nil
		@ nLin, nCol BUTTON oBtn16 PROMPT "Transf.Entre EndereÁos MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW10(), U_DOMACD10())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:destinos_mdi.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:destinos_mdi.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:destinos_mdi.png);"+cHover
		oBtn16:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf


	If aScan(aAcessos,14) <> 0
		Private oBtn22 := Nil
		@ nLin, nCol BUTTON oBtn22 PROMPT "Desmonta Embalagem MG" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW29(), U_DOMACD29())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:avgarmazem.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:avgarmazem.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:avgarmazem.png);"+cHover
		oBtn22:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,16) <> 0
		Private oBtn21 := Nil
		@ nLin, nCol BUTTON oBtn21 PROMPT "Emb.Nivel 3 MG"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW28(), U_MsgColetor("ROTINA N√O PREPARADA PARA COLETOR WINDOWS"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:pcocube.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:pcocube.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:pcocube.png);"+cHover
		oBtn21:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,17) <> 0
		Private oBtn22 := Nil
		@ nLin, nCol BUTTON oBtn22 PROMPT "Embalagem MG"   ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW19(), U_MsgColetor("ROTINA N√O PREPARADA PARA COLETOR WINDOWS"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:estimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:estimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:estimg32.png);"+cHover
		oBtn22:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,18) <> 0
		Private oBtn23 := Nil
		@ nLin, nCol BUTTON oBtn23 PROMPT "Faturamento MG" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW23(),  U_MsgColetor("ROTINA N√O PREPARADA PARA COLETOR WINDOWS"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:preco_mdi.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:preco_mdi.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:preco_mdi.png);"+cHover
		oBtn23:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,19) <> 0
		Private oBtn19 := Nil
		@ nLin, nCol BUTTON oBtn19 PROMPT "Embalagem SENF MG" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW24(), U_DOMACD24())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:wmsimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:wmsimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:wmsimg32.png);"+cHover
		oBtn19:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If aScan(aAcessos,13) <> 0
		Private oBtn17 := Nil
		@ nLin, nCol BUTTON oBtn17 PROMPT "PaletizaÁ„o MG" ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW22(), U_DOMACD22())} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
		cCSSBtN1 :=  "QPushButton{background-image: url(rpo:armimg32.png);"+cPush+;
			"QPushButton:pressed {background-image: url(rpo:armimg32.png);"+cPressed+;
			"QPushButton:hover {background-image: url(rpo:armimg32.png);"+cHover
		oBtn17:SetCSS( cCSSBtN1 )
		nLin += nSkipLin
	EndIf

	If U_VALIDACAO ("RODA") .or. .T.
		If aScan(aAcessos,26) <> 0
			Private oBtn26 := Nil
			@ nLin, nCol BUTTON oBtn26 PROMPT "Invent·rio CÌclico MG"  ACTION Processa( {|| IF(U_WEBCOL(cAmbiente), U_DOMACW45("02"), U_DOMACD45("02"))} ) SIZE nLargBut,nAltuBut PIXEL OF oScroll //oDlgMenu01
			cCSSBtN1 := "QPushButton{background-image: url(rpo:bpmsdoca.png);"+cPush+;
				"QPushButton:pressed {background-image: url(rpo:bpmsdoca.png);"+cPressed+;
				"QPushButton:hover {background-image: url(rpo:bpmsdoca.png);"+cHover
			oBtn26:SetCSS( cCSSBtN1 )
			nLin += nSkipLin
		EndIf
	EndIf




	ACTIVATE MSDIALOG oDlgMenu01 // ON INIT EnchoiceBar( oDlgMenu01,{|| nOpca := 0,oDlgMenu01:End()},{|| nOpca := 0,oDlgMenu01:End()} ) //CENTER

	If nOpca == 20
		Processa( { || U_PGPROD() })
	EndIf

Return



Static Function TroSen1()
	Private _cSenha  := Space(6)
	Private _cSenha1 := Space(6)
	Private _cSenha2 := Space(6)

	DEFINE MSDIALOG oDlgMenu03 TITLE OemToAnsi("Troca de senha") FROM 0,0 TO nAMaxTela,nLMaxTela PIXEL of oMainWnd PIXEL

	nLin := 15
	@ nLin, 010	SAY oTexto2 Var 'Usu·rio:'    SIZE 30,10 PIXEL
	oTexto2:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	@ nLin, 055  MSGET _oUsuario VAR cUsuario  Picture "@R"  SIZE 45,10 WHEN .F. PIXEL
	_oUsuario:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	nLin += 20
	@ nLin, 010	SAY oTexto3 Var 'Senha atual:'    SIZE 50,10 PIXEL
	oTexto3:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	@ nLin, 055               MSGET oSenha VAR _cSenha  Picture "@R 999999"  SIZE 45,10 WHEN .T. PASSWORD Valid ValidaSenha() PIXEL
	oSenha:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	nLin += 20
	@ nLin, 010	SAY oTexto4 Var 'Nova Senha:'    SIZE 50,10 PIXEL
	oTexto4:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	@ nLin, 055               MSGET oSenha1 VAR _cSenha1  Picture "@R 999999"  SIZE 45,10 WHEN .T. PASSWORD Valid !Empty(_cSenha1) PIXEL
	oSenha1:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	nLin += 20
	@ nLin, 010	SAY oTexto5 Var 'Redigitar:'    SIZE 50,10 PIXEL
	oTexto5:oFont := TFont():New('Arial',,nFont1,,.T.,,,,.T.,.F.)

	@ nLin, 055               MSGET oSenha2 VAR _cSenha2  Picture "@R 999999"  SIZE 45,10 WHEN .T. PASSWORD Valid ValidaSenha() PIXEL
	oSenha2:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	nLin += 35
	@ nLin, 10 BUTTON "Concluir"    ACTION Processa( {|| oDlgMenu03:End(),TroSen2()} ) SIZE nLargBut,nAltuBut PIXEL OF oDlgMenu03

	ACTIVATE MSDIALOG oDlgMenu03 // ON INIT EnchoiceBar( oDlgMenu01,{|| nOpca := 0,oDlgMenu01:End()},{|| nOpca := 0,oDlgMenu01:End()} ) //CENTER

Return

Static Function ValidaSenha()

	SX5->( dbSetOrder(1) )

	If !Empty(_cSenha)
		If SX5->( dbSeek( xFilial() + "ZA" + cUsuario ) )
			sx5_senha := AllTrim(SX5->X5_DESCRI)
			If _cSenha <> sx5_senha .or. Empty(sx5_senha)
				U_MsgColetor("Senha Inv·lida.")
				Return .F.
			Else
				SetUserDefault(Alltrim(SX5->X5_DESCSPA))
			EndIf
		Else
			U_MsgColetor("Senha Inv·lida.")
			Return .F.
		EndIf
	Else
		U_MsgColetor("A senha n„o pode ser em branco.")
		Return .T.
	EndIf

Return .T.

Static Function TroSen2()

	If Empty(_cSenha1) .or. Empty(_cSenha2)
		U_MsgColetor("A senha n„o pode estar em branco.")
	Else
		If _cSenha1 <> _cSenha2
			U_MsgColetor("Novas senha e       redigitaÁ„o da senha diferentes.")
		Else
			SX5->( dbSetOrder(1) )
			If SX5->( dbSeek( xFilial() + "ZA" + Subs(cUsuario,1,6) ) )
				Reclock("SX5",.F.)
				SX5->X5_DESCRI := _cSenha1
				SX5->( msUnlock() )
				U_MsgColetor("Senha alterada com  sucesso.")
				_cSenha := _cSenha1
			Else
				U_MsgColetor("Usuario n„o encontrado na tabela ZA.")
			EndIf
		EndIf
	EndIf

	ColetorMenu()

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹            '
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MsgColetor∫Autor  ≥Michel Sander       ∫ Data ≥  17/10/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Mensagem de Yes/No para o coletor de dados				     ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ 	MsgColetor("Texto. Continua?")                          ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function MsgColetor(cMsg,nSegundos)

	LOCAL nTamFonte := -12
	Local oTexto1
	Local oMemoMsg, oBtnSim, oBtnNao
	Local oTelaMsg

	Default nSegundos := 0

	cMsg := AllTrim(cMsg)
	cAmbiente:= UPPER(GETENVSERV())
	//apMsgYesNo('Ambiente: ' + cAmbiente + ' - Mandar foto para Jonas')
	IF U_WEBCOL(cAmbiente)
		//	apMsgYesNo('Webcol - Mandar foto para Jonas')
		nWebPx:= 1.5
		nWebPx2:= 1.3
		nFont1:= 17*nWebPx
		nLargBut := 95*nWebPx
		nAltuBut := 16*nWebPx
		nSkipLin := 17*nWebPx
		nLin     := 01*nWebPx
		nCol     := 05
		nAMaxTela := 450
		nLMaxTela := 302
		nCol2    := 10

		cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-size:15% 60%;background-position: 1% 33%;background-repeat:no-repeat ;border-radius: 6px;}"
		cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-size:15% 60%;background-position: 1% 33%;background-repeat:no-repeat ;border-radius: 6px;}"
		cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-size:15% 60%;background-position: 1% 33%;background-repeat:no-repeat ;border-radius: 6px;}"
	Else
		//apMsgYesNo('Windows - Mandar foto para Jonas')
		nWebPx:= 1
		nFont1:= 17
		cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-repeat:no-repeat ;border-radius: 6px;}"
		cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-repeat:no-repeat ;border-radius: 6px;}"
		cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
			"background-repeat:no-repeat ;border-radius: 6px;}"
	Endif

	If Len(cMsg) >= 360
		nTamFonte := -10
	EndIf

	DEFINE MSDIALOG oTelaMsg TITLE OemToAnsi("Mensagem") From 1,1 To 18*nWebPx,28*nWebPx

	@ 003,005 GET oMemoMsg VAR cMsg MEMO PIXEL SIZE 98*nWebPx,100*nWebPx FONT (TFont():New('Verdana',,nTamFonte*nWebPx,.T.)) NO BORDER
	oMemoMsg:lReadOnly := .T.

	If nSegundos == 0
		@ 105,020	SAY oTexto1 Var "Deseja Continuar?"    SIZE 98*nWebPx,10*nWebPx PIXEL Of oTelaMsg COLOR CLR_HBLUE
		oTexto1:ofont := TFont():New('Arial',,18*nWebPx,,.T.,,,,.T.,.F.)
		oTexto1:lReadOnly := .T.

		@ 115*nWebPx,61*nWebPx Button oBtnNao PROMPT "N„o" Size 35*nWebPx,10*nWebPx Pixel Of oTelaMsg
		cCSSBtN1 := "QPushButton{"+cPush+;
			"QPushButton:pressed {"+cPressed+;
			"QPushButton:hover {"+cHover
		oBtnNao:setCSS(cCSSBtN1)

		@ 115*nWebPx,10 Button oBtnSim PROMPT "Sim" Size 35*nWebPx,10*nWebPx Action oTelaMsg:End() Pixel Of oTelaMsg
		cCSSBtN1 := "QPushButton{"+cPush+;
			"QPushButton:pressed {"+cPressed+;
			"QPushButton:hover {"+cHover
		oBtnSim:setCSS(cCSSBtN1)

		oBtnNao:SetFocus()
	EndIf

	If nSegundos <> 0
		DEFINE TIMER oTimer INTERVAL (nSegundos*1000) ACTION oTelaMsg:End() OF oTelaMsg
		oTimer:Activate()
	EndIf

	ACTIVATE DIALOG oTelaMsg

Return


User Function UMSGYESNO(cMsg,cMsg2)

	LOCAL nTamFonte := -12
	Local oMemoMsg, oBtnSim, oBtnNao
	Local oTelaMsg
	Local _Retorno

	Default cMsg2 := ""

	cMsg := AllTrim(cMsg)

	cMsg += Chr(10)+Chr(13)

	cMsg += cMsg2

	If Len(cMsg) >= 360
		nTamFonte := -10
	EndIf

	DEFINE MSDIALOG oTelaMsg TITLE OemToAnsi("Mensagem") From 1,1 To 18*nWebPx,28*nWebPx

	@ 003,005 GET oMemoMsg VAR cMsg MEMO PIXEL SIZE 98*nWebPx,100*nWebPx FONT (TFont():New('Verdana',,nTamFonte*nWebPx,.T.)) NO BORDER
	oMemoMsg:lReadOnly := .T.

	@ 115,10 Button oBtnSim PROMPT "Sim" Size 35*nWebPx,10*nWebPx Action {|| _Retorno:=.T.,oTelaMsg:End()} Pixel Of oTelaMsg
	cCSSBtN1 := "QPushButton{"+cPush+;
		"QPushButton:pressed {"+cPressed+;
		"QPushButton:hover {"+cHover
	oBtnSim:setCSS(cCSSBtN1)

	@ 115,61*nWebPx Button oBtnNao PROMPT "N„o" Size 35*nWebPx,10*nWebPx Action {|| _Retorno:=.F.,oTelaMsg:End()} Pixel Of oTelaMsg
	cCSSBtN1 := "QPushButton{"+cPush+;
		"QPushButton:pressed {"+cPressed+;
		"QPushButton:hover {"+cHover
	oBtnNao:setCSS(cCSSBtN1)


	ACTIVATE DIALOG oTelaMsg

Return _Retorno

//Static Function fEspera(nSeg)
//Sleep(nSeg*1000)
//Return

User Function WEBCOL(cAmbiente)

	Local aAmbiente := {}
	Local _Retorno  := .T.

	cAmbiente := Upper(Alltrim(cAmbiente))

	AADD(aAmbiente,"WEBCOL")
	AADD(aAmbiente,"WEBCOLMG_VALIDACAO")
	AADD(aAmbiente,"WEBCOL_VALIDACAO")
	AADD(aAmbiente,"RICARDO.OPUS")

	If aScan(aAmbiente,cAmbiente) <> 0
		_Retorno := .T.
	Else
		_Retorno := .F.
	EndIf

Return _Retorno
