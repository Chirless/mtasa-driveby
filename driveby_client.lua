local driver = false
local shooting = false
local helpText,helpAnimation
lastSlot = 0
settings = {}


local function setupDriveby( player, seat )
	if seat == 0 then 
		driver = true
	else
		driver = false
	end
	setPedWeaponSlot( localPlayer, 0 )
	
	if settings.autoEquip then
		toggleDriveby()
	end
end
addEventHandler( "onClientPlayerVehicleEnter", localPlayer, setupDriveby )

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),
	function()
		bindKey ( "mouse2", "down", "Toggle Driveby", "" )
		bindKey ( "e", "down", "Next driveby weapon", "1" )
		bindKey ( "q", "down", "Previous driveby weapon", "-1" )
		toggleControl ( "vehicle_next_weapon",false )
		toggleControl ( "vehicle_previous_weapon",false )
		triggerServerEvent ( "driveby_clientScriptLoaded", localPlayer )
		helpText = dxText:create("",0.5,0.85)
		helpText:scale(1)
		helpText:type("stroke",1)
	end
)

addEventHandler("onClientResourceStop",getResourceRootElement(getThisResource()),
	function()
		toggleControl ( "vehicle_next_weapon",true )
		toggleControl ( "vehicle_previous_weapon",true )
	end
)

addEvent ( "doSendDriveBySettings", true )
addEventHandler("doSendDriveBySettings",localPlayer,
	function(newSettings)
		settings = newSettings
		local newTable = {}
		for key,vehicleID in ipairs(settings.blockedVehicles) do
			newTable[vehicleID] = true
		end
		settings.blockedVehicles = newTable
	end
)

function toggleDriveby()
	if isCursorShowing() then return end
	if not isPedInVehicle( localPlayer ) then return end
	local vehicleID = getElementModel ( getPedOccupiedVehicle ( localPlayer ) )
	if (getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Automobile" and getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:windowstat") == 0) then
	else
	if settings.blockedVehicles[vehicleID] then return end
	local yasakliVeh = {
	}
	if yasakliVeh[vehicleID] then outputChatBox("[!] #FFFFFFZırhlı araçtan ateş edemezsin.", 0, 119, 255, true) return end
	local equipedWeapon = getPedWeaponSlot( localPlayer )
	if equipedWeapon == 0 then
		setTimer(function()
			actualspeed = getVehicleSpeed()
			if (equipedWeapon == 0 and getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:windowstat") == 0) then
				if getPedWeaponSlot(localPlayer) == 0 then
				else
					setPedDoingGangDriveby ( localPlayer, false )
					setPedWeaponSlot( localPlayer, 0 )
					limitDrivebySpeed ( switchToWeapon )
					toggleControl ( "vehicle_look_left",true )
					toggleControl ( "vehicle_look_right",true )
					toggleControl ( "vehicle_secondary_fire",true )
					toggleTurningKeys(vehicleID,true)
					fadeOutHelp()
					outputChatBox("[!] #FFFFFFCam kapalıyken ateş edemezsin!", 255, 0, 0, true)
					removeEventHandler ( "onClientPlayerVehicleExit",localPlayer,removeKeyToggles )
				end
			elseif(equipedWeapon == 0 and actualspeed >= 70) then
				if getPedWeaponSlot(localPlayer) == 0 then
				else
					outputChatBox("[!] #FFFFFFHız sınırını aştın!", 255, 0, 0, true)
					setPedDoingGangDriveby ( localPlayer, false )
					setPedWeaponSlot( localPlayer, 0 )
					limitDrivebySpeed ( switchToWeapon )
					toggleControl ( "vehicle_look_left",true )
					toggleControl ( "vehicle_look_right",true )
					toggleControl ( "vehicle_secondary_fire",true )
					toggleTurningKeys(vehicleID,true)
					fadeOutHelp()
					removeEventHandler ( "onClientPlayerVehicleExit",localPlayer,removeKeyToggles )
				end
			elseif(equipedWeapon == 0 and getPedOccupiedVehicleSeat(localPlayer) == 0) then
				if getPedWeaponSlot(localPlayer) == 0 then
				else
					outputChatBox("[!] #FFFFFFŞöför koltuğunda ateş edemezsin!", 255, 0, 0, true)
					setPedDoingGangDriveby ( localPlayer, false )
					setPedWeaponSlot( localPlayer, 0 )
					limitDrivebySpeed ( switchToWeapon )
					toggleControl ( "vehicle_look_left",true )
					toggleControl ( "vehicle_look_right",true )
					toggleControl ( "vehicle_secondary_fire",true )
					toggleTurningKeys(vehicleID,true)
					fadeOutHelp()
					removeEventHandler ( "onClientPlayerVehicleExit",localPlayer,removeKeyToggles )
				end
			elseif(equipedWeapon > 0) then
				if getPedWeaponSlot(localPlayer) == 0 then
				else
					outputChatBox("[!] #FFFFFFŞöför koltuğunda ateş edemezsin!", 255, 0, 0, true)
					setPedDoingGangDriveby ( localPlayer, false )
					setPedWeaponSlot( localPlayer, 0 )
					limitDrivebySpeed ( switchToWeapon )
					toggleControl ( "vehicle_look_left",true )
					toggleControl ( "vehicle_look_right",true )
					toggleControl ( "vehicle_secondary_fire",true )
					toggleTurningKeys(vehicleID,true)
					fadeOutHelp()
					removeEventHandler ( "onClientPlayerVehicleExit",localPlayer,removeKeyToggles )
				end
			elseif(equipedWeapon == 0 and getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:windowstat") == 1 and actualspeed <= 70 and getPedOccupiedVehicle(localPlayer) == 0 and getPedOccupiedVehicleSeat(localPlayer) > 0) then
			end
		end, 1000, 500)
		if ( driver ) then weaponsTable = settings.driver
		else weaponsTable = settings.passenger end
		local switchTo
		local switchToWeapon
		local lastSlotAmmo = getPedTotalAmmo ( localPlayer, lastSlot )
		if not lastSlotAmmo or lastSlotAmmo == 0 or getSlotFromWeapon(getPedWeapon (localPlayer,lastSlot)) == 0 then
			for key,weaponID in ipairs(weaponsTable) do
				local slot = getSlotFromWeapon ( weaponID )
				local weapon = getPedWeapon ( localPlayer, slot )
				if weapon == weaponID then
					if getPedTotalAmmo ( localPlayer, slot ) ~= 0 then
						if not switchTo or slot == 4 then
							if weaponID == 22 or weaponID == 23 or weaponID == 24 or weaponID == 25 or weaponID == 26 or weaponID == 27 or weaponID == 30 or weaponID == 31 or weaponID == 33 then
							else
							if weaponID == 30 or weaponID == 31 then return end
							switchTo = slot
							switchToWeapon = weaponID
							end
						end
					end
				end
			end
		else
			local lastSlotWeapon = getPedWeapon ( localPlayer, lastSlot )
				if weaponID == lastSlotWeapon then
					if lastSlotWeapon == 30 or lastSlotWeapon == 31 then outputChatBox("yarramı ye") return end
					switchTo = lastSlot
					switchToWeapon = lastSlotWeapon
					break
				end
			end
		end
		if not switchTo then return end
		setPedDoingGangDriveby ( localPlayer, true )
		setPedWeaponSlot( localPlayer, switchTo )
		limitDrivebySpeed ( switchToWeapon )
		toggleControl ( "vehicle_look_left",false )
		toggleControl ( "vehicle_look_right",false )
		toggleControl ( "vehicle_secondary_fire",false )
		toggleTurningKeys(vehicleID,false)
		addEventHandler ( "onClientPlayerVehicleExit",localPlayer,removeKeyToggles )
		local prevw,nextw = next(getBoundKeys ( "Previous driveby weapon" )),next(getBoundKeys ( "Next driveby weapon" ))
		if prevw and nextw then
			if animation then Animation:remove() end
			helpText:text( "Silah değiştirmek için '"..prevw.."' veya '"..nextw.."' tuşuna tıklayınız" )
			fadeInHelp()
			setTimer ( fadeOutHelp, 10000, 1 )
		end
	else
		setPedDoingGangDriveby ( localPlayer, false )
		setPedWeaponSlot( localPlayer, 0 )
		limitDrivebySpeed ( switchToWeapon )
		toggleControl ( "vehicle_look_left",true )
		toggleControl ( "vehicle_look_right",true )
		toggleControl ( "vehicle_secondary_fire",true )
		toggleTurningKeys(vehicleID,true)
		fadeOutHelp()
		removeEventHandler ( "onClientPlayerVehicleExit",localPlayer,removeKeyToggles )
	end
	end
end
addCommandHandler ( "Toggle Driveby", toggleDriveby )

function getVehicleSpeed()
    if isPedInVehicle(getLocalPlayer()) then
	    local theVehicle = getPedOccupiedVehicle (getLocalPlayer())
        local vx, vy, vz = getElementVelocity (theVehicle)
        return math.sqrt(vx^2 + vy^2 + vz^2) * 100
    end
    return 0
end

function removeKeyToggles(vehicle)
	toggleControl ( "vehicle_look_left",true )
	toggleControl ( "vehicle_look_right",true )
	toggleControl ( "vehicle_secondary_fire",true )
	toggleTurningKeys(getElementModel(vehicle),true)
	fadeOutHelp()
	removeEventHandler ( "onClientPlayerVehicleExit",localPlayer,removeKeyToggles )
end


function switchDrivebyWeapon(key,progress)
	progress = tonumber(progress)
	if not progress then return end
	if shooting then return end
	if not isPedInVehicle( localPlayer ) then return end
	local currentWeapon = getPedWeapon( localPlayer )
	local currentSlot = getPedWeaponSlot(localPlayer)
	if currentSlot == 0 then return end
	if ( driver ) then weaponsTable = settings.driver
	else weaponsTable = settings.passenger end
	local switchTo
	for key,weaponID in ipairs(weaponsTable) do
		if weaponID == currentWeapon then
			local i = key + progress
			while i ~= key do
				nextWeapon = weaponsTable[i]
				if nextWeapon then
					local slot = getSlotFromWeapon ( nextWeapon )
					local weapon = getPedWeapon ( localPlayer, slot )
					if ( weapon == nextWeapon ) and weapon == 28 or weapon == 29 or weapon == 32 then
						switchToWeapon = weapon
						switchTo = slot
						break
					end
				end
				if not weaponsTable[i+progress] then
					if progress < 0 then
						i = #weaponsTable
					else
						i = 1
					end
				else
					i = i + progress
				end
			end
			break
		end
	end
	if not switchTo then return end
	lastSlot = switchTo
	setPedWeaponSlot( localPlayer, switchTo )
	limitDrivebySpeed ( switchToWeapon )
end
addCommandHandler ( "Next driveby weapon", switchDrivebyWeapon )
addCommandHandler ( "Previous driveby weapon", switchDrivebyWeapon )

local limiterTimer
function limitDrivebySpeed ( weaponID )
	local speed = settings.shotdelay[tostring(weaponID)]
	if not speed then 
		if not isControlEnabled ( "vehicle_fire" ) then 
			toggleControl ( "vehicle_fire", true )
		end
		removeEventHandler("onClientPlayerVehicleExit",localPlayer,unbindFire)
		removeEventHandler("onClientPlayerWasted",localPlayer,unbindFire)
		unbindKey ( "vehicle_fire", "both", limitedKeyPress )
	else
		if isControlEnabled ( "vehicle_fire" ) then 
			toggleControl ( "vehicle_fire", false )
			addEventHandler("onClientPlayerVehicleExit",localPlayer,unbindFire)
			addEventHandler("onClientPlayerWasted",localPlayer,unbindFire)
			bindKey ( "vehicle_fire","both",limitedKeyPress,speed)
		end
	end
end

function unbindFire()
	unbindKey ( "vehicle_fire", "both", limitedKeyPress )
	if not isControlEnabled ( "vehicle_fire" ) then 
			toggleControl ( "vehicle_fire", true )
	end
	removeEventHandler("onClientPlayerVehicleExit",localPlayer,unbindFire)
	removeEventHandler("onClientPlayerWasted",localPlayer,unbindFire)
end

local block
function limitedKeyPress (key,keyState,speed)
	if keyState == "down" then
		if block == true then return end
		shooting = true
		pressKey ( "vehicle_fire" )
		block = true
		setTimer ( function() block = false end, speed, 1 )
		limiterTimer = setTimer ( pressKey,speed, 0, "vehicle_fire" )
	else
		shooting = false
		for k,timer in ipairs(getTimers()) do
			if timer == limiterTimer then
				killTimer ( limiterTimer )
			end
		end
	end
end

function pressKey ( controlName )
	setPedControlState ( controlName, true )
	setTimer ( setPedControlState, 150, 1, controlName, false )
end

local bikes = { [581]=true,[509]=true,[481]=true,[462]=true,[521]=true,[463]=true,
	[510]=true,[522]=true,[461]=true,[448]=true,[468]=true,[586]=true }
function toggleTurningKeys(vehicleID, state)
	if bikes[vehicleID] then
		if not settings.steerBikes then
			toggleControl ( "vehicle_left", state )
			toggleControl ( "vehicle_right", state )
		end
	else
		if not settings.steerCars then
			toggleControl ( "vehicle_left", state )
			toggleControl ( "vehicle_right", state )
		end
	end
end
	
function fadeInHelp()
	if helpAnimation then helpAnimation:remove() end
	local _,_,_,a = helpText:color()
	if a == 255 then return end
	helpAnimation = Animation.createAndPlay(helpText, Animation.presets.dxTextFadeIn(300))
	setTimer ( function() helpText:color(255,255,255,255) end, 300, 1 )
end

function fadeOutHelp()
	if helpAnimation then helpAnimation:remove() end
	local _,_,_,a = helpText:color()
	if a == 0 then return end
	helpAnimation = Animation.createAndPlay(helpText, Animation.presets.dxTextFadeOut(300))
	setTimer ( function() helpText:color(255,255,255,0) end, 300, 1 )
end
