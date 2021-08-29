#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
//MAURICIO OPUS  //GERAÇÃO REGISTRO C120 DADOS ADICIONAIS IMPORTACAO
*---------------------------------------------------------------
User Function SPDIMP()       
*---------------------------------------------------------------
Local	cDoc		:=	PARAMIXB[1] //FT_NFISCAL
Local	cSerie	:=	PARAMIXB[2] //FT_SERIE
Local	cFornec	:=	PARAMIXB[3] //FT_CLIEFOR
Local	cLoja		:=	PARAMIXB[4] //FT_LOJA
Local	dEntr		:=	PARAMIXB[5] //FT_ENTRADA
Local	cChaveF1	:=	""
Local	cChaveFT	:=	""
Local	cChaveW6	:=	""
Local	cHAWB    := ""
Local	cNUMDI   := ""
Local	lTipoEx	:=	.F.
Local	aRetorno	:=	{}
Local	aAreaSFT	:=	SFT->(GetArea())
Local	aAreaSA2	:=	SA2->(GetArea())
Local	aAreaSF1	:=	SF1->(GetArea())

SF1->(DBSETORDER(1))
SW6->(DBSETORDER(1))
SFT->(DBSETORDER(2))

If SA2->(DbSeek(xFilial("SA2")+cFornec+cLoja))
	lTipoEx	:=	(SA2->A2_EST == "EX")
Endif

If lTipoEx
	cHAWB  :=''
	cNUMDI :=''
	cChaveF1 :=	xFilial("SF1")+cDoc+cSerie+cFornec+cLoja
	If SF1->(DbSeek(cChaveF1))
		cHAWB    :=SF1->F1_HAWB
		cChaveW6 :=xFilial("SW6")+cHAWB
		If SW6->(DbSeek(cChaveW6))
			cNUMDI := SW6->W6_DI_NUM
		ENDIF
	ENDIF
	
	IF EMPTY(cNUMDI)
		cNUMDI :='0000000001'
	ENDIF
	
	cChaveFT:=xFilial("SFT")+"E"+DTOS(dEntr)+cSerie+cDoc+cFornec+cLoja
	If SFT->(DbSeek(cChaveFT))
		While SFT->FT_FILIAL+SFT->FT_TIPOMOV+DTOS(SFT->FT_ENTRADA)+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cChaveFT
			aAdd(aRetorno,{ "1",;			//02 - COD_DOC_IMP
			cNUMDI,;		                  //03 - NUM_DOC_IMP
			SFT->FT_VALPIS,;		         //04 - PIS_IMP
			SFT->FT_VALCOF,;		         //05 - COF_IMP
			""})	                        //06 - NUM_ACDRAW
			SFT->(DbSkip())
		End
	Endif
Endif
RestArea(aAreaSFT)
RestArea(aAreaSA2)
RestArea(aAreaSF1)
Return aRetorno


