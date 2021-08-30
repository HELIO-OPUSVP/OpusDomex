#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#DEFINE CRLF Chr(13)+Chr(10)

User Function DOMETQ20( cLocImp, nQtdEti, nOpc)

Local nEti 		:= 0
Local _aArq		:= {}
Local aCodEtq 	:= {}
Local cUserSis	:= Upper(Alltrim(Substr(cUsuario,7,15)))
Local cFila    := ""
Default nQtdEti:= 1
//Default cLocImp := SUPERGETMV("MV_XPRINT1",.F.,"000001")


If nOpc == 1
	
	MSCBPRINTER("ZEBRA","Lpt2")
	MSCBCHKSTATUS(.F.)
	MSCBBEGIN (1,4)
	AADD(_aArq,"CT~~CD,~CC^~CT~"+ CRLF)
	AADD(_aArq,"^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD21^JUS^LRN^CI0^XZ"+ CRLF)
	AADD(_aArq,"^XA"+ CRLF)
	AADD(_aArq,"^MMT"+ CRLF)
	AADD(_aArq,"^PW400"+ CRLF)
	AADD(_aArq,"^LL0200"+ CRLF)
	AADD(_aArq,"^LS0"+ CRLF)
	AADD(_aArq,"^FO0,96^GFA,04992,04992,00052,:Z64:"+ CRLF)
	AADD(_aArq,"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:F4D8"+ CRLF)
	AADD(_aArq,"^FO0,0^GFA,06656,06656,00052,:Z64:"+ CRLF)
	AADD(_aArq,"eJztV79rI0cUfm9mvDt2xtEopBhzijXWpXCXFYbg4rBmz+KqC6RMOokLIaWMGxcmGq0EViHIlSnvT7g/YXVnLhAMaVMcZO/SXJFCIY0Cip23kovcOgFduOIKfbDo5zefvnlvnr4FWGGFFVZYYYV3Av1sP8ymEk54f7IsR0SHpi4Mnhmnl+VI2ZNWSGTaymU56qPew2NRQex0ltdBeFhjEr21y1IgRPx+TxjIIr20Dr6A714yCXcsLO0H6jjaExUI3kAHpB+SH2Bv4EeUe4b8YF8vv2+BfiJznUS6pf2E2Wn4x9pVehqmy/tZ4V1DI7uEqbcfwAAO7HsTuX7JwmyfAYPSSB7okEGD+2mBFAsUzpVRwKHWWmkeQn0QAgd9T8Vmsw+xaosC565gzLkt4viHWgrJ1mCHLga2Rl0uE8hbvcC5J4LApWUuYPxzpAMTbsIe34QQWu3N9MIcwth8GhQ4NUY/2etL0illwCWTvsalJx0cwtmkdqcna8VNaApM62eTZwI6qqX5hJt0D00aQgWfQ1N3Idb19HVKlb58sjMy5wK2lSM/l6SD0ocQ+lfwxCbQHdqTGzqgykrTAxdOKxNqd4zabaaQ3odn7acQm4664QcYk3qX9jPxNEnZ/C2aDGCHkJAOSlvct0Oqz62KPhUQB14LzaNWnS7tdKziXsxzPzfrg6MNZUgnZj6vj7V2QFfLPJFtTBOIhzuj1ymN8QymKpzobnqAoMM/r1wUnbqo0ymN1AGmXeiaqNg7K7xt+Den4H9/VMXskjH/ySumt6X03d4UsysmN8D3X1w2pH9c46Ui5+hMC+po1xT6aFD28IMKDXJRRkoLHA2dUl48P+DOJSBNBCG0+5G6eSCFwmRjHec9PnQ0DewNzn0l8NylTaXdZ1spXCghMNjc6oOqhFhpj44D5wocmy+XNPztqbbrpDOkl8jW5SX9dTOQNtmZgS1w9iu07qzuD43eXyM/F4p75Gv6GY0e8tMIfxfQKnBKUtG61jOjS3LoG0MJk24ih+dAG5r7oeNa1EEygKJMx1HjxZe5H5o4gfqiCRCRn7GpP7+hkxsggLWanuZ+KPYwKXdpJrA8MPyLTqtpqD63IH6sW826h3MVCKpP9A3QbEAT6+jz1o19SwxDtgHwSNvhvqdsQMEqkfu7xJnXxzrrCxzqHdo3AW58VVVbaXc8w8lV9zejgb+4wkr3bNKpFu2s8M4Cs+1S1sjHQYkJKzNvq9m3sN/IElaipstzwbQUZlENS5IdLDihOQJHAYFOf1/octlHUO/jGcR9UfYKKRdQw/sonwgDcbjgCOX8PCAk9q7QWnpL0YAOp+sx6yTSJGD0xFJEtefC+wVHpKmjgMCb7p4w9c2UdCjKQzweOKeQcgFFBxepvcA11XjBYeBp6flqNVH6FeYvkP5IfWKtRMoF+bGy7PYMbk8XFOC9lEZKM9d5IFQbyc8exwzi3sy1Z13KBZi6VpRPhAemc71xE5/mAYHVXI28wVlWesngTjXtMVeT4zwXnDhSpJNaM9vXnEruh3Q+dF8LEWPagWMOAcRPhftKjTXlAuVaHXP0HNqaX3PkP/yw3sJP7iFh9uP8lovldw5zHbqBWBgKROwdBQReiQ5F0Mv91Dn28/pETdWjXIAiclE+EeLH8UKGyZ1Ffd6PEsF8rkO5I8nrEyUypVyAo8iTDk2ER9ccnGyDo4DARTXojhF/mlQnXTht/PLXrMpn81wwrdKUyyeCO3gb3VoMNMtg+bu3FVZYYYX/j78BxPFd5Q==:001F"+ CRLF)
	AADD(_aArq,"^FO8,108^GB383,0,2^FS"+ CRLF)
	AADD(_aArq,"^PQ1,0,1,Y^XZ"+ CRLF)

	AaDd(aCodEtq,_aArq)
	
	
	For nY:=1 To Len(aCodEtq)
		For nP:=1 To Len(aCodEtq[nY])
			MSCBWrite(aCodEtq[nY][nP])
		Next nP
	Next nY
	MSCBEND()
	
Elseif nOpc== 2
	If !CB5SetImp(cLocImp,.F.)
		MsgAlert("Local de impressao invalido!","Aviso")
		Return .F.
	EndIf
	
	AADD(_aArq,"CT~~CD,~CC^~CT~"+CRLF)

AADD(_aArq,"^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD21^JUS^LRN^CI0^XZ"+CRLF)
AADD(_aArq,"^XA"+CRLF)
AADD(_aArq,"^MMT"+CRLF)
AADD(_aArq,"^PW945"+CRLF)
AADD(_aArq,"^LL0709"+CRLF)
AADD(_aArq,"^LS0"+CRLF)
AADD(_aArq,"^FO256,32^GFA,01152,01152,00012,:Z64:"+CRLF)
AADD(_aArq,"eJzNkj1qxDAQhSVcqNQRDNpiSx9BOVjwKqRR2EJHWEiXKkewu+QYxtWWZqtBCG00+nUgXQhksOHxPH7+ZixC/lmpVr/O6pam2dbyDbR8Dq2ndz9r6Xd6bPokmx5ly/dTzaeOzxXHDhWoA7bTpmq2dFvRfD1UOD5TKPmXzzdX8vuPrYLKd1tBJYc")
AADD(_aArq,"KOhqYinbc9SprP1ipqg/JV+oJDJg55VPgwPIA3W2wxwzKNgYFlF8NnKFgMqBFr4MtA/SKAXEpf9IGtE/5kgQ/g57E0Yq8xRH/V9Ye+6cE6tBPoJ0Vx5sYIhzd0I+g6hmw3yyYz5IfodkqDjdxiNChM/g0av6pz6BfIGESupAEKl+FCFfcaKUK+X")
AADD(_aArq,"cdy2N+Jo+PvYiFG6UuIkVQChp59GVGnc4hHomAj/MKPBLoldtcNfLo86ZiH3lI7/E15eNGyx/E7/Q6l6uYhDwm/FhhgNO9FCFV3tU3f69lkbtz/0f1BfiW9H0=:0871"+CRLF)
AADD(_aArq,"^FO224,352^GFA,01536,01536,00016,:Z64:"+CRLF)
AADD(_aArq,"eJzVlLFOhEAQhiFbUO4jgEtxic09wr6YARObIRT3CBorOx9B7K7zFYg22pGryIUMzh7s7ozFRWMsnEDIn5/Jv9/sQpL8+ypi/V3IKGU6yfwSZb5C+X42n9d6vj6r85dO6l3ULtg+9iK/zgbxftVKjakEwlLodOKApEcQWg3JFc/fHC5rnp8NkxU")
AADD(_aArq,"4H/jEgfQz5kK/oeU6v5l1x7RtcddzrTAL2uGXWPYsv1KYcmBssWGAhIccUB1LNGzH1Jhiwv2xRWB+NpBfx/ztK/XbmK878hmg3jcIt1HnHaUzQHtP/dsIaN35ioBJDc0EbACV85UHLAo01F+OPp9MdwXgdHL9cQfJcfRBq4MxaOIA3NkhMwDqd4")
AADD(_aArq,"ARIOzgunIPSPjGlb0rPB5/EA6cKgCsRyMAWmo+GrPxulq+r3CEEYDmB60HmhbfA15QL/G7AXi8BW4FVLR2eKAbI96pVsBsWT4BfF1XxD/VOoDc+/UCaGdfi5EH3X1L66DXgf6wfvX/+wRBsuav:937F"+CRLF)
AADD(_aArq,"^FO320,352^GFA,03840,03840,00040,:Z64:"+CRLF)
AADD(_aArq,"eJztlE2O1DAQhZ2xwEsfoY4SToYjzcFwaxazZG7QQVzAo16MBe4Ur/yXBIQIEjtS6u64o5cvz64fpc4444z/O0Z/UDcd07mD7/14UJcO6uIx2RAO6uaD7/1n4T7I77v7/i7PamReLL5qUToqzUFZryzjO/esDNARM0PHA4uOOCnyykFOYc1e4Yl")
AADD(_aArq,"uGTJvBBg6Zjyy5YUtzwSAGLpBfIDXsjxs/fEEHh6YrNfy38ZfeJR5XseBL+zJG/ybKHWd/o48goKtqaJb1DiTB2qnM2+oC7iyIXswQWO3gbxY87R0f/q28rB3HfPa+hG2Z7usvFfhxcoLOmJtwEN3AMur7kva+ItZ936CbsIt4mnPa/6SCUbqjr")
AADD(_aArq,"xD1sDzzZ+dl42/pGNe2MJDjhuPXjn7I+HdoaPKm8TmteusX3nDfam8oot0nTtPHIg/5jQkNsGG9S5dQ/NHkys86FTi7k900X4OG96Uzy/z3GP3Jzp6jk03yglV3hDHx+aP5S301HVuwkl1f+NzaPvIvKfU/G15KtHXjT94vSydJzXezi/Rbe/vw")
AADD(_aArq,"k0nNd7PL9nb/vz8qmMUfstvMm/78/Ou+cu6lt+E6sbiQfxJ3pDmT4WHtkKDtPpLhiPY5qXl1zve6ro/zTE/U+pPLjtd94eKrjrnS5twbQ+Wvu/+FPf+8PliKw/dJQ3Rzk90vd/GzKu6WD/Fn3Ktf0WX273oTMqf5k+5gGaXeYAWd1lX2yjKq0t+")
AADD(_aArq,"Gf7GNl/sosuYqbwglFJ/jBXFOq8M17FVdHhdmXpZF0VX5l+eVz/rSv0Jz8oqlfmXx2r1J9tcNv7ELxJuZe6WS+Fh+zJFY56BxemAeQ8Q8Use07WufhsP3/4gOOOMM/4mfgB5zEYF:3D0A"+CRLF)
AADD(_aArq,"^FO32,416^GFA,25088,25088,00112,:Z64:"+CRLF)
AADD(_aArq,"eJztXMGOLLd1JV/BooAYxa0DlKq9zE7KrgOVu/UjQZQ/KEEL94MeNHx4i+zsPzDeZ3hh2BxooZ3iD/CCD7OQVg4Fa1GOOlO551yyuqenBT0EnUHgNKF5qimy6tapQ15eHt4aY67lWq7lWq7lWq7lWq7lWq7lWq7lWq7lWq7lCcoL44zJN/Ps5jn")
AADD(_aArq,"YbIybs1nNszGjNzZKvfwS5WAnjbPxUmu8HPbG/OSPBpW30XS4eJ4/Mva7pcbNf5Ta+1N7k/HBpHm+93LJSqobaeNhb+eDTc0ctlLRJNqTxrgD7G3lPzmUylfJrD3tJaleatBy+9ie4ItmLPi2cxB7Ypf4VoLPzwn4XDKjMXZS5PJGzMqYm7niG+")
AADD(_aArq,"Til7NAxw1KjZw6h+/PxqcFHx5R7CUcK77VPAGfJz67N6whvmBwqPgGvXhvcINS4/n8j+x9ZeTZs+n40HvB6oJLHWpGL7StBJPUuJH2/mRavA7Y+1TIlkOptOBPziR5V/uf5FrjjI/do+5iBV+WpgNvkq3gC01uUbXzyaa12JGadgd7zW/EnlCJp")
AADD(_aArq,"p8Jp3Ioxw34o71Nk+XRSw0q1o/tfYlnHxWfBdJGHk/xrbKNozyJ1LRoY5pOOp+NfBWfCHhb8Q16cWdBc6mRivQYX/PvwU+KL+CSSeyZifimdrJp0pp2LTXG/UrwSSM5Yf4Sm2iAD313wJlkejk11Rp0++EsvqHyJ081Cn9mp/j6HfCxphvwPp0H")
AADD(_aArq,"Pn2fb4AhHeGDPaFtqDUY1mfwvQp+s/CXcCaYtfLXri0ZkJqh2murvZQEhXnIXy/P+vNaI/jyY/5cE1xf+ROcaq/gG2zEGwG+Dvw5t/BnY7K094A/3KPWyPH4GJ9/Fb1f8E1qbyj4NjZtAvGte+Brfaj906ZspwXfUPonaKw1cjw95s/ZKE9N/sQ")
AADD(_aArq,"f3OBMMB39wtiuZPxFPulO7blQxx+YnRd88J8Yf4pPa4BvJS7gBF+TvAvEJ5dsJ8VHL7lrvU1e3eWuhb2+CdW/NGHH1pU/uXieJ28ONbhq+8hea5NrtBfKJW6mvYKvF/DNTLpGB/46wVv8ZxNGA+9e+ZtnK/7TmUPNeXytSf5VKvjCM7n7gm9q3W")
AADD(_aArq,"0yMyeQ7IM88iAvg/ODePWwFk8byvir8wP4qzXg7zG+zmQnDJf+aVaJ/Gn/bBtx/Y7+U558R3x1/nPyhEbJrf4T78ccasD64/65nbM3ufZP0+Tj8de8SZzzcC9hRRqn9llSe3jyE/+54T1qjeDbPR5/K7z0sY4/AcX3Wcaf/TYa1gg3wopMa7nnO")
AADD(_aArq,"Cx3lSF3PP5kZjGHmvPjb4tONRV8Ymp3jM/8VZjtpUbsxR1QyswxEJ/wKC/+IT4XBdO7teb8+BN7zrw47z9b8zzmig/2bmCvX+wZxbr4TyA0Xa05j2+HZ9tUfNGsCbLiey49qQWE2KQd3J2cW9Feb1ppmB/gsxnvptbIqTP+c8Sz9eMRPmk8Fv7M")
AADD(_aArq,"L8r80ESbRtgbe+2cONvEgi9heHLylFO7WiMVZ+aHCU7P/8D8Z7Yy/20wxISQCR5S8HkOLTkrcUviWJSrdP6bBOpUazAwH/OXMXZ8XuaHLPzV+b2XYfSCAarwknd4nKEv/lPa26T9E1eV+MVmXKs1ctWZ+EX6nzeujr/7BvGLT5U/n7YB48/THia")
AADD(_aArq,"COj+sjXs5efZPuSqX+QGHtcaH9+Mj/uQ5Vg6jnP4z3mg8qF5yBBYZn3hSgxBVRmPH+V2GmFiX1pH45Cq5+BZD5wb9WGtcjWNP7HmdweA/4xb+E+Em40+Ze8RfEp+weTPfRdPL/I6g/l54jjP9J8ZUxMXy6DisNRp/ntoTMtCRCj7PuPi+rB/k3U")
AADD(_aArq,"XH+UHe7+5m/gvtcRGxH+XSMj8giHe05+VCU2vgZx7hk57rf21MnR+a/8T64RtT8Qnw3wOCWFkLPnnotiwixM+mRuc/I1fhAnbJydQaj1D71N61XMu1XMvTlPzE9tLTmtMF3dOV5qnthSe297Tm/uaKhAUeEXaP8CNnRJYdIxqJWW4k+kB4KeEn1")
AADD(_aArq,"Uyz+shAgJjl2M7/pZrkCwbR0Dzt/B0DMoRCcho9vTUUMzLusNhDIGS2aJq4lN2g0yAm2xZ7Hhog4qJ5osAyUyGdufxp5tcuYMkbDkEd1vu8CexBrMlcBbOsykpmRXyjRWCGR8PqveJbya2hZtp5T4Fl5jEk4AAl2DFEjVxAEZ8EaHhfhjIv8I2I")
AADD(_aArq,"m07w4dFSwjNuQ1MjR7Un6zWqmVB9iU/BTLCHtVzw0vRINEUEy3hcUBLftJqnYq8lC6P5NABVdnkVV0GOZM2F1Szt3di9qplxRf6wlLBQ5d4Tjs3eyRuRVYOcslxDyGoranxsPqe9mFf2yB7xfRbgWpKsk+I2Cj6sgdbF3oQ1BVfjPlAgk3qK2f+")
AADD(_aArq,"U5I4bFzZyPOEUxRezZlt5l+a+8Lem8m30DZO/TyJXfiux+l6Uo95AkaE9efShqJlOBbKG+Abzj1jjye8vzMiQ2uyIb8Tyguuirwp/UFCP8UGwJL6NGPgFtD3E1ZPaa1TUTNCRC76oy40d1oryO7otl057kGbwawOVz36l+KigLvjI3xviw6Ivd5")
AADD(_aArq,"n4uJolPumtFvZkUROIz7JxZ0Zoz62zWDKulzW8waRmsdYv9uLHWCE/5C8l4pPHyMNE/kwq/GF9oWom77TwN5gMe++6V0lFTIiDiz28neZXiu/jwxqw8GcjcYwDBIUd8Zk8LvYcp0VXBU5d5g9mHHHeOS7iF41JOxmudsW/mMOauuCDnAV88iDTM")
AADD(_aArq,"Jzgk9H4Ely6VPB54hOasFg37tcBHZ88+8XeJD9t8S9mU90L9oI88bF/yYJZ8HUcf9hQmnBSRpujmmn3xiz+JcqQSjvi86qi2aKBapDwXH46tRdZXe1BiNhBsCz4dkOv+DL8iuJzAWqmnV8f+8/JpjV4dX9Ql0l8tAfX+aH8DBWfX7ZYqJ2ZEYIl")
AADD(_aArq,"+BuBzyt/slrPRQRzqnPeZPWfe/WfNnbEt40UTXGV4gOLK/n5oPIHBfUY30TBMlJgmQb/6uh9UpyULsl1+gP/KcN0Q3zfC1VzqvgC9Rj4Vmo4xGdO/ScEy8LfrnMv1V7pn7SnFNwU/8nJwFR836LTZMVXOz3xjRUfFNQH/VNW/wf+mi+Uv0P/dOy")
AADD(_aArq,"QeHAdfwCzwXzB/vkGo2866p8bvbFJCz5T7ZXxB07A3xr82duH4y+UkSdNX6p/uZ1vI2bMez57hL3d0fiDc34HhC74Tv0LJOniX6bB3j0af/8GhaynPxN89m7+AlPJPNOfhQkq18G/cPJpSwxAfImv+Ig/2Fv8p/k2stnBf3rOIQhsDvgcJnMMT5")
AADD(_aArq,"kfbIl6FB8BtezDScdffoCvwVZGW+YH8Z/m+8D5oeKT8dNAzWyJT+Y7npSghXx6zH8JomnZYwHbx/iaxGsP/DmInfT6Y88Nu+dRp62CT+ejEZpypFZK0FbsYVemx4ZSVnzcXFHV/Z2CD8KpeTg/+DBR4OT8DsFyy/kvlvkP+mgDDtBEZrLSPzG6M")
AADD(_aArq,"PVt4E8n5Y8aqHLVVrYCNwQ3B3zyQnLBl33ExLwCPlfxmb0QRDUzuvACGBqdLBED8Hcvp3ca/5jaF6s9uQgb+C+O8Lk7CJbE59I2DNhdbuWfGr983kwWaiYq5VjwcH6Xl9JAG3XB4TQozRq/PLAnTQwU1AN/zZzgrcGfUGyID6oe408qlBmiJvjH")
AADD(_aArq,"3ojG0PLQoIz+t2ET0AWNEBI++audpnrppX+qPeBDvEsZu2YGWCqmifEng2Hek+5mIy5QAs4MPldFpIUGyg34BZ/lZtOszCqjdubswHFys4cMivXDfsHnEDNzftiLT4mcj+AsYQ+/SwTn+DiqgSq+ag8X8aoj/7JRwRIx0fuv0dOA7/WC7xkUURA")
AADD(_aArq,"glc/u5eJvdHNoDXXh9xhu0zNOiZOKpg/w4SIjrQq+Jyv2ac1xzn/K8uT4ntjeO09sr/3xJtdyLVdB9cLlKqj+rRWom9iAlpHyzwgOJMg2JVeS8mEwkJhcZH4CdBUG2Agyl/TOjFDNfse9UzbUtBEcVUF1KUXdRI6ABGpCrywmTMmVRAhDexKZRK")
AADD(_aArq,"aJIhtNArJMiWNJ78RiUJZLTBP1TKmQFiqXVkF1KStGVAEiipuRbXGKzxR7yPyUJ12bspl9lN7JNNEVIlXiG/lGrIR3B0F1KVtGlwkZoBImir3pDL497O0LPm5BK76S3pmgmcqNgK+FMoN4DpHuQVA90Gez3bvkZNW0ksWA4qu5Pp2uruyfzHtR/")
AADD(_aArq,"kE2KPhza8VX0zszNFNooHLpT6luSQvIpQdBdSkTUjok8s9gYVP4q7lM62Lv3nwYm98YzQaVBcNvFV9N70zQTKGBYgGt9n6rcukiqNYCdZPcjVgFds1jfIb4/j42srDIyp/rCr6S3jlCMx0p85uOaaLSAlrqQVCtpWRuTsgAHZiWMxV8gf9TfH8W")
AADD(_aArq,"fMj8nJQ//zvFF0p6JzVTaKCCb5iY8vM7dMt4EFQXfLrqfoEM0A6L/7P8fSX4kPm5U/7aiq+kd1IzhQYqlw4j7LGFnFsE1QVf5AJ4gwzQQdOzzvBHfN5oNqgLbVvxaXpSgmaKiRVJFmva0xYHQfXEXocM0I72zvH3pfkEOZTIBgV/XVvxlTSnbqf")
AADD(_aArq,"Lfchua6YZqr2DoLrYC3yqDTJAV+EUX+Xv6/BZRObnRvnrfcWn6WUJmunnik/OyPiTFkB+EFRrwe3Qq5AB6rM54k8XpnvaAz5kfq6UP2G84mP6Y4ZmCoWtJ+KM+2my/SKoHtvDqEEGaDOHI3ywty327sJd7JuAbFDwt3ZBx19J70zQTD13G0zGat")
AADD(_aArq,"JIi13Bp4LqYk/feo8MUEt/fYoP/N2Gf4UYiGxQ8Lc+wUfN1HHbyCSmF66ZLHokqJ68z54ZoH+Yjsaf+s+CL97FoUnIBgV/6yZU/go+aKZUkyAKAl9DSeIgqJ7aYwao3f/A+LuNt8CHbFDwNzax4NuV8QfN1GXKUh72pEXlTwXVk/7ZMwP0B/3nm")
AADD(_aArq,"zd3EZmfzRvyJ/NJ5a+MP2im9J+YFTD3zan2TxVUj+2xf/Jd9z8w/m5vbyMyP+235O9mjifjD5qp9MieKgXTRJnodhBUj+y9y/FnprR74D+Px1+6exWZ+flX8lfxHcafvXsJDZT4wJy2CAdBtRbpOi39i3mRR01rPMNffPMyMvPzecS3AnK3B/ig")
AADD(_aArq,"md4iUOlpT9+n1KSDoLrgg+ocNAN0rULnGf6AL2s2qDSCYlv4q/7TfB+ggUIyhCdFC0wNB0F1wacp7ztkgA5n8fElfAr/z2zQgbtJY5n/ShplV9Jge+qdY9VS40FQXexNnG8nZIBuhL+04AvH/M2vIjM/t0lzOyflr6R3UjOdyB/OZcqHqyDz3yK")
AADD(_aArq,"oLmWiupmRAdqbXoKZdI6/X9pbZn5KNCKNFnwlvTN3TBPdaWJx5F7E6CXmOwiqS7lvpmbyEIfT6vU9hM5z/G2bL5j56WUSuccgVXwlvRMQqIG2ul/LaQaJo2kRVJcCNQ8ioISojqJghEvUXEnIoI47KRuMoQ6qr6OLG5gUunymBAjQQHuMwHwzfx")
AADD(_aArq,"mYT38kqC5F48+AWMvrRjvsaS4oAnTIjzZtmi+YiclsUKF22BY1kOmPCXSv6D/l5Uzz/B/Sgtv1i6C6lKJuMgtCrlghZH6Mr7Nqr4mWWm2n+Ep6J/RvyqQ9GM/z/CWov5mOBNWlUN38BnTxs6gG32tNh/mh4OvhAz03E7YB8Y7iK+mdCZrps3vVU")
AADD(_aArq,"okPm0jvvz4SVK/lWq7lWq7lWq7l/3N5B/IoA5qsH8kX1WX1kVH5fXXZza+WyZ8bTY+cmZ/KqJo5O5BTtumiInXH5M/PuaAfFR+VGn4nCXs3+aKbl2uEw+ae0S3xqWrGrzgh+9p5suGC9n5mv5P48ZeQIcungOTPx38p9tKLi26ifMDkz69lXdek")
AADD(_aArq,"8pEZ8K2gVMNeEzcX3SQaXbTZfI0IvH4qDv74lRxSXJvQmY8vaA9f1E7mLiCvp3wkCHxMeDEfwl5/0U23BECyPIK9I/40w/oT+TH8cPxy9oSwnzd3sXmIj98eIi8Wr/bxR5r/4wLBiAoT8B3xNzKP/A3sdeaDS9rD1nnzMrnaPxUfv+W0d7C3viw")
AADD(_aArq,"+rK8d7Nnj8cdvVVU5OqRfXaA0zKSGOhp8PBp/Gf81UP58+l/Ah90l5AEd8YcPbNFHXb48Ph8m+s8Df8TXwl+30yXtWbUHfPfmiD/aU2W6uyw+9E9snc3lj3Ac8Tdw56Rd0h8vYo/pqvjuwNQ/UrH0zzXxuYvj+4eyMXA6/vSPE/jL4oNsXOwV/q")
AADD(_aArq,"Bt0p+pvQvj85TLIG0Tn1N8TPjUP17jl/THi9hz3Adi7rHyx12/AbEL8LkL40NCZV5zq07xRaqeG8ztTOaXFzD82F3evli5vU07pIkqf8hs7BB18i+TIJ7oL4sP8uhEaZv45Fd8vAF5k/iQin1R/4kcSXGVdfxpimZmmiRmK+yzX9CeoTyamYNNf")
AADD(_aArq,"Iaq59TQXiOzo/idS9qLkEeTcbDHmeAGqmc2yPLkbHyTLxu/mL/7Rv5pXoWCT36F+vm+/E58cnBJe29zr0vae5vYMl3Q3ts8e7ygvbfpe+mC9n72400uuj766Y83uaj+/jb2LmjubcSAp06W/b9a/huN83r5:A903"+CRLF)
AADD(_aArq,"^FO352,32^GFA,03456,03456,00036,:Z64:"+CRLF)
AADD(_aArq,"eJztlU2O1DAQhctYwjuyZOmb4DkKR+AEONIcjCAWbDlCEBfIqJHGEu4Ur6rsTgYxSi9GYkFbPZrq7pfPz/XjJrqt27qt/35FNx1q0pdjTeYrODweaj7kY837N4eSF1n5rgXhZwt4xiF4HfBHK/lCnheiYaXtcA6ayMzQsGPRRK7IM8tXot44olm")
AADD(_aArq,"dchKAyvHMpXGWPScsSDEbJ7AQ214XPzyCA/FIUVjy0Z4TlTP54vgzaiWceH7LqvG/sCeeHmbRi2alBPQnsBayg4VH7AkXw6L7hsVX+TKjXpDmSTmnjYMz+mJxStBMlIzzIJzSOIsviOVwcRJIUk74Xnd+impej/RRNLA0b5zup4YlaG6VQ00zzO")
AADD(_aArq,"vOT/VFA1rxT1Kkb+IDq58onDM0EpBb4+IkRQodpo3jzmvn1CecKZsfFMdVDsugHBgTjr6hOGbjSAErN44reGzPGTU/ysn3zc8TThqRy8ZxJd0bR9O9dk0ekc6Ln/R1UU0oobr1bxyq8ccfHPWT4eiSnxpP5gdu6pYfFk3PTx1Oxhmg2Thov/lSr")
AADD(_aArq,"xoeLT/Wud2Panq9KroSwStq02afYobQ0L1/amBJXvgm3U3dj2kufjwX1Zum9U/jdD/oxE0j/SN9iFnEMF78EFs/y+SOebRexRRIA/f8iEbmIk1WAJ0LX9rL/FC2+ZKpGDE7Ol+h6qv7oYxyTyy9kCdrRe1SwK1eDD/J5l2tDNXrvIPgausfRhSL")
AADD(_aArq,"3ht6JH1MC0N266imiCZZGeLs291iGusf4QwSVdP0e0yOs+78iD/uIyGlJC2I3F5F7yBz5vJda534/I/Gux748pyErvjJuUbjwnzM8S+kCdOx5ArPno+3cvVYc1v/Zv0GxEcq7Q==:219D"+CRLF)
AADD(_aArq,"^FO32,128^GFA,28672,28672,00112,:Z64:"+CRLF)
AADD(_aArq,"eJztXM2u5MZ1LprQrSwEMjtnQZF5gkBLGqJuy2+QN5gLZO8QyMJtmJ7mxQDWJhhtsxCsPIYXXtTFANEmCz/AIChhgEx2piABZoL2Zc73nSo2u+8djQBxOonThZlbZFcVT308VXX+qmjMJV3SJV3SeZIdTn9579s3VH3yyXGTSu87/NmFOsnc+PC")
AADD(_aArq,"YxqS9qXfTfT5NJt/LAyZvNpNceBTl90bKTGZSZ1BzN/XSSGhILbO5N0Yq2GnkvVRJUZyizJsaZdLE5Kw107PObHfTVAm93QR6e8n3JnGVPKGaeikzFelJzd0ktJLRJKCBG2lipQLupUqOYit/kkGeXE3OCr1K/rGbSNcm9TO+SX7OBQ7wJb6U3m")
AADD(_aArq,"1A7x700NFeaggdI8/GG9jIjTSRlj3u5UGkl8vPQq+WcheayVWg99RYb9qA71tBYIkz4uusA74N8eWOJSbZC9QO+PbJ3jpp4azjgyqhYyopS4HvqR2Izxl5TKD3M+KTwkxuvDzVSn9qlPhNn/ZD4qXMfNSDXiY9kxeC95mb0kizbeJTb+UReZ+ZK")
AADD(_aArq,"1Td4pXJS/utlI5mAL6qN3iMpp9jhG1NgbecuAT0rNticLnKpXeDdLgQJKRXDUIP9V7KX8m3pkt9Mlh5e7i3rdDrMEblejRNMiQj8H3gEjxG02uTjhGf0BMWSG+BL/EbefveLPAVXkam1Es/l78Z8DXy8yjjz1/LW8la+aVGN3Lik4fVwPcTZ/CY")
AADD(_aArq,"SM/updcF3g/pSW99O+PzLDP/4EgP+OTp9qXUtnhwicEtVwOGed5q5QHvqGFfOuD7FR7bBnqv+vR30pD4pDOgZ7zy72MPfDfA93ek19xIM9R7Ln8t8GXyvFpbpH0GdAWmXtpfNcTWAF8NdDdhCXjl7Ofkn+DDM/GcQfn3wQB8Bo/4Wum1Ad8XqE1")
AADD(_aArq,"8ctdoi7QvOVowFWTMFfK7E/xC7xeH0WKSF336m8g/0pMnDMq/YgA+LAnmK4xcU9fyrkDvOUezNCO92KIg9wwfnpXEVwLf9sA9k9w56e3MP8XXKv+KVsan4lN63TbgsxidGIigVwAfWhQFl0/SK0viJr62nUenSW9d+tk8Pr3S2yr/GunhqPh8xE")
AADD(_aArq,"f+ZZijxJdlSo8jrC4wObXXUgC+ZsAnheNMT/B92rdh/v0p0FP+FV3qJuJL7gbQaxudf5XtKRaE7RXpJcTXFFhKlJ4UAJ/UlMKtmWZ6vU+f9XF9waqaEwf5J6Nr0wNf4iK9ARCk1+lIfI20KjFjQb7OTOXDKChyU+cRn6ykfaBnb7391BGfLMu7Q")
AADD(_aArq,"fHtsOK6okzdbk98riW9QtfPEmum4/pS4k7WT+DblrJUR3yW+HLg853BY5Qe8Hngo1y4J70aC7/wL6P8o4jcgp7PDHrCXkPGyQpJbop8AOe3GeUf8dW2r7MDvln+WTPY22Eb8FXTEb4qJY4CK6o8Bask5V8hN+ixVAv4IIFNm4sYHAwbycKCeUJ8")
AADD(_aArq,"ThafKI9yMwoLI74E8i/gE/7lzwSHIz4uhIIPElJWYkdVYDMNoAd5B3oDBJ2IRhGGqA/+5dIs7WVCHei1th/C/BOtxC3nn33hMAIEnwgCwedyYAA9b5J74PPEZwYujyIosBgTX2tdxJc6qVSFGS99E+bE8WmsX84/GbmQjngde9CTN9AC5wbMu6b")
AADD(_aArq,"+orOx5gJC7FArUigFLvIvlWZ4DFM17W3fBfkX1r55/qUvwDQpywO9yXCckomUf0bnH+Ylih3WHHnZ6Z1cx/kH9pq4wlTA18z4DOSf4kt8k7xih8lbKl8T5b3iE2ZJtYxTrQTphPgK0uunycf1hfjiCkN8xcw/yq6Zf8k3mHTEB3qcZ+go8VH+GV")
AADD(_aArq,"0/K6mVKL6S9JzQO8IX5R/EYp89Lv8a8+pZH9bWDPhEn+FSKGKwptpKfA1WU5FHL1zqPX6A/BORIFOQ+ET4al2lJ0t4FeSfVGgh34P8K8wvhYFaVgGfKBUtRIAoPA0qK77GUlsTeoksayVYJXIzGaL8y4195igZuQSKiMrrBb484JP5Zz6SiiiTN")
AADD(_aArq,"xroQa2E7twEfJDvOeankcEMeorv1olIDPI9Q1HE13GxD/yTDrUL/UVWyztH/skMpKaYEJ8MmQ5zElAtdBT5K3i/dMkQ9JcU7aL+IqoOHxPw6WK/5F86829zC0WnwQwUpBl7ck18peovWCxHtLiWGtIaL19eXYoXWKeqnwm+21lfaoEvHWb9c1jo")
AADD(_aArq,"n/KbyHeUKb2Kcq7CAGyqMD4X+qftk6EDvc5gYdpG/bMwKR8Txr8skhEflGXhn+rX4F8u8h3rS80egzXQX0AP+jTwJYPo1lw6oVqM1/jt2lRgmEiPZAQP5SWMUYMRPOgX5cMEYyDYD/fEl8s6j/VzKz2eppL4crzDEvYCJznsB9DzT4VeW/10hL2")
AADD(_aArq,"wE1id6NpiP0xTAwloAz3P965ryNRjhbC0j+7JP9tvKB8wu6bpN1RF8h48oX2E1yAGodAb5V4Ab4N9dC/0GthHXhYXDOhoH4FfX4Ie8fUH+0/xWbH/IP9k9RB6BVcewSOsTEBvS3ocqXIvA6AL9t9efirU/pumDuyN9Dwnxzbgq2CwTv9MfOBflO")
AADD(_aArq,"9iP76apt8JDohTjjmV77RcMecNRVNN+zaZwNJS7VvFd7Bvj9IPsN/D/W5Z9pj9fkmXdEmX9GeexK4/K70UqvUZk50dludJ+ZnpZbu311kzvZ+dl96fdQo6yazN4II6Sfew7o8ds7ewey5Op/+AZkZfOxwK8ODCyRAzlPMC+lhKXdPvoGxtNMhgN")
AADD(_aArq,"oP83dL/sIM6hgu2wwW9EzCXZ/c8bHJ45uFLaURV9wnjCiZkLOc9/DyiXUKX3qF1BRe+6InTHm0QcpBqdNXLb4a2MK01OIC3LI70+hkfDDx0Dvej+htolIf4AujlVJa9oXsIluV0L/SGnCEWqNOT41qRRnowE2sWR3puxgfVOUG3qx7ZtxV9Eg4X")
AADD(_aArq,"jDdUScAH94Q0ErvKDk+Enq8+YThiIKx8ckf42o7Fyj8xuoOvVrRjJ7bLKDZWzBzLccF4Q0PfuIeXFwp5n/5Wnpj3PnUZnKQtfFUGTiVY8HhoHvjHYsXnYLsZ2gJNInp48lK6lDpmcCNJOS4Yb4DFQ+t+a+hUs6Opensn3YEJLPTojmeQhReIdAD")
AADD(_aArq,"flsWBHn18ii8RqOnn0isxBDVjOS5CvKFW675Wp6Hgo/Ga9w3gD+aasAoT8VWBf9HbQnpdGfGZoURsAcOUGewUKccF7ec2+qqbgA9k0jsBzwfCVsajGnoBOO0UX3ugJwOynvGZsdHYgvGaDbF8CPGGwi7wuauG4TUPqzYDPbo75eYm4Pso8K822Q")
AADD(_aArq,"Ffc8AnNqn9gnY6M/lRbXW4brWO8o/4UocgAzSBTocDfQERH+n9XOdfG0eL0jvgE5vUPid2zerYn/kdzPyDcZiVIJT4rdIb6O405i+EnuJ7pfz78Ihewb539G21iC1gLGlGZ1+BixBvMEf8K0v8BC9Pofissi3yL3mt/PuwmOnB9j/gKz28mehNR")
AADD(_aArq,"no1y3HBeMO1MUv+9QgyyM/e63Bo6QtAiuPzhfJvHi3EV83zDwE+YQF6o1nDclzkWAArZ47mX1ER3yvPuAPofUoycf4lXyr/tDjSW+DLPYYY8TEj/0pcMN5QRe8afOYyuRBkYMjL5CP5lx7jo38Y+PJxSQ9LL3zRDFWXWCxMyIgP77Ohgz2nL+Kw")
AADD(_aArq,"fsrsAL7XXpbLgI8+V0QR6VoJ66cWR/5l8MxDntVGPZYHfA3LG/U/HOQfaMOFIQIFLpE/eA25y6h8RnpYP3FxFeSfFj+Or0gd6GnWxPfZMN6QRPn3e5V/Hekh5oD/B3zqperVuwv+JQf55xA/iPiEf01Cepot6CHeIIJe5R/fJ71/4N8ePqxR+Ud")
AADD(_aArq,"6ea/4MsVXa/FM7zD/KtDzBen5Y3qINxi71/nXwWstjKFUTPYd4w6H+VcZnX9F5J95L8aPwJ/D+MywdQKEQlZH/tHrJ2nU+cceeCgQmH8jGjxdzL9ro+OzjvxjccRXHObfB9gPMQCfZk1cXxoTIpo6/4pqXyTYy0B8Q6OY5vnXGZ1/2xmftg70Fu")
AADD(_aArq,"vnCGCF4ivC/CsKXTnxhEbnX7kZ4TREkAGjH9ApTQK+MeD78IBvIR+KhXzoArBPNDusn4EjpfKvFHzym9CTAsg/LuSRf8kQaiPMFvDlB/4t5MO2QWxB7m80q2N5XatzO1P+ZcB3Lfeesd08yj+VD4gV8QL0UsQY3iT/RIwPZivdHTQ7yD/GGwbgA")
AADD(_aArq,"/9KrmdQBAuTfO0Q7rAH+Wd94N9ON8W0ZhvkPekt5Lsvpc+495qNsXxkvGHgjAL/QK+UMulg8pWoc7XyT+U7aC3xDcf4unn+iRqG2EKOZ6jaMusvRdRfesQEAj7putCDftZpcUkY4JXiYfRPntLN+NKlfiYaQu+xKiaemfEaX+gB3DL+nUpZjQkm")
AADD(_aArq,"Kw6CDNjY5BGwIP9UP8PzVP6lpOeP8C30T9G4bh0yxEckg30w65853kEB3XTL9UWDDNQ/k+EDnX9B/wzvlH+59eWDxfxb6NdiP4CeaNQhcyzHBeMNoofhGht3oL+8QOyoz2892HiNt6/6dbPEhwCFKXV1Mgv7YcvJjD6X6VAhO7EfZEWqfjrK23C")
AADD(_aArq,"MwRd07Hd22AnLh8rN9gOWxMHwgvgQ02Cx8i/sryK+jG4XBKFTzcI6v7CPDKMGnqLxNeJfIls84g6032AfeW7b4gVR7rjna2EfMfJAfKJ4/hFhomlCn07sv0BvN4UYvNSVv7T/BObB/vO6rER8YU/bwf6jfav45CV/A2CbMdVMy5f2rdnsuQsB2t")
AADD(_aArq,"uE6OlmFHrXCYqn/zKP4ENMI5nl+6PJ/n6Z6QXt993ix5CC/f7kzQ/79juLkX70naXrJ/v2Kqsm7vA4YzpspzpTOjO95EGY7N2muHnkbPTceemVb69ySf8zqb05L73Rn5XcWwTR6imdHbtnovfFmempnvb/LUEJ+ZVePlw7f/zglzek06Zh+0Tyc")
AADD(_aArq,"O/EZqDuhd1jO48sg4U7fUZvA8MQXvctwUxCrVxl5OZeFbEsNE0nbpWEwt7ooYdmefZh7ogol6IiYpsP9MkBW/REb5xyjQjsGWHZQCxW3ItU0EVqqFGLgjqYPDQVrXMUu75Uejj0wOz0BUFJhgosNVVfxl6kiC8J2xtJryS+Un3bDFoEfNqU+JQe")
AADD(_aArq,"tk8KoZAdJzs8Edtgn+zF/vFP5EkBnzrBpBD4dgg3AB82NFWO9HAAAvTy0FQaDHIJek/hzPDInj7YVYMgwrUYWSMM1CzwT48AwDmVcxfo32DPP45EAE7Vk3+16YLFF5rKr/I+0e5nsI69Zqf0xIgTA6ZiJ429Vf6ZSp0KeQ93WIuDEqPhkQjBhyM")
AADD(_aArq,"NBgbhJsHLykNT7PTi4Qicq6Dlx2w8oSd2UY+3fs+91L3yL+LL6e77rfl7/BF65N9P9H3WukFeKoamsIg/5/t8Da1y1Kw+oSejwGGQ0aNp75R/esSBGzq9sVvga4weiSj0SAPw5QGfNuX5iZeBHrYPxuw4MYggQP4AxpFBC/6VdNfW5t/NVWP0SE")
AADD(_aArq,"SmRxqATz1KWWyKqnp44FVPzyCz5oQegghikt7+kcDC/MOoR2FBd3STvMaZBhyJAP9+MQT+weAHPm3KqjwcgXMVQgiZe6B/NboRrX/FTYDmmH8NHZv/BASl0SMRpdn6wL804AtNpa1GLnCuoo/ZKb2Ofhh799ohXpMc86+jY6xIvoSjFEciwL+2D")
AADD(_aArq,"fzD1k7g06ZktSW9O8d7Zqf0atITfA7nUU7mX03H9PvmX/ArjkRwuWzNCT5tqi62jOcqQE+z01i+4kvvvvKFHWb+hfnXwXdBfEVlio78S4aILw34tCnwVbav9FyFiVl1Qk/3qUrPfZnen/KPjrX0efIZetE0yj9fn/AvNDUMYJQ8V4FnaHaKbxvw")
AADD(_aArq,"+UEWebfgX3DMCP8y4LOmKMm/xHczPkZsE20KfKXFfnmcqzAxy0/oBXzOj5mZxgP/6LhXfFn6a/ifcCSC/Ksj/16AnvygTRVfxnMVeIZmj+ADvbthKyv/fjH/Aj7hX55+Cu9YUSn/XBPmX8SnTcl7ngewZlA3IbI34Ot9LSvb/YF/pBf4h1M8aY8")
AADD(_aArq,"jEVKcuiLy7wUDDSY0NQxglDxXgWdodkqvC/h8U4hMO5l/yj9JCDcU9gX4JxBOxqc2Bf8aHFTkuQrSa78LH0Jlef9g/m1Nan90BX8VjkSARdQCjsanNjUMYGQ8V4HWmr1p/nmE+uzd8fxT/tlPLVyFRfoCxTJwZ/4pvoFNIRVFp6n03IGJ2SPzj+")
AADD(_aArq,"uLz3XmnM4/bBj/dQ73f5G8Iv+wa+IYnzY1PhwyqSYeNUT2KL47rJ/eFkYVlAfrp/3SKr1vUAx8yr+4fmpTzN0dD9EosL98HB+DCABmn6v8Kxb8ayj/0udXhuEG4INoPeWfNjU+BDAa00AeaXaKD0EEyL/BviwpCh/Kv+Sl1XDDL7UYWs5S/mlT8")
AADD(_aArq,"G9gsL7h0cdGs1P5AJXBY2Cm/6b4mgX/VL7f/iM0B6H3EYp1yz8jvhGfNsU7wOGBoNnUmp3Kd/QM+otP9nrZPNBfgM/xABmKS2o5S/0lNMVeGAY0Op4I6UJ2Qg9BhC2NgHt0stWQS8CXUT8z/3qV4oyBaKAs1pOPdYiozE0VX6YlHjuXsvShfhb1")
AADD(_aArq,"T+mk7RGT7R7on1ICetCstzjdkQZ8mwM+qShafqIBpxa7YBBqqh7RP3Pq14hY3kPVbnTtO9Kv+xGxrxq7eqQ40qvN/oAPTQ3pcS9M3o/Y6YDslJ4ddrQf4GjHGTjsf9qr/HPBfjAjgukdjkTsENBMvkKZ2g9kvTZNECMpZdbhnMjeemTdA/sh2kd")
AADD(_aArq,"i5KU8/eBznnnPD/aRGa90PuFIBKKaHmWbaZjtPzaVcdojoD96PTuhmT+hd7D/GlyKwab4ct1NBvvPbBG7LMKRiE4mrOI72H9simCTqarpTwMr3g3hCMVJwqk92rdluFzgU/u2b3OcacCuF5zuM+Yr4lvYt2yq+KrpP7Fc5feJZqfklva7XCbdg8")
AADD(_aArq,"Kjt/HILsJHK773Rvv9HSX31hqrpuTc9M7sdo9n4s6WTtfNd53eNJDfUbKn6+a7pnfm8aIx8Uu6pEu6pP9N6dHTDe9sebzhx5V6A50N+0yCfb8ZtRBnmvs16XlsX+G3lxws26+DfbjjptUWmy3X1VQcdO/cwZ4uFR/t+yl+amqzp7G7VsKHfDr99")
AADD(_aArq,"tJAfGrfc3sTdaLdffxazioJ/r5rbA312KrG/WTgH49HcGuH2M/r0vsYn1vCSZptoTY68NEZj5iLGar560Pr0MP2OH57CU4yF/xrGkICPe6PXC9ZfsCJ317qiE/5x+2FCLzgUMua9K64nbK5MeqYiPzjhkiT3WC+mL9akV7Oj27w20vNgn/6/ZBS")
AADD(_aArq,"OPe3dj6eskbKGN/it5eaUn0Q4B+dLKbASLHm/RXpFaTHby81C/7prt5Ab80dLO+rq6w+4Z/uWq5vzOzJWCkVtKtaeKyX/NNd2VvdXH3qAfxB9IiP315azj/ddY5Pt4SI5mr06Opsi5P5p/jwYSn9KM5qSUMNPjtZPxt1jd4Y+OWvVqTHUEP49tK")
AADD(_aArq,"Cf+H4APA9WRcf3ye/veSP+dfQmUiX3or08LUlg28vQb4f+Ed6lvTsqvTIP3jR4nckZ/7VJqXkS1fGN+g+Xt21ezT/rNFP4ayOj99e0sh54B/XlyzQoxd0pdTxIzH6jbPT9ZNbt98BvvRZT4914F+h8q/WCNpfr0uv0YMp6YxvIf+AD1+dXBffVu")
AADD(_aArq,"kp/yD/Gg3KjorPrzw+EUbRby/p17g0PqH6i6H+sjI+fmcQIRjln8YneDyC9oPgW3P9LMzHOCOIEJPi0/iE6p/AN+b9aQTzh9ET/Vq/vaTzT+MTPB5Be2Wbryv/cHxBv72k+DQ+ofYDgrpiKK2J733EJkqGCJV/IT6h9tFN2utn7FZLiLPgsFUb8")
AADD(_aArq,"YX4RLD/rKv2K+ufCQ/LjZF/IT6h9m2b9qlflZ49Pb4QAhDLkxBr0vs+c2td++i89L6PbDs3vXXt27fXuVmR3vdxrqyJ7/uEufya9N7+sHX9Szdvp9evSe+SLumSLumSLumSLumSLumSLumS/q+n/wZRrMXq:85C4"+CRLF)
AADD(_aArq,"^FO21,355^GB898,0,1^FS"+CRLF)
AADD(_aArq,"^PQ1,0,1,Y^XZ"+CRLF)

	AaDd(aCodEtq,_aArq)
	
	For nY:=1 To Len(aCodEtq)
		For nP:=1 To Len(aCodEtq[nY])
			MSCBWrite(aCodEtq[nY][nP])
		Next nP
	Next nY
	MSCBEND()
Endif


MSCBCLOSEPRINTER()

Return ( Nil )
