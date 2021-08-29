//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variแveis Estแticas
Static cTitulo := "Tabelas Gen้ricas"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMFAT06  บAutor  ณMarco Aurelio       บ Data ณ  06/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ TES Inteligente - DOMEX - ENTRADA                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#Include "Protheus.ch"
#include "RWMAKE.CH"


User Function DOMFAT06()

Private cCadastro := "Tes Inteligente de ENTRADA"
Private cAlias := "ZFN" 
Private aRotina := { }

Private aHeader    := {} 
Private aCols      := {}
Private aAlterados := {} 
Private aDeletados := {}
Private nUsado     := 0 
Private _y         := 1
Private _nQtaCols  := 0
Private _cEOL      := CHR(13)+CHR(10)

AADD (aRotina, {"Pesquisar" 	,	"AxPesqui",0,1})
AADD (aRotina, {"Visualizar" 	,	"U_CADZFNA(5)",0,2})
AADD (aRotina, {"Incluir" 		,	"U_CADZFNA(3)",0,3})
AADD (aRotina, {"Alterar" 		,	"U_CADZFNA(4)",0,4})
AADD (aRotina, {"Excluir" 		,	"U_CADZFNA(5)",0,5})

dbSelectArea("ZFN")
dbSetOrder(1)
mBrowse ( 6, 1,22 ,75 ,cAlias)

Return
    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADZFNA   บAutor  ณMicrosiga           บ Data ณ  09/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADZFNA(xOpcao)

Local _nMax := 99

If xOpcao != 0
	
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("ZFN")
	
	nUsado  := 0
	aHeader := {}
	
	While !Eof() .And. SX3->X3_ARQUIVO == "ZFN"

		If Alltrim(SX3->X3_CAMPO) $("ZFN_TIPO,ZFN_FORNECE,ZFN_LOJA,ZFN_NATURE")
			SX3->(DbSkip())
			Loop
		Endif
					
		nUsado += 1
			
		AAdd( aHeader , { AllTrim(X3_TITULO) , X3_CAMPO   , X3_PICTURE , ;
							  X3_TAMANHO         , X3_DECIMAL , X3_VALID   , ;
							  X3_USADO           , X3_TIPO    , X3_ARQUIVO , ;
							  X3_CONTEXT } )     
		
		SX3->(DbSkip())

	Enddo
	
//	_nPosItem := aScan(aHeader,{|x| Alltrim(x[2]) == "ZC_ITEM"    })
	_nPosProd := aScan(aHeader,{|x| Alltrim(x[2]) == "ZFN_CODPRO" })
	_nPosTES  := aScan(aHeader,{|x| Alltrim(x[2]) == "ZFN_TES1" })   
//	_nPosNat  := aScan(aHeader,{|x| Alltrim(x[2]) == "ZFN_NATURE" })
	_nPosDel  := Len(aHeader) + 1

	// INCLUSAO	
	If xOpcao == 3

		_cRequisi:= Space(06)
		aCols := Array(1,nUsado+1)
		
		DbSelectArea("SX3")
		DbSetOrder(1)
		DbSeek("ZFN")
		
		nUsado := 0
		
		While !Eof() .And. SX3->X3_ARQUIVO == "ZFN"

			If Alltrim(SX3->X3_CAMPO) $("ZFN_TIPO,ZFN_FORNECE,ZFN_LOJA,ZFN_NATURE") 
				SX3->(DbSkip())
				Loop
			Endif
		
			nUsado += 1
			
			If SX3->X3_TIPO == "C"
				aCols[1,nUsado] := Space(X3_TAMANHO)
			ElseIf SX3->X3_TIPO == "N"
				aCols[1,nUsado] := 0
			ElseIf SX3->X3_TIPO == "D"
				aCols[1,nUsado] := CtoD("  /  /  ")
			ElseIf SX3->X3_TIPO == "M"
				aCols[1,nUsado] := ""
			Else
				aCols[1,nUsado] := .F.
			Endif

			SX3->(DbSkip())

		Enddo

		aCols[1,nUsado+1] := .F.

	Else

		aCols      := {}
	
		cTipo			:= ZFN->ZFN_TIPO
		cCodPro		:= ZFN->ZFN_CODPRO
		cFornec		:= ZFN->ZFN_FORNEC
		cLojafo		:= ZFN->ZFN_LOJAFO

		DbSelectArea("ZFN") // ZFN_FILIAL+ZFN_CODPRO+ZFN_FORNEC+ZFN_LOJAFO+ZFN_TIPO
		DbSetOrder(1)
		DbSeek( xFilial("ZFN") + cCodPro + cFornec + cLojafo + cTipo )
		While !Eof() .And. ZFN->(ZFN_FILIAL+ZFN_CODPRO+ZFN_FORNEC+ZFN_LOJAFO+ZFN_TIPO) == xFilial("ZFN") + cCodPro + cFornec + cLojafo + cTipo
				
			AAdd(aCols,{"",0,0,""})
				
			_nQtaCols := Len(aCols)
			aCols[_nQtaCols,_nPosProd] := ZFN->ZFN_CODPRO
			aCols[_nQtaCols,_nPosTES]  := ZFN->ZFN_TES1
  //			aCols[_nQtaCols,_nPosNat]  := ZFN->ZFN_NATURE
			aCols[_nQtaCols,_nPosDel ] := .F.

			AAdd(aAlterados,{ZFN->ZFN_CODPRO,ZFN->ZFN_TES1})				// ESTAVA O CAMPO DE ITEM
				
			ZFN->(DbSkip())
		Enddo

	Endif
	
	aCabec   := {}
	aRodape  := {}
	aCGD     := {060,007,128,345}
	aTela    := {130,003,395,700}
	cTitulo  := "Tes Inteligente - ENTRADA"
	lDigitar := IIf(xOpcao == 5 ,.F.,.T.)
	cLinhaOk := "VLDLin(_nPosDifP,_nPosComs,_nPosDel)"
	cTudoOk  := "AllwaysTrue()"    
	
	
	_cTipo	:= space(02)
	_cForne	:= space(06)
	_cLoja	:= space(02)
	_cNatur	:= space(10)
/*
	_cValid1 := "NaoVazio() .And. ExistChav('SZC',_cCodigo,1)"
	_cValid2 := ""
	_cValid3 := "NaoVazio()"
	
  	AAdd( aCabec,{ "_cCodigo" , {15,010} , "Codigo          " , "@!"        , _cValid1 , , Iif(xOpcao$"A",.F.,lDigitar) } )
  	AAdd( aCabec,{ "_cDescr"  , {30,010} , "Descricao     "   , "@!"        , _cValid2 , , lDigitar } )
  	AAdd( aCabec,{ "_nComiss" , {45,010} , "% Comissao "      , "@E 999.99" , _cValid3 , , lDigitar } )
*/
	_cValid1 := "NaoVazio() " //.And. ExistChav('SZ7',_cCardap,1)"
	_cValid2 := ""
	_cValid3 := "NaoVazio() .And. ExistChav('SED',_cNatur,1)"
	
  	AAdd( aCabec,{ "_cTipo"  , {15,010} , "Opera็ใo      " , "@!"        , _cValid1 , , Iif(xOpcao == 4,.F.,lDigitar) } )
	AAdd( aCabec,{ "_cForne" , {15,070} , "Fornecedor    " , "@!"        , _cValid2 , , Iif(xOpcao == 4,.F.,lDigitar) } )
	AAdd( aCabec,{ "_cLoja"  , {15,140} , "Loja          " , "@!"        , _cValid2 , , Iif(xOpcao == 4,.F.,lDigitar) } )
	AAdd( aCabec,{ "_cNatur" , {15,250} , "Natureza      " , "@!"        , _cValid3 , , Iif(xOpcao == 4,.F.,lDigitar) } )
	  	
	_lRetorno := MODELO2(cTitulo,aCabec,aRodaPe,aCGD,xOpcao,cLinhaOk,cTudoOk,,,,_nMax,aTela)

	If _lRetorno
		If xOpcao == 3
			_Inclusao()
		ElseIf xOpcao == 4
			_Alteracao()
		ElseIf xOpcao == 5
			_Exclusao()
		Endif
	Endif

Endif

Return



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa a inclusao de registrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function _Inclusao()

Local _aArea := GetArea()

For _x:= 1 to Len(aCols)

	If aCols[_x,_nPosDel]
		Loop
	Endif
	
	RecLock("ZFN",.T.)

	ZFN->ZFN_FILIAL	:= xFilial("ZFN")
	ZFN->ZFN_FORNEC   := cFornec 
	ZFN->ZFN_LOJAFO   := cLojafo 
	ZFN->ZFN_TIPO     := cTipo 
	ZFN->ZFN_CODPRO   := aCols[_x,_nPosProd]  
 	ZFN->ZFN_TES1     := aCols[_x,_nPosTES]

	MsUnLock()

Next _x

RestArea(_aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Alteracao บAutor  ณMicrosiga          บ Data ณ  08/07/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Processa a alteracao de registros                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Alteracao()

Local _aArea := GetArea()

For _x:= 1 to Len(aAlterados)

	DbSelectArea("ZFN")
	DbSetOrder(1)
	If DbSeek( xFilial("ZFN")  + aAlterados[_x,_nPosProd] + cFornec + cLojafo + cTipo )
		RecLock("ZFN",.F.)
			ZFN->ZFN_CODPRO  := aCols[_x,_nPosProd]		
		MsUnLock()
	Endif

Next _x 

For _x:= 1 to Len(aCols)

	If aCols[_x,_nPosDel]
		AAdd(aDeletados,aCols[_x,_nPosProd]+cFornec + cLojafo + cTipo)
		Loop
	Endif
	
	DbSelectArea("ZFN")
	DbSetOrder(1)
	If !DbSeek( xFilial("ZFN") + cCodPro + cFornec + cLojafo + cTipo )
		RecLock("ZFN",.T.)    
		
		ZFN->ZFN_FILIAL	:= xFilial("ZFN")
		ZFN->ZFN_FORNEC   := cFornec 
		ZFN->ZFN_LOJAFO   := cLojafo 
		ZFN->ZFN_TIPO     := cTipo 
		ZFN->ZFN_CODPRO   := aCols[_x,_nPosProd]  
	 	ZFN->ZFN_TES1     := aCols[_x,_nPosTES]		

		MsUnLock()
	EndIf

Next _x

For _x:= 1 to Len(aDeletados)

	DbSelectArea("ZFN")
	DbSetorder(1)
	If DbSeek( xFilial("ZFN") + aDeletados[_x] )
		RecLock("ZFN",.F.)
        DbDelete()
		MsUnLock()
	Endif

Next _x

RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_Exclusao  บAutor  ณMicrosiga          บ Data ณ  08/07/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Processa a exclusao de registros                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Exclusao()

For _x:= 1 to Len(aCols)

	DbSelectArea("ZFN")
	DbSetOrder(1)
	If DbSeek( xFilial("ZFN") +cCodPro + cFornec + cLojafo + cTipo )
		RecLock("ZFN",.F.)
		DbDelete()
		MsUnLock()
	Endif

Next _x

Return



Static Function VLDLin(xPosDel)

xPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == "ZFN_CODPRO"})   //ZC_ITEM
For w:= 1 to Len(aCols)
	_nItem := Val(aCols[w,xPosProd])
Next w

_y := _nItem + 1

Return(.T.)