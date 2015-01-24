--<<Legion commander - Autoduel script - by bruninjaman>>
-- Version 1.7
-- 1 - Now you can't lose a duel.
-- 2 - How it works? Press "Key_configured" and make some destruction.
-- 3 - The combo (Press The Attack -> blink-> blademail -> mjolnir -> mordiggian -> Abyssal -> BKB (if enable) )
-- 4 - Don't lose kill's, auto "Overwhelming Odds" is used when enemy is killable.(not yet)
-- 5 - Enjoy this script, and fell free to report any bugs.
--                          And thanks to use my script!
-------------------------------------------------------------------------------------------------------
-- Changelog
-- Version 1.0 - Saturday, January 17, 2015
-- # Script released
-- Version 1.1 - Saturday, January 17, 2015
-- # Add mjollnr
-- # (plan  to changes the visual mode) [ Learning some more ]
-- # New Itens menu
-- Version 1.2 - Sunday, January 18, 2015
-- # Fixed "attempt a nil value" bug
-- # Fixed choose another hero
-- # Fixed FPS Reduction (not tested)[FAILED]
-- # Fixed  check items and spells cd (Trying to fixe always use Abyssal blade.)
-- # Menu Beta (it will be better on the future)
-- Version 1.3 - Monday, January 19, 2015
-- # Fixed FPS Reduction [FAILED].
-- # Added Medallion, Mask of madness and Halberd
-- # Fixed allways use Abyssal blade (thank you Moones)
-- # Fixed CD time before ultimate (now is instant ultimate)
-- # Menu Will be fixed in another version( but it doesn't is a problem).
-- Version 1.4 - Tuesday, January 20, 2015
-- # Fixed FPS reduction [Beta]
-- # Added CanBeCasted() and CanCast() and some sleep().
-- # Removed itens menu, it will be worked later.
-- Version 1.5 - Tuesday, January 20, 2015
-- # Fixed Armlet, now the script will use only if it is inactivated.
-- # Added cancel config, now you can cancel the combo. ( thanks Nova)
-- Version 1.6 - Tuesday, January 20, 2015
-- # Added check if you have bkb display menu, if don't have display only Autocombo menu.
-- # Added bkb icon when BKB is active in autocombo
-- # Font of "marked for death" modified for "Tahoma" for "Fixedsys"
-- Version 1.7 - Wednesday, January 21, 2015
-- # New function - Autoduel
-- - Legion Commander will autouse duel when enemy is 3 hit to die, and Legion commander hp is > 40%.
-- - You can enable/disable it.
-- - the ultimate will be used on first in the nearest enemy.
-- - Legion will use "Second skill" before the ultimate.
-- - Legion commander will check if she can castskill.
-- - the ultimate will only be used in 400 of range(Blink dagger is not active in autoultimate).
-- # New lib added libs.AbilityDamage
-- # New libs needed: require("libs.Utils") require("libs.Animations") require ("libs.AbilityDamage")
-- # Increased speed to use ultimate
-------------------------------------------------------------------------------------------------------
-- Some Functions
-- 1 - This script will run only if you are legion commander.
-- 2 - This script will show the equipments you're using in this combo.
-- 3 - This script will be upgraded until it be perfect.
-- Libraries
require("libs.Utils")
require("libs.ScriptConfig")
require("libs.TargetFind")
require("libs.AbilityDamage")
--Config
config = ScriptConfig.new()
config:SetParameter("toggleKey", "F", config.TYPE_HOTKEY)
config:SetParameter("BlinkComboKey", "D", config.TYPE_HOTKEY)
config:SetParameter("StopComboKey", "S", config.TYPE_HOTKEY)
config:SetParameter("AutoDuelKey", "T", config.TYPE_HOTKEY)
config:Load()
-- Some Variables
local AutoDuelKey   = config.AutoDuelKey
local toggleKey     = config.toggleKey
local BlinkComboKey = config.BlinkComboKey
local StopComboKey  = config.StopComboKey
local registered	= false
local range 		= 1200
local ARMLET_DELAY  = 100
-- Others variables
local target	    = nil
local active	    = false
local active2	    = false
local BlinkActive   = false
local key1          = false
local key2          = true
-- Menu screen
local x,y         = 1150, 50
local monitor     = client.screenSize.x/1600
local F14         = drawMgr:CreateFont("F14","Franklin Gothic Medium",17,800) 
local statusText  = drawMgr:CreateText(x*monitor,y*monitor,-1,"                                           No BKB -        AutoCombo - (".. string.char(BlinkComboKey) ..")",F14) statusText.visible = false
-- Autoultimate Enable/Disable --
-- Variables 
local targetHandle  = nil
local x1,y1         = 50, 50
local haveduelcheck = true
local duelenable    = true
local duelText      = drawMgr:CreateText(x1*monitor,y1*monitor,-1,"You don't have duel.",F14) duelText.visible = false
-- -- -- -- -- -- -- -- -- --
-- Visual variables
local legion   = drawMgr:CreateFont("Font","Fixedsys",14,550)
local ikillyou = drawMgr:CreateText(-50,-50,-1,"Marked for death!",legion); ikillyou.visible = false
-- Black king bar icon -- 
local bkbicon    = drawMgr:CreateRect(-16,-80,45,30,0x000000ff) bkbicon .visible = false
local bkbiconoff = drawMgr:CreateRect(-16,-80,45,30,0x000000ff) bkbicon .visible = false
local havebkb    = true
-- When you start the game (check hero)
function onLoad()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Legion_Commander then 
			script:Disable()
		else
			registered = true
			statusText.visible = true 
			duelText.visible = true
			script:RegisterEvent(EVENT_TICK,Main)
			script:RegisterEvent(EVENT_TICK,autoduel)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(onLoad)
		end
	end
end
--pressing a key
function Key(msg,code)
	local me = entityList:GetMyHero()
	if not me then return end
	-- BKB icon --
	bkbicon.entity         = me 
	bkbicon.entityPosition = Vector(0,0,me.healthbarOffset)
	bkbicon.textureId      = drawMgr:GetTextureId("NyanUI/items/black_king_bar")
	bkbiconoff.entity         = me 
	bkbiconoff.entityPosition = Vector(0,0,me.healthbarOffset)
	bkbiconoff.textureId      = drawMgr:GetTextureId("NyanUI/items/translucent/black_king_bar_t25")
	local bkb1             = me:FindItem("item_black_king_bar")
	if client.chat or client.console or client.loading then return end
	if bkb1 and havebkb then
		statusText.text = "Legion Commander - BKB Enable! - (" .. string.char(toggleKey) .. ")   AutoCombo - (" .. string.char(BlinkComboKey) .. ") "
		key2            = false
		bkbicon.visible = true
		havebkb         = false
	end
    if IsKeyDown(toggleKey) and SleepCheck("try") then
		active = not active
		Sleep(200,"try")
		-- Active/desative bkb --
		if active then
			if bkb1 then
				statusText.text = "Legion Commander - BKB Enable! - (" .. string.char(toggleKey) .. ")   AutoCombo - (" .. string.char(BlinkComboKey) .. ") "
				key2 = false
				bkbicon.visible    = true
				bkbiconoff.visible = false
			else
				statusText.text    = "                                           No BKB -        AutoCombo - (".. string.char(BlinkComboKey) ..")"
				bkbicon.visible    = false
				bkbiconoff.visible = false
			end
		else
			if bkb1 then
				statusText.text = "Legion Commander - BKB Disabled! - (" .. string.char(toggleKey) .. ")   AutoCombo - (" .. string.char(BlinkComboKey) .. ") "
				key2 = true
				bkbicon.visible = false
				bkbiconoff.visible = true
			else
				statusText.text = "                                           No BKB -        AutoCombo - (".. string.char(BlinkComboKey) ..")"
				bkbicon.visible = false
				bkbiconoff.visible = false
			end
		end
	end	
	
	if code == BlinkComboKey then
		BlinkActive = true
	end
	if code == StopComboKey then
		BlinkActive = false
	end
	
end
--Start Combo
function Main(tick)
-- variables
	local me = entityList:GetMyHero()
	if not me then return end
	-- state armlet --
	local armState    = me:DoesHaveModifier("modifier_item_armlet_unholy_strength")
    local blink       = me:FindItem("item_blink")
	local attack      = me:GetAbility(2)
	local duel        = me:GetAbility(4)
	local armlet      = me:FindItem("item_armlet")
	local blademail   = me:FindItem("item_blade_mail")
	local bkb1        = me:FindItem("item_black_king_bar")
	local abyssal     = me:FindItem("item_abyssal_blade")
	local mjolnir     = me:FindItem("item_mjollnir")
	local halberd     = me:FindItem("item_heavens_halberd")
	local medallion   = me:FindItem("item_medallion_of_courage")
	local madness     = me:FindItem("item_mask_of_madness")
	-- Visual Marked for death
	local target = targetFind:GetClosestToMouse(100)
		if target then
			ikillyou.visible = true
			ikillyou.entity = target
			ikillyou.entityPosition = Vector(0,0,target.healthbarOffset)
		else
			ikillyou.visible = false
		end
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	if not SleepCheck() then return end
	local distance = GetDistance2D(me,target)
	
	
	--SUPER COMBO
	if target and BlinkActive and me.alive and distance < range then
        if me:CanCast() then
			-- Second Skill
			if attack:CanBeCasted() then
				me:CastAbility(attack,me)
				Sleep(attack:FindCastPoint()*500)
				return
			end
			-- Blink action --
			if blink and blink:CanBeCasted() then
				me:CastAbility(blink,target.position)
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Check bkb active or inactive
			if (key1==key2) and bkb1 and bkb1:CanBeCasted() then
				me:SafeCastItem("item_black_king_bar")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Mjolnir item
			if mjolnir and mjolnir.state == LuaEntityItem.STATE_READY and mjolnir:CanBeCasted() then
				me:CastAbility(mjolnir,me)
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Armlet item
			if armlet and armlet:CanBeCasted() and not armState then
				me:SafeCastItem("item_armlet")
				Sleep(ARMLET_DELAY)
			end
			-- madness item
			if madness and madness:CanBeCasted() then
				me:SafeCastItem("item_mask_of_madness")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Abyssal item
			if abyssal and abyssal.state == LuaEntityItem.STATE_READY and abyssal:CanBeCasted() then
				me:CastItem("item_abyssal_blade",target)
				Sleep(100,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- halberd item
			if halberd and halberd.state == LuaEntityItem.STATE_READY and halberd:CanBeCasted() then
				me:CastItem("item_heavens_halberd",target)
				Sleep(50,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- medallion of courage item
			if medallion and medallion.state == LuaEntityItem.STATE_READY and medallion:CanBeCasted() then
				me:CastItem("item_medallion_of_courage",target)
				Sleep(50,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Blademail item
			if blademail and blademail:CanBeCasted() then
				me:SafeCastItem("item_blade_mail")
				Sleep(100+me:GetTurnTime(target)*600)
				return
			end
			-- Duel Hability item
			if SleepCheck("duel") and duel:CanBeCasted() then
				me:CastAbility(duel,target)
				Sleep(attack:FindCastPoint()*500)
			end
			Sleep(50)
		    BlinkActive = false
		else
			-- Second Skill
			if attack:CanBeCasted() then
				me:CastAbility(attack,me)
				Sleep(attack:FindCastPoint()*500)
				return
			end
			-- Check bkb active or inactive
			if (key1==key2) and bkb1 and bkb1:CanBeCasted() then
				me:SafeCastItem("item_black_king_bar")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Mjolnir item
			if mjolnir and mjolnir.state == LuaEntityItem.STATE_READY and mjolnir:CanBeCasted() then
				me:CastAbility(mjolnir,me)
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Armlet item
			if armlet and armlet:CanBeCasted() and not armState then
				me:SafeCastItem("item_armlet")
				Sleep(ARMLET_DELAY)
			end
			-- madness item
			if madness and madness:CanBeCasted() then
				me:SafeCastItem("item_mask_of_madness")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Abyssal item
			if abyssal and abyssal.state == LuaEntityItem.STATE_READY and abyssal:CanBeCasted() then
				me:CastItem("item_abyssal_blade",target)
				Sleep(100,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- halberd item
			if halberd and halberd.state == LuaEntityItem.STATE_READY and halberd:CanBeCasted() then
				me:CastItem("item_heavens_halberd",target)
				Sleep(50,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- medallion of courage item
			if medallion and medallion.state == LuaEntityItem.STATE_READY and medallion:CanBeCasted() then
				me:CastItem("item_medallion_of_courage",target)
				Sleep(50,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Blademail item
			if blademail and blademail:CanBeCasted() then
				me:SafeCastItem("item_blade_mail")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- Duel Hability item
			if SleepCheck("duel") and duel:CanBeCasted() then
				me:CastAbility(duel,target)
				Sleep(attack:FindCastPoint()*500)
			end
			Sleep(50)
		    BlinkActive = false
		end
		Sleep(200)
	    return
	else
	    return
	end
	    
end
-- Variables autoduel --
	local rangeduel       = 400
	local enemies         = nil
	local distance        = nil
	local duelDamageTable = nil
function autoduel(msg,code)
	if client.chat or client.console or client.loading then return end
	local me              = entityList:GetMyHero()
	local myhp            = (me.maxHealth * 0.4)
	local attack          = me:GetAbility(2)
	if not me then return end
	-- Duel Hability -- -- -- -- -- -- -- -- --
	local duel      = me:GetAbility(4)
	-- -- -- -- -- -- -- -- -- -- -- -- -- --
	if duel.level > 0 and haveduelcheck then
		duelText.text         = "AutoDuel [Enable] - (" .. string.char(AutoDuelKey) .. ")"
		haveduelcheck         = false
	end
    if IsKeyDown(AutoDuelKey) and SleepCheck("try") then
		active2 = not active2
		Sleep(200,"try")
		if active2 then
			if duel.level > 0 then
				duelText.text      = "AutoDuel [Enable] - (" .. string.char(AutoDuelKey) .. ")"
				duelenable         = true
			end
		else
			if duel.level > 0 then
				duelText.text      = "AutoDuel [Disable] - (" .. string.char(AutoDuelKey) .. ")"
				duelenable = false
			end
		end
	end
	-- Autoduel configuration --
	if not duelDamage or duelDamage[2] ~= me.attackSpeed or duelDamage[3] ~= me.dmgMin or duelDamage[4] ~= me.dmgBonus then
      duelDamageTable = {AbilityDamage.GetDamage(duel), me.attackSpeed, me.dmgMin, me.dmgBonus}
	end

	local duelDamage = (duelDamageTable[1] * 0.5)
	if duelenable and duel and SleepCheck("onetime") then
		enemies         = entityList:GetEntities({type=LuaEntity.TYPE_HERO, alive=true, team=me:GetEnemyTeam()})
		for i,enemy in ipairs(enemies) do
			distance        = GetDistance2D(me,enemy)
			if enemy.health   <= duelDamage and distance < rangeduel and me.health >= myhp then
				-- second skill --
				if attack:CanBeCasted() and SleepCheck("castattack") then
					me:CastAbility(attack,me)
					Sleep(100,"castattack")
					Sleep(200,"attack-duel")
					return
				end
				-- Duel --
				if duel:CanBeCasted() and SleepCheck("castduel") and SleepCheck("attack-duel") then
						me:CastAbility(duel,enemy)
						Sleep(100,"castduel")
						return
				end
				Sleep(500,"onetime")
			end
		end
	end	
end
--END OF GAME 
function onClose()
	collectgarbage("collect")
	if registered then
	    statusText.visible = false
		script:UnregisterEvent(Main)
		script:UnregisterEvent(autoduel)
		script:UnregisterEvent(Key)
		registered = false
	end
end
script:RegisterEvent(EVENT_CLOSE,onClose)
script:RegisterEvent(EVENT_TICK,onLoad)
