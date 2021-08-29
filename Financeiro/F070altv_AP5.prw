#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 01/08/01

User Function F070altv()        // incluido pelo assistente de conversao do AP5 IDE em 01/08/01

SetPrvt("NATU,CODCONT,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA080DT  � Autor � Marcia Natale         � Data � 11.01.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada - Alteracao de Natureza Financeira        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Apos validacao da data                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//�������������������������������������������������������������������������Ŀ
//� Abertura do arquivo  De Contas a Pagar                                  �
//���������������������������������������������������������������������������

Natu    := Space(24)
CodCont := Space(24)

@ 206,382 To 330,618 Dialog oDlg Title OemToAnsi("F070altv() - Natureza de Operacao Financeira")
@ 10,16 Say "Natureza"
@ 10,56 Get Natu Picture "@!" Valid .T. F3 "SED"
@ 25,16 Say "Cod. Contador"
@ 25,56 Get CodCont Picture "@!"

@ 40,16  BmpButton Type 1 Action Libera()
@ 40,55  BmpButton Type 2 Action Close(oDlg)

Activate Dialog oDlg Centered

Return


Static Function Libera()

Reclock("SE1",.F.)
SE1->E1_NATUREZ := Natu
SE1->E1_CODCONT := CodCont
Close(oDlg)

Return(.T.)
