//----------------------------------------------------------------------------------------------------
// Ponto de entrada para tratamento de Produto Incentivado (PPB)
// Manutenção de desembaraço - Regime de tributação
// EICDI500
// Mauricio Lima de Souza - OpusVP
//----------------------------------------------------------------------------------------------------

User Function EICDI500()
//Local _aSaveArea	:= GetArea()
Local cParam := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))


Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

/*
IF(ExistBlock("EICDI500"),Execblock("EICDI500",.F.,.F.,"MANUT_W9_INC"),)
lDelInvoice := ExecBlock("IDI500INV",.F.,.F.,"PE_EXCLUSAO_INVOICE")
IF(ExistBlock("EICDI500"),Execblock("EICDI500",.F.,.F.,"MANUT_SW9"),)
IF(ExistBlock("EICDI500"),Execblock("EICDI500",.F.,.F.,"ANTES_DELETA_INV"),)

IF(ExistBlock("EICDI500"),Execblock("EICDI500",.F.,.F.,"DELETA_INVOICES"),)
WORK_SW9->(DBDELETE())
WORK_SW9->(DBGOTOP())
*/

If cParam =="MANUT_SW9" //"MANUT_W9_INC"
	if nTipoW9Manut==1   .and. !empty(M->W9_INVOICE)
		//------------------------------------------------------------------------------------------------
		_cINVOICE:=M->W9_INVOICE
		_cDTEMIS :=M->W9_DT_EMIS
		_cFORN   :=M->W9_FORN
		_cFORLOJ :=M->W9_FORLOJ
		_cNOMFOR :=M->W9_NOM_FOR
		_cCONDPA :=M->W9_COND_PA
		_cDIASPA :=str(M->W9_DIAS_PA,3,0)
		_cMOEFOB :=M->W9_MOE_FOB
		_cFobTot :=TRANSFORM(M->W9_FOB_TOT,"@E 999,999,999.99")
		_cCAMBIO :=" "
		_cNATUREZ:=POSICIONE('SA2',1,xFILIAL('SA2')+_cFORN+_cFORLOJ,"A2_NATUREZ")
		IF SED->(dbSeek(xFilial("SED")+_cNATUREZ))
			_cDNAT :=SED->ED_DESCRIC
		ELSE
			_cDNAT   :="Não Cadastrada SED"
		ENDIF
		SY6->(dbSeek(xFilial("SY6")+_cCONDPA+_cDIASPA))
		If SY6->Y6_TIPOCOB<>"4"
			_cCAMBIO :="COM Cobertura Cambial"
		ELSE
			_cCAMBIO :="SEM Cobertura Cambial"
		ENDIF
		
		_cData     := DtoC(Date())
		_cAssunto  := "Invoice Incluida "+_cINVOICE +"  - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
		_cTexto    := "Invoice Incluida "+_cINVOICE +"  - Data " + _cData + "    " +Time() + " User: " + Subs(cUsuario,7,14) +cEOL
		_cTexto    += "Emissao : "+dtoc(_cDTEMIS) + cEOL
		_cTexto    += "Fornecedor : "+_cFORN+"/"+_cFORN+ " " +_cNOMFOR + cEOL
		_cTexto    += "Natureza "+_cNATUREZ +" "+_cDNAT +cEOL
		_cTexto    += "Cond.Pag   : "+_cCONDPA+" Dias PA:"+_cDIASPA  +" "+_cCAMBIO +cEOL
		_cTexto    += "Moeda : "+_cMOEFOB+" "+_cFobTot+ cEOL
		
		_cPara  := 'adriana.ottoboni@rosenbergerdomex.com.br, '
		_cPara  += 'patricia.vieira@rdt.com.br, '
		_cPara  += 'tatiane.vieira@rosenbergerdomex.com.br, '
		_cPara  += 'lucio.cravo@rosenbergerdomex.com.br, '
		_cPara  += 'denis.vieira@rosenbergerdomex.com.br,mauricio.souza@opusvp.com.br '
		_cCC       := ""
		_cArquivo  := ""
		
		U_EnvMailto(_cAssunto,_cTexto,_cPara,_cCC,_cArquivo)
		//------------------------------------------------------------------------------------------------
	endif
ENDIF


If cParam == "DELETA_INVOICES"
	
	//------------------------------------------------------------------------------------------------
	_cINVOICE:=Work_SW9->W9_INVOICE
	_cDTEMIS :=Work_SW9->W9_DT_EMIS
	_cFORN   :=Work_SW9->W9_FORN
	_cFORLOJ :=Work_SW9->W9_FORLOJ
	_cNOMFOR :=Work_SW9->W9_NOM_FOR
	_cCONDPA :=Work_SW9->W9_COND_PA
	_cDIASPA :=str(Work_SW9->W9_DIAS_PA,3,0)
	_cMOEFOB :=Work_SW9->W9_MOE_FOB
	_cFobTot :=TRANSFORM(Work_SW9->W9_FOB_TOT,"@E 999,999,999.99")
	_cCAMBIO :=" "
	_cNATUREZ:=POSICIONE('SA2',1,xFILIAL('SA2')+_cFORN+_cFORLOJ,"A2_NATUREZ")
	IF SED->(dbSeek(xFilial("SED")+_cNATUREZ))
		_cDNAT :=SED->ED_DESCRIC
	ELSE
		_cDNAT   :="Não Cadastrada SED"
	ENDIF
	SY6->(dbSeek(xFilial("SY6")+_cCONDPA+_cDIASPA))
	If SY6->Y6_TIPOCOB<>"4"
		_cCAMBIO :="COM Cobertura Cambial"
	ELSE
		_cCAMBIO :="SEM Cobertura Cambial"
	ENDIF
	
	_cData     := DtoC(Date())
	_cAssunto  := "Invoice Deletada "+_cINVOICE +"  - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	_cTexto    := "Invoice Deletada "+_cINVOICE +"  - Data " + _cData + "    " +Time() + " User: " + Subs(cUsuario,7,14) + cEOL
	_cTexto    += "Emissao : "+dtoc(_cDTEMIS) + cEOL
	_cTexto    += "Fornecedor : "+_cFORN+"/"+_cFORN+ " " +_cNOMFOR + cEOL
	_cTexto    += "Natureza "+_cNATUREZ +" "+_cDNAT  + cEOL
	_cTexto    += "Cond.Pag   : "+_cCONDPA+" Dias PA:"+_cDIASPA  +" "+_cCAMBIO + cEOL
	_cTexto    += "Moeda : "+_cMOEFOB+" "+_cFobTot+ cEOL
	
	_cPara  := 'adriana.ottoboni@rosenbergerdomex.com.br, '
	_cPara  += 'patricia.vieira@rdt.com.br, '
	_cPara  += 'tatiane.vieira@rosenbergerdomex.com.br, '
	_cPara  += 'lucio.cravo@rosenbergerdomex.com.br, '
	_cPara  += 'denis.vieira@rosenbergerdomex.com.br,mauricio.souza@opusvp.com.br '
	_cCC       := ""
	_cArquivo  := ""
	
	U_EnvMailto(_cAssunto,_cTexto,_cPara,_cCC,_cArquivo)
	//------------------------------------------------------------------------------------------------
	
ENDIF
/*

//Local _aSaveArea	:= GetArea()
Local cParam      := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))

If cParam == "INICIO_DI500MANUT"
AADD(aCorrespW8,{"W8_XXINPPB"  ,"WKPPB"   }) //PPB
endif


If cParam =="INV_CARREGA_SW8"
cXXINPPB :=POSICIONE('SB1',1,xFILIAL('SB1')+ALLTRIM(Work_SW8->WKCOD_I),'B1_XXINPPB')
Work_SW8->W8_XXINPPB :=cXXINPPB//SB1->B1_XXINPPB
ENDIF

If cParam =="ANT_VALID_EIJ"
_aSaveArea	:= GetArea()

IF M->EIJ_REGIPI$('5') //INCENTIVADO
Work_SW8->(DBGOTOP())
DO WHILE !Work_SW8->(EOF())
cXXINPPB :=POSICIONE('SB1',1,xFILIAL('SB1')+ALLTRIM(Work_SW8->WKCOD_I),'B1_XXINPPB')   //PPB
IF cXXINPPB <>'S'  .and. !EMPTY(Work_SW8->WKFLAGDSI)                                   // FLAG SELEÇÃO ITEM
MSGALERT('PRODUTO: '+ALLTRIM(Work_SW8->WKCOD_I)+' N A O  INCENTIVADO (PPB)')
lRet:=.F.
ENDIF
Work_SW8->(DBSKIP())
ENDDO
ENDIF

IF M->EIJ_REGIPI$('4') //INTEGRAL
Work_SW8->(DBGOTOP())
DO WHILE !Work_SW8->(EOF())
cXXINPPB :=POSICIONE('SB1',1,xFILIAL('SB1')+ALLTRIM(Work_SW8->WKCOD_I),'B1_XXINPPB')
IF cXXINPPB =='S'  .and. !EMPTY(Work_SW8->WKFLAGDSI)
MSGALERT('PRODUTO: '+ALLTRIM(Work_SW8->WKCOD_I)+'   I N C E N T I V A D O  (PPB)')
lRet:=.F.
ENDIF
Work_SW8->(DBSKIP())
ENDDO
ENDIF

RestArea(_aSaveArea)
ENDIF
*/

//RestArea(_aSaveArea)
Return Nil
