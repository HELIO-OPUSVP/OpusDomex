#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"                                                 
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR02  บAutor  ณMarco Aurelio        บ Data ณ  27/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de Pedidos Sem Libera็ao do FISCAL               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATR02()
                                                              		
	Private nOpcA			:= 0
	Private oProcess,oDlg
	Private cQuery                
	Private _cFEmail := ""
	Private _dData := DtoC(Date())
	Private _cHora := Substr(time(),1,5)
	Private _cInicio:= '20170101'		// Data de Inicio do Processamento do Relat๓rio

//If Type("CUSUARIO") == "U"
	RpcSetType(3)
	RpcSetEnv("01","01")
//EndIf

	// Fecha o arquivo temporario, caso este esteja aberto
	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	EndIf

	cQuery := "	SELECT DISTINCT "
	cQuery += " 	C6_ENTRE3,C5_NUM,C5_CLIENTE,C5_LOJACLI ,A1_NOME,C5_XXLIBFI "
	cQuery += " FROM " + RetSqlName("SC5")+" SC5 , "+ RetSqlName("SC6")+" SC6, "+ RetSqlName("SA1")+" SA1 "
	cQuery += " WHERE  "
	cQuery += " 	 NOT (  C5_NOTA<> '' OR C5_LIBEROK ='E' AND  C5_BLQ = ''  ) "
	cQuery += " 	AND C5_FILIAL+C5_NUM = C6_FILIAL+C6_NUM  "
	cQuery += " 	AND C6_QTDVEN > C6_QTDENT AND C6_ENTRE3 >= '"+_cInicio+"'	 "   
	cQuery += " 	AND C5_XXLIBFI = '0'  "
	cQuery += " 	AND C5_CLIENTE+C5_LOJACLI=A1_COD+A1_LOJA "
	cQuery += " 	AND SC5.D_E_L_E_T_ = '' "
	cQuery += " 	AND SC6.D_E_L_E_T_ = '' "
	cQuery += " 	AND SA1.D_E_L_E_T_ = '' "		
	cQuery += " ORDER BY C6_ENTRE3,C5_NUM "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

	_cTabProd		:= ""
	_nTotal			:= 0
	
	do While !eof()
		_nTotal++
      _dEmissao	:= DtoC(StoD(TRB->C6_ENTRE3)) 
      _cPedido		:= TRB->C5_NUM
      _cCliente	:= TRB->(C5_CLIENTE+"-"+C5_LOJACLI+"  "+A1_NOME)      		

		if TRB->C5_XXLIBFI == "1"
	      _cStatus		:= "Manual"
		elseif TRB->C5_XXLIBFI == "2"
	      _cStatus		:= "Automatico"
		else
	      _cStatus		:= "Nใo Liberado"
		endif	
    
		_cTabProd	+= ' <table style="width: 816px; height: 30px;" border="1" cellpadding="1"> '
		_cTabProd	+= '   <tbody><tr> '
		_cTabProd	+= '    <td style="text-align: center; width: 145px;">'+_dEmissao+'<br /></td> '
		_cTabProd	+= '    <td style="text-align: center; width: 133px;" rowspan="1">'+_cPedido+'<br /></td> '
		_cTabProd	+= '    <td style="width: 455px; text-align: center;" rowspan="1">'+_cCliente+'<br /></td> '
		_cTabProd	+= '   </tr> '
		_cTabProd	+= ' </tbody> '
		_cTabProd	+= ' </table> '

		dbSkip()

	Enddo

	// Cria Diretorio Local para HTML
	cPath:="C:\DOMEX"
//	If MakeDir(cPath) <> 0
		//		Help(" ",1,"NOMAKEDIR")
		//		lRet := .F.
//	EndIf
	

	c_FileOrig:="\WORKFLOW\MODELOS\PVFiscal.html"
	c_FileDest:="\WORKFLOW\MODELOS\PVXFiscal.html"
		
	// Dados para Gerar Email
	_cPara		:= GETMV("MV_XWKFIS") 
	_cTitMail	:= "DOMEX - OFs sem Libera็ao Fiscal"
	c_texto		:= ""
	cArquivo 	:= ""

	
	fArq(c_FileOrig, c_FileDest)  // Retorna cTexto

	_cCopyPC		:= ""
	U_EnvMailto(_cTitMail,c_texto,_cPara,_cCopyPC,cArquivo)	


Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma    ณ fArq      ณ Funcao para gravacao buffer arquivo HTML.                    บฑฑ
ฑฑฬออออออออออออุอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออัออออออัอออออออออออนฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fArq(c_FileOrig, c_FileDest)

Local l_Ret 	:= .T.
Local c_Buffer	:= ""
Local n_Posicao	:= 0
Local n_QtdReg	:= 0
Local n_RegAtu	:= 0

If !File(c_FileOrig)
	l_Ret := .F.
//	MsgStop("Arquivo [ "+c_FileOrig+" ] nใo localizado.", "Nใo localizou")
Else
	
	Ft_fuse( c_FileOrig ) 		// Abre o arquivo
	Ft_FGoTop()
	n_QtdReg := Ft_fLastRec()
	nHandle	:= MSFCREATE( c_FileDest )
	
	///////////////////////////////////
	// Carregar o array com os itens //
	///////////////////////////////////
	While !ft_fEof() .And. l_Ret
		c_Buffer := ft_fReadln()
		
		FWrite(nHandle, &("'" + c_Buffer + "'"))
		c_texto += &("'" + c_Buffer + "'")
		ft_fSkip()
	Enddo
	FClose(nHandle)
EndIf

Return l_Ret             
