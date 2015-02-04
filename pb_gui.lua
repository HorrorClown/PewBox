--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 28.01.2014 - Time: 10:55
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
local x, y = guiGetScreenSize()

function pb.createGui()
	pb.gui = {}
	pb.gui.button = {}
	pb.gui.label = {}
	pb.gui.radioButton = {}
	pb.gui.edit = {}

	pb.gui.window = guiCreateWindow(x-400, y-180, 400, 180, "PewBox", false)
	guiSetVisible(pb.gui.window, false)
    guiWindowSetSizable(pb.gui.window, false)
    guiWindowSetMovable(pb.gui.window, false)

	guiCreateLabel(10, 20, 100, 20, "State:", false, pb.gui.window)
	guiCreateLabel(10, 40, 100, 20, "Objects:", false, pb.gui.window)

	pb.gui.label[1] = guiCreateLabel(110, 20, 100, 20, "Disabled", false, pb.gui.window)
	pb.gui.label[2] = guiCreateLabel(110, 40, 100, 20, "-", false, pb.gui.window)
		
	pb.gui.button[1] = guiCreateButton(280, 25, 100, 20, "Toggle", false, pb.gui.window)
	pb.gui.button[2] = guiCreateButton(280, 50, 100, 20, "Undo", false, pb.gui.window)
	pb.gui.button[3] = guiCreateButton(280, 75, 100, 20, "Clear", false, pb.gui.window)
	pb.gui.button[4] = guiCreateButton(280, 145, 100, 20, "Export", false, pb.gui.window)
	pb.fCall[pb.gui.button[1]] = {pb.toggle}
	pb.fCall[pb.gui.button[2]] = {pb.undo}
	pb.fCall[pb.gui.button[3]] = {pb.clear}
	pb.fCall[pb.gui.button[4]] = {function() guiSetVisible(pb.gui.exportWindow, true) guiSetEnabled(pb.gui.window, false) end}
	
	--Info labels
	guiCreateLabel(10, 125, 300, 20, "Press 'ctrl + r' to add a selected object!", false, pb.gui.window)
	guiCreateLabel(10, 145, 300, 20, "GitHub: http://github.com/HorrorClown/PewBox", false, pb.gui.window)
	
	--QueryWindow
	pb.gui.exportWindow = guiCreateWindow(x/2-250/2, y/2-150/2, 250, 150, "Export", false)
    guiSetVisible(pb.gui.exportWindow, false)
    guiWindowSetSizable(pb.gui.exportWindow, false)
	pb.gui.radioButton[1] = guiCreateRadioButton(10, 20, 100, 20, "InGame export", false, pb.gui.exportWindow)
	pb.gui.radioButton[2] = guiCreateRadioButton(10, 45, 200, 20, "Export as xml file", false, pb.gui.exportWindow)
	pb.gui.radioButton[3] = guiCreateRadioButton(10, 70, 200, 20, "Export as lua script", false, pb.gui.exportWindow)
	pb.gui.edit[1] = guiCreateEdit(10, 110, 100, 20, "", false, pb.gui.exportWindow)
	pb.gui.button[5] = guiCreateButton(130, 110, 100, 20, "Export", false, pb.gui.exportWindow)
    pb.gui.button[6] = guiCreateButton(220, 25, 20, 20, "X", false, pb.gui.exportWindow)
	pb.fCall[pb.gui.button[5]] = {pb.doExport}
	pb.fCall[pb.gui.button[6]] = {pb.cancelExport}
end

function pb.doExport()
	local fileName = guiGetText(pb.gui.edit[1])
	if (not fileName) or (fileName == "") then outputChatBox("Please enter a valid file/table name!") return end
	if guiRadioButtonGetSelected(pb.gui.radioButton[1]) then
		pb.exportGUI(fileName)
	elseif guiRadioButtonGetSelected(pb.gui.radioButton[2]) then
		pb.doExportXML(fileName)
	elseif guiRadioButtonGetSelected(pb.gui.radioButton[3]) then
		pb.doExportScript(fileName)
    end

    guiSetVisible(pb.gui.exportWindow, false)
    guiSetEnabled(pb.gui.window, true)
end

function pb.cancelExport()
    guiSetVisible(pb.gui.exportWindow, false)
    guiSetEnabled(pb.gui.window, true)
end

function pb.setState(sText)
	guiSetText(pb.gui.label[1], sText)
end

function pb.setObjectCount(nCount)
	guiSetText(pb.gui.label[2], nCount)
end

addEventHandler("onClientGUIClick", root,
    function(btn, st)
        if btn ~= "left" or st ~= "up" then return end
        local fCall = pb.fCall[source]
        if fCall and fCall[1] then
            fCall[1](fCall[2])
        end
    end
)