#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "TOpconn.ch"
#include "protheus.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  CUSDOINT  �Autor  �Jonas Pereira      � Data �     01/2021   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento paralelo do custo medio                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function CUSDOINT() 
Private dMvUlmes  := SuperGetMV("mv_ulmes") 
Private dGet1	  := dMvUlmes+1      //Date() // Vari�vel do tipo Data
Private dGet2 	  := LASTDAY(dMvUlmes+1) //Date() // Vari�vel do tipo Data
Private _cPerg    := "CUSDOINT"+Space(02)
Private dInic     := CTOD("  /  /  ")
Private dFimc     := CTOD("  /  /  ")
Private nTot      := 0
   
fCriaPerg(_cPerg)


return

If MsgYesNo("O programa faz a integra��o do custo m�dio ao Ambiente Oficial, deseja continuar?")
    If !Pergunte(_cPerg, .T.)
        Return
    Else
        dInic := mv_par01
        dFimc := mv_par02
        If fvalid()            
		    //MsgRun("Processando...","Aguarde",{||fprocessa()})
            Processa({|| fprocessa()},"Aguarde Processando...")            
        Endif
    EndIf   	
EndIf

Return

Static function fvalid()
lValid := .t.

If dGet1 != dInic

    MSGALERT("Aten��o, a data inicial selecionada n�o corresponde ao dia apos o �ltimo fechamento "+dtoc(dGet1)+" !")
    lValid := .f.

ElseIf Month(dInic) != Month(dFimc) .or. Year(dInic) != Year(dFimc)

    MSGALERT("Aten��o, a data inicial e final devem ser do mesmo per�odo Ano / M�s de processamento!")
    lValid := .f.

Else

    cQuery := " SELECT count(*) as TOT FROM SD3010 (NOLOCK) WHERE D_E_L_E_T_='' AND D3_FILIAL='"+xFilial("SD3")+"'  AND D3_EMISSAO BETWEEN '"+DTOS(dInic)+"' AND '"+DTOS(dFimc)+"'  " // AND D3_SEQCALC<>''

    If Select("TMP") <> 0
		TMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS TMP

	If TMP->(EOF()) 
        MSGALERT("Aten��o, o Custo m�dio n�o foi processado, n�o h� registros a serem integrados!")
        lValid := .f.
    ElseIf TMP->TOT == 0
         MSGALERT("Aten��o, o Custo m�dio n�o foi processado, n�o h� registros a serem integrados!")
        lValid := .f.
    Else
        nTot := TMP->TOT
        TMP->( dbCloseArea() )
    EndIf

EndIf

Return lValid


Static function fprocessa()
local x
Local Nx
Local aRec := {}


nTot := dFimc - dInic

//SD3
ProcRegua(nTot)
For x := dInic to dFimc
    
    IncProc("Atualizando SD3, dia " + dtoc(x) + " de " + dtoc(dFimc) + "...")
         
    //SD3
    cQuery := " SELECT (R_E_C_N_O_) as rec FROM SD3010 (NOLOCK) WHERE  D_E_L_E_T_='' AND D3_FILIAL='"+xFilial("SD3")+"'  AND D3_EMISSAO = '"+DTOS(x)+"'   " //AND D3_SEQCALC<>''

    If Select("TMP") <> 0
	    TMP->( dbCloseArea() )
    EndIf

    TCQUERY cQuery NEW ALIAS TMP

    While TMP->(!EOF()) 
        AADD(aRec,TMP->rec)
      TMP->(dbskip())
    Enddo

    For Nx := 1 to Len(aRec)

        cQryD3 := " UPDATE [SERVIDOROFICIAL].[PROTHEUS12].[dbo].[SD3010] "
        cQryD3 += " SET SD3OFI.D3_CUSTO1=SD3TST.D3_CUSTO1                "
        cQryD3 += " FROM [SERVIDOROFICIAL].[PROTHEUS12].[dbo].[SD3010] AS SD3OFI INNER JOIN [Protheus_teste].[dbo].[SD3010] AS SD3TST "
        cQryD3 += " ON SD3OFI.R_E_C_N_O_=SD3TST.R_E_C_N_O_ "
        cQryD3 += " WHERE SD3OFI.D_E_L_E_T_='' AND  SD3TST.D_E_L_E_T_='' AND SD3TST.D3_EMISSAO = '"+DTOS(x)+"'  AND SD3OFI.D3_EMISSAO = '"+DTOS(x)+"'  AND SD3TST.D3_FILIAL='"+xFilial("SD3")+"' AND SD3OFI.D3_FILIAL='"+xFilial("SD3")+"'  AND SD3OFI.R_E_C_N_O_ = '"+str(aRec[Nx])+"'   "
        TCSQLEXEC(cQryD3)

    Next Nx

    aRec := {}

Next x



//SD2
ProcRegua(nTot)
For x := dInic to dFimc
    
    IncProc("Atualizando SD2, dia " + dtoc(x) + " de " + dtoc(dFimc) + "...")
         
    //SD2
    cQuery := " SELECT (R_E_C_N_O_) as rec FROM SD2010 (NOLOCK) WHERE D_E_L_E_T_='' AND D2_FILIAL='"+xFilial("SD2")+"'   AND D2_EMISSAO = '"+DTOS(x)+"'   " //AND D3_SEQCALC<>''

    If Select("TMP") <> 0
	    TMP->( dbCloseArea() )
    EndIf


    TCQUERY cQuery NEW ALIAS TMP

    While TMP->(!EOF()) 
        AADD(aRec,TMP->rec)
      TMP->(dbskip())
    Enddo

    For Nz := 1 to Len(aRec)

        cQryD2 := " UPDATE [SERVIDOROFICIAL].[PROTHEUS12].[dbo].[SD2010] "
        //cQryD2 := " UPDATE [Protheus_teste].[dbo].[SD2010] "
        cQryD2 += " SET SD2OFI.D2_CUSTO1=SD2TST.D2_CUSTO1                "
        cQryD2 += " FROM[SERVIDOROFICIAL].[PROTHEUS12].[dbo].[SD2010] AS SD2OFI INNER JOIN  [Protheus_TESTE].[dbo].[SD2010] AS SD2TST "
        cQryD2 += " ON SD2OFI.R_E_C_N_O_=SD2TST.R_E_C_N_O_ "
        cQryD2 += " WHERE SD2OFI.D_E_L_E_T_='' AND SD2TST.D_E_L_E_T_='' AND SD2TST.D2_EMISSAO = '"+DTOS(x)+"'  AND SD2OFI.D2_EMISSAO = '"+DTOS(x)+"'  AND SD2TST.D2_FILIAL='"+xFilial("SD2")+"'  AND SD2OFI.D2_FILIAL='"+xFilial("SD2")+"'  AND SD2OFI.R_E_C_N_O_ = '"+str(aRec[Nz])+"' "                                                                                                                                                                                                                                        
        
        TCSQLEXEC(cQryD2)
    NExt Nz

    aRec := {}

Next x

/*

//SB2
//SB6
//SC2
*/

Return


Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3               4  5     6      7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43
AADD(aRegistros,{_cPerg,"01","Data de Emiss�o de ?  ","","","mv_ch1","D",08,00,00,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{_cPerg,"02","Data de Emiss�o ate ? ","","","mv_ch2","D",08,00,00,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


DbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	Endif
Next i
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)
