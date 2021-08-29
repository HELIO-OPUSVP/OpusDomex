#include "tbiconn.ch"
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "TOTVS.CH"

User Function REQTMP()
Local aArray  := {}
Local aReturn := {}                      
Local cQuery  := "" 
Local aDados  := {}
Local aSaldos := {}
Local x       := 1
Local dFim    := CTOD('31/03/2020')

PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'    
/*
cQuery  := " SELECT B2_FILIAL, B2_COD, B2_LOCAL,  B2_VFIM1, B2_QFIM AS B2_QFIM FROM SB2010 (NOLOCK) "
cQuery  += " WHERE B2_QFIM<=0 AND B2_VFIM1<>0 AND D_E_L_E_T_='' AND B2_FILIAL='01' "

If Select("TMP") <> 0
	TMP->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMP"     

While !TMP->(EOF())

//TMATA241(TMP->B2_COD, TMP->B2_LOCAL, TMP->B2_VFIM1, CTOD('31/10/2018'),  TMP->B2_QFIM)	                            
TMATA241(TMP->B2_COD, TMP->B2_LOCAL, (TMP->B2_VFIM1), CTOD('30/09/2019'),  (TMP->B2_QFIM))	                            
//TMATA241(TMP->B2_COD, TMP->B2_LOCAL, (TMP->B2_VFIM1), CTOD('28/02/2019'),  0)	                            

TMP->(dbSKIP())
Enddo		   

*/

/*
   Aadd(aDados,{"294KIT127315D","01", 28.87 , Nil})
   Aadd(aDados,{"110FD6M8L","11", 646.25 , Nil})
   Aadd(aDados,{"160940","11", 46.22 , Nil})
   Aadd(aDados,{"160S8001","11", 11.93 , Nil})
   Aadd(aDados,{"50008111135LQ25","11", 0.76 , Nil})
   Aadd(aDados,{"700090170400032","11", 4.82 , Nil})
   Aadd(aDados,{"16413KITMOD01","97", 42.59 , Nil})
   Aadd(aDados,{"1641BKITMOD01","97", 2.24 , Nil})
   Aadd(aDados,{"1642BKITACE01","97", 223.05 , Nil})
   Aadd(aDados,{"16451KITACE01","97", 7.72 , Nil})
   Aadd(aDados,{"1645CKITPNLA73","97", 10.19 , Nil})
   Aadd(aDados,{"16477KIT01","97", 18.54 , Nil})
   Aadd(aDados,{"1647D0","97", 24.97 , Nil})
   Aadd(aDados,{"16484KITPNL270","97", 22.96 , Nil})
   Aadd(aDados,{"16484KITPNL273","97", 390.18 , Nil})
   Aadd(aDados,{"16484KITPNL292","97", 53.26 , Nil})
   Aadd(aDados,{"16484KITPNL2L0","97", 9.24 , Nil})
   Aadd(aDados,{"16484KITPNL370","97", 22.96 , Nil})
   Aadd(aDados,{"16484KITPNL373","97", 45.02 , Nil})
   Aadd(aDados,{"16484KITPNL392","97", 306.99 , Nil})
   Aadd(aDados,{"16484KITPNL3L0","97", 7.98 , Nil})
   Aadd(aDados,{"16484KITPNLA70","97", 22.96 , Nil})
   Aadd(aDados,{"16484KITPNLA73","97", 27.01 , Nil})
   Aadd(aDados,{"16484KITPNLA93C","97", 21.17 , Nil})
   Aadd(aDados,{"16484KITPNLAL0","97", 3.79 , Nil})
   Aadd(aDados,{"1648CKIT01O","97", 42.39 , Nil})
   Aadd(aDados,{"1648CKITPNL273","97", 300.12 , Nil})
   Aadd(aDados,{"1648CKITPNL373","97", 300.12 , Nil})
   Aadd(aDados,{"1648EKITACE01F","97", 27.01 , Nil})
   Aadd(aDados,{"1648EKITPNL270","97", 806.98 , Nil})
   Aadd(aDados,{"1648EKITPNL273","97", 1574.88 , Nil})
   Aadd(aDados,{"16494KIT01","97", 17.99 , Nil})
   Aadd(aDados,{"16494KITACES01F","97", 87.15 , Nil})
   Aadd(aDados,{"16494KITPNLC73","97", 236.35 , Nil})
   Aadd(aDados,{"16494KITPNLC93C","97", 95.80 , Nil})
   Aadd(aDados,{"16494KITPNLCL7","97", 48.71 , Nil})
   Aadd(aDados,{"164E1KITACE01F","97", 0.32 , Nil})
   Aadd(aDados,{"164KITEMEND1","97", 0.08 , Nil})
   Aadd(aDados,{"164KITEMEND4","97", 2.75 , Nil})
   Aadd(aDados,{"164MAKITPLE270","97", 221.92 , Nil})
   Aadd(aDados,{"164MAKITPLE273","97", 87.55 , Nil})
   Aadd(aDados,{"164MAKITPLE293C","97", 77.34 , Nil})
   Aadd(aDados,{"164MAKITPNL273","97", 28.43 , Nil})
   Aadd(aDados,{"164MAKITPNL293C","97", 42.18 , Nil})
   Aadd(aDados,{"164P2KIT01","97", 20.25 , Nil})
   Aadd(aDados,{"164Q8KITPNLB93C","97", 21.64 , Nil})
   Aadd(aDados,{"164QEKITACE01","97", 7.23 , Nil})
   Aadd(aDados,{"164S1KITACE01","97", 8.82 , Nil})
   Aadd(aDados,{"164S4KITACE01","97", 13.75 , Nil})
   Aadd(aDados,{"164S5KIT01","97", 47.76 , Nil})
   Aadd(aDados,{"164S7KITACE01","97", 55.00 , Nil})
   Aadd(aDados,{"167E3MO1270MAJ0","97", 371.48 , Nil})
   Aadd(aDados,{"16D94KITPNLC93","97", 127.73 , Nil})
   Aadd(aDados,{"1D7KITINSTBW01","97", 515.77 , Nil})
   Aadd(aDados,{"1D7KITINSTFTH01","97", 490.15 , Nil})
   Aadd(aDados,{"1MI1060700030","97", 945.74 , Nil})
   Aadd(aDados,{"1MI1062L80030","97", 2076.47 , Nil})
   Aadd(aDados,{"1P14KITBOBINAM2","97", 78.26 , Nil})
   Aadd(aDados,{"1P14KITCM291000","97", 0.28 , Nil})
   Aadd(aDados,{"1P14KITCM501000","97", 2.04 , Nil})
   Aadd(aDados,{"1P1RKITA2LF48C","97", 13.96 , Nil})
   Aadd(aDados,{"1P1RKITA2RD12S","97", 1.21 , Nil})
   Aadd(aDados,{"1P1RKITA2RD144S","97", 368.68 , Nil})
   Aadd(aDados,{"1P1RKITA2RD24S","97", 88.95 , Nil})
   Aadd(aDados,{"1P1RKITA2RD48DX","97", 6.35 , Nil})
   Aadd(aDados,{"1P1RKITA2RD48S","97", 187.08 , Nil})
   Aadd(aDados,{"1P1RKITA3RD48S","97", 0.22 , Nil})
   Aadd(aDados,{"1P1RKITBOBINMD1","97", 19.82 , Nil})
   Aadd(aDados,{"1P1RKITCAIXA1","97", 11.33 , Nil})
   Aadd(aDados,{"1P1RKITCM501500","97", 212.20 , Nil})
   Aadd(aDados,{"1P1RKITCM502500","97", 309.58 , Nil})
   Aadd(aDados,{"1P1RKITCM650700","97", 13.93 , Nil})
   Aadd(aDados,{"1PDRKITA2L348S","97", 5.23 , Nil})
   Aadd(aDados,{"1PDRKITA2RD24S","97", 7.47 , Nil})
   Aadd(aDados,{"1PDRKITA3L348S","97", 0.06 , Nil})
   Aadd(aDados,{"1PDRKITCM501200","97", 4.32 , Nil})
   Aadd(aDados,{"1PDRKITSC48FST","97", 693.41 , Nil})
   Aadd(aDados,{"1PORKITMT12FUTR","97", 283.86 , Nil})
   Aadd(aDados,{"1PORKITMTP12UT","97", 298.29 , Nil})
   Aadd(aDados,{"1PORKITMTP48F","97", 1.28 , Nil})
   Aadd(aDados,{"1PORKITSC144F","97", 373.09 , Nil})
   Aadd(aDados,{"1PORKITSC24F","97", 8.36 , Nil})
   Aadd(aDados,{"1PORKITSC48F","97", 7.67 , Nil})
   Aadd(aDados,{"294KIT127312D","97", 892.57 , Nil})
   Aadd(aDados,{"294KITINSTRACK1","97", 26.16 , Nil})
   Aadd(aDados,{"500080329232R","97", 31.83 , Nil})
   Aadd(aDados,{"500080329242R","97", 32.86 , Nil})
   Aadd(aDados,{"500080329252R","97", 15.31 , Nil})
   Aadd(aDados,{"50008111000029","97", 13.00 , Nil})
   Aadd(aDados,{"5000811101S142L","97", 51.18 , Nil})
   Aadd(aDados,{"5000811101S152L","97", 1.37 , Nil})
   Aadd(aDados,{"5000811101S182R","97", 1.87 , Nil})
   Aadd(aDados,{"50008111135LQ26","97", 65.72 , Nil})
   Aadd(aDados,{"50008111244L726","97", 0.64 , Nil})
   Aadd(aDados,{"5000811124CLQ27","97", 69.69 , Nil})
   Aadd(aDados,{"500081112P3LQ12","97", 2539.44 , Nil})
   Aadd(aDados,{"5000811165021","97", 73.15 , Nil})
   Aadd(aDados,{"5000811165027","97", 17.21 , Nil})
   Aadd(aDados,{"500081116C37031","97", 0.16 , Nil})
   Aadd(aDados,{"500081116O21801","97", 0.60 , Nil})
   Aadd(aDados,{"500081116O3L721","97", 13.42 , Nil})
   Aadd(aDados,{"500081118F0014","97", 7.64 , Nil})
   Aadd(aDados,{"50008111GSEV007","97", 51.66 , Nil})
   Aadd(aDados,{"50008111P100206","97", 2.96 , Nil})
   Aadd(aDados,{"50008112656L701","97", 0.58 , Nil})
   Aadd(aDados,{"500081128441806","97", 4.66 , Nil})
   Aadd(aDados,{"500081128E37001","97", 282.98 , Nil})
   Aadd(aDados,{"500081128F49706","97", 3.54 , Nil})
   Aadd(aDados,{"500081129837006","97", 18.12 , Nil})
   Aadd(aDados,{"500081129837007","97", 20.14 , Nil})
   Aadd(aDados,{"500081129837008","97", 7.79 , Nil})
   Aadd(aDados,{"50008112983L006","97", 1.74 , Nil})
   Aadd(aDados,{"50008112983L007","97", 1.74 , Nil})
   Aadd(aDados,{"50008112983L008","97", 4.09 , Nil})
   Aadd(aDados,{"50008112Q97021","97", 0.43 , Nil})
   Aadd(aDados,{"5000813317041","97", 30.19 , Nil})
   Aadd(aDados,{"500081331L741","97", 1137.85 , Nil})
   Aadd(aDados,{"5000813327041","97", 4.98 , Nil})
   Aadd(aDados,{"500081703021","97", 148.68 , Nil})
   Aadd(aDados,{"50008170921","97", 19.62 , Nil})
   Aadd(aDados,{"500081724311","97", 130.20 , Nil})
   Aadd(aDados,{"500081724312","97", 257.16 , Nil})
   Aadd(aDados,{"50008179511","97", 4.68 , Nil})
   Aadd(aDados,{"50008179512","97", 3.27 , Nil})
   Aadd(aDados,{"5000838811VA","97", 5.16 , Nil})
   Aadd(aDados,{"50008710902","97", 0.31 , Nil})
   Aadd(aDados,{"50008711011","97", 0.29 , Nil})
   Aadd(aDados,{"700090170400124","97", 8.90 , Nil})
   Aadd(aDados,{"700090170400126","97", 42.44 , Nil})
   Aadd(aDados,{"700090170400225","97", 3.06 , Nil})
   Aadd(aDados,{"700090170400421","97", 106.17 , Nil})
   Aadd(aDados,{"DMXFLMSL0L0250","97", 361.54 , Nil})
   Aadd(aDados,{"DMXFON40092015D","97", 4248.81 , Nil})
   Aadd(aDados,{"DMXFON400L2015D","97", 1978.72 , Nil})
   Aadd(aDados,{"JP0010808010000","97", 48.76 , Nil})
*/

   Aadd(aDados,{"1P4BD1M808D1K5H","13", 0.04 , Nil})
   Aadd(aDados,{"1P4BD1M808D2K2H","13", 0.03 , Nil})
   Aadd(aDados,{"1P4BD1M808D500H","13", 0.02 , Nil})
   Aadd(aDados,{"164KITCAS01","97",    14.67 , Nil})
   Aadd(aDados,{"1P14KITCAIXA2","97", 78.26 , Nil})
   Aadd(aDados,{"DMXFLMD7093100","97", 13.80 , Nil})





For x := 1 to len(aDados)

	TMATA241(aDados[x][1], aDados[x][2], aDados[x][3] * -1, CTOD('31/03/2020'),  0)

Next

RESET ENVIRONMENT

Return                                

Static Function TMATA241(cCodProd, cLocal, nQTD, dDT, nQTDb )

Local _aCab1    := {}
Local _aItem    := {}
Local _atotitem := {}
Local nTipo     := 0
Local cReturn   := ""                 


Local cCodigoTM := SPACE(3)

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

//Private _acod:={"1","MP1"}     

If	nQTD>0
	cCodigoTM   := "502"   
Else   
	nQTD			:= (nQTD*-1)  
	nQTDB			:= (nQTDB*-1)
	cCodigoTM   := "002"
endIf    



dbSelectArea("SB1")
dbSetOrder(1)
SB1->(dbSeek(xFilial("SB1")+cCodProd))
	
dbSelectArea("SD3")
dbSetOrder(1)
nTipo := 3
_aCab1 := { {"D3_TM" ,cCodigoTM      , NIL},;
			   {"D3_EMISSAO" ,dDT       , NIL}}
	
_aItem := { ;
			   {"D3_COD"     ,cCodProd   ,NIL},;
			   {"D3_UM"      ,SB1->B1_UM ,NIL},;
			   {"D3_QUANT"   ,nQTDb	     ,NIL},; 
			   {"D3_CUSTO1"  ,(nQTD)	  ,NIL},; 
			   {"D3_LOCAL"   ,cLocal     ,NIL}}
//{"D3_OP"      ,cCodOP     ,NIL},;
//{"D3_LOTECTL" , cLoteCTL  ,NIL}}
	

aadd(_atotitem,_aitem)
MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,nTipo)


If lMsErroAuto
	MOSTRAERRO()
EndIf

Return //(cReturn)