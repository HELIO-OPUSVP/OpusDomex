#include "protheus.ch"
#include "rwmake.ch" 
                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ01 ºAutor  ³ Felipe A. Melo     º Data ³  08/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DOMETQ01()

Local lLoop := .T.

While lLoop
	lLoop := fTelaPrint()
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ01 ºAutor  ³ Felipe A. Melo     º Data ³  08/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTelaPrint()

Local cModelo   := "Z4M"
Local cPorta    := "LPT1"

Local lPrinOK   := MSCBModelo("ZPL",cModelo)

Local aPar := {}
Local aRet := {}
Local nVar := 0

Local cRotacao := "R" //(N,R,I,B)

Local mv_par01:= Space(11) //Numero OP
Local mv_par02:= 0         //Qtd Embalagem
Local mv_par03:= 0         //Qtd Etiquetas

Local aRetAnat:= {}        //Codigos Anatel, Array
Local aCodAnat:= {}        //Codigos Anatel, Array
Local cCdAnat1:= ""        //Codigo Anatel 1
Local cCdAnat2:= ""        //Codigo Anatel 2

//cSeqEtiq := NEXTSEQ()
//cSeqEtiq := AllTrim(GetMV("MV_XXSEQET"))
//PutMv("MV_XXSEQET",Soma1(cSeqEtiq))
Private lHuawei := .f.
Private lAchou   := .T.
Private aGrpAnat := {}        //Codigos Anatel Agrupados

aAdd(aPar,{1,"Numero O.P."       ,Space(11) ,"@!"      ,/*"NaoVazio()"*/,      ,,60,.F.})
aAdd(aPar,{1,"Qtde por Embalagem",         0,"@E 999"  ,/*"NaoVazio()"*/,      ,,60,.F.})
aAdd(aPar,{1,"Qtde de Etiquetas" ,         0,"@E 9999" ,/*"NaoVazio()"*/,      ,,60,.F.})

If ParamBox(aPar,"Dados Destino",@aRet)
	mv_par01 := aRet[1]
	mv_par02 := aRet[2]
	mv_par03 := aRet[3]
Else
	mv_par01 := Space(11)
	mv_par02 := 0
	mv_par03 := 0
	Return(.F.)
EndIf

//Teste Impressão
//RPCSetType(3)
//aAbreTab := {}
//RpcSetEnv("01","01",,,,,aAbreTab)

//Localiza SC2
SC2->(DbSetOrder(1))
If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+mv_par01))
	Alert("Numero O.P. "+AllTrim(mv_par01)+" não localizada!")
	lAchou := .F.
EndIf

//Localiza SC5
SC5->(DbSetOrder(1))
If lAchou .And. SC5->(!DbSeek(xFilial("SC5")+SC2->C2_PEDIDO))
	Alert("Numero P.V. "+AllTrim(SC2->C2_PEDIDO)+" não localizado!")
	lAchou := .F.
EndIf

//Localiza SC6
SC6->(DbSetOrder(1))
If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
	Alert("Item P.V. "+AllTrim(SC2->C2_ITEMPV)+" não localizado!")
	lAchou := .F.
EndIf

//Localiza SA1
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" não localizado!")
	lAchou := .F.
EndIf

//If lAchou .And. ("HUAWEI" $ Upper(SA1->A1_NOME))
//	EtLay001()
//Else
//EndIf

//Return lAchou

//*************************************************************************************
//Static Function EtLay001()   // Layout de impressão de etiqueta 001 - Huawai

//Valida se Cliente é HUAWEI

If  ("HUAWEI" $ Upper(SA1->A1_NOME)) .OR.  ("FOXCONN" $ Upper(SA1->A1_NOME))  
	lHuawei := .t.
EndIf    

//Valida se Cliente é HUAWEI
If lAchou .and. !lHuawei
	Alert("Não é cliente HUAWEI!")
	lAchou := .F.
EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf

//
If lAchou
	aRetAnat := fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	
	If lAchou .And. Empty(SB1->B1_XXNANAT)
		Alert("Não foi preenchido o campo 'Nº Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
		lAchou := .F.
	EndIf
	
EndIf

If lAchou
	//Agrupando Codigos Anatel
	For x:=1 To Len(aCodAnat)
		nVar := aScan(aGrpAnat,aCodAnat[x])
		If nVar == 0
			aAdd(aGrpAnat,aCodAnat[x])
		EndIf
	Next x
	     
	//--> Alterado por Michel A. Sander em 25.06.2014 para verificar se o tipo PR de produto está sendo impresso
   If ALLTRIM(SB1->B1_TIPO) == 'PR'
		Do Case
			Case Val(SB1->B1_XXNANAT) == 0
				cCdAnat1 := ""
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 1 
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 2
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := SB1->B1_XXANAT1
				
			Case Val(SB1->B1_XXNANAT) == 3
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := SB1->B1_XXANAT2
				
			Case Val(SB1->B1_XXNANAT) == 4
				cCdAnat1 := SB1->B1_XXANAT1
				cCdAnat2 := SB1->B1_XXANAT2
				cCdAnat3 := SB1->B1_XXANAT3
				
			OtherWise	
				cCdAnat1 := " E R R O "
				cCdAnat2 := " E R R O "
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ01)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+mv_par01)
				lAchou   := .F.
				
		EndCase
	Else
		Do Case
			Case Val(SB1->B1_XXNANAT) == 0 .And. Len(aGrpAnat) == 0
				cCdAnat1 := ""
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
				cCdAnat1 := aGrpAnat[1]
				cCdAnat2 := ""
				
			Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
				cCdAnat1 := aGrpAnat[1]
				cCdAnat2 := aGrpAnat[1]
				
			Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
				cCdAnat1 := aGrpAnat[1]
				cCdAnat2 := aGrpAnat[2]

			Case Val(SB1->B1_XXNANAT) == 4 .And. Len(aGrpAnat) == 3
				cCdAnat1 := aGrpAnat[1]
				cCdAnat2 := aGrpAnat[2]
				cCdAnat3 := aGrpAnat[3]
				
			OtherWise
				cCdAnat1 := " E R R O "
				cCdAnat2 := " E R R O "
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ01)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+mv_par01)
				lAchou   := .F.
				
		EndCase
	EndIf	
EndIf

//Valida se Parametro que controla o Sequencial está preenchido
/*
If lAchou .And. Empty(cSeqEtiq)
aPar := {}
aAdd(aPar,{1,"Codigo Sequencial"     ,Space(06) ,"@!"    ,"NaoVazio()",      ,,60,.T.})
aRet := {}
aAdd(aRet,Space(06))
If ParamBox(aPar,"Cadastro Produto",@aRet)
PutMv("MV_XXSEQET",aRet[1])
cSeqEtiq := AllTrim(aRet[1])
Else
lAchou := .F.
EndIf
EndIf
*/

//Valida se Campo Descricao do Produto está preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Valida se Campo PN HUAWEI está preenchido
If lAchou .And. Empty(SC6->C6_SEUCOD)
	Alert("Campo PN HUAWEI não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
	lAchou := .F.
EndIf

//Valida se Campo PN HUAWEI está preenchido
If lAchou .And. Empty(SC6->C6_SEUDES)
	Alert("Campo ITEM PEDIDO CLIENTE não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUDES]")
	lAchou := .F.
EndIf

//Valida se Campo PEDIDO CLIENTE está preenchido
If lAchou .And. Empty(SC5->C5_ESP1)
	Alert("Campo PEDIDO CLIENTE não está preenchido no Cabeçalho do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C5_ESP1]")
	lAchou := .F.
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

//Se impressora não identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configuração!")
	Return(.T.)
EndIf

//Chamando função da impressora ZEBRA
MSCBPRINTER(cModelo,cPorta,,,.F.)
MSCBChkStatus(.F.)
MSCBLOADGRF("RDT.GRF")
MSCBLOADGRF("ANATEL.GRF")

For x:=1 To mv_par03
	//Pegando sequencia da etiqueta
	cSeqEtiq := NEXTSEQ()
	
	//Inicia impressão da etiqueta
	MSCBBEGIN(1,5)
	
	nCol := 03
	nIni := 07
	nLin := 04
	
	MSCBGRAFIC(90,020,"RDT",.T.)
	MSCBGRAFIC(90,135,"ANATEL",.T.)
	
	//Contorno/Borda
	//Grupo 01
	MSCBBOX(07,05,102,170,3,"B")
	
	//-------------------------------------XXXXXXXXXX XXXXXXXXXX XXXX.XXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX--------------------
	/*01*/ //MSCBSAY(nCol+(nLin*23),nIni   ,""                                                              ,cRotacao,"0","25,40")
	/*02*/   MSCBSAY(nCol+(nLin*22),nIni+65,StrZero(mv_par02,3)+" Unidade(s)"                               ,cRotacao,"0","35,50")
	/*03*/ //MSCBSAY(nCol+(nLin*21),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	/*04*/   MSCBSAY(nCol+(nLin*20),nIni   ,fTrataText(SB1->B1_DESC)                                        ,cRotacao,"0","25,40")
	/*05a*/  MSCBSAY(nCol+(nLin*19),nIni   ,"PN RDT: "+fTrataText(SB1->B1_COD)                              ,cRotacao,"0","25,40")
	/*05b*/  MSCBSAY(nCol+(nLin*19),nIni+80,"PN HUAWEI: "+fTrataText(SC6->C6_SEUCOD)                        ,cRotacao,"0","25,40")
	/*06a*/  MSCBSAY(nCol+(nLin*18),nIni   ,"PEDIDO CLIENTE: "+fTrataText(SC5->C5_ESP1)                     ,cRotacao,"0","25,40")
	/*06b*/  MSCBSAY(nCol+(nLin*18),nIni+80,"ITEM PEDIDO CLIENTE: "+fTrataText(SC6->C6_SEUDES)              ,cRotacao,"0","25,40")
	/*07*/ //MSCBSAY(nCol+(nLin*17),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	/*08*/ //MSCBSAY(nCol+(nLin*16),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	
	
	/*TESTE*///MSCBSAY(nCol+(nLin*14),nIni+78," [ HOMOLOGACÇO ]"                                                ,cRotacao,"0","65,80")
	
	
	If !Empty(cCdAnat1)
		/*09*/MSCBSAYBAR(nCol+(nLin*15)+3,nIni+4 ,fTrataText(cCdAnat1)                                            ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
		/*09*/   MSCBSAY(nCol+(nLin*14)+3,nIni+13,fTrataText(cCdAnat1)                                            ,cRotacao,"0","25,40")
	EndIf
	/*10*/ //MSCBSAY(nCol+(nLin*14),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	/*11*/ //MSCBSAY(nCol+(nLin*13),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	If !Empty(cCdAnat2)
		/*12*/MSCBSAYBAR(nCol+(nLin*12)+2,nIni+4 ,fTrataText(cCdAnat2)                                          ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
		/*12*/   MSCBSAY(nCol+(nLin*11)+2,nIni+13,fTrataText(cCdAnat2)                                          ,cRotacao,"0","25,40")
	EndIf
	
	//Grupo 02
	MSCBLineV(48,05,170,3,"B")
	//------------------------------------------------------------------------------------------------------------------------
	/*13*/ //MSCBSAY(nCol+(nLin*11),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	/*14*/ //MSCBSAY(nCol+(nLin*10),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	If !Empty(SC6->C6_SEUCOD)
		/*15*/MSCBSAYBAR(nCol+(nLin*09),nIni+04,"Part No: "+fTrataText(SC6->C6_SEUCOD)                          ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
		/*15*/   MSCBSAY(nCol+(nLin*08),nIni+13,"Part No: "+fTrataText(SC6->C6_SEUCOD)                          ,cRotacao,"0","25,40")
	EndIf

	/*15*/  MSCBSAYBAR(nCol+(nLin*09) ,nIni+094+10 ,"Quantity: "+StrZero(mv_par02,3)                                ,cRotacao,"MB07",8.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
	/*15*/   MSCBSAY(nCol+(nLin*08)   ,nIni+110+10,"Quantity: "+StrZero(mv_par02,3)                                ,cRotacao,"0","25,40")
	//94 110        //MLS
	//Grupo 03
	MSCBLineV(34,05,170,3,"B")
	//------------------------------------------------------------------------------------------------------------------------
	/*16*/ //MSCBSAY(nCol+(nLin*08),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	/*17*/   MSCBSAY(nCol+(nLin*07)-2,nIni ,"Model./Desc: "+fTrataText(SB1->B1_DESC)                        ,cRotacao,"0","25,40")
	/*18*/ //MSCBSAY(nCol+(nLin*06),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	
	//Grupo 04
	MSCBLineV(28,05,170,3,"B")
	//------------------------------------------------------------------------------------------------------------------------
	/*19*/ //MSCBSAY(nCol+(nLin*05),nIni   ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	
	cVar := "39"+AllTrim(SC6->C6_SEUCOD)+"AZ0163"+SubStr(StrZero(Year(Date()),4),3,2)+fSemanaAno()+StrZero(mv_par02,4)+cSeqEtiq //MV_XXSEQET = sequencial
	/*20*/MSCBSAYBAR(nCol+(nLin*04)-1,nIni+04,cVar                                                            ,cRotacao,"MB07",9.361,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
	/*21*/   MSCBSAY(nCol+(nLin*03)-1,nIni+13,cVar                                                            ,cRotacao,"0","25,40")
	/*22*/ //MSCBSAY(nCol+(nLin*02),nIni    ,"XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXXXX",cRotacao,"0","25,40")
	
	//Grupo 05
	MSCBLineV(13,05,170,3,"B")
	//------------------------------------------------------------------------------------------------------------------------
	/*23*/   MSCBSAY(nCol+(nLin*01)+1,nIni    ,"Remark:"                                                 ,cRotacao,"0","25,40")
	cVar := fSemanaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)
	/*23*/   MSCBSAY(nCol+(nLin*01)+1,nIni+75 ,"INDUSTRIA BRASILEIRA.  Semana: "+cVar                    ,cRotacao,"0","25,40")
	
	MSCBInfoEti("DOMEX","120X77")
	
	//Finaliza impressão da etiqueta
	MSCBEND()
   Sleep(500)	
	//Incrementa Contador
	//cSeqEtiq := Soma1(cSeqEtiq)
	//PutMv("MV_XXSEQET",cSeqEtiq)
Next x

MSCBCLOSEPRINTER()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSemanaAnoºAutor  ³ Felipe Melo        º Data ³  11/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSemanaAno()

Local dDataIni := StoD(StrZero(Year(Date()),4)+"0101")
Local dDataAtu := Date()
Local nRet     := 0
Local cRet     := ""
Local nDiff    := Dow(dDataIni)

nDias := (dDataAtu - dDataIni) + nDiff

nRet  := nDias
nRet  := nRet / 7
nRet  := Int(nRet)

//Se iniciou a semana, soma 1
If nDias % 7 > 0
	nRet := nRet + 1
EndIf

cRet := StrZero(nRet,2)

//Função padrão que retorna a semana e o ano
//RetSem(dDataAtu)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTrataTextºAutor  ³ Felipe Melo        º Data ³  11/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTrataText(cTexto)

Default := cTexto

_cDesc:=StrTran(cTexto,"–"," ")
_cDesc:=StrTran(_cDesc,"_"," ")
_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"(",""),")",""),",","."),"Ø","0"),"/","-")
_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"Á","A"),"É","E"),"Í","I"),"Ó","O"),"Ú","U")
_cDesc:=StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(_cDesc,"Ç","C"),"Ã","A"),"Í","I"),"Ó","O"),"Ú","U"),":","")
_cDesc:=AllTrim(_cDesc)

Return(_cDesc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCodNat  ºAutor  ³ Felipe Melo        º Data ³  16/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCodNat(cCodProd)

Local aRet     := {}
Local x        := 0
Local lOk      := .T.
Local cErro    := ""

Local aAreaSB1 := SB1->(GetArea())
Local aAreaSG1 := SG1->(GetArea())

SB1->(DbSetOrder(1))
SG1->(DbSetOrder(1))

//SB1->(DbSeek(xFilial("SB1")+cCodProd)) //MLS
//cNEtiquetas := Alltrim(SB1->B1_XXNANAT)
If SG1->(DbSeek(xFilial("SG1")+cCodProd))
	cNEtiquetas := Alltrim(SB1->B1_XXNANAT)
	
	While SG1->(!Eof()) .And. AllTrim(cCodProd) == AllTrim(SG1->G1_COD)
		If SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP)) .And. !Empty(SB1->B1_XXANAT1)
			//For x:=1 To SG1->G1_QUANT
			aAdd(aRet,SB1->B1_XXANAT1)
			//Next x
			//If (SG1->G1_QUANT%1) > 0
			//	lOk := .F.
			//	cErro += IIf(Empty(cErro),""," / ") + AllTrim(SG1->G1_COMP)
			//EndIf
		EndIf
		SG1->(DbSkip())
	End
EndIf

If Empty(cNEtiquetas)
	MsgStop('Não foi preenchido o número de códigos de Barra Anatel no produto ' + cCodProd)
Else
	If cNEtiquetas == '0'
		If Len(aRet) <> 0
			MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 0 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
			lOk := .F.
		EndIf
	Else
		If cNEtiquetas == '1' .or. cNEtiquetas == '2'
			If Len(aRet) <> 1
				MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 1 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
				lOk := .F.
			EndIf
		Else
			If cNEtiquetas == '3'
				If Len(aRet) <> 2
					MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 2 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
					lOk := .F.
				EndIf
			Else
				If cNEtiquetas == '3'
					If Len(aRet) <> 3
						MsgStop('No produto ' + Alltrim(cCodProd) + ' foi selecionado a opção de 3 códigos de Barra Anatel, e foi encontrado ' + Alltrim(Str(Len(aRet)))+' código Anatel na Etrutura do Produto.')
						lOk := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

//If !lOk
//	Alert("A quantidade da(s) MP(s) "+cErro+" está(ão) com casas decimais na quantidade da estrutura e isso não é permitido!")
//EndIf

RestArea(aAreaSB1)
RestArea(aAreaSG1)

Return({lOk,aRet})

Static Function NEXTSEQ()
Local _Retorno := 0
Local nLoop    := 0
Local lLoop    := .T.
Local aAreaGER := GetArea()
Local aAreaSX6 := SX6->( GetArea() )

SX6->( Dbsetorder(1) )

//cSeqEtiq := AllTrim(GetMV("MV_XXSEQET"))
//PutMv("MV_XXSEQET",Soma1(cSeqEtiq))

If SX6->( dbSeek("  " + "MV_XXSEQET") )
	While lLoop .and. nLoop < 1000
		If RecLock("SX6",.F.) .And. lLoop
			_NextDoc        := Alltrim(SX6->X6_CONTEUD)
			SX6->X6_CONTEUD := SOMA1(_NextDoc)
			SX6->( Msunlock() )
			
			lLoop    := .F.
			_Retorno := _NextDoc
		EndIf
		nLoop ++
	End
EndIf

If Empty(_Retorno)
	aPar := {}
	aAdd(aPar,{1,"Codigo Sequencial"     ,Space(06) ,"@!"    ,"NaoVazio()",      ,,60,.T.})
	aRet := {}
	aAdd(aRet,Space(06))
	If ParamBox(aPar,"Cadastro Produto",@aRet)
		PutMv("MV_XXSEQET",aRet[1])
		_Retorno := AllTrim(aRet[1])
	Else
		lAchou := .F.
	EndIf
EndIf

If Empty(_Retorno)
	MsgYesNo('Erro no campo sequencial!')
EndIf

RestArea(aAreaSX6)
RestArea(aAreaGER)

Return _Retorno
