//MAURICIO LIMA DE SOUZA 17/02/2014
#INCLUDE "PROTHEUS.CH"

USER FUNCTION UPDLTIME()

PRIVATE cDrvSHA  :=""
PRIVATE cArquivo :=""
PRIVATE nCONT    :=0

#IFDEF WNTX
	cDrvSHA := "DBFNTX"
#ENDIF
#IFDEF WCDX
	cDrvSHA := "DBFCDX"
#ENDIF
#IFDEF WAXS
	cDrvSHA := "DBFCDXAX"
#ENDIF

cArquivo := 'LT_TOTAL.dbf'

If MSFile(cArquivo,,cDrvSHA)
	dbUseArea( .T.,cDrvSHA, cArquivo, "TRB", If(.F. .OR. .T., !.T., NIL), .F. )
	If !Used()
		msgalert('em uso')
		Return NIL
	EndIf
Else
	msgalert('nao encontrado')
	Return NIL
EndIf

TRB->(dbSelectArea("TRB"))
TRB->(dbGotop())

SB1->(DBSELECTAREA('SB1'))
SB1->(DBSETORDER(1))
//TRB->PRODUTO
//TRB->LT

DO WHILE !TRB->(EOF())
	nCONT++
	IF SB1->(dbSeek( xFilial('SB1') + ALLTRIM(TRB->PRODUTO)))
		SB1->(RECLOCK("SB1",.F.))
		SB1->B1_PE   := TRB->LT
		SB1->B1_TIPE := 'D'
		SB1->(MSUNLOCK())
	ELSE
		MSGALERT('Produto nao encontrado: '+ALLTRIM(TRB->PRODUTO))
	ENDIF
	TRB->(DBSKIP())
ENDDO

MSGALERT('FIM '+ Transform(nCONT,"@E 999,999.99"))
TRB->(DBCLOSEAREA())
RETURN
