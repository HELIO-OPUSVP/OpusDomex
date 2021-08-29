# Include "RWMAKE.CH"
# Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณJuliano F. da Silva บ Data ณ  03/24/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Melhoria utilizanod ponto de entrada para auxiliar o Usu   บฑฑ
ฑฑบ          ณ ario evitar o faturamento na integra็ใo de processos com   บฑฑ
ฑฑบ          ณ informa็๕es imcompletas.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Easy Import control                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBRWBTN()

//Local cText := ""
	Local lRet	:= .T.
//Local lRet2 := .T.   
//Local _cPastas := ""
//Local _cCampos := ""

Local _cPastas   := ""

	If FunName() == "MATA010"
		Public cUserAtu
		Public lWhenSB1

		If Type("__lAuto") == "U"
			Public lTrue  := .T.
			Public lFalse := .F.
		Else
			If __lAuto 
				Public lTrue  := .T.
				Public lFalse := .T.
			Else
				Public lTrue  := .T.
				Public lFalse := .F.
			EndIf
		EndIf

		If Empty(cUserAtu)
			cUserAtu:= __CUSERID
			lWhenSB1:= .T.
		Endif

		IF __CUSERID <> cUserAtu
			cUserAtu:= __CUSERID
			lWhenSB1:= .T.
		Endif

		If lWhenSB1
			P08->(DbSetOrder(1))
			IF P08->(dbSeek(xFilial("P08")+__cUserId))
				While !P08->( EOF() ) .and. Alltrim(__cUserId) == P08->P08_CODUSR
					_cPastas += P08->P08_PASTA+","
					P08->( dbSkip() )
				End
			EndIf
			SX3->( dbSetOrder(1) )
			SX3->(dbSeek("SB1"))
			While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SB1"
				IF EMPTY(_cPastas)
					RecLock("SX3",.F.)
					SX3-> X3_WHEN:= "lFalse"
					SX3->( MsUnlock() )
				ELSE
					If Alltrim(SX3->X3_FOLDER) $ _cPastas .or. (Empty(Alltrim(SX3->X3_FOLDER)) .and. "0" $ _cPastas   )
						RecLock("SX3",.F.)
						SX3-> X3_WHEN:= "lTrue"
						SX3->( MsUnlock() )
					Else
						RecLock("SX3",.F.)
						SX3-> X3_WHEN:= "lFalse .or. INCLUI"
						SX3->( MsUnlock() )
					EndIf
				END

				SX3->( dbSkip() )
			End
			lWhenSB1:= .F.
		Endif

	EndIf

// dbSelectArea("P08")
// P08->(DbSetOrder(1))
// IF P08->(dbSeek(xFilial("P08")+__cUserId))
// 	While !P08->( EOF() ) .and. Alltrim(__cUserId) == P08->P08_CODUSR
// 		_cPastas += P08->P08_PASTA+","
// 		P08->( dbSkip() )
// 	End
// EndIf

// SX3->( dbSetOrder(1) )
// SX3->(dbSeek("SB1"))
// While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SB1"
// 	If (Alltrim(SX3->X3_FOLDER) $ _cPastas)  .or. (empty(Alltrim(SX3->X3_FOLDER)) .and. "0" $ _cPastas )
// 		RecLock("SX3",.F.)
// 		SX3-> X3_WHEN:= ""
// 		SX3->( MsUnlock() )
// 	Else
// 		RecLock("SX3",.F.) 
// 		if !empty(_cPastas) 
// 			SX3-> X3_WHEN:= "INCLUI" 
// 		Else
// 			SX3-> X3_WHEN:= ".F." 
// 		Endif
// 		SX3->( MsUnlock() )
// 	EndIf
// 	SX3->( dbSkip() )
// Enddo

Return lRet

/*

cText := "           Processo :  "+SW6->W6_HAWB+" "+chr(13)+;
         " Nใo serแ permitido Gerar a Primeira Nota ! "+chr(13)+;
         "           Falta(m) o(s) Campo(s) "+chr(13)   

	If FunName() == "EICDI154"
		If PARAMIXB[4] == "DI154NFE"
			If Empty (SW6->W6_DI_NUM)
         lRet := .F.
         cText += " No. da DI.    - Num.Declara็ใo Importa็ใo   - Pasta 1 "+chr(13)   
			EndIf
			If Empty (SW6->W6_REF_DES)
         lRet := .F.
         cText += " Ref. Desp.    - Referente Agente            - Pasta 1 "+chr(13)   
			EndIf
			If Empty (SW6->W6_DT_DTA)
         lRet := .F.
         cText += " Dt. Decl      - Data Declara็ใo Aduaneira   - Pasta 1 "+chr(13)   
			EndIf
			If Empty (SW6->W6_DT_AVE)
         lRet := .F.
         cText += " Dt. Averba็ใo - Fechamento Decl Reg Civil   - Pasta 2 "+chr(13)   
			EndIf
			If Empty (SW6->W6_HOUSE)
         lRet := .F.
         cText += " House / B.L.  - House / B.L.                - Pasta 2 "+chr(13)   
			EndIf
			If Empty (SW6->W6_PRCARGA)
         lRet := .F.
         cText += " Presen.Carga  - Presen็a de Carga           - Pasta 2 "+chr(13)   
			EndIf
			If Empty (SW6->W6_PESO_BR)
         lRet := .F.
         cText += " Peso Bruto    - Peso Bruto                  - Pasta 3 "+chr(13)   
			EndIf
			If Empty (SW6->W6_TRANS)
         lRet := .F.
         cText += " Transport.    - Transportadora              - Pasta 3 "+chr(13)   
			EndIf
			If Empty (SW6->W6_DT_DESE)
         lRet := .F.
         cText += " Dt Desembara็o- Data Desembara็o            - Pasta 6 "+chr(13)   
			EndIf
      
			If !lRet
         MsgAlert(cText)
         lRet2 := .F.
			EndIf
      
			If lRet2 .And. Empty(SW6->W6_NF_ENT)
         MsgAlert(" Confira o Numero da DI: "+SW6->W6_DI_NUM)
			EndIf
      
      //cText := "Alias [ " + PARAMIXB[1]				+ " ]" + CRLF
      //cText += "Recno [ " + AllTrim(Str(PARAMIXB[2])) + " ]" + CRLF
      //cText += "Recno [ " + AllTrim(Str(PARAMIXB[3])) + " ]" + CRLF
      // cText += "Recno [ " + PARAMIXB[4]				+ " ]" + CRLF
		EndIf
	EndIf

   
Return lRet


*/
