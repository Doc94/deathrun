include("sh_mapvote.lua")

MV.Nominations = {}
net.Receive("MapvoteSyncNominations", function()
	MV.Nominations = table.Copy( net.ReadTable() )
	MV:RepopulateMapList()
end)

function MV:IsMapNominated( mapname )
	if table.HasValue(MV.Nominations, mapname) then
		return true
	else
		return false
	end
end

function MV:NewDermaRow( tbl_cols, w, h, customColor, customColor2, doclick )
	local panel = vgui.Create("DPanel")
	panel:SetSize(w,h)
	panel.tbl_cols = tbl_cols
	panel.customColor = customColor

	function panel:Paint(w,h)

		surface.SetDrawColor( customColor or DR.Colors.Turq )
		surface.DrawRect(0,0,w,h)

		--surface.SetDrawColor( customColor ~= nil and HexColor("#303030",80) or Color(0,0,0,0) )
		surface.DrawRect(0,0,w,h)

	end

	local columns = tbl_cols

	for i = 1, #columns do
		local k = i-1
		local align = 0.5

		if i <= 1 then align = 0 end
		if i >= #columns then align = 1 end

		local label = vgui.Create("DLabel", panel)
		label:SetText( columns[i] )
		label:SetTextColor( customColor2 or DR.Colors.Clouds )
		label:SetFont("deathrun_derma_Small")
		label:SizeToContents()
		label:SetPos( #columns > 1 and 4+(k * ((panel:GetWide()-8)/(#columns-1)) - label:GetWide()*align) or (panel:GetWide()-8)/2 - label:GetWide()/2, panel:GetTall()/2 - label:GetTall()/2 - 1 )

		--draw.SimpleText( , "deathrun_derma_Small", k * (w/(#columns-1)),h/2, , align , TEXT_ALIGN_CENTER )
	end

	-- clickable
	local btn = vgui.Create("DButton", panel)
	btn:SetSize( panel:GetSize() )
	btn:SetPos(0,0)
	btn:SetText("")
	function btn:Paint() end
	btn.DoClick = doclick or function() end

	return panel
end

function MV:OpenFullMapList( maps )
	local frame = vgui.Create("deathrun_window")
	frame:SetSize(480, 480*1.618 - 44) -- GOLDEN RATIO FIBONACCI SPIRAL OMG
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Map List")

	local panel = vgui.Create("DPanel", frame)
	panel:SetPos(4,32)
	panel:SetSize( frame:GetWide() - 4, frame:GetTall() - 44 )

	function panel:Paint(w,h)
		
	end

	local scr = vgui.Create("DScrollPanel", panel)
	scr:SetSize(panel:GetWide(), panel:GetTall())
	scr:SetPos(0,0)

	local vbar = scr:GetVBar()
	vbar:SetWide(4)

	function vbar:Paint(w,h)
		surface.SetDrawColor(0,0,0,100) 
		surface.DrawRect(0,0,w,h)
	end
	function vbar.btnUp:Paint() end
	function vbar.btnDown:Paint() end
	function vbar.btnGrip:Paint(w, h)
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,w,h)
	end

	local dlist = vgui.Create("DIconLayout", scr)
	dlist:SetSize(panel:GetWide(), 1500)
	dlist:SetPos(0,0)

	dlist:SetSpaceX(0)
	dlist:SetSpaceY(4)

	dlist.maps = maps

	MV.AllMapsListList = dlist

	MV:RepopulateMapList()
end

function MV:RepopulateMapList()
	if MV.AllMapsListList then
		local dlist = MV.AllMapsListList
		local maps = dlist.maps
		dlist:Clear()
		dlist:Add( MV:NewDermaRow({"Click on a map to see options!"}, dlist:GetParent():GetParent():GetWide()-4, 24 ) )
		for i = 1,#maps do
			local mapderma = MV:NewDermaRow({maps[i] or "Error.", MV:IsMapNominated( maps[i] ) and "Nominated!" or "" }, dlist:GetParent():GetParent():GetWide()-8, 24, DR.Colors.Clouds, DR.Colors.Turq,
				function( self )
					local map = self:GetParent().mapname

					local menu = vgui.Create("DMenu")
					local nominate = menu:AddOption("Nominate map for voting")
					nominate:SetIcon("icon16/lightbulb.png")
					nominate.mapname = map
					function nominate:DoClick()
						RunConsoleCommand("mapvote_nominate_map",self.mapname)
					end

					menu:Open()
				end
			)
			mapderma.mapname = maps[i]
			dlist:Add( mapderma )
		end
	end
end

MV.AllMaps = {}

net.Receive("MapvoteSendAllMaps", function(len, ply)
	local data = net.ReadTable()
	MV:OpenFullMapList( data.maps )
end)

MV.Active = false
MV.VotingMapList = {}

-- actual voting menu place
function MV:OpenVotingPanel()

	local frame = vgui.Create("deathrun_window")
	frame:SetSize(256*1.618 + 4, (MV.MaxMaps*24) + (MV.MaxMaps-1)*4 + 44) -- GOLDEN RATIO FIBONACCI SPIRAL OMG
	frame:CenterHorizontal()
	frame:CenterVertical()
	frame:MakePopup()
	frame:SetTitle("Mapvote")

	MV.VotingPanelDerma = frame

	local panel = vgui.Create("DPanel", frame)
	panel:SetPos(4,32)
	panel:SetSize( frame:GetWide() - 8, frame:GetTall() - 44 )

	function panel:Paint(w,h)
		
	end

	local dlist = vgui.Create("DIconLayout", panel)
	dlist:SetSize(panel:GetWide(), 1500)
	dlist:SetPos(0,0)

	dlist:SetSpaceX(0)
	dlist:SetSpaceY(4)

	MV.VotingPanelDermaList = dlist
	MV:RefreshVotingPanel()
end

function MV:RefreshVotingPanel()
	if MV.VotingPanelDermaList then
		local dlist = MV.VotingPanelDermaList
		dlist:Clear()

		-- get the winning map--
		local win = ""
		local winvotes = 0
		for k,v in pairs(MV.VotingMapList) do
			if v > winvotes then
				winvotes = v
				win = k
			end
		end

		--if win == "" then win = table.Random( MV.VotingMapList )

		for k,v in pairs(MV.VotingMapList) do
			dlist:Add(MV:NewDermaRow({k or 0,v or 0}, dlist:GetWide(), 24, k == win and DR.Colors.Turq or DR.Colors.Clouds, k == win and DR.Colors.Clouds or DR.Colors.Turq))
		end
	end
end

net.Receive("MapvoteUpdateMapList", function()
	MV.VotingMapList = net.ReadTable()
	MV:RefreshVotingPanel()
	print("Updatate the memes")
end)

net.Receive("MapvoteSetActive", function()
	MV.Active = tobool(net.ReadBit())

	if MV.Active then MV:OpenVotingPanel() end
	MV.VotingMapList = net.ReadTable()
	MV.TimeLeft = net.ReadFloat()
	MV:RefreshVotingPanel()
end)


timer.Create("MapvoteCountdownTimer", 0.2, 0, function()
	if MV.Active == true then
		MV.TimeLeft = MV.TimeLeft - 0.2
		if IsValid(MV.VotingPanelDerma) then
			
			MV.VotingPanelDerma:SetTitle( "Mapvote - "..string.ToMinutesSeconds(MV.TimeLeft) )
		end
		if MV.TimeLeft < 0 then
			MV.TimeLeft = 0
		end
	end
end)