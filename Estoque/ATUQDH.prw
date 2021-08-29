#include "rwmake.ch"
#include "Protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATUQDH    ºAutor  ³Helio Ferreira      º Data ³  01/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ATUQDH(cCodProd)

//fProcessa()

Return

RPCSetType(3)
aAbreTab := {}
RpcSetEnv("01","01",,,,,aAbreTab)

cQuery := "SELECT QDH_DOCTO, MAX(QDH_RV) AS QDH_RV FROM QDH010 WHERE D_E_L_E_T_ = '' GROUP BY QDH_DOCTO"

TCQUERY cQuery NEW ALIAS "QUERYQDH"

QDH->( dbSetOrder(1) )
SZV->( dbSetOrder(1) )

While !QUERYQDH->( EOF() )
	If QDH->( dbSeek( xFilial() + QUERYQDH->QDH_DOCTO + QUERYQDH->QDH_RV ) )
		fProcessa()
	EndIf
	QUERYQDH->( dbSkip() )
End

Return


Static Function fProcessa()

//cMascara := Alltrim(StrTran(Upper(QDH->QDH_DOCTO),"X","_"))

QDH->( dbSetOrder(1) )
SZV->( dbSetOrder(1) )

//cQuery := "UPDATE " + RetSqlName("SZV") + " SET D_E_L_E_T_ = '*' WHERE ZV_ALIAS = 'SB1' AND ZV_ARQUIVO = '"+QDH->QDH_DOCTO+"' AND D_E_L_E_T_ = '' "

//TCSQLEXEC(cQuery)

/*
aCores  := {	{'Qd050DstPd()','BR_AZUL' },;
{'QDH->QDH_OBSOL == "N" .And. QDH->QDH_STATUS == "L  " .And. QDH->QDH_CANCEL <> "S"','ENABLE' },;
{'QDH->QDH_OBSOL == "N" .And. QDH->QDH_STATUS <> "L  " .And. QDH->QDH_CANCEL <> "S"','BR_AMARELO'},;
{'QDH->QDH_CANCEL = "S" .And. QDH->QDH_STATUS <> "L  " ','BR_BRANCO'},;
{'QDH->QDH_CANCEL = "S" ','BR_PRETO'},;
{'QDH->QDH_OBSOL == "S" .And. QDH->QDH_CANCEL <> "S"','DISABLE'}}

*/

If QDH->QDH_OBSOL == "N" .And. QDH->QDH_STATUS == "L  " .And. QDH->QDH_CANCEL <> "S"  // 'ENABLE' - Legenda Verde
	cMascara0   := Alltrim(QDH->QDH_XXMAS0)
	//cMascara1   := Alltrim(QDH->QDH_XXMAS1)
	//cMascara2   := Alltrim(QDH->QDH_XXMAS2)
	//cMascara3   := Alltrim(QDH->QDH_XXMAS3)
	//cMascara4   := Alltrim(QDH->QDH_XXMAS4)
	//cMascara5   := Alltrim(QDH->QDH_XXMAS5)
	//cMascara6   := Alltrim(QDH->QDH_XXMAS6)
	//cMascara7   := Alltrim(QDH->QDH_XXMAS7)
	//cMascara8   := Alltrim(QDH->QDH_XXMAS8)
	//cMascara9   := Alltrim(QDH->QDH_XXMAS9)
	
	If !Empty(cMascara0)
		cQuery := "SELECT B1_COD FROM " + RetSqlName("SB1") + " WHERE ( "
		cQuery += "B1_COD LIKE '" + cMascara0 + "%' "//OR "
		//cQuery += "B1_COD LIKE '" + cMascara1 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara2 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara3 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara4 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara5 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara6 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara7 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara8 + "%' OR "
		//cQuery += "B1_COD LIKE '" + cMascara9 + "%' "
		cQuery += " ) AND D_E_L_E_T_ = '' AND (B1_GRUPO = 'DIO' OR B1_GRUPO = 'DIOE') "
		
		If Select("QUERYSB1") <> 0
			QUERYSB1->( dbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "QUERYSB1"
		
		If !QUERYSB1->( EOF() )
			cQuery := "UPDATE " + RetSqlName("SZV") + " SET D_E_L_E_T_ = '*' WHERE ZV_ALIAS = 'SB1' AND ZV_ARQUIVO = '"+QDH->QDH_DOCTO+"' AND D_E_L_E_T_ = '' "
			TCSQLEXEC(cQuery)
		EndIf
		
		While !QUERYSB1->( EOF() )
			//tcSqlExec("UPDATE SZV010 SET D_E_L_E_T_ = '*' WHERE ZV_ALIAS = 'SB1' AND ZV_CHAVE = '"+QUERYSB1->B1_COD+"' AND D_E_L_E_T_ = '' ")
			If !SZV->( dbSeek( xFilial() + "SB1" + QUERYSB1->B1_COD + QDH->QDH_DOCTO ) )
				Reclock("SZV",.T.)
				SZV->ZV_FILIAL  := xFilial("SZV")
				SZV->ZV_ALIAS   := "SB1"
				SZV->ZV_CHAVE   := QUERYSB1->B1_COD
				SZV->ZV_ARQUIVO := QDH->QDH_DOCTO
				SZV->ZV_DESCRI  := QDH->QDH_TITULO
				SZV->( msUnlock() )
			EndIf
			QUERYSB1->( dbSkip() )
		End
	EndIf
EndIf

Return
