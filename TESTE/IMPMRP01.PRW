//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Mauricio Lima de Souza - 09/06/14 - OpusVp                                                                                                       //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Leitura tabelas Ctree Mrp SHA SH5  / Gera็ใo das tabelas SHA010 E SH5010 EM SQL
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#INCLUDE "TBICONN.CH"   
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"
#DEFINE _CRLF CHR(13)+CHR(10)
#DEFINE _NEWLINE chr(13)+chr(13)

USER FUNCTION IMPMRP01()

LOCAL cDrvSHA   := ""

PRIVATE lContinua :=.F.
PRIVATE nX        :=0
PRIVATE nY        :=0
PRIVATE _nPERIODO :=0

#IFDEF WNTX
	cDrvSHA := "DBFNTX"
#ENDIF
#IFDEF WCDX
	cDrvSHA := "DBFCDX"
#ENDIF
#IFDEF WAXS
	cDrvSHA := "DBFCDXAX"
#ENDIF

lContinua := OpenMRP2(.T.)

dDATA1 :=LASTDAY(date())   // ULTIMO DIA MES CORRENTE
dDATA2 :=dDATA1+1             // PRIMEIRO DIA PROXIMO MES
dDATA3 :=LASTDAY(dDATA2)      // ULTIMO DIA PROXIMO MES      
nDIAS  :=dDATA3-date()     // QUANTIDADE DE PERIODOS

nNumPeriodos :=nDIAS+1
_nPERIODO    :=nDIAS+1

_nPERIODO    := 90  //mls newmrp

If lContinua
	dbSelectArea("SHA")
	//	dbSetOrder(2)
	dbGoTop()
	
	cQUERY1:=" DELETE FROM SHA010  "
	TCSQLEXEC(cQUERY1)
	nX:=0
	nY:=0
	DO While !Eof()
		nY++
		cQUERY1:=" INSERT INTO SHA010 "
		cQUERY1+=" ( "
		FOR nX:=1 TO _nPERIODO
			cQUERY1+=" HA_PER"+alltrim(strzero(nX,3))+", "
		NEXT
		cQUERY1+=" HA_FILIAL,HA_NUMMRP,HA_NIVEL,HA_PRODUTO,HA_PRODSHW,HA_OPC,HA_REVISAO,HA_REVSHW,HA_TIPO,HA_TEXTO    , "
		cQUERY1+=" R_E_C_N_O,R_E_C_N_O_  ) "
		cQUERY1+=" VALUES "
		cQUERY1+=" ( "
		FOR nX:=1 TO _nPERIODO
			cQUERY1+=" '"+ALLTRIM(STR(&('SHA->HA_PER'+alltrim(strzero(nX,3)))))+"', "
		NEXT
		cQUERY1+=" '"+SHA->HA_FILIAL+"','"+SHA->HA_NUMMRP+"','"+SHA->HA_NIVEL +"','"+SHA->HA_PRODUTO+"','"+SHA->HA_PRODSHW+"','"+SHA->HA_OPC   +"','"+SHA->HA_REVISAO+"','"+SHA->HA_REVSHW+"','"+SHA->HA_TIPO  +"','"+SHA->HA_TEXTO +"','"+STR(nY)+"','"+STR(nY)+"' "
		cQUERY1+=" ) "
		TCSQLEXEC(cQUERY1)
		/*
		cQUERY1:=" INSERT INTO SHA010 "
		cQUERY1+=" ( "
		cQUERY1+=" HA_PER001,HA_PER002,HA_PER003,HA_PER004,HA_PER005,HA_PER006,HA_PER007,HA_PER008,HA_PER009,HA_PER010, "
		cQUERY1+=" HA_PER011,HA_PER012,HA_PER013,HA_PER014,HA_PER015,HA_PER016,HA_PER017,HA_PER018,HA_PER019,HA_PER020, "
		cQUERY1+=" HA_PER021,HA_PER022,HA_PER023,HA_PER024,HA_PER025,HA_PER026,HA_PER027,HA_PER028,HA_PER029,HA_PER030, "
		
		cQUERY1+=" HA_PER031,HA_PER032,HA_PER033,HA_PER034,HA_PER035,HA_PER036,HA_PER037,HA_PER038,HA_PER039,HA_PER040, "
		cQUERY1+=" HA_PER041,HA_PER042,HA_PER043,HA_PER044,HA_PER045,HA_PER046,HA_PER047,HA_PER048,HA_PER049,HA_PER050, "
		cQUERY1+=" HA_PER051,HA_PER052,HA_PER053,HA_PER054,HA_PER055,HA_PER056,HA_PER057,HA_PER058,HA_PER059,HA_PER060, "
		
		cQUERY1+=" HA_FILIAL,HA_NUMMRP,HA_NIVEL,HA_PRODUTO,HA_PRODSHW,HA_OPC,HA_REVISAO,HA_REVSHW,HA_TIPO,HA_TEXTO    , "
		cQUERY1+=" R_E_C_N_O,R_E_C_N_O_  ) "
		cQUERY1+=" VALUES "
		cQUERY1+=" ( "
		cQUERY1+=" '"+STR(SHA->HA_PER001)+"','"+STR(SHA->HA_PER002)+"','"+STR(SHA->HA_PER003)+"','"+STR(SHA->HA_PER004) +"','"+STR(SHA->HA_PER005) +"','"+STR(SHA->HA_PER006)+"','"+STR(SHA->HA_PER007) +"','"+STR(SHA->HA_PER008)+"','"+STR(SHA->HA_PER009)+"','"+STR(SHA->HA_PER010)+"',"
		cQUERY1+=" '"+STR(SHA->HA_PER011)+"','"+STR(SHA->HA_PER012)+"','"+STR(SHA->HA_PER013)+"','"+STR(SHA->HA_PER014) +"','"+STR(SHA->HA_PER015) +"','"+STR(SHA->HA_PER016)+"','"+STR(SHA->HA_PER017) +"','"+STR(SHA->HA_PER018)+"','"+STR(SHA->HA_PER019)+"','"+STR(SHA->HA_PER020)+"',"
		cQUERY1+=" '"+STR(SHA->HA_PER021)+"','"+STR(SHA->HA_PER022)+"','"+STR(SHA->HA_PER023)+"','"+STR(SHA->HA_PER024) +"','"+STR(SHA->HA_PER025) +"','"+STR(SHA->HA_PER026)+"','"+STR(SHA->HA_PER027) +"','"+STR(SHA->HA_PER028)+"','"+STR(SHA->HA_PER029)+"','"+STR(SHA->HA_PER030)+"',"
		
		cQUERY1+=" '"+STR(SHA->HA_PER031)+"','"+STR(SHA->HA_PER032)+"','"+STR(SHA->HA_PER033)+"','"+STR(SHA->HA_PER034) +"','"+STR(SHA->HA_PER035) +"','"+STR(SHA->HA_PER036)+"','"+STR(SHA->HA_PER037) +"','"+STR(SHA->HA_PER038)+"','"+STR(SHA->HA_PER039)+"','"+STR(SHA->HA_PER040)+"',"
		cQUERY1+=" '"+STR(SHA->HA_PER041)+"','"+STR(SHA->HA_PER042)+"','"+STR(SHA->HA_PER043)+"','"+STR(SHA->HA_PER044) +"','"+STR(SHA->HA_PER045) +"','"+STR(SHA->HA_PER046)+"','"+STR(SHA->HA_PER047) +"','"+STR(SHA->HA_PER048)+"','"+STR(SHA->HA_PER049)+"','"+STR(SHA->HA_PER050)+"',"
		cQUERY1+=" '"+STR(SHA->HA_PER051)+"','"+STR(SHA->HA_PER052)+"','"+STR(SHA->HA_PER053)+"','"+STR(SHA->HA_PER054) +"','"+STR(SHA->HA_PER055) +"','"+STR(SHA->HA_PER056)+"','"+STR(SHA->HA_PER057) +"','"+STR(SHA->HA_PER058)+"','"+STR(SHA->HA_PER059)+"','"+STR(SHA->HA_PER060)+"',"
		
		cQUERY1+=" '"+SHA->HA_FILIAL+"','"+SHA->HA_NUMMRP+"','"+SHA->HA_NIVEL +"','"+SHA->HA_PRODUTO+"','"+SHA->HA_PRODSHW+"','"+SHA->HA_OPC   +"','"+SHA->HA_REVISAO+"','"+SHA->HA_REVSHW+"','"+SHA->HA_TIPO  +"','"+SHA->HA_TEXTO +"','"+STR(nX)+"','"+STR(nX)+"' "
		cQUERY1+=" ) "
		*/
		DBSKIP()
	ENDDO
	
	If Select("SHA") > 0
		SHA->( DbCloseArea() )
	EndIf
	
	dbSelectArea("SH5")
	//	dbSetOrder(1)
	dbGoTop()
	cQUERY1:=" DELETE FROM SH5010  "
  	TCSQLEXEC(cQUERY1)
	nX:=0
	DO While !Eof()
		nX++
		
		cQUERY1:=" INSERT INTO SH5010 "
		cQUERY1+=" ( "
		cQUERY1+="    H5_DATAORI,H5_PER  ,H5_NUMMRP,H5_NIVEL  ,H5_PRODUTO,H5_OPC   , "
		cQUERY1+="    H5_REVISAO,H5_ALIAS,H5_RECNO ,H5_TIPO   ,H5_DOC    ,H5_DOCKEY, "
		cQUERY1+="    H5_DOCREV ,H5_ITEM ,H5_QUANT ,H5_PRODORI,R_E_C_N_O_,R_E_C_N_O  "
		cQUERY1+=" )  "
		cQUERY1+=" VALUES  "
		cQUERY1+=" (  "
		cSH5DTORI:=DTOS(SH5->H5_DATAORI)
		cQUERY1+="    '"+cSH5DTORI      +"','"+SH5->H5_PER  +"','"+SH5->H5_NUMMRP    +"','"+SH5->H5_NIVEL  +"','"+SH5->H5_PRODUTO+"','"+SH5->H5_OPC   +"', "
		cQUERY1+="    '"+SH5->H5_REVISAO+"','"+SH5->H5_ALIAS+"','"+STR(SH5->H5_RECNO)+"','"+SH5->H5_TIPO   +"','"+SH5->H5_DOC    +"','"+SH5->H5_DOCKEY+"', "
		cQUERY1+="    '"+SH5->H5_DOCREV +"','"+SH5->H5_ITEM +"','"+STR(SH5->H5_QUANT)+"','"+SH5->H5_PRODORI+"','"+STR(nX)        +"','"+STR(nX)       +"' "
		cQUERY1+=" )  "
		TCSQLEXEC(cQUERY1)
		DBSKIP()
	ENDDO
	If Select("SH5") > 0
		SH5->( DbCloseArea() )
	EndIf
	
ENDIF

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOpenMRP2บAutor  ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel pela criacao e abertura dos arquivos de    บฑฑ
ฑฑบ          ณtrabalho do MRP (SH5 e SHA). A RDD obrigatoriamente eh em     บฑฑ
ฑฑบ          ณCTREE, devido o tamanho dos campos da chave de indice.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ ExpL1 : Indica se o MRP sera executado em modo visualizacao  บฑฑ
ฑฑบ          ณ ExpA1 : Array com estrutura da tabela SH5                    บฑฑ
ฑฑบ          ณ ExpA2 : Array com estrutura da tabela SHA                    บฑฑ
ฑฑบ          ณ ExpL2 : Indica se esta processando atraves de JOB            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ A estrutura de abertura de arquivos e checagem de indices foiบฑฑ
ฑฑบ          ณ desenvolvida conforme orientacao da tecnologia (devedo as    บฑฑ
ฑฑบ          ณ particularidades da RDD CTREECDX).                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MATA710                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC Function OpenMRP2(lVisualiza,aStruSH5,aStruSHA,lInJob)
Local lRet 		:= .T.
Local cDrive 	:= "CTREECDX"
Local cExt		:= ".cdx"
Local cPath		:= ""
Local cArqSH5	:= ""
Local cArqSHA	:= ""
Local cNameIdx	:= ""
Local aTam		:= {}
LOCAL aTamQuant	:= TamSX3("B2_QFIM")
LOCAL aArea     := GetArea()
Local nI
Local nTamItem	:= 0,aCamposIt:={"C1_ITEM","C2_ITEM","C3_ITEM","C6_ITEM","C7_ITEM"}
Local aCpsUsu 	:= {}

DEFAULT lInJob   	:= .F.
DEFAULT lVisualiza	:= .t.
DEFAULT aStruSH5	:= {}
DEFAULT aStruSHA	:= {}

lVisualiza:=.T.


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria semaforo para controle de exclusividade da operacao     ณ
//ณ Somente na chamada em job nao testa essa exclusividade       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lInJob .Or. (!lInJob .And. LockByName("SH5USO"+cEmpAnt,.T.,.F.,.T.))
	
	//-- Para manter legado o path dos arquivos SH5 e SHA sempre sera o mesmo do definido
	//-- na primeira ocorrencia da familia SH. E podera retornar vazio em ambientes Top,
	//-- por este nao preencher o X2_PATH.
	dbSelectArea("SX2")
	dbSeek("SH")
	cPath:=AllTrim(X2_PATH)
	cPath:=cPath+'01\'
	
	//-- Define o nome do arquivo SH5
	cArqSH5 := REtArq(cDrive,cPath+"SH5"+Substr(cNumEmp,1,2)+"0",.t.)
	//cArqSH5 :='\DATA\01\SH5010.DTC'
	
	//-- Define o nome do arquivo SHA
	cArqSHA := REtArq(cDrive,cPath+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)
	//cArqSHA := '\DATA\01\SHA010.DTC'
	
	If lRet
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta arquivos do MRP                                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lVisualiza
			
			//-- Verifica se o SH5 esta aberto
			If Select("SH5") > 0
				SH5->( DbCloseArea() )
			EndIf
			
			//-- Apago o SH5 (Tabela e Indice) para que seja criada nova estrutura
			FErase(cArqSH5)
			FErase(FileNoExt(cArqSH5)+cExt)
			
			//-- Verifica se o SHA esta aberto
			If Select("SHA") > 0
				SH5->( DbCloseArea() )
			EndIf
			
			//-- Apago o SHA (Tabela e Indice) para que seja criada nova estrutura
			FErase(cArqSHA)
			FErase(FileNoExt(cArqSHA)+cExt)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ NUMERO DO MRP                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			c711NumMRP:=GetMV("MV_NEXTMRP")
			PutMV("MV_NEXTMRP",Soma1(Substr(c711NumMRP,1,Len(SC2->C2_SEQMRP))))
			// Arquivo de trabalho do MRP
			//H5_DATAORI - DATA ORIGINAL
			AADD(aStruSH5 ,{"H5_DATAORI","D",08,0})
			//H5_PER - PERIODO
			AADD(aStruSH5 ,{"H5_PER","C",03,0})
			//H5_NUMMRP - NUMERO DA PROGRAMACAO
			AADD(aStruSH5 ,{"H5_NUMMRP"  ,"C",Len(SC2->C2_SEQMRP),0})
			AADD(aStruSHA,{"HA_NUMMRP"  ,"C",Len(SC2->C2_SEQMRP),0})
			//H5_NIVEL   - NIVEL
			AADD(aStruSH5 ,{"H5_NIVEL"  ,"C",02,0})
			AADD(aStruSHA,{"HA_NIVEL"  ,"C",02,0})
			//H5_PRODUTO - PRODUTO
			AADD(aStruSH5 ,{"H5_PRODUTO","C",TamSX3("B1_COD")[1],0})
			AADD(aStruSHA,{"HA_PRODUTO","C",TamSX3("B1_COD")[1],0})
			AADD(aStruSHA,{"HA_PRODSHW","C",TamSX3("B1_COD")[1],0})
			//H5_OPC     - OPCIONAL
			aTam:=TAMSX3("C2_OPC")
			AADD(aStruSH5 ,{"H5_OPC"    ,"C",aTam[1],0})
			AADD(aStruSH5 ,{"H5_OPCORI" ,"C",aTam[1],0})
			AADD(aStruSHA,{"HA_OPC"    ,"C",aTam[1],0})
			AADD(aStruSHA,{"HA_OPCSHW" ,"C",aTam[1],0})
			//H5_ALIAS   - ALIAS DO MOVIMENTO
			//           SC1
			//           SC7
			//           SC2
			//           SHC
			//           SD4
			//           SC6
			//           SC4
			//           AFJ
			aTam:=TamSX3("B1_REVATU")
			AADD(aStruSH5 ,{"H5_REVISAO","C",aTam[1],0})
			AADD(aStruSHA,{"HA_REVISAO","C",aTam[1],0})
			AADD(aStruSHA,{"HA_REVSHW" ,"C",aTam[1],0})
			AADD(aStruSH5 ,{"H5_ALIAS"   ,"C",03,0})
			//H5_RECNO   - REGISTRO
			AADD(aStruSH5 ,{"H5_RECNO"   ,"N",14,0})
			// H5_TIPO - TIPO DO DOCUMENTO
			// 2 - ENTRADA
			// 3 - SAIDA
			// 4 - SAIDA RELACIONADA A ESTRUTURA
			AADD(aStruSH5 ,{"H5_TIPO"    ,"C",01,0})
			AADD(aStruSHA,{"HA_TIPO"    ,"C",01,0})
			AADD(aStruSHA,{"HA_TEXTO"   ,"C",16,0})
			//H5_DOC     - DOCUMENTO
			AADD(aStruSH5 ,{"H5_DOC"     ,"C",15,0})
			//H5_DOCKEY  - DOCUMENTO DE LIGACAO
			AADD(aStruSH5 ,{"H5_DOCKEY"  ,"C",13,0})
			AADD(aStruSH5 ,{"H5_DOCREV"  ,"C",Len(SC2->C2_REVISAO),0})
			//H5_ITEM    - ITEM
			// Pesquisa o tamanho dos campos de item
			For nI:=1 to Len(aCamposIt)
				nTamItem:=Max(nTamItem,TamSX3(aCamposIt[nI])[1])
			Next nI
			AADD(aStruSH5 ,{"H5_ITEM"    ,"C",nTamItem,0})
			//H5_QUANT   - QUANTIDADE
			AADD(aStruSH5,{"H5_QUANT","N",aTamQuant[1]+2,aTamQuant[2]})
			
			//-- Cria Tabela SH5 -----------------------------------------------------------
			DbCreate(cArqSH5,aStruSH5,cDrive)
			dbUseArea( .T.,cDrive, cArqSH5, "SH5", .T., .F. )
			
			cNameIdx := FileNoExt(cArqSH5)
			
			//INDEX ON H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER 			TAG &(cNameIdx+"1") TO &(cNameIdx)
			//INDEX ON H5_ALIAS+H5_NIVEL+H5_PRODUTO+H5_OPC+H5_REVISAO	TAG &(cNameIdx+"2") TO &(cNameIdx)
			//INDEX ON H5_PRODUTO+H5_ALIAS+DTOS(H5_DATAORI) 			TAG &(cNameIdx+"3") TO &(cNameIdx)
			
			//dbClearIndex()
			//dbSetIndex( cNameIdx+cExt )
			
			//-- Cria Tabela SHA ------------------------------------------------------------
			DbCreate(cArqSHA,aStruSHA,cDrive)
			dbUseArea( .T.,cDrive, cArqSHA, "SHA", .T. , .F. )
			
			cNameIdx := FileNoExt(cArqSHA)
			
			//INDEX ON HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO 			TAG &(cNameIdx+"1") TO &(cNameIdx)
			//INDEX ON HA_NIVEL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO	TAG &(cNameIdx+"2") TO &(cNameIdx)
			
			//dbClearIndex()
			//dbSetIndex( cNameIdx+cExt )
		Else
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณNa rotina de abertura, se alguem apagou o indice do disco,       ณ
			//ณqdo abrimos  a tabela, o ctree vai fazer rebuild destes indices, ณ
			//ณporem se a tabela foi renomeada, ou criada em um diretorio e     ณ
			//ณcopiada para outro, ele nao faz o rebuild.                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			//-- Abre o arquivo SH5
			If MSFile(cArqSH5,,cDrive)
				dbUseArea( .T. ,cDrive,cArqSH5, "SH5", .T. , .F. )
				
				cNameIdx := FileNoExt(cArqSH5)
				
				//-- Checa a existencia do indice permanente para tabela SH5, e cria se nao existir
				//	If !File(cNameIdx+cExt)
				//					INDEX ON H5_PRODUTO+H5_OPC+H5_REVISAO+H5_PER 			TAG &(cNameIdx+"1") TO &(cNameIdx)
				//					INDEX ON H5_ALIAS+H5_NIVEL+H5_PRODUTO+H5_OPC+H5_REVISAO	TAG &(cNameIdx+"2") TO &(cNameIdx)
				//					INDEX ON H5_PRODUTO+H5_ALIAS+DTOS(H5_DATAORI) 			TAG &(cNameIdx+"3") TO &(cNameIdx)
				//	EndIf
				
				//				dbClearIndex()
				//				dbSetIndex( cNameIdx+cExt )
				
				
				//-- Abre tabelas em modo compartilhado
				If MSFile(cArqSHA,,cDrive)
					dbUseArea( .T.,cDrive, cArqSHA, "SHA", .T., .F. )
					
					cNameIdx := FileNoExt(cArqSHA)
					
					//-- Checa a existencia do indice permanente para tabela SHA, e cria se nao existir
					//If !File(cNameIdx+cExt)
					//						INDEX ON HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO 			TAG &(cNameIdx+"1") TO &(cNameIdx)
					//						INDEX ON HA_NIVEL+HA_PRODUTO+HA_OPC+HA_REVISAO+HA_TIPO 	TAG &(cNameIdx+"2") TO &(cNameIdx)
					//EndIf
					
					//					dbClearIndex()
					//					dbSetIndex( cNameIdx+cExt )
				Else
					Help(" ",1,"A710SHA")
					lRet := .F.
				Endif
			Else
				Help(" ",1,"A710SH5")
				lRet := .F.
			Endif
		EndIf
	EndIf
	
	If lInJob
		RestArea(aArea)
	EndIf
	
Else
	Help(" ",1,"SH5EmUso")
	lRet := .F.
EndIf

Return ( lRet )
