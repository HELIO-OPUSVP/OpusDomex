#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo gen้rica de gera็ใo de Inventแrio                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GERA_SB7()
Private lMSHelpAuto := .T.  // Para mostrar os erro na tela
Private lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro ้ que deu erro
Private _Armazem := "97"
                                                                           
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

cUsrMenu := ""


//If !(__cUserID $ cUsrMenu)
//	MsgAlert("Usuแrio sem Acesso para executar esta rotina.")
//	Return
//endif

If !MsgNoYes("Deseja realmente gerar o inventario ZERO na data atual para o Armazem "+_Armazem+" ?")
   Return
EndIf
                    

cQuery1 := " "
cQuery1 += " SELECT B8_PRODUTO, B8_LOCAL, B8_LOTECTL, B8_DTVALID, "
cQuery1 += " CASE WHEN BF_LOCALIZ IS NULL THEN '97PROCESSO' ELSE BF_LOCALIZ END AS BF_LOCALIZ "
cQuery1 += " FROM SB8010 AS SB8 "
cQuery1 += " LEFT JOIN SBF010 AS SBF ON BF_PRODUTO=B8_PRODUTO AND BF_LOCAL=B8_LOCAL AND B8_LOTECTL=BF_LOTECTL AND SBF.D_E_L_E_T_='' "
cQuery1 += " WHERE SB8.D_E_L_E_T_='' AND B8_FILIAL='01' AND B8_SALDO<>0 AND B8_LOCAL='97' "

  
If Select("QUERYSB8") <> 0
	QUERYSB8->( dbCloseArea() )
EndIf

TCQUERY cQuery1 NEW ALIAS "QUERYSB8"

SB7->( dbSetOrder(1) )

ProcRegua( QUERYSB8->( Reccount() ))

While !QUERYSB8->( EOF() )
	
//	IncProc("Gerando SB7 com saldo do SB2 no Armazem: "+_Armazem+" ...")
	IncProc("Gerando SB7 com saldo ZERO  no Armazem: "+_Armazem+" ...")	
	
	If SB1->( dbSeek( xFilial() + QUERYSB8->B8_PRODUTO ) )

		//If !SB7->( dbSeek( xFilial() + DtoS(dDatabase) + QUERYSB2->B2_COD + QUERYSB2->B2_LOCAL ) )
			
			aVetor := {}
			AADD(aVetor,{"B7_FILIAL" 			 ,xFilial("SB7")		 		   ,Nil} )
			AADD(aVetor,{"B7_DATA"           ,dDataBase                    ,Nil} )
			AADD(aVetor,{"B7_COD"            ,QUERYSB8->B8_PRODUTO         ,Nil} )
		  	AADD(aVetor,{"B7_LOCAL"          ,QUERYSB8->B8_LOCAL           ,Nil} )
			AADD(aVetor,{"B7_QUANT"          ,0           		            ,Nil} )
			AADD(aVetor,{"B7_DOC"            ,'ACERTO017'                  ,Nil} )			
		  	AADD(aVetor,{"B7_LOTECTL"        ,QUERYSB8->B8_LOTECTL         ,Nil} )
			AADD(aVetor,{"B7_DTVALID"        ,STOD(QUERYSB8->B8_DTVALID)   ,Nil} )
			AADD(aVetor,{"B7_LOCALIZ"        ,QUERYSB8->BF_LOCALIZ	      ,Nil} )
			
			lBloqueado := .F.
	 		If SB1->B1_MSBLQL='1'
	 			Reclock("SB1",.F.)    
	 			SB1->B1_MSBLQL := '2'
	  			SB1->( msUnlock() )
				lBloqueado := .T.
	 		EndIf
	 		
			MSExecAuto({|x,y,z| MATA270(x,y,z)},aVetor,.f.,3)
			
		 	If lBloqueado
		 		Reclock("SB1",.F.)
		 		SB1->B1_MSBLQL := '1'
		 		SB1->( msUnlock() )
			EndIf
			
			If lMSErroAuto
				MOSTRAERRO()
				lMSHelpAuto := .T.  // Para mostrar os erro na tela
				lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro ้ que deu erro
				If MsgYesNo("Deseja Sair?")
				   Return
				EndIf
			Endif
	EndIf
	QUERYSB8->( dbSkip() )
Enddo

MsgStop("Processamento concluํdo.")        

RESET ENVIRONMENT

Return
