#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A200BOK   �Autor  �Michel A. Sander    � Data �  05/16/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada no Botao de OK da Estrutura de Produtos   ���
���          � para salvar a posi��o da Estrutura antes da altera��o      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A200BOK()

Local _aAreaGER := GetArea()
Local _aAreaSG1 := SG1->( GetArea() )
Local _lOk      := .T.

//������������������������������������������������������������������Ŀ
//� Verifica a quantidade base das estruturas					         �
//��������������������������������������������������������������������
If nQTDBASE <> 1
   Aviso("Aten��o","A quantidade base das estruturas n�o pode ser diferente de 1. Corrija a quantidade.",{"Ok"})
   REturn(.F.)
EndIf

//������������������������������������������������������������������Ŀ
//� Cria o array que recebera a estrutura antes da altera��o         �
//��������������������������������������������������������������������
If !INCLUI
	PUBLIC _aEstru:={}
	U_ExpEstru(cPRODUTO,@_aEstru) // vari�vel CPRODUTO do GET da tela de altera��o de estruturas
EndIf

RestArea(_aAreaSG1)
RestArea(_aAreaGER)

Return ( _lOk )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Explode  �Autor  �Michel A. Sander    � Data �  05/16/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Explode a estrutura do produto									  ���
���          � 																			  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ExpEstru(_cProduto,aArray)

LOCAL _nRegi

//�������������������������������������������������Ŀ
//� Posiciona na estrutura ou sub-estrutura         �
//���������������������������������������������������
dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial()+_cProduto)

While !Eof() .And. G1_FILIAL+G1_COD == xFilial()+_cProduto
	
	_nRegi := Recno()
	_nProcura:=ASCAN(aArray,{|x| x[2]==G1_COMP})
	If _nProcura  = 0
		AADD(aArray,{G1_COD,G1_COMP,G1_QUANT})
	EndIf
	
	//�������������������������������������������������Ŀ
	//� Verifica se existe sub-estrutura                �
	//���������������������������������������������������
	_nRecno := Recno()
	
	If dbSeek(xFilial()+G1_COMP,.F.)
	
		U_ExpEstru(G1_COD,@aArray)
		
	Else
		dbGoto(_nRecno)
		_nProcura:=ASCAN(aArray,{|x| x[2]==G1_COMP})
		If _nProcura  = 0
			AADD(aArray,{G1_COD,G1_COMP,G1_QUANT})
		EndIf
	Endif
	
	dbGoto(_nRegi)
	dbSkip()
	
Enddo

Return
