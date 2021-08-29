#include "rwmake.ch"
#include "topconn.ch"

User Function WFblOpCq(cOp)
	Local aAreaGER := GetArea()
	Local aAreaSC2 := SC2->( GetArea() )

	SC2->( dbSetOrder(1) )
	If SC2->( dbSeek( xFilial() + Alltrim(cOp) ) )
		cEmail := "helio@opusvp.com.br;denis.vieira@rosenbergerdomex.com.br" //+ AllTrim(aElaborador[y,2])

		cMsg := "Bloqueio de OP : "+ Alltrim(cOp) +'<br>'
		cMsg += "<br>"
        cMsg += "Filial : "+ xFilial("SC2") +'<br>'
        cMsg += "<br>"
		cMsg += "Tentativa de separação do material em  "+Dtoc(Date())+" - "+Time()+'<br>'
		cMsg += "Por: "+ cUsuario+'<br>'
		cMsg += "<br>"

		cMsg += "OP"+'&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; CLIENTE <br>'


		cMsg += Alltrim(cOp)+ '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; '+Posicione("SA1",1,xFilial("SA1")+SC2->C2_CLIENT,"A1_NREDUZ")+'<br>'

		//Sleep(1000)
		U_EnvMailto("Bloqueio de OP: " + Alltrim(cOp) ,cMsg,cEmail,"",)
	EndIf

	RestArea(aAreaSC2)
	RestArea(aAreaGER)

Return
