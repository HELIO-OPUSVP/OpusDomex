#include "rwmake.ch"
#include "protheus.ch"         
#INCLUDE "TOPCONN.CH"   
#include "tbiconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMPERDA    บAutor:  Jackson Santos    บ Data ณ  04/03/22   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de apontamento de perdas da produ็ใo.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMPERDA()         

Local aIndex := {} 
Local lFiltro:= .F.
Local cFiltro := "ZA_SALDO <> 0  .AND. ZA_TIPO =='S'"
Local cQuery:= ""

Local aCores := {;
{"ZA_SALDO==0 .AND. ZA_TIPO = 'N'" , "DISABLE"     },;
{"ZA_SALDO<>0 .AND. ZA_TIPO = 'N'" , "BR_VERDE"    },;
{"ZA_SALDO==0 .AND. ZA_TIPO = 'S'" , "BR_CINZA"    },;
{"ZA_SALDO<>0 .AND. ZA_TIPO = 'S'" , "BR_AZUL"     }}

Private bFiltraBrw := { || FilBrowse( "SZA" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCelula:= 0
Private cArm:= '96'

//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

DbSelectArea("SZA")
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Incluir         ",'U_DPDINCLUI'  , 0, 3 } )
AADD(aRotina,{ "Mแquina Corte   ",'U_fButtCel'   , 0, 4 } )
AADD(aRotina,{ "Excluir         ",'U_DPDDELETA'  , 0, 5 } )
AADD(aRotina,{ "Alterar         ",'U_DPDALTERA'  , 0, 6 } )
AADD(aRotina,{ "Reimprimir      ",'U_DPDREIMP'   , 0, 7 } )
AADD(aRotina,{ "Legenda         ",'U_fLegDomP'  , 0, 8 } )
AADD(aRotina,{ "Cad.Operador    ",'U_CADZZM'  	 , 0, 9 } )


cCadastro := "DOMPERDA - Perdas da Produ็ใo - Domex"
//SetKey(VK_F10, { || U_fReImp() } )

IF MsgYesNo ("Filtrar somente fibras เ pagar?")

	cQuery:= " UPDATE SZA010 SET ZA_TIPO = 'N'  "
	cQuery+= " FROM "+RetSqlTab("SZA")
	cQuery+= " INNER JOIN "+RetSqlTab("SB1")+" ON B1_COD = ZA_PRODUTO  AND B1_GRUPO NOT IN ('FO','FOFS') AND SB1.D_E_L_E_T_ = '' "
	cQuery+= " WHERE SZA.D_E_L_E_T_ = ''  "
	TCSQLEXEC(cQuery)

	cQuery:= " UPDATE SZA010 SET ZA_TIPO = 'S'  "
	cQuery+= " FROM "+RetSqlTab("SZA") 
	cQuery+= " INNER JOIN "+RetSqlTab("SB1")+" ON B1_COD = ZA_PRODUTO  AND B1_GRUPO IN ('FO','FOFS') AND SB1.D_E_L_E_T_ = '' "
	cQuery+= " WHERE SZA.D_E_L_E_T_ = '' "
	TCSQLEXEC(cQuery)

	Eval( bFiltraBrw ) //Efetiva o Filtro antes da Chamada a mBrowse 
	lFiltro:= .T.
Endif

mBrowse( 6, 1,22,75,"SZA",,,,,,aCores              ,,,,,,,,)  // "U_CADSZATOK()" )

IF lFiltro
	EndFilBrw( "SZA" , @aIndex ) //Finaliza o Filtro 
Endif
//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

//RESET ENVIRONMENT

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
						Inclusใo de registro de perda
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DPDINCLUI()
Local nOK
//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui("SZA"    , 0     , 3     ,        ,        ,        , "U_CADSZATOK()" )

If nOk == 1
	Reclock("SZA",.F.)
	SZA->ZA_DATA := DATE()
	SZA->ZA_HORA := Time()
	SZA->( msUnlock() )
	
	If SB1->B1_APROPRI == 'I' .or. Subs(SB1->B1_COD,1,8) == '50010100'
		_nQtdTot    := SZA->ZA_SALDO

	  	Reclock("SZA",.F.)
		SZA->ZA_SALDO := 0
	  	SZA->( msUnlock() )
	
    Else    
    	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ GERA EMPENHO NA CRIACAO DA PERDAณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  		SD4PERDA(SZA->ZA_PRODUTO, cArm, SZA->ZA_OP, SZA->ZA_QTDORI,.F. ) 
  		U_CRIAP07(SZA->ZA_PRODUTO, cArm)	
		//FIM
		
		 if !(Posicione("SB1",1,xFilial("SB1")+SZA->ZA_PRODUTO,"B1_GRUPO") $ "FO|FOFS")
			If MsgYesNo("Deseja imprimir a etiqueta?")
				Etiqueta()
			EndIf
		ENdif	
	 EndIf  
EndIf

Return
//----------------------------------------------------------

//User Function fReImp()

//Return

//------------------------------------------------------------


User Function fLegDomP()

BrwLegenda("","Legenda",{;
{"BR_CINZA"   ,"Perda Fibras - Pagas" 		},;  
{"BR_AZUL"    ,"Perda Fibras - เ Pagar"		},; 
{"DISABLE"    ,"Perdas Outros - Pagas"		},; 
{"BR_VERDE"   ,"Perdas Outros - เ Pagar"	}}) 

Return

User Function DPDINIC_DOC()

Return "000001"

Static Function Etiqueta()
Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()

Reclock("SZA",.F.)
SZA->ZA_DATA := DATE()
SZA->ZA_HORA := Time()
SZA->( msUnlock() )

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBSay(28,01,"PAGAMENTO: PERDA PRODUวรO","N","3","1,1")


n := 3
// 01
MSCBSay(28,01+n,"DATA:"+DtoC(SZA->ZA_DATA)+" HORA:"+SZA->ZA_HORA+Space(10)+Transform(SZA->ZA_SALDO,"@E 999,999.99"),"N","2","1,1")
//03
MSCBSay(28,03+n,"OPERA.:"+SZA->ZA_OPERADO+" QTD:"+Transform(SZA->ZA_SALDO,"@E 999,999.99"),"N","2","1,1")
//05
MSCBSay(28,05+n,"PRODUTO: "+Alltrim(SZA->ZA_PRODUTO)+" "+Alltrim(SZA->ZA_DESC),"N","2","1,1")

//MSCBSayBar - Imprime c๓digo de barras ( nXmm nYmm cConteudo cRota็ใo cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
//07
MSCBSayBar(31,07+n,SZA->ZA_DOCUMEN,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)
//18
MSCBSay(46,18+n,"OP: "+SZA->ZA_OP,"N","2","1,1")

MSCBEnd()

MSCBClosePrinter()

RestArea(_aAreaGER)


/*
MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBSay(28,01,"ALMOXARIFADO :"+SBE->BE_LOCAL,"N","2","1,1")
MSCBSay(28,03,"ENDERECO :"+SBE->BE_LOCALIZ,"N","2","1,1")
MSCBSayBar(27,06,SBE->BE_LOCAL+SubStr(SBE->BE_LOCALIZ,1,13),"N","MB07",10,.F.,.T.,.F.,,2,1,Nil,Nil,Nil,Nil)
MSCBEnd()
MSCBClosePrinter()
*/



Return


User Function DPDALTERA()

If SZA->ZA_QTDORI == SZA->ZA_SALDO
	nOK := AxAltera("SZA",0,4)
	
	If nOk == 1 
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ GERA EMPENHO NA ALTERACAO DA PERDAณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//SD4PERDA(SZA->ZA_PRODUTO, '96', SZA->ZA_OP, SZA->ZA_QTDORI,.F. ) 
		//FIM
		
		Reclock("SZA",.F.)
		SZA->ZA_DATA := DATE()
		SZA->ZA_HORA := Time()
		SZA->( msUnlock() )  
		
		
		if !(Posicione("SB1",1,xFilial("SB1")+SZA->ZA_PRODUTO,"B1_GRUPO") $ "FO|FOFS")
			If MsgYesNo("Deseja imprimir a etiqueta?")
				Etiqueta()
			EndIf
		ENdif	
	EndIf
Else
	MsgStop("Altera็ใo nใo permitida. Perda jแ atendida.")
EndIf

Return


User Function DPDREIMP()

if !(Posicione("SB1",1,xFilial("SB1")+SZA->ZA_PRODUTO,"B1_GRUPO") $ "FO|FOFS")
	If SZA->ZA_QTDORI == SZA->ZA_SALDO
		If MsgYesNo("Deseja imprimir a etiqueta?")
			Etiqueta()
		EndIf
	Else
		MsgStop("Reimpressใo nใo permitida. Perda jแ atendida.")
	EndIf
Endif
Return

User Function DPDDELETA()

If SZA->ZA_SALDO == 0
	MsgStop("Perda com pagamento jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
Else
	If SZA->ZA_QTDORI <> SZA->ZA_SALDO
		MsgStop("Perda com pagamento parcial jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
	Else        
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ EXCLUI EMPENHOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		SD4PERDA(SZA->ZA_PRODUTO, '96', SZA->ZA_OP, SZA->ZA_QTDORI, .T. ) 
		//FIM  	
		RegToMemory("SZA",.F.)
		AxDeleta("SZA"  , SZA->( Recno() )     , 5    )
	EndIf
EndIf

Return

User Function CADDPDTOK()
Local _Retorno := .F.

If !Empty(M->ZA_OP)
	_Retorno := .T.
Else
	MsgStop("Para apontamentos do tipo Perdas da Produ็ใo, ้ obrigat๓rio informar a Ordem de Produ็ใo.")
	_Retorno := .F.
EndIf
//EndIf




Return _Retorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT410TOK  บAutor  ณJonas Pereira 		 บ Data ณ  09/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera empenho no lancamento de perda		  บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SD4PERDA(cProduto, cLocal, cOP, nQtd, lExclui )                 

Local lReturn  := .t.
Local aArea    := GetArea()
//Local lFibra   := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_GRUPO") $ "FO|FOFS"

//cLocal := IIF(lFibra,'97','96')
cLocal:= "96"

//Verifica se tem armazem criado para o produto


dbSelectArea("SB2")
MsSeek(xFilial("SB2")+cProduto+cLocal)
If EOF()
	CriaSB2(cProduto,cLocal)
EndIf
                       

//Verifica se a OP continua em aberto
DBSelectArea("SC2")                       
If SC2->(DBSeek(xFilial()+cOP))
	If !Empty(SC2->C2_DATRF)    
		U_MSGCOLETOR("OP Jม FOI ENCERRADA")
		lReturn := .f.
	EndIf
Else
	U_MSGCOLETOR("OP NAO ENCONTRADA")
	lReturn := .f.
EndIf


If lReturn .and. !lExclui      
	DBSelectArea("SD4")
	DBSetOrder(2)
	If SD4->(DBSeek(xFilial()+cOP+(SPACE(14-LEN(cOP)))+cProduto+(SPACE(15-LEN(cProduto)))+cLocal))
		RecLock("SD4",.F.)
		SD4->D4_QUANT	  := SD4->D4_QUANT+nQTD
		SD4->D4_QTDEORI  := SD4->D4_QTDEORI+nQTD
		SD4->( msUnlock() ) 
	Else
		Reclock("SD4",.T.)
		SD4->D4_FILIAL   := xFilial()
		SD4->D4_COD      := cProduto
		SD4->D4_LOCAL    := cLocal
		SD4->D4_OP       := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		SD4->D4_DATA     := DATE()
		SD4->D4_QTDEORI  := nQTD
		SD4->D4_QUANT    := nQTD
		SD4->D4_LOTECTL  := ''
		SD4->D4_DTVALID  := StoD('20491231')
		SD4->D4_PRODUTO := SC2->C2_PRODUTO
		SD4->( msUnlock() ) 
	EndIF
	//Ajusta B2_QEMP
   //	cEMPSB2(cProduto, cLocal, nQTD, lExclui)
EndIf             
           
//Exclui empenho
If lExclui
	DBSelectArea("SD4")
	DBSetOrder(2)
	If SD4->(DBSeek(xFilial()+cOP+(SPACE(14-LEN(cOP)))+cProduto+(SPACE(15-LEN(cProduto)))+cLocal))	       
			If SD4->D4_QUANT==nQTD
				RecLock("SD4",.F.)
				SD4->(DbDelete())
				SD4->(MsUnLock())
				//Ajusta B2_QEMP
	  			//	cEMPSB2(cProduto, cLocal, nQTD, lExclui) 		  	
	  	    ElseIF SD4->D4_QUANT>nQTD
	  	    	RecLock("SD4",.F.)  
	  	    	SD4->D4_QTDEORI := SD4->D4_QTDEORI - nQTD 
				SD4->D4_QUANT   := SD4->D4_QUANT   - nQTD 
				SD4->(MsUnLock())				
		  	EndIf
	EndIf           
Endif

RestArea(aArea)                                     

Return lReturn 

//Static function cEMPSB2(cProduto, cLocal, nQTD, lExclui)

//Local nVal                                             

If lExclui    
	nVal := Alltrim(Str(nQTD*(-1)))
Else                               
	nVal := Alltrim(Str(nQTD))
EndIf

//AjustaEmpenho
Reclock("P05",.T.)
P05->P05_FILIAL := "01"
P05->P05_ALIAS  := "SB2"
P05->P05_INDICE := "1"
P05->P05_CHAVE  := "01" + cProduto + cLocal
P05->P05_CAMPO  := "B2_QEMP"
P05->P05_TIPO   := "N"
P05->P05_SOMA   := nVal
P05->P05_DTINC  := dDataBase
P05->P05_HRINC  := Time()
P05->P05_PRODUT := cProduto
P05->P05_LOCAL  := cLocal
P05->( msUnlock() )

Return


User Function fButtCel()
Local oCelCort1
Local oCelCort2
Local oCelCort3
Local oCelCort4
Local oCelCort5
Local oCelCort6

Local oFont1 := TFont():New("Arial",,050,,.T.,,,,,.F.,.F.)
Static oDlgBtC

Local cCSSBtN1 :="QPushButton{background-color: #f6f7fa; color: #707070; font: bold 22px Arial; }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 22px  Arial; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 22px  Arial; }"

  DEFINE MSDIALOG oDlgBtC TITLE "Escolha a c้lula de trabalho" FROM 000, 000  TO 550, 800 COLORS 0, 16777215 PIXEL
	@ 033, 040 BUTTON oCelCort1 PROMPT "CORTE 1" SIZE 150, 053 OF oDlgBtC ACTION (cCelula := "CORTE 1", oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort1:setCSS(cCSSBtN1)
	@ 033, 212 BUTTON oCelCort2 PROMPT "CORTE 2" SIZE 150, 053 OF oDlgBtC ACTION (cCelula := "CORTE 2", oDlgBtc:end()) FONT oFont1 PIXEL
	oCelCort2:setCSS(cCSSBtN1)
	@ 110, 040 BUTTON oCelCort3 PROMPT "CORTE 3" SIZE 150, 053 OF oDlgBtC ACTION (cCelula := "CORTE 3", oDlgBtc:end()) FONT oFont1 PIXEL
	oCelCort3:setCSS(cCSSBtN1)
	@ 110, 212 BUTTON oCelCort4 PROMPT "CORTE 4" SIZE 150, 053 OF oDlgBtC ACTION (cCelula := "CORTE 4", oDlgBtc:end()) FONT oFont1 PIXEL
	oCelCort4:setCSS(cCSSBtN1)
	@ 187, 040 BUTTON oCelCort5 PROMPT "TRUNK 1" SIZE 150, 053 OF oDlgBtC ACTION (cCelula := "TRUNK 1", oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort5:setCSS(cCSSBtN1)
	@ 187, 212 BUTTON oCelCort6 PROMPT "DROP 1" SIZE 150, 053 OF oDlgBtC ACTION (cCelula := "DROP 1", oDlgBtc:end() ) FONT oFont1 PIXEL
	oCelCort6:setCSS(cCSSBtN1)
	
	ACTIVATE MSDIALOG oDlgBtC CENTERED

	Reclock("SZA",.F.)
	SZA->ZA_MAQUINA := (cCelula)
	SZA->( msUnlock() )

				
		P10->(DbSetOrder(1))//P10_FILIAL, P10_OP, P10_FIBRA
		RecLock("P10",.T.)
		P10->P10_FILIAL	:= xFilial("P10")
		P10->P10_OP       := SZA->ZA_OP
		P10->P10_DTPROG	  := SZA->ZA_DATA
		P10->P10_FIBRA    := SZA->ZA_PRODUTO
		P10->P10_SQCORT	  := '000'
		P10->P10_MAQUIN    := cCelula
		P10->(MsUnLock())
	
Return 


User Function DPDZEDOC()
Local _Retorno := ""
Local nLoop    := 0
Local lLoop    := .T.
Local aAreaGER := GetArea()
Local aAreaSX6 := SX6->( GetArea() )

SX6->( Dbsetorder(1) )

If SX6->( dbSeek(xFilial("SD3")+"MV_XZAZEDO") )
	While lLoop .and. nLoop < 1000
		If RecLock("SX6",.F.) .And. lLoop
			_NextDoc        := Alltrim(SX6->X6_CONTEUD)
			SX6->X6_CONTEUD := SOMA1(_NextDoc)
			SX6->( Msunlock() )
			
			lLoop    := .F.
			_Retorno := _NextDoc
		EndIf
		nLoop ++
	End
EndIf

RestArea(aAreaSX6)
RestArea(aAreaGER)
                     
If Empty(_Retorno)
   MsgYesNo('Parametro MV_XXNEXTD nใo criado!')
   _Retorno := ''
EndIf

Return _Retorno
