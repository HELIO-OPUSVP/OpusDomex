#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"


user  Function TMPTRANS()

Local _nTamEtiq   :=Len(CriaVar("XD1_XXPECA",.F.))
Local _nOpcAuto   := 3

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private _aEndereco  := {}
Private _aItem      := {}
Private _cDoc       := ''
Private lTRANSF     :=.F.
Private _aAuto      :={}
*********************************************************************************
PRIVATE cCusMed := GetMv("MV_CUSMED")
PRIVATE cCadastro:= OemToAnsi("Transfer^ncias")     //"Transfer^ncias"
PRIVATE aRegSD3 := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
	PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
	PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
	PRIVATE cLoteEst      // Numero do lote para lancamentos do estoque
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	PRIVATE nTotal := 0      // Total dos lancamentos contabeis
	PRIVATE cArquivo     // Nome do arquivo contra prova
EndIf
*********************************************************************************  

cQUERY1 :=" DROP TABLE BFEXP "

cQUERY2 :=" SELECT B2_QATU,SUM(BF_QUANT) BF_QUANT,B2_LOCAL,B2_COD,BF_LOTECTL,BF_LOCALIZ,'13EXPEDICAO' AS BF_LOCALIZ2 "
cQUERY2 +=" INTO BFEXP "
cQUERY2 +=" FROM SBF010 BF WITH(NOLOCK),SB2010 B2 WITH(NOLOCK) "
cQUERY2 +=" WHERE  B2_COD=BF_PRODUTO AND B2_LOCAL=BF_LOCAL "
cQUERY2 +=" AND BF_LOTECTL='LOTE1308' AND BF_LOCALIZ='13PRODUCAO'  "
cQUERY2 +=" AND BF.D_E_L_E_T_='' "
cQUERY2 +=" AND B2.D_E_L_E_T_='' "
cQUERY2 +=" AND BF_QUANT<>0  AND BF_LOCAL='13' "
cQUERY2 +=" GROUP BY B2_QATU,B2_LOCAL,B2_COD,BF_LOCALIZ,BF_LOTECTL "
cQUERY2 +=" ORDER BY B2_COD "

TCSQLEXEC(cQUERY1)
TCSQLEXEC(cQUERY2)

cQuery := " SELECT * FROM BFEXP  WHERE B2_QATU=BF_QUANT  "
//B2_QATU                BF_QUANT               B2_LOCAL B2_COD          BF_LOTECTL BF_LOCALIZ      BF_LOCALIZ2


TcQuery cQuery Alias "TMP" New

dbSelectArea("TMP")
dbGotop()

Do While !TMP->(EOF())
	
	_aAuto      :={}
	_aItem      :={}
	
	
	CriaSB2(TMP->B2_COD,'13')
	
	_cDoc:= U_NEXTDOC()
	_cDoc:=_cDoc+SPACE(09)
	_cDoc:=SUBSTR(_cDoc,1,9)
	
	DbSelectArea("SB1")
	dbSetOrder(1)
	
	DbSelectArea("SD3")
	dbSetOrder(2)
	
	
	***********************************************************************************************************************
	//B2_QATU                BF_QUANT               B2_LOCAL B2_COD          BF_LOTECTL BF_LOCALIZ      BF_LOCALIZ2
	cCodOrig   := TMP->B2_COD
	cLocOrig   := '13'
	nQuant260  := TMP->BF_QUANT
	cDocto     := _cDoc
	dEmis260   := DDATABASE
	nQuant260D := 0
	cNumLote   := ''
	cLoteDigi  := TMP->BF_LOTECTL
	dDtValid   := CtoD("31/12/49")
	cNumSerie  := ''
	cLoclzOrig := PADR('13PRODUCAO',15)
	cCodDest   := TMP->B2_COD
	cLocDest   := '13'
	cLocLzDest := PADR('13EXPEDICAO',15)
	cServico   := ''
	nPotencia  := 0
	cLoteDigiD := TMP->BF_LOTECTL
	dDtVldDesT := CtoD("31/12/49")
	If a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,NIL,cLoteDigi,dDtValid,NIL,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,.F.,Nil,Nil,"MATA260",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,cLoteDigiD,NIL,nil,nil,.T.)
		lTRANSF:=.T.
	ELSE
		U_MsgColetor("Erro na transferencia"+TMP->B2_COD)
	ENDIF
	***********************************************************************************************************************
	TMP->(DBSKIP())
EndDo

MSGALERT('FIM')

Return
