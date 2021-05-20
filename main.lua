LG = love.graphics
LM = love.mouse

function love.load()
    math.randomseed(os.time())

    windowWidth = LG.getWidth()
    windowHeight = LG.getHeight()

    gameFontHeight = 25
    gameFont = LG.newFont('fonts/Lemon-Regular.ttf', gameFontHeight)

    sprites = {}
    sprites.background = LG.newImage('sprites/sky.png')
    sprites.target = LG.newImage('sprites/target.png')
    sprites.crosshair = LG.newImage('sprites/crosshairs.png')

    target = {}
    target.radius = 50
    target.x = random(target.radius, windowWidth)
    target.y = random(target.radius, windowHeight)

    click = {}
    click.x = 0
    click.y = 0

    gameState = "idle"
    score = 0
    timer = 0
    levelTime = 15
end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = "result"
    end
end

function love.draw()
    LM.setVisible(true)

    LG.setFont(gameFont)
    LG.draw(sprites.background, 0, 0)

    drawTargetDependingOnState()

    -- Reset colors to default
    LG.reset()
end

function drawTargetDependingOnState()

    if gameState == "idle" then
        LG.printf("Click anywhere to begin!", 0, windowHeight / 2 - gameFontHeight, windowWidth, "center")
    elseif gameState == "play" then
        --LG.setColor(1, 0.0, 0.2)
        --LG.circle("fill", target.x, target.y, target.radius)
        LG.draw(sprites.target, target.x - target.radius, target.y - target.radius)

        LM.setVisible(false)
        LG.draw(sprites.crosshair, LM.getX() - 20, LM.getY() - 20)

        LG.setColor(.5, .2, 0.4)
        LG.printf("Score: " .. score, 20, 0, windowWidth, "left")
        LG.printf("Timer: " .. avoidDecimals(timer), 0, 0, windowWidth, "center")
    elseif gameState == "result" then
        LG.printf("Time over. Your score: " .. score, 0, windowHeight / 2 - gameFontHeight, windowWidth, "center")
    end
end

function love.mousepressed(x, y, button)
    click.x = x
    click.y = y

    if button == 1 and gameState == "play" then
        local distance = distanceBetween(target.x, target.y)
        calculateDistance(distance)
    elseif button == 1 and gameState == "idle" then
        gameState = "play"
        score = 0
        timer = levelTime
    elseif button == 1 and gameState == "result" then
        gameState = "idle"
    end
end

function avoidDecimals(number)
    return math.ceil(number)
end

function calculateDistance(distance)
    if target.radius - distance >= 0  then
        score = score + 1
        newTargetPosition()
    else
        score = score - 1
        newTargetPosition()
    end
end

function distanceBetween(targetX, targetY)
    return math.sqrt( (targetX - click.x)^2 + (targetY - click.y)^2 )
end

function newTargetPosition()
    target.x = random(target.radius, windowWidth)
    target.y = random(target.radius, windowHeight)
end

-- max = windowWidth or windowHeight
function random(radius, max)
    return math.random(radius, max - radius)
end

function printUsefulness()
    local leftOffset = 5
    local bottomOffset = windowHeight - 100

    love.graphics.setFont(love.graphics.newFont(15))
    love.graphics.setColor(.0, .0, .0)
    love.graphics.print('FPS: ' .. love.timer.getFPS(), leftOffset, bottomOffset)
    love.graphics.print('Width: ' .. windowWidth, leftOffset, bottomOffset + 20)
    love.graphics.print('Height: ' .. windowHeight, leftOffset, bottomOffset + 40)  
    love.graphics.print('Target X,Y: [' .. target.x .. ', ' .. target.y .. ']', leftOffset, bottomOffset + 60)
    love.graphics.print('Click X,Y: [' .. click.x .. ', ' .. click.y .. ']', leftOffset, bottomOffset + 80)
end