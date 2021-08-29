#include "rwmake.ch"
#include "topconn.ch"

User Function DOMRVI01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := "Visita Vendedor"
Local   cPict       := ""
Local   titulo      := "Visita Vendedor"
Local   nLin        := 08
Local   Cabec1      := "Agend   Vendedor                    Cliente                        Prospect                       Contato                     Tipo                    Data         Realizado "
Local   Cabec2      := ""
Local   imprime     := .T.
Local   aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "DOMRVI01"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0 
Private cPerg       := "Z6VISITA  "
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "DOMRVI01"
Private cString     := "SZ6"
Private Cgruporet   :=''
Private cGrupo      :=''
Private nCont       :=1
Private NX          :=0
Private NI          :=0


pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Private NI  :=0

MV12 :=''
nCont  :=1
IF len(MV_PAR12)> 3
	FOR NI :=1 TO  len(MV_PAR12)/2
		IF SUBSTR(MV_PAR12,nCont,2)<>'**'
			MV12 +=",'"+SUBSTR(MV_PAR12,nCont,2)+"'
		ENDIF
		nCont :=nCont+2
	NEXT
	MV12:=SUBSTR(MV12,2,LEN(MV12))
ENDIF

cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName('SZ6') + " "
cQuery += " WHERE D_E_L_E_T_<>'*' "
cQuery += "        AND Z6_VEND   >='"+MV_PAR01+"'        AND Z6_VEND   <='"+MV_PAR02+"' "
cQuery += "        AND Z6_CLI    >='"+MV_PAR03+"'        AND Z6_CLI    <='"+MV_PAR05+"' "
cQuery += "        AND Z6_LJCLI  >='"+MV_PAR04+"'        AND Z6_LJCLI  <='"+MV_PAR06+"' "
cQuery += "        AND Z6_PROSP  >='"+MV_PAR07+"'        AND Z6_PROSP  <='"+MV_PAR09+"' "
cQuery += "        AND Z6_LJPRO  >='"+MV_PAR08+"'        AND Z6_LJPRO  <='"+MV_PAR10+"' "
cQuery += "        AND Z6_DATA   >='"+DTOS(MV_PAR13)+"'  AND Z6_DATA   <='"+DTOS(MV_PAR14)+"' "
cQuery += "        AND Z6_DTREAL >='"+DTOS(MV_PAR15)+"'  AND Z6_DTREAL <='"+DTOS(MV_PAR16)+"' "
IF   MV_PAR11==1
     cQuery += "        AND Z6_TIPO IN ("+MV12+")  "
ENDIF     
cQuery += " ORDER BY Z6_CODAG  "

TCQUERY cQuery NEW ALIAS "TR1"

TR1->( dbGoTop() )

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

DO While TR1->(!EOF())
	
	@ nLin,000 pSay TR1->Z6_CODAG
	@ nLin,008 pSay TR1->Z6_VEND    +'-'+ SUBSTR(POSICIONE('SA3',1,xFILIAL('SA3')+TR1->Z6_VEND,'A3_NOME'),1,20)
	@ nLin,036 pSay TR1->Z6_CLI     +'/'+TR1->Z6_LJCLI +'-'+ SUBSTR(POSICIONE('SA1',1,xFILIAL('SA1')+TR1->Z6_CLI  +TR1->Z6_LJCLI,'A1_NOME'),1,20)
	@ nLin,067 pSay TR1->Z6_PROSP   +'/'+TR1->Z6_LJPRO +'-'+ SUBSTR(POSICIONE('SUS',1,xFILIAL('SUS')+TR1->Z6_PROSP+TR1->Z6_LJPRO,'US_NOME'),1,20)
	@ nLin,098 pSay TR1->Z6_CONTATO +'-'+ SUBSTR(POSICIONE('SU5',1,xFILIAL('SU5')+TR1->Z6_CONTATO,'U5_CONTAT'),1,20)
	@ nLin,126 pSay TR1->Z6_TIPO
	@ nLin,151 pSay SUBSTR(TR1->Z6_DATA,7,2)  +'/'+SUBSTR(TR1->Z6_DATA,5,2)  +'/'+SUBSTR(TR1->Z6_DATA,1,4)
	@ nLin,162 pSay SUBSTR(TR1->Z6_DTREAL,7,2)+'/'+SUBSTR(TR1->Z6_DTREAL,5,2)+'/'+SUBSTR(TR1->Z6_DTREAL,1,4) 
	nLin:=nLin+1 

	IF MV_PAR17==1
	   @ nLin,008 pSay SUBSTR(TR1->Z6_OBS,1,180)
	   nLin:=nLin+1
	   IF !EMPTY (ALLTRIM(SUBSTR(TR1->Z6_OBS,1,LEN(TR1->Z6_OBS))))
	      @ nLin,008 pSay SUBSTR(TR1->Z6_OBS,181,LEN(TR1->Z6_OBS))
	      @ nLin:=nLin+1
	   ENDIF
      @ NLIN,000 PSAY __PrtThinLine()
      nLin:=nLin+1
   ENDIF   

	IF NLIN > 57
	   Roda(0,"",Tamanho)
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 08
	ENDIF      
	
	TR1->(DBSKIP())
ENDDO       
TR1->(DBCLOSEAREA())
Roda(0,"","M")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
