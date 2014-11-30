oldkey=Controls.read()
while true do
  screen:clear()-------------------------------------Index--------------------
  key=Controls.read()

  cfg=io.open("cfg.dat","r")
  lang=string.sub(cfg:read(),1,2)
  cfg:close()

  if select > 3 then select=1 elseif select < 1 then select = 3 end
  if key:up() and not oldkey:up() then 
    select=select-1 
  elseif key:down() and not oldkey:down() then 
    select=select+1 
  end
  if select==1 then drawrec(190,300,65-25,65+25,a)
    if key:cross() then dofile("engine.lua") end
  elseif select==2 then drawrec(190,300,65*2-25,65*2+25,a)
    if key:cross() and not oldkey:cross() then 
    cfg=io.open("cfg.dat","w")
      if lang=="en" then cfg:write("fr") 
      elseif lang=="fr" then cfg:write("en")
      end
      cfg:close()
    end
  elseif select==3 then drawrec(190,300,65*3-25,65*3+25,a)
    if key:cross() and not oldkey:cross() then
      if lang=="en" then System.message("Thanks for testing this!",0)
      elseif lang=="fr" then System.message("Merci d'avoir essaye ce jeu!",0)
      end
      file=io.open("temp/lvl.txt","r")
      file:write(1)
      file:close()
      System.Quit()
    end
  end
  
  for i=1,3 do 
    screen:fontPrint(font,240-((string.len(menu[lang][i])*8)/2),65*i,menu[lang][i],Color.new(255,0,0)) 
  end

  oldkey=key
  ---------------------------------------------------------------------------
  screen.waitVblankStart()
  screen.flip()
end




