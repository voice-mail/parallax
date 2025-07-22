function love.load()
    -- Load layers in order
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    parallaxPosition = 0
    pause = false

    local layerFiles = love.filesystem.getDirectoryItems("put_layers_here")             
    table.sort(layerFiles)
    layers = {}
    for i, filename in ipairs(layerFiles) do
        layers[i] = {}
        if filename:match("%.png$") or filename:match("%.jpg$") then
            local path = "put_layers_here/" .. filename
            local success, img = pcall(love.graphics.newImage, path)
            if success then
                layers[i].image = img
            else
                layers[i].image = nil
                print("Failed to load image:", path)
            end
            layers[i].pos = 0

        end
    end
    
    -- Set layerWidth to the scaled width of the first image
    if #layers > 0 and layers[1].image then
        local scale = love.graphics.getHeight() / layers[1].image:getHeight()
        layerWidth = layers[1].image:getWidth() * scale
    else
        layerWidth = 0
    end
    print("Layer width:", layerWidth)
end

function love.update()
    local layerFiles = love.filesystem.getDirectoryItems("put_layers_here")             
    table.sort(layerFiles)
    for i, filename in ipairs(layerFiles) do
        if filename:match("%.png$") or filename:match("%.jpg$") then
            local path = "put_layers_here/" .. filename
            local success, img = pcall(love.graphics.newImage, path)
            if success then
                layers[i].image:release()
                layers[i].image = img
            else
                print("Failed to load image:", path)
            end
        end
        
        
        if pause == false then layers[i].pos = layers[i].pos - settings.scrollSpeed * (settings.speedMultiplier * i) end
        

        
        if layers[i].pos < -layerWidth then
            layers[i].pos = layers[i].pos + layerWidth
        end
    end
    
end

function love.draw()
    local scale = love.graphics.getHeight() / layers[1].image:getHeight()
    for i = 1, #layers do
        love.graphics.push()
        love.graphics.translate(layers[i].pos, 0) -- Move each layer based on its position
        love.graphics.draw(layers[i].image, 0, 0, 0, scale, scale) -- Draw each layer
        love.graphics.translate(layerWidth, 0)
        love.graphics.draw(layers[i].image, 0, 0, 0, scale, scale) -- Draw second instance for screen wrapping effect
        love.graphics.pop()
    end
end

-------------- Callback Functions --------------
function love.resize(w, h)
    settings.windowWidth = w
    settings.windowHeight = h
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        if pause == true then
            pause = false
        else
            pause = true
        end
    end
end

-------------- Helper Functions --------------

function printTable(table)
    for key, value in pairs(table) do
        print(key, value)
    end
end
