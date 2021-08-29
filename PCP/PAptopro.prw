#include 'rwmake.ch'
#include 'tbiconn.ch'
#include 'tbicode.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPAPTOPRO  บAutor  ณHelio Ferreira      บ Data ณ  18/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio de e-mail com a posi็ใo dos apontamentos de produ็ใo บฑฑ
ฑฑบ          ณ do dia                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PAptopro()

aCorpoEmail := {}
cQuery := "SELECT D3_OP FROM SD3010 (NOLOCK), SF5010 (NOLOCK) WHERE D3_FILIAL = '01' AND D3_ESTORNO = '' AND D3_TM = F5_CODIGO AND F5_TIPO = 'P' AND D3_EMISSAO = '"+DtoS(dDataBase)+"' AND SD3010.D_E_L_E_T_ = '' AND SF5010.D_E_L_E_T_ = '' GROUP BY D3_OP ORDER BY D3_OP "

If Select("PROD") <> 0
	PROD->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "PROD"

aPedidos := {}
SC2->( dbSetOrder(1) )
SC6->( dbSetOrder(1) )
SD3->( dbSetOrder(1) )
SF5->( dbSetOrder(1) )

While !PROD->( EOF() )
	If SC2->( dbSeek( xFilial() + Subs(PROD->D3_OP,1,11) ) )
		If !Empty(SC2->C2_PEDIDO)
			If aScan(aPedidos,SC2->C2_PEDIDO) == 0
				AADD(aPedidos,SC2->C2_PEDIDO)
				If SC6->( dbSeek( xFilial() + SC2->C2_PEDIDO ) )
					While !SC6->( EOF() ) .and. SC6->C6_NUM == SC2->C2_PEDIDO
						cQuery := "SELECT C2_NUM+C2_ITEM+C2_SEQUEN AS C2_OP FROM SC2010 (NOLOCK) WHERE C2_FILIAL = '01' AND  C2_PEDIDO = '"+SC6->C6_NUM+"' AND C2_ITEMPV = '"+SC6->C6_ITEM+"' AND D_E_L_E_T_ = '' "
						
						If SELECT("QUERYSC2") <> 0
							QUERYSC2->( dbCloseArea() )
						EndIf             
						
						TCQUERY cQuery NEW ALIAS "QUERYSC2"
						
						SC5->( dbSetOrder(1) )
						SC5->( dbSeek( xFilial() + SC6->C6_NUM ) )
						SA1->( dbSetOrder(1) )
						SA1->( dbSeek( xFilial() + SC6->C6_CLI + SC6->C6_LOJA ) )
						
						//                Pedido(1)   Item(2)      OP(3)           4-Dt Fatur (PCP)       5-Qtd Pedido                                     SALDO(6)                                                        7  8   9
						If !GetMV("MV_XXINVDT")  
						   AADD(aCorpoEmail,{SC6->C6_NUM,SC6->C6_ITEM,SA1->A1_NREDUZ,DtoC(SC5->C5_EMISSAO),DtoC(SC6->C6_ENTRE3),SC6->C6_PRODUTO,QUERYSC2->C2_OP,Transform(SC6->C6_QTDVEN,'@E 999,999,999.9999'),Transform(SC6->C6_QTDVEN-SC6->C6_QTDENT,'@E 999,999,999.9999'),0 ,'','' })  // Tratado
						Else
						   AADD(aCorpoEmail,{SC6->C6_NUM,SC6->C6_ITEM,SA1->A1_NREDUZ,DtoC(SC5->C5_EMISSAO),DtoC(SC6->C6_ENTREG) ,SC6->C6_PRODUTO,QUERYSC2->C2_OP,Transform(SC6->C6_QTDVEN,'@E 999,999,999.9999'),Transform(SC6->C6_QTDVEN-SC6->C6_QTDENT,'@E 999,999,999.9999'),0 ,'','' })  // Tratado
						EndIf
						If !QUERYSC2->( EOF() )
							If SD3->( dbSeek( xFilial() + QUERYSC2->C2_OP ) )
								While !SD3->( EOF() ) .and. Subs(SD3->D3_OP,1,11) == Subs(QUERYSC2->C2_OP,1,11)
									If Empty(SD3->D3_ESTORNO)
										If SF5->( dbSeek( xFilial() + SD3->D3_TM ) )
											If SF5->F5_TIPO == 'P'
												If SD3->D3_EMISSAO == dDataBase
												   aCorpoEmail[Len(aCorpoEmail),10] += SD3->D3_QUANT
												   aCorpoEmail[Len(aCorpoEmail),11] := SD3->D3_LOTECTL
												   aCorpoEmail[Len(aCorpoEmail),12] := SD3->D3_HORA
												EndIf
											EndIf
										EndIf
									EndIf
									SD3->( dbSkip() )
								End
							EndIf
						EndIf
						
						SC6->( dbSkip() )
					End
				EndIf
			EndIf
		Else
			
		EndIf
	Else
		MsgStop("OP nใo encontrada: " + PROD->D3_OP )
	EndIf
	PROD->( dbSkip() )
End

// Ordenando o Vetor:
aVetNotFat := {}
For x := 1 to Len(aCorpoEmail)
   If !Empty(Val(aCorpoEmail[x,9]))  // Saldo do pedido a faturar
      If aScan(aVetNotFat,aCorpoEmail[x,1]) == 0
         cTemp := aCorpoEmail[x,1]        // Pedidos que tem saldo a faturar
         AADD(aVetNotFat,cTemp)
      EndIf
   EndIf
Next x

aNovoCorpo := {}
cPedido    := ''
For x := 1 to Len(aCorpoEmail)
	If aScan(aVetNotFat,aCorpoEmail[x,1]) <> 0
		//If CtoD(aCorpoEmail[x,5]) <= dDataBase    // Data de faturamento menor ou igual a data base
			If !Empty(cPedido) .and. cPedido <> aCorpoEmail[x,1]
				AADD(aNovoCorpo,{'-','','','','','','','','','','',''} )
			EndIf
			AADD(aNovoCorpo,aClone(aCorpoEmail[x]))
			cPedido := aCorpoEmail[x,1]
		//EndIf
	EndIf
Next x

If !Empty(aNovoCorpo)
   AADD(aNovoCorpo,{'FATURADOS:','','','','','','','','','','',''} )
EndIf

cPedido := ''
For x := 1 to Len(aCorpoEmail)
   If aScan(aVetNotFat,aCorpoEmail[x,1]) == 0
      If !Empty(cPedido) .and. cPedido <> aCorpoEmail[x,1]
         cPedido := aCorpoEmail[x,1]
         AADD(aNovoCorpo,{'','','','','','','','','','','',''} )
      EndIf
      AADD(aNovoCorpo,aClone(aCorpoEmail[x]))
   EndIf
Next x

// Depois de criar o aNovoCorpo igual ao aCorpoEmail ordenado:

aCorpoEmail := aClone(aNovoCorpo)

// Fim da ordena็ใo do vedor de corpo do e-mail


cAssunto := 'Posi็ใo de Apto. Produ็ใo: ' + Time()
cTexto   := ''
cPara    := 'helio@opusvp.com.br;luciano.silva@rosenbergerdomex.com.br;elaine.ribeiro@rdt.com.br;denis.vieira@rdt.com.br'
cCC      := ''

If !File("\workflow\Posaptoprod.htm")
	MsgStop("HTM nใo encontrado.")
EndIf

oProcess:=TWFProcess():New("00001",OemToAnsi(cAssunto))
oProcess:NewTask("000001","\workflow\Posaptoprod.htm")
oHtml:=oProcess:oHtml

oProcess:ClientName( Subs(cUsuario,7,15) )
oProcess:cTo      := cPara
oProcess:UserSiga := "000000"
oProcess:cSubject := cAssunto

//oProcess:oHtml:ValByName( "cTitulo"	   , 'Posi็ใo de Apontamentos de Produ็ใo: ' + Time() )


For x := 1 to Len(aCorpoEmail)
	aadd(oHtml:ValByName("it.pedido")         ,aCorpoEmail[X,1]	 )
	aadd(oHtml:ValByName("it.item")           ,aCorpoEmail[X,2]	 )
	aadd(oHtml:ValByName("it.nreduz")         ,aCorpoEmail[X,3]  )
	aadd(oHtml:ValByName("it.dtemis")         ,aCorpoEmail[X,4]  )
	aadd(oHtml:ValByName("it.dtfatur")        ,aCorpoEmail[X,5]  )
	aadd(oHtml:ValByName("it.produto")        ,aCorpoEmail[X,6]  )
	aadd(oHtml:ValByName("it.op")             ,aCorpoEmail[X,7]	 )
	aadd(oHtml:ValByName("it.qtdorig")        ,aCorpoEmail[X,8]	 )
	aadd(oHtml:ValByName("it.saldo")          ,aCorpoEmail[X,9]	 )
	aadd(oHtml:ValByName("it.qtddia")         ,aCorpoEmail[X,10] )
	aadd(oHtml:ValByName("it.lote")           ,aCorpoEmail[X,11] )
	aadd(oHtml:ValByName("it.hora")           ,aCorpoEmail[X,12] )
Next x

oProcess:Start()
oProcess:Finish()

Return
