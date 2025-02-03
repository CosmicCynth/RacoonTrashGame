function love.load()
    --loading the Libaries
    wf = require"Libaries/windfield"
    world = wf.newWorld(0,0,true)

    --windfield stuff
    world:addCollisionClass("Racoons")
    world:addCollisionClass("Bullets")

    --Player table
    player = {}
    --Hitbox
    player.hitbox = world:newRectangleCollider(100,600-64,64,64)
    player.hitbox:setFixedRotation(true)
    
    --player stats
    player.speed = 300
    player.x = player.hitbox:getX() - 32
    player.y = player.hitbox:getY() - 32
    player.level = 1
    player.enemiesLeft = 1

    --Player bullets
    bullets = {}

    --Racoons
    racoons = {}
    --Levels
    levelLoader(player.level)

    --Debugging
    debug = "1123lkefkefk"
    
end

function love.update(dt)
    --Movement
    local vx,vy = player.hitbox:getLinearVelocity()

    if love.keyboard.isDown("a") and player.x > 0 then
        player.hitbox:setLinearVelocity(-player.speed, vy)
    elseif love.keyboard.isDown("d") and player.x < 800 - 64 then
        player.hitbox:setLinearVelocity(player.speed,vy)
    else
        player.hitbox:setLinearVelocity(0,vy)
    end

    --Updates the position of the player
    player.x = player.hitbox:getX() - 32
    player.y = player.hitbox:getY() - 32
    --Updates the position of the hitboxes

    --For each bullet present on screen
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet.hitbox:setLinearVelocity(0, -170)
        bullet.y = bullet.hitbox:getY() - 8
        for i = #racoons, 1, -1 do
            local racoon = racoons[i]
            if bullet.hitbox:enter("Racoons") then
                racoon.hitbox:destroy()
                racoon.hitbox = nil
                table.remove(racoons, i)
            end
        end
    

    end
    

    --Checks and makes sure that racoon hitbox and sprite macthes
    for i, racoon in pairs(racoons) do 
       racoon.y = racoon.hitbox:getY() - 32
    end


    world:update(dt)
end

function love.draw()
    --Draws the player duh
    love.graphics.setColor(0,255,0)
    love.graphics.rectangle("fill",player.x,player.y,64,64)
    love.graphics.setColor(255,255,255)

    --Draws the bullet
    for i, bullet in pairs(bullets) do 
        love.graphics.draw(bullet.sprite,bullet.x,bullet.y)
    end

    --Draws the racoon
    for i, racoon in pairs(racoons) do
        love.graphics.draw(racoon.sprite,racoon.x,racoon.y)
    end

    world:draw()
end

--Function to spawn bullet
function love.mousepressed(x,y,button)
    if button == 1 then
        spawnBullet(player.x,player.y,sprite)
    end
end

--spawning bullet
function spawnBullet(x,y,sprite)
    bullet = {}
    bullet.x = x + 20
    bullet.y = y - 20
    bullet.hitbox = world:newRectangleCollider(bullet.x,bullet.y,16,16)
    bullet.hitbox:setCollisionClass("Bullets")
    bullet.hitbox:setFixedRotation(true)
    bullet.sprite = love.graphics.newImage("images/pBullet.png")
    table.insert(bullets,bullet)
end

--Spawning enemy used in level designing
function spawnRacoon(x,y,sprite)
    racoon = {}
    racoon.x = x
    racoon.y = y
    racoon.hitbox = world:newRectangleCollider(racoon.x,racoon.y,64,64)
    racoon.hitbox:setFixedRotation(true)
    racoon.hitbox:setCollisionClass("Racoons")
    racoon.sprite = love.graphics.newImage("images/enemy.png")
    table.insert(racoons,racoon)
end

function levelLoader(level)
    if level == 1 then
        spawnRacoon(200,200,sprite)
        player.enemiesLeft = 1
    end
end
