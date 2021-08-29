#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraInventºAutor  ³Marcos Resende      º Data ³  12/18/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para gerar dados no arquivo de inventario a partir  º±±
±±º          ³ dos arquivos de saldos por endereço                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Alterado por MICHEL SANDER em 18.12.2014                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GerSB7SBF()

Local aVetor       := {}
Local aAreaSB2      := {}

PRIVATE lMSHelpAuto := .T.  // Para mostrar os erro na tela
PRIVATE lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro é que deu erro

SB1->(dbSetOrder(1))
SBF->(dbSetOrder(1))
SB7->(dbSetOrder(1))  // B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE+B7_CONTAGE

SBF->( dbGoTop() )

MsgInfo('Cuidado ao realizar o processamento'+chr(13)+'Rotina Responsável por zerar os saldos em estoque')

If MsgNoYes('Filial corrente: ' + cFilAnt+CHR(13)+'Database:        ' + DtoC(dDatabase) +chr(13)+'Deseja Continuar com o processamento(não será possível cancelar após confirmação)?','Gerar Inventario a partir dos saldos em estoque')
	Processa({|| procinv() })
endif

MsgAlert('Fim da geração dos registros para zerar saldo em estoque para inventario')

Return

Static Function ProcInv()

aAreaSBF := SBF->( GetArea() )
SBF->( dbSeek( xFilial() ) )
ProcRegua(SBF->(RecCount()))
SBF->( dbSeek( xFilial() ) )

While !SBF->( EOF() )
	
	IncProc("Gerando SB7 com saldo do SBF...")
	
	If SBF->BF_FILIAL == cFilAnt  .and. SBF->BF_LOCAL = '97'
	
		If SB1->( dbSeek( xFilial() + SBF->BF_PRODUTO) )                                              
		   // B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ
			If !SB7->( dbSeek( xFilial() + DtoS(dDatabase) + SBF->BF_PRODUTO + SBF->BF_LOCAL + SBF->BF_LOCALIZ ) ) 
						
					aVetor := {}
					AADD( aVetor,{"B7_FILIAL" 			  ,xFilial("SB7")			   	,Nil} )
					AADD( aVetor,{"B7_DATA"            ,dDataBase                  ,Nil} )
					AADD( aVetor,{"B7_COD"             ,SBF->BF_PRODUTO            ,Nil} )
					AADD( aVetor,{"B7_LOCAL"           ,SBF->BF_LOCAL              ,Nil} )
					//AADD( aVetor,{"B7_QUANT"         ,SBF->BF_QUANT		         ,Nil} )
					AADD( aVetor,{"B7_QUANT"           ,0		                     ,Nil} )
					AADD( aVetor,{"B7_DOC"             ,'INVENT'                   ,Nil} )
			      AADD( aVetor,{"B7_LOTECTL"         ,SBF->BF_LOTECTL            ,Nil} )
					If SB1->B1_LOCALIZ == 'S'
						AADD(aVetor,{"B7_LOCALIZ"      ,SBF->BF_LOCALIZ             ,Nil} )
					EndIf
					
					lBloqueado := .F.
					If SB1->B1_MSBLQL = '1'
						Reclock("SB1",.F.)
						SB1->B1_MSBLQL := '2'
						SB1->( msUnlock() )
						lBloqueado := .T.
					EndIf
					
					//BEGIN transaction
					
							MSExecAuto({|x,y,z| MATA270(x,y,z)},aVetor,.f.,3)
							
							If lBloqueado
							   Reclock("SB1",.F.)
							   SB1->B1_MSBLQL := '1'
							   SB1->( msUnlock() )
							EndIf
							
							If lMSErroAuto

								MOSTRAERRO()
								lMSHelpAuto := .T.  // Para mostrar os erro na tela
								lMSErroAuto := .F.  // Inicializa como falso, se voltar verdadeiro é que deu erro
							Endif
							
					//END Transaction

			EndIf
			
		EndIf
		
	EndIf             
	
	SBF->( dbSkip() )
	
Enddo

RestArea(aAreaSBF)

Return