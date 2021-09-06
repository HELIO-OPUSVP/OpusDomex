/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณITEM      บAutor  ณMicrosiga           บ Data ณ  04/25/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto Entrada MVC MATA010 - Cadastro produtos              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ITEM()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ""
	Local cIdPonto   := ""
	Local cIdModel   := ""
	//Local lIsGrid    := .F.
	//Local nLinha     := 0
	//Local nQtdLinhas := 0
	//Local cMsg       := ""
	//Local cOpcaoAtu  := ""
	Local aEstrut	  := {}
	Local aDoctos	  := {}
	//Local _cPastas   := ""
	//Local _cCampos   := ""
	Local cDescDoc	  := ""
	Local cRegra	  := ""
	Local _i
	Local _x
	Private _Codigo  := ""
	Private oError   := ErrorBlock({|e| MsgAlert("Regra invแlida: " +chr(10)+ e:Description,"Aviso")})
	Private cQuery   := ""

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

	If aParam <> NIL
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]

		aEstrut:= {}
		aDoctos := {}

		if M->B1_QB == 0
			M->B1_QB := 1
		Endif

		If cIdPonto == "MODELCOMMITTTS" .AND. INCLUI

			if M->B1_TIPO == "PA"  .or. M->B1_TIPO == "PI"

				if Upper(Alltrim(FunName())) <> "DOMCADI"
				 	if !(msgYesNo("Deseja gerar a estrutura do Produto?","Aten็ใo"))
						Return xRet
					Endif
				Endif	

				_Codigo := M->B1_COD

				If Select("QRY") > 0
					QRY->(dbCloseArea())
				Endif

				cQuery:= " SELECT ZZA_BASE,ZZA_PN,ZZA_DESCR,ZZA_QUANT,ZZA_TIPO,ZZA_QETQ1,ZZA_QETQ2,ZZA_EMB,ZZA_PSEMB,ZZA_CONTEU, ZZA_QTDVIA, "
				cQuery+= " R_E_C_N_O_,  D_E_L_E_T_ = '', "
				cQuery+= " ISNULL(CAST(CAST(ZZA_MREGRA AS VARBINARY(8000)) AS VARCHAR(8000)),'') ZZA_REGRA "
				cQuery+= " FROM "+RETSQLNAME("ZZA")+" ZZA "
				cQuery+= " WHERE ZZA_FILIAL = '"+xFilial("ZZA")+"' "
				cQuery+= " AND ZZA_BASE = '"+SUBSTRING(M->B1_COD,1,2)+"' "
				cQuery+= " AND D_E_L_E_T_ = '' "
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

				If !QRY->(eof())
					While QRY->(!eof())
						IF  QRY->ZZA_TIPO == "1"
							aadd(aEstrut,{ QRY->ZZA_BASE,  QRY->ZZA_PN, QRY->ZZA_CONTEU,"SUBSTRING(_Codigo,1,2)== '"+RTRIM( QRY->ZZA_BASE)+"' .AND. "+ RTRIM( QRY->ZZA_REGRA), QRY->ZZA_QETQ1, QRY->ZZA_QETQ2, QRY->ZZA_EMB, QRY->ZZA_PSEMB, QRY->ZZA_QTDVIA})
						ElseIF  QRY->ZZA_TIPO == "2"
							aadd(aDoctos,{ QRY->ZZA_BASE,  QRY->ZZA_PN, QRY->ZZA_CONTEU,"SUBSTRING(_Codigo,1,2)== '"+RTRIM( QRY->ZZA_BASE)+"' .AND. "+ RTRIM( QRY->ZZA_REGRA), QRY->ZZA_QETQ1, QRY->ZZA_QETQ2, QRY->ZZA_EMB, QRY->ZZA_PSEMB, QRY->ZZA_QTDVIA})
						Endif
						QRY->(dbSkip())
					EndDo
				Else
					msgInfo("Nenhuma regra foi encontrada para cria็ใo da estrutura do produto "+RTRIM(M->B1_COD), "Verifique")
					//Return nil // descomentar essa linha quando entrar em produ็ใo
				Endif

				For _i := 1 To Len(aEstrut)
					Begin Sequence

						cRegra := StrTran(aEstrut[_i,4], "#(", "SUBS(_CODIGO," )
						_lGrava := &(Alltrim(cRegra))
						//_lGrava:=  &(aEstrut[_i,4])
						CONOUT ("ITEM.PRW - PASSANDO PELA REGRA:" + cRegra)
						if  _lGrava
							DbSelectArea("SG1")
							DbSetOrder(1)// G1_FILIAL, G1_COD, G1_COMP, G1_TRT
							if !DbSeek(xFilial("SG1")+M->B1_COD + aEstrut[_i,2])
								RecLock("SG1",.T.)
								SG1->G1_FILIAL 	:= xFilial("SG1")
								SG1->G1_COD			:= M->B1_COD
								SG1->G1_COMP 		:= aEstrut[_i,2]
								SG1->G1_TRT 		:=	""
								SG1->G1_QUANT 		:=	&(aEstrut[_i,3])
								SG1->G1_PERDA 		:= 0
								SG1->G1_INI 		:=	dDatabase
								SG1->G1_FIM 		:=	STOD("20491231")
								SG1->G1_NIV 		:=	"01"
								SG1->G1_OBSERV 	:=	""
								SG1->G1_FIXVAR 	:=	"V"
								SG1->G1_NIVINV 	:=	"99"
								SG1->G1_GROPC 		:=	""
								SG1->G1_REVINI 	:=	""
								SG1->G1_OPC 		:=	""
								SG1->G1_REVFIM 	:=	"ZZZ"
								SG1->G1_POTENCI 	:=	0
								SG1->G1_XXQTET1	:=	aEstrut[_i,5]
								SG1->G1_XXQTET2	:=	aEstrut[_i,6]
								SG1->G1_XXEMBNI	:=	aEstrut[_i,7]
								SG1->G1_XPESEMB	:=	aEstrut[_i,8]
								SG1->G1_XQTDVIA :=	aEstrut[_i,9]
								SG1->( MsUnlock() )

							Endif
						Endif
					End Sequence

					ErrorBlock(oError)
				Next _i

				For _x := 1 To Len(aDoctos)
					Begin Sequence

						cRegra := StrTran(aDoctos[_x ,4], "#(", "SUBS(_CODIGO," )
						_lGrava := &(Alltrim(cRegra))
						//_lGrava:=  &(aDoctos[_x ,4])
						if  _lGrava
							cDescDoc:= Posicione("QDH",1,xFilial("QDH")+ALLTRIM(aDoctos[_x ,2]),"QDH_TITULO")

							DbSelectArea("SZV")
							DbSetOrder(2)// ZV_FILIAL, ZV_CHAVE, ZV_ARQUIVO
							if !DbSeek(xFilial("SZV")+PADR(M->B1_COD,TAMSX3("ZV_CHAVE")[1])+ aDoctos[_x ,2])
								RecLock("SZV",.T.)
								SZV->ZV_FILIAL := xFilial("SZV")
								SZV->ZV_ALIAS 	:= "SB1"
								SZV->ZV_CHAVE 	:= M->B1_COD
								SZV->ZV_ARQUIVO:= aDoctos[_x ,2]
								SZV->ZV_DESCRI := cDescDoc
								SZV->ZV_DOCTO 	:= ""
								SZV->(MsUnlock())
							Endif
						Endif
					End Sequence

					ErrorBlock(oError)
				Next _x
			Endif
		Endif
	EndIf
Return xRet

