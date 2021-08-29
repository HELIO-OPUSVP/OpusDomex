#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fAjusSld บAutor  ณ  Felipe A. Melo    บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fAjusSld()

//Variaveis do tamanho a tela
Local aDlgTela     := {000,000,500,1000}

//Divis๕es dentro da tela
Local aDlgCabc     := {005,005,035,497}

Local aDlgGd01     := {040,005,105,497}
Local aDlgGd02     := {110,005,165,497}
Local aDlgGd03     := {170,005,220,497}

Local aDlgRodp     := {225,005,245,497}

//Variaveis diversas
Local oDialg
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

Private oGetCod    := Nil
Private oGetDsc    := Nil

Private cGetCod    := Space(15)
Private cGetDsc    := Space(50)

Private nCtrlClik  := 1

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

//Bot๕es - Declara็ใo das Variแveis
Local nTamBtn := (aSizeDlg[4]/7)-6.3
Local aBtn01  := {aSizeDlg[1]+15,    aSizeDlg[2]+(05*6)+(nTamBtn*5),   nTamBtn-1, 012}
Local aBtn02  := {aSizeDlg[1]+15,    aSizeDlg[2]+(05*7)+(nTamBtn*6),   nTamBtn-1, 012}

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Campo Codigo
oSayCod := TSay():New( aSayCod[1],aSayCod[2],bSayCod,oDialg,,,.F.,.F.,.F.,.T.,,,aSayCod[3],aSayCod[4])
oGetCod := TGet():New( aGetCod[1],aGetCod[2],{|u| IIf(Pcount()>0,cGetCod:=u,cGetCod)},oDialg,aGetCod[3],aGetCod[4],'@!',/*cValid*/{||.T.},,,,.F.,,.T.,  ,.F.,/*cWhen*/{||.T.},.F.,.F.,,.F.,.F.,"SB1","",,,,.T.)

//Campo Descri็ใo
oSayDsc := TSay():New( aSayDsc[1],aSayDsc[2],bSayDsc,oDialg,,,.F.,.F.,.F.,.T.,,,aSayDsc[3],aSayDsc[4])
oGetDsc := TGet():New( aGetDsc[1],aGetDsc[2],{|u| IIf(Pcount()>0,cGetDsc:=u,cGetDsc)},oDialg,aGetDsc[3],aGetDsc[4],'@!',/*cValid*/{||.T.},,,,.F.,,.T.,  ,.F.,/*cWhen*/{||.T.},.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//Bot๕es
@ aBtn02[1],aBtn02[2] Button "Pesquisar" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fPesquisar()
@ aBtn01[1],aBtn01[2] Button "Limpar"    Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fLimpar()

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
Static Function fPesquisar()

Local cQry  := ""
Local cQbra := Chr(13)+Chr(10)

cQry += cQbra+" SELECT "
cQry += cQbra+" B1_FILIAL, "
cQry += cQbra+" B1_COD, "
cQry += cQbra+" B1_DESC, "
cQry += cQbra+" SB1.R_E_C_N_O_ B1_RECNO "
cQry += cQbra+" FROM "+RetSqlName("SB1")+" SB1(NOLOCK) "
cQry += cQbra+" WHERE SB1.D_E_L_E_T_ = '' "
cQry += cQbra+" AND B1_COD = '"+AllTrim(cGetCod)+"' "
cQry += cQbra+" AND B1_DESC LIKE '%"+AllTrim(cGetDsc)+"%' "
cQry += cQbra+" ORDER BY B1_FILIAL, B1_COD, B1_DESC "

//Fecha Alias caso encontre
If Select("QRY") <> 0 ; QRY->(dbCloseArea()) ; EndIf

//Cria alias temporario
TcQuery cQry New Alias "QRY"

//========================================================================================
//Limpa GetDados 01
fGd01Limpa()

//Carrega GetDados 01 com nova pesquisa
MsgRun("Procurando registros...","Favor Aguardar.....",{|| fGd01Carga() })
//========================================================================================
//Limpa GetDados 02
fGd02Limpa()

//Carrega GetDados 02 com nova pesquisa
MsgRun("Procurando registros...","Favor Aguardar.....",{|| fGd02Carga() })
//========================================================================================
//Limpa GetDados 03
fGd03Limpa()

//Carrega GetDados 03 com nova pesquisa
MsgRun("Procurando registros...","Favor Aguardar.....",{|| fGd03Carga() })
//========================================================================================

//Fecha Alias
QRY->(dbCloseArea())

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

Local nPosFlag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosCod  := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_CODIGO"})
Local nPosDesc := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_DESCRI"})
Local nPosRecn := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_RECNO"})

Local nConta   := 0

//Carrega aCols com base no resultado da query
QRY->(DbGoTop())
While QRY->(!Eof())
	//Contador para item
	nConta ++
	
	//Cria uma linha no aCols
	aAdd(oGdItm01:aCols,Array(Len(oGdItm01:aHeader)+1))
	nLin := Len(oGdItm01:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm01:aCols[nLin, nPosFlag] := "LBNO"
	oGdItm01:aCols[nLin, nPosCod ] := QRY->B1_COD
	oGdItm01:aCols[nLin, nPosDesc] := QRY->B1_DESC
	oGdItm01:aCols[nLin, nPosRecn] := QRY->B1_RECNO
	oGdItm01:aCols[nLin, Len(oGdItm01:aHeader)+1] := .F.

	QRY->(DbSkip())
End

//Carrega aCols com uma linha vazia por nใo teve resultado na query
QRY->(DbGoTop())
If QRY->(Eof())
	//Cria uma linha no aCols
	aAdd(oGdItm01:aCols,Array(Len(oGdItm01:aHeader)+1))
	nLin := Len(oGdItm01:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm01:aCols[nLin, nPosFlag] := "LBNO"
	oGdItm01:aCols[nLin, nPosCod ] := ""
	oGdItm01:aCols[nLin, nPosDesc] := ""
	oGdItm01:aCols[nLin, nPosRecn] := 0
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

Local nPosFlag := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosCod  := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="XX_CODIGO"})
Local nPosDesc := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="XX_DESCRI"})
Local nPosRecn := aScan(oGdItm02:aHeader,{|x|AllTrim(x[2])=="XX_RECNO"})

Local nConta   := 0

//Carrega aCols com base no resultado da query
QRY->(DbGoTop())
While QRY->(!Eof())
	//Contador para item
	nConta ++
	
	//Cria uma linha no aCols
	aAdd(oGdItm02:aCols,Array(Len(oGdItm02:aHeader)+1))
	nLin := Len(oGdItm02:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm02:aCols[nLin, nPosFlag] := "LBNO"
	oGdItm02:aCols[nLin, nPosCod ] := QRY->B1_COD
	oGdItm02:aCols[nLin, nPosDesc] := QRY->B1_DESC
	oGdItm02:aCols[nLin, nPosRecn] := QRY->B1_RECNO
	oGdItm02:aCols[nLin, Len(oGdItm02:aHeader)+1] := .F.

	QRY->(DbSkip())
End

//Carrega aCols com uma linha vazia por nใo teve resultado na query
QRY->(DbGoTop())
If QRY->(Eof())
	//Cria uma linha no aCols
	aAdd(oGdItm02:aCols,Array(Len(oGdItm02:aHeader)+1))
	nLin := Len(oGdItm02:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm02:aCols[nLin, nPosFlag] := "LBNO"
	oGdItm02:aCols[nLin, nPosCod ] := ""
	oGdItm02:aCols[nLin, nPosDesc] := ""
	oGdItm02:aCols[nLin, nPosRecn] := 0
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

Local nPosFlag := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosCod  := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="XX_CODIGO"})
Local nPosDesc := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="XX_DESCRI"})
Local nPosRecn := aScan(oGdItm03:aHeader,{|x|AllTrim(x[2])=="XX_RECNO"})

Local nConta   := 0

//Carrega aCols com base no resultado da query
QRY->(DbGoTop())
While QRY->(!Eof())
	//Contador para item
	nConta ++
	
	//Cria uma linha no aCols
	aAdd(oGdItm03:aCols,Array(Len(oGdItm03:aHeader)+1))
	nLin := Len(oGdItm03:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm03:aCols[nLin, nPosFlag] := "LBNO"
	oGdItm03:aCols[nLin, nPosCod ] := QRY->B1_COD
	oGdItm03:aCols[nLin, nPosDesc] := QRY->B1_DESC
	oGdItm03:aCols[nLin, nPosRecn] := QRY->B1_RECNO
	oGdItm03:aCols[nLin, Len(oGdItm03:aHeader)+1] := .F.

	QRY->(DbSkip())
End

//Carrega aCols com uma linha vazia por nใo teve resultado na query
QRY->(DbGoTop())
If QRY->(Eof())
	//Cria uma linha no aCols
	aAdd(oGdItm03:aCols,Array(Len(oGdItm03:aHeader)+1))
	nLin := Len(oGdItm03:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm03:aCols[nLin, nPosFlag] := "LBNO"
	oGdItm03:aCols[nLin, nPosCod ] := ""
	oGdItm03:aCols[nLin, nPosDesc] := ""
	oGdItm03:aCols[nLin, nPosRecn] := 0
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

//          X3_TITULO    , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
aAdd(aHead,{""           ,"XX_FLAG"      ,"@BMP"               ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Cod. Prod"  ,"XX_CODIGO"    ,"@!"                 ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Desc. Prod" ,"XX_DESCRI"    ,"@!"                 ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Recno SB1"  ,"XX_RECNO"     ,"@E 9999999999"      ,          10,          0, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
aAdd(aCols,Array(Len(aHead)+1))
nLin := Len(aCols)

//Alimenta a linha do aCols vazia
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_FLAG"})   ] := "LBNO"
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_CODIGO"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_DESCRI"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_RECNO"})  ] := 0
aCols[nLin, Len(aHead)+1]                                  := .F.

oGdItm01:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
oGdItm01:oBrowse:bLDblClick := {|| fDblClick(@oGdItm01) }

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

//          X3_TITULO    , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
aAdd(aHead,{""           ,"XX_FLAG"      ,"@BMP"               ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Cod. Prod"  ,"XX_CODIGO"    ,"@!"                 ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Desc. Prod" ,"XX_DESCRI"    ,"@!"                 ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Recno SB1"  ,"XX_RECNO"     ,"@E 9999999999"      ,          10,          0, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
aAdd(aCols,Array(Len(aHead)+1))
nLin := Len(aCols)

//Alimenta a linha do aCols vazia
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_FLAG"})   ] := "LBNO"
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_CODIGO"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_DESCRI"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_RECNO"})  ] := 0
aCols[nLin, Len(aHead)+1]                                  := .F.

oGdItm02:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
oGdItm02:oBrowse:bLDblClick := {|| fDblClick(@oGdItm02) }

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

//          X3_TITULO    , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
aAdd(aHead,{""           ,"XX_FLAG"      ,"@BMP"               ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Cod. Prod"  ,"XX_CODIGO"    ,"@!"                 ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Desc. Prod" ,"XX_DESCRI"    ,"@!"                 ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Recno SB1"  ,"XX_RECNO"     ,"@E 9999999999"      ,          10,          0, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
aAdd(aCols,Array(Len(aHead)+1))
nLin := Len(aCols)

//Alimenta a linha do aCols vazia
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_FLAG"})   ] := "LBNO"
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_CODIGO"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_DESCRI"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_RECNO"})  ] := 0
aCols[nLin, Len(aHead)+1]                                  := .F.

oGdItm03:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
oGdItm03:oBrowse:bLDblClick := {|| fDblClick(@oGdItm03) }

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDblClickบAutor  ณ Felipe A. Melo     บ Data ณ  11/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDblClick(oGetDad)

Local x        := 1
Local cVarTmp  := ""
Local nLinhaOK := oGetDad:oBrowse:nAt
Local nPosFlag := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })
Local nPosCod  := aScan(oGetDad:aHeader,{|x|AllTrim(x[2])=="XX_CODIGO"})

//Trata quando nใo teve resultado
If Empty(oGetDad:aCols[nLinhaOK][nPosCod])
	Alert("Este item nใo pode ser marcado, pois nada consta nele!")
	Return
EndIf

//Desmarca todos
For x:=1 To Len(oGetDad:aCols)
	oGetDad:aCols[x][nPosFlag] := "LBNO"
Next x

oGetDad:aCols[nLinhaOK][nPosFlag] := "LBTIK"

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
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Bot๕es
@ aBtn01[1],aBtn01[2] Button "Confirmar"  Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fAtuliza(oDialg)
@ aBtn02[1],aBtn02[2] Button "Sair" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fSair(oDialg)

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

oDialg:End()

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