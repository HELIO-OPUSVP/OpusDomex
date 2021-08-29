#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "totvs.ch"
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZI    บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro da SZI - Browse de gerenciamento inventแrio       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSZI()

Local   aCores   :=  {}
Private oObjMBrw := Nil
Private nMaxCont := 0
Private dDataInv := GetMV("MV_XXDTINV")
Private cEquipe  := ""
Private cFilBrow
Private cAlias := "SZI"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณMonta legenda do browse											 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
AADD(aCores,{ "ZI_STATLIN == 'V' .and. ZI_STATPRO == ' '" , 'ENABLE'  } )
AADD(aCores,{ "ZI_STATLIN == 'V' .and. ZI_STATPRO == 'V'" , 'BR_AZUL' } )
AADD(aCores,{ "ZI_STATLIN == 'A'" , 'BR_AMARELO' } )
AADD(aCores,{ "ZI_STATLIN == 'C' .or. ZI_STATLIN == 'E'" , 'BR_CINZA'   } )  //C=Nova contagem de Produto, E=Recontagem de etiqueta
AADD(aCores,{ "ZI_STATLIN == 'D'" , 'DISABLE'    } )
AADD(aCores,{ "ZI_STATLIN == '*'" , 'BR_PINK'    } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณAtualiza a ๚ltima contagem										 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
AtuMacCont()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณMonta MENU do browse												 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
DbSelectArea(cAlias)
aRotina := {}

AADD(aRotina,{ "Pesquisar"                ,'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Apaga ultima contagem(F4)",'U_SZIDELUL'   , 0, 3 } )
AADD(aRotina,{ "Atualizar (F5)"           ,'U_ATUSZI'     , 0, 3 } )
AADD(aRotina,{ "Recontagem Etiqueta (F6)" ,'U_RECONT'     , 0, 3 } )
AADD(aRotina,{ "Nova Contagem (F7)"       ,'U_NOVACONT'   , 0, 3 } )
AADD(aRotina,{ "Etiqueta (F8)"            ,'U_FILETIQ'    , 0, 3 } )
AADD(aRotina,{ "Filtrar (F9)"             ,'U_SZIFIL'     , 0, 3 } )
AADD(aRotina,{ "Filt.Posicionado (F10)"   ,'U_SZIFILPRO'  , 0, 3 } )
AADD(aRotina,{ "Contagem Faltante (F11)"  ,'U_SZISOLCON'  , 0, 3 } )

If Upper(Alltrim(Subs(cUsuario,7,15))) $ "HELIO OPUS,LUCIANO DE ANGE,MICHEL"
	AADD(aRotina,{ "Desconsiderar (F12)"   ,'U_SZIDELETA', 0, 3 } )
EndIf

AADD(aRotina,{ "Relat๓rio"               ,'U_RESTR02'    , 0, 3 } )
AADD(aRotina,{ "Legenda"                 ,'U_fLegSZI'    , 0, 5 } )

cCadastro := "CADSZI - Gerenciamento de Inventแrio por Coletores"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณTeclas de Atalho do Browse										 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
SetKey(VK_F4, { || U_SZIDELUL()  } )
SetKey(VK_F5, { || U_ATUSZI()    } )
SetKey(VK_F6, { || U_RECONT()    } )
SetKey(VK_F7, { || U_NOVACONT()  } )
SetKey(VK_F8, { || U_FILETIQ()   } )
SetKey(VK_F9, { || U_SZIFIL()    } )
SetKey(VK_F10,{ || U_SZIFILPRO() } )
SetKey(VK_F11,{ || U_SZISOLCON() } )
SetKey(VK_F12,{ || U_SZIDELETA() } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณMonta o filtro do Browse										 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
P02->(dbSetOrder(2))
P02->(dbSeek(xFilial("P02")+__cUSERID))
P03->(dbSetOrder(2))
P03->(dbSeek(xFilial("P03")+P02->P02_CODIGO))

cExprFilTop := "ZI_DATA = '"+DTOS(dDataInv)+"' AND "
If Subs(cUsuario,7,5) <> 'HELIO' .and. Subs(cUsuario,7,5) <> 'Denis' .and. Subs(cUsuario,7,6) <> 'Michel'
   cFilBrow    := "ZI_PRODUTO IN (SELECT P04_CODPRO FROM "+RetSQLName("P04")+" (NOLOCK) WHERE D_E_L_E_T_= '' AND P04_CODEQU = '"+P03->P03_CODIGO+"') "
Else
   cFilBrow    := "ZI_PRODUTO = ZI_PRODUTO "
EndIf

cExprFilTop += cFilBrow

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณCarrega Browse do SZI											 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
mBrowse( 6, 1,22,75,cAlias ,,,,,, aCores             ,,,,,,,,cExprFilTop ,)  //"U_CADSZITOK()" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณLimpa teclas de atalho											 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
SetKey(VK_F5 ,Nil)
SetKey(VK_F6 ,Nil)
SetKey(VK_F7 ,Nil)
SetKey(VK_F8 ,Nil)
SetKey(VK_F9 ,Nil)
SetKey(VK_F10,Nil)
SetKey(VK_F11,Nil)
SetKey(VK_F12,Nil)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SZIINCLUIบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusใo no SZI												        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZIINCLUI()

Local nOK

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui(cAlias    , 0     , 3     ,        ,        ,        , "U_CADSZITOK()" )

If nOk == 1
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLegSZI    บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda do browse												         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fLegSZI()

BrwLegenda("","Legenda",{;
{"ENABLE"     ,"Contagens da etiqueta Ok"                     },;
{"BR_AMARELO" ,"Etiqueta aguardando contagem"                 },;
{"BR_CINZA"   ,"A็ใo do Coordenador jแ efetuada"              },;
{"DISABLE"    ,"Contagens da etiqueta com com diverg๊ncia"    },;
{"BR_PINK"    ,"Contagem desconsiderada"                      },;
{"BR_AZUL"    ,"Todas etiquetas do Produto Ok "               }})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SZIALTERAบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera็ใo do SZI  											         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZIALTERA()

nOK := AxAltera(cAlias,0,4)

If nOk == 1
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SZIDELETAบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Deleta SZI														         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZIDELETA()

//RegToMemory(cAlias,.F.)
//AxDeleta(cAlias  , &(cAlias+"->( Recno() )")     , 5    )

If MsgYesNo("Confirma a desconsidera็ใo das contagem?")
	// Apagando o registro no SZC
	cQuery := "UPDATE "      +RetSqlName("SZC")+"  SET D_E_L_E_T_ = '*' WHERE "
	cQuery += "ZC_FILIAL = '"+xFilial("SZC")   +"' AND ZC_DATAINV = '"+DtoS(dDataInv) +"' AND "
	cQuery += "ZC_XXPECA = '"+SZI->ZI_XXPECA   +"' AND "
	cQuery += "ZC_LOCAL  = '"+SZI->ZI_LOCAL    +"' AND ZC_LOCALIZ = '"+SZI->ZI_LOCALIZ+"' AND "
	cQuery += "D_E_L_E_T_ = '' "
	TCSQLEXEC(cQuery)
	Reclock("SZI",.F.)
	SZI->ZI_STATLIN := '*'
	SZI->( msUnlock() )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CADSZITOKบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida SZI														         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSZITOK()

Local _Retorno := .T.

Return _Retorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SZIFIL   บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro de browse do SZI 									        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZIFIL()

Local   calias

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณCaptura objeto MBrowse 											 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
oObjMBrw := GetObjBrow()

cAlias:=Alias()
cPerg := PadR("CADSZI",10)
dbSelectArea("SZI")

_cArq     := CriaTrab(NIL,.f.)
_cKey     := Indexkey()
_nIndex   := RetIndex("SZI")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณLimpa filtro			 											 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
If Pergunte(cPerg,.T.)
	SZI->(Dbclearfilter())
Else
	Setmbtopfilter("SZI","")
	dbSelectarea(cAlias)
	oObjMBrw:GoTop()
	oObjMBrw:Refresh()
	Return
EndIf

If !Empty(mv_par03) .and. mv_par03 == mv_par04
	U_ATUSZI(mv_par03)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณFiltra apenas os registros da equipe do Coordenador	 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
P02->(dbSetOrder(2))
P02->(dbSeek(xFilial("P02")+__cUSERID))
P03->(dbSetOrder(2))
P03->(dbSeek(xFilial("P03")+P02->P02_CODIGO))
_cFILTER1 := "ZI_DATA = '"+DtoS(dDataInv)+"' "
_cFILTER1 += "AND ZI_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
_cFILTER1 += cFilBrow

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณFiltra parโmetros													 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
If mv_par05 == 2             // Somente contagens divergentes = Nao
	If mv_par06 == 2          // Somente contagens faltantes = Nใo
		If mv_par07 == 2       // Somente a็๕es tomadas
			If mv_par01 == 2    // Nใo mostra contagens batidas
				If mv_par02 == 1 // Produto
					_cFILTER1 += " AND ZI_STATPRO <> 'V' "
				EndIf
				If mv_par02 == 2 // Por linha
					_cFILTER1 += " AND ZI_STATLIN <> 'V' "
				EndIf
			EndIf
		Else
			_cFILTER1 += " AND ZI_STATLIN = 'C' "
		EndIf
	Else
		_cFILTER1 += " AND ZI_STATLIN = 'A' "
	EndIf
Else
	_cFILTER1 += " AND ZI_STATLIN = 'D' "
EndIf
//EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณFiltra os deletados												 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
If mv_par08 == 2
	_cFILTER1 += " AND ZI_STATLIN <> '*' "
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณExecuta o Filtro 													 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
Setmbtopfilter("SZI","")
MsAguarde({|| Setmbtopfilter("SZI",_cFilter1) },'Filtrando Registros...')

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณAtualiza o Browse													 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
oObjMBrw:GoTop()
oObjMBrw:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SZIFILPROบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro de produto posicionado no SZI   				        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZIFILPRO()  //Filtra produto posicionado

Local   calias

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณCaptura objeto MBrowse											 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
oObjMBrw := GetObjBrow()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณLimpa o filtro														 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
cAlias:=Alias()
dbSelectArea("SZI")
_cArq     := CriaTrab(NIL,.f.)
_cKey     := Indexkey()
_nIndex   := RetIndex("SZI")
SZI->(Dbclearfilter())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณAciona o produto posicionado									 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
cProduto := SZI->ZI_PRODUTO
U_ATUSZI(cProduto)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณFiltra produto posicionado										 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
_cFILTER1 := "ZI_DATA = '"+DtoS(dDataInv)+"' AND ZI_STATLIN <> '*' AND ZI_PRODUTO = '"+cProduto+"' AND "
_cFILTER1 += cFilBrow

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณExecuta o filtro													 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
Setmbtopfilter("SZI","")
MsAguarde({|| Setmbtopfilter("SZI",_cFilter1) },'Filtrando Registros...')

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณAtualiza o browse													 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
oObjMBrw:GoTop()
oObjMBrw:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FILETIQ  บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro de etiqueta no SZI   								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FILETIQ()

Local calias
Local cEtiqueta := Space(6)
Local lCancel   := .F.
Local oFont1    := TFont():New("Arial Narrow",,025,,.F.,,,,,.F.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณCaptura objeto MBrowse											 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
oObjMBrw := GetObjBrow()

cAlias:=Alias()
_cFILTER1 := ""
dbSelectArea("SZI")
_cArq     := CriaTrab(NIL,.f.)
_cKey     := Indexkey()
_nIndex   := RetIndex("SZI")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
//ณTela de filtro da etiquta										 ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
DEFINE MSDIALOG oDlg TITLE "Filtro por Etiqueta" FROM 000, 000  TO 150, 170 COLORS 0, 16777215 PIXEL

@ 010, 015 SAY oSay1 PROMPT "Etiqueta: " 	SIZE 200, 024 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 025, 015 MSGET oGet1 VAR cEtiqueta WHEN(.T.)  SIZE 56, 015 OF oDlg COLORS 0, 16777215 PIXEL
oGet1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

DEFINE SBUTTON oSButton1 FROM 55, 15 TYPE 01 OF oDlg ENABLE Action (lOK     :=.T., oDlg:End() )
DEFINE SBUTTON oSButton2 FROM 55, 45 TYPE 02 OF oDlg ENABLE Action (lCancel :=.T., oDlg:End() )

ACTIVATE MSDIALOG oDlg CENTERED

If !lCancel .and. !Empty(cEtiqueta)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
	//ณSeleciona a etiqueta												 ณ
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
	cQuery := "SELECT ZI_PRODUTO FROM SZI010 WHERE ZI_DATA = '"+DtoS(dDataInv)+"' AND ZI_ETIQUET LIKE '%"+cEtiqueta+"%' AND D_E_L_E_T_ = '' GROUP BY ZI_PRODUTO "
	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf
	TCQUERY cQuery NEW ALIAS "TEMP"
	While !TEMP->( EOF() )
		U_ATUSZI(TEMP->ZI_PRODUTO)
		TEMP->( dbSkip() )
	End
	
	SZI->(Dbclearfilter())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
	//ณExecuta o filtro													 ณ
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
	_cFILTER1 := "ZI_DATA = '"+DtoS(dDataInv)+"' AND ZI_ETIQUET LIKE '%"+cEtiqueta+"%' "
	Setmbtopfilter("SZI","")
	MsAguarde({|| Setmbtopfilter("SZI",_cFilter1) },'Filtrando Registros...')
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
	//ณAtualiza o Browse													 ณ
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺ
	oObjMBrw:GoTop()
	oObjMBrw:Refresh()
	
Else
	
	SZI->(Dbclearfilter())
	SZI->( dbGoTop() )
	oObjMBrw:GoTop()
	oObjMBrw:Refresh()
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RECONT   บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abertura de recontagem de etiqueta						        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RECONT()

Local nProxCont := 0
Local lOk       := .F.
Local lCancel   := .F.
Local oFont1    := TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

If SZI->ZI_DATA == dDataInv
	
	aNaoPode := {}
	For x := 2 to 20
		If Type("SZI->ZI_CON"+StrZero(x,3)) <> 'U'
			If !Empty(&("SZI->ZI_CON" + StrZero(x,3)))
				AADD(aNaoPode,&("SZI->ZI_USU" + StrZero(x,3)))
			EndIf
		EndIf
	Next x
	
	aRecontagem := {}
	If Len(aNaoPode) > 1
		For x := 2 to 20
			If Type("SZI->ZI_CON"+StrZero(x,3)) <> 'U'
				If !Empty(&("SZI->ZI_CON" + StrZero(x,3)))
					aNaoPode := {}
					AADD(aNaoPode,&("SZI->ZI_USU" + StrZero(x,3)))
					cOperador := SeleUsu(aNaoPode)
					If Empty(cOperador)
						MsgStop("Recontagem cancelada.")
						aRecontagem := {}
						Exit
					Else
						AADD(aRecontagem,cOperador)
					EndIf
				EndIf
			EndIf
		Next x
		
		For x := 2 to Len(aRecontagem)
			cNumEtiq   := GetNumInv()
			Reclock("SZI",.F.)
			&("SZI->ZI_USU" + StrZero(x,3)) := aRecontagem[x]
			&("SZI->ZI_CON" + StrZero(x,3)) := 0
			SZI->ZI_STATLIN := "E"
			If x == 2
				SZI->ZI_ETIQUET := cNumEtiq+"(002)"
			Else
				SZI->ZI_ETIQUET := Alltrim(SZI->ZI_ETIQUET)+cNumEtiq+"("+StrZero(x,3)+")"
			EndIf
			SZI->( msUnlock() )
			
			aEnderecos := {}
			AADD(aEnderecos,SZI->ZI_LOCALIZ)
			nProxCont  := x
			cProduto   := SZI->ZI_PRODUTO
			cOperador  := &("SZI->ZI_USU" + StrZero(x,3))
			cXXPeca    := SZI->ZI_XXPECA
			EtiqRecon(nProxCont,cNumEtiq,cProduto,cOperador,aEnderecos,cXXPeca)
			If x <> Len(aRecontagem)
				MsgInfo("Pausa para impressใo...")
			EndIf
			
			// Apagando o registro no SZC
			cQuery := "UPDATE "      +RetSqlName("SZC")+"  SET D_E_L_E_T_ = '*' WHERE "
			cQuery += "ZC_FILIAL = '"+xFilial("SZC")   +"' AND ZC_DATAINV = '"+DtoS(dDataInv) +"' AND "
			cQuery += "ZC_XXPECA = '"+SZI->ZI_XXPECA   +"' AND ZC_CONTAGE = '"+StrZero(x,3)   +"' AND "
			cQuery += "ZC_LOCAL  = '"+SZI->ZI_LOCAL    +"' AND ZC_LOCALIZ = '"+SZI->ZI_LOCALIZ+"' AND "
			cQuery += "D_E_L_E_T_ = '' "
			
			//TCSQLEXEC(cQuery)
		Next x
	Else
		MsgStop("S๓ ้ permitido abrir recontagem de etiquetas para etiquetas com mais de uma contagem jแ realizada.")
	EndIf
Else
	MsgStop("Posicione em um registro do inventแrio atual")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ NOVACONT บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Nova Contagem de Etiqueta   								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NOVACONT()

Local nProxCont := 0
Local lOk       := .F.
Local lCancel   := .F.
Local oFont1    := TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

If SZI->ZI_DATA == dDataInv
	
	AtuMacCont()
	
	For x := 2 to nMaxCont+1
		cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SZI") + " (NOLOCK) WHERE ZI_CON"+StrZero(x,3)+" <> '' AND ZI_DATA = '"+DtoS(dDataInv)+"' AND ZI_PRODUTO = '"+SZI->ZI_PRODUTO+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' "
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "TEMP"
		If TEMP->( EOF() )
			nProxCont := x
			Exit
		EndIf
	Next x
	
	nProxCont := nProxCont - 1
	If nProxCont < 0
		nProxCont := 2
	EndIf
	
	DEFINE MSDIALOG oDlg TITLE "Abertura de nova contagem" FROM 000, 000  TO 150, 360 COLORS 0, 16777215 PIXEL
	
	@ 015, 015 SAY oSay1 PROMPT "N๚mero da Nova Contagem " 	SIZE 200, 024 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
	
	@ 015, 140 MSGET oGet1 VAR nProxCont WHEN(.F.) SIZE 30, 010 OF oDlg COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 50, 100 TYPE 01 OF oDlg ENABLE Action (lOk     :=.T., oDlg:End() )
	DEFINE SBUTTON oSButton2 FROM 50, 140 TYPE 02 OF oDlg ENABLE Action (lCancel :=.T., oDlg:End() )
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If lOk
		aNaoPode := {}
		cOperador  := SeleUsu(aNaoPode)
		
		If !Empty(cOperador)
			cProduto := SZI->ZI_PRODUTO
			cNumEtiq := GetNumInv()
			cQuery   := "UPDATE " + RetSqlName("SZI") + " SET "
			cQuery   += "ZI_STATLIN = 'C', "
			cQuery   += "ZI_CONTAGE = '" + StrZero(nProxCont+1,3) + "', "
			cQuery   += "ZI_ETIQUET = '"+cNumEtiq+"', "
			cQuery   += "ZI_USU" + StrZero(nProxCont+1,3) + " = '" + cOperador + "' "
			cQuery   += "WHERE ZI_PRODUTO = '"+cProduto+"' AND ZI_DATA = '"+DtoS(dDataInv)+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' "
			TCSQLEXEC(cQuery)
			
			cQuery := "SELECT ZI_LOCALIZ FROM " + RetSqlName("SZI") + " WHERE ZI_PRODUTO = '"+cProduto+"' AND ZI_DATA = '"+DtoS(dDataInv)+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' GROUP BY ZI_LOCALIZ ORDER BY ZI_LOCALIZ "
			
			If Select("TEMP") <> 0
				TEMP->( dbCloseArea() )
			EndIf
			
			TCQUERY cQuery NEW ALIAS "TEMP"
			
			aEnderecos := {}
			While !TEMP->( EOF() )
				AADD(aEnderecos,TEMP->ZI_LOCALIZ)
				TEMP->( dbSkip() )
			End
			
			oObjMBrw := GetObjBrow()
			oObjMBrw:Refresh()
			
//			EtiqNovCon(nProxCont-1,cNumEtiq,cProduto,cOperador,aEnderecos)
			EtiqNovCon(nProxCont,cNumEtiq,cProduto,cOperador,aEnderecos)
		EndIf
	EndIf
Else
	MsgStop("Posicione em um registro do inventแrio atual")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SZISOLCONบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Solicita contagem em aberto  								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZISOLCON()

Local nProxCont := 0
Local lOk       := .F.
Local lCancel   := .F.
Local oFont1    := TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

If SZI->ZI_DATA == dDataInv
	
	aNaoPode := {}
	For x := 1 to 20
		If Type("SZI->ZI_CON"+StrZero(x,3)) <> 'U'
			If !Empty(&("SZI->ZI_CON" + StrZero(x,3)))
				AADD(aNaoPode,&("SZI->ZI_USU" + StrZero(x,3)))
			EndIf
		EndIf
	Next x
	
	cOperador := SeleUsu(aNaoPode)
	
	For x := 1 to 10
		
		If Empty(&("SZI->ZI_CON" + StrZero(x,3)))
			
			cNumEtiq   := GetNumInv()
			Reclock("SZI",.F.)
			&("SZI->ZI_USU" + StrZero(x,3)) := cOperador
			SZI->ZI_STATLIN := "C"
			SZI->ZI_ETIQUET := cNumEtiq
			SZI->( msUnlock() )
			
			aEnderecos := {}
			AADD(aEnderecos,SZI->ZI_LOCALIZ)
			nProxCont  := x
			cProduto   := SZI->ZI_PRODUTO
			cOperador  := &("SZI->ZI_USU" + StrZero(x,3))
			cXXPeca    := SZI->ZI_XXPECA
			EtiqFalta(nProxCont,cNumEtiq,cProduto,cOperador,aEnderecos,cXXPeca)
			Exit
			
		EndIf
		
	Next x
	
Else
	
	MsgStop("Posicione em um registro do inventแrio atual")
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuMacContบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza numero da contagem  								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuMacCont()

cQuery := "SELECT MAX(ZC_CONTAGE) AS MAXCONTAGEM FROM " + RetSqlName("SZC") + " WHERE ZC_DATAINV = '"+DtoS(dDataInv)+"' AND D_E_L_E_T_ = '' "

If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP"

nMaxCont := Val(TEMP->MAXCONTAGEM)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EtiqReconบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta de recontagem  									        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EtiqRecon(nProxCont,cNumEtiq,cProduto,cOperador,aEnderecos,cXXPeca)

Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()
Local x

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

MSCBSay(28,01,"RECONTAGEM DE ETIQUETA: " + StrZero(nProxCont,3),"N","3","1,1")

n := 3

// 01
MSCBSay(28,01+n,"PRODUTO: " + cProduto,"N","2","1,1")

//03
cDescri := Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC")
cDescri := StrTran(cDescri,'"',"'")

MSCBSay(28,03+n,"DESCRIวรO:" + cDescri   ,"N","2","1,1")
//05
MSCBSay(28,05+n,"OPERADOR:" + cOperador ,"N","2","1,1")

//MSCBSayBar - Imprime c๓digo de barras ( nXmm nYmm cConteudo cRota็ใo cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
//07
MSCBSayBar(28,07+n,cNumEtiq,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)
//18
//MSCBSay(46,18+n,"OP: "+SZE->ZE_OP,"N","2","1,1")

MSCBSay(55,06+n,"Endere็os:","N","2","1,1")

nLin := 08+n
For x := 1 to Len(aEnderecos)
	MSCBSay(55,nLin,aEnderecos[x] ,"N","2","1,1")
	nLin += 2
Next x

nLin += 2
MSCBSay(55,nLin,"Etiqueta: " ,"N","2","1,1")
nLin += 2
MSCBSay(55,nLin,cXXPeca ,"N","2","1,1")

MSCBEnd()
MSCBClosePrinter()

// Etiqueta em branco
MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBEnd()
MSCBClosePrinter()

RestArea(_aAreaGER)

Return

Static Function EtiqFalta(nProxCont,cNumEtiq,cProduto,cOperador,aEnderecos,cXXPeca)

Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()
Local x

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

MSCBSay(28,01,"CONTAGEM FALTANDO: " + StrZero(nProxCont,3),"N","3","1,1")

n := 3
// 01
MSCBSay(28,01+n,"PRODUTO: " + cProduto,"N","2","1,1")

//03
cDescri := Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC")
cDescri := StrTran(cDescri,'"',"'")

MSCBSay(28,03+n,"DESCRIวรO:" + cDescri   ,"N","2","1,1")
//05
MSCBSay(28,05+n,"OPERADOR:" + cOperador ,"N","2","1,1")

//MSCBSayBar - Imprime c๓digo de barras ( nXmm nYmm cConteudo cRota็ใo cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
//07
MSCBSayBar(28,07+n,cNumEtiq,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)
//18
//MSCBSay(46,18+n,"OP: "+SZE->ZE_OP,"N","2","1,1")

MSCBSay(55,06+n,"Endere็os:","N","2","1,1")

nLin := 08+n
For x := 1 to Len(aEnderecos)
	MSCBSay(55,nLin,aEnderecos[x] ,"N","2","1,1")
	nLin += 2
Next x

nLin += 2
MSCBSay(55,nLin,"Etiqueta: " ,"N","2","1,1")
nLin += 2
MSCBSay(55,nLin,cXXPeca ,"N","2","1,1")

MSCBEnd()
MSCBClosePrinter()

// Etiqueta em branco
MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBEnd()
MSCBClosePrinter()

RestArea(_aAreaGER)

Return

Static Function GetNumInv()

Local _Retorno := ""
Local nLoop    := 0
Local lLoop    := .T.
Local aAreaGER := GetArea()
Local aAreaSX6 := SX6->( GetArea() )

SX6->( Dbsetorder(1) )

If SX6->( dbSeek(SPACE(02)+"MV_XXETIIN") )
	While lLoop .and. nLoop < 1000
		If RecLock("SX6",.F.) .And. lLoop
			_NextDoc        := VAL(SX6->X6_CONTEUD)
			SX6->X6_CONTEUD := ALLTRIM(STR(_NextDoc+1))
			SX6->X6_CONTENG := ALLTRIM(STR(_NextDoc+1))
			SX6->X6_CONTSPA := ALLTRIM(STR(_NextDoc+1))
			SX6->( Msunlock() )
			lLoop    := .F.
			_Retorno := STRZERO(_NextDoc,6)
		EndIf
		nLoop ++
	End
EndIf

RestArea(aAreaSX6)
RestArea(aAreaGER)

Return _Retorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SeleUsu  บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona Contadores       								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SeleUsu(aNaoPode)

Local oRadio
Local aRadio    := {}
Local lOk       := .F.
Local lCancel   := .F.

nRadio    := 1

Default aNaoPode := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o combo dos contadores			    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P02->(dbSetOrder(2))
P02->(dbSeek(xFilial("P02")+__cUSERID))
aClassBox := {}
AADD(aClassBox,SPACE(06)+SPACE(02)+SPACE(60))
P03->(dbSetOrder(2))
If P03->(dbSeek(xFilial("P03")+P02->P02_CODIGO))
	cP03COD := P03->P03_CODCOR
	cP03FIL := P03->P03_FILIAL
	Do While P03->(!Eof()) .And. xFilial("P03")+P03->P03_CODCOR == cP03FIL+cP03COD
		P01->(dbSetOrder(1))
		If P01->(dbSeek(xFilial("P03")+P03->P03_CODCON))
			If aScan(aNaoPode,Alltrim(P01->P01_USUCOL)) == 0
				AADD(aClassBox,P01->P01_CODIGO+"  "+P01->P01_DESC)
			EndIf
		EndIf
		P03->(dbSkip())
	EndDo
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a janela de escolha				    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg TITLE "Selecione o usuแrio para realizar a contagem" FROM 000, 000  TO 250, 360 COLORS 0, 16777215 PIXEL

@ 10, 10 SAY "Escolha o Contador" SIZE 120,60 of oDlg PIXEL
@ 20, 10 COMBOBOX oCbx1 VAR cEquipe ITEMS aClassBox SIZE 163,60 Of oDlg WHEN .T. Pixel

DEFINE SBUTTON oSButton1 FROM 100, 100 TYPE 01 OF oDlg ENABLE Action (lOk     :=.T., oDlg:End() )
DEFINE SBUTTON oSButton2 FROM 100, 140 TYPE 02 OF oDlg ENABLE Action (lCancel :=.T., oDlg:End() )

ACTIVATE MSDIALOG oDlg CENTERED

_Retorno := IIF( lOk, ALLTRIM(SUBSTR(cEquipe,7)), "" )

Return ( _Retorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EtiqNovCon บAutorณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta de Nova Contagem    								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EtiqNovCon(nProxCont,cNumEtiq,cProduto,cOperador,aEnderecos)
Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()


MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

MSCBSay(28,01,"NOVA CONTAGEM PRODUTO: " + StrZero(nProxCont,3),"N","3","1,1")

n := 3
// 01
MSCBSay(28,01+n,"PRODUTO: " + cProduto ,"N","2","1,1")
//03
cDescri := Posicione("SB1",1,xFilial("SB1") + cProduto,"B1_DESC")
cDescri := StrTran(cDescri,'"',"'")

MSCBSay(28,03+n,"DESCRIวรO:" + cDescri  ,"N","2","1,1")
//05
MSCBSay(28,05+n,"OPERADOR:" + cOperador ,"N","2","1,1")

//MSCBSayBar - Imprime c๓digo de barras ( nXmm nYmm cConteudo cRota็ใo cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
//07
MSCBSayBar(28,07+n,cNumEtiq,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)
//18

MSCBSay(55,06+n,"Endere็os:","N","2","1,1")

nLin := 08+n
For x := 1 to Len(aEnderecos)
	MSCBSay(55,nLin,aEnderecos[x] ,"N","2","1,1")
	nLin += 2
Next x

MSCBEnd()
Sleep(500)
MSCBClosePrinter()

// Etiqueta em branco
MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBEnd()
MSCBClosePrinter()

RestArea(_aAreaGER)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ATUSZI   บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza Contagens	       								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ATUSZI(cProdAtu)

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza contagens de acordo com a coleta de inventแrio			 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
MsgRun("Atualizando Inventแrio","Aguarde...",{ ||ATUSZIPROC(cProdAtu)} )

// Gera็ใo de dados no SZI a partir do SZC ou atualiza็ใo dos dados
// Comentado por Michel A. Sander em 15.12.2015 para utilizar atualiza็ใo com Query e aumentar perfomance
/*
If Empty(cProdAtu)

cQuery := "SELECT ZI_PRODUTO FROM " + RetSqlName("SZI") + " WHERE D_E_L_E_T_ = '' AND ZI_DATA = '"+DtoS(dDataInv)+"' AND "
cQuery += cFilBrow
cQuery += "GROUP BY ZI_PRODUTO "

If Select("QUERYSZI") <> 0
QUERYSZI->( dbCloseArea() )
EndIf
TCQUERY cQuery NEW ALIAS "QUERYSZI"

WHILE !QUERYSZI->( EOF() )
MsgRun("Atualizando Inventแrio","Aguarde...",{ ||ATUSZIPROC(QUERYSZI->ZI_PRODUTO)} )
QUERYSZI->( dbSkip() )
End

Else

MsgRun("Atualizando Inventแrio","Aguarde...",{ ||ATUSZIPROC(cProdAtu)} )

EndIf
*/

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUSZIPROCบAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da atualiza็ใo das contagens  		           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ATUSZIPROC(cProdAtu)

LOCAL cAliasTZI := GetNextAlias()
Default cProdAtu := ""

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza contagem															 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
AtuMacCont()

// Gera็ใo de dados no SZI a partir do SZC ou atualiza็ใo dos dados
// Comentado por Michel A. Sander em 15.12.2015 para utilizar atualiza็ใo com Query e aumentar perfomance

/*
cQuery := "SELECT * FROM " + RetSqlName("SZC") + " WHERE ZC_DATAINV = '"+DtoS(dDataInv)+"' AND D_E_L_E_T_ = '' "
If !Empty(cProdAtu)
cQuery += "AND ZC_PRODUTO = '"+cProdAtu+"'  "
EndIf

If Select("QUERYSZC") <> 0
QUERYSZC->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZC"

SB1->( dbSetOrder(1) )
SZI->( dbSetOrder(2) )   // ZI_FILIAL + ZI_DATA + ZI_XXPECA + ZI_PRODUTO + ZI_LOCAL + ZI_LOCALIZ + ZI_CONTAGE

While !QUERYSZC->( EOF() )

If !SZI->( dbSeek( xFilial() + QUERYSZC->ZC_DATAINV + QUERYSZC->ZC_XXPECA + QUERYSZC->ZC_PRODUTO + QUERYSZC->ZC_LOCAL + QUERYSZC->ZC_LOCALIZ ) )
If SB1->( dbSeek( xFilial() + QUERYSZC->ZC_PRODUTO ) )
Reclock("SZI",.T.)
SZI->ZI_FILIAL  := xFilial("SZI")
SZI->ZI_DATA    := StoD(QUERYSZC->ZC_DATAINV)
SZI->ZI_XXPECA  := QUERYSZC->ZC_XXPECA
SZI->ZI_PRODUTO := QUERYSZC->ZC_PRODUTO
SZI->ZI_LOCAL   := QUERYSZC->ZC_LOCAL
SZI->ZI_LOCALIZ := QUERYSZC->ZC_LOCALIZ
SZI->ZI_DESC    := SB1->B1_DESC
&("SZI->ZI_USU"+QUERYSZC->ZC_CONTAGE) := QUERYSZC->ZC_USUARIO
&("SZI->ZI_CON"+QUERYSZC->ZC_CONTAGE) := QUERYSZC->ZC_QUANT
SZI->( msUnlock() )
Else
MsgStop("Produto nใo encontrado (SZC): " + QUERYSZC->ZC_PRODUTO )
EndIf
Else
Reclock("SZI",.F.)
&("SZI->ZI_USU"+QUERYSZC->ZC_CONTAGE) := QUERYSZC->ZC_USUARIO
&("SZI->ZI_CON"+QUERYSZC->ZC_CONTAGE) := QUERYSZC->ZC_QUANT
SZI->( msUnlock() )
EndIf
QUERYSZC->( dbSkip() )

End

*/

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as etiquetas coletadas que nใo possuem cadastro no SZI ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cAliasSZC := GetNextAlias()
cWhere    := "%ZC_DATAINV = '"+Dtos(dDataInv)+"'%"

BeginSQL Alias cAliasSZC
	
	SELECT ZC_FILIAL,ZC_DATAINV,ZC_XXPECA,ZC_PRODUTO,ZC_LOCAL,ZC_LOCALIZ,ZC_CONTAGE,ZC_USUARIO,ZC_QUANT,ZC_LOTECTL,
	ZI_FILIAL,ZI_DATA,ZI_XXPECA,ZI_PRODUTO,ZI_LOCAL,ZI_LOCALIZ,ZI_LOTECTL
	FROM %table:SZC% SZC (NOLOCK)
	LEFT JOIN %table:SZI% SZI (NOLOCK) ON
	ZI_FILIAL  = ZC_FILIAL  AND "
	ZI_DATA    = ZC_DATAINV AND
	ZI_XXPECA  = ZC_XXPECA  AND
	ZI_PRODUTO = ZC_PRODUTO AND
	ZI_LOCAL   = ZC_LOCAL   AND
	ZI_LOCALIZ = ZC_LOCALIZ AND
	ZI_LOTECTL = ZC_LOTECTL AND 
	SZC.D_E_L_E_T_ = '' 	 AND
	SZI.D_E_L_E_T_ = ''
	WHERE ZI_XXPECA IS NULL AND %Exp:cWhere%
	ORDER BY ZC_XXPECA
	
EndSQL

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Insere coletas nใo encontradas no SZI na data de inventแrio     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
While (cAliasSZC)->(!EOF())
	
	cSQL := "IF NOT EXISTS (SELECT * FROM SZI010 WHERE "
	cSQL += "    ZI_FILIAL  ='"+(cAliasSZC)->ZC_FILIAL +"' "
	cSQL += "AND ZI_DATA    ='"+(cAliasSZC)->ZC_DATAINV+"' "
	cSQL += "AND ZI_XXPECA  ='"+(cAliasSZC)->ZC_XXPECA +"' "
	cSQL += "AND ZI_PRODUTO ='"+(cAliasSZC)->ZC_PRODUTO+"' "
	cSQL += "AND ZI_LOCAL   ='"+(cAliasSZC)->ZC_LOCAL  +"' "
	cSQL += "AND ZI_LOCALIZ ='"+(cAliasSZC)->ZC_LOCALIZ+"' "
	cSQL += "AND ZI_LOTECTL ='"+(cAliasSZC)->ZC_LOTECTL+"' "
	cSQL += "AND D_E_L_E_T_ ='')"+CHR(13)
	cSQL += "BEGIN "+CHR(13)
	cSQL += "INSERT "+RetSQLName("SZI")+" ( ZI_FILIAL, "
	cSQL += "ZI_DATA, "
	cSQL += "ZI_PRODUTO, "
	cSQL += "ZI_DESC, "
	cSQL += "ZI_LOCAL, "
	cSQL += "ZI_LOCALIZ, "
	cSQL += "ZI_XXPECA, "
	cSQL += "ZI_USU"+(cAliasSZC)->ZC_CONTAGE+", "
	cSQL += "ZI_CON"+(cAliasSZC)->ZC_CONTAGE+", "
	cSQL += "ZI_STATLIN, "
	cSQL += "ZI_LOTECTL, "
	cSQL += "R_E_C_N_O_ ) VALUES ( "
	cSQL += "'"+(cAliasSZC)->ZC_FILIAL + "', "
	cSQL += "'"+(cAliasSZC)->ZC_DATAINV+"', "
	cSQL += "'"+(cAliasSZC)->ZC_PRODUTO+"', "
	cSQL += "'"+Posicione("SB1",1,xFilial("SB1")+(cAliasSZC)->ZC_PRODUTO,"B1_DESC")+"', "
	cSQL += "'"+(cAliasSZC)->ZC_LOCAL+"', "
	cSQL += "'"+(cAliasSZC)->ZC_LOCALIZ+"', "
	cSQL += "'"+(cAliasSZC)->ZC_XXPECA+"', "
	cSQL += "'"+(cAliasSZC)->ZC_USUARIO+"', "
	cSQL += STR((cAliasSZC)->ZC_QUANT)+", "
	cSQL += "'A', "
	cSQL += "'"+(cAliasSZC)->ZC_LOTECTL+"', "
	cSQL += " ISNULL((SELECT MAX(R_E_C_N_O_)+1 FROM "+RetSQLName("SZI")+"),1) )"+CHR(13)
	cSQL += "END"
	
	If Subs(cUsuario,7,5) == 'HELIO'
	   If Alltrim((cAliasSZC)->ZC_PRODUTO)  == '251SCSI3100M14'  
	       ___nTemp := 1
	   EndIf
	EndIf
	
	TCSQLEXEC(cSQL)
	
	(cAliasSZC)->( dbSkip() )
	
End

(cAliasSZC)->(dbCloseArea())

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza contagens com a coleta de inventแrio				 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
For nQ := 2 to 8
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza contagens													 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cSQL := "UPDATE "+RetSQLName("SZI")+" SET ZI_USU"+StrZero(nQ,3)+" = ZC_USUARIO, ZI_CON"+StrZero(nQ,3)+" = ZC_QUANT, ZI_REFSTAT='T' FROM "+RetSQLName("SZI")+" SZI (NOLOCK) "
	cSQL += "INNER JOIN "+RetSQLName("SZC")+" SZC(NOLOCK) ON "
	cSQL += "SZI.ZI_FILIAL  = SZC.ZC_FILIAL  AND "
	cSQL += "SZI.ZI_DATA    = SZC.ZC_DATAINV AND "
	cSQL += "SZI.ZI_XXPECA  = SZC.ZC_XXPECA  AND "
	cSQL += "SZI.ZI_PRODUTO = SZC.ZC_PRODUTO AND "
	cSQL += "SZI.ZI_LOCAL   = SZC.ZC_LOCAL   AND "
	cSQL += "SZI.ZI_LOTECTL = SZC.ZC_LOTECTL AND "
	cSQL += "SZI.ZI_LOCALIZ = SZC.ZC_LOCALIZ WHERE "
	cSQL += "SZI.D_E_L_E_T_ = '' AND "
	cSQL += "SZC.D_E_L_E_T_ = '' AND "
	cSQL += "SZC.ZC_DATAINV = '"+DtoS(dDataInv)+"' AND "
	cSQL += "SZC.ZC_CONTAGE = '"+StrZero(nQ,3)+"' AND "
	cSQL += "(SZI.ZI_USU"+StrZero(nQ,3)+" <> SZC.ZC_USUARIO OR SZI.ZI_CON"+StrZero(nQ,3)+" <> SZC.ZC_QUANT)   AND "
	cSQL += "SZI."+cFilBrow
	TCSQLEXEC(cSQL)
	
Next

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Deleta contagens fora da data de inventแrio					 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cQuery := "UPDATE " + RetSqlName("SZI") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE "
cQuery += "ZI_DATA <> '"+DtoS(dDataInv)+"' AND "
cQuery += "D_E_L_E_T_ = ''"
TCSQLEXEC(cQuery)

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seleciona os produtos que terใo status atualizado					 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cAliasTMP := GetNextAlias()
cWhere    := "%ZI_DATA = '"+Dtos(dDataInv)+"' AND "
cWhere    += "ZI_REFSTAT = 'T' AND "
cWhere    += ALLTRIM(cFilBrow)+"%"

BeginSQL Alias cAliasTMP
	
	SELECT DISTINCT ZI_PRODUTO FROM %table:SZI% SZI (NOLOCK) WHERE %exp:cWhere% AND SZI.%NotDel%
	
EndSQL

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza os Status dos produtos											 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
While (cAliasTMP)->(!Eof())
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona o produto															 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cProdAtu := (cAliasTMP)->ZI_PRODUTO
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza de status para valida็ใo da atualiza็ใo do SZI	(ZI_REFSTAT)		 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cQuery := "UPDATE "+RetSQLName("SZI")+" SET ZI_REFSTAT = '' WHERE "
	cQuery += "ZI_PRODUTO = '"+cProdAtu+"' AND "
	cQuery += "ZI_DATA    = '"+DtoS(dDataInv)+"' AND "
	cQuery += "D_E_L_E_T_ = '' AND "
	cQuery += cFilBrow
	TCSQLEXEC(cQuery)
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Busca a ๚ltima contagem													 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	nUtimaCon := 0
	For x := 1 to 8
		cQuery := "SELECT SUM(ZI_CON"+StrZero(x,3)+") AS QTD FROM "+RetSQLName("SZI")+" (NOLOCK) WHERE "
		cQuery += "ZI_DATA    = '"+DtoS(dDataInv)+"' AND "
		cQuery += "ZI_PRODUTO = '"+cProdAtu      +"' AND "
		cQuery += "ZI_STATLIN <> '*' AND "
		cQuery += "D_E_L_E_T_ = ''"
		If Select("TEMP") <> 0
			TEMP->( dbCloseArea() )
		EndIf
		TCQUERY cQuery NEW ALIAS "TEMP"
		If !Empty(TEMP->QTD)
			nUtimaCon := x
		EndIf
	Next x
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza o status para aguardar contagem (Legenda Amarela)		 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cQuery := "UPDATE " + RetSqlName("SZI") + " SET ZI_STATLIN = 'A' WHERE "
	cQuery += "ZI_PRODUTO = '"+cProdAtu      +"' AND "
	cQuery += "ZI_DATA    = '"+DtoS(dDataInv)+"' AND "
	cQuery += "ZI_CON"+StrZero(nUtimaCon,3)+" = 0 AND "
	cQuery += "ZI_STATLIN <> 'C' AND "
	cQuery += "D_E_L_E_T_ = ''   AND "
	cQuery += "ZI_STATLIN <> '*' "
	TCSQLEXEC(cQuery)
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Marcando as linhas SEM CONTAGEM BATIDA								 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	nTemp  := nUtimaCon
	cQuery := "UPDATE " + RetSqlName("SZI") + " SET ZI_STATLIN = 'D' WHERE "
	cQuery += "ZI_DATA = '"+DtoS(dDataInv)+"' AND "
	cQuery += "ZI_STATLIN <> 'C' AND "
	cQuery += "ZI_STATLIN <> '*' AND "
	cQuery += "D_E_L_E_T_ = ''   AND "
	cQuery += "ZI_PRODUTO = '"+cProdAtu+"' AND ( "
	For x := nTemp-1 to 1 step (-1)
		cQuery += "(ZI_CON"+StrZero(nTemp,3) + " <> ZI_CON" + StrZero(x,3) + " AND ZI_CON"+StrZero(nTemp,3) + " <> 0 ) AND "
	Next x
	cQuery := Subs(cQuery,1,Len(cQuery)-4) + ") "
	TCSQLEXEC(cQuery)
	
	If !Empty(cProdAtu)
		
		cQuery := "UPDATE "+RetSQLName("SZI")+" SET ZI_STATPRO = '' WHERE "
		cQuery += "ZI_PRODUTO = '"+cProdAtu+"' AND "
		cQuery += "ZI_STATLIN <> '*' AND "
		cQuery += "D_E_L_E_T_ = ''"
		TCSQLEXEC(cQuery)
		
		If nUtimaCon >= 2
			nTemp := nUtimaCon
			cQuery := "UPDATE " + RetSqlName("SZI") + " SET ZI_STATLIN = 'V' WHERE "
			cQuery += "ZI_DATA = '"+DtoS(dDataInv)+"' AND "
			cQuery += "ZI_STATLIN <> 'V' AND "
			cQuery += "ZI_STATLIN <> '*' AND "
			cQuery += "D_E_L_E_T_ = ''   AND "
			cQuery += "ZI_PRODUTO = '"+cProdAtu+"' AND ( "
			For x := nTemp-1 to 1 step (-1)
				cQuery += "(ZI_CON"+StrZero(nTemp,3) + " = ZI_CON" + StrZero(x,3) + " AND ZI_CON"+StrZero(x,3) + " <> 0 ) OR "
			Next x
			cQuery := Subs(cQuery,1,Len(cQuery)-3) + ") "
			TCSQLEXEC(cQuery)
		EndIf
		
	EndIf
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Recalculando o campo ZI_CONTAGE											 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cQuery := "SELECT MAX(ZI_CONTAGE) AS ZI_CONTAGE FROM "+RetSQLName("SZI")+" (NOLOCK) WHERE "
	cQuery += "ZI_PRODUTO = '"+cProdAtu+"' AND "
	cQuery += "ZI_STATLIN <> '*' AND "
	cQuery += "D_E_L_E_T_ = '' "
	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TEMP"
	
	If Val(TEMP->ZI_CONTAGE) > nUtimaCon
		cContagem := TEMP->ZI_CONTAGE
	Else
		cContagem := StrZero(nUtimaCon,3)
	EndIf
	
	If cContagem <= '002'
		cContagem := ""
	EndIf
	
	cQuery := "UPDATE " + RetSqlName("SZI") + " SET ZI_CONTAGE = '"+cContagem+"' WHERE "
	cQuery += "ZI_DATA = '"+DtoS(dDataInv)+"' AND "
	cQuery += "D_E_L_E_T_ = ''   AND "
	cQuery += "ZI_STATLIN <> '*' AND "
	cQuery += "ZI_PRODUTO = '"+cProdAtu+"' "
	TCSQLEXEC(cQuery)
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualizando o status do produto											 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cQuery := "UPDATE " + RetSqlName("SZI") + " SET ZI_STATPRO = 'V' WHERE "
	cQuery += "ZI_PRODUTO NOT IN ( SELECT ZI_PRODUTO FROM "+RetSQLName("SZI")+" (NOLOCK) WHERE "
	cQuery += "ZI_DATA = '"+DtoS(dDataInv)+"' AND "
	cQuery += "D_E_L_E_T_ = ''   AND "
	cQuery += "ZI_STATLIN <> '*' AND "
	cQuery += "ZI_STATLIN <> 'V' ) AND "
	cQuery += "D_E_L_E_T_ = '' AND "
	cQuery += "ZI_STATLIN <> '*'"
	TCSQLEXEC(cQuery)
	
	(cAliasTMP)->(dbSkip())
	
EndDo

(cAliasTMP)->(dbCloseArea())


// Gera SB7
If .T.
	cQuery := "SELECT ZI_PRODUTO, ZI_LOCAL, "
	cQuery += "SUM(ZI_CON001) AS ZI_CON001, "
	cQuery += "SUM(ZI_CON002) AS ZI_CON002, "
	cQuery += "SUM(ZI_CON003) AS ZI_CON003, "
	cQuery += "SUM(ZI_CON004) AS ZI_CON004, "
	cQuery += "SUM(ZI_CON005) AS ZI_CON005, "
	cQuery += "SUM(ZI_CON006) AS ZI_CON006, "
	cQuery += "SUM(ZI_CON007) AS ZI_CON007, "
	cQuery += "SUM(ZI_CON008) AS ZI_CON008  "
	cQuery += "FROM "+RetSqlName("SZI")+" WHERE ZI_STATPRO = 'V' AND ZI_SB7 = '' AND D_E_L_E_T_ = '' AND "
	cQuery += cFilBrow
	cQuery += " GROUP BY ZI_PRODUTO, ZI_LOCAL "
	
	If Select("QUERYSZI") <> 0
		QUERYSZI->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QUERYSZI"
	
	SB2->( dbSetOrder(1) )
	While !QUERYSZI->( EOF() )
		
		For x := 2 to 8
			If !Empty(&("QUERYSZI->ZI_CON"+StrZero(x,3)))
				nUltimaCon := x
			EndIf
		Next x
		
		If SZI->(dbSeek( xFilial() + DtoS(dDataInv) + QUERYSZI->ZI_PRODUTO + QUERYSZI->ZI_LOCAL ))
			If Empty(SZI->ZI_SB7)
				
				//Reclock("SZI",.F.)
				//SZI->ZI_SB7 := "S"
				//SZI->( dbUnlock() )
				
				TCSQLEXEC("UPDATE " + RetSqlName("SZI") + " SET ZI_SB7 = 'S' WHERE ZI_DATA = '"+DtoS(dDataInv)+"' AND ZI_PRODUTO = '"+QUERYSZI->ZI_PRODUTO+"' AND ZI_LOCAL = '"+QUERYSZI->ZI_LOCAL+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' " )
				
				cQuery := "SELECT SUM(ZI_CON"+StrZero(nUltimaCon,3)+") AS SOMAQTD FROM " + RetSqlName("SZI") + " WHERE ZI_DATA = '"+DtoS(dDataInv)+"' "
				cQuery += "AND ZI_PRODUTO = '"+QUERYSZI->ZI_PRODUTO+"' AND ZI_LOCAL = '"+QUERYSZI->ZI_LOCAL+"' AND ZI_STATPRO = 'V' AND ZI_STATLIN <> '*' AND D_E_L_E_T_ = '' "
				
				If Select("TEMP") <> 0
					TEMP->( dbCloseArea() )
				EndIf
				
				TCQUERY cQuery NEW ALIAS "TEMP"
				
				
				If SB2->( dbSeek( xFilial() + QUERYSZI->ZI_PRODUTO + QUERYSZI->ZI_LOCAL ) )
					If SB2->B2_CM1 <= 0
						cAssunto  := "Inventario DOMEX " + DtoC(dDataInv)
						cTexto    := "Produto iventariado com B2_CM1 zerado. Ajuste ficarแ sem custo <br>Produto: " + QUERYSZI->ZI_PRODUTO + " Local " + QUERYSZI->ZI_LOCAL
						cPara     := "denis.vieira@rdt.com.br;michel@opusvp.com.br;helio@opusvp.com.br"
						cCC       := "";cArquivo  := ""
						U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
					EndIf
				Else
					cAssunto  := "Inventario DOMEX " + DtoC(dDataInv)
					cTexto    := "Produto iventariado sem SB2. Ajuste ficarแ sem custo <br>Produto: " + QUERYSZI->ZI_PRODUTO + " Local " + QUERYSZI->ZI_LOCAL
					cPara     := "denis.vieira@rdt.com.br;michel@opusvp.com.br;helio@opusvp.com.br"
					cCC       := "";cArquivo  := ""
					U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
				EndIf
				
				If !SB2->( EOF() ) .and. SB2->B2_CM1 > 0
					Reclock("SZI",.F.)
					SZI->ZI_VLRDIF := (TEMP->SOMAQTD * SB2->B2_CM1) - SB2->B2_VATU1
					SZI->( dbUnlock() )
				EndIf
				
				cQuery := "SELECT ZI_PRODUTO, ZI_LOCAL, ZI_LOCALIZ, ZI_LOTECTL, SUM(ZI_CON"+StrZero(nUltimaCon,3)+") AS ZI_QTD "
				cQuery += "FROM " + RetSqlName("SZI") + " WHERE ZI_DATA = '"+DtoS(dDataInv)+"' AND ZI_PRODUTO = '"+QUERYSZI->ZI_PRODUTO+"' "
				cQuery += "AND ZI_LOCAL = '"+QUERYSZI->ZI_LOCAL+"' AND ZI_STATPRO = 'V' AND ZI_STATLIN <> '*' AND D_E_L_E_T_ = '' "
				cQuery += "GROUP BY ZI_PRODUTO, ZI_LOCAL, ZI_LOCALIZ, ZI_LOTECTL "
				
				If Select("TEMP") <> 0
					TEMP->( dbCloseArea() )
				EndIf
				
				TCQUERY cQuery NEW ALIAS "TEMP"
				
				While !TEMP->( EOF() )
					If SB7->( dbSeek( xFilial() + DtoS(dDataInv) + TEMP->ZI_PRODUTO + TEMP->ZI_LOCAL + TEMP->ZI_LOCALIZ + Space(Len(SB7->B7_NUMSERI)) + TEMP->ZI_LOTECTL ) )
						Reclock("SB7",.F.)
						SB7->B7_QUANT := TEMP->ZI_QTD
						SB7->( msUnlock() )
					Else
						If SB1->( dbSeek( xFilial() + TEMP->ZI_PRODUTO ) )
							lMSHelpAuto := .T.  // Para mostrar os erro na tela
							lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro ้ que deu erro
							
							aVetor := {}
							AADD( aVetor,{"B7_FILIAL" 			  ,xFilial("SB7")			   	,Nil} )
							AADD( aVetor,{"B7_DATA"            ,dDataInv                   ,Nil} )
							AADD( aVetor,{"B7_COD"             ,TEMP->ZI_PRODUTO           ,Nil} )
							AADD( aVetor,{"B7_LOCAL"           ,TEMP->ZI_LOCAL             ,Nil} )
							AADD( aVetor,{"B7_QUANT"           ,TEMP->ZI_QTD  		         ,Nil} )
							AADD( aVetor,{"B7_DOC"             ,'INVENT'                   ,Nil} )
							AADD( aVetor,{"B7_LOTECTL"         ,TEMP->ZI_LOTECTL           ,Nil} )
							AADD( aVetor,{"B7_LOCALIZ"         ,TEMP->ZI_LOCALIZ           ,Nil} )
							
							lBloqueado := .F.
							If SB1->B1_MSBLQL = '1'
								Reclock("SB1",.F.)
								SB1->B1_MSBLQL := '2'
								SB1->( msUnlock() )
								lBloqueado := .T.
							EndIf
							
							//BEGIN transaction
							
							MSExecAuto({|x,y,z| MATA270(x,y,z)},aVetor,.f.,3)
							
							//END Transaction
							
							If lBloqueado
								Reclock("SB1",.F.)
								SB1->B1_MSBLQL := '1'
								SB1->( msUnlock() )
							EndIf
							
							If lMSErroAuto
								MOSTRAERRO()
								lMSHelpAuto := .T.  // Para mostrar os erro na tela
								lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro ้ que deu erro
							Endif
						EndIf
					EndIf
					TEMP->( dbSkip() )
				End
			Else
			   TCSQLEXEC("UPDATE " + RetSqlName("SZI") + " SET ZI_SB7 = 'S' WHERE ZI_DATA = '"+DtoS(dDataInv)+"' AND ZI_PRODUTO = '"+QUERYSZI->ZI_PRODUTO+"' AND ZI_LOCAL = '"+QUERYSZI->ZI_LOCAL+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' " )
			EndIf
		EndIf
		QUERYSZI->( dbSkip() )
	End
EndIf

SZI->( dbSetOrder(1) )
SZI->( dbGoTop() )
oObjMBrw := GetObjBrow()
oObjMBrw:GoTop()
oObjMBrw:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SZIDELUL บAutor  ณHelio Ferreira      บ Data ณ  20/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Deleta ultima contagem	    								        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SZIDELUL()

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura a ultima contagem													 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
nUtimaCon := 0
For x := 2 to 8
	If !Empty(&("SZI->ZI_USU"+StrZero(x,3)))
		nUtimaCon := x
	EndIf
Next x   

If nUtimaCon > 0

	Reclock("SZI",.F.)
	&("SZI->ZI_USU"+StrZero(nUtimaCon,3)) := ""
	&("SZI->ZI_CON"+StrZero(nUtimaCon,3)) := 0
	SZI->( msUnlock() )
	
	/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza ultima contagem													 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	cQuery := "UPDATE "       +RetSqlName("SZC")   +"  SET D_E_L_E_T_ = '*' WHERE "
	cQuery += "ZC_FILIAL  = '"+xFilial("SZC")      +"' AND "
	cQuery += "ZC_DATAINV = '"+DtoS(dDataInv)      +"' AND "
	cQuery += "ZC_XXPECA  = '"+SZI->ZI_XXPECA      +"' AND "
	cQuery += "ZC_LOCAL   = '"+SZI->ZI_LOCAL       +"' AND "
	cQuery += "ZC_LOCALIZ = '"+SZI->ZI_LOCALIZ     +"' AND "
	cQuery += "ZC_CONTAGE = '"+StrZero(nUtimaCon,3)+"' AND "
	cQuery += "D_E_L_E_T_ = '' "
	TCSQLEXEC(cQuery)
	
	cQuery := "SELECT MAX(ZI_CONTAGE) AS ZI_CONTAGE FROM SZI010 WHERE ZI_PRODUTO = '"+SZI->ZI_PRODUTO+"' AND ZI_STATLIN <> '*' AND D_E_L_E_T_ = '' "
	
	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TEMP"
	
	cContagem := TEMP->ZI_CONTAGE
	
	cQuery := "UPDATE " + RetSqlName("SZI") + " SET ZI_CONTAGE = '"+cContagem+"' "
	cQuery += "WHERE ZI_DATA = '"+DtoS(dDataInv)+"' AND D_E_L_E_T_ = '' AND ZI_STATLIN <> '*' AND ZI_PRODUTO = '"+SZI->ZI_PRODUTO+"' "
	TCSQLEXEC(cQuery)
	
Else    

   nAviso := Aviso("Aten็ใo","Esse registro de coleta serแ apagado. Confirma ?",{"Sim","Nao"})
   If nAviso == 1
      Reclock("SZI",.F.)
      SZI->(dbDelete())
      SZI->(MsUnlock())
   EndIf

EndIf

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza o filtro de browse												 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
U_SZIFILPRO()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VerP04   บAutor  ณMichel Sander       บ Data ณ  15.10.2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica os produtos por equipe de contagem			        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VerP04(cProdIni,cProdFin,cUserP04)

aSeleProd := {}
csql := "SELECT P04_CODPRO FROM P04010 WHERE P04_CODPRO BETWEEN '"+cProdIni+"' AND '"+cProdFin+"' AND P04_CODUSU = '"+cUserP04+"' AND D_E_L_E_T_=''"
dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSQL),"TMP",.F.,.T.)

While P04->(!Eof())
	AADD(aSeleProd,TMP->P04_CODPRO)
	P04->(dbSkip())
EndDo

P04->(dbclosearea())

Return ( aSeleProd )
