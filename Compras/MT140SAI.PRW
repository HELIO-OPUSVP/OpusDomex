#include "protheus.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT140SAI  �Autor  �OPUS MAURICIO     � Data �  25/11/19     ���
�������������������������������������������������������������������������͹��
��� Descri��o                                                             ���
���          �Function MT140SAI - Respons�vel por controlar a             ���
���          �interface de um pre-documento de entrada                    ���
���EM QUE PONTO                                                           ��� 
���          �Ponto de entrada disparado antes do retorno da rotina ao    ���
���          �browse. Dessa forma, a tabela SF1 pode ser reposicionada    ���
���          �antes do retorno ao browse.                                 ���
���Eventos                                                                ���
���          �Programa Fonte                                              ���
���          �MATA140.PRW                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MT140SAI()
	Local _cQR1  :=''
	Local _cQR2  :=''
    Local _cQR3  :=''    
//Local nOrdem := SF1->( IndexOrd() )
//PARAMIXB[1] = Numero da opera��o - ( 2-Visualiza��o, 3-Inclus�o, 4-Altera��o, 5-Exclus�o )
//PARAMIXB[2] = N�mero da nota
//PARAMIXB[3] = S�rie da nota//PARAMIXB[4] = Fornecedor
//PARAMIXB[5] = Loja//PARAMIXB[6] = Tipo
//PARAMIXB[7] = Op��o de Confirma��o (1 = Confirma pr�-nota; 0 = N�o Confirma pr�-nota)
//If ParamIxb[1] == 3   
//   SF1->( dbSetOrder( 1 ) )   
//   SF1->( MsSeek( xFilial( 'SF1' ) + ParamIxb[2] + ParamIxb[3] + ParamIxb[4] + ParamIxb[5] ) )   
//   SF1->( dbSetOrder( nOrdem ) )
//EndIf

	_cQR1 :=" UPDATE SD1010 "
	_cQR1 +=" SET D1_DESPESA=(SELECT WN_DESPICM      FROM SWN010 WITH(NOLOCK) WHERE WN_DOC+WN_SERIE+WN_PRODUTO+SUBSTRING(REPLICATE('0', 4 - LEN(WN_LINHA)) + RTrim(WN_LINHA),1,4)=D1_DOC+D1_SERIE+D1_COD+SUBSTRING(D1_ITEM,1,4) AND   D_E_L_E_T_=''  AND WN_FILIAL='"+xFILIAL('SWN')+"' )  "
	_cQR1 +=" WHERE D1_DOC='"+PARAMIXB[2]+"' AND D1_SERIE='001' AND D_E_L_E_T_='' AND   D1_FILIAL='"+xFILIAL('SD1')+"'  "
	_cQR1 +=" AND EXISTS(SELECT WN_DESPICM FROM SWN010 WHERE WN_DOC+WN_SERIE+WN_PRODUTO+SUBSTRING(REPLICATE('0', 4 - LEN(WN_LINHA)) + RTrim(WN_LINHA),1,4)=D1_DOC+D1_SERIE+D1_COD+SUBSTRING(D1_ITEM,1,4) AND   D_E_L_E_T_=''  AND WN_FILIAL='"+xFILIAL('SWN')+"')  "
	_cQR1 +=" AND (SELECT WN_DESPICM FROM SWN010 WHERE WN_DOC+WN_SERIE+WN_PRODUTO+SUBSTRING(REPLICATE('0', 4 - LEN(WN_LINHA)) + RTrim(WN_LINHA),1,4)=D1_DOC+D1_SERIE+D1_COD+SUBSTRING(D1_ITEM,1,4) AND   D_E_L_E_T_='' AND WN_FILIAL='"+xFILIAL('SWN')+"' )>0   "

	_cQR2 :=" UPDATE SF1010 "
	_cQR2 +=" SET F1_DESPESA=(SELECT SUM(WN_DESPICM) FROM SWN010 WITH(NOLOCK) WHERE WN_DOC+WN_SERIE=F1_DOC+F1_SERIE AND   D_E_L_E_T_='' AND WN_FILIAL='"+xFILIAL('SWN')+"') "
	_cQR2 +=" WHERE F1_DOC='"+PARAMIXB[2]+"' AND F1_SERIE='001' AND D_E_L_E_T_='' AND  F1_FILIAL='"+xFILIAL('SF1')+"' "
	_cQR2 +=" AND EXISTS(SELECT SUM(WN_DESPICM) FROM SWN010 WHERE WN_DOC+WN_SERIE=F1_DOC+F1_SERIE AND   D_E_L_E_T_='' AND WN_FILIAL='"+xFILIAL('SWN')+"' ) "
	_cQR2 +=" AND (SELECT SUM(WN_DESPICM) FROM SWN010 WHERE WN_DOC+WN_SERIE=F1_DOC+F1_SERIE AND   D_E_L_E_T_='' AND WN_FILIAL='"+xFILIAL('SWN')+"' )>0  "

	_cQR3 :=" UPDATE SF1010 "
	_cQR3 +=" SET F1_COND='031'  "
	_cQR3 +=" WHERE F1_DOC='"+PARAMIXB[2]+"' AND F1_SERIE='001' AND D_E_L_E_T_='' "
	_cQR3 +=" AND   F1_FILIAL='"+xFILIAL('SF1')+"' AND F1_COND='' "
	_cQR3 +=" AND EXISTS(SELECT TOP 1 WN_DOC FROM SWN010 "
	_cQR3 +="            WHERE WN_DOC+WN_SERIE=F1_DOC+F1_SERIE AND D_E_L_E_T_='' "
    _cQR3 +="            AND WN_FILIAL='"+xFILIAL('SWN')+"') "

	TCSQLEXEC(_cQR1)
	Sleep( 3000 ) // Para o processamento por 3 segundo
	TCSQLEXEC(_cQR2)
	//Sleep( 3000 ) // Para o processamento por 3 segundo
	//TCSQLEXEC(_cQR3)    

Return( NIL )
