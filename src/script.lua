--set language
cfg=io.open("cfg.dat","r")
lang=string.sub(cfg:read(),1,2)
cfg:close()

--set messages
font=Font.createMonoSpaced()
font:setPixelSizes(15,15)
menu={}
menu["en"]={"Play","Francais","Quit"}
menu["fr"]={"Jouer","English","Quitter"}

function drawrec(x1,x2,y1,y2,a)
	screen:drawLine(x1,y1,x2,y1,Color.new(a,a,a))
	screen:drawLine(x1,y1,x1,y2,Color.new(a,a,a))
	screen:drawLine(x1,y2,x2,y2,Color.new(a,a,a))
	screen:drawLine(x2,y1,x2,y2,Color.new(a,a,a))
end

a=125
oldkey=Controls.read()
select=1

dofile("core.lua")
