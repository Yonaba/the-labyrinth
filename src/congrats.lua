--set language
cfg=io.open("cfg.dat","r")
lang=string.sub(cfg:read(),1,2)
cfg:close()

font=Font.createMonoSpaced()
font:setPixelSizes(10,10)
won = 0

score={}
for i=1,4 do
  file=io.open("temp/score"..i..".dat","r")
  score[i]=file:read("*n")
  file:close()
end

if (currentTime)/reduce <= lvl*1000 then
  if (currentTime/reduce) < score[lvl-1] then
    file=io.open("temp/score"..lvl..".dat","w")
    file:write(math.floor((currentTime)/reduce))
    file:close()
  end
end

score={}
for i=1,4 do
  file=io.open("temp/score"..i..".dat","r")
  score[i]=file:read("*n")
  file:close()
end
  
tables={}
if lang=="en" then
  for i=1,4 do 
    tables[i]="Map "..i.." : Best Time = "..score[i]
  end
elseif lang=="fr" then
  for i=1,4 do 
    tables[i]="Map "..i.." : Meilleur Temps = "..score[i]
  end
end


while true do
  screen:clear()
  key=Controls.read()
    
  for i=1,4 do
    screen:fontPrint(font,150,50*i,tables[i],Color.new(255,255,0))
  end
  if key:cross() then dofile("engine.lua") end
    
  screen.waitVblankStart()
  screen:flip()
end
