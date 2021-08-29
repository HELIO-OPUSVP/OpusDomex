#INCLUDE "TOPCONN.CH"

User Function EICPO400()

//MsgInfo("User Function EICPO400() ")
lTelaSi:=.f.

Do Case
	
	//    Case ParamIXB == "GRAVA_PO_PC" //tratamentos customizados
	Case ParamIXB == "Work_SI" //adição de campos na work que será usada para exibir os dados da S.I. de referência
		//AAdd(aSemSX3, {"W0_COMPRA", "C", 3, 0})
		AAdd(aSemSX3, {"W1_COD_I"   , "C", 15, 0})
		AAdd(aSemSX3, {"W1_DESCR"   , "C", 30, 0})
		AAdd(aSemSX3, {"W1_POSICAO" , "C", 05, 0})
		AAdd(aSemSX3, {"W1_QTDE"    , "N", 15, 2})
		AAdd(aSemSX3, {"W1_FORN"    , "C", 06, 0})
		AAdd(aSemSX3, {"W1_FORLOJ"  , "C", 02, 0})
  Case ParamIXB == "TB_Campos_SI" //campos que serão exibidos ao clicar no botão "S.I. de Referência"
	// AAdd(Tb_Campos_temp, {{|| Work_SI->W0_COMPRA },, "COMPRADOR"})
		AAdd(Tb_Campos_temp, {{|| Work_SI->W1_COD_I  },, "PRODUTO"})
		AAdd(Tb_Campos_temp, {{|| Work_SI->W1_DESCR  },, "DESCRICAO"})
		AAdd(Tb_Campos_temp, {{|| Work_SI->W1_POSICAO},, "POSICAO"})
		AAdd(Tb_Campos_temp, {{|| Work_SI->W1_QTDE   },, "QTDE"})
		AAdd(Tb_Campos_temp, {{|| Work_SI->W1_FORN   },, "FORNECEDOR"})
		AAdd(Tb_Campos_temp, {{|| Work_SI->W1_FORLOJ },, "LOJA"})
		
		//   Case ParamIXB == "GRAVA_WORK_SI" //informação a ser gravada no campo adicional
		//       Work_SI->W1_COD_I   := SW0->W0_COMPRA
		//       Work_SI->W1_DESCR   := SW0->W0_
		//       Work_SI->W1_POSICAO := SW0->W0_
		//       Work_SI->W1_QTDE    := SW0->W0_
		//       Work_SI->W1_FORN    := SW0->W0_
		//       Work_SI->W1_FORLOJ  := SW0->W0_
		//   Case ParamIXB == "SelecionaSI" //Define se a tela será aberta.
		//       MsgInfo("SELECIONASI .f.")
		//       Return .f. //Define se a tela não será aberta
		//   Case ParamIXB == "DEPOIS_ALTERA_INC_PO"
		//       If lDepoisAltIncPO
		//          MsgInfo("Operação de alteração confirmada!")
		//       Else
		//          MsgInfo("Operação de alteração cancelada!")
		//       Endif
		//   Case ValType(ParamIXB) == "A"
		//       cParam := ParamIXB[1]
		//   Case ParamIXB == "PO_PesqSI_Sel"
		//          MsgInfo("PO_PesqSI_Sel .t.")
		//          lLoop := .T.
		//       MSG
		//INFO("PONTO DE ENTRADA 'PO_PesqSI_Sel' ATIVO!")
		//Case ParamIXB == "VALID"
		//If cFlag == 'Saldo_Q'
		//MsgInfo("Entrou no ponto de entrada 'VALID'.")
		//Endif
		//   Case ParamIXB == "DEPOIS_GRAVA_INC_PO"
		//       If lDepoisGrvIncPO
		//          MsgInfo("Operação de gravação confirmada!")
		//       Else
		//          MsgInfo("Operação de gravação cancelada!")
		//       Endif
		//
		//Case PARAMIXB == "ALTERA_PO_POST"
		//MsgInfo("Entrou no ponto de entrada 'ALTERA_PO_POST'.")
		//lAltPOPost := .F.
		
		//IF(ExistBlock("EICPO400"),ExecBlock("EICPO400",.F.,.F.,"DESVIA_WORK_SI"),)
		
	Case ParamIXB == "DESVIA_WORK_SI"
		//MsgInfo("DESVIA_WORK_SI")
		IF !Inclui
			lDesvia=.T.
			OldArea:=SELECT()
			//cCPos:="SW1.W1_SI_NUM W1_SI_NUM "
			cCPos:="SW1.W1_SI_NUM  W1_SI_NUM  , "
			cCPos+="SW1.W1_COD_I   W1_COD_I   , "
			cCPos+="SW1.W1_POSICAO W1_POSICAO , "
			cCPos+="SW1.W1_QTDE    W1_QTDE    , "
			cCPos+="SW1.W1_FORN    W1_FORN    , "
			cCPos+="SW1.W1_FORLOJ  W1_FORLOJ    "
			
			cQuery:="SELECT DISTINCT "+cCpos+"  FROM "+ RetSQLName("SW1")+" SW1 WHERE "+;   // RS 13/08/07
			"SW1.W1_FILIAL  = '"+xFilial("SW1")+"' AND "+;
			"SW1.D_E_L_E_T_ <> '*' AND "+;
			"SW1.W1_CC = '"    +TCc    +"' AND "+;
			"SW1.W1_SEQ    > 0 AND  SW1.W1_SALDO_Q = 0"+ " AND "+;
			"SW1.W1_PO_NUM = '"  +M->W2_PO_NUM+"' AND "+;
			"(SW1.W1_FORN  = '"  +M->W2_FORN   +"' OR SW1.W1_FORN = '"+space(06)+"')"
			
			cQuery:=ChangeQuery(cQuery)
			TcQuery cQuery ALIAS "SW1NEW" NEW
			SW1NEW->(DBGOTOP())
			DO WHILE !SW1NEW->(EOF())
				
				SW0->(DBSEEK(xFilial()+TCC+SW1NEW->W1_SI_NUM))
				If !( Type("lPoAuto")=="L" .And. lPoAuto) //FSM - 17/05/2012
					IncProc("Processando S.I. nr. "+SW0->W0__NUM) //"Processando S.I. nr. "
				EndIf
				
				If EMPTY(ALLTRIM(SW0->W0_HAWB_DA))
					Work_SI->(DBAPPEND())
					Work_SI->W1_SI_NUM:=SW0->W0__NUM
					Work_SI->W0_C1_NUM:=SW0->W0_C1_NUM
					
					Work_SI->W1_COD_I   := SW1NEW->W1_COD_I
					Work_SI->W1_DESCR   := POSICIONE('SB1',1,xFILIAL('SB1')+SW1NEW->W1_COD_I,'B1_DESC')
					Work_SI->W1_POSICAO := SW1NEW->W1_POSICAO
					Work_SI->W1_QTDE    := SW1NEW->W1_QTDE
					Work_SI->W1_FORN    := SW1NEW->W1_FORN
					Work_SI->W1_FORLOJ  := SW1NEW->W1_FORLOJ
					
					Work_SI->TRB_ALI_WT:="SW0"
					Work_SI->TRB_REC_WT:=SW0->(Recno())
					
				EndIf
				
				SW1NEW->(DBSKIP())
				
			ENDDO
			
			SW1NEW->(DBCLOSEAREA())
			DBSELECTAREA(OldArea)
		ENDIF
EndCase
Return Nil
