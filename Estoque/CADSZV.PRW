#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZv    บAutor  ณHelio Ferreira      บ Data ณ  28/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Amarra็ใo Produto x Documentos                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSZV()

Local aCores       := {}
Private nFCICalc   := SuperGetMV("MV_FCICALC",.F.,0)

DbSelectArea("SZV")
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
//AADD(aRotina,{ "Incluir       ",'U_SZEINCLUI'  , 0, 3 } )
AADD(aRotina,{ "Incluir         ",'AxInclui'     , 0, 3 } )
//AADD(aRotina,{ "Excluir       ",'U_SZEDELETA'  , 0, 5 } )
AADD(aRotina,{ "Excluir         ",'AxDeleta'     , 0, 5 } )
//AADD(aRotina,{ "Alterar       ",'U_SZEALTERA'  , 0, 3 } )
AADD(aRotina,{ "Alterar         ",'AxAltera'     , 0, 4 } )

cCadastro := "CADSZV - Amarra็ใo de Produto x Documentos Domex"

mBrowse( 6, 1,22,75,"SZV",,,,,,aCores              ,,,,,,,,)  // "U_CADSZETOK()" )

//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

Return

User Function SZVINCLUI()
Local nOK
Local lChkMov := .f.

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui("SZE"    , 0     , 3     ,        ,        ,        , "U_CADSZETOK()" )

If nOk == 1
	
	Reclock("SZE",.F.)
	SZE->ZE_DATA := DATE()
	SZE->ZE_HORA := Time()
	SZE->( msUnlock() )
	/*
	SB1->( dbSeek( xFilial() + SZE->ZE_PRODUTO ) )
	
	Private _cDoc	     := U_NEXTDOC()  //GetSxENum("SD3","D3_DOC",1)
	PRIVATE lMSHelpAuto := .t. // para mostrar os erro na tela
	PRIVATE lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e' que deu erro
	
	_aAuto := {}
	aadd(_aAuto,{_cDoc,Date()})
	
	_aItem := {}
	aadd(_aItem,SZE->ZE_PRODUTO)        //Produto Origem
	aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
	aadd(_aItem,SB1->B1_UM)  	         //UM Origem
	aadd(_aItem,cLocProcDom  )          //Local Origem
	aadd(_aItem,'97PROCESSO')	         //Endereco Origem
	aadd(_aItem,SZE->ZE_PRODUTO)        //Produto Destino
	aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
	aadd(_aItem,SB1->B1_UM)  	         //UM destino
	aadd(_aItem,'11')                   //Local Destino
	aadd(_aItem,'CQ')	            	   //Endereco Destino
	aadd(_aItem,"")                     //Numero Serie
	aadd(_aItem,'LOTE1308')             //Lote Origem
	aadd(_aItem,"")         	         //Sub Lote Origem
	aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Origem
	aadd(_aItem,0)		                  //Potencia
	aadd(_aItem,SZE->ZE_QTDORI )   	   //Quantidade
	aadd(_aItem,0)		                  //Quantidade 2a. unidade
	aadd(_aItem,"")   	               //ESTORNO
	aadd(_aItem,"")         	         //NUMSEQ
	aadd(_aItem,'LOTE1308')             //Lote Destino
	aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Destino
	aadd(_aItem,"")		               //D3_ITEMGRD
	aadd(_aItem,0)                      //D3_PERIMP
	If GetVersao(.F.,.F.) == "12"
	aAdd(_aItem,"")   //D3_IDDCF
	aAdd(_aItem,"")   //D3_OBSERVACAO
	EndIf
	aadd(_aAuto,_aItem)
	
	SB2->( dbSetOrder(1) )
	If SB2->( dbSeek( xFilial() + SZE->ZE_PRODUTO + cLocProcDom ) )
	aAreaSB2 := SB2->( GetArea() )
	nB2_QEMP := SB2->B2_QEMP
	
	Reclock("SB2",.F.)
	SB2->B2_QEMP := 0
	SB2->( MsUnlock() )
	
	aAreaSB1    := SB1->( GetArea() )
	cB1_MSBLQL  := SB1->B1_MSBLQL
	
	If SB1->B1_MSBLQL == '1'
	Reclock("SB1",.F.)
	SB1->B1_MSBLQL := '2'
	SB1->( msUnlock() )
	EndIf
	
	// Inicio MarteLopus
	cQuery := "SELECT MAX(R_E_C_N_O_) AS R_E_C_N_O_ FROM SD3010 WHERE "
	cQuery += "D3_COD = '"+SZE->ZE_PRODUTO+"' AND D3_CF = 'RE4' AND D3_LOCAL = '97' AND D_E_L_E_T_ = '' AND D3_ESTORNO = '' AND D3_NUMSEQ IN "
	cQuery += "(SELECT D3_NUMSEQ FROM SD3010 WHERE D3_COD = '"+SZE->ZE_PRODUTO+"' AND D3_CF = 'DE4' AND D3_LOCAL = '11' AND D_E_L_E_T_ = '') "
	
	If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TEMP"
	
	NRECNO1 := TEMP->R_E_C_N_O_
	
	MSExecAuto({|x,y| mata261(x,y)},_aAuto,3)  // Execauto de transfer๊ncia do 97 para o 11
	
	cQuery := "SELECT MAX(R_E_C_N_O_) AS R_E_C_N_O_ FROM SD3010 WHERE "
	cQuery += "D3_COD = '"+SZE->ZE_PRODUTO+"' AND D3_CF = 'RE4' AND D3_LOCAL = '97' AND D_E_L_E_T_ = '' AND D3_ESTORNO = '' AND D3_NUMSEQ IN "
	cQuery += "(SELECT D3_NUMSEQ FROM SD3010 WHERE D3_COD = '"+SZE->ZE_PRODUTO+"' AND D3_CF = 'DE4' AND D3_LOCAL = '11' AND D_E_L_E_T_ = '') "
	
	If Select("TEMP") <> 0
	TEMP->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TEMP"
	
	NRECNO2 := TEMP->R_E_C_N_O_
	
	// Fim Martelopus
	
	RestArea(aAreaSB1)
	
	If SB1->B1_MSBLQL <> cB1_MSBLQL
	Reclock("SB1",.F.)
	SB1->B1_MSBLQL := cB1_MSBLQL
	SB1->( msUnlock() )
	EndIf
	
	RestArea(aAreaSB2)
	Reclock("SB2",.F.)
	SB2->B2_QEMP := nB2_QEMP
	SB2->( MsUnlock() )
	
	If NRECNO1 == NRECNO2  //lMSErroAuto
	Mostraerro()
	
	If "DENIS" $ Upper(Subs(cUsuario,7,14))
	MsgAlert("Administrador, nใo foi possํvel fazer a tranfer๊ncia. Favor transferir manualmente " +Alltrim(Transform(SZE->ZE_QTDORI,"@E 999,999,999.9999"))+ " do produto " +Alltrim(SZE->ZE_PRODUTO)+ " lote 1308 do 97 para o 11 ou excluir este registro de perda.")
	
	If MsgYesNo("Deseja imprimir a etiqueta?")
	Etiqueta()
	EndIf
	Else
	Reclock("SZE",.F.)
	SZE->( dbDelete() )
	SZE->( msUnlock() )
	
	MsgStop("Nใo foi possํvel lan็ar esta perda.")
	EndIf
	
	//lMsErroAuto  _cDoc
	Else
	
	SD3->( dbGoTo(NRECNO2) )
	_cDoc := SD3->D3_DOC
	
	SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
	If SD3->( dbSeek( xFilial() + _cDoc ) )
	While !SD3->( EOF() ) .and. SD3->D3_DOC == _cDoc
	If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
	Reclock("SD3",.F.)
	SD3->D3_XXOP    := SZE->ZE_OP
	SD3->D3_HORA    := Time()
	SD3->( msUnlock() )
	EndIf
	SD3->( dbSkip() )
	End
	EndIf
	
	If MsgYesNo("Deseja imprimir a etiqueta?")
	Etiqueta()
	EndIf
	EndIf
	
	Else
	MsgStop("SB2 nใo encontrado!!!")
	EndIf
	*/
	
	If SB1->( dbSeek( xFilial() + SZE->ZE_PRODUTO ) )
		_aAuto := {}
		
		// Relacionando os lotes disponํvens para devolu็ใo/perda da OP
		aLotes   := {}
		nTotDisp := 0
		SD3->( dbSetOrder(1) )
		SD5->( dbSetOrder(3) )  // D5_NUMSEQ
		If SD3->( dbSeek( xFilial() + SZE->ZE_OP + SZE->ZE_PRODUTO + cLocProcDom ) )
			While !SD3->( EOF() ) .and. SD3->D3_FILIAL == xFilial("SD3") .and. Subs(SZE->ZE_OP,1,11) + SZE->ZE_PRODUTO + cLocProcDom == Subs(SD3->D3_OP,1,11) + SD3->D3_COD + SD3->D3_LOCAL
				If Empty(SD3->D3_ESTORNO)
					If SD5->( dbSeek( xFilial() + SD3->D3_NUMSEQ ) )
						_nPos    := aScan(aLotes, { |aVet| aVet[2] == SD5->D5_LOTECTL } )
						_nSinal  := If(SD3->D3_TM < '500',1,-1)
						nTotDisp += (SD5->D5_QUANT * _nSinal)
						
						If Empty(_nPos)
							AADD(aLotes,{SD5->D5_PRODUTO, SD5->D5_LOTECTL, SD5->D5_QUANT * _nSinal} )
						Else
							aLotes[_nPos,3] += (SD5->D5_QUANT * _nSinal)
						EndIf
					Else
						MsgStop('Numseq do SD3 nใo encontrado no SD5!')
					EndIf
				EndIf
				SD3->( dbSkip() )
			End
		EndIf
		
		SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD + D3_LOCAL
		SUMD3QTD1 := 0
		If SD3->( dbSeek( xFilial() + SZE->ZE_OP + '  ' + SZE->ZE_PRODUTO  ) )
			While !SD3->( EOF() ) .and. SZE->ZE_OP + '  ' + SZE->ZE_PRODUTO == SD3->D3_XXOP + SD3->D3_COD
				If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
					If SD5->( dbSeek( xFilial() + SD3->D3_NUMSEQ ) )
						_nPos   := aScan(aLotes, { |aVet| aVet[2] == SD5->D5_LOTECTL } )
						_nSinal := If(SD3->D3_TM < '500',1,-1)
						nTotDisp += (SD5->D5_QUANT * _nSinal)
						
						If Empty(_nPos)
							AADD(aLotes,{SD5->D5_PRODUTO, SD5->D5_LOTECTL, SD5->D5_QUANT * _nSinal} )
						Else
							aLotes[_nPos,3] += (SD5->D5_QUANT * _nSinal)
						EndIf
					Else
						MsgStop('Numseq do SD3 nใo encontrado no SD5!')
					EndIf
				EndIf
				SD3->( dbSkip() )
			End
		EndIf
		
		
		If SZE->ZE_QTDORI > nTotDisp
			MsgStop('Quantidade superior a disponํvel em processo para esta OP.')
			_Retorno := .F.
		Else
			
			nTotTrans := SZE->ZE_QTDORI
			
			For x := 1 to Len(aLotes)
				If nTotTrans > 0
					Private _cDoc := SZE->ZE_DOCUMEN // U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
					_cDoc :=_cDoc+SPACE(09)          //DOCUMENTO 9 DIGITOS
					_cDoc := SUBSTR(_cDoc,1,9)
					
					PRIVATE lMSHelpAuto := .t. // para mostrar os erro na tela
					PRIVATE lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e' que deu erro
					
					_aAuto := {}
					aadd(_aAuto,{_cDoc,dDataBase})
					
					_aItem := {}
					aadd(_aItem,SZE->ZE_PRODUTO)          //Produto Origem
					aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
					aadd(_aItem,SB1->B1_UM)  	         //UM Origem
					aadd(_aItem,cLocProcDom)            //Local Origem
					aadd(_aItem,"97PROCESSO")	    	   //Endereco Origem
					aadd(_aItem,SZE->ZE_PRODUTO)          //Produto Destino
					aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
					aadd(_aItem,SB1->B1_UM)  	         //UM destino
					aadd(_aItem,'11')                   //Local Destino
					aadd(_aItem,'CQ')	            	   //Endereco Destino
					aadd(_aItem,"")                     //Numero Serie
					aadd(_aItem,aLotes[x,2])	         //Lote Origem
					aadd(_aItem,"")         	         //Sub Lote Origem
					aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Origem
					aadd(_aItem,0)		                  //Potencia
					
					If nTotTrans <= aLotes[x,3]
						aadd(_aItem,nTotTrans)       	   //Quantidade
						_nQtd := nTotTrans
						nTotTrans := 0
					Else
						aadd(_aItem,aLotes[x,3])    	   //Quantidade
						_nQtd := aLotes[x,3]
						nTotTrans -= aLotes[x,3]
					EndIf
					
					aadd(_aItem,0)		                  //Quantidade 2a. unidade
					aadd(_aItem,"")   	               //ESTORNO
					aadd(_aItem,"")         	         //NUMSEQ
					aadd(_aItem,aLotes[x,2])   	      //Lote Destino
					aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Destino
					aadd(_aItem,"")		               //D3_ITEMGRD
					If nFCICalc == 1
						aadd(_aItem,0)                   //D3_PERIMP
					ENDIF
					If GetVersao(.F.,.F.) == "12"
						//aAdd(_aItem,"")   //D3_IDDCF
						aAdd(_aItem,"")   //D3_OBSERVACAO
					EndIf
					aadd(_aAuto,_aItem)
					
					SB2->( dbSetOrder(1) )
					If SB2->( dbSeek( xFilial() + SZE->ZE_PRODUTO + cLocProcDom) )
						aAreaSB2 := SB2->( GetArea() )
						nB2_QEMP := SB2->B2_QEMP
						
						Reclock("SB2",.F.)
						SB2->B2_QEMP := 0
						SB2->( MsUnlock() )
						
						MSExecAuto({|x,y| mata261(x,y)},_aAuto,3)  // Execauto de transfer๊ncia para o 97
						
						RestArea(aAreaSB2)
						Reclock("SB2",.F.)
						SB2->B2_QEMP := nB2_QEMP
						SB2->( MsUnlock() )
					Else
						MsgStop('Produto nใo encontrado no SB2 do Local SB2.')
					EndIf
					
					If lMsErroAuto
						Mostraerro()
						If "DENIS" $ Upper(Subs(cUsuario,7,14))
							MsgAlert("Administrador, nใo foi possํvel fazer a tranfer๊ncia. Favor transferir manualmente " +Alltrim(Transform(SZE->ZE_QTDORI,"@E 999,999,999.9999"))+ " do produto " +Alltrim(SZE->ZE_PRODUTO)+ " lote 1308 do 97 para o 11 ou excluir este registro de perda.")
							If MsgYesNo("Deseja imprimir a etiqueta?")
								Etiqueta()
							EndIf
						Else
							Reclock("SZE",.F.)
							SZE->( dbDelete() )
							SZE->( msUnlock() )
							
							MsgStop("Nใo foi possํvel lan็ar esta perda.")
						EndIf
						
					Else
						SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
						If SD3->( dbSeek( xFilial() + _cDoc ) )
							While !SD3->( EOF() ) .and. SD3->D3_DOC == _cDoc
								If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
									If SD3->D3_COD == SZE->ZE_PRODUTO
										If SD3->D3_EMISSAO == dDataBase
											If SD3->D3_QUANT == _nQtd
												If Empty(SD3->D3_XXOP)
													
													Reclock("SD3",.F.)
													SD3->D3_XXOP    := SZE->ZE_OP
													SD3->D3_HORA    := Time()
													SD3->( msUnlock() )   
													
												EndIf
												If !lCHkMov
													//VERIFICA INTEGRIDADE DOS MOVIMENTOS 
													lCHkMov := U_CHKMOV(SD3->D3_COD, SD3->D3_NUMSEQ, SD3->( Recno()), "T")
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
								SD3->( dbSkip() )
							End
						EndIf
						If MsgYesNo("Deseja imprimir a etiqueta?")
							Etiqueta()
						EndIf
					EndIf
				EndIf
				lChkMov := .f.
			Next x
		EndIf
	EndIf
EndIf

Return
//----------------------------------------------------------

//User Function fReImp()

//Return

//------------------------------------------------------------


//User Function fLegenda()

/*
1 (vermelha) Etiqueta de Pr้-NF nใo classificada

2 (preta)    Etiqueta de NF classificada e em CQ

3 (amarela)  Etiqueta de NF Classificada, liberada pelo CQ e com pend๊ncia de Endere็amento

4 (verde)    Etiqueta endere็ada e pronta para uso

5 (cinza)    Material jแ utilizado
*/

BrwLegenda("","Legenda",{;
{"DISABLE"    ,"Etiqueta de Pr้-NF nใo classificada"                                            },;  // 1
{"BR_PRETO"   ,"Etiqueta de NF classificada e em CQ"                                            },;  // 2
{"BR_AMARELO" ,"Etiqueta de NF Classificada, liberada pelo CQ e com pend๊ncia de Endere็amento" },;  // 3
{"ENABLE"     ,"Etiqueta endere็ada e pronta para uso"                                          },;  // 4
{"BR_AZUL"    ,"Material jแ utilizado"                                                          }}) // 5


/*{"BR_AMARELO","Reimpressa"   },;  // 2*/
//SX3-->1=Impresso;2=Reimpresso;3=Nao Impresso;4=Excluido;5=Avulsa;6=Armazenado;7=Consumido

//Return

User Function INIZV_DOC()

Return "000001"

Static Function Etiqueta()
Local _cPorta    := "LPT1"
Local _aAreaGER  := GetArea()

Reclock("SZE",.F.)
SZE->ZE_DATA := DATE()
SZE->ZE_HORA := Time()
SZE->( msUnlock() )

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

//If SZE->ZE_TIPO == 'P'
//   MSCBSay(28,01,"PAGAMENTO: PERDA PRODUวรO","N","3","1,1")
//EndIf

//If SZE->ZE_TIPO == 'F'
MSCBSay(28,01,"PAGAMENTO: PERDA FORNECEDOR","N","3","1,1")
//EndIf

//If SZE->ZE_TIPO == 'C'
//   MSCBSay(28,01,"PAGAMENTO: MATERIAL CONSUMO","N","3","1,1")
//EndIf

//If SZE->ZE_TIPO == 'E'
//   MSCBSay(28,01,"PAGAMENTO: ENGENHARIA","N","3","1,1")
//EndIf

n := 3
// 01
MSCBSay(28,01+n,"DATA:"+DtoC(SZE->ZE_DATA)+" HORA:"+SZE->ZE_HORA+Space(10)+Transform(SZE->ZE_SALDO,"@E 999,999.99"),"N","2","1,1")
//03
MSCBSay(28,03+n,"OPERA.:"+SZE->ZE_OPERADO+" QTD:"+Transform(SZE->ZE_SALDO,"@E 999,999.99"),"N","2","1,1")
//05
MSCBSay(28,05+n,"PRODUTO: "+Alltrim(SZE->ZE_PRODUTO)+" "+Alltrim(SZE->ZE_DESC),"N","2","1,1")

//MSCBSayBar - Imprime c๓digo de barras ( nXmm nYmm cConteudo cRota็ใo cTypePrt [ nAltura ] [ *lDigver ] [ lLinha ] [ *lLinBaixo ] [ cSubSetIni ]      [ nLargura ] [ nRelacao ] [ lCompacta ] [ lSerial ] [ cIncr ] [ lZerosL ] )
//07
MSCBSayBar(31,07+n,SZE->ZE_DOCUMEN,"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)
//18
MSCBSay(46,18+n,"OP: "+SZE->ZE_OP,"N","2","1,1")

MSCBEnd()

MSCBClosePrinter()

RestArea(_aAreaGER)


/*
MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)
MSCBSay(28,01,"ALMOXARIFADO :"+SBE->BE_LOCAL,"N","2","1,1")
MSCBSay(28,03,"ENDERECO :"+SBE->BE_LOCALIZ,"N","2","1,1")
MSCBSayBar(27,06,SBE->BE_LOCAL+SubStr(SBE->BE_LOCALIZ,1,13),"N","MB07",10,.F.,.T.,.F.,,2,1,Nil,Nil,Nil,Nil)
MSCBEnd()
MSCBClosePrinter()
*/

Return

User Function SZVALTERA()

nOK := AxAltera("SZE",0,4)

If nOk == 1
	Reclock("SZE",.F.)
	SZE->ZE_DATA := DATE()
	SZE->ZE_HORA := Time()
	SZE->( msUnlock() )
	
	If MsgYesNo("Deseja imprimir a etiqueta?")
		Etiqueta()
	EndIf
EndIf

Return

User Function SZVREIMP()

If MsgYesNo("Deseja imprimir a etiqueta?")
	Etiqueta()
EndIf

Return

User Function SZVDELETA()

If SZE->ZE_SALDO == 0
	MsgStop("Perda com pagamento jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
Else
	If SZE->ZE_QTDORI <> SZE->ZE_SALDO
		MsgStop("Perda com pagamento parcial jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
	Else
		RegToMemory("SZE",.F.)
		AxDeleta("SZE"  , SZE->( Recno() )     , 5    )
	EndIf
EndIf

Return

User Function CADSZVTOK()
Local _Retorno := .F.
Local aAreaGER := GetArea()

If !Empty(M->ZE_OP)
	_Retorno := .T.
Else
	MsgStop("Para apontamentos do tipo Perda de Fornecedor, ้ obrigat๓rio informar a OP.")
	_Retorno := .F.
EndIf

If _Retorno
	If SB1->( dbSeek( xFilial() + M->ZE_PRODUTO ) )
		_aAuto := {}
		
		// Relacionando os lotes disponํvens para devolu็ใo/perda da OP
		aLotes   := {}
		nTotDisp := 0
		SD3->( dbSetOrder(1) )
		SD5->( dbSetOrder(3) )  // D5_NUMSEQ
		If SD3->( dbSeek( xFilial() + M->ZE_OP + M->ZE_PRODUTO + cLocProcDom ) )
			While !SD3->( EOF() ) .and. SD3->D3_FILIAL == xFilial("SD3") .and. Subs(M->ZE_OP,1,11) + M->ZE_PRODUTO + cLocProcDom == Subs(SD3->D3_OP,1,11) + SD3->D3_COD + SD3->D3_LOCAL
				If Empty(SD3->D3_ESTORNO)
					If SD5->( dbSeek( xFilial() + SD3->D3_NUMSEQ ) )
						_nPos    := aScan(aLotes, { |aVet| aVet[2] == SD5->D5_LOTECTL } )
						_nSinal  := If(SD3->D3_TM < '500',1,-1)
						nTotDisp += (SD5->D5_QUANT * _nSinal)
						
						If Empty(_nPos)
							AADD(aLotes,{SD5->D5_PRODUTO, SD5->D5_LOTECTL, SD5->D5_QUANT * _nSinal} )
						Else
							aLotes[_nPos,3] += (SD5->D5_QUANT * _nSinal)
						EndIf
					Else
						MsgStop('Numseq do SD3 nใo encontrado no SD5!')
					EndIf
				EndIf
				SD3->( dbSkip() )
			End
		EndIf
		
		SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD + D3_LOCAL
		SUMD3QTD1 := 0
		If SD3->( dbSeek( xFilial() + M->ZE_OP + '  ' + M->ZE_PRODUTO  ) )
			While !SD3->( EOF() ) .and. M->ZE_OP + '  ' + M->ZE_PRODUTO == SD3->D3_XXOP + SD3->D3_COD
				If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
					If SD5->( dbSeek( xFilial() + SD3->D3_NUMSEQ ) )
						_nPos   := aScan(aLotes, { |aVet| aVet[2] == SD5->D5_LOTECTL } )
						_nSinal := If(SD3->D3_TM < '500',1,-1)
						nTotDisp += (SD5->D5_QUANT * _nSinal)
						
						If Empty(_nPos)
							AADD(aLotes,{SD5->D5_PRODUTO, SD5->D5_LOTECTL, SD5->D5_QUANT * _nSinal} )
						Else
							aLotes[_nPos,3] += (SD5->D5_QUANT * _nSinal)
						EndIf
					Else
						MsgStop('Numseq do SD3 nใo encontrado no SD5!')
					EndIf
				EndIf
				SD3->( dbSkip() )
			End
		EndIf
		
		
		If M->ZE_QTDORI > nTotDisp
			MsgStop('Quantidade superior a disponํvel em processo para esta OP.')
			_Retorno := .F.
		Else
			
			nTotTrans := M->ZE_QTDORI
			
			/*
			For x := 1 to Len(aLotes)
			If nTotTrans > 0
			Private _cDoc	     := U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
			PRIVATE lMSHelpAuto := .t. // para mostrar os erro na tela
			PRIVATE lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e' que deu erro
			
			_aAuto := {}
			aadd(_aAuto,{_cDoc,dDataBase})
			
			_aItem := {}
			aadd(_aItem,M->ZE_PRODUTO)          //Produto Origem
			aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
			aadd(_aItem,SB1->B1_UM)  	         //UM Origem
			aadd(_aItem,cLocProcDom)            //Local Origem
			aadd(_aItem,"97PROCESSO")	    	   //Endereco Origem
			aadd(_aItem,M->ZE_PRODUTO)          //Produto Destino
			aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
			aadd(_aItem,SB1->B1_UM)  	         //UM destino
			aadd(_aItem,'11')                   //Local Destino
			aadd(_aItem,'CQ')	            	   //Endereco Destino
			aadd(_aItem,"")                     //Numero Serie
			aadd(_aItem,aLotes[x,2])	         //Lote Origem
			aadd(_aItem,"")         	         //Sub Lote Origem
			aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Origem
			aadd(_aItem,0)		                  //Potencia
			
			If nTotTrans <= aLotes[x,3]
			aadd(_aItem,nTotTrans)       	   //Quantidade
			nTotTrans := 0
			Else
			aadd(_aItem,aLotes[x,3])    	   //Quantidade
			nTotTrans -= aLotes[x,3]
			EndIf
			
			aadd(_aItem,0)		                  //Quantidade 2a. unidade
			aadd(_aItem,"")   	               //ESTORNO
			aadd(_aItem,"")         	         //NUMSEQ
			aadd(_aItem,aLotes[x,2])   	      //Lote Destino
			aadd(_aItem,CtoD("31/12/49"))	      //Validade Lote Destino
			aadd(_aItem,"")		               //D3_ITEMGRD
			aadd(_aItem,0)                      //D3_PERIMP
			If GetVersao(.F.,.F.) == "12"
			aAdd(_aItem,"")   //D3_IDDCF
			aAdd(_aItem,"")   //D3_OBSERVACAO
			EndIf
			aadd(_aAuto,_aItem)
			
			SB2->( dbSetOrder(1) )
			If SB2->( dbSeek( xFilial() + M->ZE_PRODUTO + cLocProcDom) )
			aAreaSB2 := SB2->( GetArea() )
			nB2_QEMP := SB2->B2_QEMP
			
			Reclock("SB2",.F.)
			SB2->B2_QEMP := 0
			SB2->( MsUnlock() )
			
			MSExecAuto({|x,y| mata261(x,y)},_aAuto,3)  // Execauto de transfer๊ncia para o 97
			
			RestArea(aAreaSB2)
			Reclock("SB2",.F.)
			SB2->B2_QEMP := nB2_QEMP
			SB2->( MsUnlock() )
			Else
			MsgStop('Produto nใo encontrado no SB2 do Local SB2.')
			EndIf
			
			If lMsErroAuto
			MostraErro()
			Else
			
			EndIf
			EndIf
			Next x
			*/
		EndIf
	EndIf
EndIf

RestArea(aAreaGER)

Return _Retorno
