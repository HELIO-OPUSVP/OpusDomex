#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณascan  บAutor  ณJonas Pereira      บ Data ณ  28.05.2020   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida quantidades para faturamento	  				   บฑฑ
ฑฑบ          ณ 										     			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿*/


User Function VLQTDFAT(cNumPV, dData)

Local _Retorno := ''

//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

//cNumPV := '043013' 
//dData  := DDATABASE

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeleciona o pedido para faturamento                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQueryTMPNFS := "SELECT * FROM "+RetSqlName("SZY")+" WHERE ZY_PEDIDO = '"+cNumPV+"' AND ZY_PRVFAT = '"+DtoS(dData)+"' AND ZY_NOTA = '' AND D_E_L_E_T_ = '' ORDER BY ZY_PEDIDO, ZY_ITEM, ZY_SEQ "
If Select("QUERYSZY") <> 0
	QUERYSZY->( dbCloseArea() )
EndIf

TCQUERY cQueryTMPNFS NEW ALIAS "QUERYSZY"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณvalida os itens do pedido					                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SC6->( dbSetOrder(1) )
While !QUERYSZY->( EOF() )
	If SC6->( dbSeek( xFilial() + QUERYSZY->ZY_PEDIDO + QUERYSZY->ZY_ITEM ) )
		If SC6->C6_PRODUTO == QUERYSZY->ZY_PRODUTO
			If QUERYSZY->ZY_QUANT <= (SC6->C6_QTDVEN - SC6->C6_QTDENT)                                    
                    //EXECUTA PRIMEIRA VERIFICAวรO
                    If !FSALDO(SC6->C6_PRODUTO, SC6->C6_LOCAL, SC6->C6_LOTECTL, SC6->C6_DTVALID, QUERYSZY->ZY_QUANT, .f. )
                        //SE NAO Hม SALDO EXECUTA NOVAMENTE COM O RECALCULO REALIZADO
                        If !FSALDO(SC6->C6_PRODUTO, SC6->C6_LOCAL, SC6->C6_LOTECTL, SC6->C6_DTVALID, QUERYSZY->ZY_QUANT, .t. )
                            _Retorno := 'Nใo hแ saldo para o material '+SC6->C6_PRODUTO+Chr(13)+Chr(10)+Chr(13)+Chr(10)+'Armazem '+SC6->C6_LOCAL+', lote '+SC6->C6_LOTECTL+' e quantidade '+alltrim(str(QUERYSZY->ZY_QUANT))+Chr(13)+Chr(10)+Chr(13)+Chr(10)
                            Exit   
                        EndIf
                    EndIf                                                        				
			EndIf
		EndIf
	EndIf
	QUERYSZY->( dbSkip() )
End


//RESET ENVIRONMENT
Return _Retorno

Static function fsaldo(cProd, cLocal, cLoteCTL, dDTVAlid, nQtd, lsecond)
local lRet := .t.

If P07->(dbSeek(xFilial()+cProd+cLocal))  .or. lsecond
    U_JobPASld(cEmpAnt,cProd)
EndIf    

If SB2->( dbSeek( xFilial() + cProd + cLocal ) )
	If SB2->B2_QATU >= nQtd
        //If SB1->( dbSeek( xFilial() + cProd  ) )
        If !Empty(alltrim(cLoteCTL))
            //Produto de revenda nao valida o LOTE -- EM BRANCO NO SC6
            If SB1->B1_TIPO<>'PR'
                SB8->( DBSetOrder(3) )
		        If SB8->( dbSeek( xFilial() + cProd + cLocal  + cLoteCTL ) )
                    If SB8->B8_SALDO >= nQtd
                        lRet := .t.
                    else
                        //sb8 sem saldo
                        lRet := .F.                
                    EndIF
                Else
                //sb8 nao encontrado
                lRet := .F.
		        EndIf            
            EndIf            
        EndIf
    Else
        //sb2 sem saldo
        lRet := .F.
    EndIf
else
    //sb2 nao encontrado
    lRet := .F.
EndIf


return lRet
