#include "print.ch"
#include "font.ch" 
#include "colors.ch"
#include "Protheus.ch"
#include "Topconn.ch"
#include "Rwmake.ch"

#INCLUDE "RPCPR01.CH"

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto>;
=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, ''), ofnt,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> FONT <oFonte>;
=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, ''), <oFonte>,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture>;
=> oprn:say(<nLinha>*50+100, <nColuna>*30/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), ofnt,,;
CLR_BLACK)

#xcommand @ <nLinha>, <nColuna> PSAY <cTexto> PICTURE <cPicture> FONT <oFonte>;
=> oprn:say(<nLinha>*50+100, <nColuna>*25/*-<nColuna>/2*/+40, transform(<cTexto>, <cPicture>), <oFonte>,,;
CLR_BLACK)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DOMSENF2 � OPUSVP� Mauricio Lima de Souza� Data � 19.09.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio SENF  Com codigo de barras                       ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function DOMSENF2()
Local titulo  := 'SENF'
Local wnrel   := "DOMSENF2"
Local tamanho := "M"
Local resp
Local cQry
Local cOP1
Local cOP2
Private cPerg    :="DOMSENF01"+Space(01)
Private lItemNeg := .F.
Private plinha   := .t.
Private cContPg  := ""
Private nPAG     := 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
resp := pergunte(cPerg,.T.)

If !resp
   Return        
EndIf

//������������������������������������������������������������������������������������������������������
//� Coloca um flag em um campo criado para poder indicar ao pessoal do Estoque que um OP foi impressa. �
//������������������������������������������������������������������������������������������������������
_cPED1   :=MV_PAR01
_cPED2   :=MV_PAR02  

_cCLI1   :=MV_PAR03
_cCLI2   :=MV_PAR04  

_cLOJ1   :=MV_PAR05
_cLOJ2   :=MV_PAR06  

_dDtSep1 :=MV_PAR07
_dDtSep2 :=MV_PAR08  

cQry := " SELECT *  "
cQry += " FROM  SC5010 (NOLOCK) C5, SC6010 (NOLOCK) C6 "
cQry += " WHERE C5_NUM=C6_NUM  AND C5_FILIAL = '01' AND C6_FILIAL = '01' AND "
cQry += "       C6_QTDVEN-C6_QTDENT >0 AND C6_XXDTSEP >= '"+DtoS(_dDtSep1)+"' AND C6_XXDTSEP <= '"+DtoS(_dDtSep2)+"' AND C6_XXDTSEP <> '' AND C6_XXSEPAR = 'S' AND "
cQry += "       C5.D_E_L_E_T_<>'*' AND C6.D_E_L_E_T_<>'*'  AND "
cQry += "       C5_NUM    >='"+_cPED1+"'  AND C5_NUM    <='"+_cPED2+"' AND "
cQry += "       C5_CLIENTE>='"+_cCLI1+"'  AND C5_CLIENTE<='"+_cCLI2+"' AND "
cQry += "       C5_LOJACLI>='"+_cLOJ1+"'  AND C5_LOJACLI<='"+_cLOJ2+"' "
cQry += " ORDER BY C5_NUM,C6_ITEM   "

TcQuery cQry NEW Alias "TMP"

DBSELECTAREA("TMP")
DBGOTOP()

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

print oprn preview
define font ofnt  name "Courier New" /*bold*/ size 0,12 of oprn
define font ofnt2 name "Courier New" bold size 0,10 of oprn
define font ofnt3 name "Courier New" bold size 0,12 of oprn

RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

TMP->( dbCloseArea() )

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DOMSENF2 � OPUSVP� Mauricio Lima de Souza� Data � 19.09.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio SENF  Com codigo de barras                       ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local CbCont,cabec1,cabec2
Local limite     := 100
Local nQuant     := 1
Local nomeprog   := "DOMSENF02"
Local nTipo      := 18
Local cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd
Local cIndSC2    := CriaTrab(NIL,.F.), nIndSC2
Private aArray   := {}
Private li       := 100

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(0)
cbcont   := 0
m_pag    := 0
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := ""
cabec2 := ""

dbSelectArea("TMP")

SetRegua(LastRec())


//���������������������������������������������������������Ŀ
//� Imprime cabecalho                                       �
//�����������������������������������������������������������

nPAG     := 1
cabecOp(Tamanho)

nSKIPLIN :=6.2
cPV :=TMP->C5_NUM
While !TMP->(Eof())

	IncRegua()
	li++
	//���������������������������������������������������������Ŀ
	//� Se nao couber, salta para proxima folha                 �
	//�����������������������������������������������������������
	IF lEnd
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"	                                                                   
		Exit
	EndIF
	
	IF li > 55 .OR.  cPV<>TMP->C5_NUM 
		IF cPV<>TMP->C5_NUM
		   nPAG :=1
		ELSE
		   nPAG++
		ENDIF
	   cPV :=TMP->C5_NUM
		Li  := 1
		CabecOp(Tamanho)		// imprime cabecalho 
		nSKIPLIN :=6.2
		Li ++

	EndIF
	
	@Li,01 Psay TMP->C6_ITEM
	@Li,04 Psay TMP->C6_PRODUTO 
	@Li,30 Psay Transform(TMP->C6_QTDVEN,"@E 999,999.99")
	
	If (TMP->C6_QTDVEN-TMP->C6_QTDENT) < TMP->C6_XXQSEPA
	   @Li,50 Psay Transform(TMP->C6_QTDVEN-C6_QTDENT,"@E 999,999.99")
	Else
	   @Li,50 Psay Transform(C6_XXQSEPA              ,"@E 999,999.99")
	EndIf
	
	//--------------------------------------
	oPr := oprn
	cNUM := (TMP->C5_NUM+TMP->C6_ITEM)
	MSBAR2("CODE128",nSKIPLIN,16.5,Alltrim(cNUM),opr,.F.,,.T.,0.025,0.8,NIL,NIL,NIL,.F.)
	//--------------------------------------	
	nSKIPLIN :=nSKIPLIN+2.14 //1.27 //2.17
	Li++
	@Li,04 Psay TMP->C6_DESCRI
	Li++
	If Empty(TMP->C6_LOTECTL)
	   @ Li,04 Psay "Dt. Separa��o: " + DtoC(StoD(TMP->C6_XXDTSEP)) + "   Lote: (sem valida��o de lote)"
	Else
	   @ Li,04 Psay "Dt. Separa��o: " + DtoC(StoD(TMP->C6_XXDTSEP)) + "   Lote: " + TMP->C6_LOTECTL
	EndIf
	Li++	                                              
	@Li,00 Psay REPLICATE(CHR(151),170)
	Li++
	
	TMP->(DBSKIP())
EndDO

endprint
ofnt:end()
ofnt2:end()
ofnt3:end()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DOMSENF2 � OPUSVP� Mauricio Lima de Souza� Data � 19.09.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio SENF  Com codigo de barras                       ���
�������������������������������������������������������������������������Ĵ��
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

Static Function CabecOp(Tamanho)

//								           012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                        			       1         2         3         4         5         6         7         8
Local nBegin
Local nPed
Local cPed
Local _nTamOK  :=100
Local _nTamMax :=34

If li # 5
	li := 0
Endif  
	
if plinha
  plinha := .f.
else
//  cContPg :=Alltrim(SC2->C2_NUM+" "+SC2->C2_ITEM+SC2->C2_SEQUEN)
  endpage
  page
endif


//page
//Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li,01 Psay "ROSENBERGER DOMEX TELECOM    SEPARA��O DE MATERIAL PARA SENF   " + DTOC(DATE())+' '+ALLTRIM(TIME())  +' Pag.:'+ALLTRIM(STR(NPAG)) Font ofnt3

Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
                                                                                                 
@Li,01 Psay  "Pedido de Venda (PV) "+ TMP->C5_NUM  Font ofnt3
oPr := oprn
cNUM := (TMP->C5_NUM)
MSBAR2("CODE128",2.15,16.5,Alltrim(cNUM),opr,.F.,,.T.,0.025,0.5,NIL,NIL,NIL,.F.)
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
SA1->(DBSELECTAREA('SA1'))
SA1->(DBSETORDER(1))
SA1->(DBSEEK(xFilial('SA1')+TMP->C5_CLIENTE+TMP->C5_LOJACLI))
@Li,10 Psay "Cliente  "
@li,25 Psay TMP->C5_CLIENTE+'/'+TMP->C5_LOJACLI+ '  '+SA1->A1_NOME
Li++
@Li,10 Psay "Emiss�o Pedido  "
@Li,25 Psay SUBSTR(TMP->C5_EMISSAO,7,2)+'/'+SUBSTR(TMP->C5_EMISSAO,5,2)+'/'+SUBSTR(TMP->C5_EMISSAO,1,4)
Li++
@Li,10 Psay "Observa��o  "
@Li,25 Psay TMP->C5_ESP1
Li++
@Li,25 Psay TMP->C5_ESP2
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++
@Li, 01 PSay  "ITEM PRODUTO          DESCRI��O          QTDVEN             SALDO   " Font ofnt3
Li++
@Li,00 Psay REPLICATE(CHR(151),170)
Li++

Return
