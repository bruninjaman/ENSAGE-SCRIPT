--<<Legion commander V1.0D ✰ - by ☢bruninjaman☢>>--
--[[
☑ Reworked version.
☑ Some new functions and more performance.
☑ Fixed little bugs, FPS drops and more.
☛ This script do?
☑ Jump in enemy with blink dagger, use all itens and ultimate super fast.
☒ Auto use first skill when enemy is killable.
☑ Little text Menu, with mini manual.
☑ Show if enemy is on blink dagger range and your target.
********************************************************************************
♜ Change Log ♜
➩ V1.0D - Monday, March 9, 2015 - REMOVED AUTO DUEL(Because it isn't good.)  and OverHelmingOdds(Fix lag problem). Reworked itens Icons.
➩ V1.0C - Monday, March 2, 2015 - Increased speed of combo and Blink dagger will only be used if enemy is out of duel range. Added auto OverwhelmingOdds.
➩ V1.0B - Thursday, February 28, 2015 - Option for Low Resolution screen and Hidemessage option.
➩ V1.0A - Thursday, February 26, 2015 - New Reworked Version Released.
]]

-- ✖ Libraries ✖ --
require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.AbilityDamage")
require("libs.Animations")

-- ✖ config ✖ --
config = ScriptConfig.new()
config:SetParameter("toggleKey", "F", config.TYPE_HOTKEY)
config:SetParameter("BlinkComboKey", "D", config.TYPE_HOTKEY)
config:SetParameter("StopComboKey", "S", config.TYPE_HOTKEY)
config:SetParameter("lowResolution", false)
config:SetParameter("hidemessage", false)
config:Load()

local toggle = {
			config.toggleKey,       -- ➜ toggle Key            --  toggle[1]
			config.BlinkComboKey,   -- ➜ blink Combo Key       --  toggle[2]
			config.StopComboKey,    -- ➜ Stop Combo Key        --  toggle[3]
			config.lowResolution,   -- ➜ Low Resolution Option --  toggle[4]
			config.hidemessage,     -- ➜ Hide TXT              --  toggle[5]
}

-- Global Variables --
local target   = nil
local item     = nil
local skill    = nil
local me       = nil

local codes = {
	true,  -- codes[1]
	true,  -- codes[2]
	true,  -- codes[3]
	false, -- codes[4]
	false, -- codes[5]
	false, -- codes[6]
	false,  -- codes[7]
}
-- ✖ Menu screen ✖ --
local x,y            = 1150, 50
local monitor        = client.screenSize.x/1600
local F14            = drawMgr:CreateFont("F14","Franklin Gothic Medium",17,800) 
local F12            = drawMgr:CreateFont("F12","Franklin Gothic Medium",12,10)
local statusText     = drawMgr:CreateText(x*monitor,y*monitor,0xA4A4A4FF,"Finding Black King Bar - Blink Combo - (".. string.char(toggle[2]) ..")",F14) statusText.visible  = false
-- ➜ marked for death text
local legion         = drawMgr:CreateFont("Font","Fixedsys",14,550)
local ikillyou       = drawMgr:CreateText(-50,-50,-1,"Marked for death!",legion); ikillyou.visible = false
-- ➜ Images
local bkb3       = drawMgr:CreateRect(-17,-82,34,34,0xFFD700ff) bkb3.visible     = false
local bkb1       = drawMgr:CreateRect(-16,-80,45,30,0x000000ff) bkb1.visible     = false
local bkb2       = drawMgr:CreateRect(-16,-80,45,30,0x000000ff) bkb2.visible     = false
local blinkbg    = drawMgr:CreateRect(-19,-83,36,33,0x1C1C1Cff) blinkbg.visible  = false
local blink      = drawMgr:CreateRect(-16,-80,43,27,0x000000ff) blink.visible    = false

-- ✖ When you start the game (check hero) ✖ --
function onLoad()
	if PlayingGame() then
		me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Legion_Commander then 
			script:Disable()
		else
			if toggle[4] then
				statusText     = drawMgr:CreateText((x-150)*monitor,(y+10)*monitor,0xA4A4A4FF,"Finding Black King Bar - Blink Combo - (".. string.char(toggle[2]) ..")",F12) statusText.visible  = false
			end
			if toggle[5] then
				statusText.visible  = false
			else
				statusText.visible  = true 
			end
			codes[5] = true
			script:RegisterEvent(EVENT_TICK,Main)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(onLoad)
		end
	end
end

-- ✖ pressing 'F' or 'D' or 'S' ✖ --
function Key(msg,code)
	me = entityList:GetMyHero()
	if not me then return end
	item = {
		me:FindItem("item_black_king_bar") -- ➜ BKB item[1]
	}
	skill = {
		me:GetAbility(4)                   -- ➜ skill[1] -- DUEL
	}
	if client.chat or client.console or client.loading then return end
	if item[1] and codes[1] and not toggle[5] then
		statusText.text = "Black King Bar - Enable - (" .. string.char(toggle[1]) .. ")   Blink Combo - (" .. string.char(toggle[2]) .. ") "
		codes[1] = false
		codes[3] = true
		-- ➜ BKB icon
		bkb1.entity            = me 
		bkb1.entityPosition    = Vector(0,0,me.healthbarOffset)
		bkb1.textureId         = drawMgr:GetTextureId("NyanUI/items/black_king_bar")
		bkb1.visible           = true
		bkb3.entity            = me 
		bkb3.entityPosition    = Vector(0,0,me.healthbarOffset)
		bkb3.visible           = true
		bkb2.entity            = me 
		bkb2.entityPosition    = Vector(0,0,me.healthbarOffset)
		bkb2.textureId         = drawMgr:GetTextureId("NyanUI/items/translucent/black_king_bar_t25")
	end
	if IsKeyDown(toggle[1]) and SleepCheck("CD_toggle2") and not toggle[5] then
		codes[2] = not codes[2]
		Sleep(500,"CD_toggle2")
		if codes[2] then
			if item[1] then
				statusText.text = "Black King Bar - Enable - (" .. string.char(toggle[1]) .. ")   Blink Combo - (" .. string.char(toggle[2]) .. ") "
				statusText.color = 0xDF0101FF
				codes[3] = true
				bkb1.visible = true
				bkb2.visible = false
				bkb3.visible = true
			else
				statusText.text    = "Finding Black King Bar - Blink Combo - (".. string.char(toggle[2]) ..")"
				statusText.color = 0xA4A4A4FF
				bkb1.visible = false
				bkb2.visible = false
				bkb3.visible = false
			end
		else
			if item[1] then
				statusText.text = "Black King Bar - Disable - (" .. string.char(toggle[1]) .. ")   Blink Combo - (" .. string.char(toggle[2]) .. ") "
				codes[3] = false
				bkb1.visible = false
				bkb2.visible = true
				bkb3.visible = true
				statusText.color = 0x8A0808FF
			else
				statusText.text = "Finding Black King Bar - Blink Combo - (".. string.char(toggle[2]) ..")"
				statusText.color = 0xA4A4A4FF
				bkb1.visible = false
				bkb2.visible = false
				bkb3.visible = false
			end
		end
	end
	if code == toggle[2] then
		codes[4] = true
	end
	if code == toggle[3] then
		codes[4] = false
	end
end


-- ✖ Starting Combo ✖ --
function Main(tick)
	me = entityList:GetMyHero()
	if not me then return end
	if not SleepCheck() then return end
	target = targetFind:GetClosestToMouse(100)
	item = {
		me:DoesHaveModifier("modifier_item_armlet_unholy_strength"), -- ➜ item[1]
		me:FindItem("item_blink"), 									 -- ➜ item[2]
		me:FindItem("item_armlet"),                                  -- ➜ item[3]
		me:FindItem("item_blade_mail"),                              -- ➜ item[4]
		me:FindItem("item_black_king_bar"),                          -- ➜ item[5]
		me:FindItem("item_abyssal_blade"),                           -- ➜ item[6]
		me:FindItem("item_mjollnir"),                                -- ➜ item[7]
		me:FindItem("item_heavens_halberd"),                         -- ➜ item[8]
		me:FindItem("item_medallion_of_courage"),                    -- ➜ item[9]
		me:FindItem("item_mask_of_madness"),                         -- ➜ item[10]
		me:FindItem("item_urn_of_shadows"),                          -- ➜ item[11]
	}
	skill = {
		me:GetAbility(1),                                            -- ➜ skill[1] -- Arrows
		me:GetAbility(2),                                            -- ➜ skill[2] -- Buff
		me:GetAbility(4),                                            -- ➜ skill[3] -- DUEL
	}
	if target and GetDistance2D(me,target) < 2000 and skill[3] and target.alive and target.visible then
		blink.entity            = target 
		blink.entityPosition    = Vector(0,0,target.healthbarOffset)
		blink.textureId         = drawMgr:GetTextureId("NyanUI/items/blink")
		blinkbg.entity          = target 
		blinkbg.entityPosition  = Vector(0,0,target.healthbarOffset)
		ikillyou.entity = target
		ikillyou.entityPosition = Vector(0,0,target.healthbarOffset)
		markedfordeath()
	else
		ikillyou.visible   = false
		blink.visible      = false
		blinkbg.visible    = false
	end
	if target and GetDistance2D(me,target) < 950 and item[11] then
		Autourn()
	end
	if codes[4] and skill[3].level > 0 and target and target.visible and target.alive and me.alive and GetDistance2D(me,target) < 1200 and SleepCheck("DelayCombo") and SleepCheck("duelactive") then
		Sleep(300,"DelayCombo")
		BlinkCombo()
	end
end

function markedfordeath()
	if target and target.alive and target.visible then
		ikillyou.visible = true
		if item[2] and GetDistance2D(me,target) < 1200 then
			blink.visible   = true
			blinkbg.visible = true
		else
			blink.visible      = false
			blinkbg.visible    = false
		end
	end
end

function Autourn()
	if target and target.health <= 150 and item[11] and GetDistance2D(me,target) < 950 and target.visible and target.alive and me.alive then
		if item[11] and item[11]:CanBeCasted() then
			me:CastItem("item_urn_of_shadows",target)
			Sleep(100+me:GetTurnTime(target)*500)
		return
		end
	end
end

function BlinkCombo()
	if me:DoesHaveModifier("modifier_item_invisibility_edge_windwalk") then
		codes[6] = true
		me:Attack(target)
		Sleep(100+me:GetTurnTime(target)*500)
	else
		codes[6] = false
	end
	if me:CanCast() and not me:IsChanneling() and not codes[6] then
		-- ➜ Press the attack
		if skill[2]:CanBeCasted() then
			me:CastAbility(skill[2],me)
			Sleep(skill[2]:FindCastPoint()*500)
		end
		-- ➜ Blink dagger
		if item[2] and item[2]:CanBeCasted() and GetDistance2D(me,target) > 150 then
			me:CastAbility(item[2],target.position)
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Check if bkb is active or inactive
		if codes[3] and item[5] and item[5]:CanBeCasted() then
			me:SafeCastItem("item_black_king_bar")
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Mjolnir item
		if item[7] and item[7].state == LuaEntityItem.STATE_READY and item[7]:CanBeCasted() then
			me:CastAbility(item[7],me)
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Armlet item
		if item[3] and item[3]:CanBeCasted() and not item[1] and SleepCheck("Armlet_use_delay") then
			me:SafeCastItem("item_armlet")
			Sleep(100)
			Sleep(200,"Armlet_use_delay")
		end
		-- ➜ Madness item
		if item[10] and item[10]:CanBeCasted() then
			me:SafeCastItem("item_mask_of_madness")
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Abyssal item
		if item[6] and item[6].state == LuaEntityItem.STATE_READY and item[6]:CanBeCasted() then
			me:CastItem("item_abyssal_blade",target)
			Sleep(100,"duel")
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Urn of Shadows item
		if item[11] and item[11]:CanBeCasted() then
			me:CastItem("item_urn_of_shadows",target)
			Sleep(100,"duel")
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Halberd item
		if item[8] and item[8].state == LuaEntityItem.STATE_READY and item[8]:CanBeCasted() then
			me:CastItem("item_heavens_halberd",target)
			Sleep(100,"duel")
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Medallion of courage item
		if item[9] and item[9].state == LuaEntityItem.STATE_READY and item[9]:CanBeCasted() then
			me:CastItem("item_medallion_of_courage",target)
			Sleep(100,"duel")
			Sleep(100+me:GetTurnTime(target)*500)
		end
		-- ➜ Blademail item
		if item[4] and item[4]:CanBeCasted() then
			me:SafeCastItem("item_blade_mail")
			Sleep(100+me:GetTurnTime(target)*600)
		end
		-- ➜ Duel Hability
		if target.classId == CDOTA_Unit_Hero_Abaddon and target:GetAbility(4).cd > 5 then
			if SleepCheck("duel") and skill[3]:CanBeCasted() and not target:IsLinkensProtected() and not target:IsPhysDmgImmune() and not target:DoesHaveModifier("modifier_abaddon_borrowed_time") then
				me:CastAbility(skill[3],target)
				Sleep(skill[2]:FindCastPoint()*800)
				Sleep(80,"duelactive")
				codes[4] = false
			end
		elseif target.classId ~= CDOTA_Unit_Hero_Abaddon then
			if SleepCheck("duel") and skill[3]:CanBeCasted() and not target:IsLinkensProtected() and not target:IsPhysDmgImmune() and not target:DoesHaveModifier("modifier_abaddon_borrowed_time") then
				me:CastAbility(skill[3],target)
				Sleep(skill[2]:FindCastPoint()*800)
				Sleep(80,"duelactive")
				codes[4] = false
			end
		end
		codes[4] = false
		Sleep(200)
	else
	    return
	end
end


-- ✖ END OF GAME  ✖ --
function onClose()
	collectgarbage("collect")
	if codes[5] then
	    statusText.visible = false
		ikillyou.visible = false
		bkb1.visible  = false
		bkb2.visible  = false
		blink.visible = false
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
		codes[5] = false
	end
end
script:RegisterEvent(EVENT_CLOSE,onClose)
script:RegisterEvent(EVENT_TICK,onLoad)
