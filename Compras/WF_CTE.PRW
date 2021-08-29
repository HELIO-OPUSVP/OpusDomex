#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"                                                 
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWF_CTE    บAutor  ณMarco Aurelio       บ Data ณ  22/01/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WorkFLow de CTE - GestorXML                                บฑฑ
ฑฑบ          ณ Lista itens que foram lancados sem Regra criada             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WF_CTE()
                                                              		
	Private nOpcA			:= 0
	Private oProcess,oDlg
	Private cQuery1                
	Private _cFEmail := ""
	Private _dData := DtoC(Date())
	Private _cHora := "10:12" //Substr(time(),1,5)         
	Private _cTabProd := ""

 //	If Type("CUSUARIO") == "U"
// 	RpcSetType(3)
 //	RpcSetEnv("01","01")
//	EndIf

		_cTipo := ""
		// Fecha o arquivo temporario, caso este esteja aberto
		If Select("TRB1") <> 0
			TRB1->(dbCloseArea())
		EndIf
	
		cQuery1	:= " SELECT DISTINCT F1_FORNECE,F1_LOJA,F1_SERIE,F1_DOC,F1_EMISSAO,F1_DTDIGIT,F1_VALBRUT " 
		cQuery1 	+= " FROM "+ RetSqlName("SF1")+" SF1  " 
		cQuery1 	+= " WHERE " 
		cQuery1 	+= " D_E_L_E_T_ = '' " 
		cQuery1 	+= " AND F1_ESPECIE = 'CTE' "
		cQuery1 	+= " AND F1_DTDIGIT >= '20190122' "
		cQuery1 	+= " AND F1_FORNECE+F1_LOJA NOT IN ( "
		cQuery1 	+= " 			                         SELECT  DISTINCT ZZ5_FORNEC+ZZ5_LOJAFO FROM "+ RetSqlName("ZZ5")+" ZZ5  " 
		cQuery1 	+= "                                  WHERE D_E_L_E_T_ ='' AND  ZZ5_CTE = 'S' )"
		cQuery1 	+= " ORDER BY F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_DOC "
	 
		cQuery1 := ChangeQuery(cQuery1)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB1",.T.,.T.)
	
		DbSelectArea("TRB1")	
		_nTotal			:= 0
		
		do While  !TRB1->( EOF() )
			_nTotal++
 
	      _cFornec		:= TRB1->F1_FORNECE +"-"+ TRB1->F1_LOJA 
	      _cDocumento	:= TRB1->F1_SERIE+"-"+TRB1->F1_DOC 
	      _dEmissao	:= DtoC(StoD(TRB1->F1_EMISSAO)) 
	      _dDigit		:= DtoC(StoD(TRB1->F1_DTDIGIT))
	      _nValBrut	:= TRB1->F1_VALBRUT   
/*
			_cTabProd	+= ' <table style="text-align: left; width: 861px; background-color: white; height: 37px;" border="1" cellpadding="1" cellspacing="1"> '
			_cTabProd	+= '   <tbody> '
			_cTabProd	+= '     <tr> '
			_cTabProd	+= '       <td style="vertical-align: top; text-align: center; background-color: white; font-family: Arial; width: 130px; height: 31px;">'+_cFornec+'<br /> '
			_cTabProd	+= '       </td> '
			_cTabProd	+= '       <td style="vertical-align: top; text-align: center; background-color: white; font-family: Arial; width: 90px; height: 31px;">'+_cDocumento+'<br /> '
			_cTabProd	+= '       </td> '
			_cTabProd	+= '       <td style="vertical-align: top; text-align: center; background-color: white; font-family: Arial; width: 90px; height: 31px;">'+_dEmissao+'<br /> '
			_cTabProd	+= '       </td> '
			_cTabProd	+= '       <td style="vertical-align: top; text-align: center; background-color: white; font-family: Arial; width: 90px; height: 31px;">'+_dDigit+'<br /> '
			_cTabProd	+= '       </td> '
			_cTabProd	+= '       <td style="vertical-align: top; text-align: center; background-color: white; font-family: Arial; width: 90px; height: 31px;">'+_nValBrut+'<br /> '
			_cTabProd	+= '       </td> '
			_cTabProd	+= '     </tr> '
			_cTabProd	+= '   </tbody> '
			_cTabProd	+= ' </table> '
*/

			_cTabProd	+= ' <table style="text-align: left; width: 811px; height: 60px; background-color: white;" border="1" cellpadding="2" cellspacing="2"> '
			_cTabProd	+= '   <tbody> '
			_cTabProd	+= '     <tr> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 70px;"><small>'+_cFornec+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 75px;"><small>'+_cDocumento+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 112px;"><small>'+_dEmissao+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 107px;"><small>'+_dDigit+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 110px;"><small>'+_nValBrut+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 81px;"><small>'+_cFornec+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 196px;"><small>'+_nValBrut+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '     </tr> '
			_cTabProd	+= '   </tbody> '
			_cTabProd	+= ' </table> '
	
			dbSkip()
	
		Enddo
 	
		If _nTotal > 0
		   _cTexto			:= "Total de CTE sem Amarra็ใo : " + str(_nTotal)
	   else
		   _cTexto			:= "Nใo Existem itens para Listar..."	   
		endif
	
		// Cria Diretorio Local para HTML
		cPath:="C:\DOMEX"	
		c_FileOrig:="\WORKFLOW\MODELOS\WF_CTE.html"
		c_FileDest:="\WORKFLOW\MODELOS\WF_CTE.html"
			
		// Dados para Gerar Email
		_cPara		:= ";denis.vieira@rdt.com.br"  // ";marco.aurelio@opusvp.com.br"  
		_cTitMail	:= "DOMEX - CTE Sem Amarra็ใo (Tes Inteligente)" 
		c_texto		:= _cTexto
		cArquivo 	:= ""
	  							
		fArq(c_FileOrig, c_FileDest)  // Retorna cTexto
	
		_cCopyPC		:= ""  
		lUsaWorkflow := .F.
		U_EnvMailto(_cTitMail,c_texto,_cPara,_cCopyPC,cArquivo,lUsaWorkflow)	

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
