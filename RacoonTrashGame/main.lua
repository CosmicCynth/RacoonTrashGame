function love.load()
    --loading the Libaries
    wf = require"Libaries/windfield"
    world = wf.newWorld(0,0,true)


    --Player table
    player = {}
    --Hitbox
    player.hitbox = world:newRectangleCollider(100,600-64,64,64)
    player.hitbox:setFixedRotation(true)
    
    --player stats
    player.speed = 300
    player.x = player.hitbox:getX() - 32
    player.y = player.hitbox:getY() - 32

    --Player bullets
    bullets = {}

    --Debugging

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

    --Checks for each bullet and updates their y axis up
    for i,bullet in ipairs(bullets) do
        bullet.hitbox:setLinearVelocity(0,-100)
        bullet.y = bullet.hitbox:getY() - 8
    end

    world:update(dt)
end

function love.draw()
    --Draws the player duh
    love.graphics.setColor(0,255,0)
    love.graphics.rectangle("fill",player.x,player.y,64,64)
    love.graphics.setColor(255,255,255)

    love.graphics.print("X: "..player.x)


    for i, bullet in pairs(bullets) do 
        love.graphics.draw(bullet.sprite,bullet.x,bullet.y)
    end
    world:draw()
end

function love.mousepressed(x,y,button)
    if button == 1 then
        spawnBullet(player.x,player.y,sprite)
    end
end

function spawnBullet(x,y,sprite)
    bullet = {}
    bullet.x = x
    bullet.y = y - 20
    bullet.hitbox = world:newRectangleCollider(x,bullet.y,16,16)
    bullet.sprite = love.graphics.newImage("images/pBullet.png")
    table.insert(bullets,bullet)
end