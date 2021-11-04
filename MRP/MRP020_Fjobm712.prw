//-------------------------------------------------------------------------------------------------------------------------------------------------// 
//Mauricio Lima de Souza - 11/11/18 - OpusVp                                                                                                             //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                        //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Gera��o tabela temporaria MRP2  (Tabela ZHC010)                                                                                           //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"

/*
[01] - Processamento do MRP ?        	Tipo N
[02] - Geracao de SCs ?              	Tipo N
[03] - Geracao de OPs Prod. Interme ?	Tipo N
[04] - Selecao para Geracao OPs/SCs ?	Tipo N
[05] - Data Inicial PMP / Prev. Ven ?	Tipo D
[06] - Data Final PMP / Prev. Ven ?  	Tipo D
[07] - Incrementa Numeracao de OPs ? 	Tipo N
[08] - De Armazem ?                  	Tipo C
[09] - Ate Armazem ?                 	Tipo C
[10] - Tipo de OPs/SCs para geracao ?	Tipo N
[11] - Apaga OPs/SCs Previstas ?     	Tipo N
[12] - Considera Sabados e Domingos ?	Tipo N
[13] - Considera OPs Suspensas ?     	Tipo N
[14] - Considera OPs Sacramentadas ? 	Tipo N
[15] - Recal. Niveis das Estruturas ?	Tipo N
[16] - Gera OPs Aglutinadas ?        	Tipo N
[17] - Pedidos de Venda colocados ?  	Tipo N
[18] - Considera Saldo em Estoque ?  	Tipo N
[19] - Ao atingir Estoque Maximo ?   	Tipo N
[20] - Qtd. nossa Poder Terc. ?      	Tipo N
[21] - Qtd. Terc. em nosso Poder ?   	Tipo N
[22] - Saldo rejeitado pelo CQ ?     	Tipo N
[23] - De  Documento PV/PMP ?        	Tipo C
[24] - Ate Documento PV/PMP ?        	Tipo C
[25] - Saldo bloqueado por lote ?    	Tipo N
[26] - Considera Est. Seguranca ?    	Tipo N
[27] - Ped. de Venda Bloq. Credito ? 	Tipo N
[28] - Mostra dados resumidos ?      	Tipo N
[29] - Detalha lotes vencidos ?      	Tipo N
[30] - Pedidos de Venda faturados ?  	Tipo N
[31] - Considera Ponto de Pedido ?   	Tipo N
[32] - Gera tabela necessidades ?    	Tipo N
[33] - Data inicial Ped Faturados ?  	Tipo D
[34] - Data final Ped Faturados ?    	Tipo D
[35] - Exibe resultado do calculo ?  	Tipo N
exemplo:
alterar o parametro se considera estoque de seguran�a .
aPerg[26] := 2 //1=Sim,2=Nao
*/

User Function Fjobm712()
	PRIVATE lCZI    :=.F.
	PRIVATE lCZJ    :=.F.
	PRIVATE lCZK    :=.F.
	PRIVATE lMRPSI  :=.F.
	PRIVATE lMRFl2  :=.T. 

	PRIVATE _cCODMRP:=''

	U_MRPDELFF() // DROP TABLE CZI010, CZJ010, CZK010

	aemp := {"01","02"} 
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" USER 'MRP' PASSWORD 'MRP' Tables "SB1","SB2","SC1","SC2","SC3","SC4","SC5","SC6","SC7","SBM","SHF","CZI","CZJ","CZK","CV8","CT2","SBM","CT5","ZZ7"  Modulo "PCP"

	MATA712( .T.,{1,730,.T.,;
		{{.T.,'AT'},{.T.,'BN'},{.T.,'FP'},{.T.,'GG'},{.T.,'MA'},{.T.,'MC'},{.T.,'MD'},{.T.,'ME'},{.T.,'MO'},{.T.,'MP'},{.T.,'MS'},{.T.,'PA'},{.T.,'PI'},{.T.,'PR'},{.T.,'SI'},{.T.,'SV'}},;
		{{.T.,'    '},{.T.,'0   '},{.T.,'0001'},{.T.,'0002'},{.T.,'0003'},{.T.,'0004'},{.T.,'0005'},{.T.,'0006'},{.T.,'ABRC'},{.T.,'ADES'},{.T.,'ADOP'},{.T.,'ANTE'},{.T.,'ATOP'},{.T.,'AUTO'},;
		{.T.,'BAST'},{.T.,'BRID'},{.T.,'CALI'},{.T.,'CBCX'},{.T.,'CCOX'},{.T.,'CE  '},{.T.,'COM '},{.T.,'CON '},{.T.,'CORD'},{.T.,'CXEM'},{.T.,'DIO '},{.T.,'DIOE'},{.T.,'DIV '},{.T.,'DROP'},;
		{.T.,'EBPA'},{.T.,'EBPL'},{.T.,'EPTR'},{.T.,'ESTP'},{.T.,'ETQE'},{.T.,'FERG'},{.T.,'FERR'},{.T.,'FLEX'},{.T.,'FO  '},{.T.,'FOFS'},{.T.,'FTTA'},{.T.,'INFO'},{.T.,'JUMP'},{.T.,'LIXA'},;
		{.T.,'MAGC'},{.T.,'MAIN'},{.T.,'MAOP'},{.T.,'MASE'},{.T.,'MC  '},{.T.,'ME  '},{.T.,'MESC'},{.T.,'MFTX'},{.T.,'MKT '},{.T.,'MLIP'},{.T.,'MMAQ'},{.T.,'MMV '},{.T.,'MPS '},{.T.,'OBRA'},;
		{.T.,'PARF'},{.T.,'PCJO'},{.T.,'PCLH'},{.T.,'PCMP'},{.T.,'PCOP'},{.T.,'PV  '},{.T.,'REOP'},{.T.,'RF  '},{.T.,'RT  '},{.T.,'SEMI'},{.T.,'SENS'},{.T.,'TRSU'},{.T.,'TRUE'},{.T.,'TRUN'},;
		{.T.,'TUBO'},{.T.,'USIN'},{.T.,'UTP '},{.T.,'WRL '}},.F.,.F.,1800})

	U_MRP020F()

	RESET ENVIRONMENT

RETURN Nil

	*----------------------------------------------------------------------------------------------------*
USER FUNCTION MRP02INF()
	*----------------------------------------------------------------------------------------------------*
	PRIVATE nMRPS:=0

	_cCODMRP:=''

	cQUERYCD :="SELECT MAX(ZZ7_COD) AS MXCOD FROM ZZ7010 WHERE D_E_L_E_T_='' "
	TcQuery cQUERYCD Alias "TRCD" New
	If TRCD->(Eof())
		_cCODMRP:='000000'
	ELSE
		_cCODMRP:=StrZero((VAL(TRCD->MXCOD)+1),6)
	ENDIF

	TRCD->(DbCloseArea())

	//MLS ZZ7 INI

	ZZ7->(dbSelectArea("ZZ7"))
	ZZ7->(DBSETORDER(1))
	Reclock("ZZ7",.T.)
	ZZ7->ZZ7_FILIAL	:= xFilial("ZZ7")
	ZZ7->ZZ7_TIPO	:="2"
	ZZ7->ZZ7_COD   	:=_cCODMRP
	ZZ7->ZZ7_NRMRP := ""
	ZZ7->ZZ7_DTINI	:=DATE()
	//ZZ7->ZZ7_DTFIM  :=""
	ZZ7->ZZ7_HRINI	:=TIME()
	//ZZ7->ZZ7_HRFIM	:=""
	ZZ7->ZZ7_HIST   :="INICIO FILIAL 02"
	ZZ7->( msUnlock() )

//SC1 SALDO
//------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2  INICIO - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2  INICIO - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br;paulo.celestino@rdt.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

//------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2 Filial 02 Saldo SC - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2 Filial 02 Saldo SC- Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------
	cSQL := " UPDATE SC1010 SET C1_QUJE= "
	cSQL += " (SELECT SUM(C7_QUANT)  "
	cSQL += "   FROM SC7010 WITH(NOLOCK)  "
	cSQL += "   WHERE C7_NUMSC=C1_NUM  "
	cSQL += "         AND C7_ITEMSC=C1_ITEM  "
	cSQL += "         AND C7_PRODUTO=C1_PRODUTO  "
	cSQL += "         AND D_E_L_E_T_<>'*' AND C7_FILIAL = '"+xFilial('SC7')+"' "
	cSQL += "         GROUP BY C7_NUMSC,C7_ITEMSC) "
	cSQL += " WHERE D_E_L_E_T_='' AND C1_FILIAL='"+xFILIAL('SC1')+"' "
	cSQL += " AND   C1_QUANT>C1_QUJE "
	cSQL += " AND   C1_RESIDUO='' AND C1_FILIAL = '01' "
	cSQL += " AND C1_NUM+C1_ITEM+C1_PRODUTO IN  "
	cSQL += " (SELECT C7_NUMSC+C7_ITEMSC+C7_PRODUTO FROM SC7010 WITH(NOLOCK) WHERE D_E_L_E_T_='' AND C7_RESIDUO='' AND C7_FILIAL = '"+xFilial('SC7')+"' ) "
	TCSQLEXEC(cSQL)

	cData     := DtoC(Date())
	cAssunto  := "MRP V2 Filial 02 Explode SC4 Prev.Venda - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2 Filial 02 Explode SC4 Prev.Venda - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	U_ExplSC4()
	*-----------------------------------------------------------
//************************************************************************************************************************************
//* Apagando todos os registros da SHF. Tivemos problemas de cria��o de milh�es de registros nela sem sabermos exatamente para que.  *
//************************************************************************************************************************************


//�������������������������������������������u
//�Selecionando registros para compor   o MRP�
//�������������������������������������������u

	cData     := DtoC(Date())
	cAssunto  := "MRP V2 Filial 02 Campo B1_MRP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2 Filial 02 Campo B1_MRP - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	TCSQLEXEC("UPDATE SC4010 SET C4_QUANT = 0 WHERE C4_FILIAL='"+xFilial('SC4')+"' AND  C4_DATA <'"+DTOS(FIRSTDAY(DDATABASE))+"' AND  D_E_L_E_T_ = '' ")

	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N'")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010, SC7010 WHERE C7_FILIAL='"+xFILIAL('SC7')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND  C7_RESIDUO = '' AND C7_QUJE < C7_QUANT AND C7_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC7010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC1010, SB1010 WHERE C1_FILIAL='"+xFILIAL('SC1')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND  C1_QUJE < C1_QUANT AND C1_RESIDUO = '' AND C1_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC1010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SD4010, SB1010 WHERE D4_FILIAL='"+xFILIAL('SD4')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND D4_QUANT <> 0 AND D4_COD = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SD4010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC2010, SB1010 WHERE C2_FILIAL='"+xFILIAL('SC2')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND C2_QUANT > C2_QUJE AND C2_DATRF = '' AND C2_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC2010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC4010, SB1010 WHERE C4_FILIAL='"+xFILIAL('SC4')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND C4_QUANT <> 0 AND C4_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC4010.D_E_L_E_T_ = '' ")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SC6010, SB1010 WHERE C6_FILIAL='"+xFILIAL('SC6')+"' AND B1_FILIAL='"+xFILIAL('SB1')+"' AND C6_QTDENT < C6_QTDVEN AND C6_PRODUTO = B1_COD AND B1_MRP <> 'S' AND SB1010.D_E_L_E_T_ = '' AND SC6010.D_E_L_E_T_ = '' ")

	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' FROM SB1010  WHERE B1_FILIAL='"+xFILIAL('SB1')+"'  AND B1_ALTER IN (SELECT B1_COD FROM SB1010 (NOLOCK) WHERE B1_MRP = 'S' AND B1_FILIAL ='"+xFILIAL('SB1')+"' ) AND B1_MRP = 'N' AND D_E_L_E_T_ = ''")
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'S' WHERE  B1_FILIAL='"+xFILIAL('SB1')+"'  AND B1_COD  IN (SELECT GI_PRODALT FROM SGI010 (NOLOCK) WHERE D_E_L_E_T_='' AND GI_FILIAL ='"+xFILIAL('SGI')+"'  )" )

	cQueryMRPS := " UPDATE SB1010 SET B1_MRP='S'  "
	cQueryMRPS += " WHERE B1_FILIAL='"+xFILIAL('SB1')+"'  AND B1_COD IN "
	cQueryMRPS += " (SELECT G1_COMP "
	cQueryMRPS += " FROM SG1010 (NOLOCK) "
	cQueryMRPS += " WHERE G1_FILIAL='"+xFILIAL('SG1')+"'  AND D_E_L_E_T_='' AND  G1_COD IN  "
	cQueryMRPS += " (select B1_COD from SB1010 (NOLOCK) where B1_FILIAL='"+xFILIAL('SB1')+"'  AND B1_MRP='S' AND D_E_L_E_T_='')GROUP BY G1_COMP) "
	cQueryMRPS += " AND D_E_L_E_T_='' "
	cQueryMRPS += " AND B1_MRP<>'S' "

	nMRPS := 0
	For nMRPS := 1 TO  10
		TCSQLEXEC(cQueryMRPS)
		Sleep( 2000 )   // Para o processamento por 2 segundo
	NEXT

	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_FILIAL='"+xFILIAL('SB1')+"'  AND B1_TIPO IN ('SI','AT' ) AND  B1_MRP = 'S' AND D_E_L_E_T_='' " )
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_FILIAL='"+xFILIAL('SB1')+"'  AND B1_LOCPAD='03'          AND  B1_MRP = 'S' AND D_E_L_E_T_='' " )
	TCSQLEXEC("UPDATE SB1010 SET B1_MRP = 'N' WHERE B1_FILIAL='"+xFILIAL('SB1')+"'  AND B1_TIPO='GG'            AND  B1_MRP = 'S' AND D_E_L_E_T_='' " )

//MSGALERT('FIM INICIALIZACAO MRP')

	//If Subs(cUsuario,7,5) == "HELIO"
	//	NMODULO = 10
	//	MATA712()
	//	U_MRP020()
	//EndIf

RETURN


	*----------------------------------------------------------------------------------------------------*
USER FUNCTION  MRP020F()    //GERACAO CUBO MRP
	*----------------------------------------------------------------------------------------------------*
	U_MRP020FB()
RETURN

	*----------------------------------------------------------------------------------------------------*
USER FUNCTION  MRP020FB()    //GERACAO CUBO MRP
	*----------------------------------------------------------------------------------------------------*

	Local   cQuery    := ""
	Local   cAlias    :="TRB"
	LOCAL   nPERIODO  :=0
	LOCAL   nX        :=0
	LOCAL   nZ        :=0

	PRIVATE nLTIME    :=0  //LEAD TIME
	PRIVATE nLOTEE    :=0  //LOTE ECONOMICO

	PRIVATE _SC4COD:= ''
	PRIVATE _SC4REC:= 0

	PRIVATE _cTXTSC4:=SPACE(20)
	PRIVATE _cSC4COD:=SPACE(06)

//------------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2 Filial 02 Inicio Cubo MRP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2 Filial 02 Inicio Cubo MRP - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br;paulo.celestino@rdt.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------------


	cQUERY1:=" DELETE FROM ZHC010  "
	TCSQLEXEC(cQUERY1)

	cQuery := " SELECT  "
	cQuery += " '  '        ZHC_FILIAL, "
	cQuery += " CZK_PERMRP  ZHC_PERIOD, "
	cQuery += " CZI_PERMRP, "
	cQuery += " CZK_NRMRP   ZHC_NUMMRP, "
	cQuery += " CZJ_NRLV    ZHC_NIVEL, "
	cQuery += " CZJ_PROD    ZHC_PRODUT, "
	cQuery += " CZJ_OPCORD  , "
	cQuery += " CZI_ALIAS, "
	cQuery += "  CASE  CZI_ALIAS "

	cQuery += "       WHEN 'SB1' THEN '00-Seguranca'       "
	cQuery += "       WHEN 'SB2' THEN '00-Saldo Negativo'  "
	cQuery += "       WHEN 'SC1' THEN '03-Sol.Compras'     "
	cQuery += "       WHEN 'SC7' THEN '04-Pedido Compra'   "
	cQuery += "       WHEN 'SD4' THEN '05-Empenho'         "
	cQuery += "       WHEN 'SC2' THEN '06-Ordem Producao'  "
	cQuery += "       WHEN 'SC6' THEN '07-Pedido Venda'    "
	cQuery += "       WHEN 'CZJ' THEN '08-Saida Estrutura' "
	cQuery += "       WHEN 'ENG' THEN '08-Saida Estrutura' "
	cQuery += "       WHEN 'SC4' THEN '09-Previsao Venda'  "

	cQuery += " 	  ELSE "
	cQuery += " 	    CZI_ALIAS "
	cQuery += "  END "
	cQuery += " 		AS  ZHC_TIPO, "
	cQuery += " CZI_DOC      AS ZHC_TEXTO, "
	cQuery += " CZI_TPRG, "
	cQuery += " CZI_DOCKEY, "
	cQuery += " CZI_DTOG,   "
	cQuery += " CZI_QUANT,  "
	cQuery += " B1_DESC       AS ZHC_DESC  , "
	cQuery += " B1_TIPO       AS ZHC_TIPOP , "
	cQuery += " B1_GRUPO      AS ZHC_GRUPO , "
	cQuery += " CZK_QTSLES,                  "
	cQuery += " CZK_QTENTR,                  "
	cQuery += " CZK_QTSAID,                  "
	cQuery += " CZK_QTSEST,                  "
	cQuery += " CZK_QTSALD,                  "
	cQuery += " CZK_QTNECE,                  "
	cQuery += " '          '  AS ZHC_TXDT1,  "
	cQuery += " '          '  AS ZHC_TXDT2,  "
	cQuery += " '          '  AS ZHC_IDMRP,  "
	cQuery += " '          '  AS ZHC_NUMSC,  "
	cQuery += " '          '  AS ZHC_HISTSC, "
	cQuery += " 0             AS ZHC_QTDSC,  "
	cQuery += " '          '  AS ZHC_DATASC, "
	cQuery += " '          '  AS ZHC_STATUS, "
	cQuery += " '      '      AS ZHC_FORN,   "
	cQuery += " '  '          AS ZHC_LOJA,   "
	cQuery += " 0             AS ZHC_UPRC,   "
	cQuery += " '          '  AS ZHC_NFORN,  "
	cQuery += "  CASE  CZI_ALIAS "
	cQuery += "  WHEN 'SC4' THEN  CZI_PROD  "
	cQuery += "  ELSE '               ' "
	cQuery += "  END "
	cQuery += "  AS  ZHC_SC4COD, "
	cQuery += "  CASE  CZI_ALIAS "
	cQuery += "  WHEN 'SC4' THEN  CZI_NRRGAL  "
	cQuery += "  ELSE 0 "
	cQuery += "  END "
	cQuery += "  AS  ZHC_SC4REC "
	cQuery += "  FROM CZK010 CZK WITH(NOLOCK),CZJ010 CZJ WITH(NOLOCK)  , CZI010 CZI WITH(NOLOCK), SB1010 SB1 WITH(NOLOCK) "
	cQuery += " WHERE "
	cQuery += "     CZK_RGCZJ= CZJ.R_E_C_N_O_  "
	cQuery += " AND B1_COD=CZJ_PROD and B1_TIPO NOT IN('PA','PI','MO')  AND SB1.D_E_L_E_T_='' "
	cQuery += " AND CZI_PROD=CZJ_PROD AND CZI_PERMRP=CZK_PERMRP AND CZJ_NRLV=CZI_NRLV         "
	cQuery += " AND CZK.CZK_FILIAL='"+xFILIAL('CZK')+"' "
	cQuery += " AND CZI.CZI_FILIAL='"+xFILIAL('CZI')+"' "
	cQuery += " AND CZJ.CZJ_FILIAL='"+xFILIAL('CZJ')+"' "
	cQuery += " AND SB1.B1_FILIAL ='"+xFILIAL('SB1')+"' "
	cQuery += " order by CZI.CZI_PERMRP,CZJ.CZJ_PROD,CZI.CZI_TPRG " 

	TcQuery cQuery Alias "TRB" New

	TRB->(DbGoTop())

	If TRB->(Eof())
		//	Alert("Nao foi encontrado nenhum item neste Processo !")
		DbSelectArea("TRB")
		TRB->(DbCloseArea())
		Return()
	EndIf

	ZHC->(DBSELECTAREA('ZHC'))
	ZHC->(DBSETORDER(2))

	cIDMRP :=TRB->ZHC_NUMMRP+'000'// INICIALIZADOR IDMRP


	//ZZ7 NUM MRP TRB->ZHC_NUMMRP

	ZZ7->(dbSelectArea("ZZ7"))
	ZZ7->(DBSETORDER(1))
	ZZ7->(DbSeek(xFilial("ZZ7")+_cCODMRP))
	IF ZZ7->(FOUND())
		Reclock("ZZ7",.F.)
		ZZ7->ZZ7_NRMRP  :=TRB->ZHC_NUMMRP
		ZZ7->ZZ7_HIST    :="CUBO FILIAL 02"
		ZZ7->(MsUnlock())
	ENDIF

	DO WHILE .NOT. TRB->(EOF())
		dPERIOD := STOD(TRB->CZI_DTOG)
		cNUMMRP := TRB->ZHC_NUMMRP
		cPRODUT := TRB->ZHC_PRODUT
		cPERMRP := TRB->CZI_PERMRP
		cQuery   += " order by CZI.CZI_PERMRP,CZJ.CZJ_PROD "
		//DO WHILE .NOT. TRB->(EOF()).AND. TRB->ZHC_FILIAL == xFILIAL('ZHC') .AND. STOD(TRB->CZI_DTOG) == dPERIOD .AND. TRB->ZHC_NUMMRP == cNUMMRP .AND. TRB->ZHC_PRODUT == cPRODUT
		DO WHILE .NOT. TRB->(EOF()).AND. TRB->ZHC_FILIAL == xFILIAL('ZHC') .AND. TRB->CZI_PERMRP == cPERMRP .AND. TRB->ZHC_PRODUT == cPRODUT
			RecLock("ZHC",.T.)
			ZHC->ZHC_FILIAL := xFILIAL('ZHC')
			ZHC->ZHC_PERIOD := dPERIOD
			ZHC->ZHC_NUMMRP := TRB->ZHC_NUMMRP
			ZHC->ZHC_PRODUT := TRB->ZHC_PRODUT
			ZHC->ZHC_DESC   := TRB->ZHC_DESC
			ZHC->ZHC_TIPO   := TRB->ZHC_TIPO
			ZHC->ZHC_TIPOP  := TRB->ZHC_TIPOP
			ZHC->ZHC_GRUPO  := TRB->ZHC_GRUPO
			ZHC->ZHC_NIVEL  := TRB->ZHC_NIVEL
			//ZHC->ZHC_REVISA := TRB->ZHC_REVISA
			//ZHC->ZHC_REVSHW := TRB->ZHC_REVSHW
			IF ALLTRIM(TRB->ZHC_TIPO)=='09-Previsao Venda'
				MRP02SC4(TRB->ZHC_SC4REC)
				ZHC->ZHC_TEXTO  := _cTXTSC4
				ZHC->ZHC_SC4COD := _cSC4COD
			ELSE
				ZHC->ZHC_TEXTO  := TRB->ZHC_TEXTO
			ENDIF
			ZHC->ZHC_TXDT1  := DTOC(dPERIOD)
			ZHC->ZHC_TXDT2  := dPERIOD
			ZHC->ZHC_XQTDE  := TRB->CZI_QUANT
			ZHC->ZHC_SC4REC := TRB->ZHC_SC4REC
			DO CASE
			CASE SUBSTR(TRB->ZHC_TIPO,1,2) $('05|07|09|00')  //05-Empenho   07-Pedido Venda    09-Previsao Venda 00-Seguranca
				ZHC->ZHC_SAIDA:=TRB->CZI_QUANT
			CASE SUBSTR(TRB->ZHC_TIPO,1,2) =='08'            //08-Saida Estrutura
				ZHC->ZHC_SESTR:=TRB->CZI_QUANT
			CASE SUBSTR(TRB->ZHC_TIPO,1,2) $('03|04|06')     //03-Sol.Compras //04-Pedido Compra   06-Ordem Producao
				ZHC->ZHC_ENTRAD:=TRB->CZI_QUANT
			ENDCASE

			nSLDINI  :=TRB->CZK_QTSLES    //SALDO INICIAL    02-Saldo Estoque
			//CZK_QTENTR                  //ENTRADA
			//CZK_QTSAID                  //SAIDA
			//CZK_QTSEST                  //SAIDA ESTRUTURA
			nSLDFIN  :=TRB->CZK_QTSALD    //SALDO FINAL      10-Saldo Final
			nNECE    :=TRB->CZK_QTNECE    //NECESSIDADE      01-Necessidade

			cDESC    :=TRB->ZHC_DESC
			cTIPOP   :=TRB->ZHC_TIPOP
			cGRUPO   :=TRB->ZHC_GRUPO
			dDATA    :=dPERIOD

			ZHC->( msUnlock() )
			TRB->(DBSKIP())
		ENDDO
		*------02-Saldo Estoque--------------------------------------------------------------------------------
		RecLock("ZHC",.T.)
		ZHC->ZHC_FILIAL := xFILIAL('ZHC')
		ZHC->ZHC_PERIOD := dPERIOD
		ZHC->ZHC_NUMMRP := cNUMMRP
		ZHC->ZHC_PRODUT := cPRODUT
		ZHC->ZHC_DESC   := cDESC
		ZHC->ZHC_TIPO   := '02-Saldo Estoque'
		ZHC->ZHC_TIPOP  := cTIPOP
		ZHC->ZHC_GRUPO  := cGRUPO
		ZHC->ZHC_NIVEL  := ''
		ZHC->ZHC_TEXTO  := ' '
		ZHC->ZHC_TXDT1  := DTOC(dDATA)
		ZHC->ZHC_TXDT2  := dDATA
		ZHC->ZHC_XQTDE  := nSLDINI
		ZHC->ZHC_SALDOE := nSLDINI
		ZHC->( msUnlock() )
		*------10-Saldo Final----------------------------------------------------------------------------------
		RecLock("ZHC",.T.)
		ZHC->ZHC_FILIAL := xFILIAL('ZHC')
		ZHC->ZHC_PERIOD := dPERIOD
		ZHC->ZHC_NUMMRP := cNUMMRP
		ZHC->ZHC_PRODUT := cPRODUT
		ZHC->ZHC_DESC   := cDESC
		ZHC->ZHC_TIPO   := '10-Saldo Final'
		ZHC->ZHC_TIPOP  := cTIPOP
		ZHC->ZHC_GRUPO  := cGRUPO
		ZHC->ZHC_NIVEL  := ''
		ZHC->ZHC_TEXTO  := ' '
		ZHC->ZHC_TXDT1  := DTOC(dDATA)
		ZHC->ZHC_TXDT2  := dDATA
		ZHC->ZHC_XQTDE  := nSLDFIN
		ZHC->ZHC_SALDO  := nSLDFIN
		ZHC->( msUnlock() )
		*------01-Necessidade----------------------------------------------------------------------------------
		RecLock("ZHC",.T.)
		ZHC->ZHC_FILIAL := xFILIAL('ZHC')
		ZHC->ZHC_PERIOD := dPERIOD
		ZHC->ZHC_NUMMRP := cNUMMRP
		ZHC->ZHC_PRODUT := cPRODUT
		ZHC->ZHC_DESC   := cDESC
		ZHC->ZHC_TIPO   := '01-Necessidade'
		ZHC->ZHC_TIPOP  := cTIPOP
		ZHC->ZHC_GRUPO  := cGRUPO
		ZHC->ZHC_NIVEL  := ''
		ZHC->ZHC_TEXTO  := ' '
		ZHC->ZHC_TXDT1  := DTOC(dDATA)
		ZHC->ZHC_TXDT2  := dDATA
		ZHC->ZHC_XQTDE  := nNECE
		ZHC->ZHC_NEC    := nNECE
		IF nNECE>0
			cIDMRP     := Soma1(cIDMRP,7,.T.,.T.)
			ZHC->ZHC_IDMRP  := cIDMRP
		ENDIF
		ZHC->( msUnlock() )
		*--------------------------------------------------------------------------------------
		//TRB->(DBSKIP())
	ENDDO

	TRB->(DbCloseArea())

//UPDATE ZHC010 SET ZHC_PERIOD ='20181113'  WHERE ZHC_PERIOD <'20181113'
//?update ZHC010 SET ZHC_TXDT1='13/11/2018', ZHC_TXDT2='20181113'  WHERE  ZHC_PERIOD ='20181113'
//UPDATE ZHC010 SET ZHC_PERIOD ='20181126',ZHC_TXDT1='26/11/2018', ZHC_TXDT2='20181126'  WHERE ZHC_PERIOD <'20181126'
//------------------------------------------------------------------------------------------------------
	cData     := DtoC(Date())
	cAssunto  := "MRP V2 Filial 02 Fim MRP - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	cTexto    := "MRP V2 Filial 02 Fim MRP - Date " + cData + "  Time: " + Time()
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br;paulo.celestino@rdt.com.br"
	cCC       := ""
	cArquivo  := ""

	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
//------------------------------------------------------------------------------------------------------
	//ZZ7 FIM

	ZZ7->(dbSelectArea("ZZ7"))
	ZZ7->(DBSETORDER(1))
	ZZ7->(DbSeek(xFilial("ZZ7")+_cCODMRP))
	IF ZZ7->(FOUND())
		_cHRINI:=ZZ7->ZZ7_HRINI
		Reclock("ZZ7",.F.)
		ZZ7->ZZ7_DTFIM  	:=DATE()
		ZZ7->ZZ7_HRFIM	:=TIME()
		ZZ7->ZZ7_HORAS   :=cValtoChar(SubHoras(time(),_cHRINI)) //SubHoras(time(),"13:59:45")
		ZZ7->ZZ7_HIST    :='FIM FILIAL 02'
		ZZ7->(MsUnlock())
	ENDIF

	_cdata1 :=dtos(dDatabase)
	_cdata2 :=SUBSTR(_cdata1,7,2)+'/'+SUBSTR(_cdata1,5,2)+'/'+SUBSTR(_cdata1,1,4)
//UPDATE ZHC010 SET ZHC_PERIOD ='20181217',ZHC_TXDT1='17/12/2018', ZHC_TXDT2='20181217'  WHERE ZHC_PERIOD <'20181217'
	cQRYFIM :="UPDATE ZHC010 SET ZHC_PERIOD ='"+_cdata1+"',ZHC_TXDT1='"+_cdata2+"', ZHC_TXDT2='"+_cdata1+"'  WHERE ZHC_PERIOD <'"+_cdata1+"' "
	TCSQLEXEC(cQRYFIM)
	MSGALERT('FIM')

RETURN

	*----------------------------------------------------------------------------------------------------*
STATIC FUNCTION MRP02SC4(_nC4REC)  // PESQUISA PREVISAO DE VENDA SC4
	*----------------------------------------------------------------------------------------------------*


	_cTXTSC4:=SPACE(20)
	_cSC4COD:=SPACE(06)

	cQRSC4 := " SELECT C4_XXPRI,C4_PRODUTO,C4_XXCOD,C4_DATA,C4_OBS,C4_QUANT,C4_XXNOMCL FROM SC4010 WHERE D_E_L_E_T_='' AND R_E_C_N_O_ ="+alltrim(str(_nC4REC))+" "
	TcQuery cQRSC4 Alias "TRSC4" New
//("TRSC4")->(DbGoTop())
	If TRSC4->(Eof())
		_cTXTSC4:=''
		_cSC4COD:=''
	ELSE
		_cPRI:=''
		DO CASE
		CASE alltrim(TRSC4->C4_XXPRI)=='W'
			_cPRI:='WON '
		CASE alltrim(TRSC4->C4_XXPRI)=='B'
			_cPRI:='BEST'
		CASE alltrim(TRSC4->C4_XXPRI)=='I'
			_cPRI:='IN  '
		ENDCASE

		_cTXTSC4:=_cPRI+' '+alltrim(TRSC4->C4_PRODUTO)+' Cod:'+alltrim(TRSC4->C4_XXCOD)+' Qtd:'+ alltrim(Transform(TRSC4->C4_QUANT,"@e 99,999.99"))+' Obs:'+alltrim(TRSC4->C4_OBS)+ ' '+alltrim(TRSC4->C4_XXNOMCL)+space(120)//+' QTD:'+Transform(TRSC4->C4_QUANT,"@e 99,999.99")STR(TRSC4->C4_QUANT)//mls
		_cTXTSC4:=substr(_cTXTSC4,1,119)
		_cSC4COD:=TRSC4->C4_XXCOD
	ENDIF

	TRSC4->(DbCloseArea())

RETURN


// --------------------------------------------------------------------------
static Function _PCham ()
	local _i      := 0
	local _sPilha := chr (13) + chr (10) + chr (13) + chr (10) + "Pilha de chamadas:"
	do while procname (_i) != ""
		_sPilha += chr (13) + chr (10) + procname (_i)
		_i++
	enddo
return _sPilha


	*----------------------------------------------------------------------------------------------------*
User Function MRP02RDF()
	*----------------------------------------------------------------------------------------------------*
//MsAguarde( { || DjoBPAR()    } ,"MRP Domex V2 Acerto Parametros", "Aguarde..." )  
//MsAguarde( { || U_MRP02INF() } ,"Inicio MRP Domex V2", "Aguarde..." )  
	PRIVATE lMRPSI :=.F.
	PRIVATE lMRFl2 :=.T.
	MATA712()
	U_MRP020()

return


USER FUNCTION MRPDELFF()
	PRIVATE _lCZI :=.F.
	PRIVATE _lCZJ :=.F.
	PRIVATE _lCZK :=.F.

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" USER 'MRP' PASSWORD 'MRP' Tables "SB1" Modulo "PCP"

	TCLink()
	IF TCDelFile( "CZI010" ) == .T.
		_lCZI:=.T.
	ENDIF
	IF TCDelFile( "CZJ010" ) == .T.
		_lCZJ:=.T.
	ENDIF
	IF TCDelFile( "CZK010" ) == .T.
		_lCZK:=.T.
	ENDIF
	TCUnlink()
	cData     := DtoC(Date())
	cPara     := "denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
	cCC       := ""
	cArquivo  := ""
	IF _lCZI==.T. .AND. _lCZJ==.T. .AND.  _lCZK==.T.
		cAssunto  := "MRP V2 Filial 02 Deletado Tabelas (CZI,CZJ,CZK) - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
		cTexto    := "MRP V2 Filial 02Deletado Tabelas  (CZI,CZJ,CZK)- Date " + cData + "  Time: " + Time()
	ELSE
		cAssunto  := "MRP V2 Filial 02 não foi proosivel deletar tabelas (CZI,CZJ,CZK) - Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
		cTexto    := "MRP V2 Filial 02 não foi proosivel deletar tabelas (CZI,CZJ,CZK)- Date " + cData + "  Time: " + Time()
	ENDIF
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	RESET ENVIRONMENT
RETURN
