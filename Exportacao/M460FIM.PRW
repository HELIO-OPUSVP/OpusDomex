#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³OPUSVP              º Data ³  05/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este P.E. e' chamado apos a Gravacao da NF de Saida, e     º±±
±±º          ³ fora da transação                                          º±±
±±º          ³ Devido as notas de exporta;áo náo utilizarem               º±±
±±º          ³ os processo do siga eec foi necessario alimentar a         º±±
±±º          ³ cdl para transmitir as notas de exporta;áo                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//FILIALMG
User Function M460FIM()
	Local aArea   := GetArea()
	Local aAreaC5 := GetArea()
	Local aAreaD2 := GetArea()
//Local lExp    := .F.

/*
	If DtoS(Date()) == '20210901'  .and.  'JONAS.OPUS' $ Upper(GetEnvServer()) //.AND. xFilial("SF1") == '02'
		PARAMIXB := {}
		RpcSetEnv("01","01")
		AADD(PARAMIXB, 3)
		AADD(PARAMIXB, 1)
		SF2->( dbGoTo(122218) )

		nConfirma := 1
		nOpcao := 3
	EndIf
*/

/////////////
	SD2->(DBSETORDER(3))
	SD2->(DBSEEK(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))


	If (SF2->F2_CLIENTE=="700000" .AND. SF2->F2_LOJA=="01" .AND. fwfilial() == "01") .OR. (SF2->F2_CLIENTE=="001078" .AND. SF2->F2_LOJA=="01" .AND. fwfilial() == "02")
		U_AtuXD1(XFILIAL("SD2"),SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
	EndIf



/////////////
	sc5->(dbsetorder(1))
	sc5->(xfilial("SC5")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
/////////////

	Private _cCodEmb   := SC5->C5_LCEMB
	Private _cLocEmb   := Posicione("SY9",1,xFilial("SY9")+_cCodEmb,"Y9_CIDADE")
	Private _cUFemb    := Posicione("SY9",1,xFilial("SY9")+_cCodEmb,"Y9_ESTADO")

	U_GeraCDL(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

/*
	If SF2->F2_EST == 'EX'
	dbSelectArea("CDL")
	dbSetOrder(1)
	dbSeek(xFilial("CDL")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA)
		If !Found()
		RecLock("CDL",.T.)
		Replace CDL_FILIAL With xFilial("CDL")
		Replace CDL_DOC With SF2->F2_DOC
		Replace CDL_SERIE With SF2->F2_SERIE
		Replace CDL_ESPEC With "SPED"
		Replace CDL_CLIENT With SF2->F2_CLIENTE
		Replace CDL_LOJA With SF2->F2_LOJA
		Replace CDL_UFEMB With _cUFemb
		Replace CDL_LOCEMB With _cLocEmb
		MsUnlock()
		EndIf
	dbselectArea("CDL")
	dbskip()
	EndIf
*/

	RestArea(aAreaD2)
	RestArea(aAreaC5)
	RestArea(aArea)
Return



User Function GeraCDL(_Doc,_Serie,_Cliente,_Loja)

	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial()+_Doc+_Serie+_Cliente+_Loja))

		if SF2->F2_EST == "EX"

			cQuery := " SELECT D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_EMISSAO,D2_ITEM,D2_COD,C5_LCEMB,Y9_COD,Y9_CIDADE,Y9_ESTADO "
			cQuery += " FROM "+ RetSqlName("SD2")+" SD2 "
			cQuery += " LEFT JOIN "+ RetSqlName("SC5")+" ON D2_PEDIDO=C5_NUM "
			cQuery += " LEFT JOIN "+ RetSqlName("SY9")+" ON C5_LCEMB = Y9_COD "
			cQuery += " WHERE D2_DOC='"+_Doc+"' AND D2_SERIE= '"+_Serie+"' AND D2_CLIENTE = '"+_Cliente+"' AND D2_LOJA = '"+_Loja+"' "
			cQuery += " AND D2_EST = 'EX' AND SD2.D_E_L_E_T_ = '' "

			If Select("QUERYCDL") <> 0
				QUERYCDL->( dbCloseArea() )
			EndIf

			TCQUERY cQuery NEW ALIAS "QUERYCDL"

			While !QUERYCDL->( EOF() )

				dbSelectArea("CDL")
				dbSetOrder(2)
				if !dbSeek(xFilial("CDL")+QUERYCDL->D2_DOC+QUERYCDL->D2_SERIE+QUERYCDL->D2_CLIENTE+QUERYCDL->D2_LOJA+QUERYCDL->D2_ITEM)
					RecLock("CDL",.T.)
					CDL_FILIAL	:= xFilial("CDL")
					CDL_DOC		:= QUERYCDL->D2_DOC
					CDL_SERIE	:= QUERYCDL->D2_SERIE
					CDL_ESPEC	:= "SPED"
					CDL_CLIENT	:= QUERYCDL->D2_CLIENTE
					CDL_LOJA	:= QUERYCDL->D2_LOJA
					CDL_DTDE	:= STOD(QUERYCDL->D2_EMISSAO)
					CDL_DTREG	:= STOD(QUERYCDL->D2_EMISSAO)
					CDL_DTCHC	:= STOD(QUERYCDL->D2_EMISSAO)
					CDL_DTAVB	:= STOD(QUERYCDL->D2_EMISSAO)
					CDL_EMIEXP	:= STOD(QUERYCDL->D2_EMISSAO)
					CDL_UFEMB	:= QUERYCDL->Y9_ESTADO
					CDL_LOCEMB	:= QUERYCDL->Y9_CIDADE
					CDL_ITEMNF	:= QUERYCDL->D2_ITEM
					CDL_PRODNF	:= QUERYCDL->D2_COD
					CDL_ACDRAWF	:= "20180021117" //"20160037921"        // Ato Concessorio
					CDL_SDOCF	:= "001"

					MsUnlock()

				endif

				QUERYCDL->( dbSkip() )
			End

		endif

	Endif

Return

User Function AtuXD1(cFilNF, cDocNF, cSerieNF, cCliNF, cLojaNF)
	Local aArea := GetArea()
	Local aXD1Recno := {}

	If SD2->(dbSeek(cFilNF + cDocNF + cSerieNF + cCliNF + cLojaNF))
		While SD2->(!EOF()) .AND. SD2->D2_DOC==cDocNF .AND. SD2->D2_FILIAL==cFilNF .AND. SD2->D2_SERIE==cSerieNF .AND. SD2->D2_CLIENTE==cCliNF .AND. SD2->D2_LOJA==cLojaNF
			If SD2->D2_LOCAL == "95"
				XD1->(DBSETORDER(8))
				If XD1->(DbSeek(xFilial() + SD2->D2_COD + SD2->D2_LOCAL + "4" ))
					While XD1->(!Eof()) .AND. XD1->XD1_COD == SD2->D2_COD .AND. XD1->XD1_LOCAL == SD2->D2_LOCAL .AND. XD1->XD1_OCORRE == "4"

						aTemp := {XD1->(Recno()), SD2->(Recno()) }
						AADD(aXD1Recno,aTemp )

						XD1->(dbskip())
					EndDo
				EndIF
			EndIf
			SD2->(dbSkip())
		Enddo
	EndIf


	For x := 1 to Len(aXD1Recno)
		XD1->( dbGoTo(aXD1Recno[x,1]) )
		SD2->( dbGoTo(aXD1Recno[x,2]) )
		If XD1->( Recno() ) == aXD1Recno[x,1] .and. SD2->( Recno() ) == aXD1Recno[x,2] .AND. ALLTRIM(SUBSTR(XD1->XD1_LOTECTL,1,8)) == ALLTRIM(SD2->D2_LOTECTL)
			Reclock("XD1",.F.)
			XD1->XD1_FILORI  := XD1->XD1_FILIAL
			XD1->XD1_OCORRE  := "9"   // EM TRANSFERENCIA
			XD1->XD1_ZYNOTA  := SD2->D2_DOC
			XD1->XD1_ZYSERI  := SD2->D2_SERIE
			XD1->XD1_ZYDTNF  := SD2->D2_EMISSAO
			XD1->XD1_PVSEP   := SD2->D2_PEDIDO+''+SD2->D2_ITEMPV
			XD1->XD1_ZYSEQ   := SD2->D2_ITEM
			XD1->(MsUnlock())
		EndIf
	Next x

	


	RestArea(aArea)
Return
