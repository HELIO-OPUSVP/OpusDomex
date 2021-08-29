#include "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
//--Gera codigo de barras através de linha digitavel
//Desenvolvida por Marcos Rezende
//
user function GerCodBar()
	Local cCodBarMan:=''
	local cStrVLD:=""
	Local cVLDcp1:="",cVLDcp2:="",cVLDcp3:=""
	Local cRETcp1:="",cRETcp2:="",cRETcp3:=""
	Local nRETcp1:=0,nRETcp2:=0,nRETcp3:=0
	Local nDV1:=0,nDV2:=0,nDV3:=0
	Local cDV1:="",cDV2:="",cDV3:=""
	Local lRet:=.t.
	Local i := 0
	cStrVLD:="212121212121212121212121212121212121212121212"

	cCodBarMan:=alltrim(m->e2_codbar)
	if len(cCodBarMan)=47
//valida código de barras
		cCampo1	:=substr(cCodBarMan,1,9)
		cVLDcp1	:=substr(cStrVLD,1,9)
		cDv1	:=substr(cCodBarMan,10,1)

		cCampo2	:=substr(cCodBarMan,11,10)
		cVLDcp2	:=substr(cStrVLD,10,10)
		cDv2	:=substr(cCodBarMan,21,1)

		cCampo3	:=substr(cCodBarMan,22,10)
		cVLDcp3	:=substr(cStrVLD,20,10)
		cDv3	:=substr(cCodBarMan,32,1)

//calcula campo1
		for i:=1 to len(cCampo1)
			nCalc:=val(substr(cCampo1,i,1)) * val(substr(cVLDcp1,i,1))
			cRetCp1:=cRetCp1+alltrim(str(nCalc))
		next
		for i:=1 to len(cRetCp1)
			nCalc:=val(substr(cRetCp1,i,1))
			nRetCP1:=nRetCP1+nCalc
		next

//calcula campo2
		for i:=1 to len(cCampo2)
			nCalc:=val(substr(cCampo2,i,1)) * val(substr(cVLDcp2,i,1))
			cRetCp2:=cRetCp2+alltrim(str(nCalc))
		next
		for i:=1 to len(cRetCp2)
			nCalc:=val(substr(cRetCp2,i,1))
			nRetCP2:=nRetCP2+nCalc
		next

//calcula campo3
		for i:=1 to len(cCampo3)
			nCalc:=val(substr(cCampo3,i,1)) * val(substr(cVLDcp3,i,1))
			cRetCp3:=cRetCp3+alltrim(str(nCalc))
		next
		for i:=1 to len(cRetCp3)
			nCalc:=val(substr(cRetCp3,i,1))
			nRetCP3:=nRetCP3+nCalc
		next

		nDV1:=10-(nRetCp1 % 10)
		if ndv1==10
			ndv1:=0
		endif
		nDV2:=10-(nRetCp2 % 10)
		if ndv2==10
			ndv2:=0
		endif
		nDV3:=10-(nRetCp3 % 10)
		if ndv3==10
			ndv3:=0
		endif

		IF nDV1<>val(cDV1)
			msgalert("Código de barras incorreto, campo 1 inválido")
			lret:=.f.
		endif
		IF nDV2<>val(cDV2)
			msgalert("Código de barras incorreto, campo 2 inválido")
			lret:=.f.
		endif
		IF nDV3<>val(cDV3)
			msgalert("Código de barras incorreto, campo 3 inválido")
			lret:=.f.
		endif

//transforma em código de barras para compatibilizar com o sistema
		cCodBar:=substr(cCodBarman,1,4)
		cCodBar+=substr(cCodBarman,33,15)
		cCodBar+=substr(cCodBarman,5,5)
		cCodBar+=substr(cCodBarman,11,10)
		cCodBar+=substr(cCodBarman,22,10)

		if !lret
			return("")
		else          
			msgalert("Código digitado corretamente e salvo no campo código de barras")
			Return(cCodBar)
		endif

	else              
		if len(cCodBarMan)>47
			msgalert("Favor verificar código de barras, possui mais de 47 dígitos")
		endif
		cCodBar := cCodBarMan
	endif
	return(cCodBar)

