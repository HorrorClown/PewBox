--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 28.01.2014 - Time: 10:55
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
pb = {}
pb.items = {}
pb.enabled = false
pb.selectedObject = false
pb.fCall = {}

addEventHandler("onClientClick", root,
    function(btn, st, _, _, _, _, _, element)
        if btn ~= "left" or st ~= "down" then return end

        if isElement(element) and getElementType(element) == "object" then
            pb.selectedObject = element
        end
    end
)

bindKey("r", "down",
    function()
        if getKeyState("lctrl") then
            pb.addSelectedItem()
        end
    end
)

bindKey("o", "down",
    function()
        if getKeyState("lctrl") then
            local v = guiGetVisible(pb.gui.window)
            guiSetVisible(pb.gui.window, not v)
        end
    end
)

function pb.addSelectedItem()
    if not pb.selectedObject then return end
    if not pb.enabled then return end
    local id = getElementModel(pb.selectedObject)
    local x, y, z = getElementPosition(pb.selectedObject)
    local rx, ry, rz = getElementRotation(pb.selectedObject)
    local scale = getObjectScale(pb.selectedObject)
    local doubleSided = isElement(pb.selectedObject)
    local collisions = getElementCollisionsEnabled(pb.selectedObject)
    local dim = getElementDimension(pb.selectedObject)
    table.insert(pb.items, {id = id, element = pb.selectedObject, x = x, y = y, z = z, rx = rx, ry = ry, rz = rz, scale = scale, ds = doubleSided, col = collisions, dim = dim})
    setElementDimension(pb.selectedObject, 1337)
    pb.selectedObject = false
    pb.setObjectCount(#pb.items)
end

function pb.toggle()
    pb.enabled = not pb.enabled
    pb.setState(pb.enabled and "Enabled" or "Disabled")
end

function pb.undo()
    local lID = #pb.items
    if lID == 0 then return end
    setElementDimension(pb.items[lID].element, pb.items[lID].dim)
    table.remove(pb.items, lID)
    pb.setObjectCount(#pb.items)
end

function pb.clear()
    for _, ob in ipairs(pb.items) do
        setElementDimension(ob.element, ob.dim)
    end
    pb.items = {}
    pb.setObjectCount(0)
end

function pb.doExportXML(sName)
    local file = xmlCreateFile(("export/%s-%s.xml"):format(pb.getDate(), sName), sName)
    if not file then outputChatBox("Invalid filename") return end
    for _, item in ipairs(pb.items) do
        local child = xmlCreateChild(file, "object")
        for _, key in ipairs({"id", "x", "y", "z", "rx", "ry", "rz", "scale", "ds", "col", "dim"}) do
            xmlNodeSetAttribute(child, key, tostring(item[key]))
        end
        --for itemKey, itemValue in pairs(item) do
        --    if itemKey ~= "element" then
        --	    xmlNodeSetAttribute(child, itemKey, tostring(itemValue))
        --    end
        --end
    end
    xmlSaveFile(file)
    xmlUnloadFile(file)
end

function pb.doExportScript(sName)
    local file = fileCreate(("export/%s-%s.lua"):format(pb.getDate(), sName))
    fileWrite(file, ("%s = {\n"):format(sName))
    for i, item in ipairs(pb.items) do
        if i < #pb.items then
            fileWrite(file, ("\t{id = %s, x = %s, y = %s, z = %s, rx = %s, ry = %s, rz = %s, scale = %s, ds = %s, col = %s, dim = %s},\n"):format(item.id, item.x, item.y, item.z, item.rx, item.ry, item.rz, item.scale, tostring(item.ds), tostring(item.col), item.dim))
        else
            fileWrite(file, ("\t{id = %s, x = %s, y = %s, z = %s, rx = %s, ry = %s, rz = %s, scale = %s, ds = %s, col = %s, dim = %s}\n"):format(item.id, item.x, item.y, item.z, item.rx, item.ry, item.rz, item.scale, tostring(item.ds), tostring(item.col), item.dim))
            fileWrite(file, "}")
            fileClose(file)
        end
    end
end

function pb.exportGUI(sName)
    outputChatBox("Sry, not ready yet :C")
end

function pb.getDate()
    local time = getRealTime()
    return (("%04d_%02d_%02d"):format(time.year+1900, time.month, time.monthday))
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        pb.createGui()
    end
)