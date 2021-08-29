#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExplSC4   บAutor  ณHelio Ferreira      บ Data ณ  31/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Domex                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------------------------------------------------*
User Function  ExplSC4()
*--------------------------------------------------------------------------*
Local x        := 0
PRIVATE aEstruPA := {} 

// If Type("cUsuario") == "U"
//   aAbreTab := {}
//   RpcSetEnv("01","01",,,,,aAbreTab) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
//   SetUserDefault("000000")
//EndIf

cQuery := " SELECT * FROM SC4010  "
cQuery += " WHERE C4_XXCOD  <> '' "
cQuery += " AND C4_XCODPA   = ''"      // PRODUTO PAI DA PREVISAO
cQuery += " AND C4_XXCODPA  = ''  "      // FLAG PARA ITEM PAI
cQuery += " AND C4_PRODUTO <> ''  "
cQuery += " AND C4_QUANT    > 0   "
cQuery += " AND D_E_L_E_T_ = ''   "
cQuery += " AND C4_FILIAL='"+xFILIAL('SC4')+"' "
cQuery += " ORDER BY C4_XXCOD "

If Select("QUERYSC4") <> 0
	QUERYSC4->( dbCloseAll() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSC4"

While !QUERYSC4->( EOF() )
//	aEstruMP := {}
	aEstruPA := {}

	ExpEstr2(QUERYSC4->C4_PRODUTO,QUERYSC4->C4_QUANT)
	
	C4FILIAL := QUERYSC4->C4_FILIAL
	C4LOCAL  := QUERYSC4->C4_LOCAL
	C4DATA   := QUERYSC4->C4_DATA
	C4CLIEN  := QUERYSC4->C4_XXCLIEN
	C4LOJA   := QUERYSC4->C4_XXLOJA
	C4NOME   := QUERYSC4->C4_XXNOMCL
	C4CNPJ   := QUERYSC4->C4_XXCNPJ
	C4EMISS  := QUERYSC4->C4_XXDTEMI
	C4XXPRI  := QUERYSC4->C4_XXPRI
	C4XXCOD  := QUERYSC4->C4_XXCOD
//	C4QTDPAI := QUERYSC4->C4_QUANT
	C4PA     := QUERYSC4->C4_PRODUTO
    C4XXSIMU := QUERYSC4->C4_XXSIMU
	
	SC4->( dbGoTo(QUERYSC4->R_E_C_N_O_) )
	If SC4->( Recno() ) == QUERYSC4->R_E_C_N_O_
		SC4->(Reclock("SC4",.F.))
		SC4->C4_XXCODPA := "XXXXXX"
		SC4->C4_XCODPA  := C4PA
	    SC4->C4_XXSIMU  := C4XXSIMU
		IF Len(aEstruPA)>0
			SC4->C4_PRODUTO := ''
		ENDIF
		SC4->( msUnlock() )
		
		For x := 1 to Len(aEstruPA)
			SC4->(Reclock("SC4",.T.))
			SC4->C4_FILIAL  := C4FILIAL
			SC4->C4_PRODUTO := aEstruPA[x,1]
			SC4->C4_LOCAL   := C4LOCAL
			SC4->C4_QUANT   := aEstruPA[x,2]
			SC4->C4_DATA    := CTOD(SUBSTR(C4DATA,7,2)+'/'+SUBSTR(C4DATA,5,2)+'/'+SUBSTR(C4DATA,1,4))
			SC4->C4_XXCLIEN := C4CLIEN
			SC4->C4_XXLOJA  := C4LOJA
			SC4->C4_XXNOMCL := C4NOME
			SC4->C4_XXQTDOR := aEstruPA[x,2]
			SC4->C4_XXCNPJ  := C4CNPJ
			SC4->C4_XXDTEMI := CTOD(SUBSTR(C4EMISS,7,2)+'/'+SUBSTR(C4EMISS,5,2)+'/'+SUBSTR(C4EMISS,1,4))
			SC4->C4_XXCOD   := C4XXCOD
			SC4->C4_XXPRI   := C4XXPRI
			SC4->C4_XCODPA  := C4PA
		    SC4->C4_XXSIMU  := C4XXSIMU
			SC4->( msUnlock() )
		Next x
	EndIf
	
	QUERYSC4->( dbSkip() )
End
QUERYSC4->(dbCloseArea())

Return


// Funcao adicionada por Cesar Arneiro, em 29/03/2018, para permitir chamar o procedimento de explosao de estrutura atraves de User Function
*--------------------------------------------------------------------------*
User Function ofExpEstr(cProduto,nQuant)
*--------------------------------------------------------------------------*

Private aEstruPA := {}

ExpEstr2(cProduto,nQuant)

Return(aEstruPA)

*--------------------------------------------------------------------------*
Static Function  ExpEstr2(cProduto,nQuantPai)
*--------------------------------------------------------------------------*

PRIVATE nQtdBase   :=1
PRIVATE cCOMP      :=''
PRIVATE nQTDCOMP   :=0

SG1->(dbSelectArea("SG1"))
SG1->(dbSeek(xFilial('SG1')+cProduto))

EXPLSC4B(cProduto,nQuantPai,nQtdBase)
RETURN

*--------------------------------------------------------------------------*
STATIC Function EXPLSC4B(cProduto,nQuantPai,nQtdBase)
*--------------------------------------------------------------------------*
LOCAL nReg,nQuantItem := 0

dbSelectArea("SG1")
While !Eof() .And. G1_FILIAL+G1_COD == xFilial()+cProduto
	IF G1_FIM >=DATE()
		nReg       := Recno()
		nQuantItem := ExplEstr(nQuantPai,,,)
		dbSelectArea("SG1")
		
		//SB1->(dbSelectArea("SG1"))
		//SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
		//AADD(aEstruPA,{SG1->G1_COMP,nQuantItem})
		cCOMP   :=SG1->G1_COMP
		nQTDCOMP:=nQuantItem
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica se existe sub-estrutura                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
     	dbSelectArea("SG1")
    	dbSeek(xFilial()+G1_COMP)
		IF Found()
			EXPLSC4B(G1_COD,nQuantItem,nQtdBase)
		ELSE
			AADD(aEstruPA,{cCOMP,nQTDCOMP})
		EndIf
		dbGoto(nReg)
	ENDIF
	SG1->(dbSkip())
EndDo

Return


/*

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Explode  บAutor  ณMichel A. Sander    บ Data ณ  05/16/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Explode a estrutura do produto									  บฑฑ
ฑฑบ          ณ 																			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
STATIC Function ExpEstr2(_cProduto,aArray)

LOCAL _nRegi

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona na estrutura ou sub-estrutura         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial()+_cProduto)

While !Eof() .And. G1_FILIAL+G1_COD == xFilial()+_cProduto

_nRegi := Recno()
_nProcura:=ASCAN(aArray,{|x| x[2]==G1_COMP})
If _nProcura  = 0
AADD(aArray,{G1_COD,G1_COMP,G1_QUANT})
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se existe sub-estrutura                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nRecno := Recno()

If dbSeek(xFilial()+G1_COMP,.F.)

ExpEstr2(G1_COD,@aArray)

Else
dbGoto(_nRecno)
_nProcura:=ASCAN(aArray,{|x| x[2]==G1_COMP})
If _nProcura  = 0
AADD(aArray,{G1_COD,G1_COMP,G1_QUANT})
EndIf
Endif

dbGoto(_nRegi)
dbSkip()

Enddo

Return
