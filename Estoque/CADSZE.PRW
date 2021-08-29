#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSZE    บAutor  ณMicrosiga           บ Data ณ  13/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perda de Fornecedores                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADSZE()

Local aCores := {;
{'ZE_SALDO==0' , 'DISABLE'    },;
{'ZE_SALDO<>0' , 'BR_VERDE'   } }

Private cLocProcDom := GetMV("MV_XXLOCPR")   // Local de Processos Domex

Private aEmpSB2   := {}
Private aEmpSBF   := {}
Private aEmpSB8   := {}
Private aSD4QUANT := {}
Private nFCICalc  := SuperGetMV("MV_FCICALC",.F.,0)
Private nOpc      := 0
Private lOkIn     := .f.
Private _cDoc     := ""

DbSelectArea("SZE")
aRotina := {}

AADD(aRotina,{ "Pesquisar       ",'AxPesqui'     , 0, 1 } )
AADD(aRotina,{ "Visualizar      ",'AxVisual'     , 0, 2 } )
AADD(aRotina,{ "Incluir         ",'U_SZEINCLUI'  , 0, 3 } )
AADD(aRotina,{ "Excluir         ",'U_SZEDELETA'  , 0, 5 } )
//AADD(aRotina,{ "Alterar       ",'U_SZEALTERA'  , 0, 3 } )   // Nใo pode voltar esta op็ใo por dar problema de saldo => H้lio
AADD(aRotina,{ "Reimprimir      ",'U_SZEREIMP'   , 0, 3 } )
AADD(aRotina,{ "Legenda         ",'U_fLegenda'   , 0, 3 } )

cCadastro := "CADSZE - Perdas geradas por falha de Fornecedores"

//SetKey(VK_F10, { || U_fReImp() } )

mBrowse( 6, 1,22,75,"SZE",,,,,,aCores              ,,,,,,,,)

//mBrowse( 6, 1,22,75,"SE2",,,,,, Fa040Legenda("SE2"),,,,,,,,IIF(ExistBlock("F080FILB"),ExecBlock("F080FILB",.f.,.f.),NIL))

//SetKey(VK_F10,Nil)

Return

User Function SZEINCLUI()
Local nOK
//Local lRet := .T.

nOpc       := 3

//     AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>        , <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
nOK := AxInclui("SZE"    , 0     , nOpc  ,        ,        ,        , "U_CADSZETOK()" )

If nOk == 1
	Reclock("SZE",.F.) 
	SZE->ZE_DOCUMENT := _cDoc
	SZE->ZE_DATA 	  := DATE()
	SZE->ZE_HORA     := Time()   	
	SZE->( msUnlock() )                  
	If lOkIn
		If MsgYesNo("Deseja imprimir a etiqueta?")
   		Etiqueta()
		EndIf
	EndIf
EndIf

Return

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

Return

User Function SZEREIMP()

If MsgYesNo("Deseja imprimir a etiqueta?")
	Etiqueta()
EndIf

Return

User Function SZEDELETA()

nOpc := 5

If SZE->ZE_SALDO == 0
	MsgStop("Perda com pagamento jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
Else
	If SZE->ZE_QTDORI <> SZE->ZE_SALDO
		MsgStop("Perda com pagamento parcial jแ efetuado. Nใo serแ possํvel excluir este apontamento.")
	Else
		RegToMemory("SZE",.F.)
		//AxDeleta( <cAlias>, <nReg>           , <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>        , <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)
		AxDeleta("SZE", SZE->( Recno()) ,nOpc,,"U_CADSZETOK()"  )
	EndIf
EndIf

Return

User Function CADSZETOK() // Valida็ใo

Local _Retorno := .T.
Local aAreaGER := GetArea()                                             
//Local cNumSeq  := ""
Local lChkMov := .f.

If nOpc == 3 // Inclusใo
	
	If SB1->( dbSeek( xFilial() + M->ZE_PRODUTO ) )
	
   	cNumLote    := Space(Len(SB8->B8_NUMLOTE))
		cLoteCtl    := U_RetLotC6(M->ZE_OP)
		cProduto    := M->ZE_PRODUTO
		cLocal      := "97"
		dData       := Date()+1
		cLocaliza   := Subs("97PROCESSO" + Space(30),1,Len(SBF->BF_LOCALIZ))
		cNumSerie   := Space(Len(SBF->BF_NUMSERI))
		aSaldo      := CalcEstL(cProduto, cLocal, dData,cLoteCtl,cNumLote,cLocaliza,cNumSerie,.T.)
		nSalDispB8  := aSaldo[1]
		
		SBF->( dbSetOrder(1) )
		If SBF->( dbSeek( xFilial() + cLocal + cLocaliza + cProduto + cNumSerie + cLoteCtl  ) )
			nSalDispBF := SBF->BF_QUANT
		Else
			nSalDispBF := 0
		EndIf
		
		If M->ZE_QTDORI > nSalDispBF
			_Retorno := .F.
			MsgStop('Quantidade ' + Alltrim(Str(M->ZE_QTDORI)) + ' superior ao saldo de '+Alltrim(Str(nSalDispBF))+' do lote '+Alltrim(cLoteCtl)+' do produto '+Alltrim(M->ZE_PRODUTO)+" no edere็o "+cLocaliza+" desta OP. Nใo foi possํvel apontar estar perda por falta de saldo por endere็o.")
		EndIf
		
		If M->ZE_QTDORI > nSalDispB8
			_Retorno := .F.
			MsgStop('Quantidade ' + Alltrim(Str(M->ZE_QTDORI)) + ' superior ao saldo de '+Alltrim(Str(nSalDispB8))+' do lote '+Alltrim(cLoteCtl)+' do produto '+Alltrim(M->ZE_PRODUTO)+" desta OP. Nใo foi possํvel apontar estar perda por falta de saldo por lote.")
		EndIf
		
		If _Retorno 
		//SZE->ZE_DOCUMENJONAS
			_cDoc :=  U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
			_cDoc :=_cDoc+SPACE(09)        //DOCUMENTO 9 DIGITOS
			_cDoc := SUBSTR(_cDoc,1,9)
 
			
			lMSHelpAuto := .t. // para mostrar os erro na tela
			lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e' que deu erro
			
			_aAuto := {}
			aadd(_aAuto,{_cDoc,dDataBase})
			
			_aItem := {}
			
			aadd(_aItem,M->ZE_PRODUTO)          //Produto Origem
			aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
			aadd(_aItem,SB1->B1_UM)  	         //UM Origem
			aadd(_aItem,cLocProcDom)            //Local Origem
			aadd(_aItem,"97PROCESSO     ")	   //Endereco Origem
			aadd(_aItem,M->ZE_PRODUTO)          //Produto Destino
			aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
			aadd(_aItem,SB1->B1_UM)  	         //UM destino
			aadd(_aItem,'11')                   //Local Destino
			aadd(_aItem,'CQ           ')  	   //Endereco Destino
			aadd(_aItem,"")                     //Numero Serie
			aadd(_aItem,cLoteCtl)               //aLotes[x,2])	         //Lote Origem     //74343 01
			aadd(_aItem,"")         	         //Sub Lote Origem
			aadd(_aItem,CtoD("31/12/2049"))	   //Validade Lote Origem
			aadd(_aItem,0)		                  //Potencia
			aadd(_aItem,M->ZE_QTDORI)    	      //Quantidade
			aadd(_aItem,criavar("D3_QTSEGUM"))  //Quantidade 2a. unidade
			aadd(_aItem,criavar("D3_ESTORNO"))  //ESTORNO
			aadd(_aItem,criavar("D3_NUMSEQ"))  //NUMSEQ
			aadd(_aItem,"LOTE1308  "         )  // aLotes[x,2])   	      //Lote Destino
			aadd(_aItem,CtoD("31/12/2049")   )  //Validade Lote Destino
			aadd(_aItem,criavar("D3_ITEMGRD"))  //D3_ITEMGRD
			If nFCICalc == 1
				aadd(_aItem,0)                      //D3_PERIMP
			ENDIF
			If GetVersao(.F.,.F.) == "12"
				//aAdd(_aItem,"")   //D3_IDDCF
				aAdd(_aItem,"")   //D3_OBSERVACAO
			EndIf
			aadd(_aAuto,_aItem)
			
			CriaSB2(M->ZE_PRODUTO,"11")
			
			SB2->( dbSetOrder(1) )
			If SB2->( dbSeek( xFilial() + M->ZE_PRODUTO + cLocProcDom) )
				aAreaSB2 := SB2->( GetArea() )
				
				nB2_QEMP := SB2->B2_QEMP
				
				Reclock("SB2",.F.)
				SB2->B2_QEMP := 0
				SB2->( MsUnlock() )
				
				GuardaEmps(SZE->ZE_PRODUTO,cLocProcDom)
				
				MSExecAuto({|x,y| mata261(x,y)},_aAuto,3)
				
				VoltaEmps()
				
				RestArea(aAreaSB2)
				Reclock("SB2",.F.)
				SB2->B2_QEMP := nB2_QEMP
				SB2->( MsUnlock() )
			Else
				MsgStop('Produto nใo encontrado no SB2 armaz้m 97.')
				
			EndIf
			
			If lMsErroAuto
				
				MsgStop("Erro no processo de tranfer๊ncia para o almoxarifado 11. Nใo foi possํvel lan็ar esta perda.")
				
				Mostraerro()
				
				_Retorno := .F.
			Else 			
				SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
				If SD3->( dbSeek( xFilial() + _cDoc ) )
					While !SD3->( EOF() ) .and. SD3->D3_DOC == _cDoc
						If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
							If SD3->D3_COD == M->ZE_PRODUTO
								If SD3->D3_EMISSAO == dDataBase
									If SD3->D3_QUANT == M->ZE_QTDORI
										If Empty(SD3->D3_XXOP)
											Reclock("SD3",.F.)
											SD3->D3_XXOP    := M->ZE_OP
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
				//If MsgYesNo("Deseja imprimir a etiqueta?")
				//	Etiqueta()
				//EndIf
				lOKIn := .t.
			EndIf
		EndIf
	EndIf
EndIf

If nOpc == 5 // exclusใo

	If SB1->( dbSeek( xFilial() + SZE->ZE_PRODUTO ) )
	   cNumLote    := Space(Len(SB8->B8_NUMLOTE))
		cLoteCtl    := U_RetLotC6(SZE->ZE_OP)
		cProduto    := SZE->ZE_PRODUTO
		cLocal      := "11"
		dData       := Date()+1
		cLocaliza   := Subs("CQ" + Space(30),1,Len(SBF->BF_LOCALIZ))
		cNumSerie   := Space(Len(SBF->BF_NUMSERI))
		aSaldo      := CalcEstL(cProduto, cLocal, dData,cLoteCtl,cNumLote,cLocaliza,cNumSerie,.T.)
		nSalDispB8  := aSaldo[1]
		
		SBF->( dbSetOrder(1) )
		If SBF->( dbSeek( xFilial() + cLocal + cLocaliza + cProduto + cNumSerie + cLoteCtl  ) )
			nSalDispBF := SBF->BF_QUANT
		Else
			nSalDispBF := 0
		EndIf
		
		If M->ZE_QTDORI > nSalDispBF
			_Retorno := .F.
			MsgStop('Quantidade ' + Alltrim(Str(M->ZE_QTDORI)) + ' superior ao saldo de '+Alltrim(Str(nSalDispBF))+' do lote '+Alltrim(cLoteCtl)+' do produto '+Alltrim(M->ZE_PRODUTO)+" no edere็o "+cLocaliza+" desta OP. Nใo foi possํvel apontar estar perda por falta de saldo por endere็o.")
		EndIf
		
		If M->ZE_QTDORI > nSalDispB8
			_Retorno := .F.
			MsgStop('Quantidade ' + Alltrim(Str(M->ZE_QTDORI)) + ' superior ao saldo de '+Alltrim(Str(nSalDispB8))+' do lote '+Alltrim(cLoteCtl)+' do produto '+Alltrim(M->ZE_PRODUTO)+" desta OP. Nใo foi possํvel apontar estar perda por falta de saldo por lote.")
		EndIf
		
		If _Retorno  
		   //M->ZE_DOCUMEN 
			_cDoc :=   M->ZE_DOCUMEN// U_NEXTDOC() //GetSxENum("SD3","D3_DOC",1)
			_cDoc :=_cDoc+SPACE(09)        //DOCUMENTO 9 DIGITOS
			_cDoc := SUBSTR(_cDoc,1,9)
			
			lMSHelpAuto := .t. // para mostrar os erro na tela
			lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e' que deu erro
			
			_aAuto := {}
			aadd(_aAuto,{_cDoc,dDataBase})
			
			_aItem := {}
			
			aadd(_aItem,M->ZE_PRODUTO)          //Produto Origem
			aadd(_aItem,SB1->B1_DESC)           //Descricao Origem
			aadd(_aItem,SB1->B1_UM)  	         //UM Origem
			aadd(_aItem,cLocProcDom)            //Local Origem
			aadd(_aItem,"97PROCESSO     ")	   //Endereco Origem
			aadd(_aItem,M->ZE_PRODUTO)          //Produto Destino
			aadd(_aItem,SB1->B1_DESC)           //Descricao Destino
			aadd(_aItem,SB1->B1_UM)  	         //UM destino
			aadd(_aItem,'11')                   //Local Destino
			aadd(_aItem,'CQ           ')  	   //Endereco Destino
			aadd(_aItem,"")                     //Numero Serie
			aadd(_aItem,cLoteCtl)               //aLotes[x,2])	         //Lote Origem     //74343 01
			aadd(_aItem,"")         	         //Sub Lote Origem
			aadd(_aItem,CtoD("31/12/2049"))	   //Validade Lote Origem
			aadd(_aItem,0)		                  //Potencia
			aadd(_aItem,M->ZE_QTDORI)    	      //Quantidade
			aadd(_aItem,criavar("D3_QTSEGUM"))  //Quantidade 2a. unidade
			aadd(_aItem,criavar("D3_ESTORNO"))  //ESTORNO
			aadd(_aItem,criavar("D3_NUMSEQ") )  //NUMSEQ
			aadd(_aItem,"LOTE1308  "         )  // aLotes[x,2])   	      //Lote Destino
			aadd(_aItem,CtoD("31/12/2049")   )  //Validade Lote Destino
			aadd(_aItem,criavar("D3_ITEMGRD"))  //D3_ITEMGRD
			If nFCICalc == 1
				aadd(_aItem,0)                   //D3_PERIMP
			ENDIF
			If GetVersao(.F.,.F.) == "12"
				//aAdd(_aItem,"")   //D3_IDDCF
				aAdd(_aItem,"")   //D3_OBSERVACAO
			EndIf
			aadd(_aAuto,_aItem)
			
			CriaSB2(M->ZE_PRODUTO,"11")
			
			SB2->( dbSetOrder(1) )
			If SB2->( dbSeek( xFilial() + M->ZE_PRODUTO + cLocProcDom) )
				aAreaSB2 := SB2->( GetArea() )
				
				nB2_QEMP := SB2->B2_QEMP
				
				Reclock("SB2",.F.)
				SB2->B2_QEMP := 0
				SB2->( MsUnlock() )
				
				GuardaEmps(SZE->ZE_PRODUTO,cLocProcDom)
				
				MSExecAuto({|x,y| mata261(x,y)},_aAuto,3)
				
				VoltaEmps()
				
				RestArea(aAreaSB2)
				Reclock("SB2",.F.)
				SB2->B2_QEMP := nB2_QEMP
				SB2->( MsUnlock() )
			Else
				MsgStop('Produto nใo encontrado no SB2 armaz้m 97.')
				
			EndIf
			
			If lMsErroAuto
				
				MsgStop("Erro no processo de tranfer๊ncia para o almoxarifado 11. Nใo foi possํvel lan็ar esta perda.")
				
				Mostraerro()
				
				_Retorno := .F.
			Else
				/*
				SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
				If SD3->( dbSeek( xFilial() + _cDoc ) )
					While !SD3->( EOF() ) .and. SD3->D3_DOC == "000000000"
						If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
							If SD3->D3_COD == M->ZE_PRODUTO
								If SD3->D3_EMISSAO == dDataBase
									If SD3->D3_QUANT == M->ZE_QTDORI   
										If SD3->D3_LOCAL=='11' 									  	
											If Empty(SD3->D3_XXOP)
												If SD3->D3_LOTECTL=cLoteCtl
											   	cNumSeq:=SD3->D3_NUMSEQ
													SD3->( dbSetOrder(4) )  // D3_FILIAL + D3_DOC
														If SD3->( dbSeek( xFilial() + cNumSeq ) )
															While !SD3->( EOF() ) .and. SD3->D3_NUMSEQ == cNumSeq
																If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
																	If SD3->D3_COD == M->ZE_PRODUTO
																		If SD3->D3_EMISSAO == dDataBase
																			If SD3->D3_QUANT == M->ZE_QTDORI   				  	
																				If Empty(SD3->D3_XXOP)
																					Reclock("SD3",.F.)
																					SD3->D3_XXOP    := M->ZE_OP
																					SD3->D3_HORA    := Time()
																					SD3->( msUnlock() )       
																				EndIf
																			EndIf
																		EndIf
																	EndIf
																EndIf 
																SD3->( dbSkip() )
															End
														EndIf
												EndIf
											EndIf             
										EndIF	
									EndIf
								EndIf
							EndIf
						EndIf
						SD3->( dbSkip() )
					End
				EndIf
				*/
				If MsgYesNo("Deseja imprimir a etiqueta ?")
				 	Etiqueta()				 
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aAreaGER)

Return _Retorno



*-------------------------------------------------------------------------------------
Static Function GuardaEmps(cProduto,cLocal)
*-------------------------------------------------------------------------------------
Local x

aEmpSB2   := {}
aEmpSBF   := {}
aEmpSB8   := {}
aSD4QUANT := {}

SB2->( dbSetOrder(1) )
If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
	If !Empty(SB2->B2_QEMP)
		AADD(aEmpSB2,{SB2->(Recno()),SB2->B2_QEMP})
	EndIf
EndIf

SBF->( dbSetOrder(2) )
If SBF->( dbSeek( xFilial() + cProduto + cLocal ) )
	While !SBF->( EOF() ) .and. SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL == xFilial("SBF") + cProduto + cLocal
		If !Empty(SBF->BF_EMPENHO)
			AADD(aEmpSBF,{SBF->(Recno()),SBF->BF_EMPENHO})
		EndIf
		SBF->( dbSkip() )
	End
EndIf

SB8->( dbSetOrder(1) )
If SB8->( dbSeek( xFilial() + cProduto + cLocal ) )
	While !SB8->( EOF() ) .and. SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL == xFilial("SB8") + cProduto + cLocal
		If !Empty(SB8->B8_EMPENHO)
			AADD(aEmpSB8,{SB8->(Recno()),SB8->B8_EMPENHO})
		EndIf
		SB8->( dbSkip() )
	End
EndIf

For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := 0
	SB2->( msUnlock() )
Next x

For x := 1 to Len(aEmpSBF)
	SBF->( dbGoTo(aEmpSBF[x,1]) )
	Reclock("SBF",.F.)
	SBF->BF_EMPENHO := 0
	SBF->( msUnlock() )
Next x

For x := 1 to Len(aEmpSB8)
	SB8->( dbGoTo(aEmpSB8[x,1]) )
	Reclock("SB8",.F.)
	SB8->B8_EMPENHO := 0
	SB8->( msUnlock() )
Next x


cQuery := "SELECT R_E_C_N_O_, D4_QUANT FROM " + RetSqlName("SD4") + " WHERE D4_COD = '"+cProduto+"' AND D4_LOCAL = '"+cLocal+"' AND D4_QUANT <> 0 "

If Select("QUERYSD4") <> 0
	QUERYSD4->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSD4"

While !QUERYSD4->( EOF() )
	AADD(aSD4QUANT,{QUERYSD4->R_E_C_N_O_,QUERYSD4->D4_QUANT})
	SD4->( dbGoTo(QUERYSD4->R_E_C_N_O_) )
	If SD4->( Recno() ) == QUERYSD4->R_E_C_N_O_
		Reclock("SD4",.F.)
		SD4->D4_XQUANT := SD4->D4_QUANT
		SD4->D4_QUANT  := 0
		SD4->( msUnlock() )
	EndIf
	QUERYSD4->( dbSkip() )
End

Return

*-------------------------------------------------------------------------------------
Static Function VoltaEmps()
*-------------------------------------------------------------------------------------
Local x

For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := aEmpSB2[x,2]
	SB2->( msUnlock() )
Next x

For x := 1 to Len(aEmpSBF)
	SBF->( dbGoTo(aEmpSBF[x,1]) )
	Reclock("SBF",.F.)
	SBF->BF_EMPENHO := aEmpSBF[x,2]
	SBF->( msUnlock() )
Next x

For x := 1 to Len(aEmpSB8)
	SB8->( dbGoTo(aEmpSB8[x,1]) )
	Reclock("SB8",.F.)
	SB8->B8_EMPENHO := aEmpSB8[x,2]
	SB8->( msUnlock() )
Next x

For x := 1 to Len(aSD4QUANT)
	SD4->( dbGoTo(aSD4QUANT[x,1]) )
	If SD4->( Recno() ) == aSD4QUANT[x,1]
		Reclock("SD4",.F.)
		SD4->D4_QUANT  := SD4->D4_XQUANT
		SD4->D4_XQUANT := 0
		SD4->( msUnlock() )
	EndIf
Next x

Return
