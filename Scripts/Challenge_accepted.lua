--<<Challenge Accepted, Legion commander script! By Bruninjaman>>
-- Version 1.1
-- 1 - Now you can't lose a duel.
-- 2 - How it works? Press "Key_configured" and make some destruction.
-- 3 - The combo (Press The Attack -> blink-> blademail -> mordiggian -> Abyssal -> BKB (if enable) )
-- 4 - Don't lose kill's, auto "Overwhelming Odds" is used when enemy is killable.(not yet)
-- 5 - Enjoy this script, and fell free to report any bugs.
--                          And thanks to use my script!
-------------------------------------------------------------------------------------------------------
-- Some Functions
-- 1 - This script will run only if you are if legion commander.
-- 2 - This script will show the equipments you're using in this combo.
-- 3 - This script will be upgraded until it be perfect.
-- Libraries
require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
--Config
config = ScriptConfig.new()
config:SetParameter("toggleKey", "F", config.TYPE_HOTKEY)
config:SetParameter("BlinkComboKey", "D", config.TYPE_HOTKEY)
config:Load()
-- Some Variables
local toggleKey     = config.toggleKey
local BlinkComboKey = config.BlinkComboKey
local registered	= false
local range 		= 1200
-- Others variables
local target	    = nil
local active	    = false
local BlinkActive = false
local key1 = false
local key2 = true
-- Visual variables
local legion = drawMgr:CreateFont("Font","Tahoma",14,550)
local ikillyou = drawMgr:CreateText(-50,-50,-1,"Marked for death!",legion); ikillyou.visible = false
-- Menu screen
local x,y = 1150, 50
local monitor = client.screenSize.x/1600
local F14 = drawMgr:CreateFont("F14","Franklin Gothic Medium",17,800) 
local statusText = drawMgr:CreateText(x*monitor,y*monitor,-1,"Legion Commander - BKB Disabled! - (" .. string.char(toggleKey) .. ")   AutoCombo - (" .. string.char(BlinkComboKey) .. ")",F14) statusText.visible = false
-- Marked for death visual --
function tick(tick)
	local target = targetFind:GetClosestToMouse(100)
	if target then
		ikillyou.visible = true
		ikillyou.entity = target
		ikillyou.entityPosition = Vector(0,0,target.healthbarOffset)
	else
		ikillyou.visible = false
	end
end
-- When you start the game (check hero)
function onLoad()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Legion_Commander then 
			script:Disable()
		else
			registered = true
			statusText.visible = true 
			script:RegisterEvent(EVENT_TICK,Main)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(onLoad)
		end
	end
end
--pressing a key
function Key(msg,code)
	if client.chat or client.console or client.loading then return end
    if IsKeyDown(toggleKey) then
		active = not active
		-- Active/desative bkb --
		if active then
			statusText.text = "Legion Commander - BKB Enable! - (" .. string.char(toggleKey) .. ")   AutoCombo - (" .. string.char(BlinkComboKey) .. ") "
			key2 = false
		else
			statusText.text = "Legion Commander - BKB Disabled! - (" .. string.char(toggleKey) .. ")   AutoCombo - (" .. string.char(BlinkComboKey) .. ") "
			key2 = true
		end
	end	
	
	if code == BlinkComboKey then
		BlinkActive = true
	end
	
end
--Start Combo
function Main(tick)
	-- Images
			local me = entityList:GetMyHero()
			if not me then return end
			local active = true
			local duel = me:GetAbility(4)
			local dagger = me:FindItem("item_blink")
			local bkb1 = me:FindItem("item_black_king_bar")
			local armlet1 = me:FindItem("item_armlet")
			local blademail1 = me:FindItem("item_blade_mail")
			local abyssal1 = me:FindItem("item_abyssal_blade") 
			local mjolnir1 = me:FindItem("item_mjollnir")
			local duel2 = drawMgr:CreateRect(-15,-70,25,20,0x000000ff) duel2.visible = false
			local blink2 = drawMgr:CreateRect(-45,-70,35,20,0x000000ff) blink2.visible = false
			local armlet2 = drawMgr:CreateRect(15,-70,35,20,0x000000ff) armlet2.visible = false
			local blademail2 = drawMgr:CreateRect(45,-70,35,20,0x000000ff) blademail2.visible = false
			local bkb2 = drawMgr:CreateRect(75,-70,35,20,0x000000ff) bkb2.visible = false
			local abyssal2 = drawMgr:CreateRect(105,-70,35,20,0x000000ff) abyssal2.visible = false
			local mjolnir2 = drawMgr:CreateRect(135,-70,35,20,0x000000ff) mjolnir2.visible = false
			mjolnir2.entity = me 
			mjolnir2.entityPosition = Vector(0,0,me.healthbarOffset)
			abyssal2.entity = me 
			abyssal2.entityPosition = Vector(0,0,me.healthbarOffset)
			duel2.entity = me 
			duel2.entityPosition = Vector(0,0,me.healthbarOffset)
			blink2.entity = me 
			blink2.entityPosition = Vector(0,0,me.healthbarOffset)
			armlet2.entity = me 
			armlet2.entityPosition = Vector(0,0,me.healthbarOffset)
			blademail2.entity = me 
			blademail2.entityPosition = Vector(0,0,me.healthbarOffset)
			bkb2.entity = me 
			bkb2.entityPosition = Vector(0,0,me.healthbarOffset)
	
			if duel.level > 0 then
				-- Duel image --
				duel2.textureId = drawMgr:GetTextureId("NyanUI/spellicons/legion_commander_duel")
				duel2.visible = active
				-- Mjolnir image --
				if mjolnir1 then
					mjolnir2.textureId = drawMgr:GetTextureId("NyanUI/items/mjollnir")
					mjolnir2.visible = active
				else
					armlet2.visible = false
				end
				-- BKB image --
				if bkb1 then
					bkb2.textureId = drawMgr:GetTextureId("NyanUI/items/black_king_bar")
					bkb2.visible = active
				else
					bkb2.visible = false
				end
				-- Armlet image --
				if armlet1 then
					armlet2.textureId = drawMgr:GetTextureId("NyanUI/items/armlet")
					armlet2.visible = active
				else
					armlet2.visible = false
				end
				-- Blademail image --
				if blademail1 then
					blademail2.textureId = drawMgr:GetTextureId("NyanUI/items/blade_mail")
					blademail2.visible = active
				else
					blademail2.visible = false
				end
				-- Abyssal Blade --
				if abyssal1 then
					abyssal2.textureId = drawMgr:GetTextureId("NyanUI/items/abyssal_blade")
					abyssal2.visible = active
				else
					abyssal2.visible = false
				end
				-- Blink dagger image --
				if dagger then
					blink2.textureId = drawMgr:GetTextureId("NyanUI/items/blink")
					blink2.visible = active
				else
					blink2.visible = false
				end
			end
		-- end of images
	if not SleepCheck() then return end
	-- variables
	local me = entityList:GetMyHero()
	if not me then return end
	
	local victim = targetFind:GetClosestToMouse(100)
    local blink = me:FindItem("item_blink")
	local attack = me:GetAbility(2)
	local duel = me:GetAbility(4)
	local distance = GetDistance2D(me,victim)
	local armlet = me:FindItem("item_armlet")
	local blademail = me:FindItem("item_blade_mail")
	local bkb1 = me:FindItem("item_black_king_bar")
	local abyssal =  me:FindItem("item_abyssal_blade")
	local mjolnir = me:FindItem("item_mjollnir")
	
	
	--SUPER COMBO
	if victim and BlinkActive and me.alive and distance < range then
        if blink and blink:CanBeCasted() then
			me:CastAbility(attack,me)
	        me:CastAbility(blink,victim.position)
			if (key1==key2) and bkb1 then
				me:SafeCastItem("item_black_king_bar")
			end
			if mjolnir then
				me:CastAbility(mjolnir,me)
			end
			if armlet then
				me:SafeCastItem("item_armlet")
			end
			if abyssal then
				me:CastAbility(abyssal,victim)
			end
			if blademail then
				me:SafeCastItem("item_blade_mail")
			end
		    me:CastAbility(duel,victim)
			Sleep(600)
		    BlinkActive = false
		else
			me:CastAbility(attack,me)
			if (key1==key2) and bkb1 then
				me:SafeCastItem("item_black_king_bar")
			end
			if abyssal then
				me:CastAbility(abyssal,victim)
			end
			if mjolnir then
				me:CastAbility(mjolnir,me)
			end
			if armlet then
				me:SafeCastItem("item_armlet")
			end
			if blademail then
				me:SafeCastItem("item_blade_mail")
			end
		    me:CastAbility(duel,victim)
			Sleep(600)
		    BlinkActive = false
		end
		Sleep(200)
	    return
	else
	    return
	end
	    
end

--END OF GAME 
function onClose()
	collectgarbage("collect")
	if registered then
	    statusText.visible = false
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		registered = false
	end
end

script:RegisterEvent(EVENT_CLOSE,onClose)
script:RegisterEvent(EVENT_TICK,onLoad)
script:RegisterEvent(EVENT_TICK,tick)
