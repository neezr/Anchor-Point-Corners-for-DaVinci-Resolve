-- ~ Anchor Point Corners ~
-- created by nizar / version 1.0
-- contact: http://twitter.com/nizarneezR

-- Usage:
-- Execute this script from DaVinci Resolve's dropdown menu (Workspace > Scripts)
-- Select a video clip on your Edit page and "pin" its Anchor Point to a corner or side of the screen with one of the buttons in the panel.
-- Note: Keyframes are sadly not supported by this script, because they are not callable from the API

-- Install:
-- Copy this .lua-file into the folder "%appdata%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts\Edit"

local ui = fu.UIManager
local disp = bmd.UIDispatcher(ui)


win = disp:AddWindow(
	{
		ID = "WinAnchorPointCorners",
		WindowTitle = "Nizar's Anchor Point Corners",
		Geometry = { 100,100,315,100 },
		Composition = comp,

		ui:VGroup
		{
			ID = "root",
			ui:HGroup
			{
				Weight = 0,

				ui:Button{ ID = "button_up_left", Text = "\u{2196}" },
				ui:Button{ ID = "button_up", Text = "\u{2191}" },
				ui:Button{ ID = "button_up_right", Text = "\u{2197}" },

			},
			ui:HGroup
			{
				Weight = 0,

				ui:Button{ ID = "button_left", Text = "\u{2190}" },
				ui:Button{ ID = "button_center", Text = "\u{2B24}" },
				ui:Button{ ID = "button_right", Text = "\u{2192}" },

			},
			ui:HGroup
			{
				Weight = 0,
				ui:Button{ ID="button_down_left", Text = "\u{2199}" },
				ui:Button{ ID="button_down", Text = "\u{2193}" },
				ui:Button{ ID="button_down_right", Text = "\u{2198}" },
			},
		},
	})

itm = win:GetItems()

function win.On.button_up_left.Clicked(ev)
	setAnchorPointToCorner("up_left")
end

function win.On.button_up.Clicked(ev)
	setAnchorPointToCorner("up")
end

function win.On.button_up_right.Clicked(ev)
	setAnchorPointToCorner("up_right")
end

function win.On.button_left.Clicked(ev)
	setAnchorPointToCorner("left")
end

function win.On.button_center.Clicked(ev)
	setAnchorPointToCorner("center")
end

function win.On.button_right.Clicked(ev)
	setAnchorPointToCorner("right")
end

function win.On.button_down_left.Clicked(ev)
	setAnchorPointToCorner("down_left")
end

function win.On.button_down.Clicked(ev)
	setAnchorPointToCorner("down")
end

function win.On.button_down_right.Clicked(ev)
	setAnchorPointToCorner("down_right")
end



function win.On.OK.Clicked(ev)
	disp:ExitLoop()
end

function win.On.WinAnchorPointCorners.Close(ev)
	disp:ExitLoop()
end

-- functions


function setAnchorPointToCorner(direction)--'up_left', 'up', 'up_right', 'left', 'center', 'right', 'down_left', 'down', 'down_right'
	timeline = resolve:GetProjectManager():GetCurrentProject():GetCurrentTimeline()

	selected_edit_clip = timeline:GetCurrentVideoItem() --video item currently under playhead, not necessarily in selection

	TIMELINE_HEIGHT = tonumber(timeline:GetSetting()["timelineOutputResolutionHeight"])
	TIMELINE_WIDTH = tonumber(timeline:GetSetting()["timelineOutputResolutionWidth"])


	if(direction == "left")
	then
		--left
		selected_edit_clip:SetProperty("AnchorPointX", -1*(TIMELINE_WIDTH/2))
		selected_edit_clip:SetProperty("AnchorPointY", 0)
	elseif(direction == "right")
	then
		--right
		selected_edit_clip:SetProperty("AnchorPointX", TIMELINE_WIDTH/2)
		selected_edit_clip:SetProperty("AnchorPointY", 0)
	elseif(direction == "down")
	then
		--down
		selected_edit_clip:SetProperty("AnchorPointX", 0)
		selected_edit_clip:SetProperty("AnchorPointY", -1*(TIMELINE_HEIGHT/2))
	elseif(direction == "up")
	then
		--up
		selected_edit_clip:SetProperty("AnchorPointX", 0)
		selected_edit_clip:SetProperty("AnchorPointY", TIMELINE_HEIGHT/2)
	elseif(direction == "center")
	then
		--center
		selected_edit_clip:SetProperty("AnchorPointX", 0)
		selected_edit_clip:SetProperty("AnchorPointY", 0.000001)
	elseif(direction == "up_left")
	then
		--up_left
		selected_edit_clip:SetProperty("AnchorPointX", -1*(TIMELINE_WIDTH/2))
		selected_edit_clip:SetProperty("AnchorPointY", TIMELINE_HEIGHT/2)
	elseif(direction == "up_right")
	then
		--up_right
		selected_edit_clip:SetProperty("AnchorPointX", TIMELINE_WIDTH/2)
		selected_edit_clip:SetProperty("AnchorPointY", TIMELINE_HEIGHT/2)
	elseif(direction == "down_left")
	then
		--down_left
		selected_edit_clip:SetProperty("AnchorPointX", -1*(TIMELINE_WIDTH/2))
		selected_edit_clip:SetProperty("AnchorPointY", -1*(TIMELINE_HEIGHT/2))
	elseif(direction == "down_right")
	then
		--down_right
		selected_edit_clip:SetProperty("AnchorPointX", TIMELINE_WIDTH/2)
		selected_edit_clip:SetProperty("AnchorPointY", -1*(TIMELINE_HEIGHT/2))
	else
		print("--- Error in Anchor Point Corners: Corner position was not selected. ---")
	end
end


win:Show()

disp:RunLoop()

win:Hide()
