#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บAutor  ณHelio Ferreira      บ Data ณ  10/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Projetos Opus                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSZ4CAD()
Local aCores   := {}
Local cFilSZJ  := ''  //  "Z4_CODIGO <= '000010'"

Public cBlqCli := ''

cCadastro := "RSZ4CAD - Projetos Opus"

If __cUserID == '000013' // Denis Domex
   cFilSZJ := "Z4_CLIENTE = '000012'"
   cBlqCli := '000012'
EndIf

If __cUserID == '000017' // Antonio Alltec
   cFilSZJ := "Z4_CLIENTE = '000006'"
   cBlqCli := '000006'
EndIf

If __cUserID == '000018' // Emerson Pelican
   cFilSZJ := "Z4_CLIENTE = '000001'"
   cBlqCli := '000001'
EndIf

aRotina := {}

AADD(aRotina , { "Pesquisar   "      ,'AxPesqui'                  , 0, 1 } )
AADD(aRotina , { "Visualizar  "      ,'AxVisual'                  , 0, 2 } )
AADD(aRotina , { "Incluir     "      ,'AxInclui'                  , 0, 3 } )
AADD(aRotina , { "Alterar     "      ,'AxAltera'                  , 0, 4 } )
AADD(aRotina , { "Excluir     "      ,'AxDeleta'                  , 0, 5 } )
AADD(aRotina , { "Relat๓rio   "      ,'U_RPRJ01'                  , 0, 6 } )
AADD(aRotina , { "Sincronizar "      ,'U_SITBOPUS'                , 0, 3 } )

SetKey(VK_F5, { || U_SITBOPUS()    } )

If Empty(cFilSZJ)
   AADD(aRotina , { "Manuten็ใo  "      ,'U_MANUTPRJ', 0, 8 } )
   AADD(aRotina , { "oTree       "      ,'U_F3SZ4(SZ4->Z4_CLIENTE,.F.)'  , 0, 6 } )
Else
   AADD(aRotina , { "oTree       "      ,'U_F3SZ4(SZ4->Z4_CLIENTE,.T.)'  , 0, 6 } )
EndIf

AADD(aRotina , { "Integra็ใo Project",'U_fPROJECT', 0, 7 } )

U_SITBOPUS()

dbSelectArea("SZ4")

mBrowse(6,1,22,75,"SZ4",Nil,,,,,aCores,,,,,,,,cFilSZJ)

Return
