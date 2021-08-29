#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT410ACE  บAutor  ณHelio Ferreira      บ Data ณ  23/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida acesso da op็ใo de Pedido de Vendas                 บฑฑ
ฑฑบ          ณ executado no momento da alteracao e exclusao               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT410ACE()

Local _Retorno := .T.
Local aAreaGER := GetArea()
Local aAreaSC2 := SC2->( GetArea() )
Local aAreaSC5 := SC5->( GetArea() )
Local aAreaSC6 := SC6->( GetArea() )
Local aAreaSA1 := SA1->( GetArea() )  
Local nOpc     := PARAMIXB [1]
Local _cQr1    :=''

If _Retorno .and. PARAMIXB[1] == 1  // Exclusใo
	SC6->( dbSetOrder(1) )
	SC2->(DbOrderNickName("USUSC20001"))  // C2_FILIAL + C2_PEDIDO + C2_ITEMPV
	If SC6->( dbSeek( xFilial() + SC5->C5_NUM ) )
		While !SC6->( EOF() ) .and. SC6->C6_NUM == SC5->C5_NUM
			If SC2->( dbSeek( xFilial() + SC6->C6_NUM + SC6->C6_ITEM ) )
				MsgStop("Nใo serแ possํvel excluir este Pedido. A Ordem de Produ็ใo " + Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11) + " jแ foi gerada para o item " + SC6->C6_ITEM + ".")
				_Retorno := .F.
			EndIf
			SC6->( dbSkip() )
		End
	EndIf
EndIf
 
// Exclui previsใo de faturamento
If _Retorno .and. PARAMIXB[1] == 1  // Exclusใo
   SZY->(dbSetOrder(1))
	Do While SZY->(dbSeek(xFilial("SZY")+SC5->C5_NUM))
		Reclock("SZY",.F.)
		SZY->(dbDelete())
		SZY->(MsUnlock())
	EndDo
EndIf


//If  PARAMIXB[1]  == 4 // Alterar   // MLS TESTAR ALTERACAO
   //_cESTADO := POSICIONE('SA1',1,xFILIAL('SA1')+SC5->C5_CLIENT+SC5->C5_LOJACLI,'A1_EST')
   //IF _cESTADO=='EX'
//      _cQr1 := " UPDATE SC5010 SET C5_PEDEXP='' WHERE C5_PEDEXP<>'' "
//      TCSQLEXEC(_cQr1)
   //ENDIF   
//ENDIF   

 

RestArea(aAreaSA1)
RestArea(aAreaSC5)
RestArea(aAreaSC2)
RestArea(aAreaSC6)
RestArea(aAreaGER)        



If _Retorno 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPrepara aCols da Previsใo de Faturamento			 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   U_fDefVars()
EndIf


Return _Retorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDefVars บAutor  ณMichel Sander       บ Data ณ  16.02.16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o aCols para a previsใo de faturamento por item       บฑฑ
ฑฑบ          ณ 																		     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fDefVars()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera aCols pelo n๚mero mแximo de linhas do pedido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//cAuxItem := "00"
//For nX := 1 to 1000
//    cAuxItem := Soma1(cAuxItem)
//    Public aCols&cAuxItem := {}
//Next
Public aCols01 := {}
Public aCols02 := {}
Public aCols03 := {}
Public aCols04 := {}
Public aCols05 := {}
Public aCols06 := {}
Public aCols07 := {}
Public aCols08 := {}
Public aCols09 := {}
Public aCols10 := {}
Public aCols11 := {}
Public aCols12 := {}
Public aCols13 := {}
Public aCols14 := {}
Public aCols15 := {}
Public aCols16 := {}
Public aCols17 := {}
Public aCols18 := {}
Public aCols19 := {}
Public aCols20 := {}
Public aCols21 := {}
Public aCols22 := {}
Public aCols23 := {}
Public aCols24 := {}
Public aCols25 := {}
Public aCols26 := {}
Public aCols27 := {}
Public aCols28 := {}
Public aCols29 := {}
Public aCols30 := {}
Public aCols31 := {}
Public aCols32 := {}
Public aCols33 := {}
Public aCols34 := {}
Public aCols35 := {}
Public aCols36 := {}
Public aCols37 := {}
Public aCols38 := {}
Public aCols39 := {}
Public aCols40 := {}
Public aCols41 := {}
Public aCols42 := {}
Public aCols43 := {}
Public aCols44 := {}
Public aCols45 := {}
Public aCols46 := {}
Public aCols47 := {}
Public aCols48 := {}
Public aCols49 := {}
Public aCols50 := {}
Public aCols51 := {}
Public aCols52 := {}
Public aCols53 := {}
Public aCols54 := {}
Public aCols55 := {}
Public aCols56 := {}
Public aCols57 := {}
Public aCols58 := {}
Public aCols59 := {}
Public aCols60 := {}
Public aCols61 := {}
Public aCols62 := {}
Public aCols63 := {}
Public aCols64 := {}
Public aCols65 := {}
Public aCols66 := {}
Public aCols67 := {}
Public aCols68 := {}
Public aCols69 := {}
Public aCols70 := {}
Public aCols71 := {}
Public aCols72 := {}
Public aCols73 := {}
Public aCols74 := {}
Public aCols75 := {}
Public aCols76 := {}
Public aCols77 := {}
Public aCols78 := {}
Public aCols79 := {}
Public aCols80 := {}
Public aCols81 := {}
Public aCols82 := {}
Public aCols83 := {}
Public aCols84 := {}
Public aCols85 := {}
Public aCols86 := {}
Public aCols87 := {}
Public aCols88 := {}
Public aCols89 := {}
Public aCols90 := {}
Public aCols91 := {}
Public aCols92 := {}
Public aCols93 := {}
Public aCols94 := {}
Public aCols95 := {}
Public aCols96 := {}
Public aCols97 := {}
Public aCols98 := {}
Public aCols99 := {}
Public ACOLSA0	:= {}
Public ACOLSA1	:= {}
Public ACOLSA2	:= {}
Public ACOLSA3	:= {}
Public ACOLSA4	:= {}
Public ACOLSA5	:= {}
Public ACOLSA6	:= {}
Public ACOLSA7	:= {}
Public ACOLSA8	:= {}
Public ACOLSA9	:= {}
Public ACOLSAA	:= {}
Public ACOLSAB	:= {}
Public ACOLSAC	:= {}
Public ACOLSAD	:= {}
Public ACOLSAE	:= {}
Public ACOLSAF	:= {}
Public ACOLSAG	:= {}
Public ACOLSAH	:= {}
Public ACOLSAI	:= {}
Public ACOLSAJ	:= {}
Public ACOLSAK	:= {}
Public ACOLSAL	:= {}
Public ACOLSAM	:= {}
Public ACOLSAN	:= {}
Public ACOLSAO	:= {}
Public ACOLSAP	:= {}
Public ACOLSAQ	:= {}
Public ACOLSAR	:= {}
Public ACOLSAS	:= {}
Public ACOLSAT	:= {}
Public ACOLSAU	:= {}
Public ACOLSAV	:= {}
Public ACOLSAW	:= {}
Public ACOLSAX	:= {}
Public ACOLSAY	:= {}
Public ACOLSAZ	:= {}
Public ACOLSB0	:= {}
Public ACOLSB1	:= {}
Public ACOLSB2	:= {}
Public ACOLSB3	:= {}
Public ACOLSB4	:= {}
Public ACOLSB5	:= {}
Public ACOLSB6	:= {}
Public ACOLSB7	:= {}
Public ACOLSB8	:= {}
Public ACOLSB9	:= {}
Public ACOLSBA	:= {}
Public ACOLSBB	:= {}
Public ACOLSBC	:= {}
Public ACOLSBD	:= {}
Public ACOLSBE	:= {}
Public ACOLSBF	:= {}
Public ACOLSBG	:= {}
Public ACOLSBH	:= {}
Public ACOLSBI	:= {}
Public ACOLSBJ	:= {}
Public ACOLSBK	:= {}
Public ACOLSBL	:= {}
Public ACOLSBM	:= {}
Public ACOLSBN	:= {}
Public ACOLSBO	:= {}
Public ACOLSBP	:= {}
Public ACOLSBQ	:= {}
Public ACOLSBR	:= {}
Public ACOLSBS	:= {}
Public ACOLSBT	:= {}
Public ACOLSBU	:= {}
Public ACOLSBV	:= {}
Public ACOLSBW	:= {}
Public ACOLSBX	:= {}
Public ACOLSBY	:= {}
Public ACOLSBZ	:= {}
Public ACOLSC0	:= {}
Public ACOLSC1	:= {}
Public ACOLSC2	:= {}
Public ACOLSC3	:= {}
Public ACOLSC4	:= {}
Public ACOLSC5	:= {}
Public ACOLSC6	:= {}
Public ACOLSC7	:= {}
Public ACOLSC8	:= {}
Public ACOLSC9	:= {}
Public ACOLSCA	:= {}
Public ACOLSCB	:= {}
Public ACOLSCC	:= {}
Public ACOLSCD	:= {}
Public ACOLSCE	:= {}
Public ACOLSCF	:= {}
Public ACOLSCG	:= {}
Public ACOLSCH	:= {}
Public ACOLSCI	:= {}
Public ACOLSCJ	:= {}
Public ACOLSCK	:= {}
Public ACOLSCL	:= {}
Public ACOLSCM	:= {}
Public ACOLSCN	:= {}
Public ACOLSCO	:= {}
Public ACOLSCP	:= {}
Public ACOLSCQ	:= {}
Public ACOLSCR	:= {}
Public ACOLSCS	:= {}
Public ACOLSCT	:= {}
Public ACOLSCU	:= {}
Public ACOLSCV	:= {}
Public ACOLSCW	:= {}
Public ACOLSCX	:= {}
Public ACOLSCY	:= {}
Public ACOLSCZ	:= {}
Public ACOLSD0	:= {}
Public ACOLSD1	:= {}
Public ACOLSD2	:= {}
Public ACOLSD3	:= {}
Public ACOLSD4	:= {}
Public ACOLSD5	:= {}
Public ACOLSD6	:= {}
Public ACOLSD7	:= {}
Public ACOLSD8	:= {}
Public ACOLSD9	:= {}
Public ACOLSDA	:= {}
Public ACOLSDB	:= {}
Public ACOLSDC	:= {}
Public ACOLSDD	:= {}
Public ACOLSDE	:= {}
Public ACOLSDF	:= {}
Public ACOLSDG	:= {}
Public ACOLSDH	:= {}
Public ACOLSDI	:= {}
Public ACOLSDJ	:= {}
Public ACOLSDK	:= {}
Public ACOLSDL	:= {}
Public ACOLSDM	:= {}
Public ACOLSDN	:= {}
Public ACOLSDO	:= {}
Public ACOLSDP	:= {}
Public ACOLSDQ	:= {}
Public ACOLSDR	:= {}
Public ACOLSDS	:= {}
Public ACOLSDT	:= {}
Public ACOLSDU	:= {}
Public ACOLSDV	:= {}
Public ACOLSDW	:= {}
Public ACOLSDX	:= {}
Public ACOLSDY	:= {}
Public ACOLSDZ	:= {}
Public ACOLSE0	:= {}
Public ACOLSE1	:= {}
Public ACOLSE2	:= {}
Public ACOLSE3	:= {}
Public ACOLSE4	:= {}
Public ACOLSE5	:= {}
Public ACOLSE6	:= {}
Public ACOLSE7	:= {}
Public ACOLSE8	:= {}
Public ACOLSE9	:= {}
Public ACOLSEA	:= {}
Public ACOLSEB	:= {}
Public ACOLSEC	:= {}
Public ACOLSED	:= {}
Public ACOLSEE	:= {}
Public ACOLSEF	:= {}
Public ACOLSEG	:= {}
Public ACOLSEH	:= {}
Public ACOLSEI	:= {}
Public ACOLSEJ	:= {}
Public ACOLSEK	:= {}
Public ACOLSEL	:= {}
Public ACOLSEM	:= {}
Public ACOLSEN	:= {}
Public ACOLSEO	:= {}
Public ACOLSEP	:= {}
Public ACOLSEQ	:= {}
Public ACOLSER	:= {}
Public ACOLSES	:= {}
Public ACOLSET	:= {}
Public ACOLSEU	:= {}
Public ACOLSEV	:= {}
Public ACOLSEW	:= {}
Public ACOLSEX	:= {}
Public ACOLSEY	:= {}
Public ACOLSEZ	:= {}
Public ACOLSF0	:= {}
Public ACOLSF1	:= {}
Public ACOLSF2	:= {}
Public ACOLSF3	:= {}
Public ACOLSF4	:= {}
Public ACOLSF5	:= {}
Public ACOLSF6	:= {}
Public ACOLSF7	:= {}
Public ACOLSF8	:= {}
Public ACOLSF9	:= {}
Public ACOLSFA	:= {}
Public ACOLSFB	:= {}
Public ACOLSFC	:= {}
Public ACOLSFD	:= {}
Public ACOLSFE	:= {}
Public ACOLSFF	:= {}
Public ACOLSFG	:= {}
Public ACOLSFH	:= {}
Public ACOLSFI	:= {}
Public ACOLSFJ	:= {}
Public ACOLSFK	:= {}
Public ACOLSFL	:= {}
Public ACOLSFM	:= {}
Public ACOLSFN	:= {}
Public ACOLSFO	:= {}
Public ACOLSFP	:= {}
Public ACOLSFQ	:= {}
Public ACOLSFR	:= {}
Public ACOLSFS	:= {}
Public ACOLSFT	:= {}
Public ACOLSFU	:= {}
Public ACOLSFV	:= {}
Public ACOLSFW	:= {}
Public ACOLSFX	:= {}
Public ACOLSFY	:= {}
Public ACOLSFZ	:= {}
Public ACOLSG0	:= {}
Public ACOLSG1	:= {}
Public ACOLSG2	:= {}
Public ACOLSG3	:= {}
Public ACOLSG4	:= {}
Public ACOLSG5	:= {}
Public ACOLSG6	:= {}
Public ACOLSG7	:= {}
Public ACOLSG8	:= {}
Public ACOLSG9	:= {}
Public ACOLSGA	:= {}
Public ACOLSGB	:= {}
Public ACOLSGC	:= {}
Public ACOLSGD	:= {}
Public ACOLSGE	:= {}
Public ACOLSGF	:= {}
Public ACOLSGG	:= {}
Public ACOLSGH	:= {}
Public ACOLSGI	:= {}
Public ACOLSGJ	:= {}
Public ACOLSGK	:= {}
Public ACOLSGL	:= {}
Public ACOLSGM	:= {}
Public ACOLSGN	:= {}
Public ACOLSGO	:= {}
Public ACOLSGP	:= {}
Public ACOLSGQ	:= {}
Public ACOLSGR	:= {}
Public ACOLSGS	:= {}
Public ACOLSGT	:= {}
Public ACOLSGU	:= {}
Public ACOLSGV	:= {}
Public ACOLSGW	:= {}
Public ACOLSGX	:= {}
Public ACOLSGY	:= {}
Public ACOLSGZ	:= {}
Public ACOLSH0	:= {}
Public ACOLSH1	:= {}
Public ACOLSH2	:= {}
Public ACOLSH3	:= {}
Public ACOLSH4	:= {}
Public ACOLSH5	:= {}
Public ACOLSH6	:= {}
Public ACOLSH7	:= {}
Public ACOLSH8	:= {}
Public ACOLSH9	:= {}
Public ACOLSHA	:= {}
Public ACOLSHB	:= {}
Public ACOLSHC	:= {}
Public ACOLSHD	:= {}
Public ACOLSHE	:= {}
Public ACOLSHF	:= {}
Public ACOLSHG	:= {}
Public ACOLSHH	:= {}
Public ACOLSHI	:= {}
Public ACOLSHJ	:= {}
Public ACOLSHK	:= {}
Public ACOLSHL	:= {}
Public ACOLSHM	:= {}
Public ACOLSHN	:= {}
Public ACOLSHO	:= {}
Public ACOLSHP	:= {}
Public ACOLSHQ	:= {}
Public ACOLSHR	:= {}
Public ACOLSHS	:= {}
Public ACOLSHT	:= {}
Public ACOLSHU	:= {}
Public ACOLSHV	:= {}
Public ACOLSHW	:= {}
Public ACOLSHX	:= {}
Public ACOLSHY	:= {}
Public ACOLSHZ	:= {}
Public ACOLSI0	:= {}
Public ACOLSI1	:= {}
Public ACOLSI2	:= {}
Public ACOLSI3	:= {}
Public ACOLSI4	:= {}
Public ACOLSI5	:= {}
Public ACOLSI6	:= {}
Public ACOLSI7	:= {}
Public ACOLSI8	:= {}
Public ACOLSI9	:= {}
Public ACOLSIA	:= {}
Public ACOLSIB	:= {}
Public ACOLSIC	:= {}
Public ACOLSID	:= {}
Public ACOLSIE	:= {}
Public ACOLSIF	:= {}
Public ACOLSIG	:= {}
Public ACOLSIH	:= {}
Public ACOLSII	:= {}
Public ACOLSIJ	:= {}
Public ACOLSIK	:= {}
Public ACOLSIL	:= {}
Public ACOLSIM	:= {}
Public ACOLSIN	:= {}
Public ACOLSIO	:= {}
Public ACOLSIP	:= {}
Public ACOLSIQ	:= {}
Public ACOLSIR	:= {}
Public ACOLSIS	:= {}
Public ACOLSIT	:= {}
Public ACOLSIU	:= {}
Public ACOLSIV	:= {}
Public ACOLSIW	:= {}
Public ACOLSIX	:= {}
Public ACOLSIY	:= {}
Public ACOLSIZ	:= {}
Public ACOLSJ0	:= {}
Public ACOLSJ1	:= {}
Public ACOLSJ2	:= {}
Public ACOLSJ3	:= {}
Public ACOLSJ4	:= {}
Public ACOLSJ5	:= {}
Public ACOLSJ6	:= {}
Public ACOLSJ7	:= {}
Public ACOLSJ8	:= {}
Public ACOLSJ9	:= {}
Public ACOLSJA	:= {}
Public ACOLSJB	:= {}
Public ACOLSJC	:= {}
Public ACOLSJD	:= {}
Public ACOLSJE	:= {}
Public ACOLSJF	:= {}
Public ACOLSJG	:= {}
Public ACOLSJH	:= {}
Public ACOLSJI	:= {}
Public ACOLSJJ	:= {}
Public ACOLSJK	:= {}
Public ACOLSJL	:= {}
Public ACOLSJM	:= {}
Public ACOLSJN	:= {}
Public ACOLSJO	:= {}
Public ACOLSJP	:= {}
Public ACOLSJQ	:= {}
Public ACOLSJR	:= {}
Public ACOLSJS	:= {}
Public ACOLSJT	:= {}
Public ACOLSJU	:= {}
Public ACOLSJV	:= {}
Public ACOLSJW	:= {}
Public ACOLSJX	:= {}
Public ACOLSJY	:= {}
Public ACOLSJZ	:= {}
Public ACOLSK0	:= {}
Public ACOLSK1	:= {}
Public ACOLSK2	:= {}
Public ACOLSK3	:= {}
Public ACOLSK4	:= {}
Public ACOLSK5	:= {}
Public ACOLSK6	:= {}
Public ACOLSK7	:= {}
Public ACOLSK8	:= {}
Public ACOLSK9	:= {}
Public ACOLSKA	:= {}
Public ACOLSKB	:= {}
Public ACOLSKC	:= {}
Public ACOLSKD	:= {}
Public ACOLSKE	:= {}
Public ACOLSKF	:= {}
Public ACOLSKG	:= {}
Public ACOLSKH	:= {}
Public ACOLSKI	:= {}
Public ACOLSKJ	:= {}
Public ACOLSKK	:= {}
Public ACOLSKL	:= {}
Public ACOLSKM	:= {}
Public ACOLSKN	:= {}
Public ACOLSKO	:= {}
Public ACOLSKP	:= {}
Public ACOLSKQ	:= {}
Public ACOLSKR	:= {}
Public ACOLSKS	:= {}
Public ACOLSKT	:= {}
Public ACOLSKU	:= {}
Public ACOLSKV	:= {}
Public ACOLSKW	:= {}
Public ACOLSKX	:= {}
Public ACOLSKY	:= {}
Public ACOLSKZ	:= {}
Public ACOLSL0	:= {}
Public ACOLSL1	:= {}
Public ACOLSL2	:= {}
Public ACOLSL3	:= {}
Public ACOLSL4	:= {}
Public ACOLSL5	:= {}
Public ACOLSL6	:= {}
Public ACOLSL7	:= {}
Public ACOLSL8	:= {}
Public ACOLSL9	:= {}
Public ACOLSLA	:= {}
Public ACOLSLB	:= {}
Public ACOLSLC	:= {}
Public ACOLSLD	:= {}
Public ACOLSLE	:= {}
Public ACOLSLF	:= {}
Public ACOLSLG	:= {}
Public ACOLSLH	:= {}
Public ACOLSLI	:= {}
Public ACOLSLJ	:= {}
Public ACOLSLK	:= {}
Public ACOLSLL	:= {}
Public ACOLSLM	:= {}
Public ACOLSLN	:= {}
Public ACOLSLO	:= {}
Public ACOLSLP	:= {}
Public ACOLSLQ	:= {}
Public ACOLSLR	:= {}
Public ACOLSLS	:= {}
Public ACOLSLT	:= {}
Public ACOLSLU	:= {}
Public ACOLSLV	:= {}
Public ACOLSLW	:= {}
Public ACOLSLX	:= {}
Public ACOLSLY	:= {}
Public ACOLSLZ	:= {}
Public ACOLSM0	:= {}
Public ACOLSM1	:= {}
Public ACOLSM2	:= {}
Public ACOLSM3	:= {}
Public ACOLSM4	:= {}
Public ACOLSM5	:= {}
Public ACOLSM6	:= {}
Public ACOLSM7	:= {}
Public ACOLSM8	:= {}
Public ACOLSM9	:= {}
Public ACOLSMA	:= {}
Public ACOLSMB	:= {}
Public ACOLSMC	:= {}
Public ACOLSMD	:= {}
Public ACOLSME	:= {}
Public ACOLSMF	:= {}
Public ACOLSMG	:= {}
Public ACOLSMH	:= {}
Public ACOLSMI	:= {}
Public ACOLSMJ	:= {}
Public ACOLSMK	:= {}
Public ACOLSML	:= {}
Public ACOLSMM	:= {}
Public ACOLSMN	:= {}
Public ACOLSMO	:= {}
Public ACOLSMP	:= {}
Public ACOLSMQ	:= {}
Public ACOLSMR	:= {}
Public ACOLSMS	:= {}
Public ACOLSMT	:= {}
Public ACOLSMU	:= {}
Public ACOLSMV	:= {}
Public ACOLSMW	:= {}
Public ACOLSMX	:= {}
Public ACOLSMY	:= {}
Public ACOLSMZ	:= {}
Public ACOLSN0	:= {}
Public ACOLSN1	:= {}
Public ACOLSN2	:= {}
Public ACOLSN3	:= {}
Public ACOLSN4	:= {}
Public ACOLSN5	:= {}
Public ACOLSN6	:= {}
Public ACOLSN7	:= {}
Public ACOLSN8	:= {}
Public ACOLSN9	:= {}
Public ACOLSNA	:= {}
Public ACOLSNB	:= {}
Public ACOLSNC	:= {}
Public ACOLSND	:= {}
Public ACOLSNE	:= {}
Public ACOLSNF	:= {}
Public ACOLSNG	:= {}
Public ACOLSNH	:= {}
Public ACOLSNI	:= {}
Public ACOLSNJ	:= {}
Public ACOLSNK	:= {}
Public ACOLSNL	:= {}
Public ACOLSNM	:= {}
Public ACOLSNN	:= {}
Public ACOLSNO	:= {}
Public ACOLSNP	:= {}
Public ACOLSNQ	:= {}
Public ACOLSNR	:= {}
Public ACOLSNS	:= {}
Public ACOLSNT	:= {}
Public ACOLSNU	:= {}

Return