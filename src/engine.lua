--set language
cfg=io.open("cfg.dat","r")
lang=string.sub(cfg:read(),1,2)
cfg:close()

--set messages
--font=Font.createMonoSpaced()
--font:setPixelSizes(12,12)
text={}
text["fr"]="Plus de Temps !"
text["en"]="Time is Over !"

--choose automatically the map
file=io.open("temp/lvl.txt","r")
lvl=file:read("*n")
file:close()
if lvl < 1 then lvl=1 
elseif lvl>4 then lvl=4 
end

--loads map from file
dofile("maps/map"..lvl..".map")

map_width  = 11
map_height = table.getn(map)

--screen  size
screenx  = 480
screeny  = 272

--background
background=Image.createEmpty(44,44)
background:clear(Color.new(255,100,100))

--set field of View
fov  = 60 
larg   = 5
zoom      = 135
ray_rez = 0.06
   
--others sets
fps = math.ceil(screenx / larg)
aps = fov / fps
pibt = (math.pi / 180)
fovbt = (fov / 2)
    
-- generates player variables
moving_speed  = 0.3
rotating_speed   = 22
playerX = mapInitX
playerY = mapInitY
player_ang = mapInitAng
target=255
    
--the next phase is create a custom function which returns 1,else player's current position
function locate(x, y)
  x = math.floor(x)
  y = math.floor(y)
  if (x < 1 or y < 1) or (x > map_width or y > map_height) then return 1 end
  return map[y][x]
end
    
--Now raycasting  can be done
function raycasting(x, y, angle)
  dist = 0
  dx = ray_rez*math.cos(angle * pibt) 
  dy = ray_rez*math.sin(angle * pibt) 
  repeat
    x = x + dx
    y = y + dy
    dist = dist + ray_rez
    collision = locate(x, y)
    if (collision ~= 0) then break end
  until (false)
  return dist, collision
end

--minutor
clock=Timer.new()
clock:start()
in_game=true
message=50
reduce=100
main=true

while main do
  currentTime = clock:time()

   --Enables Pad & Joystick
  key = Controls.read()
  ax=key:analogX()
  ay=key:analogY()


  --temporarily position
  ox = playerX
  oy = playerY

  --draws the background:ground & sky
  screen:clear(Color.new(0,250,0))
  screen:fillRect(0,0,480,136,Color.new(50,50,255))

  if in_game then
    --Enables Player Moves
    if key:up() or ay<-80 then 
      playerX = playerX + math.cos(player_ang * pibt) * moving_speed
      playerY = playerY + math.sin(player_ang * pibt) * moving_speed
    elseif key:down() or ay>80  then
      playerX = playerX - math.cos(player_ang * pibt) * moving_speed
      playerY = playerY - math.sin(player_ang * pibt) * moving_speed
    end
    if key:right() or ax>80 then
      player_ang = (player_ang + rotating_speed) % 360
    elseif key:left() or ax<-80 then
      player_ang = (player_ang + 360 - rotating_speed) % 360
    end
  end

  --sets collisions when player hits a wall (O)
  if (locate(playerX, playerY) ~= 0) then
    playerX = ox
    playerY = oy
  end

  --raycast stuffs 
  sx = 0
  angle = player_ang - fovbt
  ray_len = 0
  collision = 0
  h = 0
  wall = 0
  for s = 1, fps do
    ray_len, collision = raycasting(playerX, playerY, angle)
    ray_len = ray_len *  math.cos((player_ang - angle) * pibt)
    h = math.floor(zoom / ray_len)
    wall = math.floor(136 - h / 2)
    if (wall < 0) then  h = h + wall  wall = 0  end
    if (wall + h > screeny) then h = screeny - wall end
    screen:fillRect(sx, wall, larg, h, Color.new(100,100,100))    
    sx = sx + larg
    angle = angle + aps
  end

  if math.floor(playerX) == 5 or math.floor(playerX) == 6 then
    if math.floor(playerY)>= map_height then
      main=false
      lvl=lvl+1
      file=io.open("temp/lvl.txt","w")
      file:write(lvl)
      file:close()
      dofile("congrats.lua")
    end
  end

  if (currentTime)/reduce>= lvl*1000 then 
    in_game=false 
    screen:print(240-((string.len(text[lang])*8)/4),136,text[lang],Color.new(255,255,255))
    message=message-1
    if message <= 0 then 
      main=false 
      dofile("congrats.lua")
    end
  end

  screen:print(410,10,"Map  "..lvl.."/4",Color.new(255,0,0))
  if lang=="en" then
    if lvl*1000-(currentTime)/reduce >= 0 then 
      screen:print(300,25,"Time Remaining :"..math.ceil(lvl*1000-(currentTime)/reduce),Color.new(0,255,0))
    else screen:print(330,25,"Time Remaining :"..0,Color.new(0,255,0))
    end
  elseif lang=="fr" then
    if lvl*1000-(currentTime)/reduce >= 0 then 
      screen:print(300,25,"Temps Restant :"..math.ceil(lvl*1000-(currentTime)/reduce),Color.new(0,255,0))
    else screen:print(330,25,"Temps Restant :"..0,Color.new(0,255,0))
    end  
  end

  screen:blit(0,10,background)
  screen:fillRect(math.floor(playerX)*4,10+math.floor(playerY)*4*(11/map_height),2,2,Color.new(255,255,0))
  screen:fillRect(20,10+(44)-4,5,5,Color.new(0,target,0))
  
  screen.waitVblankStart()
  screen.flip()
end




