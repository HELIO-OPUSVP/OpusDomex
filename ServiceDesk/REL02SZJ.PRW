#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"                                                 
#Include "protheus.ch"
#Include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREL02SZJ  บAutor  ณMarco Aurelio       บ Data ณ  27/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WorkFLow de Chamados - Service Desk                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function REL02SZJ()
                                                              		
	Private nOpcA			:= 0
	Private oProcess,oDlg
	Private cQuery1                
	Private _cFEmail := ""
	Private _dData := DtoC(Date())
	Private _cHora := Substr(time(),1,5)
	Private _nDtWF1	:= dtos(date() - 15)		// Dias para gerar WorkFlow 1 (Chamados Novos )
	Private _nDtWF2	:= dtos(date() - 05)		// Dias para gerar WorkFlow 2 (Chamados Em Atendimento )	

	If Type("CUSUARIO") == "U"
		RpcSetType(3)
		RpcSetEnv("01","01")
	EndIf

	For i:= 1 to 3

		_cTipo := ""
		// Fecha o arquivo temporario, caso este esteja aberto
		If Select("TRB1") <> 0
			TRB1->(dbCloseArea())
		EndIf
	
		if i == 1     //   DIARIO - Chamados Novos Abertos a mais de 15 dias  / Nao Classificados /Nao Atendidos

		   _cTipo	:= " Novos - Sem Atendimento"			
			cQuery1	:= " SELECT * FROM "+ RetSqlName("SZJ")+" SZJ  "
			cQuery1 	+= " WHERE 	 SZJ.ZJ_SITUAC NOT IN ('C','R') "        	//-- T=Aguardando Tecnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado
			cQuery1 	+= "		AND SZJ.ZJ_STATUS IN ('P') "             		//-- P=Chamado Novo;A=Em Atendimento;F=Fechado 
			cQuery1 	+= "		AND SZJ.ZJ_CLASSIF IN ('1','2','3') "	 		//-- 1=Suporte N1;2=Suporte N2;3=Suporte N3;4=Melhoria  
			cQuery1 	+= "      AND SZJ.ZJ_DT_INC <= '"+_nDtWF1+"'"
			cQuery1 	+= "		AND SZJ.D_E_L_E_T_ = '' "		
			cQuery1 	+= " ORDER BY SZJ.ZJ_DT_INC,SZJ.ZJ_HR_INC "	

		elseIf i == 2   // 

		   _cTipo 	:= " Em Atendimento - Sem Intera็๕es a 5 dias"			
			cQuery1 	:= " SELECT * FROM "+ RetSqlName("SZJ")+" SZJ  "
			cQuery1 	+= " LEFT JOIN SZK010 SZK "     		   	
			cQuery1 	+= "     ON ZJ_NUMCHAM+ZJ_QTDINTE=ZK_NUMCHAM+ZK_NUMINTE "     		   				
			cQuery1 	+= " WHERE 	 SZJ.ZJ_SITUAC NOT IN ('C','R') "     		//-- T=Aguardando Tecnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado
			cQuery1 	+= "		AND SZJ.ZJ_STATUS IN ('A') "        			//-- P=Chamado Novo;A=Em Atendimento;F=Fechado 
			cQuery1 	+= "      AND SZK.ZK_DT_INC <= '"+_nDtWF2+"'"
			cQuery1 	+= "		AND SZJ.D_E_L_E_T_ = '' "		
			cQuery1 	+= "		AND SZK.D_E_L_E_T_ = '' "					
			cQuery1 	+= " ORDER BY SZJ.ZJ_DT_INC,SZJ.ZJ_HR_INC "	

		elseIf i == 3   // MENSAL
  
		   _cTipo	:= " Melhorias em Aberto"			
			cQuery1 	:= " SELECT * FROM "+ RetSqlName("SZJ")+" SZJ  "
			cQuery1 	+= " WHERE 	 SZJ.ZJ_SITUAC NOT IN ('C','R') "        	//-- T=Aguardando Tecnico;S=Aguardando Solicitante;R=Resolvido;C=Cancelado
			cQuery1 	+= "		AND SZJ.ZJ_CLASSIF  IN ('4') "	 				//-- 1=Suporte N1;2=Suporte N2;3=Suporte N3;4=Melhoria  
			cQuery1 	+= "		AND SZJ.D_E_L_E_T_ = '' "		
			cQuery1 	+= " ORDER BY SZJ.ZJ_DT_INC,SZJ.ZJ_HR_INC "	
		endif		
		 
		cQuery1 := ChangeQuery(cQuery1)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TRB1",.T.,.T.)
	
		DbSelectArea("TRB1")
	
		_cTabProd		:= ""
		_nTotal			:= 0
		
		do While  !TRB1->( EOF() )
			_nTotal++
			
	      _dInclusao	:= DtoC(StoD(TRB1->ZJ_DT_INC))
	      _cChamado	:= TRB1->ZJ_NUMCHAM
	      _cSolicit	:= TRB1->ZJ_NOMESOL
	      _cStatus		:= "-"
	      _cClassif	:= "-"
	      _cSituac		:= "-"
	      _cAssunto	:= TRB1->ZJ_ASSUNTO
	
			// Status
			if     TRB1->ZJ_STATUS == "P"
		      _cStatus		:= "Chamado Novo"
			elseif TRB1->ZJ_STATUS == "A"
		      _cStatus		:= "Em Atendimento"
			elseif TRB1->ZJ_STATUS == "F"
		      _cStatus		:= "Fechado"
			endif	 
			
			// Classificacao   
		   if     TRB1->ZJ_CLASSIF == "N" 
		      _cClassif		:= "Nao Classificado"
			elseif TRB1->ZJ_CLASSIF == "1"
		      _cClassif		:= "Suporte N1"
			elseif TRB1->ZJ_CLASSIF == "2"
		      _cClassif		:= "Suporte N2"
			elseif TRB1->ZJ_CLASSIF == "3"
		      _cClassif		:= "Suporte N3"		      
			elseif TRB1->ZJ_CLASSIF == "4"
		      _cClassif		:= "Melhoria"
			endif	
	   
	 		// Situacao   
		   if     TRB1->ZJ_SITUAC == "T"    
		      _cSituac		:= "Aguardando Tecnico"
			elseif TRB1->ZJ_SITUAC == "S"
		      _cSituac		:= "Aguardando Solicitante"
			elseif TRB1->ZJ_SITUAC == "R"
		      _cSituac		:= "Resolvido"
			elseif TRB1->ZJ_SITUAC == "R"
		      _cSituac		:= "Cancelado"	      
			endif	

			if i == 2
				_cStatus	:= " Intera็ใo em " + dtoc(stod(TRB1->ZK_DT_INC))
			endif
			
			_cTabProd	+= ' <table style="text-align: left; width: 811px; height: 60px; background-color: white;" border="1" cellpadding="2" cellspacing="2"> '
			_cTabProd	+= '   <tbody> '
			_cTabProd	+= '     <tr> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 70px;"><small>'+_dInclusao+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 75px;"><small>'+_cChamado+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 112px;"><small>'+_cSolicit+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 107px;"><small>'+_cStatus+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 110px;"><small>'+_cClassif+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 81px;"><small>'+_cSituac+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '       <td style="vertical-align: top; width: 196px;"><small>'+_cAssunto+'<br /> '
			_cTabProd	+= '       </small></td> '
			_cTabProd	+= '     </tr> '
			_cTabProd	+= '   </tbody> '
			_cTabProd	+= ' </table> '
	
			dbSkip()
	
		Enddo
		

		If _nTotal > 0
		   _cTexto			:= "Total de Chamados : " + str(_nTotal)
	   else
		   _cTexto			:= "Nใo Existem itens para Listar..."	   
		endif


		// Se o Relatorio for Mensal e o dia nao for 01, nao processa.		
		if i == 3   .and. Day(date()) <> 1
			Exit	
		endif

	
		// Cria Diretorio Local para HTML
		cPath:="C:\DOMEX"
	
		c_FileOrig:="\WORKFLOW\MODELOS\WF_Chamados1.html"
		c_FileDest:="\WORKFLOW\MODELOS\WF_Chamados1.html"
			
		// Dados para Gerar Email
		_cPara		:= GETMV("MV_XWKCHAM") //  
			if  i == 1  //  Novos Diario  - Adiciona Jose
				//_cPara +=  ";"
			endif
		_cTitMail	:= "DOMEX - Chamados-"+ _cTipo 
		c_texto		:= ""
		cArquivo 	:= ""
	  							
		fArq(c_FileOrig, c_FileDest)  // Retorna cTexto
	
		_cCopyPC		:= ""
		U_EnvMailto(_cTitMail,c_texto,_cPara,_cCopyPC,cArquivo)	
	
	Next i
	

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
