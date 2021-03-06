//----------------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - OpusVp - 09/12/13                                                                                                                   //
//----------------------------------------------------------------------------------------------------------------------------------------------------------//
//Espec�fico Rosenberger                                                                                                                                    //
//Gest�o de Pessoal                                                                                                                                         //
//----------------------------------------------------------------------------------------------------------------------------------------------------------// 
//Ponto de entrada                                                                                                                                          //  
//----------------------------------------------------------------------------------------------------------------------------------------------------------//
//C�lculo do adicional de periculosidade.  Roteiro de c�lculo seq 761.                                                                                      //
//----------------------------------------------------------------------------------------------------------------------------------------------------------//

#Include "Totvs.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
#Include "Fileio.ch"
#Include "Protheus.ch"

User Function CALCPERIC()
Local _cCodHE    := StrTran(Alltrim(GetMv("MV__PERHE")) ,"/","") //"138/139/167/193/196"
Local _cCodDSR   := StrTran(Alltrim(GetMv("MV__PERDSR")),"/","") //"123"
Local _cAdcNot   := StrTran(Alltrim(GetMv("MV__PERNOT")),"/","") //"106" 
Local _cVerbas       
             
_cVerbas := _cCodHE+_cCodDSR+_cAdcNot

If Alltrim(SRA->RA_CODFUNC) $ Alltrim(GetMv("MV__PERFNC"))
   For _nI:=1 To Len(_cVerbas)  
       _nPos:=Ascan(aPd,{|X| X[1] = SubStr(_cVerbas,_nI,3)})
       If _nPos>0
          SalMes_Per+=aPd[_nPos][5]
       EndIf   
   Next 3
EndIf

Return(Nil)