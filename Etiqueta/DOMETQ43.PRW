#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ43 ºAutor  ³ Ricardo Roda       º Data ³  16.11.2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 43   - Etiqueta avulsa Zebra   		      º±±
±±º          ³             IGUAL LAYOUT 107                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ43(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

	Local cModelo    := ""
	Local cPorta     := "LPT1"
	Local lPrinOK    := MSCBModelo("ZPL",cModelo)
	Local aPar       := {}
	Local aRet       := {}
	Local nVar       := 0
	Local cRotacao   := "N"      //(N,R,I,B)
	Local mv_par02   := 1         //Qtd Embalagem
	Local mv_par03   := 1         //Qtd Etiquetas
	Local aTemp      :={}

	Local aRetAnat   := {}        //Codigos Anatel, Array
	Local aCodAnat   := {}        //Codigos Anatel, Array
	Local x
	Local nP
	Local ny
	Local cMVPAR01a:= ""
	Local cMVPAR01b:= ""
	Local cMVPAR01c:= ""

	Private cCdAnat1   := ""        //Codigo Anatel 1
	Private cCdAnat2   := ""        //Codigo Anatel 2
	Private lAchou     := .T.
	Private aGrpAnat   := {}     //Codigos Anatel Agrupados
	Private _cSerieIni := ""
	Private aCodEtq    := {}
	Private _aArq      :={}
	private aRetPar   := {}
	Private aPar:= {}
	Private cFila:= ""

	Default cNumOP   := ""
	Default cNumSenf := ""
	Default nQtdEmb  := 0
	Default nQtdEtq  := 0
	Default cNumSerie := ""
	Default cNumPeca  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca quantidades para impressão								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	mv_par02:= nQtdEmb   //Qtd Embalagem
	mv_par03:= nQtdEtq   //Qtd Etiquetas

	If !Empty(cNumOP)

		//Localiza SC2
		SC2->(DbSetOrder(1))
		If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
			Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
			lAchou := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o número de série														 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		cSerieFim := If( cNumSerie == 1, 1, cNumSerie )

		Do Case
		Case SC2->C2_QUANT <=9
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
			cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
		EndCase

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no PA																 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	SB1->(DbSetOrder(1))
	If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
		lAchou := .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no Cliente					    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
/*SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"não localizado!")
	lAchou := .F.
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida descrição do produto		    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	If lAchou .And. Empty(SB1->B1_DESC)
		Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
		lAchou := .F.
	EndIf

//Caso algum registro não seja localizado, sair da rotina
	If !lAchou
		Return(.T.)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Montagem do código de barras 2D						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
	cSemana := WEEK->SEMANA
	WEEK->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consiste a quantidade de conectores na estrutura					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	nEtq := 0
	cSQL := "SELECT DISTINCT B1_GRUPO, B1_DESC, G1_COD " //, G1_COMP, G1_XXQTET1, G1_XXQTET2, G1_QUANT
	cSQL += " FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
	cSQL += "G1_FILIAL = B1_FILIAL AND G1_COD = B1_COD WHERE "
	cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
	cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
	cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
//cSQL += "(G1_XXQTET1 > 0 OR G1_XXQTET2 > 0) AND "
	cSQL += "B1_GRUPO = 'CORD'"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"ETQ",.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Parâmetros de impressão do Crystal Reports		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	cOptions := "2;0;1;Trunk"			// Parametro 1 (2= Impressora 1=Visualiza)
	nQ 		:= 1
	nSomaSer := cNumSerie
	nDobra   := If(SUBSTR(SB1->B1_GRUPO,1,4)=="CORD", 2, 1)
	cIL1     := AllTrim(TransForm(SB1->B1_XXIL1,"9.99"))
	cIL2     := AllTrim(TransForm(SB1->B1_XXIL2,"9.99"))
	nAviso   := Aviso("Atenção","Tipo de impressão",{"Total","Parcial"})
	nChoice  := If(nAviso==1,SC2->C2_QUANT,mv_par03)

	// cFila := cPorta
	// IF !CB5SetImp(cFila,.F.)
	// 	U_MsgColetor("Local de impressao invalido!")
	// 	Return .F.
	// EndIf

	if empty(Alltrim(cFila))
		aAdd(aPar,{1,"Escolha a Impressora " ,SPACE(6) ,"@!"       ,'.T.' , 'CB5', '.T.', 20 , .T. } )
		If !ParamBox(aPar,"INFORMAR IMPRESSORA",@aRetPar)
			Return
		EndIf

		cFila := ALLTRIM(aRetPar[1])
	Endif

	If !CB5SetImp(cFila,.F.)
		MsgAlert("Local de impressao invalido!","Aviso")
		Return .F.
	EndIf

	For x := 1 to nChoice

		ETQ->(dbGoTop())


		aTemp := U_QuebraString(SB1->B1_DESC,28)

		cMVPAR01a := aTemp[1]

		if len(aTemp) > 1
			cMVPAR01b := aTemp[2]
		Endif

		If len(aTemp) > 2
			cMVPAR01c := aTemp[3]
		Endif

		cMVPAR02 := " "
		cMVPAR03 := "PN:"+SB1->B1_COD
		cMVPAR04 := "SN:"+nSomaSer
		cMVPAR05 := "DC:"+substring(dtos(dDatabase),1,4)+"/"+substring(dtos(dDatabase),5,2)
		cMVPAR06 := " "

		cParam   := cMVPAR01a+cMVPAR01b+cMVPAR01c+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"

		// AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
		// AADD(_aArq,'^XA'+ CRLF)
		// AADD(_aArq,'~TA000'+ CRLF)
		// AADD(_aArq,'~JSN'+ CRLF)
		// AADD(_aArq,'^LT0'+ CRLF)
		// AADD(_aArq,'^MNW'+ CRLF)
		// AADD(_aArq,'^MTT'+ CRLF)
		// AADD(_aArq,'^PON'+ CRLF)
		// AADD(_aArq,'^PMN'+ CRLF)
		// AADD(_aArq,'^LH0,0'+ CRLF)
		// AADD(_aArq,'^JMA'+ CRLF)
		// AADD(_aArq,'^PR6,6'+ CRLF)
		// AADD(_aArq,'^JUS'+ CRLF)
		// AADD(_aArq,'^LRN'+ CRLF)
		// AADD(_aArq,'^CI27'+ CRLF)
		// AADD(_aArq,'^PA0,1,1,0'+ CRLF)
		// AADD(_aArq,'^XZ'+ CRLF)
		// AADD(_aArq,'^XA'+ CRLF)
		// AADD(_aArq,'^MMT'+ CRLF)
		// AADD(_aArq,'^PW591'+ CRLF)
		// AADD(_aArq,'^LL295'+ CRLF)
		// AADD(_aArq,'^LS0'+ CRLF)
		// AADD(_aArq,'^FT201,287^A0B,23,23^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
		// AADD(_aArq,'^FT235,287^A0B,23,23^FH\^CI28^FD'+cMVPAR01b+'^FS^CI27'+ CRLF)
		// AADD(_aArq,'^FT268,287^A0B,23,23^FH\^CI28^FD'+cMVPAR01c+'^FS^CI27'+ CRLF)
		// AADD(_aArq,'^FT469,287^A0B,26,28^FH\^CI28^FD'+cMVPAR03+'^FS^CI27'+ CRLF)
		// AADD(_aArq,'^FT505,287^A0B,26,28^FH\^CI28^FD'+cMVPAR04+'^FS^CI27'+ CRLF)
		// AADD(_aArq,'^FT542,287^A0B,27,28^FH\^CI28^FD'+cMVPAR05+'^FS^CI27'+ CRLF)
		// AADD(_aArq,'^FO76,37^GFA,805,2880,12,:Z64:eJyl1UFu4yAUBmCQpbKb1wNU5hqpZNlXmWNkEclIs8i1PJpFZjW5gqsuuhy6w2omDCjA+92xp42CFOWTY+ABjxch/t++MuXIVmACd+C+2EhfPFR+yLbky9un7lzsvQWPYMOjc1ehT2DuKnp47j3aLPrcs0+aPSr2ULGFubgNH/opivUvdne8uI7xJOs47/HSl8LXn2QV1v16uFjPLVeei+nInq+Lwyx75UI8aZuryZR9o2kQymaPpZ+ebIjJFHfJ3aMrczUb9HbFLk79j/WjZfu5t8kUzj/PSyF1+uQqfGdLv3ym2jvwGcb3ZsUDepdjUPsxx1DLH2Me80E+FTcrbqvn4m7/MuYYtX8Z8p5Hl7PwB5PPiPze5LNT/o7P9DRfr0u5GvPNUrG0Cpyex9xz4HN3MQ2cM3H/e3COJzrHGU2OzesK73NoEn6qfHpfToZ8GlNNQ3HIPZ1joMnqtxxD8JDuZrTJ6904LZKbaMre1st2xS1Yv1nNecIOubdo5YfikHvF4h6MDeqQgt+JS2HoOIJ507q8adGS3YIbsewHwePUkk1cyglq7bW+utG7PFly9wm3MCa6XjGhR/ZaDNd61iZmyG2eF+rq+xq75JCfxc3M2w+NfWONXYqZIN/QCnKywlzmv+d5q5h3xH2/aB6z7uyiW3CzgzXueC2b7bIbx+4c3BHcz9dl0xPHpr5zzLN2z5TwX7p2f2nl/urfkMMSc/jj+4vvYF8cc/1MOTaMGdey0uSJypjVmc9I+R78iVpx4LpH3+yKxxtsyyHdUsduqWl/AaRH9RE=:49F5'+ CRLF)
		// AADD(_aArq,'^PQ1,0,1,Y'+ CRLF)
		// AADD(_aArq,'^XZ'+ CRLF)
		//

		AADD(_aArq,'^XA'+ CRLF)
		AADD(_aArq,'~TA000'+ CRLF)
		AADD(_aArq,'~JSN'+ CRLF)
		AADD(_aArq,'^LT0'+ CRLF)
		AADD(_aArq,'^MNW'+ CRLF)
		AADD(_aArq,'^MTT'+ CRLF)
		AADD(_aArq,'^PON'+ CRLF)
		AADD(_aArq,'^PMN'+ CRLF)
		AADD(_aArq,'^LH0,0'+ CRLF)
		AADD(_aArq,'^JMA'+ CRLF)
		AADD(_aArq,'^PR6,6'+ CRLF)
		//AADD(_aArq,'~SD15'+ CRLF)
		AADD(_aArq,'^JUS'+ CRLF)
		AADD(_aArq,'^LRN'+ CRLF)
		AADD(_aArq,'^CI27'+ CRLF)
		AADD(_aArq,'^PA0,1,1,0'+ CRLF)
		AADD(_aArq,'^XZ'+ CRLF)
		
		AADD(_aArq,'^XA'+ CRLF)
		AADD(_aArq,'^MMT'+ CRLF)
		AADD(_aArq,'^PW400'+ CRLF)
		AADD(_aArq,'^LL200'+ CRLF)
		AADD(_aArq,'^LS0'+ CRLF)
		AADD(_aArq,'^FT137,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01a+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT159,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01b+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT182,194^A0B,16,15^FH\^CI28^FD'+cMVPAR01c+'FS^CI27'+ CRLF)
		AADD(_aArq,'^FT317,194^A0B,17,18^FH\^CI28^FD'+cMVPAR03+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT341,194^A0B,17,18^FH\^CI28^FD'+cMVPAR04+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FT366,194^A0B,18,18^FH\^CI28^FD'+cMVPAR05+'^FS^CI27'+ CRLF)
		AADD(_aArq,'^FO51,25^GFA,497,1304,8,:Z64:eJyN0rFOwzAQBmBbRXRBSUeGyn4FRoaoeRzWjAwV6aNZYq14AoZ0KkPUmK1So5r0/j8RDg3goZ/SnO/suyj1bd3RJV0D3QqLGTQptHkFg6MI52s1O8bP9jxyBU0C728vtSo1+4DzGqaHy1uv7EUdvKHLkZJXvy5SyX/Dupmbi22lPZW41kucrum2sLHeKNaT04Uq7ZX8uYMJ7jPUDy33nWlIKOrs9tCN3DUwNHJOHQ44d3hjPYX3lTKGJrFWCh4ZF7zcv3NOZR6XZ8f+e8y6lDmtXck+BfbnuEJ/pAFdX3wCq8jaw+BlX9cfWDqYbwLnjZVvID+aLl6xz3BHK+qK6NmeEG8ZP+WP1eefEmkHVS8/4sl943oZ77dmgpb3axlf020RW4/ysS+DpYOWdTR94v8N6zQ+9q2IfS/i89D+nOrZxffp59XXH+ZFP3+flz798z7qQX7TPeLTibmaF0SbDC4fr2uyxdX9f34nXF8AEhF6:12FC'+ CRLF)
		AADD(_aArq,'^PQ1,0,1,Y'+ CRLF)
		AADD(_aArq,'^XZ'+ CRLF)
		AaDd(aCodEtq,_aArq)
		_aArq:= {}
	Next x

		For nY:=1 To Len(aCodEtq)
			For nP:=1 To Len(aCodEtq[nY])
				MSCBWrite(aCodEtq[nY][nP])
			Next nP
		Next nY

		aCodEtq:={}
	
		MSCBEND()

		nSomaSer := Soma1(nSomaSer)

	
	MSCBCLOSEPRINTER()
	ETQ->(dbCloseArea())

Return ( .T. )
