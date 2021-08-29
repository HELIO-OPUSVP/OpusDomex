//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Mauricio Lima de Souza - 20/04/18 - OpusVp                                                                                                       //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Importacao Cadastro de Produto                                                                                               //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
                             
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function IMPPVEXP()
// criação tabela temporaria 
MsAguarde( { || U_IMPEXP2() } ,"Importar Pedido de Venda SIGAEEC", "Procurando Pedido venda SIGAFAT - Aguarde..." )   
return

User Function IMPEXP2()
PRIVATE _nTXUSD :=1
cQUERY := " SELECT *  "
cQUERY += " FROM "+RetSQLName("SC5")+" C5,"+RetSQLName("SC6")+" C6 ,"+RetSQLName("SA1")+" A1 "
cQUERY += " WHERE  "
cQUERY += " C6_NUM=C5_NUM "
cQUERY += " AND C6_CLI=A1_COD AND C6_LOJA=A1_LOJA "
cQUERY += " AND C5.D_E_L_E_T_='' "
cQUERY += " AND C6.D_E_L_E_T_='' "
cQUERY += " AND A1.D_E_L_E_T_='' "
cQUERY += " AND C5_FILIAL='"+xFILIAL('SC5')+"' "
cQUERY += " AND C6_FILIAL='"+xFILIAL('SC6')+"' "
cQUERY += " AND A1_FILIAL='"+xFILIAL('SA1')+"' "
cQUERY += " AND A1_EST='EX'      "
cQUERY += " AND C5_EMISSAO>='20180101'      "
/////cQUERY += " AND C6_QTDENT=0      "
/////cQUERY += " AND C6_QTDVEN>0      "   
/////cQUERY += "   AND C6_ITEM='04'   "
/////cQUERY += "   AND C6_NUM='034178'   "  
cQUERY += " AND C6_BLQ<>'R'       "
cQUERY += " AND C5_NUM NOT IN (SELECT  EE7_PEDFAT FROM "+RetSQLName("EE7")+" WHERE D_E_L_E_T_='' AND EE7_FILIAL='"+xFILIAL('EE7')+"' GROUP BY EE7_PEDFAT ) "
cQUERY += " ORDER BY C6.C6_NUM   "

TcQuery cQuery Alias "TRB" New       

EE7->(DBSELECTAREA('EE7'))
EE7->(DBSETORDER(1))

EE8->(DBSELECTAREA('EE8'))
EE8->(DBSETORDER(1))

("TRB")->(DbGoTop())

cPEDIDO :=SPACE(06)

//TAXA DOLAR
SYE->(DBSELECTAREA('SYE'))
SYE->(DBSETORDER(2))//YE_FILIAL+YE_MOEDA+DTOS(YE_DATA) 

IF SYE->(DbSeek(xFilial('SYE')+'US$'+DTOS(DATE())))  
    IF SYE->YE_VLCON_C >0         // TAXA DO DOLAR NO DIA
       _nTXUSD := SYE->YE_VLCON_C
       ELSE
       _nTXUSD := 1
       
    ENDIF   
ENDIF   

DO WHILE .NOT. TRB->(EOF())

    //cQRUPD := " UPDATE SC5010 SET C5_PEDEXP='"+"EXP00000000000"+ALLTRIM(TRB->C5_NUM)+"' WHERE C5_NUM='"+TRB->C5_NUM+"' "
    //TCSQLEXEC(cQRUPD)

	IF cPEDIDO<>TRB->C5_NUM
	//IF 1==2
		//CABEC
		RecLock("EE7",.T.)
		EE7->EE7_FILIAL:= xFILIAL('EE7')
		EE7->EE7_PEDIDO:='EXP00000000000'+ALLTRIM(TRB->C5_NUM)
		EE7->EE7_PEDFAT:=TRB->C5_NUM
		EE7->EE7_AMOSTR:='2'
		//EE7->EE7_CLIENT:=TRB->C5_CLIENTE
		//EE7->EE7_CLLOJA:=TRB->C5_LOJACLI
		EE7->EE7_IMPORT:=TRB->C5_CLIENTE
		EE7->EE7_IMLOJA:=TRB->C5_LOJACLI
		EE7->EE7_REFIMP:=TRB->C5_ESP1
		
		EE7->EE7_IMPODE :=POSICIONE('SA1',1,xFILIAL('SA1')+TRB->C5_CLIENTE+TRB->C5_LOJACLI,'A1_NOME') 
		EE7->EE7_ENDIMP :=POSICIONE('SA1',1,xFILIAL('SA1')+TRB->C5_CLIENTE+TRB->C5_LOJACLI,'A1_END') 
		EE7->EE7_END2IM :=POSICIONE('SA1',1,xFILIAL('SA1')+TRB->C5_CLIENTE+TRB->C5_LOJACLI,'A1_BAIRRO') 

		//ENDERECO2
		EE7->EE7_XIMPOD :=POSICIONE('SA1',1,xFILIAL('SA1')+TRB->C5_CLIENTE+TRB->C5_LOJACLI,'A1_NOME') 
		EE7->EE7_XENDIM :=POSICIONE('SA1',1,xFILIAL('SA1')+TRB->C5_CLIENTE+TRB->C5_LOJACLI,'A1_END') 
		EE7->EE7_XEND2I :=POSICIONE('SA1',1,xFILIAL('SA1')+TRB->C5_CLIENTE+TRB->C5_LOJACLI,'A1_BAIRRO') 
        //---------------------------------------------------------------------------------------
		
		EE7->EE7_EXPORT:='900000'
		EE7->EE7_FORN  :='900000'
		EE7->EE7_FOLOJA:='01'
		EE7->EE7_EXLOJA:='01'
		EE7->EE7_DTPEDI:= ctod(subst(TRB->C5_EMISSAO,7,2)+'/'+substr(TRB->C5_EMISSAO,5,2)+'/'+subst(TRB->C5_EMISSAO,1,4))
		EE7->EE7_DTPROC:= DATE()
		EE7->EE7_IDIOMA:='INGLES-INGLES'
		EE7->EE7_INCOTE:='EXW'
		EE7->EE7_MOEDA :='US$'
		EE7->EE7_MPGEXP:='001'
	   //	EE7->EE7_STATUS:='1'
	   //	EE7->EE7_STTDES:='Aguardando Solicitacao de Credito '
		EE7->EE7_TOTITE:= TRB->C6_VALOR  / _nTXUSD
		EE7->EE7_TOTPED:= TRB->C6_VALOR  / _nTXUSD
		EE7->EE7_INCO2 :='EXW'
		EE7->EE7_KEY   :=-1
		EE7->EE7_VLFOB := TRB->C6_VALOR  / _nTXUSD
        EE7->EE7_TOTFOB:= TRB->C6_VALOR  / _nTXUSD
		EE7->EE7_TPDESC:='2'
		EE7->EE7_TOTLIQ:=TRB->C6_VALOR   / _nTXUSD
		EE7->EE7_PRECOA:= "1"
        EE7->EE7_FRPPCC:='PP'
        EE7->EE7_BRUEMB:='2'
        
        EE7->EE7_CALCEM:='1'
        EE7->EE7_CONDPA :=POSICIONE('SY6',2,xFILIAL('SY6')+TRB->C5_CONDPAG,'Y6_COD')
        EE7->EE7_DIASPA :=POSICIONE('SY6',2,xFILIAL('SY6')+TRB->C5_CONDPAG,'Y6_DIAS_PA')
        EE7->EE7_STATUS='B'
        EE7->EE7_STTDES:='Aguardando Faturamento'
        EE7->EE7_DTSLCR:=DATE()
        EE7->EE7_DTPROC:=DATE()
        EE7->EE7_PEDFAT:=ALLTRIM(TRB->C5_NUM)
		
		EE7->(MSUNLOCK())
		cData     := DtoC(Date())
        cAssunto  := "Importacao SIGAFAT X SIGAEEC  Pedido: "+"EXP00000000000"+ALLTRIM(TRB->C5_NUM)+" User:  " + Subs(cUSUARIO,7,14)+" "+TRB->C5_ESP1
        cTexto    := "Importacao SIGAFAT X SIGAEEC US$  Pedido: "+"EXP00000000000"+ALLTRIM(TRB->C5_NUM)+" "+TRB->C5_ESP1+" - Data " + cData + "  Hora: " + Time()
        cPara     := "natassia.curado@rdt.com.br;adriana.ottoboni@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;mauricio.souza@opusvp.com.br"
        cCC       := ""
        cArquivo  := ""

        U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

	ENDIF
	//ITEM
	cPEDIDO :=TRB->C5_NUM
	RecLock("EE8",.T.)
	EE8->EE8_FILIAL := xFILIAL('EE8')
	EE8->EE8_PEDIDO := 'EXP00000000000'+ALLTRIM(TRB->C5_NUM)
	EE8->EE8_SEQUEN := STRZERO(VAL(TRB->C6_ITEM),6)
	EE8->EE8_COD_I  := TRB->C6_PRODUTO
	//EE8->EE8_DESC   := TRB->C6_DESCRI
	EE8->EE8_DTENTR := ctod(subst(TRB->C6_ENTREG,7,2)+'/'+substr(TRB->C6_ENTREG,5,2)+'/'+subst(TRB->C6_ENTREG,1,4))//TRB->C6_ENTREG
	EE8->EE8_DTPREM := ctod(subst(TRB->C6_ENTREG,7,2)+'/'+substr(TRB->C6_ENTREG,5,2)+'/'+subst(TRB->C6_ENTREG,1,4))//TRB->C6_ENTREG
	EE8->EE8_FORN   :='900000'
	EE8->EE8_FOLOJA :='01'
	EE8->EE8_PRECO  := TRB->C6_PRCVEN / _nTXUSD
	EE8->EE8_PRCUN  := TRB->C6_PRCVEN / _nTXUSD
	EE8->EE8_PRCTOT := TRB->C6_VALOR  / _nTXUSD
	EE8->EE8_PRECOI := TRB->C6_VALOR  / _nTXUSD
	EE8->EE8_QE     := TRB->C6_QTDVEN
	EE8->EE8_QTDEM1 := TRB->C6_QTDVEN	
	EE8->EE8_SLDATU := TRB->C6_QTDVEN
	EE8->EE8_SLDINI := TRB->C6_QTDVEN
	EE8->EE8_POSIPI := POSICIONE('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_POSIPI')
	EE8->EE8_UNIDAD := POSICIONE('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_UM')
	EE8->EE8_UNPRC  := POSICIONE('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_UM')
	EE8->EE8_UNPES  := 'KG'
	EE8->EE8_PRCINC := TRB->C6_PRCVEN / _nTXUSD
	EE8->EE8_GRADE  :='N'
	EE8->EE8_FATIT  :=TRB->C6_ITEM
	EE8->EE8_TES    :=TRB->C6_TES
	EE8->EE8_CF     :=TRB->C6_CF
	
	EE8->EE8_PART_N :=SUBSTR(TRB->C6_SEUCOD,1,15)
	EE8->EE8_REFCLI :=TRB->C6_SEUDES
	
	EE8->EE8_EMBAL1 :='CAIXA001'  
	
	EE8->EE8_PSBRUN :=POSICIONE('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_PESBRU')
	EE8->EE8_PSLQUN :=POSICIONE('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_PESO'  )		
	
	EE8->EE8_PSBRTO :=POSICIONE('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_PESBRU')*TRB->C6_QTDVEN  
	EE8->EE8_PSLQTO :=POSICIONE('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_PESO'  )*TRB->C6_QTDVEN  
	
	_cDesc:= posicione('SB1',1,xFILIAL('SB1')+TRB->C6_PRODUTO,'B1_DESC')
    _nTam := TamSX3("B1_DESC")
    _nTam1 := _nTam[1]
    EE8->EE8_DESC := MSMM(,_nTam1,,_cDesc ,1,,,"EE8","EE8_DESC")
	
    //EE8->EE8_DPCOD  :=
	//EE8->EE8_FABR   :=
	//EE8->EE8_FALOJA :=


	//EE8->EE8_FPCOD  :=
	//EE8->EE8_GPCOD  :=
	//EE8->EE8_NALSH  :=
	//EE8->EE8_NLNCCA :=
	//EE8->EE8_PART_N :=
	
	//EE8->EE8_REFCLI :=
	//EE8->EE8_STATUS :=
	//EE8->EE8_DTQNCM :=
	//EE8->EE8_TPONCM :=
	//EE8->EE8_PERCOM :=
	//EE8->EE8_PRENEG :=
	//EE8->EE8_RV :=
	//EE8->EE8_STA_RV :=
	//EE8->EE8_SEQ_RV :=
	//EE8->EE8_MESFIX :=
	//EE8->EE8_DTCOTA :=
	//EE8->EE8_DTFIX :=
	//EE8->EE8_STFIX :=
	//EE8->EE8_QTDLOT :=
	//EE8->EE8_ORIGEM :=
	//EE8->EE8_LOTECT :=
	//EE8->EE8_NUMLOT :=
	//EE8->EE8_DTVALI :=
	//EE8->EE8_DIFERE :=
	//EE8->EE8_CODQUA :=
	//EE8->EE8_QUADES :=
	//EE8->EE8_CODPEN :=
	//EE8->EE8_DSCPEN :=
	//EE8->EE8_CODTIP :=
	//EE8->EE8_DSCTIP :=
	//EE8->EE8_CODBEB :=
	//EE8->EE8_DSCBEB :=
	//EE8->EE8_PRVPRO :=
	//EE8->EE8_DTPROD :=
	//EE8->EE8_PRECO5 :=
	//EE8->EE8_PRECO2 :=
	//EE8->EE8_PRECO3 :=
	//EE8->EE8_PRECO4 :=
	//EE8->EE8_DESCON :=
	//EE8->EE8_CODAGE :=
	//EE8->EE8_TIPCOM :=
	//EE8->EE8_DTRV :=
	//EE8->EE8_DTVCRV :=
	//EE8->EE8_CODNOR :=
	//EE8->EE8_ORIGV :=
	//EE8->EE8_INVPAG :=
	//EE8->EE8_VLPAG :=
	//EE8->EE8_LC_NUM :=
	//EE8->EE8_SEQ_LC :=
	//EE8->EE8_VLFRET :=
	//EE8->EE8_VLSEGU :=
	//EE8->EE8_VLOUTR :=
	//EE8->EE8_VLDESC :=
	//EE8->EE8_DIFE2 :=
	//EE8->EE8_ITEMGR :=
	//EE8->EE8_RESERV :=
	//EE8->EE8_CODOPE :=
	//EE8->EE8_VLCOM :=
	//EE8->EE8_PEDERP :=
	//EE8->EE8_SLDELI :=
	//EE8->EE8_DTELIM :=
	//EE8->EE8_OPC :=
	//EE8->EE8_MOP :=
	//EE8->EE8_ATOCON :=
	EE8->(MSUNLOCK())
	TRB->(DBSKIP())
ENDDO

//EE7->EE7_CONDPA:=
//EE7->EE7_BELOJA:=
//EE7->EE7_BENEDE:=
//EE7->EE7_BENEF :=
//EE7->EE7_BRUEMB:=
//EE7->EE7_CALCEM:=
//EE7->EE7_CODMAR:=
//EE7->EE7_CODMEM:=
//EE7->EE7_CODOBP:=
//EE7->EE7_COLOJA:=
//EE7->EE7_CONSIG:=
//EE7->EE7_CUBAGE:=
//EE7->EE7_DESCON:=
//EE7->EE7_DESPIN:=
//EE7->EE7_DEST  :=
//EE7->EE7_DIASPA:=
//EE7->EE7_DSCGEN:=
//EE7->EE7_DTAPCR:=
//EE7->EE7_DTLIMP:=
//EE7->EE7_DTSLCR:=
//EE7->EE7_EMBAFI:=
//EE7->EE7_END2BE:=
//EE7->EE7_END2IM:=
//EE7->EE7_ENDBEN:=
//EE7->EE7_ENDIMP:=
//EE7->EE7_EXLIMP:=
//EE7->EE7_FATURA:=
//EE7->EE7_FIM_PE:=
//EE7->EE7_FRPCOM:=
//EE7->EE7_FRPREV:=
//EE7->EE7_IMPODE:=
//EE7->EE7_LC_NUM:=
//EE7->EE7_LICIMP:=
//EE7->EE7_MOTSIT:=
//EE7->EE7_ORIGEM:=
//EE7->EE7_PESBRU:=
//EE7->EE7_PESLIQ:=
//EE7->EE7_PGTANT:=
//EE7->EE7_TIPSEG:=
//EE7->EE7_REFAGE:=
//EE7->EE7_REFIMP:=C5_ESP1
//EE7->EE7_RESPON:=
//EE7->EE7_SEGPRE:=
//EE7->EE7_SEGURO:=
//EE7->EE7_SL_EME:=
//EE7->EE7_SL_LC :=
//EE7->EE7_TIPCOM:=
//EE7->EE7_TIPCVL:=
//EE7->EE7_TIPTRA:=
//EE7->EE7_VALCOM:=
//EE7->EE7_VIA   :=
//EE7->EE7_DECQTD:=
//EE7->EE7_DECPRC:=
//EE7->EE7_DECPES:=
//EE7->EE7_INTERM:=
//EE7->EE7_COND2 :=
//EE7->EE7_DIAS2 :=
//EE7->EE7_PERC  :=
//EE7->EE7_UNIDAD:=
//EE7->EE7_ENVAMO:=
//EE7->EE7_TABPRE:=
//EE7->EE7_PAISET:=
//EE7->EE7_TEMLC :=
//EE7->EE7_DTPGAN:=
//EE7->EE7_INTEGR:=
//EE7->EE7_QTD20 :=
//EE7->EE7_QTD40 :=
//EE7->EE7_QTD40H:=
//EE7->EE7_TIPO  :=
//EE7->EE7_FUMIGA:=
//EE7->EE7_MODEST:=
//EE7->EE7_CODBOL:=
//EE7->EE7_OPCFIX:=
//EE7->EE7_CONDFI:=
//EE7->EE7_DSCORG:=
//EE7->EE7_SPOT  :=
//EE7->EE7_ID_CR :=
//EE7->EE7_ID_AP :=
//EE7->EE7_FREEMB:=
//EE7->EE7_PEDERP:=
//EE7->EE7_DESSEG:=
//EE7->EE7_DTSLAP:=
//EE7->EE7_DTAPPE:=
//		EE7->(MSUNLOCK())
//	ENDIF
//	TRB->(DBSKIP())
//ENDDO

TRB->(DbCloseArea())


cQUERY1 := " UPDATE SC5010 SET C5_PEDEXP=(SELECT TOP 1 EE7_PEDIDO  "
cQUERY1 += " FROM EE7010 WHERE EE7_PEDFAT=C5_NUM AND D_E_L_E_T_='' AND EE7_FILIAL='') "
cQUERY1 += " WHERE D_E_L_E_T_='' AND C5_FILIAL='01' AND C5_PEDEXP='' "
cQUERY1 += " AND EXISTS (SELECT TOP 1 EE7_PEDIDO FROM EE7010 WHERE EE7_PEDFAT=C5_NUM AND D_E_L_E_T_='' AND EE7_FILIAL='') "

cQUERY2 := " UPDATE EE7010 SET EE7_STATUS='D', EE7_STTDES='Faturado'  "
cQUERY2 += " WHERE EE7_PEDFAT IN(SELECT C5_NUM FROM SC5010 WHERE C5_PEDEXP<>'' AND C5_NOTA<>'' AND D_E_L_E_T_='') "
cQUERY2 += " AND D_E_L_E_T_='' AND  EE7_STATUS<>'D' "

cQUERY3 := " UPDATE EE7010 SET EE7_STATUS='B', EE7_STTDES='Aguardando Faturamento'  "
cQUERY3 += " WHERE EE7_PEDFAT  IN(SELECT C5_NUM FROM SC5010 WHERE C5_PEDEXP<>'' AND C5_NOTA='' AND D_E_L_E_T_='') "
cQUERY3 += " AND D_E_L_E_T_='' AND  EE7_STATUS NOT IN ('B','D') "

cQUERY4 := " UPDATE SC5010 SET C5_PEDEXP=''  WHERE C5_PEDEXP<>''  "   // DESFAZ ANARRACAO SIGAEEC X SIGAFAT    

cQUERY5 := " UPDATE EE7010 SET EE7_PESLIQ= "
cQUERY5 += " (SELECT TOP 1 F2_PLIQUI FROM SC6010 WITH(NOLOCK),SF2010 WITH(NOLOCK) "
cQUERY5 += " WHERE C6_NUM = EE7_PEDFAT "
cQUERY5 += " AND SC6010.D_E_L_E_T_=''  AND C6_BLQ<>'R' AND C6_NOTA<>'' "
cQUERY5 += " AND SF2010.D_E_L_E_T_=''  AND F2_DOC=C6_NOTA AND F2_EMISSAO>='20181001'), "
cQUERY5 += " EE7_PESBRU= "
cQUERY5 += " (SELECT TOP 1 F2_PBRUTO FROM SC6010 WITH(NOLOCK),SF2010 WITH(NOLOCK) "
cQUERY5 += " WHERE C6_NUM = EE7_PEDFAT "
cQUERY5 += " AND SC6010.D_E_L_E_T_=''  AND C6_BLQ<>'R' AND C6_NOTA<>'' "
cQUERY5 += " AND SF2010.D_E_L_E_T_=''  AND F2_DOC=C6_NOTA AND F2_EMISSAO>='20181001') "
cQUERY5 += " WHERE D_E_L_E_T_='' "
cQUERY5 += " AND EXISTS  "
cQUERY5 += " (SELECT TOP 1  F2_PLIQUI FROM SC6010 WITH(NOLOCK),SF2010 WITH(NOLOCK) "
cQUERY5 += " WHERE C6_NUM = EE7_PEDFAT "
cQUERY5 += " AND SC6010.D_E_L_E_T_=''  AND C6_BLQ<>'R' AND C6_NOTA<>'' "
cQUERY5 += " AND SF2010.D_E_L_E_T_=''  AND F2_DOC=C6_NOTA AND F2_EMISSAO>='20181001') "

TCSQLEXEC(cQUERY1)
TCSQLEXEC(cQUERY2) 
TCSQLEXEC(cQUERY3)
TCSQLEXEC(cQUERY4)
TCSQLEXEC(cQUERY5)

//MSGALERT('Fim Importacao SIGAFAT X SIGAEEC ','Atencao')
RETURN
