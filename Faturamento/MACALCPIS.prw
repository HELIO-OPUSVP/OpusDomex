#INCLUDE "PROTHEUS.CH"
 
User Function MaCalcPIS()
Local aRet     := {}
Local cCalcPIS := "S" // S=Calcula PIS; N=Não Calcula PIS.
Local nAliqPIS := 10  // Retorna o percentual de alíquota do PIS.
Local nBasePIS := 1000  // Retorna a base de cálculo do PIS.
 
/*
 
Faça seu cálculo aqui: À partir desse ponto de entrada, é possível acessar o aCols e o aHeader do Pedido.
 
*/
 
aAdd(aRet, cCalcPIS )
aAdd(aRet, nAliqPIS )
aAdd(aRet, nBasePIS )
 
Return aRet
