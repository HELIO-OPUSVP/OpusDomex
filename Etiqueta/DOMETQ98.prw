#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMETQ98  ºAutor  ³Michel Sander       º Data ³  07/06/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de etiqueta pequena apenas com numeração		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//U_DOMETQ98(cNumOpBip,NIL     ,1       ,1       ,"1"    ,aUsoSerie,.T.      ,0         ,.F.      , ""       ,         ,       , cCodPnBar) //Layout 98 - Etiqueta Somente com CODBAR
User Function DOMETQ98(cNumOp   ,cNumSenf, nQtdEmb, nQtdEtq, cNivel, aFilhas , lImprime, _PesoAuto, lCtor, cNumSerie, cNumPeca, cSetor,cEtqHuawei,cVolumeAtu,cNumpedido)

	Local _cPorta   := "LPT2"
	Local cModelo   := "TLP 2844"  // "Z4M"
	Local aAreaGER  := GetArea()
	Local aAreaSB1  := SB1->( GetArea() )
	Local aAreaSC2  := SC2->( GetArea() )
	Local _nX		:= 0
	Local nQ 		:= 0
	//Local cLocImp	:= Iif(cfilant == "02","000024","LPT2")
	Local cLocImp	:= "LPT2"
	
	Default cNumPeca	:= ""
	Default cSetor   	:= ""
	Default cEtqHuawei 	:=""
	Default cVolumeAtu 	:= ""
	Default cNumpedido 	:= ""
	Default _PesoAuto   := 0


	IF ISINCALLSTACK('U_DOMACW46') .and. cfilant == "02
		cLocImp:= "000032"
	ENDIF	


	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )

	If SC2->( dbSeek( xFilial() + cNumOP ) )
		If SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
			For nQ := 1 to nQtdEtq
				//U_MsgColetor("Iprimindo etiquetinha na porta " + _cPorta + " modelo " + cModelo)
				If !U_Validacao()
					MSCBPrinter(cModelo,_cPorta,,,.F.)
					MSCBChkStatus(.F.)
					MSCBBegin(1,6)
				else
					If !CB5SetImp(cLocImp,.F.)
						MsgAlert("Local de impressao invalido!","Aviso")
						Return .F.
					else
						MSCBBegin(1,6)	
					EndIf
				EndIf
				//Controla o numero da etiqueta de embalagens
				If Empty(cNumPeca)
					_cProxPeca := U_IXD1PECA()
				Else
					_cProxPeca := cNumPeca
				EndIf

				For _nX := 1 to Len(aFilhas)
					Reclock("XD2",.T.)
					XD2->XD2_FILIAL := xFilial("XD2")
					XD2->XD2_XXPECA := _cProxPeca
					If ValType(aFilhas[_nX])  == "A"
						XD2->XD2_PCFILH := aFilhas[_nX][1]
					Else
						XD2->XD2_PCFILH := aFilhas[_nX]
					EndIf
					XD2->( msUnlock() )
				Next _nX

				Reclock("XD1",.T.)
				XD1->XD1_FILIAL  := xFilial("XD1")
				XD1->XD1_XXPECA  := _cProxPeca
				XD1->XD1_FORNEC  := Space(06)
				XD1->XD1_LOJA    := Space(02)
				XD1->XD1_DOC     := Space(06)
				XD1->XD1_SERIE   := Space(03)
				XD1->XD1_ITEM    := ""
				XD1->XD1_COD     := SB1->B1_COD
				XD1->XD1_LOCAL   := SC2->C2_LOCAL
				XD1->XD1_TIPO    := SB1->B1_TIPO
				XD1->XD1_LOTECT  := U_RetLotC6(cNumOP)
				XD1->XD1_DTDIGI  := dDataBase
				XD1->XD1_FORMUL  := ""
				XD1->XD1_LOCALI  := ""
				XD1->XD1_USERID  := __cUserId
				XD1->XD1_OCORRE  := "6"
				XD1->XD1_OP      := cNumOP
				XD1->XD1_PV      := cNumSenf
				XD1->XD1_QTDORI  := nQtdEmb //iif(Alltrim(cNivel)=="p",nQtdEtq,nQtdEmb)
				XD1->XD1_QTDATU  := nQtdEmb //iif(Alltrim(cNivel)=="p",nQtdEtq,nQtdEmb)
				aRetEmbala       := U_RetEmbala(XD1->XD1_COD,iif(Alltrim(cNivel)=="P","1",cNivel))
				XD1->XD1_EMBALA  := iif(Alltrim(cNivel)=="P","PALETE",aRetEmbala[1])
				XD1->XD1_QTDEMB  := iif(Alltrim(cNivel)=="P",Len(aFilhas),aRetEmbala[2])
				XD1->XD1_NIVEMB  := cNivel
				XD1->XD1_SERIAL  := cNumSerie
				XD1->XD1_ULTNIV  := IIF(Alltrim(cNivel)=="P","S","N")
				XD1->XD1_PVSEP   := cNumpedido
				XD1->XD1_PESOB   := _PesoAuto
				XD1->XD1_VOLUME  := cVolumeAtu


				If GetMV("MV_XVERHUA")
					//If Type("XD1_ETQHUA") <> "U"
					XD1->XD1_ETQHUA := cEtqHuawei
					//EndIf
				EndIf

				XD1->( MsUnlock() )

				// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
				If Type("cDomEtDl31_CancEtq") <> "U"
					cDomEtDl31_CancEtq := XD1->XD1_XXPECA
					cDomEtDl32_CancOP  := cNumOP
					cDomEtDl33_CancEmb := cNumSenf
					cDomEtDl34_CancKit := nQtdEmb
					cDomEtDl35_CancUni := nQtdEtq
					cDomEtDl38_CancNiv := cNivel
					aDomEtDl3A_CancFil := aFilhas
					cDomEtDl39_CancPes := _PesoAuto // nPesoVol    // Incluido _PesoAuto para evitar error.log:
				EndIf

				//Alert('cSetor '+ cSetor)
				//If !U_Validacao()
					If !Empty(cSetor)
						MSCBSAY(30,03,cSetor,"N","1","1,2")
					Else
						MSCBSAY(30,03,cSetor,"N","1","1,2")
					EndIf

					MSCBSayBar(30,10,AllTrim(XD1->XD1_XXPECA),"N","MB04",10,.F.,.T.,.F.,,3,Nil,Nil,Nil,Nil,Nil)
					MSCBEnd()
					
				//EndIf
				//U_MsgColetor("Impressão concluída")
			Next
		EndIf
	EndIf
	
	MSCBClosePrinter()
	RestArea(aAreaSC2)
	RestArea(aAreaSB1)
	RestArea(aAreaGER)

Return
