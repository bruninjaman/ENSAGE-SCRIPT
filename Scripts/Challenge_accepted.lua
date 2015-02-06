--<<Legion commander V2.2 ☠ - autoduel script - by ☢bruninjaman☢>>
-- Version 2.2
-- 1 - Now you can't lose a duel. ｡◕‿◕｡
-- 2 - How it works? Press "Key_configured" and make some destruction.
-- 3 - The combo [New itens added] (Press The Attack ➩ blink ➩ blademail ➩ mjolnir ➩ mordiggian ➩ Abyssal ➩ BKB (if enable) )
-- 4 - Don't lose kill's, auto "Overwhelming Odds" is used when enemy is killable.(not yet,but AIO_kill_Stealer have this funcion)
-- 5 - Enjoy this script, and fell free to report any bugs.
--                          ☢And thanks to use my script!☢
-------------------------------------------------------------------------------------------------------
-- Changelog
-- Version 1.0 - Saturday, January 17, 2015
-- ➩ Script released
-- Version 1.1 - Saturday, January 17, 2015
-- ➩ Add mjollnr
-- ➩ (plan  to changes the visual mode) [ Learning some more ]
-- ➩ New Itens menu
-- Version 1.2 - Sunday, January 18, 2015
-- ➩ Fixed "attempt a nil value" bug
-- ➩ Fixed choose another hero
-- ➩ Fixed FPS Reduction (not tested)[FAILED]
-- ➩ Fixed  check items and spells cd (Trying to fixe always use Abyssal blade.)
-- ➩ Menu Beta (it will be better on the future)
-- Version 1.3 - Monday, January 19, 2015
-- ➩ Fixed FPS Reduction [FAILED].
-- ➩ Added Medallion, Mask of madness and Halberd
-- ➩ Fixed allways use Abyssal blade (thank you Moones)
-- ➩ Fixed CD time before ultimate (now is instant ultimate)
-- ➩ Menu Will be fixed in another version( but it doesn't is a problem).
-- Version 1.4 - Tuesday, January 20, 2015
-- ➩ Fixed FPS reduction [Beta]
-- ➩ Added CanBeCasted() and CanCast() and some sleep().
-- ➩ Removed itens menu, it will be worked later.
-- Version 1.5 - Tuesday, January 20, 2015
-- ➩ Fixed Armlet, now the script will use only if it is inactivated.
-- ➩ Added cancel config, now you can cancel the combo. ( thanks Nova)
-- Version 1.6 - Tuesday, January 20, 2015
-- ➩ Added check if you have bkb display menu, if don't have display only Autocombo menu.
-- ➩ Added bkb icon when BKB is active in autocombo
-- ➩ Font of "marked for death" modified for "Tahoma" for "Fixedsys"
-- Version 1.7 - Wednesday, January 21, 2015
-- ➩ New function - Autoduel
-- → Legion Commander will autouse duel when enemy is 3 hit to die, and Legion commander hp is > 40%.
-- → You can enable/disable it.
-- → the ultimate will be used on first in the nearest enemy.
-- → Legion will use "Second skill" before the ultimate.
-- → Legion commander will check if she can castskill.
-- → the ultimate will only be used in 400 of range(Blink dagger is not active in autoultimate).
-- ➩ New lib added libs.AbilityDamage
-- ➩ New libs needed: require("libs.Utils") require("libs.Animations") require ("libs.AbilityDamage")
-- ➩ Increased speed to use ultimate
-- Version 1.8 Saturday, January 24, 2015
-- ➩ Script re-organize.
-- Version 1.9 Sunday, January 25, 2015
-- ➩ Check if enemies have linkens
-- ➩ Check if target is imune from physical damage.
-- ➩ Fixed illusion autoultimate and fixed autoultimate.
-- Version 2.0 Wednesday, February 4, 2015
-- ➩ Reworked code and added some sleeps.. ( fixed problems with high memory usage. ). Thanks NOVA for help.
-- ➩ Urn added.
-- ➩ auto urn added.
-- Version 2.1 Wednesday, February 4, 2015
-- ➩ New Lib Animations(thanks Moones).
-- ➩ don't have autoblink bug anymore.
-- ➩ will not use ultimate on abaddon, only if is on cooldown.
-- ➩ Auto ultimate fixed, now autoultimate will use blink.
-- Version 2.2 Thursday, February 5, 2015
-- ➩ script reorganized.
-- ➩ more arrays.
-- ➩ Now Auto Duel Will use all itens.
-------------------------------------------------------------------------------------------------------
-- Some Functions
-- 1 - This script will run only if you are legion commander.
-- 2 - This script will show the equipments you're using in this combo.[Menu Will be worked later]
-- 3 - This script will be upgraded until it be perfect.
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
config:SetParameter("AutoDuelKey", "T", config.TYPE_HOTKEY)
config:Load()
-- ✖ arrays keys and range ✖ -- 
local Keys_config = {
			config.AutoDuelKey,     -- ➜ Auto Duel Key --  Keys_config[1]
			config.toggleKey,       -- ➜ toggle Key --  Keys_config[2]
			config.BlinkComboKey,   -- ➜ blink Combo Key --  Keys_config[3]
			config.StopComboKey,    -- ➜ Stop Combo Key --  Keys_config[4]
}
local ranges = {
		1200,      -- ➜ range blink dagger ranges[1]
		100,       -- ➜ ARMLET_DELAY ranges[2]	
		400,       -- ➜ range duel ranges[3]

}
local keys = { 
			false,    -- ➜ registered keys[1]
			false,    -- ➜ active keys[2]
			false,    -- ➜ active2 keys[3]
			false,    -- ➜ BlinkActive keys[4]
			false,    -- ➜ key1 keys[5]
			true,     -- ➜ key2 keys[6]
			true,     -- ➜ haveduelcheck keys[7]
			true,     -- ➜ duelenable keys[8]
			true      -- ➜ havebkb keys[9]
			}
-- target variable --
local target         = nil
-- ✖ array itens and variable me ✖ --
local item = nil
local me = nil
-- ✖ Menu screen ✖ --
local x,y            = 1150, 50
local monitor        = client.screenSize.x/1600
local F14            = drawMgr:CreateFont("F14","Franklin Gothic Medium",17,800) 
local statusText     = drawMgr:CreateText(x*monitor,y*monitor,-1,"                                           No BKB -        AutoCombo - (".. string.char(Keys_config[3]) ..")",F14) statusText.visible = false
-- ✖ Images and coordinates variables ✖ --
local x1,y1          = 50, 50
local duelText       = drawMgr:CreateText(x1*monitor,y1*monitor,-1,"Finding Duel Hability.",F14) duelText.visible = false
-- ➜ marked for death text
local legion         = drawMgr:CreateFont("Font","Fixedsys",14,550)
local ikillyou       = drawMgr:CreateText(-50,-50,-1,"Marked for death!",legion); ikillyou.visible = false
-- ➜ Black king bar icon 
local bkbicon        = drawMgr:CreateRect(-16,-80,45,30,0x000000ff) bkbicon .visible = false
local bkbiconoff     = drawMgr:CreateRect(-16,-80,45,30,0x000000ff) bkbicon .visible = false
-- ✖ When you start the game (check hero) ✖ --
function onLoad()
	if PlayingGame() then
		local me = entityList:GetMyHero()
		-- ➜ if is not a legion commander disable script
		if not me or me.classId ~= CDOTA_Unit_Hero_Legion_Commander then 
			script:Disable()
		else
			-- ➜ if is, enable script
			keys[1] = true
			statusText.visible = true 
			duelText.visible = true
			script:RegisterEvent(EVENT_TICK,Main)
			script:RegisterEvent(EVENT_TICK,autoduel)
			script:RegisterEvent(EVENT_KEY,Key)
			script:UnregisterEvent(onLoad)
		end
	end
end
-- ✖ pressing 'F' or 'D' or 'S' ✖ --
function Key(msg,code)
	me = entityList:GetMyHero()
	if not me then return end
	-- ➜ BKB icon
	bkbicon.entity            = me 
	bkbicon.entityPosition    = Vector(0,0,me.healthbarOffset)
	bkbicon.textureId         = drawMgr:GetTextureId("NyanUI/items/black_king_bar")
	bkbiconoff.entity         = me 
	bkbiconoff.entityPosition = Vector(0,0,me.healthbarOffset)
	bkbiconoff.textureId      = drawMgr:GetTextureId("NyanUI/items/translucent/black_king_bar_t25")
	local bkb1                = me:FindItem("item_black_king_bar")
	if client.chat or client.console or client.loading then return end
	if bkb1 and keys[9] then
		statusText.text = "Legion Commander - BKB Enable! - (" .. string.char(Keys_config[2]) .. ")   AutoCombo - (" .. string.char(Keys_config[3]) .. ") "
		keys[6]            = false
		bkbicon.visible = true
		keys[9]         = false
	end
    if IsKeyDown(Keys_config[2]) and SleepCheck("try") then
		keys[2] = not keys[2]
		Sleep(100,"try")
		-- ➜ Active/desative black king bar
		if keys[2] then
			if bkb1 then
				statusText.text = "Legion Commander - BKB Enable! - (" .. string.char(Keys_config[2]) .. ")   AutoCombo - (" .. string.char(Keys_config[3]) .. ") "
				keys[6] = false
				bkbicon.visible    = true
				bkbiconoff.visible = false
			else
				statusText.text    = "                                           No BKB -        AutoCombo - (".. string.char(Keys_config[3]) ..")"
				bkbicon.visible    = false
				bkbiconoff.visible = false
			end
		else
			if bkb1 then
				statusText.text = "Legion Commander - BKB Disabled! - (" .. string.char(Keys_config[2]) .. ")   AutoCombo - (" .. string.char(Keys_config[3]) .. ") "
				keys[6] = true
				bkbicon.visible = false
				bkbiconoff.visible = true
			else
				statusText.text = "                                           No BKB -        AutoCombo - (".. string.char(Keys_config[3]) ..")"
				bkbicon.visible = false
				bkbiconoff.visible = false
			end
		end
	end	
	
	if code == Keys_config[3] then
		keys[4] = true
	end
	if code == Keys_config[4] then
		keys[4] = false
	end
	
end
-- ✖ Starting Combo ✖ --
function Main(tick)
	target = targetFind:GetClosestToMouse(100)
	me = entityList:GetMyHero()
	if not me then return end
	item = {
		me:DoesHaveModifier("modifier_item_armlet_unholy_strength"), -- ➜ item[1]
		me:FindItem("item_blink"), 									 -- ➜ item[2]
		me:GetAbility(2),                                            -- ➜ item[3]
		me:GetAbility(4),                                            -- ➜ item[4]
		me:FindItem("item_armlet"),                                  -- ➜ item[5]
		me:FindItem("item_blade_mail"),                              -- ➜ item[6]
		me:FindItem("item_black_king_bar"),                          -- ➜ item[7]
		me:FindItem("item_abyssal_blade"),                           -- ➜ item[8]
		me:FindItem("item_mjollnir"),                                -- ➜ item[9]
		me:FindItem("item_heavens_halberd"),                         -- ➜ item[10]
		me:FindItem("item_medallion_of_courage"),                    -- ➜ item[11]
		me:FindItem("item_mask_of_madness"),                         -- ➜ item[12]
		me:FindItem("item_urn_of_shadows"),                          -- ➜ item[13]
	}
	-- ✖ Marked for death text ✖ --
		if target and target.alive and target.visible then
			ikillyou.visible = true
			ikillyou.entity = target
			ikillyou.entityPosition = Vector(0,0,target.healthbarOffset)
		else
			ikillyou.visible = false
		end
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	if not SleepCheck() then return end
	local distance = GetDistance2D(me,target)
	-- ✖ Auto Urn function ✖ --
	if target and target.health <= 150 and item[13] and distance < ranges[1] and target.visible and target.alive then
		if item[13] and item[13]:CanBeCasted() then
			me:CastItem("item_urn_of_shadows",target)
			Sleep(100+me:GetTurnTime(target)*500)
		return
		end
	end
	-- ✖ Make Combo ✖ --
	if target and keys[4] and me.alive and distance < ranges[1] and target.visible and target.alive then
        if me:CanCast() then
			-- ➜ Press the attack
			if item[3]:CanBeCasted() then
				me:CastAbility(item[3],me)
				Sleep(item[3]:FindCastPoint()*500)
				return
			end
			-- ➜ Blink dagger
			if item[2] and item[2]:CanBeCasted() then
				me:CastAbility(item[2],target.position)
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Check if bkb is active or inactive
			if (keys[5]==keys[6]) and item[7] and item[7]:CanBeCasted() then
				me:SafeCastItem("item_black_king_bar")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Mjolnir item
			if item[9] and item[9].state == LuaEntityItem.STATE_READY and item[9]:CanBeCasted() then
				me:CastAbility(item[9],me)
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Armlet item
			if item[5] and item[5]:CanBeCasted() and not item[1] then
				me:SafeCastItem("item_armlet")
				Sleep(ranges[2])
			end
			-- ➜ Madness item
			if item[12] and item[12]:CanBeCasted() then
				me:SafeCastItem("item_mask_of_madness")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Abyssal item
			if item[8] and item[8].state == LuaEntityItem.STATE_READY and item[8]:CanBeCasted() then
				me:CastItem("item_abyssal_blade",target)
				Sleep(100,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Urn of Shadows item
			if item[13] and item[13]:CanBeCasted() then
				me:CastItem("item_urn_of_shadows",target)
				Sleep(100,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Halberd item
			if item[10] and item[10].state == LuaEntityItem.STATE_READY and item[10]:CanBeCasted() then
				me:CastItem("item_heavens_halberd",target)
				Sleep(100,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Medallion of courage item
			if item[11] and item[11].state == LuaEntityItem.STATE_READY and item[11]:CanBeCasted() then
				me:CastItem("item_medallion_of_courage",target)
				Sleep(100,"duel")
				Sleep(100+me:GetTurnTime(target)*500)
				return
			end
			-- ➜ Blademail item
			if item[6] and item[6]:CanBeCasted() then
				me:SafeCastItem("item_blade_mail")
				Sleep(100+me:GetTurnTime(target)*600)
				return
			end
			-- ➜ Duel Hability
			if target.classId == CDOTA_Unit_Hero_Abaddon and target:GetAbility(4).cd > 5 then
				if SleepCheck("duel") and item[4]:CanBeCasted() and not target:IsLinkensProtected() and not target:IsPhysDmgImmune() and not target:DoesHaveModifier("modifier_abaddon_borrowed_time") then
					me:CastAbility(item[4],target)
					Sleep(item[3]:FindCastPoint()*500)
				end
			else if target.classId ~= CDOTA_Unit_Hero_Abaddon then
				if SleepCheck("duel") and item[4]:CanBeCasted() and not target:IsLinkensProtected() and not target:IsPhysDmgImmune() and not target:DoesHaveModifier("modifier_abaddon_borrowed_time") then
					me:CastAbility(item[4],target)
					Sleep(item[3]:FindCastPoint()*500)
				end
			end
			end
			Sleep(50)
		    keys[4] = false
		end
		Sleep(200)
	    return
	else
	    return
	end
	    
end
-- ✖ Variables Auto Duel ✖ --
	local enemies         = nil
	local distance        = nil
	local duelDamageTable = {}
	local duelDamage      = 0
-- ✖ Auto Duel Function ✖ --
function autoduel(msg,code)
	me = entityList:GetMyHero()
	if not me then return end
	item = {
		me:DoesHaveModifier("modifier_item_armlet_unholy_strength"), -- ➜ item[1]
		me:FindItem("item_blink"), 									 -- ➜ item[2]
		me:GetAbility(2),                                            -- ➜ item[3]
		me:GetAbility(4),                                            -- ➜ item[4]
		me:FindItem("item_armlet"),                                  -- ➜ item[5]
		me:FindItem("item_blade_mail"),                              -- ➜ item[6]
		me:FindItem("item_abyssal_blade"),                           -- ➜ item[7]
		me:FindItem("item_mjollnir"),                                -- ➜ item[8]
		me:FindItem("item_heavens_halberd"),                         -- ➜ item[9]
		me:FindItem("item_medallion_of_courage"),                    -- ➜ item[10]
		me:FindItem("item_mask_of_madness"),                         -- ➜ item[11]
		me:FindItem("item_urn_of_shadows"),                          -- ➜ item[12]
	}
	if client.chat or client.console or client.loading then return end
	local myhp            = (me.maxHealth * 0.4)
	if not me then return end
	if item[4].level > 0 and keys[7] then
		duelText.text         = "AutoDuel [Enable] - (" .. string.char(Keys_config[1]) .. ")"
		keys[7]         = false
	end
	-- ➜ Pressing 'T'
    if IsKeyDown(Keys_config[1]) and SleepCheck("try") then
		keys[3] = not keys[3]
		Sleep(100,"try")
		if keys[3] then
			if item[4].level > 0 then
				duelText.text      = "AutoDuel [Enable] - (" .. string.char(Keys_config[1]) .. ")"
				keys[8]         = true
			end
		else
			if item[4].level > 0 then
				duelText.text      = "AutoDuel [Disable] - (" .. string.char(Keys_config[1]) .. ")"
				keys[8] = false
			end
		end
	end
	if Animations.maxCount < 1 then return end
	-- ✖ Duel damage calculation ✖ --
	if not duelDamageTable or duelDamageTable[2] ~= me.attackSpeed or duelDamageTable[3] ~= me.dmgMin or duelDamageTable[4] ~= me.dmgBonus then
      duelDamageTable = {AbilityDamage.GetDamage(item[4]), me.attackSpeed, me.dmgMin, me.dmgBonus}
	end
	duelDamage = (duelDamageTable[1])
	-- ✖ Auto use duel configuration ✖ --
	if item[2] and item[2]:CanBeCasted() then
		ranges[3] = 1000
	else
		ranges[3] = 400
	end
	if keys[8] and item[4] and SleepCheck("onetime") then
		enemies  = entityList:GetEntities({type=LuaEntity.TYPE_HERO, alive=true, team=me:GetEnemyTeam()})
		for i,enemy in ipairs(enemies) do
			distance = GetDistance2D(me,enemy)
			if enemy.health <= duelDamage and distance < ranges[3] and me.health >= myhp and item[4]:CanBeCasted() and not enemy:IsPhysDmgImmune() and not enemy:IsIllusion() and not enemy:IsLinkensProtected() or item[7] then
				-- ➜ Check if is abaddon
				if enemy.classId == CDOTA_Unit_Hero_Abaddon and enemy:GetAbility(4).cd > 5 then
					-- ➜ Press the attack
					if item[3]:CanBeCasted() and SleepCheck("castattack") then
						me:CastAbility(item[3],me)
						Sleep(100,"castattack")
						Sleep(200,"attack-duel")
						return
					end
					--  ➜ Blink dagger
					if item[2] and item[2]:CanBeCasted() then
						me:CastAbility(item[2],enemy.position)
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Abyssal item
					if item[7] and item[7].state == LuaEntityItem.STATE_READY and item[7]:CanBeCasted() and enemy:IsLinkensProtected() then
						me:CastItem("item_abyssal_blade",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Armlet item
					if item[5] and item[5]:CanBeCasted() and not item[1] then
						me:SafeCastItem("item_armlet")
						Sleep(ranges[2])
					end
					-- ➜ Madness item
					if item[11] and item[11]:CanBeCasted() then
						me:SafeCastItem("item_mask_of_madness")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Urn of Shadows item
					if item[12] and item[12]:CanBeCasted() then
						me:CastItem("item_urn_of_shadows",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Halberd item
					if item[9] and item[9].state == LuaEntityItem.STATE_READY and item[9]:CanBeCasted() then
						me:CastItem("item_heavens_halberd",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Medallion of courage item
					if item[10] and item[10].state == LuaEntityItem.STATE_READY and item[10]:CanBeCasted() then
						me:CastItem("item_medallion_of_courage",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Blademail item
					if item[6] and item[6]:CanBeCasted() then
						me:SafeCastItem("item_blade_mail")
						Sleep(100+me:GetTurnTime(enemy)*600)
						return
					end
					-- ➜ Duel
					if SleepCheck("duel2") and item[4]:CanBeCasted() and SleepCheck("castduel") and SleepCheck("attack-duel") and not enemy:IsLinkensProtected() and not enemy:IsPhysDmgImmune() and not enemy:DoesHaveModifier("modifier_abaddon_borrowed_time") then
							me:CastAbility(item[4],enemy)
							Sleep(100,"castduel")
							return
					end
				else if enemy.classId ~= CDOTA_Unit_Hero_Abaddon then
					-- ➜ Press the attack
					if item[3]:CanBeCasted() and SleepCheck("castattack") then
						me:CastAbility(item[3],me)
						Sleep(100,"castattack")
						Sleep(200,"attack-duel")
						return
					end
					--  ➜ Blink dagger
					if item[2] and item[2]:CanBeCasted() then
						me:CastAbility(item[2],enemy.position)
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Abyssal item
					if item[7] and item[7].state == LuaEntityItem.STATE_READY and item[7]:CanBeCasted() and enemy:IsLinkensProtected() then
						me:CastItem("item_abyssal_blade",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Armlet item
					if item[5] and item[5]:CanBeCasted() and not item[1] then
						me:SafeCastItem("item_armlet")
						Sleep(ranges[2])
					end
					-- ➜ Madness item
					if item[11] and item[11]:CanBeCasted() then
						me:SafeCastItem("item_mask_of_madness")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Urn of Shadows item
					if item[12] and item[12]:CanBeCasted() then
						me:CastItem("item_urn_of_shadows",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Halberd item
					if item[9] and item[9].state == LuaEntityItem.STATE_READY and item[9]:CanBeCasted() then
						me:CastItem("item_heavens_halberd",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Medallion of courage item
					if item[10] and item[10].state == LuaEntityItem.STATE_READY and item[10]:CanBeCasted() then
						me:CastItem("item_medallion_of_courage",enemy)
						Sleep(100,"duel2")
						Sleep(100+me:GetTurnTime(enemy)*500)
						return
					end
					-- ➜ Blademail item
					if item[6] and item[6]:CanBeCasted() then
						me:SafeCastItem("item_blade_mail")
						Sleep(100+me:GetTurnTime(enemy)*600)
						return
					end
					-- ➜ Duel
					if SleepCheck("duel2") and item[4]:CanBeCasted() and SleepCheck("castduel") and SleepCheck("attack-duel") and not enemy:IsLinkensProtected() and not enemy:IsPhysDmgImmune() and not enemy:DoesHaveModifier("modifier_abaddon_borrowed_time") then
							me:CastAbility(item[4],enemy)
							Sleep(100,"castduel")
							return
					end
					end
				end
				Sleep(500,"onetime")
			end
		end
	end	
end
-- ✖ END OF GAME  ✖ --
function onClose()
	collectgarbage("collect")
	if keys[1] then
	    statusText.visible = false
		duelText.visible = false
		script:UnregisterEvent(Main)
		script:UnregisterEvent(autoduel)
		script:UnregisterEvent(Key)
		keys[1] = false
	end
end
script:RegisterEvent(EVENT_CLOSE,onClose)
script:RegisterEvent(EVENT_TICK,onLoad)
