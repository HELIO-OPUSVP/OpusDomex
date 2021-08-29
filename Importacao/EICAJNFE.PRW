//------------------------------------------------------------------------------------//
//Empresa...:  DOMEX
//------------------------------------------------------------------------------------//
//Funcao....: ANALISTA DE SISTEMAS
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......: 06/2013
//Uso.......: Ajuste itens NF entrada EIC SD1 X SWN X SW8 X SW7
//            Rejeição :CFOP IMPORTAÇÃO E NAO ENCONTRADO DADOS DI
//Versao....: 11
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

#INCLUDE "MSOBJECT.CH"

*----------------------------------------------------------------------------------------
USER FUNCTION EICAJNFE()
*----------------------------------------------------------------------------------------
Local oFont1  := TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local _cPAR01 :=SPACE(LEN(SD1->D1_DOC))
Local _cPAR02 :=SPACE(LEN(SD1->D1_SERIE))
Local _cPAR03 :=SPACE(LEN(SW8->W8_HAWB))

Local lImport := .F.
Local lLOOP   := .T.

Local oGet1
Local oGet2
Local oGet3

Local oSButton1
Local oSButton2

Static oDlgAJNFE

PRIVATE ccadastro :='Ajuste itens NF entrada EIC SD1 X SWN X SW8 X SW7'

PRIVATE cQUERY1 :=''
PRIVATE cQUERY2 :=''
PRIVATE cQUERY3 :=''
PRIVATE cQUERY4 :=''

DO WHILE lLOOP
	_cPAR01 :=SPACE(LEN(SD1->D1_DOC))
	_cPAR02 :=SPACE(LEN(SD1->D1_SERIE))
	_cPAR03 :=SPACE(LEN(SW8->W8_HAWB))
	
	cQUERY1 :=''
	cQUERY2 :=''
	cQUERY3 :=''
	cQUERY4 :=''
	
	DEFINE MSDIALOG oDlgNFE TITLE 'Ajuste itens NF entrada EIC SD1 X SWN X SW8 X SW7' FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL
	
	@ 011, 010 SAY oSay1 PROMPT "Rejeição :CFOP DE IMPORTAÇÃO, DI " 	SIZE 336, 024 OF oDlgNFE FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 037, 010 SAY oSay2 PROMPT "Nota Fiscal :" 	     	      SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 050, 010 SAY oSay3 PROMPT "Serie :" 			            SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 063, 010 SAY oSay3 PROMPT "Processo :" 	               SIZE 045, 007 OF oDlgNFE COLORS 0, 16777215 PIXEL
	
	@ 037, 050 MSGET oGet1 VAR _cPAR01 WHEN(.T.) F3 "SD1EIC" SIZE 050, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 050, 050 MSGET oGet2 VAR _cPAR02 WHEN(.T.)             SIZE 030, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	@ 063, 050 MSGET oGet3 VAR _cPAR03 WHEN(.T.) F3 "SW6"    SIZE 050, 010 OF oDlgNFE COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgNFE ENABLE Action (lImport :=.T., oDlgNFE:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgNFE ENABLE Action (lLOOP   :=.F., oDlgNFE:End() )//oDlgNFE:End()
	
	ACTIVATE MSDIALOG oDlgNFE CENTERED
	
	
	IF lImport ==.T. //.AND. !EMPTY(_cPAR01)  .AND. !EMPTY(_cPAR02)  .AND. !EMPTY(_cPAR03)
		lImport :=.F.
		
		SW9->(DbSelectArea("SW9"))
		SW9->(DbSetOrder(3))
		If !(SW9->(dbSeek( xFilial('SW9') + _cPAR03 )))
			MSGALERT('Processo: '+alltrim(_cPAR03)+' não encontrado.' )
			RETURN
		ENDIF
		
		SD1->(DbSelectArea("SD1"))
		SD1->(DbSetOrder(1))
		If !(SD1->(dbSeek( xFilial('SD1') + _cPAR01 + _cPAR02  )))
			MSGALERT('Nota Fiscal: '+alltrim(_cPAR01)+' Série: '+_cPAR02+' não encontrada.' )
			RETURN
		ENDIF
		
		IF EMPTY(_cPAR01)  .OR. EMPTY(_cPAR02)  .OR. EMPTY(_cPAR03)
			MSGALERT('Existe Parametros não preenchido.' )
			RETURN
		ENDIF
		
		//-----FASE 1 - AJUSTE WN_ITEM-------------------------------------------------------------------------------------------------
		cQUERY1:= " UPDATE "+RetSqlName('SWN')+"      "
		cQUERY1+= " SET WN_ITEM=                      "
		cQUERY1+= " (SELECT TOP 1 D1_ITEMPC           "
		cQUERY1+= "       FROM "+RetSqlName('SD1')+" with (NOLOCK)    "
		cQUERY1+= "       WHERE                       "
		cQUERY1+= "       D_E_L_E_T_<>'*'         AND "
		cQUERY1+= "       D1_DOC    = WN_DOC      AND "
		cQUERY1+= "       D1_SERIE  = WN_SERIE    AND "
		cQUERY1+= "       D1_PEDIDO = WN_PO_NUM   AND "
		cQUERY1+= "       D1_COD    = WN_PRODUTO  AND "
		cQUERY1+= "       D1_QUANT  = WN_QUANT   ),   "
		cQUERY1+= " WN_FORNECE=                       "
		cQUERY1+= " (SELECT TOP 1 D1_FORNECE          "
		cQUERY1+= "       FROM "+RetSqlName('SD1')+" with (NOLOCK)  "
		cQUERY1+= "       WHERE                       "
		cQUERY1+= "       D_E_L_E_T_<>'*'         AND "
		cQUERY1+= "       D1_DOC    = WN_DOC      AND "
		cQUERY1+= "       D1_SERIE  = WN_SERIE    AND "
		cQUERY1+= "       D1_PEDIDO = WN_PO_NUM   AND "
		cQUERY1+= "       D1_COD    = WN_PRODUTO  AND "
		cQUERY1+= "       D1_QUANT  = WN_QUANT   ),   "
		cQUERY1+= " WN_LOJA=                          "
		cQUERY1+= " (SELECT TOP 1 D1_LOJA             "
		cQUERY1+= "       FROM "+RetSqlName('SD1')+" with (NOLOCK)  "
		cQUERY1+= "       WHERE                       "
		cQUERY1+= "       D_E_L_E_T_<>'*'         AND "
		cQUERY1+= "       D1_DOC    = WN_DOC      AND "
		cQUERY1+= "       D1_SERIE  = WN_SERIE    AND "
		cQUERY1+= "       D1_PEDIDO = WN_PO_NUM   AND "
		cQUERY1+= "       D1_COD    = WN_PRODUTO  AND "
		cQUERY1+= "       D1_QUANT  = WN_QUANT   )    "
		cQUERY1+= " FROM "+RetSqlName('SWN')+"  with (NOLOCK) "
		cQUERY1+= " WHERE  D_E_L_E_T_<>'*'       AND  "
		cQUERY1+= "       WN_DOC  ='"+_cPAR01+"' AND  "
		cQUERY1+= "       WN_SERIE='"+_cPAR02+"' AND  "
		cQUERY1+= "       EXISTS                      "
		cQUERY1+= " (SELECT TOP 1 D1_ITEMPC           "
		cQUERY1+= "       FROM "+RetSqlName('SD1')+"  with (NOLOCK) "
		cQUERY1+= "       WHERE                       "
		cQUERY1+= "       D_E_L_E_T_<>'*'         AND "
		cQUERY1+= "       D1_DOC    = WN_DOC      AND "
		cQUERY1+= "       D1_SERIE  = WN_SERIE    AND "
		cQUERY1+= "       D1_PEDIDO = WN_PO_NUM   AND "
		cQUERY1+= "       D1_COD    = WN_PRODUTO  AND "
		cQUERY1+= "       D1_QUANT  = WN_QUANT   )    "
		//-----FASE 2 - AJUSTE W8_POSICAO--------------------------------------------------------------------------------------
		cQUERY2:= " UPDATE "+RetSqlName('SW8')+"    "
		cQUERY2+= " SET W8_POSICAO=                 "
		cQUERY2+= " (SELECT WN_ITEM    FROM "+RetSqlName('SWN')+" with (NOLOCK) WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*'), "
		cQUERY2+= " W8_FORN=                                                                                                                               "
		cQUERY2+= " (SELECT WN_FORNECE FROM "+RetSqlName('SWN')+" with (NOLOCK) WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*'), "
		cQUERY2+= " W8_FORLOJ=                                                                                                                             "
		cQUERY2+= " (SELECT WN_LOJA    FROM "+RetSqlName('SWN')+" with (NOLOCK) WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*')  "
		cQUERY2+= " FROM "+RetSqlName('SW8')+"  with (NOLOCK) "
		cQUERY2+= " WHERE W8_HAWB='"+_cPAR03+"'   AND D_E_L_E_T_<>'*'                                                                                       "
		cQUERY2+= " AND EXISTS                                                                                                                             "
		cQUERY2+= " (SELECT WN_ITEM    FROM "+RetSqlName('SWN')+" with (NOLOCK) WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*')  "
		//-----FASE 3 - AJUSTE W7_POSICAO--------------------------------------------------------------------------------------
		cQUERY3:= " UPDATE "+RetSqlName('SW7')+"         "
		cQUERY3+= " SET W7_POSICAO=                      "
		cQUERY3+= " (SELECT TOP 1 W8_POSICAO FROM "+RetSqlName('SW8')+" with (NOLOCK) "
		cQUERY3+= " WHERE  W8_FILIAL  = W7_FILIAL  AND   "
		cQUERY3+= " W8_HAWB    = W7_HAWB    AND          "
		cQUERY3+= " W8_PO_NUM  = W7_PO_NUM  AND          "
		cQUERY3+= " W8_PGI_NUM = W7_PGI_NUM AND          "
		cQUERY3+= " W8_COD_I   = W7_COD_I   AND          "
		cQUERY3+= " W8_QTDE    = W7_QTDE    AND          "
		cQUERY3+= " "+RetSqlName('SW8')+".D_E_L_E_T_<>'*'),              "
		cQUERY3+= " W7_FORN=                             "
		cQUERY3+= " (SELECT TOP 1 W8_FORN     FROM "+RetSqlName('SW8')+" with (NOLOCK) "
		cQUERY3+= " WHERE  W8_FILIAL  = W7_FILIAL  AND   "
		cQUERY3+= " W8_HAWB    = W7_HAWB    AND          "
		cQUERY3+= " W8_PO_NUM  = W7_PO_NUM  AND          "
		cQUERY3+= " W8_PGI_NUM = W7_PGI_NUM AND          "
		cQUERY3+= " W8_COD_I   = W7_COD_I   AND          "
		cQUERY3+= " W8_QTDE    = W7_QTDE    AND          "
		cQUERY3+= " "+RetSqlName('SW8')+".D_E_L_E_T_<>'*'),              "
		cQUERY3+= " W7_FORLOJ=                           "
		cQUERY3+= " (SELECT TOP 1 W8_FORLOJ   FROM "+RetSqlName('SW8')+" with (NOLOCK) "
		cQUERY3+= " WHERE  W8_FILIAL  = W7_FILIAL  AND   "
		cQUERY3+= " W8_HAWB    = W7_HAWB    AND          "
		cQUERY3+= " W8_PO_NUM  = W7_PO_NUM  AND          "
		cQUERY3+= " W8_PGI_NUM = W7_PGI_NUM AND          "
		cQUERY3+= " W8_COD_I   = W7_COD_I   AND          "
		cQUERY3+= " W8_QTDE    = W7_QTDE    AND          "
		cQUERY3+= " "+RetSqlName('SW8')+".D_E_L_E_T_<>'*')              "
		cQUERY3+= " FROM "+RetSqlName('SW7')+"  with (NOLOCK) "
		cQUERY3+= " WHERE W7_HAWB='"+_cPAR03+"' AND SW7010.D_E_L_E_T_<>'*' "                                                                                     "
		cQUERY3+= " AND EXISTS                           "
		cQUERY3+= " (SELECT TOP 1 W8_POSICAO FROM   "+RetSqlName('SW8')+" with (NOLOCK) "
		cQUERY3+= " WHERE W8_FILIAL  = W7_FILIAL  AND    "
		cQUERY3+= " W8_HAWB    = W7_HAWB    AND          "
		cQUERY3+= " W8_PO_NUM  = W7_PO_NUM  AND          "
		cQUERY3+= " W8_PGI_NUM = W7_PGI_NUM AND          "
		cQUERY3+= " W8_COD_I   = W7_COD_I   AND          "
		cQUERY3+= " W8_QTDE    = W7_QTDE    AND          "
		cQUERY3+= " "+RetSqlName('SW8')+".D_E_L_E_T_<>'*')              "
		//-----FASE 4 - AJUSTE BASE ICMS--------------------------------------------------------------------------------------
		cQUERY4:= "	UPDATE "+RetSqlName('SD1')+"  SET D1_BASEICM=D1_VALICM/(D1_PICM/100)        "
		cQUERY4+= " FROM   "+RetSqlName('SD1')+"  with (NOLOCK)  "
		cQUERY4+= " WHERE D1_DOC  ='"+_cPAR01+"' AND  "
		cQUERY4+= "       D1_SERIE='"+_cPAR02+"' AND  "
		cQUERY4+= "       D_E_L_E_T_<>'*'             "
		
		MsAguarde( { || EICAJ002() } , "AGUARDE..." )
		
	ENDIF
ENDDO


RETURN

*----------------------------------------------------------------------------------------
STATIC FUNCTION EICAJ002()
*----------------------------------------------------------------------------------------


TCSQLEXEC(cQUERY1)
TCSQLEXEC(cQUERY2)
TCSQLEXEC(cQUERY3)
TCSQLEXEC(cQUERY4)

MSGALERT('FIM')

Return

*----------------------------------------------------------------------------------------
USER FUNCTION EICAJTXE
*----------------------------------------------------------------------------------------
Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local _cPAR01 :=SPACE(LEN(SW9->W9_HAWB))
Local _nPAR02 :=0
Local _cPAR02 :=' '

Local lImport  := .F.
Local lLOOP    := .T.

Local oGet1
Local oGet2

Local oSButton1
Local oSButton2

Static oDlgAJTXE

PRIVATE ccadastro :='Ajuste taxa moeda Entreposto'

PRIVATE cQUERY1 :=''
/*
DO WHILE lLOOP
	_cPAR01 :=SPACE(LEN(SW9->W9_HAWB))
	_nPAR02 :=0.0000
	_cPAR02 :=' '
	
	cQUERY1 :=''
	
	DEFINE MSDIALOG oDlgAJTXE TITLE 'Ajuste taxa moeda Entreposto' FROM 000, 000  TO 280, 470 COLORS 0, 16777215 PIXEL
	
	@ 011, 010 SAY oSay1 PROMPT "Ajusta Taxa Moeda SW9 "     SIZE 336, 024 OF oDlgAJTXE FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 037, 010 SAY oSay2 PROMPT "Processo Mãe :"   	         SIZE 045, 007 OF oDlgAJTXE COLORS 0, 16777215 PIXEL
	@ 050, 010 SAY oSay3 PROMPT "Taxa Moeda   :" 		      SIZE 045, 007 OF oDlgAJTXE COLORS 0, 16777215 PIXEL
	
	@ 037, 050 MSGET oGet1 VAR _cPAR01 WHEN(.T.) F3 "SW6"                              SIZE 050, 010 OF oDlgAJTXE COLORS 0, 16777215 PIXEL
	@ 050, 050 MSGET oGet2 VAR _nPAR02 WHEN(.T.) PICTURE (PesqPict("SW9","W9_TX_FOB")) SIZE 050, 010 OF oDlgAJTXE COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgAJTXE ENABLE Action (lImport :=.T., oDlgAJTXE:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgAJTXE ENABLE Action (lLOOP   :=.F., oDlgAJTXE:End() )
	
	ACTIVATE MSDIALOG oDlgAJTXE CENTERED
	
	
	IF lImport ==.T. //.AND. !EMPTY(_cPAR01) .AND. _nPAR02 >0
		lImport :=.F.
		
		SW9->(DbSelectArea("SW9"))
		SW9->(DbSetOrder(3))
		If !(SW9->(dbSeek( xFilial('SW9') + _cPAR01 )))
			MSGALERT('Processo: '+alltrim(_cPAR01)+' não encontrado.' )
			RETURN
		ENDIF
		
		IF EMPTY(_cPAR01)
			MSGALERT('Numero processo não preenchido')
			RETURN
		ENDIF
		
		IF _nPAR02 <=0
			MSGALERT('Valor Taxa incorreto')
			RETURN
		ENDIF
		
		_cPAR02 :=alltrim(STR(_nPAR02))
		_cPAR02 :=StrTran(_cPAR02, ",", ".", 1, 1)
		
		cQUERY1:= " UPDATE "+RetSqlName('SW9')+"   "
		cQUERY1+= " SET W9_TX_FOB ="+_cPAR02+"    "
		cQUERY1+= " FROM   "+RetSqlName('SW9')+"  with (NOLOCK)  "		
		cQUERY1+= " WHERE W9_HAWB LIKE ('"+ALLTRIM(_cPAR01)+"%')  "
		cQUERY1+= "    AND D_E_L_E_T_<>'*' "
		
		TCSQLEXEC(cQUERY1)
		MSGALERT('Taxa Moeda alterado')
		
	ENDIF
ENDDO
 */
RETURN

*----------------------------------------------------------------------------------------
USER FUNCTION IDI154MNU()  // P.E. utilizado para adicionar itens no Menu da mBrowse
*----------------------------------------------------------------------------------------

Local aRotAdic :={}
/*
aAdd(aRotAdic,{"Ajuste NFe" ,"U_EICAJNFE", 0 , 2})
aAdd(aRotAdic,{"Taxa Entre" ,"U_EICAJTXE", 0 , 2})
*/

Return aRotAdic







/*
SELECT WN_DOC,WN_SERIE,WN_PO_NUM,WN_PRODUTO,WN_QUANT,WN_FORNECE,WN_LOJA,D1_FORNECE,D1_LOJA,WN_ITEM,D1_ITEMPC, D1_FORNECE, WN_FORNECE
FROM SWN010 ,SD1010
WHERE
SWN010.D_E_L_E_T_<>'*'  AND
SD1010.D_E_L_E_T_<>'*'  AND
WN_DOC      = D1_DOC    AND
WN_SERIE    = D1_SERIE  AND
WN_PO_NUM   = D1_PEDIDO AND
WN_PRODUTO  = D1_COD    AND
WN_QUANT    = D1_QUANT  AND
D1_DOC='029270'
SELECT * FROM SW8010 WHERE W8_HAWB='IMP 2114/13C' AND D_E_L_E_T_<>'*'

-----FASE 1 - AJUSTE WN_ITEM-------------------------------------------------------------------------------------------------
UPDATE SWN010
SET WN_ITEM=
(SELECT TOP 1 D1_ITEMPC
FROM SD1010
WHERE
D_E_L_E_T_<>'*'         AND
D1_DOC    = WN_DOC      AND
D1_SERIE  = WN_SERIE    AND
D1_PEDIDO = WN_PO_NUM   AND
D1_COD    = WN_PRODUTO  AND
D1_QUANT  = WN_QUANT   ),
WN_FORNECE=
(SELECT TOP 1 D1_FORNECE
FROM SD1010
WHERE
D_E_L_E_T_<>'*'         AND
D1_DOC    = WN_DOC      AND
D1_SERIE  = WN_SERIE    AND
D1_PEDIDO = WN_PO_NUM   AND
D1_COD    = WN_PRODUTO  AND
D1_QUANT  = WN_QUANT   ),
WN_LOJA=
(SELECT TOP 1 D1_LOJA
FROM SD1010
WHERE
D_E_L_E_T_<>'*'         AND
D1_DOC    = WN_DOC      AND
D1_SERIE  = WN_SERIE    AND
D1_PEDIDO = WN_PO_NUM   AND
D1_COD    = WN_PRODUTO  AND
D1_QUANT  = WN_QUANT   )
WHERE  D_E_L_E_T_<>'*'  AND
WN_DOC='029270'  AND
EXISTS
(SELECT TOP 1 D1_ITEMPC
FROM SD1010
WHERE
D_E_L_E_T_<>'*'         AND
D1_DOC    = WN_DOC      AND
D1_SERIE  = WN_SERIE    AND
D1_PEDIDO = WN_PO_NUM   AND
D1_COD    = WN_PRODUTO  AND
D1_QUANT  = WN_QUANT   )
-----FASE 2 - AJUSTE W8_POSICAO--------------------------------------------------------------------------------------
UPDATE SW8010
SET W8_POSICAO=
(SELECT WN_ITEM    FROM SWN010 WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*'),
W8_FORN=
(SELECT WN_FORNECE FROM SWN010 WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*'),
W8_FORLOJ=
(SELECT WN_LOJA    FROM SWN010 WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*')
WHERE W8_HAWB='IMP 2114/13C' AND D_E_L_E_T_<>'*'
AND EXISTS
(SELECT WN_ITEM FROM SWN010 WHERE WN_HAWB=W8_HAWB AND WN_PRODUTO=W8_COD_I AND WN_QUANT=W8_QTDE AND D_E_L_E_T_<>'*')
-----FASE 3 - AJUSTE W7_POSICAO--------------------------------------------------------------------------------------
--!SW7->(DbSeek(cFilSW7+SW8->W8_HAWB+SW8->W8_PO_NUM+SW8->W8_POSICAO+SW8->W8_PGI_NUM))
--SELECT W8_FILIAL,W8_HAWB,W8_PO_NUM,W8_POSICAO,W8_PGI_NUM,W8_COD_I,W8_QTDE,* FROM SW8010 WHERE W8_HAWB='IMP 2159/13A'  AND D_E_L_E_T_<>'*' ORDER BY W8_POSICAO
--SELECT W7_FILIAL,W7_HAWB,W7_PO_NUM,W7_POSICAO,W7_PGI_NUM,W7_COD_I,W7_QTDE,* FROM SW7010 WHERE W7_HAWB='IMP 2159/13A'  AND D_E_L_E_T_<>'*' ORDER BY W7_POSICAO
----------------------------------------------------------------------------------------
UPDATE SW7010
SET W7_POSICAO=
(SELECT TOP 1 W8_POSICAO FROM SW8010
WHERE  W8_FILIAL  = W7_FILIAL  AND
W8_HAWB    = W7_HAWB    AND
W8_PO_NUM  = W7_PO_NUM  AND
W8_PGI_NUM = W7_PGI_NUM AND
W8_COD_I   = W7_COD_I   AND
W8_QTDE    = W7_QTDE    AND
SW8010.D_E_L_E_T_<>'*'),
W7_FORN=
(SELECT TOP 1 W8_FORN    FROM SW8010
WHERE  W8_FILIAL  = W7_FILIAL  AND
W8_HAWB    = W7_HAWB    AND
W8_PO_NUM  = W7_PO_NUM  AND
W8_PGI_NUM = W7_PGI_NUM AND
W8_COD_I   = W7_COD_I   AND
W8_QTDE    = W7_QTDE    AND
SW8010.D_E_L_E_T_<>'*'),
W7_FORLOJ=
(SELECT TOP 1 W8_FORLOJ  FROM SW8010
WHERE  W8_FILIAL  = W7_FILIAL  AND
W8_HAWB    = W7_HAWB    AND
W8_PO_NUM  = W7_PO_NUM  AND
W8_PGI_NUM = W7_PGI_NUM AND
W8_COD_I   = W7_COD_I   AND
W8_QTDE    = W7_QTDE    AND
SW8010.D_E_L_E_T_<>'*')
WHERE W7_HAWB='IMP 2114/13C'   AND SW7010.D_E_L_E_T_<>'*'
AND EXISTS
(SELECT TOP 1 W8_POSICAO FROM SW8010
WHERE W8_FILIAL  = W7_FILIAL  AND
W8_HAWB    = W7_HAWB    AND
W8_PO_NUM  = W7_PO_NUM  AND
W8_PGI_NUM = W7_PGI_NUM AND
W8_COD_I   = W7_COD_I   AND
W8_QTDE    = W7_QTDE    AND
SW8010.D_E_L_E_T_<>'*')
----------------------------------------------------------------------------------------



