#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCoDifSal()  บAutor  ณHelio Ferreira    บ Data ณ  11/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CoDifSal()

	Local nLinIni  := 40
	Local nAltura1 := 80
	Local nAltura2 := 80
	Local nAltura3 := 80

//Variaveis do tamanho a tela
	Private aDlgTela     := {000,000,600,1200}

//Divis๕es dentro da tela
	Private aDlgCabc     := {005,005,035,497}

//Private aDlgGd01   := {040,005,105,400}
//Private aDlgGd02   := {110,005,165,240}
//Private aDlgGd03   := {170,005,220,240}

	Private aDlgGd01     := {nLinIni                 ,005,nLinIni+nAltura1                 ,500}
	Private aDlgGd02     := {aDlgGd01[3]+5           ,005,aDlgGd01[3]+5+nAltura2           ,400}
	Private aDlgGd03     := {aDlgGd01[3]+5+nAltura2+5,005,aDlgGd01[3]+5+nAltura2+5+nAltura3,300}

	Private aDlgRodp     := {225,005,245,497}

//Variaveis diversas
	Private oDialg

	Private oGdItm

	Private cStrCad := "SB1,SB2,SB8,SBF,SD3,SD5,SDA,SDB"
	Private cTitCad := "Ajusta Saldo do Produto"
	Private cPrtCad    := cTitCad+" ["+cStrCad+"]"
	Private lPesqOk    := .F.

	Private oGdItm01   := Nil
	Private oGdItm02   := Nil
	Private oGdItm03   := Nil

	Private oSayCod    := Nil
	Private oSayDsc    := Nil
	Private oSayDt     := Nil

	Private oGetCod    := Nil
	Private oGetDsc    := Nil

	Private cGetCod    := Space(15)
	Private cGetDsc    := Space(50)
	Private dGetDt     := dDataBase

	Private nCtrlClik  := 1
	Private lCheck1    := .F.
	Private lCheck2    := .T.
	Private lCheck3    := .T.
	Private lCheck4    := .F.
	Private lCheck5    := .T.

	Private cLocUni    := ""
	Private cLotUni    := ""
	Private cEndUni    := ""

	Private nPadNum    := 12  //10
	Private nPadDec    := 4
	Private nPadMasc   := "@E 999,999,999.9999"
// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

	fCabec(oDialg,aDlgCabc)

	fGdItm01(oDialg,aDlgGd01)
	fGdItm02(oDialg,aDlgGd02)
	fGdItm03(oDialg,aDlgGd03)

	fRodap(oDialg,aDlgRodp)

	Activate MsDialog oDialg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCabec   บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCabec(oDialg,aSizeDlg)

	Local nQtdCpo := 5
	Local nTamCpo := (aSizeDlg[4]/nQtdCpo)-6.8

//Codigo - Declara็ใo das Variแveis
	Local bSayCod := {|| "Codigo"}
	Local aSayCod := {aSizeDlg[1]+05,   aSizeDlg[2]+(05*1),   nTamCpo,   008}
	Local aGetCod := {aSizeDlg[1]+15,   aSizeDlg[2]+(05*1),   nTamCpo,   008}

//Descri็ใo - Declara็ใo das Variแveis
	Local bSayDsc := {|| "Descri็ใo"}
	Local aSayDsc := {aSizeDlg[1]+05,   aSizeDlg[2]+(05*2)+(nTamCpo*1),   nTamCpo,   008}
	Local aGetDsc := {aSizeDlg[1]+15,   aSizeDlg[2]+(05*2)+(nTamCpo*1),   nTamCpo,   008}

// *** dDataBase ***
	Local bSayDt  := {|| "### dDataBase ###"}
	Local aSayDt := {aSizeDlg[1]+05,   aSizeDlg[2]+(05*3)+(nTamCpo*2),   nTamCpo,   008}
	Local aGetDt := {aSizeDlg[1]+15,   aSizeDlg[2]+(05*3)+(nTamCpo*2),   nTamCpo,   008}


//Bot๕es - Declara็ใo das Variแveis
	Local nTamBtn := (aSizeDlg[4]/7)-6.3
	Local aBtn01  := {aSizeDlg[1]+15,    aSizeDlg[2]+(05*6)+(nTamBtn*5),   nTamBtn-1 , 012}
	Local aBtn02  := {aSizeDlg[1]+15,    aSizeDlg[2]+(05*7)+(nTamBtn*6),   nTamBtn-1 , 012}
	Local aBtn03  := {aSizeDlg[1]+02,    aSizeDlg[2]+(05*8)            ,   nTamBtn-18, 010}

//Contorno
	@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Campo Codigo
	oSayCod := TSay():New( aSayCod[1],aSayCod[2],bSayCod,oDialg,,,.F.,.F.,.F.,.T.,,,aSayCod[3],aSayCod[4])
	oGetCod := TGet():New( aGetCod[1],aGetCod[2],{|u| IIf(Pcount()>0,cGetCod:=u,cGetCod)},oDialg,aGetCod[3],aGetCod[4],'@!',{|| cLocUni:='', FVGetCod() },,,,.F.,,.T.,  ,.F.,/*cWhen*/{||.T.},.F.,.F.,,.F.,.F.,"SB1","",,,,.T.)

//Campo Descri็ใo
	oSayDsc := TSay():New( aSayDsc[1],aSayDsc[2],bSayDsc,oDialg,,,.F.,.F.,.F.,.T.,,,aSayDsc[3],aSayDsc[4])
	oGetDsc := TGet():New( aGetDsc[1],aGetDsc[2],{|u| IIf(Pcount()>0,cGetDsc:=u,cGetDsc)},oDialg,aGetDsc[3],aGetDsc[4],'@!',/*cValid*/{||.F.},,,,.F.,,.T.,  ,.F.,/*cWhen*/{||.F.},.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//Campo DataBase
	oSayDt  := TSay():New( aSayDt[1],aSayDt[2],bSayDt,oDialg,,,.F.,.F.,.F.,.T.,,,aSayDt[3],aSayDt[4])
	oGetDt  := TGet():New( aGetDt[1],aGetDt[2],{|u| IIf(Pcount()>0,dGetDt:=u,dGetDt)},oDialg,aGetDt[3],aGetDt[4],'@D',/*cValid*/{||dDataBase:=dGetDt,.T.},,,,.F.,,.T.,  ,.F.,/*cWhen*/{||.T.},.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//Bot๕es
	@ aBtn01[1],aBtn01[2] Button "Limpar"         Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fLimpar()
	@ aBtn02[1],aBtn02[2] Button "Recarregar"     Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action FVGetCod(.T.)
	@ aBtn03[1],aBtn03[2] Button "Varre Difsaldo" Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action ProxDifsaldo()

// CheckBox do msGet do SB2
	oCheck1 := TCheckBox():New(aDlgGd01[1]   ,aDlgGd01[4]+10,'Filtra B2_QATU zero'              ,{|| lCheck1 },oDialg,100,210,,,,,,,,.T.,,,)
	oCheck4 := TCheckBox():New(aDlgGd01[1]+10,aDlgGd01[4]+10,"Roda 'Varre Difsaldo' automatico" ,{|| lCheck4 },oDialg,100,210,,,,,,,,.T.,,,)
	oCheck5 := TCheckBox():New(aDlgGd01[1]+20,aDlgGd01[4]+10,"Reprocessa saldos"                ,{|| lCheck5 },oDialg,100,210,,,,,,,,.T.,,,)

	@ aDlgGd01[1]+30,aDlgGd01[4]+10 Button "Corrigir Negativos"  Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action ButNegB2()

	oCheck1:cVariable := "lCheck1"
	oCheck1:bSetGet := {|u| If(PCount()>0,lCheck1:=u,lCheck1) }
	oCheck1:bChange := {|| Clic1Check()(lCheck1), oMainWnd:Refresh() }

	oCheck4:cVariable := "lCheck4"
	oCheck4:bSetGet := {|u| If(PCount()>0,lCheck4:=u,lCheck4) }
	oCheck4:bChange := {|| Clic4Check()(lCheck4), oMainWnd:Refresh() }

	oCheck5:cVariable := "lCheck5"
	oCheck5:bSetGet := {|u| If(PCount()>0,lCheck5:=u,lCheck5) }
//oCheck4:bChange := {|| Clic4Check()(lCheck4), oMainWnd:Refresh() }

// CheckBox do msGet do SB2
	oCheck2 := TCheckBox():New(aDlgGd02[1],aDlgGd02[4]+10,'Filtra B8_SALDO zero' ,{|| lCheck2 },oDialg,100,210,,,,,,,,.T.,,,)

	oCheck2:cVariable := "lCheck2"
	oCheck2:bSetGet := {|u| If(PCount()>0,lCheck2:=u,lCheck2) }
	oCheck2:bChange := {|| Clic2Check()(lCheck2), oMainWnd:Refresh() }

	@ aDlgGd02[1]+10,aDlgGd02[4]+10 Button "Corrigir Negativos"  Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action ButNegB8(@oGdItm03)

	@ aDlgGd02[1]+25,aDlgGd02[4]+10 Button "Corrigir B2 x B8"    Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action ButB2B8()

//If Subs(cUsuario,7,5) == 'HELIO'
	@ aDlgGd02[1]+40,aDlgGd02[4]+10 Button "Gerar B8"         Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action GeraSB8()
//EndIf

	SetKey(VK_F4,{|| ButB2B8()})

// CheckBox do msGet do SBF
	oCheck3 := TCheckBox():New(aDlgGd03[1],aDlgGd03[4]+10,'Filtra BF_QUANT zero' ,{|| lCheck3 },oDialg,100,210,,,,,,,,.T.,,,)

	oCheck3:cVariable := "lCheck3"
	oCheck3:bSetGet := {|u| If(PCount()>0,lCheck3:=u,lCheck3) }
	oCheck3:bChange := {|| Clic3Check()(lCheck3), oMainWnd:Refresh() }

	@ aDlgGd03[1]+10,aDlgGd03[4]+10 Button "Corrigir Negativos"  Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action ButNegBF(@oGdItm03)

	@ aDlgGd03[1]+25,aDlgGd03[4]+10 Button "Corrigir B2 x BF"    Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action ButB2BF()

	If Subs(cUsuario,7,5) == 'HELIO'
		@ aDlgGd03[1]+40,aDlgGd03[4]+10 Button "Gerar BF"         Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action GeraSBF()
	EndIf

	SetKey(VK_F3,{|| ButB2BF()})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLimpar  บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLimpar()

	cGetCod := Space(15)
	cGetDsc := Space(50)

	oGetCod:Refresh()
	oGetDsc:Refresh()

//Limpa GetDados 01
	fGd01Limpa()

//Limpa GetDados 02
	fGd02Limpa()

//Limpa GetDados 03
	fGd03Limpa()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPesquisarบAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FVGetCod(lRec300)
	Default lRec300 := .F.
	MsgRun("Procurando registros...","Favor Aguardar.....",{|| Carregando(lRec300) })
Return

Static Function Carregando(lRec300)
	Local cQuery  := ""
	Local cQbra := Chr(13)+Chr(10)
	Local _Retorno := .T.

	If Empty(cGetCod)
		Return .T.
	EndIf

	cGetDsc := Posicione("SB1",1,xFilial("SB1")+cGetCod,"B1_DESC")

	If lCheck5 .or. lRec300
		U_DOMESTD5()
		U_UMATA300(cGetCod,cGetCod,,)
	Else
		//If MsgNoYes("Reprocessa saldos?")
		//	U_UMATA300(cGetCod,cGetCod,,)
		//EndIf
	EndIf
	cQuery += cQbra+" SELECT "
	cQuery += cQbra+" B2_LOCAL, "
	cQuery += cQbra+" B2_QATU, "
	cQuery += cQbra+" B2_QEMP, "
	cQuery += cQbra+" B2_QACLASS, "

	cQuery += cQbra+" (SELECT SUM(B8_SALDO) FROM "+RetSqlName("SB8")+" SB8 (NOLOCK) "
	cQuery += cQbra+" WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_LOCAL = SB2.B2_LOCAL AND B8_PRODUTO = '"+cGetCod+"' AND SB8.D_E_L_E_T_ = '' ) AS B8_SALDO, "

	cQuery += cQbra+" (SELECT SUM(BF_QUANT) FROM "+RetSqlName("SBF")+" SBF (NOLOCK) "
	cQuery += cQbra+" WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_LOCAL = SB2.B2_LOCAL AND BF_PRODUTO = '"+cGetCod+"' AND SBF.D_E_L_E_T_ = '' ) AS BF_QUANT "

	cQuery += cQbra+" FROM "+RetSqlName("SB2")+" SB2 (NOLOCK) "
	cQuery += cQbra+" WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = '"+cGetCod+"' "
	cQuery += cQbra+" AND SB2.D_E_L_E_T_ = '' "

	If lCheck1
		cQuery += cQbra+" AND SB2.B2_QATU <> 0 "
	EndIf

	If !Empty(cLocUni)
		cQuery += cQbra+" AND SB2.B2_LOCAL = '"+cLocUni+"' "
	EndIf

	cQuery += cQbra+" ORDER BY B2_LOCAL "

//Fecha Alias caso encontre
	If Select("QUERYSB2") <> 0 ; QUERYSB2->(dbCloseArea()) ; EndIf

//Cria alias temporario
		TcQuery cQuery New Alias "QUERYSB2"

//Limpa GetDados 01
		fGd01Limpa()

//Carrega GetDados 01 com nova pesquisa
		fGd01Carga()
//========================================================================================
		cQuery  := ""

		cQuery += cQbra+" SELECT "
		cQuery += cQbra+" B8_LOCAL, "
		cQuery += cQbra+" B8_SALDO, "
		cQuery += cQbra+" B8_EMPENHO, "
		cQuery += cQbra+" B8_QACLASS, "
		cQuery += cQbra+" B8_LOTECTL, "

		cQuery += cQbra+" (SELECT SUM(BF_QUANT) FROM "+RetSqlName("SBF")+" SBF (NOLOCK) "
		cQuery += cQbra+" WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_LOCAL = SB8.B8_LOCAL AND BF_PRODUTO = '"+cGetCod+"' AND BF_LOTECTL = SB8.B8_LOTECTL AND SBF.D_E_L_E_T_ = '' ) AS BF_QUANT "

		cQuery += cQbra+" FROM "+RetSqlName("SB8")+" SB8 (NOLOCK) "
		cQuery += cQbra+" WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_PRODUTO = '"+cGetCod+"' "
		cQuery += cQbra+" AND SB8.D_E_L_E_T_ = '' "
		If lCheck2
			cQuery += cQbra+" AND SB8.B8_SALDO <> 0 "
		EndIf

		If !Empty(cLocUni)
			cQuery += cQbra+" AND SB8.B8_LOCAL = '"+cLocUni+"' "
		EndIf

		cQuery += cQbra+" ORDER BY B8_LOCAL,B8_SALDO,B8_LOTECTL,BF_QUANT "

//Fecha Alias caso encontre
		If Select("QUERYSB8") <> 0 ; QUERYSB8->(dbCloseArea()) ; EndIf

//Cria alias temporario
			TcQuery cQuery New Alias "QUERYSB8"

//Limpa GetDados 02
			fGd02Limpa()

//Carrega GetDados 02 com nova pesquisa
			fGd02Carga()
//========================================================================================
			cQuery  := ""

			cQuery += cQbra+" SELECT      "
			cQuery += cQbra+" BF_LOCAL,   "
			cQuery += cQbra+" BF_QUANT,   "
			cQuery += cQbra+" BF_EMPENHO, "
			cQuery += cQbra+" BF_LOTECTL, "
			cQuery += cQbra+" BF_LOCALIZ  "
			cQuery += cQbra+" FROM "+RetSqlName("SBF")+" SBF (NOLOCK) "
			cQuery += cQbra+" WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND BF_PRODUTO = '"+cGetCod+"' "
			cQuery += cQbra+" AND SBF.D_E_L_E_T_ = '' "
			If lCheck3
				cQuery += cQbra+" AND SBF.BF_QUANT <> 0 "
			EndIf

			If !Empty(cLocUni)
				cQuery += cQbra+" AND SBF.BF_LOCAL = '"+cLocUni+"' "
			EndIf

			cQuery += cQbra+" ORDER BY BF_LOCAL, BF_QUANT DESC, BF_LOTECTL "

//Fecha Alias caso encontre
			If Select("QUERYSBF") <> 0 ; QUERYSBF->(dbCloseArea()) ; EndIf

//Cria alias temporario
				TcQuery cQuery New Alias "QUERYSBF"

//Limpa GetDados 03
				fGd03Limpa()

//Carrega GetDados 03 com nova pesquisa
				fGd03Carga()
//========================================================================================

//Fecha Alias
				QUERYSB2->(dbCloseArea())

				Return _Retorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGd01LimpaบAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGd01Limpa()

//Apaga registros da pesquisa anterior
	oGdItm01:aCols := {}

//Atualiza objeto
	oGdItm01:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGd01LimpaบAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGd02Limpa()

//Apaga registros da pesquisa anterior
	oGdItm02:aCols := {}

//Atualiza objeto
	oGdItm02:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGd01LimpaบAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGd03Limpa()

//Apaga registros da pesquisa anterior
	oGdItm03:aCols := {}

//Atualiza objeto
	oGdItm03:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGd01CargaบAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGd01Carga()

//Local nPosFlag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
//Local nPosCod  := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_CODIGO"})
//Local nPosDesc := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_DESCRI"})
//Local nPosRecn := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_RECNO"})

	Local nPB2FLAG    := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_FLAG"})
	Local nPB2LOCAL   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_LOCAL"})
	Local nPB2QATU    := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_QATU"})
	Local nPB2QEMP    := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_QEMP"})
	Local nPB2QACLASS := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_QACLASS"})
	Local nPB8SALDO   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B8_SALDO"})
	Local nPDIFB2B8   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="DIFB2B8"})
	Local nPBFQUANT   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="BF_QUANT"})
	Local nPDIFB2BF   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="DIFB2BF"})

	Local nConta   := 0

//Carrega aCols com base no resultado da query
	QUERYSB2->(DbGoTop())
	While QUERYSB2->(!Eof())
		//Contador para item
		nConta ++

		//Cria uma linha no aCols
		aAdd(oGdItm01:aCols,Array(Len(oGdItm01:aHeader)+1))
		nLin := Len(oGdItm01:aCols)

		//Alimenta a linha do aCols vazia
		If cLocUni <> QUERYSB2->B2_LOCAL
			oGdItm01:aCols[nLin, nPB2FLAG]    := "LBNO"
		Else
			oGdItm01:aCols[nLin, nPB2FLAG]    := "LBTIK"
		EndIf
		oGdItm01:aCols[nLin, nPB2LOCAL]   := QUERYSB2->B2_LOCAL
		oGdItm01:aCols[nLin, nPB2QATU]    := QUERYSB2->B2_QATU
		oGdItm01:aCols[nLin, nPB2QEMP]    := QUERYSB2->B2_QEMP
		oGdItm01:aCols[nLin, nPB2QACLASS] := QUERYSB2->B2_QACLASS
		oGdItm01:aCols[nLin, nPB8SALDO]   := QUERYSB2->B8_SALDO
		oGdItm01:aCols[nLin, nPDIFB2B8]   := QUERYSB2->B2_QATU-QUERYSB2->B8_SALDO
		oGdItm01:aCols[nLin, nPBFQUANT]   := QUERYSB2->BF_QUANT
		oGdItm01:aCols[nLin, nPDIFB2BF]   := (QUERYSB2->B2_QATU-QUERYSB2->B2_QACLASS)-QUERYSB2->BF_QUANT
		oGdItm01:aCols[nLin, Len(oGdItm01:aHeader)+1] := .F.

		QUERYSB2->(DbSkip())
	End

//Carrega aCols com uma linha vazia por nใo teve resultado na query
	QUERYSB2->(DbGoTop())
	If QUERYSB2->(Eof())
		//Cria uma linha no aCols
		aAdd(oGdItm01:aCols,Array(Len(oGdItm01:aHeader)+1))
		nLin := Len(oGdItm01:aCols)

		//Alimenta a linha do aCols vazia
		oGdItm01:aCols[nLin, nPB2FLAG] := "LBNO"
		oGdItm01:aCols[nLin, nPB2LOCAL]   := ""
		oGdItm01:aCols[nLin, nPB2QATU]    := 0
		oGdItm01:aCols[nLin, nPB2QEMP]    := 0
		oGdItm01:aCols[nLin, nPB2QACLASS] := 0
		oGdItm01:aCols[nLin, Len(oGdItm01:aHeader)+1] := .F.
	EndIf

//Atualiza tela
	oGdItm01:oBrowse:nAt := 1
	oGdItm01:oBrowse:Refresh()
	oGdItm01:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGd02CargaบAutor  ณ  Felipe A. Melo    บ Data ณ  12/04/2023 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGd02Carga()

	Local nPB8FLAG    := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_FLAG"   })
	Local nPB8LOCAL   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_LOCAL"  })
	Local nPB8SALDO   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_SALDO"  })
	Local nPB8EMPENHO := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_EMPENHO"})
	Local nPB8QACLASS := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_QACLASS"})
	Local nPB8LOTECTL := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_LOTECTL"})
	Local nPBFQUANT   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="BF_QUANT"  })
	Local nPDIFB8BF   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="DIFB8BF"   })

	Local nConta   := 0

//Carrega aCols com base no resultado da query
	QUERYSB8->(DbGoTop())
	While QUERYSB8->(!Eof())
		//Contador para item
		nConta ++

		//Cria uma linha no aCols
		aAdd(oGdItm02:aCols,Array(Len(oGdItm02:aHeader)+1))
		nLin := Len(oGdItm02:aCols)

		//Alimenta a linha do aCols vazia
		oGdItm02:aCols[nLin, nPB8FLAG    ] := "LBNO"
		oGdItm02:aCols[nLin, nPB8LOCAL   ] := QUERYSB8->B8_LOCAL
		oGdItm02:aCols[nLin, nPB8SALDO   ] := QUERYSB8->B8_SALDO
		oGdItm02:aCols[nLin, nPB8EMPENHO ] := QUERYSB8->B8_EMPENHO
		oGdItm02:aCols[nLin, nPB8QACLASS ] := QUERYSB8->B8_QACLASS
		oGdItm02:aCols[nLin, nPB8LOTECTL ] := QUERYSB8->B8_LOTECTL
		oGdItm02:aCols[nLin, nPBFQUANT   ] := QUERYSB8->BF_QUANT
		oGdItm02:aCols[nLin, nPDIFB8BF   ] := (QUERYSB8->B8_SALDO-QUERYSB8->B8_QACLASS)-QUERYSB8->BF_QUANT
		oGdItm02:aCols[nLin, Len(oGdItm02:aHeader)+1] := .F.

		QUERYSB8->(DbSkip())
	End

//Carrega aCols com uma linha vazia por nใo teve resultado na query
	QUERYSB8->(DbGoTop())
	If QUERYSB8->(Eof())
		//Cria uma linha no aCols
		aAdd(oGdItm02:aCols,Array(Len(oGdItm02:aHeader)+1))
		nLin := Len(oGdItm02:aCols)

		//Alimenta a linha do aCols vazia
		oGdItm02:aCols[nLin, nPB8FLAG    ] := "LBNO"
		oGdItm02:aCols[nLin, nPB8LOCAL   ] := ""
		oGdItm02:aCols[nLin, nPB8SALDO   ] := 0
		oGdItm02:aCols[nLin, nPB8EMPENHO ] := 0
		oGdItm02:aCols[nLin, nPB8QACLASS ] := 0
		oGdItm02:aCols[nLin, nPB8LOTECTL ] := ""
		oGdItm02:aCols[nLin, Len(oGdItm02:aHeader)+1] := .F.
	EndIf

//Atualiza tela
	oGdItm02:oBrowse:nAt := 1
	oGdItm02:oBrowse:Refresh()
	oGdItm02:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGd03CargaบAutor  ณ  Felipe A. Melo    บ Data ณ  12/04/2033 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGd03Carga()

	Local nPBFFLAG    := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_FLAG"   })
	Local nPBFLOCAL   := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_LOCAL"  })
	Local nPBFQUANT   := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_QUANT"  })
	Local nPBFEMPENHO := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_EMPENHO"})
	Local nPBFLOTECTL := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_LOTECTL"})
	Local nPBFLOCALIZ := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_LOCALIZ"})

	Local nConta   := 0

//Carrega aCols com base no resultado da query
	QUERYSBF->(DbGoTop())
	While QUERYSBF->(!Eof())
		//Contador para item
		nConta ++

		//Cria uma linha no aCols
		aAdd(oGdItm03:aCols,Array(Len(oGdItm03:aHeader)+1))
		nLin := Len(oGdItm03:aCols)

		//Alimenta a linha do aCols vazia
		oGdItm03:aCols[nLin, nPBFFLAG   ] := "LBNO"
		oGdItm03:aCols[nLin, nPBFLOCAL  ] := QUERYSBF->BF_LOCAL
		oGdItm03:aCols[nLin, nPBFQUANT  ] := QUERYSBF->BF_QUANT
		oGdItm03:aCols[nLin, nPBFEMPENHO] := QUERYSBF->BF_EMPENHO
		oGdItm03:aCols[nLin, nPBFLOTECTL] := QUERYSBF->BF_LOTECTL
		oGdItm03:aCols[nLin, nPBFLOCALIZ] := QUERYSBF->BF_LOCALIZ
		oGdItm03:aCols[nLin, Len(oGdItm03:aHeader)+1] := .F.

		QUERYSBF->(DbSkip())
	End

//Carrega aCols com uma linha vazia por nใo teve resultado na query
	QUERYSBF->(DbGoTop())
	If QUERYSBF->(Eof())
		//Cria uma linha no aCols
		aAdd(oGdItm03:aCols,Array(Len(oGdItm03:aHeader)+1))
		nLin := Len(oGdItm03:aCols)

		//Alimenta a linha do aCols vazia
		oGdItm03:aCols[nLin, nPBFFLAG   ] := "LBNO"
		oGdItm03:aCols[nLin, nPBFLOCAL  ] := ""
		oGdItm03:aCols[nLin, nPBFQUANT  ] := 0
		oGdItm03:aCols[nLin, nPBFEMPENHO] := 0
		oGdItm03:aCols[nLin, nPBFLOTECTL] := 0
		oGdItm03:aCols[nLin, nPBFLOCALIZ] := ""
		oGdItm03:aCols[nLin, Len(oGdItm03:aHeader)+1] := .F.
	EndIf

//Atualiza tela
	oGdItm03:oBrowse:nAt := 1
	oGdItm03:oBrowse:Refresh()
	oGdItm03:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGdItm01 บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGdItm01(oDialg,aSizeDlg)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := GD_UPDATE                   // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHead          := {}                                              // Array do aHeader
	Local aCols          := {}                                              // Array do aCols

//          X3_TITULO    , X3_CAMPO     , X3_PICTURE ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(aHead,{""           ,"B2_FLAG"     ,"@BMP"      ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B2_LOCAL"   ,"B2_LOCAL"    ,"@!"        ,          02,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B2_QATU"    ,"B2_QATU"     ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B2_QEMP"    ,"B2_QEMP"     ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B2_QACLASS" ,"B2_QACLASS"  ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B8_SALDO"   ,"B8_SALDO"    ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"BF_QUANT"   ,"BF_QUANT"    ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"DIF B2 - B8","DIFB2B8"     ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"DIF B2 - BF","DIFB2BF"     ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
	aAdd(aCols,Array(Len(aHead)+1))
	nLin := Len(aCols)

//Alimenta a linha do aCols vazia
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B2_FLAG"   }) ] := "LBNO"
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B2_LOCAL"  }) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B2_QATU"   }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B2_QEMP"   }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B2_QACLASS"}) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B8_SALDO"  }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="DIFB2B8"   }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_QUANT"  }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="DIFB2BF"   }) ] := 0
	aCols[nLin, Len(aHead)+1]                                   := .F.

	oGdItm01:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
	oGdItm01:oBrowse:bLDblClick := {|| fDblClick1(@oGdItm01) }

	SetKey(VK_F1,{||oGdItm01:oBrowse:SetFocus()})

//oGdItm01:oBrowse:bGotFocus := { || fDblClick1(@oGdItm01) }

//oGdItm01:oBrowse:bLClicked:= {|| fDblClick1(@oGdItm01) }

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGdItm02 บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGdItm02(oDialg,aSizeDlg)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := GD_UPDATE                   // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHead          := {}                                              // Array do aHeader
	Local aCols          := {}                                              // Array do aCols

//          X3_TITULO    , X3_CAMPO      , X3_PICTURE ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(aHead,{""           ,"B8_FLAG"      ,"@BMP"      ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B8_LOCAL"   ,"B8_LOCAL"     ,"@!"        ,          02,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B8_SALDO"   ,"B8_SALDO"     ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B8_EMPENHO" ,"B8_EMPENHO"   ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B8_QACLASS" ,"B8_QACLASS"   ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"B8_LOTECTL" ,"B8_LOTECTL"   ,"@R"        ,          10,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"BF_QUANT"   ,"BF_QUANT"     ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"DIF B8 - BF","DIFB8BF"      ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
	aAdd(aCols,Array(Len(aHead)+1))
	nLin := Len(aCols)

//Alimenta a linha do aCols vazia
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B8_FLAG"   }) ] := "LBNO"
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B8_LOCAL"  }) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B8_SALDO"  }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B8_EMPENHO"}) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B8_QACLASS"}) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="B8_LOTECTL"}) ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_QUANT"  }) ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="DIFB8BF"   }) ] := 0
	aCols[nLin, Len(aHead)+1]                                   := .F.

	oGdItm02:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
	oGdItm02:oBrowse:bLDblClick := {|| fDblClick2(@oGdItm02) }

//SetKey(VK_F4,{||oGdItm02:oBrowse:SetFocus()})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGdItm03 บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGdItm03(oDialg,aSizeDlg)

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Local cGetOpc        := GD_UPDATE                   // GD_INSERT+GD_DELETE+GD_UPDATE
	Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Local aHead          := {}                                              // Array do aHeader
	Local aCols          := {}                                              // Array do aCols

//          X3_TITULO    , X3_CAMPO     , X3_PICTURE ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(aHead,{""           ,"BF_FLAG"     ,"@BMP"      ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"BF_LOCAL"   ,"BF_LOCAL"    ,"@!"        ,          02,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"BF_QUANT"   ,"BF_QUANT"    ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"BF_EMPENHO" ,"BF_EMPENHO"  ,nPadMasc    ,     nPadNum,    nPadDec, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"BF_LOTECTL" ,"BF_LOTECTL"  ,"@!"        ,          10,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(aHead,{"BF_LOCALIZ" ,"BF_LOCALIZ"  ,"@!"        ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//aAdd(aHead,{""           ,"XX_FLAG"      ,"@BMP"               ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHead,{"Cod. Prod"  ,"XX_CODIGO"    ,"@!"                 ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHead,{"Desc. Prod" ,"XX_DESCRI"    ,"@!"                 ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHead,{"Recno SB1"  ,"XX_RECNO"     ,"@E 9999999999"      ,          10,          0, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
	aAdd(aCols,Array(Len(aHead)+1))
	nLin := Len(aCols)

//Alimenta a linha do aCols vazia
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_FLAG"   })  ] := "LBNO"
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_LOCAL"  })  ] := ""
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_QUANT"  })  ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_EMPENHO"})  ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_LOTECTL"})  ] := 0
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="BF_LOCALIZ"})  ] := ""
	aCols[nLin, Len(aHead)+1]                                    := .F.

	oGdItm03:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
	oGdItm03:oBrowse:bLDblClick := {|| fDblClick3(@oGdItm03) }

	SetKey(VK_F2,{||oGdItm03:oBrowse:SetFocus()})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDblClick1บAutor ณ Felipe A. Melo     บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDblClick1(oGetDad)

	Local x         := 1
	Local nLinhaOK  := oGetDad:oBrowse:nAt
	Local nPB2FLAG  := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="B2_FLAG"  })
	Local nPB2LOCAL := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="B2_LOCAL" })
	Local cVarTmp   := oGetDad:aCols[nLinhaOK][nPB2FLAG]

//Trata quando nใo teve resultado
//If Empty(oGetDad:aCols[nLinhaOK][nPosCod])
//	Alert("Este item nใo pode ser marcado, pois nada consta nele!")
//	Return
//EndIf

//Desmarca todos
	For x:=1 To Len(oGetDad:aCols)
		oGetDad:aCols[x][nPB2FLAG] := "LBNO"
	Next x

	If cVarTmp == "LBNO"
		oGetDad:aCols[nLinhaOK][nPB2FLAG] := "LBTIK"
		cLocUni    := oGetDad:aCols[nLinhaOK][nPB2LOCAL]
	Else
		cLocUni    := ""
	EndIf

//Atualiza tela
	oGetDad:oBrowse:nAt := nLinhaOK
	oGetDad:oBrowse:Refresh()
	oGetDad:oBrowse:SetFocus()

	FVGetCod()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDblClick2บAutor ณ Felipe A. Melo     บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDblClick2(oGetDad)

	Local x        := 1
	Local cVarTmp  := ""
	Local nLinhaOK := oGetDad:oBrowse:nAt
	Local nPB8FLAG := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="B8_FLAG"  })
//Local nPosCod  := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="XX_CODIGO"})

//Trata quando nใo teve resultado
//If Empty(oGetDad:aCols[nLinhaOK][nPosCod])
//	Alert("Este item nใo pode ser marcado, pois nada consta nele!")
//	Return
//EndIf

//Desmarca todos
	For x:=1 To Len(oGetDad:aCols)
		oGetDad:aCols[x][nPB8FLAG] := "LBNO"
	Next x

	oGetDad:aCols[nLinhaOK][nPB8FLAG] := "LBTIK"

//Atualiza tela
	oGetDad:oBrowse:nAt := nLinhaOK
	oGetDad:oBrowse:Refresh()
	oGetDad:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDblClick3บAutor ณ Felipe A. Melo     บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDblClick3(oGetDad)

	Local x        := 1
	Local cVarTmp  := ""
	Local nLinhaOK := oGetDad:oBrowse:nAt
	Local nPBFFLAG := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="BF_FLAG"  })
//Local nPosCod  := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="XX_CODIGO"})

//Trata quando nใo teve resultado
//If Empty(oGetDad:aCols[nLinhaOK][nPosCod])
//	Alert("Este item nใo pode ser marcado, pois nada consta nele!")
//	Return
//EndIf

//Desmarca todos
	For x:=1 To Len(oGetDad:aCols)
		oGetDad:aCols[x][nPBFFLAG] := "LBNO"
	Next x

	oGetDad:aCols[nLinhaOK][nPBFFLAG] := "LBTIK"

//Atualiza tela
	oGetDad:oBrowse:nAt := nLinhaOK
	oGetDad:oBrowse:Refresh()
	oGetDad:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fRodap   บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRodap(oDialg,aSizeDlg)

	Local nTamBtn := (aSizeDlg[4]/7)-6.3
	Local aBtn01  := {aSizeDlg[1]+4,   aSizeDlg[2]+(05*6)+(nTamBtn*5),   nTamBtn-1, 012}
	Local aBtn02  := {aSizeDlg[1]+4,   aSizeDlg[2]+(05*7)+(nTamBtn*6),   nTamBtn-1, 012}

//Contorno
//@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Bot๕es
	@ aBtn01[1]+30,aBtn01[2]+50 Button "Relatorio Difsaldo"  Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fRelDifSal(oDialg)
	@ aBtn02[1]+30,aBtn02[2]+50 Button "Sair" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fSair(oDialg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fSair    บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSair(oDialg)

	SetKey(VK_F1,{|| Nil })
	SetKey(VK_F2,{|| Nil })
	SetKey(VK_F3,{|| Nil })
	SetKey(VK_F4,{|| Nil })

	oDialg:End()
//dbCloseAll()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAtuliza  บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAtuliza(oDialg)

	Local x := 0
	Local nPos1Flag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })
	Local nPos2Flag := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })
	Local nPos3Flag := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })

	For x:=1 To Len(oGdItm01:aCols)
		//Verifica se tem algum registro marcado [X]
		If oGdItm01:aCols[x][nPos1Flag] == "LBTIK"
			//Esse registro estแ marcado
			//Helio, criar fun็ใo aqui!!!
		EndIf
	Next x

	For x:=1 To Len(oGdItm02:aCols)
		//Verifica se tem algum registro marcado [X]
		If oGdItm02:aCols[x][nPos2Flag] == "LBTIK"
			//Esse registro estแ marcado
			//Helio, criar fun็ใo aqui!!!
		EndIf
	Next x

	For x:=1 To Len(oGdItm03:aCols)
		//Verifica se tem algum registro marcado [X]
		If oGdItm03:aCols[x][nPos3Flag] == "LBTIK"
			//Esse registro estแ marcado
			//Helio, criar fun็ใo aqui!!!
		EndIf
	Next x

	oDialg:End()

Return
Static Function ValProd()
	Local _Retorno := .T.

	SB1->( dbSetOrder(1) )

	If SB1->( dbSeek( xFilial() + cProduto ) )
		cDescricao := SB1->B1_DESC
		oDlg:Refresh()
	Else
		MsgYesNo('Produto nใo encontrado.')
		Return .F.
	EndIf

Return _Retorno

Static Function Clic1Check()
	FVGetCod()
Return

Static Function Clic2Check()
	FVGetCod()
Return

Static Function Clic3Check()
	FVGetCod()
Return

Static Function ButNegBF(oGetDad)
	Local nPBFFLAG    := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="BF_FLAG"   })
	Local nPBFLOCAL   := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="BF_LOCAL"  })
	Local nPBFQUANT   := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="BF_QUANT"  })
	Local nPBFEMPENHO := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="BF_EMPENHO"})
	Local nPBFLOTECTL := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="BF_LOTECTL"})
	Local nPBFLOCALIZ := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="BF_LOCALIZ"})
	Local lTemp       := .F.

	For x := 1 to Len(oGetDad:aCols)
		If oGetDad:aCols[x][nPBFQUANT] < 0
			lTemp := .T.
			If dDataBase > GetMV("MV_ULMES")
				_cAlias   := "SDB"
				_cTM      := "002"
				_cProduto := cGetCod
				_cLocal   := oGetDad:aCols[x][nPBFLOCAL]
				_cLoteCtl := oGetDad:aCols[x][nPBFLOTECTL]
				_cLocaliz := oGetDad:aCols[x][nPBFLOCALIZ]
				_nQtd     := (oGetDad:aCols[x][nPBFQUANT] * (-1))

				fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,_cLocaliz,_nQtd)
			Else
				MsgStop("Database selecionada menor que MV_ULMES ("+DtoC(GetMV("MV_ULMES"))+"). Nใo serแ possํvel corrigir o saldo negativo.")
			EndIf
		EndIf
	Next x

	If !lTemp
		MsgInfo("Nใo foi encontrado localiza็ใo com Quantidade negativa.")
	Else
		If lCheck5
			U_DOMESTD5()
			U_UMATA300(cGetCod,cGetCod,,)
		Else
			//If MsgNoYes("Reprocessa saldos?")
			//	U_UMATA300(cGetCod,cGetCod,,)
			//EndIf
		EndIf

		FVGetCod()    // Recarrega
	EndIf

Return

Static Function fMoviment(__cAlias,__cTM,_dDataBase,__cProduto,__cLocal,__cLoteCtl,__cLocaliz,__nQtd)

	SB1->( dbGoTop() )

	If __cAlias == "SDB"
		If !Localiza(__cProduto)
			MsgStop("Solicitado movimenta็ใo no SDB para um produto sem controle de Localiza็ใo. Solicita็ใo abortada.")
			Return
		EndIf
		If Rastro(__cProduto)
			If Empty(__cLoteCtl)
				MsgStop("Solicitado movimenta็ใo no SDB para um produto que tem controle de lote sem lote informado. Solicita็ใo abortada.")
				Return
			EndIf
		Else
			If !Empty(__cLoteCtl)
				MsgStop("Solicitado movimenta็ใo no SDB para um produto sem controle de lote e foi informado o lote. Solicita็ใo abortada.")
				Return
			EndIf
		EndIf

		cNumIDOper := GetSx8Num('SDB','DB_IDOPERA'); ConfirmSX8()

		Reclock("SDB",.T.)
		SDB->DB_FILIAL  := xFilial("SDB")
		SDB->DB_ITEM    := '0001'
		SDB->DB_PRODUTO := __cProduto
		SDB->DB_LOCAL   := __cLocal
		SDB->DB_LOCALIZ := __cLocaliz
		SDB->DB_DOC     := 'ACERTO'
		SDB->DB_TM      := __cTM
		SDB->DB_ORIGEM  := 'SD3'
		SDB->DB_QUANT   := __nQtd
		SDB->DB_DATA    := _dDataBase
		If Rastro(__cProduto)
			SDB->DB_LOTECTL := __cLoteCtl
		EndIf
		SDB->DB_NUMSEQ  := ProxNum()
		SDB->DB_TIPO    := If(Val(__cTM)<500,'D','R')
		SDB->DB_SERVIC  := If(Val(__cTM)<500,'499','999')
		SDB->DB_ATIVID  := 'ZZZ'
		SDB->DB_HRINI   := Time()
		SDB->DB_ATUEST  := 'S'
		SDB->DB_STATUS  := 'M'
		SDB->DB_ORDATIV := 'ZZ'
		SDB->DB_IDOPERA := cNumIDOper
		SDB->( msUnlock() )
	EndIf

	If __cAlias == "SD5"
		If Rastro(__cProduto)
			If Empty(__cLoteCtl)
				MsgStop("Solicitado movimenta็ใo no SD5 e lote nใo informado. Solicita็ใo abortada.")
				Return
			EndIf
		Else
			MsgStop("Solicitado movimenta็ใo no SD5 para um produto sem controle de lote. Solicita็ใo abortada.")
			Return
		EndIf

		Reclock("SD5",.T.)
		SD5->D5_FILIAL   := xFilial("SD5")
		SD5->D5_NUMSEQ   := ProxNum()
		SD5->D5_PRODUTO  := __cProduto
		SD5->D5_LOCAL    := __cLocal
		SD5->D5_DOC      := 'ACERTO'
		SD5->D5_DATA     := dDataBase
		SD5->D5_ORIGLAN  := __cTM
		SD5->D5_QUANT    := __nQtd
		SD5->D5_LOTECTL  := __cLoteCtl
		SD5->D5_DTVALID  := CtoD("31/12/49")
		SD5->( msUnlock() )
	EndIf

	If __cAlias == "SD3"
		Reclock("SD3",.T.)
		SD3->D3_FILIAL   := xFilial("SD3")
		SD3->D3_NUMSEQ   := ProxNum()
		SD3->D3_COD      := __cProduto
		SD3->D3_LOCAL    := __cLocal
		SD3->D3_DOC      := 'ACERTO'
		SD3->D3_EMISSAO  := dDataBase
		SD3->D3_TM       := __cTM
		SD3->D3_CF       := If(__cTM <= '500','DE0','RE0')
		SD3->D3_QUANT    := __nQtd
		SD3->( msUnlock() )
	EndIf

Return

Static Function ButB2BF()
	Local nPDIFB2B8   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="DIFB2B8"})
	Local nPDIFB2BF   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="DIFB2BF"})

	Local nPDIFB8BF   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="DIFB8BF"})

	Local nPBFFLAG    := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_FLAG"   })
	Local nPBFLOCAL   := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_LOCAL"  })
	Local nPBFQUANT   := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_QUANT"  })
	Local nPBFEMPENHO := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_EMPENHO"})
	Local nPBFLOTECTL := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_LOTECTL"})
	Local nPBFLOCALIZ := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="BF_LOCALIZ"})

	For x := 1 to Len(oGdItm03:aCols)
		If oGdItm03:aCols[x,nPBFQUANT] < 0
			MsgStop("Foram encontrados endere็os com saldo negativo. Corriga primeiro este tipo de erro.")
			Return
		EndIf
	Next x

	If !Empty(cLocUni)
		If oGdItm01:aCols[01, nPDIFB2BF] <> 0

			nLinSBF := 0
			If Len(oGdItm03:aCols) == 1
				nLinSBF := 1
			Else
				For x := 1 to Len(oGdItm03:aCols)
					If oGdItm03:aCols[x, nPBFFLAG] == "LBTIK"
						nLinSBF := x
						Exit
					EndIf
				Next x
			EndIf

			If !Empty(nLinSBF)
				If oGdItm01:aCols[01, nPDIFB2BF] > 0
					_cAlias   := "SDB"
					_cTM      := "002"
					_cProduto := cGetCod
					_cLocal   := oGdItm03:aCols[nLinSBF][nPBFLOCAL]
					_cLoteCtl := oGdItm03:aCols[nLinSBF][nPBFLOTECTL]
					_cLocaliz := oGdItm03:aCols[nLinSBF][nPBFLOCALIZ]
					_nQtd     := oGdItm01:aCols[01, nPDIFB2BF]

					fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,_cLocaliz,_nQtd)
				Else
					_cAlias   := "SDB"
					_cTM      := "503"
					_cProduto := cGetCod
					_cLocal   := oGdItm03:aCols[nLinSBF][nPBFLOCAL]
					_cLoteCtl := oGdItm03:aCols[nLinSBF][nPBFLOTECTL]
					_cLocaliz := oGdItm03:aCols[nLinSBF][nPBFLOCALIZ]

					If oGdItm03:aCols[nLinSBF][nPBFQUANT] >= (oGdItm01:aCols[01, nPDIFB2BF] * (-1))
						_nQtd  := oGdItm01:aCols[01, nPDIFB2BF] * (-1)
					Else
						_nQtd  := oGdItm03:aCols[nLinSBF][nPBFQUANT]
					EndIf

					fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,_cLocaliz,_nQtd)
				EndIf

				If lCheck5
					U_DOMESTD5()
					U_UMATA300(cGetCod,cGetCod,,)
				Else
					//If MsgNoYes("Reprocessa saldos?")
					//	U_UMATA300(cGetCod,cGetCod,,)
					//EndIf
				EndIf

				FVGetCod()    // Recarrega
			Else
				MsgStop("Selecione primeiro uma linha no terceiro MsGet para efetuar a corre็ใo.")
			EndIf
		Else
			MsgStop("Nใo existe diferen็a ente SB2 e SBF para o Almoxarifado selecionado.")
		EndIf
	Else
		MsgStop("Selecione primeiro um Almoxarifado no primeir MsGet.")
	EndIf

	If lCheck4
		ltOk := .T.
		For x := 1 to Len(oGdItm01:aCols)
			If !Empty(oGdItm01:aCols[x,nPDIFB2B8]) .or. !Empty(oGdItm01:aCols[x,nPDIFB2BF])
				ltOk := .F.
				Exit
			EndIf
		Next x

		For x := 1 to Len(oGdItm02:aCols)
			If !Empty(oGdItm02:aCols[x,nPDIFB8BF])
				ltOk := .F.
				Exit
			EndIf
		Next x

		If ltOK
			ProxDifsaldo()
		EndIf
	EndIf

Return

Static Function fRelDifSal()
	aBkpPerg := {}

//Chama pergunta ocultamente para alimentar variแveis
	Pergunte("DIFSAL",.F.,,,,,@aBkpPerg)

//Altera conte๚do de alguma pergunta
	mv_par01 := cGetCod
	mv_par02 := cGetCod
	mv_par03 := 1

	SaveMVVars(.T.)

	__SaveParam("DIFSAL    ", aBkpPerg)

	U_DIFSALDO()

Return

Static Function ButB2B8()
	Local nPDIFB2B8   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="DIFB2B8"})
	Local nPDIFB2BF   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="DIFB2BF"})

	Local nPB8FLAG    := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_FLAG"   })
	Local nPB8LOCAL   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_LOCAL"  })
	Local nPB8SALDO   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_SALDO"  })
	Local nPB8EMPENHO := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_EMPENHO"})
	Local nPB8LOTECTL := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_LOTECTL"})
	Local nPDIFB8BF   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="DIFB8BF"})

	For x := 1 to Len(oGdItm02:aCols)
		If oGdItm02:aCols[x,nPB8SALDO] < 0
			MsgStop("Foram encontrados lotes com saldo negativo. Corriga primeiro este tipo de erro.")
			Return
		EndIf
	Next x

	If !Empty(cLocUni)
		If oGdItm01:aCols[01, nPDIFB2B8] <> 0

			nLinSB8 := 0
			If Len(oGdItm02:aCols) == 1
				nLinSB8 := 1
			Else
				For x := 1 to Len(oGdItm02:aCols)
					If oGdItm02:aCols[x, nPB8FLAG] == "LBTIK"
						nLinSB8 := x
						Exit
					EndIf
				Next x
			EndIf

			If !Empty(nLinSB8)
				If oGdItm01:aCols[01, nPDIFB2B8] > 0
					_cAlias   := "SD5"
					_cTM      := "002"
					_cProduto := cGetCod
					_cLocal   := oGdItm02:aCols[nLinSB8][nPB8LOCAL]
					_cLoteCtl := oGdItm02:aCols[nLinSB8][nPB8LOTECTL]
					_nQtd     := oGdItm01:aCols[01, nPDIFB2B8]

					fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,,_nQtd)
				Else
					_cAlias   := "SD5"
					_cTM      := "503"
					_cProduto := cGetCod
					_cLocal   := oGdItm02:aCols[nLinSB8][nPB8LOCAL]
					_cLoteCtl := oGdItm02:aCols[nLinSB8][nPB8LOTECTL]

					If oGdItm02:aCols[nLinSB8][nPB8SALDO] >= (oGdItm01:aCols[01, nPDIFB2B8] * (-1))
						_nQtd  := oGdItm01:aCols[01, nPDIFB2B8] * (-1)
					Else
						_nQtd  := oGdItm02:aCols[nLinSB8][nPB8SALDO]
					EndIf

					fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,,_nQtd)
				EndIf

				If lCheck5
					U_DOMESTD5()
					U_UMATA300(cGetCod,cGetCod,,)
				Else
					//If MsgNoYes("Reprocessa saldos?")
					//	U_UMATA300(cGetCod,cGetCod,,)
					//EndIf
				EndIf

				FVGetCod()    // Recarrega
			Else
				MsgStop("Selecione primeiro uma linha no segundo MsGet para efetuar a corre็ใo.")
			EndIf
		Else
			MsgStop("Nใo existe diferen็a ente SB2 e SB8 para o Almoxarifado selecionado.")
		EndIf
	Else
		MsgStop("Selecione primeiro um Almoxarifado no primeir MsGet.")
	EndIf

	If lCheck4
		ltOk := .T.
		For x := 1 to Len(oGdItm01:aCols)
			If !Empty(oGdItm01:aCols[x,nPDIFB2B8]) .or. !Empty(oGdItm01:aCols[x,nPDIFB2BF])
				ltOk := .F.
				Exit
			EndIf
		Next x

		For x := 1 to Len(oGdItm02:aCols)
			If !Empty(oGdItm02:aCols[x,nPDIFB8BF])
				ltOk := .F.
				Exit
			EndIf
		Next x

		If ltOK
			ProxDifsaldo()
		EndIf
	EndIf

Return

Static Function ButNegB2()
	Local x
	Local nPB2FFLAG   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_FLAG"   })
	Local nPB2LOCAL   := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_LOCAL"  })
	Local nPB2QATU    := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="B2_QATU"   })
	Local aVetSB2     := {}
	Local lTemp       := .F.

	For x := 1 to Len(oGdItm01:aCols)
		If oGdItm01:aCols[x][nPB2QATU] < 0
			lTemp := .T.
			If dDataBase > GetMV("MV_ULMES")
				_cAlias   := "SD3"
				_cTM      := "002"
				_cProduto := cGetCod
				_cLocal   := oGdItm01:aCols[x][nPB2LOCAL]
				_cLoteCtl := ""
				_cLocaliz := ""
				_nQtd     := oGdItm01:aCols[x][nPB2QATU] * (-1)

				fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,_cLocaliz,_nQtd)

				aadd(aVetSB2,{_cProduto,_cLocal,_nQtd})
			Else
				MsgStop("Database selecionada menor que MV_ULMES ("+DtoC(GetMV("MV_ULMES"))+"). Nใo serแ possํvel corrigir o saldo negativo.")
			EndIf
		EndIf
	Next x

	If !lTemp
		MsgInfo("Nใo foi encontrado SB2 com saldo negativa.")
	Else
		If lCheck5
			U_DOMESTD5()
			U_UMATA300(cGetCod,cGetCod,,)
		Else
			//If MsgNoYes("Reprocessa saldos?")
			//	U_UMATA300(cGetCod,cGetCod,,)
			//EndIf
			For x := 1 to Len(aVetSB2)
				If SB2->( dbSeek( xFilial() + aVetSB2[x,1] + aVetSB2[x,2] ) )
					If Reclock("SB2",.F.)
						SB2->B2_QATU += aVetSB2[x,3]
						SB2->( msUnlock() )
					EndIf
				EndIf
			Next x
		EndIf

		FVGetCod()    // Recarrega
	EndIf

Return


Static Function ButNegB8()
	Local nP8FFLAG    := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_FLAG"   })
	Local nPB8LOCAL   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_LOCAL"  })
	Local nPB8SALDO   := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_SALDO"  })
	Local nPB8EMPENHO := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_EMPENHO"})
	Local nPB8LOTECTL := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_LOTECTL"})
	Local lTemp       := .F.

	For x := 1 to Len(oGdItm02:aCols)
		If oGdItm02:aCols[x][nPB8SALDO] < 0
			lTemp := .T.
			If dDataBase > GetMV("MV_ULMES")
				_cAlias   := "SD5"
				_cTM      := "002"
				_cProduto := cGetCod
				_cLocal   := oGdItm02:aCols[x][nPB8LOCAL]
				_cLoteCtl := oGdItm02:aCols[x][nPB8LOTECTL]
				_cLocaliz := "" //oGdItm03:aCols[x][nPB8LOCALIZ]
				_nQtd     := oGdItm02:aCols[x][nPB8SALDO] * (-1)

				fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,_cLocaliz,_nQtd)
			Else
				MsgStop("Database selecionada menor que MV_ULMES ("+DtoC(GetMV("MV_ULMES"))+"). Nใo serแ possํvel corrigir o saldo negativo.")
			EndIf
		EndIf
	Next x

	If !lTemp
		MsgInfo("Nใo foi encontrado LOTE com saldo negativa.")
	Else
		If lCheck5
			U_DOMESTD5()
			U_UMATA300(cGetCod,cGetCod,,)
		Else
			//If MsgNoYes("Reprocessa saldos?")
			//	U_UMATA300(cGetCod,cGetCod,,)
			//EndIf
		EndIf

		FVGetCod()    // Recarrega
	EndIf

Return

Static Function ProxDifsaldo()
	Local lEnd := .F.

	Processa({|lEnd| ProcRun(@lEnd)}, 'Procurando pr๓ximo Produto com Difsaldo...')

Return

Static Function ProcRun(lEnd)

	Local cProxCod := ''
	Local cTemp    := ''
	Local nContagem := 0

	If Empty(cGetCod)
		SB1->( dbSetOrder(1) )
		SB1->( dbGoTop() )
		cProxCod := SB1->B1_COD
	Else
		SB1->( dbSetOrder(1) )
		SB1->( dbSeek( xFilial() + cGetCod ) )
		SB1->( dbSkip() )
		cProxCod := SB1->B1_COD
	EndIf

	Public lFDifSaldo := .T.

	cQuery := "SELECT COUNT(*) AS CONTAGEM FROM " + RetSqlName("SB1") + " (NOLOCK) WHERE B1_COD >= '"+cProxCod+"' AND D_E_L_E_T_ = '' AND B1_FILIAL='"+xFILIAL("SB1")+"'  "

	If Select("CONTAGEM") <> 0
		CONTAGEM->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "CONTAGEM"

	ProcRegua(CONTAGEM->CONTAGEM,"Procurando pr๓ximo produto com Difsaldo...")
//ProcRegua(10,"Procurando pr๓ximo produto com Difsaldo...")

	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial() + cProxCod ) )

	While !SB1->( EOF() )
		IncProc("Produto: " + SB1->B1_COD)
		If lEnd
			MsgStop('Procura cancelada.')
			Exit
		EndIf
		aAreaSB1 := SB1->( GetArea() )

		aBkpPerg := {}
		Pergunte("DIFSAL",.F.,,,,,@aBkpPerg)
		mv_par01 := SB1->B1_COD
		mv_par02 := SB1->B1_COD
		mv_par03 := 1
		SaveMVVars(.T.)
		__SaveParam("DIFSAL    ", aBkpPerg)

		cTemp := U_DifSaldo()   // Relat๓rio

		If !Empty(cTemp)
			cGetCod := cTemp
			Exit
		EndIf

		RestArea(aAreaSB1)
		SB1->( dbSkip() )
	End

	If Empty(cTemp)
		MsgStop("Nใo foi encontrado um pr๓ximo produto com Difsaldo")
	Else
		//MsgStop("Produto encontrado!")
		cLocUni:=''
		FVGetCod()
	EndIf

	lFDifSaldo := .F.

Return

Static Function Clic4Check()

Return

Static Function GeraSB8()

	If !Empty(cLocUni)
		If QUERYSB8->( EOF() )
			Reclock("SD5",.T.)
			SD5->D5_FILIAL  := xFilial("SD5")
			SD5->D5_NUMSEQ  := ProxNum()
			SD5->D5_PRODUTO := cGetCod
			SD5->D5_LOCAL   := cLocUni
			SD5->D5_DOC     := '00000'
			SD5->D5_DATA    := dDataBase
			SD5->D5_ORIGLAN := '499'
			SD5->D5_QUANT   := 1
			SD5->D5_LOTECTL := 'LOTE1308'
			SD5->D5_DTVALID := StoD("20491231")
			SD5->( msUnlock() )
		Else
			MsgStop('Jแ existe registro no SB8.')
		EndIf
	Else
		MsgStop("Selecione primeiro um Almoxarifado no primeir MsGet.")
	EndIf

	Carregando()

Return

Static Function GeraSBF()

	Local nPB8FLAG    := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_FLAG"   })
	Local nPB8LOTECTL := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="B8_LOTECTL"})
	Local _cLoteCtl   := 'LOTE1308'

	For x := 1 to Len(oGdItm02:aCols)
		If oGdItm02:aCols[x, nPB8FLAG] == "LBTIK"
			_cLoteCtl := oGdItm02:aCols[x][nPB8LOTECTL]
			Exit
		EndIf
	Next x

	SBE->( dbSetOrder(1) )

	If SBE->( dbSeek( xFilial() + cLocUni ) )
		_cAlias   := "SDB"
		_cTM      := "002"
		_cProduto := cGetCod
		_cLocal   := cLocUni
		_cLoteCtl := _cLoteCtl
		_cLocaliz := SBE->BE_LOCALIZ
		_nQtd     := 1

		fMoviment(_cAlias,_cTM,dDataBase,_cProduto,_cLocal,_cLoteCtl,_cLocaliz,_nQtd)

		Carregando()
	Else
		MsgStop("Almoxarifado " + cLocUni + " nใo encontrado no SBE. ")
	EndIf

Return
