#include "print.ch"         
#include "font.ch"
#include "colors.ch"
#include "Protheus.ch"
#include "Topconn.ch"
#include "Rwmake.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)

User Function DOMSLDEMP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := "Saldo empenho"
//Local   cPict       := ""
Local   titulo      := "Posição de Pagamento de OP"
Local   nLin        := 8
//Local   Cabec1      := "OP             PRODUTO                                             QTD.ORI   SALDO EMP  REQUISIÇÃO  TRANSF(97) SALDO FINAL  LOCAL  DT.PAGTO  USUARIO"
Local   Cabec1      := "OP             PRODUTO                                               QTD.ORI      SALDO EMP   REQUISIÇÃO    TRANSF(97)       DEV(97)   SALDO FINAL  LOCAL DT.PAGTO  USUARIO"
Local   Cabec2      := " "
Local   aOrd        := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "DOMSLDEMP"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       :="DOMSLDEMP"+Space(01)
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "DOMSLDEMP"
Private cString     := "SD4"
Private Cgruporet   :=''
Private cGrupo      :=''
Private nCont       :=1
Private NX          :=0
Private cOPsImps    := ''
Private lImpEtiq    := .F.
Private _COP        := ""

pergunte(cPerg,.F.)

_cOP1 :=MV_PAR01
_cOP2 :=MV_PAR02
_cLinha:= MV_PAR09


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

_cOP1 :=MV_PAR01
_cOP2 :=MV_PAR02
_cLinha := MV_PAR09

lSohPicklist := (MV_PAR08 == 1)

cQuery := " SELECT D4_OP,D4_COD,D4_QTDEORI,D4_QUANT, D4_LOCAL, D4_OPORIG,D4_XPKLIST,  "
cQuery += ENTER +  " (SELECT SUM(D3_QUANT) FROM SD3010 WITH (NOLOCK) WHERE D3_OP =D4_OP AND D3_COD=D4_COD AND         "
cQuery += ENTER + "                                   D3_LOCAL<>'97'  AND D3_TM>='500' AND  D3_TM<>'570' AND         "
cQuery += ENTER + "                                   D3_ESTORNO<>'S' AND D3_FILIAL = '"+xFilial("SD3")+"' AND SD3010.D_E_L_E_T_<>'*' )   AS D4_REQSD3,   "

cQuery += ENTER + " (SELECT SUM(D3_QUANT) FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND       "
cQuery += ENTER + "                                   D3_LOCAL='97'  and D3_CF='DE4' AND    "
cQuery += ENTER + "                                   D3_ESTORNO<>'S' AND D3_FILIAL = '"+xFilial("SD3")+"' AND SD3010.D_E_L_E_T_<>'*')   AS D4_TRANSF97,  "

cQuery += ENTER + "  (SELECT SUM(D3_QUANT) FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND      "  // ESTAVA INIBIDO
cQuery += ENTER + "                                   D3_LOCAL='97'  and D3_CF='RE4' AND                             "
cQuery += ENTER + "                                   D3_ESTORNO<>'S' AND D3_FILIAL = '"+xFilial("SD3")+"' AND SD3010.D_E_L_E_T_<>'*')   AS D4_DEVOL97,   "

cQuery += ENTER + " (SELECT MAX(D3_EMISSAO) FROM SD3010  WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND    "
cQuery += ENTER + "                                   D3_LOCAL='97'  and D3_CF='DE4' AND    "
cQuery += ENTER + "                                   D3_ESTORNO<>'S' AND D3_FILIAL = '"+xFilial("SD3")+"' AND SD3010.D_E_L_E_T_<>'*')   AS D3_MAXEMIS,    "     // Adicionado Virgula - MAS

cQuery += ENTER + " (SELECT TOP 1 D3_USUARIO FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND  "
cQuery += ENTER + "                                   D3_LOCAL='97'  and D3_CF='DE4' AND    "
cQuery += ENTER + "                                   D3_ESTORNO<>'S' AND D3_FILIAL = '"+xFilial("SD3")+"' AND SD3010.D_E_L_E_T_<>'*' ORDER BY D3_EMISSAO DESC) AS D3_USUARIO "

cQuery += ENTER + " FROM SD4010 (NOLOCK), SC2010 (NOLOCK) ,SB1010(NOLOCK) "
cQuery += ENTER + " WHERE SD4010.D_E_L_E_T_ = '' AND SC2010.D_E_L_E_T_ = '' AND SB1010.D_E_L_E_T_ = '' AND D4_OP>='"+MV_PAR01+"' AND D4_OP<='"+MV_PAR02+"' AND "
cQuery += ENTER + " D4_OP 	= C2_NUM+C2_ITEM+C2_SEQUEN AND C2_XXDTPRO >= '"+DtoS(mv_par04)+"' AND C2_XXDTPRO <= '"+DtoS(mv_par05)+"' "
cQuery += ENTER + " AND B1_COD = D4_COD 
cQuery += ENTER + " AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += ENTER + " AND D4_FILIAL = '"+xFilial("SD4")+"' "
cQuery += ENTER + " AND C2_FILIAL = '"+xFilial("SC2")+"' "


If lSohPicklist
	//cQuery += " AND D4_XPKLIST = 'N' "
	//cQuery += " AND C2_XETQIMP = 'S' "
	cQuery += ENTER + " AND D4_LOCAL NOT IN ('99','08') "
	cQuery += ENTER + " AND B1_GRUPO NOT IN ('FO','FOFS') "
	//cQuery += " AND ((D4_QTDEORI - D4_REQSD3) -  (D4_TRANSF97+D4_DEVOL97))	 > 0 "
EndIf
If mv_par03 == 2
	cQuery += ENTER + " AND D4_LOCAL <> '"+GetMV("MV_LOCPROC")+"' AND D4_LOCAL <> '"+GetMV("MV_XXLOCPE")+"' AND D4_LOCAL <> '08' AND C2_QUANT > C2_QUJE AND D4_FILIAL = '"+xFilial("SD4")+"' AND C2_FILIAL = '"+xFilial("SC2")+"' "
EndIf
//If (Upper(GetEnvServ()) == 'HOMOLOGACAO') .Or. (Upper(GetEnvServ()) == 'VALIDACAO')
	If !Empty(Alltrim(_cLinha)) .And.  !Alltrim(_cLinha) $ "ZZZ/zzz/ZZZZ/zzzz/z/Z/zz/ZZ"
		If Alltrim(_cLinha) $ "DIO/DIOE/TRUN/TRUE"
			cQuery += ENTER + " AND LEFT(D4_OP,8)  IN "
			cQuery += ENTER + " (SELECT C2_NUM + C2_ITEM FROM " + RetSqlName("SC2") + " SC2  "
			cQuery += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ =''AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO AND LEFT(SB1.B1_GRUPO,3) IN ( '" +  Left(Alltrim(_cLinha),3) + "') "
			If lSohPicklist
				cQuery += ENTER + " WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_FILIAL = '" +  xFilial("SC2")+ "' AND SC2.C2_XXDTPRO  BETWEEN  '"+DtoS(mv_par04)+"' AND '"+DtoS(mv_par05)+"' AND  C2_XETQIMP = 'S' AND C2_SEQUEN = '001'  ) "
			Else
				cQuery += ENTER + " WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_FILIAL = '" +  xFilial("SC2")+ "' AND SC2.C2_XXDTPRO  BETWEEN  '"+DtoS(mv_par04)+"' AND '"+DtoS(mv_par05)+"' AND C2_SEQUEN = '001'  ) "
			EndIf
			//cQuery += " AND  SC2010.C2_PRODUTO IN ( SELECT B1_COD FROM " + RetSqlName("SB1") + " SB1 WHERE D_E_L_E_T_ ='' AND LEFT(SB1.B1_GRUPO,3) IN ( '" +  Left(Alltrim(_cLinha),3) + "')) "
		Else
			cQuery += ENTER + " AND LEFT(D4_OP,8)  IN "
			cQuery += ENTER + " (SELECT C2_NUM + C2_ITEM FROM " + RetSqlName("SC2") + " SC2  
			cQuery += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ =''AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO AND SB1.B1_GRUPO = '" +  Alltrim(_cLinha) + "' " 
			If lSohPicklist
				cQuery += ENTER + " WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_FILIAL = '" +  xFilial("SC2")+ "' AND SC2.C2_XXDTPRO  BETWEEN  '"+DtoS(mv_par04)+"' AND '"+DtoS(mv_par05)+"' AND  C2_XETQIMP = 'S' AND C2_SEQUEN = '001'  ) "
			Else
				cQuery += ENTER + " WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_FILIAL = '" +  xFilial("SC2")+ "' AND SC2.C2_XXDTPRO  BETWEEN  '"+DtoS(mv_par04)+"' AND '"+DtoS(mv_par05)+"' AND C2_SEQUEN = '001'  ) "
			EndIf	
			//cQuery += " AND  SC2010.C2_PRODUTO IN ( SELECT B1_COD FROM " + RetSqlName("SB1") + " SB1 WHERE D_E_L_E_T_ ='' AND SB1.B1_GRUPO = '" +  Alltrim(_cLinha) + "' ) "
		EndIf
	Else
		cQuery += ENTER + " AND LEFT(D4_OP,8)  IN "
		cQuery += ENTER + " (SELECT C2_NUM + C2_ITEM FROM " + RetSqlName("SC2") + " SC2  
		cQuery += ENTER + " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ =''AND SB1.B1_FILIAL ='" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO  " 
		If lSohPicklist
			cQuery += ENTER + " WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_FILIAL = '" +  xFilial("SC2")+ "' AND SC2.C2_XXDTPRO  BETWEEN  '"+DtoS(mv_par04)+"' AND '"+DtoS(mv_par05)+"' AND  C2_XETQIMP = 'S' AND C2_SEQUEN = '001'  ) "
		Else
			cQuery += ENTER + " WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_FILIAL = '" +  xFilial("SC2")+ "' AND SC2.C2_XXDTPRO  BETWEEN  '"+DtoS(mv_par04)+"' AND '"+DtoS(mv_par05)+"' AND C2_SEQUEN = '001'  ) "
		EndIf			
	EndIf
//EndIf
cQuery += ENTER + " ORDER BY D4_OP,D4_COD, D4_OPORIG DESC "

TCQUERY cQuery NEW ALIAS "TR1"

TR1->( dbGoTop() )
SetRegua(SELECT("TR1"))

IncRegua()
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
DO While TR1->(!EOF())
	
	If lSohPicklist .And. ((TR1->D4_QTDEORI - TR1->D4_REQSD3)- ((TR1->D4_TRANSF97)+(TR1->D4_DEVOL97))) <= 0
		TR1->( dbSkip() )
		If !Empty(_COP)			
			IF ALLTRIM(_COP)<>ALLTRIM(TR1->D4_OP)
				@nLin,00 PSay __PrtThinLine()
				nLin++
				_COP := ""
			ENDIF
		EndIf		
	
		loop						
	EndiF
	/*
	If !Empty(_COP)			
		IF ALLTRIM(_COP)<>ALLTRIM(TR1->D4_OP)
			@nLin,00 PSay __PrtThinLine()
			nLin++
			_COP := ""
		ENDIF
	EndIf		*/

	// Verificando se o produto não tem OP filha
	lOPFilha := .F.
	cOPProdPI      := TR1->D4_OPORIG
	/*
	aAreaSC2Temp := SC2->( GetArea() )
	cRaizOP      :=  Subs(cOPProdPI,1,8) //Subs(TR1->D4_OP,1,8)
	SC2->( dbSetOrder(1) )
	SC2->( dbSeek( xFilial() + cRaizOP ) )
	While !SC2->( EOF() ) .and. SC2->C2_NUM + SC2->C2_ITEM == cRaizOP
		If SC2->C2_PRODUTO == TR1->D4_COD
			lOPFilha := .T.
			Exit
		EndIf
		SC2->( dbSkip() )
	End
	RestArea(aAreaSC2Temp)
	*/
	 //.or. Empty(cOPProdPI)
	_COP:=TR1->D4_OP
	
	@ nLin,00 pSay TR1->D4_OP
	@ nLin,15 pSay TR1->D4_COD
	_CPROD:=POSICIONE('SB1',1,XFILIAL('SB1')+TR1->D4_COD,'B1_DESC')
	@ nLin,32 pSay SUBSTR(_CPROD,1,30)
	@ nLin,PCOL()+2 pSay Transform(TR1->D4_QTDEORI     ,"@E 999,999.9999")  // QTD.ORI
	@ nLin,PCOL()+2 pSay Transform(TR1->D4_QUANT       ,"@E 999,999.9999")  // SLADO EMP
	@ nLin,PCOL()+2 pSay Transform(TR1->D4_REQSD3      ,"@E 999,999.9999")  // REQUISICAO

	_nCALC1:=(TR1->D4_QTDEORI - TR1->D4_REQSD3)
	_nCALC2:=(_NCALC1-TR1->D4_TRANSF97)+(TR1->D4_DEVOL97)
		
	If Empty(cOPProdPI)
		@ nLin,PCOL()+2 pSay Transform(TR1->D4_TRANSF97 ,"@E 999,999.9999")  // TRANSF (97)
		@ nLin,PCOL()+2 pSay Transform(TR1->D4_DEVOL97  ,"@E 999,999.9999")  // DEV (97)
		@ nLin,PCOL()+2 pSay Transform(_nCALC2          ,"@E 999,999.9999")  // SALDO FINAL
	Else
		@ nLin,PCOL()+2 pSay Transform(0.0000           ,"@E 999,999.9999")  // TRANSF (97)
		@ nLin,PCOL()+2 pSay Transform(0.0000           ,"@E 999,999.9999")  // DEV (97)
		@ nLin,PCOL()+2 pSay Transform(TR1->D4_QTDEORI  ,"@E 999,999.9999")  // SALDO FINAL
	EndIf
	
		
	@ nLin,PCOL()+2 pSay TR1->D4_LOCAL
	@ nLin,PCOL()+2 pSay DtoC(StoD(TR1->D3_MAXEMIS))
	
	If  mv_par06 == 1 .And. !Empty(Alltrim(cOPProdPI))
		@ nLin,PCOL()+2 pSay "PI  OP: "+cOPProdPI
	Else
		@ nLin,PCOL()+2 pSay SPACE(22)
	EndIf		
		
	cD3_USUARIO := ''
	
	//If Empty(cOPProdPI)
	cQuery := "SELECT D3_USUARIO FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP = '"+TR1->D4_OP+"' AND D3_COD = '"+TR1->D4_COD+"' AND  "
	cQuery += "                                   D3_LOCAL='97'  AND D3_CF='DE4' AND D3_FILIAL = '"+xFilial("SD3")+"' AND  "
	cQuery += "                                   D3_ESTORNO<>'S' AND SD3010.D_E_L_E_T_='' GROUP BY D3_USUARIO "
													
	If Select("D3USUARIO") <> 0
		D3USUARIO->( dbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "D3USUARIO"
	
	While !D3USUARIO->( EOF() )
		cD3_USUARIO += Alltrim(D3USUARIO->D3_USUARIO)+'/'
		D3USUARIO->( dbSkip() )
	End
	//EndIf

	@ nLin,PCOL()+2 pSay Subs(cD3_USUARIO,1,Len(cD3_USUARIO)-1)
	If lSohPicklist
		@ nLin,PCOL()+2 pSay IIF(TR1->D4_XPKLIST =="N","Sem Sld.Est.PickList","Com Sld.Est.PickList")
	Endif
	If !Empty(_nCALC2) .and. Empty(cOPProdPI)
		If !lImpEtiq
			If mv_par07 == 1
				If MsgYesNo('Deseja imprimir etiqueta de produto não pago?')
					lImpEtiq := .T.
					ImpEtiq()
				EndIf
			EndIf
		Else
			ImpEtiq()
		EndIf
	EndIf
	nLin++		
	//EndIf	
	
	TR1->( dbSkip() )
	If !Empty(_COP)
		IF ALLTRIM(_COP)<>ALLTRIM(TR1->D4_OP)
			@nLin,00 PSay __PrtThinLine()
			nLin++
		ENDIF
	EndIf		
	IF NLIN >=55
		Roda(0,"","M")
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	ENDIF	
	IncRegua()
EndDo
TR1->(DBCLOSEAREA())
Roda(0,"","M")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

RETURN

Static Function ImpEtiq()
Local _cPorta    := "LPT1"

If !(Alltrim(TR1->D4_OP) $ cOPsImps)
	cOPsImps += Alltrim(TR1->D4_OP)
	
	MSCBPrinter("TLP 2844",_cPorta,,,.F.)
	MSCBBegin(1,6)
	
	MSCBSay(26,06,"Impressão temporaria de OP","N","2","1,1")
	
	//MSCBSAYBAR(10,150,AllTrim(cOPBarra),"N","MB07"   ,09,.F.,.F.,   ,,2,2) //Codigo produto em Barras
	MSCBSayBar(30,09,Alltrim(TR1->D4_OP)  ,"N","MB07",7 ,.F.,.T.,.F.,,2,Nil,Nil,Nil,Nil,Nil)
	MSCBEnd()
	MSCBClosePrinter()
EndIf

SB1->( dbSetOrder(1) )
SB1->( dbSeek( xFilial() + TR1->D4_COD ) )

_cProxPeca := U_IXD1PECA()
Reclock("XD1",.T.)
Replace XD1->XD1_FILIAL  With xFilial("XD1")
// Substituido por Michel Sander em 28.08.2014 para gravar o documento a partir do programa IXD1PECA()
Replace XD1->XD1_XXPECA  With _cProxPeca
Replace XD1->XD1_FORNEC  With Space(06)
Replace XD1->XD1_LOJA    With Space(02)
Replace XD1->XD1_DOC     With Space(06)
Replace XD1->XD1_SERIE   With Space(03)
//Replace XD1->XD1_ITEM    With StrZero(Recno(),4)
Replace XD1->XD1_COD     With TR1->D4_COD
Replace XD1->XD1_LOCAL   With TR1->D4_LOCAL
Replace XD1->XD1_TIPO    With SB1->B1_TIPO
Replace XD1->XD1_LOTECT  With "LOTE1308"
Replace XD1->XD1_DTDIGI  With dDataBase
Replace XD1->XD1_FORMUL  With ""
Replace XD1->XD1_LOCALI  With ""
Replace XD1->XD1_USERID  With __cUserId
XD1->XD1_OCORRE := "4"
Replace XD1->XD1_QTDORI  With _nCALC2
Replace XD1->XD1_QTDATU  With _nCALC2
XD1->( MsUnlock() )

U_DOMEST06()

Return
