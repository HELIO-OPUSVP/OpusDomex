#Include "topconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410VRES  ºAutor  ³Ricardo Roda        º Data ³  08/15/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na validação da eliminação de residuo     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rosenberger                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function  M410VRES()
Local lRet     := .T.  
Local aArea    := GetArea()
Local aAreaXD1 := XD1->( GetArea() )
Local aAreaSC2 := SC2->( GetArea() )

XD1->( Dbsetorder(6) )
IF  XD1->( DbSeek(xFilial("XD1")+ SC5->C5_NUM) )
   IF XD1->XD1_OCORRE<>'5' 
		If XD1->XD1_ULTNIV = 'S' .And. XD1->XD1_ZYNOTA <> ''
	  		MsgInfo("Estorno Processado com Sucesso.","Estorno Liberado")
	   		lRet:= .T.
		Else
//	   MsgInfo("Existem embalagens separadas para este pedido na expedição." + chr(13)+chr(10)+ "Favor verificar com a logística antes do estorno." ,"Atenção")
	   		MsgAlert("Existem embalagens separadas para este pedido na expedição." + chr(13)+chr(10)+ "Favor verificar com a logística antes do estorno." )
	   		lRet:= .F.	  
		EndIf
	ELSE
//	   MsgInfo("Encontrado Pedido com ocorrencia 5 - Etiqueta Cancelada. " + chr(13)+chr(10)+ "Estorno Liberado ","aviso")
	   MsgInfo("Estorno Processado com Sucesso.","Estorno Liberado")
	   lRet:= .T.
	ENDIF   
Endif

//SC2->( Dbsetorder(12) )
//If SC2->( DbSeek(xFilial("SC2")+ SC5->C5_NUM) )
//	MsgInfo("Existe ordem de produção gerada para este pedido." + chr(13)+chr(10)+ "Favor verificar com a produção antes do estorno." , "aviso")
//	lRet:= .F.
//Endif

RestArea(aAreaSC2)
RestArea(aAreaXD1)            
RestArea(aArea)

Return lRet    

