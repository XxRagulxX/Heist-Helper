-- ALL CODES ARE FROM IceDoomfist#0001 Thank you . 
        util.require_natives("natives-1651208000")
        util.toast("Heist Helper by XxRagulxX#9490")
        --- Github Integration :)
        local response = false
        localVer = 1.6
        async_http.init("raw.githubusercontent.com", "/XxRagulxX/Heist-Helper/main/version.lua", function(output)
            currentVer = tonumber(output)
            response = true
            if localVer ~= currentVer then
                util.toast("Heist Helper version is available, update the lua to get the newest version.")
                menu.action(menu.my_root(), "Update Lua", {}, "", function()
                    async_http.init('raw.githubusercontent.com','/XxRagulxX/Heist-Helper/main/HeistHelper.lua',function(a)
                        local err = select(2,load(a))
                        if err then
                            util.toast("Script failed to download. Please try again later. If this continues to happen then manually update via github.")
                        return end
                        local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                        f:write(a)
                        f:close()
                        util.toast("Successfully updated Heist Helper, please restart the script :)")
                        util.stop_script()
                    end)
                    async_http.dispatch()
                end)
            end
        end, function() response = true end)
        async_http.dispatch()
        repeat 
            util.yield()
        until response
        --end

        function MP_INDEX()
            return "MP" .. util.get_char_slot() .. "_"
        end
        function IS_MPPLY(Stat)
            local Stats = {
                "MP_PLAYING_TIME",
            }

            for i = 1, #Stats do
                if Stat == Stats[i] then
                    return true
                end
            end

            if string.find(Stat, "MPPLY_") then
                return true
            else
                return false
            end
        end
        function ADD_MP_INDEX(Stat)
            if not IS_MPPLY(Stat) then
                Stat = MP_INDEX() .. Stat
            end
            return Stat
        end

        function STAT_SET_INT(Stat, Value)
            STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
        end
        function STAT_SET_FLOAT(Stat, Value)
            STATS.STAT_SET_FLOAT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
        end
        function STAT_SET_BOOL(Stat, Value)
            STATS.STAT_SET_BOOL(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
        end
        function STAT_SET_STRING(Stat, Value)
            STATS.STAT_SET_STRING(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
        end
        function STAT_SET_DATE(Stat, Year, Month, Day, Hour, Min)
            local DatePTR = memory.alloc(7*8) 
            memory.write_int(DatePTR, Year)
            memory.write_int(DatePTR+8, Month)
            memory.write_int(DatePTR+16, Day)
            memory.write_int(DatePTR+24, Hour)
            memory.write_int(DatePTR+32, Min)
            memory.write_int(DatePTR+40, 0) -- Second
            memory.write_int(DatePTR+48, 0) -- Millisecond
            STATS.STAT_SET_DATE(util.joaat(ADD_MP_INDEX(Stat)), DatePTR, 7, true)
        end

        function STAT_SET_PACKED_BOOL(Stat, Value)
            STATS._SET_PACKED_STAT_BOOL(Stat, Value, util.get_char_slot())
        end
        function STAT_SET_INCREMENT(Stat, Value)
            STATS.STAT_INCREMENT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
        end

        function STAT_GET_PACKED_BOOL(Stat)
            STATS._GET_PACKED_STAT_BOOL(Stat, util.get_char_slot())
        end

        function STAT_GET_INT(Stat)
            local IntPTR = memory.alloc_int()
            STATS.STAT_GET_INT(util.joaat(ADD_MP_INDEX(Stat)), IntPTR, -1)
            return memory.read_int(IntPTR)
        end
        function STAT_GET_FLOAT(Stat)
            local FloatPTR = memory.alloc_int()
            STATS.STAT_GET_FLOAT(util.joaat(ADD_MP_INDEX(Stat)), FloatPTR, -1)
            return tonumber(string.format("%.3f", memory.read_float(FloatPTR)))
        end
        function STAT_GET_BOOL(Stat)
            if STAT_GET_INT(Stat) == 0 then
                return "false"
            elseif STAT_GET_INT(Stat) == 1 then
                return "true"
            else
                return "STAT_UNKNOWN"
            end 
        end
        function STAT_GET_STRING(Stat)
            return STATS.STAT_GET_STRING(util.joaat(ADD_MP_INDEX(Stat)), -1)
        end
        function STAT_GET_DATE(Stat, Sort)
            local DatePTR = memory.alloc(7*8)
            STATS.STAT_GET_DATE(util.joaat(ADD_MP_INDEX(Stat)), DatePTR, 7, true)
            local Add = 0
            if Sort == "Year" then
                Add = 0
            elseif Sort == "Month" then
                Add = 8
            elseif Sort == "Day" then
                Add = 16
            elseif Sort == "Hour" then
                Add = 24
            elseif Sort == "Min" then
                Add = 32
            end
            return memory.read_int(DatePTR+Add)
        end

        function SET_INT_GLOBAL(Global, Value)
            memory.write_int(memory.script_global(Global), Value)
        end
        function SET_FLOAT_GLOBAL(Global, Value)
            memory.write_float(memory.script_global(Global), Value)
        end

        function GET_INT_GLOBAL(Global)
            return memory.read_int(memory.script_global(Global))
        end

        function SET_PACKED_INT_GLOBAL(StartGlobal, EndGlobal, Value)
            for i = StartGlobal, EndGlobal do
                SET_INT_GLOBAL(262145 + i, Value)
            end
        end

        function SET_INT_LOCAL(Script, Local, Value)
            if memory.script_local(Script, Local) ~= 0 then
                memory.write_int(memory.script_local(Script, Local), Value)
            end
        end
        function SET_FLOAT_LOCAL(Script, Local, Value)
            if memory.script_local(Script, Local) ~= 0 then
                memory.write_float(memory.script_local(Script, Local), Value)
            end
        end

        function GET_INT_LOCAL(Script, Local)
            if memory.script_local(Script, Local) ~= 0 then
                local Value = memory.read_int(memory.script_local(Script, Local))
                if Value ~= nil then
                    return Value
                end
            end
        end

        function TELEPORT(X, Y, Z)
            PED.SET_PED_COORDS_KEEP_VEHICLE(players.user_ped(), X, Y, Z)
        end
        function SET_HEADING(Heading)
            ENTITY.SET_ENTITY_HEADING(players.user_ped(), Heading)
        end

        function IsWorking(IsAddNewLine)
            local State = "" -- If global and local variables have been changed due to the GTAO update then 
            if util.is_session_started() then
                if GET_INT_LOCAL("freemode", 3504) ~= util.joaat("lr_prop_carkey_fob") then -- freemode.c, joaat("lr_prop_carkey_fob")
                    State = "[NOT WORKING]"
                    if IsAddNewLine then
                        State = State .. "\n\n"
                    end
                end
            end
            return State
        end

        function RGB(R, G, B, A) 
            local Color = {}
            Color.r = R
            Color.g = G
            Color.b = B
            Color.a = A
            return Color
        end

        function HelpMsgBeingDisplayed(Label) 
            HUD.BEGIN_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(Label)
            return HUD.END_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(0)
        end

        function IS_PED_PLAYER(Ped)
            if PED.GET_PED_TYPE(Ped) >= 4 then
                return false
            else
                return true
            end
        end

        function FORCE_CLOUD_SAVE()
            STATS.STAT_SAVE(0, 0, 3, 0)
            util.yield(1500)
            util.arspinner_enable()
            util.yield(4500)
            util.arspinner_disable()
        end

        function IA_MENU_OPEN()
            PAD._SET_CONTROL_NORMAL(0, 244, 1)
            util.yield(200)
        end
        function IA_MENU_UP(Num)
            for i = 1, Num do
                PAD._SET_CONTROL_NORMAL(0, 172, 1)
                util.yield(200)
            end
        end
        function IA_MENU_DOWN(Num)
            for i = 1, Num do
                PAD._SET_CONTROL_NORMAL(0, 173, 1)
                util.yield(200)
            end
        end
        function IA_MENU_ENTER(Num)
            for i = 1, Num do
                PAD._SET_CONTROL_NORMAL(0, 176, 1)
                util.yield(200)
            end
        end
        INT_MIN = -2147483648
        INT_MAX = 2147483647
        util.keep_running()
--- Main Lists

        local PERICO_HEIST = menu.list(menu.my_root(), ("Cayo Perico Heist"), {"hccp"}, "", function();  end)
        local CASINO_HEIST = menu.list(menu.my_root(), ("Diamond Casino Heist"), {"hccah"}, "", function(); end)
        local DOOMS_HEIST = menu.list(menu.my_root(), ("Doomsday Heist"), {"hcdooms"}, "", function(); end)
        local CLASSIC_HEISTS = menu.list(menu.my_root(), ("Classic Heist"), {"hcclassic"}, "", function(); end)

--- Cayo Perico Heist
    
    local CAYO_AUTO_PRST = menu.list(PERICO_HEIST, ("Automated Presets"), {}, ("- Remember to choose your preset outside the Submarine or in the Main Deck") .. "\n\n" .. ("- Remember to deactivate the preset at the end."), function(); end)

        local AUTOMATED_SOLO = menu.list(CAYO_AUTO_PRST, ("1 Player"), {}, "", function(); end)

            menu.toggle_loop(AUTOMATED_SOLO, ("Sapphire Panther"), {"hccp1psp"}, IsWorking(false), function()
                STAT_SET_INT("H4CNF_BOLTCUT", -1)
                STAT_SET_INT("H4CNF_UNIFORM", -1)
                STAT_SET_INT("H4CNF_GRAPPEL", -1)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                STAT_SET_INT("H4CNF_TARGET", 5)
                STAT_SET_INT("H4LOOT_CASH_I", 5551206)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 5551206)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 4884838)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 4884838)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 192)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 192)
                STAT_SET_INT("H4LOOT_WEED_I", 0)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 120)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 120)
                STAT_SET_INT("H4LOOT_CASH_V", 224431)
                STAT_SET_INT("H4LOOT_COKE_V", 353863)
                STAT_SET_INT("H4LOOT_GOLD_V", 471817)
                STAT_SET_INT("H4LOOT_PAINT_V", 353863)
                STAT_SET_INT("H4LOOT_WEED_V", 0)
                STAT_SET_INT("H4_PROGRESS", 131055)
                STAT_SET_INT("H4CNF_BS_GEN", -1)
                STAT_SET_INT("H4CNF_BS_ENTR", -1)
                STAT_SET_INT("H4CNF_BS_ABIL", -1)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
            end)

            menu.toggle_loop(AUTOMATED_SOLO, ("Ruby Necklace"), {"hccp1prn"}, IsWorking(false), function()
                STAT_SET_INT("H4CNF_TARGET", 1)
                STAT_SET_INT("H4LOOT_CASH_I", 9208137)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 9208137)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 1048704)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 1048704)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 255)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 255)
                STAT_SET_INT("H4LOOT_WEED_I", 4206596)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 4206596)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 127)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 127)
                STAT_SET_INT("H4LOOT_CASH_V", 424431)
                STAT_SET_INT("H4LOOT_COKE_V", 848863)
                STAT_SET_INT("H4LOOT_GOLD_V", 1131817)
                STAT_SET_INT("H4LOOT_PAINT_V", 848863)
                STAT_SET_INT("H4LOOT_WEED_V", 679090)
                STAT_SET_INT("H4_PROGRESS", 131055)
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
            end)

        ---

        local AUTOMATED_2P = menu.list(CAYO_AUTO_PRST, ("2 Players"), {}, "", function(); end)

            menu.toggle_loop(AUTOMATED_2P, ("Sapphire Panther"), {"hccp2psp"}, IsWorking(false), function()   
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                STAT_SET_INT("H4CNF_TARGET", 5)
                STAT_SET_INT("H4LOOT_CASH_I", 2359448)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 2359448)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 2)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 2)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 255)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 255)
                STAT_SET_INT("H4LOOT_WEED_I", 0)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 127)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 127)
                STAT_SET_INT("H4LOOT_CASH_V", 474431)
                STAT_SET_INT("H4LOOT_COKE_V", 948863)
                STAT_SET_INT("H4LOOT_GOLD_V", 1265151)
                STAT_SET_INT("H4LOOT_PAINT_V", 948863)
                STAT_SET_INT("H4LOOT_WEED_V", 0)
                STAT_SET_INT("H4_PROGRESS", 126823)
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 50)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 50)
                menu.set_value(CP_2P_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_2P_CUT_LOOP, false)
            end)

            menu.toggle_loop(AUTOMATED_2P, ("Ruby Necklace"), {"hccp2prn"}, IsWorking(false), function()  
                STAT_SET_INT("H4CNF_TARGET", 1)
                STAT_SET_INT("H4LOOT_CASH_I", 9208137)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 9208137)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 1048704)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 1048704)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 255)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 255)
                STAT_SET_INT("H4LOOT_WEED_I", 4206596)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 4206596)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 127)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 127)
                STAT_SET_INT("H4LOOT_CASH_V", 572727)
                STAT_SET_INT("H4LOOT_COKE_V", 1145454)
                STAT_SET_INT("H4LOOT_GOLD_V", 1527272)
                STAT_SET_INT("H4LOOT_PAINT_V", 1145454)
                STAT_SET_INT("H4LOOT_WEED_V", 916363)
                STAT_SET_INT("H4_PROGRESS", 126823)
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 50)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 50)
                menu.set_value(CP_2P_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_2P_CUT_LOOP, false)
            end)

        ---

        local AUTOMATED_3P = menu.list(CAYO_AUTO_PRST, ("3 Players"), {}, "", function(); end)

            menu.toggle_loop(AUTOMATED_3P, ("Sapphire Panther"), {"hccp3psp"}, IsWorking(false), function()
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                STAT_SET_INT("H4CNF_TARGET", 5)
                STAT_SET_INT("H4LOOT_CASH_I", 2359448)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 2359448)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 4901222)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 4901222)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 255)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 255)
                STAT_SET_INT("H4LOOT_WEED_I", 0)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 127)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 127)
                STAT_SET_INT("H4LOOT_CASH_V", 515151)
                STAT_SET_INT("H4LOOT_COKE_V", 1030303)
                STAT_SET_INT("H4LOOT_GOLD_V", 1373737)
                STAT_SET_INT("H4LOOT_PAINT_V", 1030303)
                STAT_SET_INT("H4LOOT_WEED_V", 0)
                STAT_SET_INT("H4_PROGRESS", 126823)
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 30)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 35)
                menu.set_value(CP_2P_CUT_LOOP, true)
                menu.set_value(CP_3P_CUT, 35)
                menu.set_value(CP_3P_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_2P_CUT_LOOP, false)
                menu.set_value(CP_3P_CUT, 100)
                menu.set_value(CP_3P_CUT_LOOP, false)
            end)

            menu.toggle_loop(AUTOMATED_3P, ("Ruby Necklace"), {"hccp3prn"}, IsWorking(false), function()
                STAT_SET_INT("H4CNF_TARGET", 1)
                STAT_SET_INT("H4LOOT_CASH_I", 9208137)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 9208137)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 1048704)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 1048704)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 255)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 255)
                STAT_SET_INT("H4LOOT_WEED_I", 4206596)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 4206596)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 127)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 127)
                STAT_SET_INT("H4LOOT_CASH_V", 598268)
                STAT_SET_INT("H4LOOT_COKE_V", 1196536)
                STAT_SET_INT("H4LOOT_GOLD_V", 1595382)
                STAT_SET_INT("H4LOOT_PAINT_V", 1196536)
                STAT_SET_INT("H4LOOT_WEED_V", 957229)
                STAT_SET_INT("H4_PROGRESS", 126823)
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 30)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 35)
                menu.set_value(CP_2P_CUT_LOOP, true)
                menu.set_value(CP_3P_CUT, 35)
                menu.set_value(CP_3P_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_2P_CUT_LOOP, false)
                menu.set_value(CP_3P_CUT, 100)
                menu.set_value(CP_3P_CUT_LOOP, false)
            end)

        ---

        local AUTOMATED_4P = menu.list(CAYO_AUTO_PRST, ("4 Players"), {}, "", function(); end)

            menu.toggle_loop(AUTOMATED_4P, ("Sapphire Panther"), {"hccp4psp"}, IsWorking(false), function()
                STAT_SET_INT("H4CNF_TARGET", 5)
                STAT_SET_INT("H4LOOT_CASH_I", 2359448)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 2359448)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 4901222)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 4901222)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 255)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 255)
                STAT_SET_INT("H4LOOT_WEED_I", 0)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 127)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 127)
                STAT_SET_INT("H4LOOT_CASH_V", 599431)
                STAT_SET_INT("H4LOOT_COKE_V", 1198863)
                STAT_SET_INT("H4LOOT_GOLD_V", 1598484)
                STAT_SET_INT("H4LOOT_PAINT_V", 1198863)
                STAT_SET_INT("H4LOOT_WEED_V", 0)
                STAT_SET_INT("H4_PROGRESS", 126823)
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 25)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 25)
                menu.set_value(CP_2P_CUT_LOOP, true)
                menu.set_value(CP_3P_CUT, 25)
                menu.set_value(CP_3P_CUT_LOOP, true)
                menu.set_value(CP_4P_CUT, 25)
                menu.set_value(CP_4P_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_2P_CUT_LOOP, false)
                menu.set_value(CP_3P_CUT, 100)
                menu.set_value(CP_3P_CUT_LOOP, false)
                menu.set_value(CP_4P_CUT, 100)
                menu.set_value(CP_4P_CUT_LOOP, false)
            end)

            menu.toggle_loop(AUTOMATED_4P, ("Ruby Necklace"), {"hccp4prn"}, IsWorking(false), function()
                STAT_SET_INT("H4CNF_TARGET", 1)
                STAT_SET_INT("H4LOOT_CASH_I", 9208137)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 9208137)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 1048704)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 1048704)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 255)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 255)
                STAT_SET_INT("H4LOOT_WEED_I", 4206596)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 4206596)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT", 127)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 127)
                STAT_SET_INT("H4LOOT_CASH_V", 655681)
                STAT_SET_INT("H4LOOT_COKE_V", 1311363)
                STAT_SET_INT("H4LOOT_GOLD_V", 1748484)
                STAT_SET_INT("H4LOOT_PAINT_V", 1311363)
                STAT_SET_INT("H4LOOT_WEED_V", 1049090)
                STAT_SET_INT("H4_PROGRESS", 126823)
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4_MISSIONS", -1)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4CNF_TROJAN", 5)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 100)
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT, 25)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 25)
                menu.set_value(CP_2P_CUT_LOOP, true)
                menu.set_value(CP_3P_CUT, 25)
                menu.set_value(CP_3P_CUT_LOOP, true)
                menu.set_value(CP_4P_CUT, 25)
                menu.set_value(CP_4P_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_2P_CUT_LOOP, false)
                menu.set_value(CP_3P_CUT, 100)
                menu.set_value(CP_3P_CUT_LOOP, false)
                menu.set_value(CP_4P_CUT, 100)
                menu.set_value(CP_4P_CUT_LOOP, false)
            end)

        ---

        menu.toggle(CAYO_AUTO_PRST, ("Quick Preset [1 ~ 4P]"), {"hccpquick"}, IsWorking(false), function(Toggle)
            quickcp = Toggle

            if quickcp then
                NOTIFY(("There are no secondary targets, only one primary target exists. Your goal is get it.") .. "\n\n" .. ("Leave activated until the end of the heist"))
            end

            if not quickcp then
                menu.set_value(CP_REM_FEE, false)
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_3P_CUT_LOOP, false)
                menu.set_value(CP_3P_CUT, 100)
                menu.set_value(CP_4P_CUT_LOOP, false)
                menu.set_value(CP_4P_CUT, 100)
            end

            while quickcp do
                STAT_SET_INT("H4CNF_BS_GEN", 262143)
                STAT_SET_INT("H4CNF_BS_ENTR", 63)
                STAT_SET_INT("H4CNF_BS_ABIL", 63)
                STAT_SET_INT("H4CNF_WEP_DISRP", 3)
                STAT_SET_INT("H4CNF_ARM_DISRP", 3)
                STAT_SET_INT("H4CNF_HEL_DISRP", 3)
                STAT_SET_INT("H4CNF_BOLTCUT", 4424)
                STAT_SET_INT("H4CNF_UNIFORM", 5256)
                STAT_SET_INT("H4CNF_GRAPPEL", 5156)
                STAT_SET_INT("H4CNF_APPROACH", -1)
                STAT_SET_INT("H4LOOT_CASH_I", 0)
                STAT_SET_INT("H4LOOT_CASH_C", 0)
                STAT_SET_INT("H4LOOT_WEED_I", 0)
                STAT_SET_INT("H4LOOT_WEED_C", 0)
                STAT_SET_INT("H4LOOT_COKE_I", 0)
                STAT_SET_INT("H4LOOT_COKE_C", 0)
                STAT_SET_INT("H4LOOT_GOLD_I", 0)
                STAT_SET_INT("H4LOOT_GOLD_C", 0)
                STAT_SET_INT("H4LOOT_PAINT", 0)
                STAT_SET_INT("H4LOOT_CASH_V", 0)
                STAT_SET_INT("H4LOOT_COKE_V", 0)
                STAT_SET_INT("H4LOOT_GOLD_V", 0)
                STAT_SET_INT("H4LOOT_PAINT_V", 0)
                STAT_SET_INT("H4LOOT_WEED_V", 0)
                STAT_SET_INT("H4LOOT_CASH_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_CASH_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_WEED_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_WEED_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_COKE_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_I_SCOPED", 0)
                STAT_SET_INT("H4LOOT_GOLD_C_SCOPED", 0)
                STAT_SET_INT("H4LOOT_PAINT_SCOPED", 0)
                STAT_SET_INT("H4CNF_TARGET", 5)
                STAT_SET_INT("H4CNF_WEAPONS", 1)
                STAT_SET_INT("H4_MISSIONS", 65283)
                STAT_SET_INT("H4_PROGRESS", 126823)
                STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 5)
                SET_INT_GLOBAL(262145 + 29975, 2455000) -- 266828370
                menu.set_value(CP_REM_FEE, true)
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 145)
                menu.set_value(CP_2P_CUT_LOOP, true)
                menu.set_value(CP_3P_CUT, 145)
                menu.set_value(CP_3P_CUT_LOOP, true)
                menu.set_value(CP_4P_CUT, 145)
                menu.set_value(CP_4P_CUT_LOOP, true)

                util.yield()
            end
        end)
        menu.action(CAYO_AUTO_PRST,("Set Heist to Default [Reset]"), {"hccpreset"}, "", function()
            STAT_SET_INT("H4_MISSIONS", 0)
            STAT_SET_INT("H4_PROGRESS", 0)
            STAT_SET_INT("H4CNF_APPROACH", 0)
            STAT_SET_INT("H4CNF_BS_ENTR", 0)
            STAT_SET_INT("H4CNF_BS_GEN", 0)
            STAT_SET_INT("H4_PLAYTHROUGH_STATUS", 0)
            STAT_SET_INT("H4CNF_TARGET", -1)
        end)
        local PERICO_ADV = menu.list(PERICO_HEIST, ("Advanced Features"), {}, "", function(); end)

        local HSCUT_CP = menu.list(PERICO_ADV, ("Players Cut"), {}, "", function(); end)

            local PERICO_HOST_CUT = menu.list(HSCUT_CP, ("Your Cut"), {}, "", function(); end)

                CP_HOST_CUT_LOOP = menu.toggle_loop(PERICO_HOST_CUT, ("Enable"), {"hccphostcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 1, menu.get_value(CP_HOST_CUT)) -- heist_island_planning.c
                end, function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 1, 100)
                end)

                CP_HOST_CUT = menu.slider(PERICO_HOST_CUT, ("Custom Payout"), {"hccphostcut"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---

            local PERICO_P2_CUT = menu.list(HSCUT_CP, ("Player 2"), {}, "", function(); end)

                CP_2P_CUT_LOOP = menu.toggle_loop(PERICO_P2_CUT, ("Enable"), {"hccp2pcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 2, menu.get_value(CP_2P_CUT)) -- heist_island_planning.c
                end, function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 2, 100)
                end)

                CP_2P_CUT = menu.slider(PERICO_P2_CUT, ("Custom Payout"), {"hccp2pcut"}, "(%)", 0, 1000, 100, 5, function(); end)
            
            ---
            
            local PERICO_P3_CUT = menu.list(HSCUT_CP, ("Player 3"), {}, "", function(); end)

                CP_3P_CUT_LOOP = menu.toggle_loop(PERICO_P3_CUT, ("Enable"), {"hccp3pcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 3, menu.get_value(CP_3P_CUT)) -- heist_island_planning.c
                end, function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 3, 100)
                end)

                CP_3P_CUT = menu.slider(PERICO_P3_CUT, ("Custom Payout"), {"hccp3pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---

            local PERICO_P4_CUT = menu.list(HSCUT_CP, ("Player 4"), {}, "", function(); end)

                CP_4P_CUT_LOOP = menu.toggle_loop(PERICO_P4_CUT, ("Enable"), {"hccp4pcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 4, menu.get_value(CP_4P_CUT)) -- heist_island_planning.c
                end, function()
                    SET_INT_GLOBAL(1973321 + 823 + 56 + 4, 100)
                end)

                CP_4P_CUT = menu.slider(PERICO_P4_CUT, ("Custom Payout"), {"hccp4pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---
            
            menu.toggle_loop(HSCUT_CP, ("Set 100% to everyone"), {"hccpcutall100"}, IsWorking(false), function()
                menu.set_value(CP_HOST_CUT, 100)
                menu.set_value(CP_HOST_CUT_LOOP, true)
                menu.set_value(CP_2P_CUT, 100)
                menu.set_value(CP_2P_CUT_LOOP, true)
                menu.set_value(CP_3P_CUT, 100)
                menu.set_value(CP_3P_CUT_LOOP, true)
                menu.set_value(CP_4P_CUT, 100)
                menu.set_value(CP_4P_CUT_LOOP, true)
            end, function()
                menu.set_value(CP_HOST_CUT_LOOP, false)
                menu.set_value(CP_2P_CUT_LOOP, false)
                menu.set_value(CP_3P_CUT_LOOP, false)
                menu.set_value(CP_4P_CUT_LOOP, false)
            end)

        ---

        menu.list_action(PERICO_ADV, ("Bag Capacity Modifier"), {"hccpbag"}, IsWorking(true) .. ("[Locally]"), {
            { ("Normal Bag Limit"), {"1p"} },
            { ("Simulate Bag to 2 players"), {"2p"} },
            { ("Simulate Bag to 3 players"), {"3p"} },
            { ("Simulate Bag to 4 players"), {"4p"} },
            { ("Infinite Bag"), {"inf"} },
        }, function(Index)
            if Index ~= 5 then
                SET_INT_GLOBAL(262145 + 29720, 1800 * Index) -- 1859395035
            else
                SET_INT_GLOBAL(262145 + 29720, 99999)
            end
        end)



        menu.toggle_loop(PERICO_ADV, ("Skip Sewer Cutter"), {}, IsWorking(true) .. "Use with Cayo Perico Heist > Custom Teleport > Island > Drainage!", function() 
            if HelpMsgBeingDisplayed("UT_WELD_PROMPT") then -- "~s~Press ~INPUT_CONTEXT~ to cut through the grill."
                PAD._SET_CONTROL_NORMAL(2, 51, 1)
            elseif GET_INT_LOCAL("fm_mission_controller_2020", 27500) == 4 then -- Local from https://www.unknowncheats.me/forum/3389282-post1.html  
                SET_INT_LOCAL("fm_mission_controller_2020", 27500, 6)
            end
        end)

        menu.toggle_loop(PERICO_ADV, ("Open Plasma Glass Immediately"), {}, IsWorking(false), function()
            SET_FLOAT_LOCAL("fm_mission_controller_2020", 28736 + 3, 100)
        end, function()
            SET_FLOAT_LOCAL("fm_mission_controller_2020", 28736 + 3, 0)
        end)

        menu.toggle_loop(PERICO_ADV, ("Bypass Plasma Glass Cutter Heat"), {}, IsWorking(false), function()
            SET_FLOAT_LOCAL("fm_mission_controller_2020", 28736 + 4, 0)
        end)

        menu.toggle_loop(PERICO_ADV, ("Infinite Voltage Timer"), {}, IsWorking(false), function()
            local Value = GET_INT_LOCAL("fm_mission_controller_2020", 1716)
            SET_INT_LOCAL("fm_mission_controller_2020", 1715, Value)
        end, function()
            SET_INT_LOCAL("fm_mission_controller_2020", 1715, 0)
        end)

        CP_REM_FEE = menu.toggle_loop(PERICO_ADV, ("Remove Fencing Fee & Pavel Cut"), {"hccpremfee"}, IsWorking(true) .. ("Leave activated until the end of the heist"), function()
            SET_FLOAT_GLOBAL(262145 + 29979, 0) -- 902085532
            SET_FLOAT_GLOBAL(262145 + 29980, 0) -- -1135949374
        end, function()
            SET_FLOAT_GLOBAL(262145 + 29979, -0.1)
            SET_FLOAT_GLOBAL(262145 + 29980, -0.02)
        end)

        menu.action(PERICO_ADV, ("Auto-finish Primary Target"), {"hccpfintar"}, IsWorking(false), function() -- Locals from https://www.unknowncheats.me/forum/3418914-post13398.html, Values from Heist Control for Nightfall
            SET_INT_LOCAL("fm_mission_controller_2020", 28735, 5) -- CutterStage
            SET_INT_LOCAL("fm_mission_controller_2020", 28736, 3) -- BitCheck
        end)

        menu.action(PERICO_ADV, ("Remove Drainage Pipe"), {"hccprempipe"}, "", function() -- Thanks to help me to code, Sapphire#6031
            for k, ent in pairs(entities.get_all_objects_as_handles()) do
                if ENTITY.GET_ENTITY_MODEL(ent) == -1297635988 then
                    entities.delete_by_handle(ent)
                end
            end
        end)


    local TELEPORT_CP = menu.list(PERICO_HEIST, ("Teleport"), {}, "", function(); end)

        local CAYO_TELE_COMPOUND = menu.list(TELEPORT_CP, ("Compound"), {}, "", function(); end)

            local CAYO_TELE_STORAGE = menu.list(CAYO_TELE_COMPOUND, ("Storage"), {}, "", function(); end)

                menu.action(CAYO_TELE_STORAGE, ("North"), {}, "", function()
                    TELEPORT(5081.0415, -5755.32, 15.829645)
                end)
                menu.action(CAYO_TELE_STORAGE, ("West"), {}, "", function()
                    TELEPORT(5006.722, -5786.5967, 17.831688)
                end)
                menu.action(CAYO_TELE_STORAGE, ("South"), {}, "", function()
                    TELEPORT(5027.603, -5734.682, 17.255005)
                end)

            ---

            local CAYO_TELE_VAULT = menu.list(CAYO_TELE_COMPOUND, ("Vault"), {}, "", function(); end)

                CAYO_TELE_VAULT_PRIMARY = menu.action(CAYO_TELE_VAULT, ("Primary Target"), {}, "", function()
                    TELEPORT(5006.7, -5756.2, 14.8)
                    SET_HEADING(145)
                end)
                menu.action(CAYO_TELE_VAULT, ("Secondary Target"), {}, "", function()
                    TELEPORT(4999.764160, -5749.863770, 14.840000)
                end)

            ---

            menu.action(CAYO_TELE_COMPOUND, ("El Rubio's Office"), {}, "", function()
                TELEPORT(5010.12, -5750.1353, 28.84334)
                SET_HEADING(325)
            end)
            menu.action(CAYO_TELE_COMPOUND, ("Front Gate Exit"), {}, "", function()
                TELEPORT(4990.0386, -5717.6895, 19.880217)
                SET_HEADING(50)
            end)

        ---

        local CAYO_TELE_ISLAND = menu.list(TELEPORT_CP, ("Island"), {}, "", function(); end)

            local CAYO_TELE_AIRSTRIP = menu.list(CAYO_TELE_ISLAND, ("Airstrip"), {}, "", function(); end)

                menu.action(CAYO_TELE_AIRSTRIP, ("Loot") .. " - #1", {}, "", function()
                    TELEPORT(4503.587402, -4555.740723, 2.854459)
                end)
                menu.action(CAYO_TELE_AIRSTRIP, ("Loot") .. " - #2", {}, "", function()
                    TELEPORT(4437.821777, -4447.841309, 3.028436)
                end)
                menu.action(CAYO_TELE_AIRSTRIP, ("Loot") .. " - #3", {}, "", function()
                    TELEPORT(4447.091797, -4442.184082, 5.936794)
                end)

            ---

            local CAYO_TELE_CROP_FIELDS = menu.list(CAYO_TELE_ISLAND, ("Crop Fields"), {}, "", function(); end)

                menu.action(CAYO_TELE_CROP_FIELDS, ("Loot") .. " - #1", {}, "", function()
                    TELEPORT(5330.527, -5269.7515, 33.18603)
                end)

            ---

            local CAYO_TELE_MAIN_DOCK = menu.list(CAYO_TELE_ISLAND, ("Main Dock"), {}, "", function(); end)

                menu.action(CAYO_TELE_MAIN_DOCK, ("Loot") .. " - #1", {}, "", function()
                    TELEPORT(5193.909668, -5135.642578, 2.045917)
                end)
                menu.action(CAYO_TELE_MAIN_DOCK, ("Loot") .. " - #2", {}, "", function()
                    TELEPORT(4963.184570, -5108.933105, 1.670808)
                end)
                menu.action(CAYO_TELE_MAIN_DOCK, ("Loot") .. " - #3", {}, "", function()
                    TELEPORT(4998.709473, -5165.559570, 1.464137)
                end)
                menu.action(CAYO_TELE_MAIN_DOCK, ("Loot") .. " - #4", {}, "", function()
                    TELEPORT(4924.693359, -5243.244629, 1.223599)
                end)

            ---

            local CAYO_TELE_NORTH_DOCK = menu.list(CAYO_TELE_ISLAND, ("North Dock"), {}, "", function(); end)

                menu.action(CAYO_TELE_NORTH_DOCK, ("Loot") .. " - #1", {}, "", function()
                    TELEPORT(5132.558594, -4612.922852, 1.162808)
                end)
                menu.action(CAYO_TELE_NORTH_DOCK, ("Loot") .. " - #2", {}, "", function()
                    TELEPORT(5065.255371, -4591.706543, 1.555012)
                end)
                menu.action(CAYO_TELE_NORTH_DOCK, ("Loot") .. " - #3", {}, "", function()
                    TELEPORT(5090.916016, -4682.670898, 1.107098)
                end)

            ---

                menu.action(CAYO_TELE_ISLAND, ("Radio Tower"), {}, "", function()
                    TELEPORT(5263.7124, -5407.5835, 65.24931)
                end)
                CAYO_TELE_ISLAND_DRAINGE_1ST = menu.action(CAYO_TELE_ISLAND, ("Drainage"), {}, "", function()
                    TELEPORT(5044.001, -5815.6426, -11.808871)
                end)
                CAYO_TELE_ISLAND_DRAINGE_2ND = menu.action(CAYO_TELE_ISLAND, ("Drainage: 2nd Checkpoint"), {}, "", function()
                    TELEPORT(5053.773, -5773.2266, -5.40778)
                end)
                menu.action(CAYO_TELE_ISLAND, ("Ocean Safe Place"), {}, "", function()
                    TELEPORT(4771.479, -6165.737, -39.079613)
                end)

        menu.action(TELEPORT_CP, ("Kosatka: Heist Board [Call Kosatka first]"), {"hctpsub"}, "", function()
            if STAT_GET_INT("IH_SUB_OWNED") == 0 then
                NOTIFY(("You have not bought Kosatka yet. Buy it first to teleport!"))
            else
                TELEPORT(1561.2369, 385.8771, -49.689915)
                SET_HEADING(175)
            end
        end)

        menu.toggle_loop(PERICO_HEIST, ("Skip Hacking"), {}, IsWorking(false), function() 
            if GET_INT_LOCAL("fm_mission_controller_2020", 23385) == 4 then -- Locals from https://www.unknowncheats.me/forum/3418914-post13398.html, Values from Heist Control for Nightfall
                SET_INT_LOCAL("fm_mission_controller_2020", 23385, 5)
            end
        end)
    
--- Diamond Casino Heist

    local CASINO_PRESETS = menu.list(CASINO_HEIST, ("Automated Presets"), {}, "Remember to deactivate the preset at the end.", function(); end)

        local CASINO_PRESETS_DIAMOND = menu.list(CASINO_PRESETS, ("Diamond"), {}, ("$3.5 Millions & For All Players"), function(); end)

            menu.toggle(CASINO_PRESETS_DIAMOND, ("Silent & Sneaky Approach"), {"hccahdiasil"}, IsWorking(true) .. ("ALWAYS choose Low Level Buyer!"), function(Toggle)
                DiamondST = Toggle

                if DiamondST then
                    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)
                    STAT_SET_INT("H3OPT_MASKS", 4)
                    STAT_SET_INT("H3OPT_WEAPS", 1)
                    STAT_SET_INT("H3OPT_VEHS", 3)
                end

                if not DiamondST then
                    menu.set_value(CAH_1P_CUT, 100)
                    menu.set_value(CAH_1P_CUT_LOOP, false)
                    menu.set_value(CAH_2P_CUT, 100)
                    menu.set_value(CAH_2P_CUT_LOOP, false)
                    menu.set_value(CAH_3P_CUT, 100)
                    menu.set_value(CAH_3P_CUT_LOOP, false)
                    menu.set_value(CAH_4P_CUT, 100)
                    menu.set_value(CAH_4P_CUT_LOOP, false)
                end

                while DiamondST do
                    STAT_SET_INT("CAS_HEIST_FLOW", -1)
                    STAT_SET_INT("H3_LAST_APPROACH", 0)
                    STAT_SET_INT("H3OPT_APPROACH", 1)
                    STAT_SET_INT("H3_HARD_APPROACH", 0)
                    STAT_SET_INT("H3OPT_TARGET", 3)
                    STAT_SET_INT("H3OPT_POI", 1023)
                    STAT_SET_INT("H3OPT_ACCESSPOINTS", 2047)
                    STAT_SET_INT("H3OPT_CREWWEAP", 4)
                    STAT_SET_INT("H3OPT_CREWDRIVER", 3)
                    STAT_SET_INT("H3OPT_CREWHACKER", 4)
                    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
                    STAT_SET_INT("H3OPT_BODYARMORLVL", -1)
                    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
                    STAT_SET_INT("H3OPT_BITSET1", 127)
                    STAT_SET_INT("H3OPT_BITSET0", 262270)
                    SET_INT_GLOBAL(262145 + 28796, 1410065408) -- 1277889925
                    menu.set_value(CAH_1P_CUT, 60)
                    menu.set_value(CAH_1P_CUT_LOOP, true)
                    menu.set_value(CAH_2P_CUT, 147)
                    menu.set_value(CAH_2P_CUT_LOOP, true)
                    menu.set_value(CAH_3P_CUT, 147)
                    menu.set_value(CAH_3P_CUT_LOOP, true)
                    menu.set_value(CAH_4P_CUT, 147)
                    menu.set_value(CAH_4P_CUT_LOOP, true)

                    util.yield()
                end
            end)

            menu.toggle(CASINO_PRESETS_DIAMOND, ("BigCon Approach"), {"hccahdiabig"}, IsWorking(true) .. ("ALWAYS choose Low Level Buyer!"), function(Toggle)
                DiamondND = Toggle

                if DiamondND then
                    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)
                    STAT_SET_INT("H3OPT_MASKS", 2)
                    STAT_SET_INT("H3OPT_WEAPS", 1)
                    STAT_SET_INT("H3OPT_VEHS", 3)
                end

                if not DiamondND then
                    menu.set_value(CAH_1P_CUT, 100)
                    menu.set_value(CAH_1P_CUT_LOOP, false)
                    menu.set_value(CAH_2P_CUT, 100)
                    menu.set_value(CAH_2P_CUT_LOOP, false)
                    menu.set_value(CAH_3P_CUT, 100)
                    menu.set_value(CAH_3P_CUT_LOOP, false)
                    menu.set_value(CAH_4P_CUT, 100)
                    menu.set_value(CAH_4P_CUT_LOOP, false)
                end

                while DiamondND do
                    STAT_SET_INT("CAS_HEIST_FLOW", -1)
                    STAT_SET_INT("H3_LAST_APPROACH", 0)
                    STAT_SET_INT("H3OPT_APPROACH", 2)
                    STAT_SET_INT("H3_HARD_APPROACH", 0)
                    STAT_SET_INT("H3OPT_TARGET", 3)
                    STAT_SET_INT("H3OPT_POI", 1023)
                    STAT_SET_INT("H3OPT_ACCESSPOINTS", 2047)
                    STAT_SET_INT("H3OPT_CREWWEAP", 4)
                    STAT_SET_INT("H3OPT_CREWDRIVER", 3)
                    STAT_SET_INT("H3OPT_CREWHACKER", 4)
                    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
                    STAT_SET_INT("H3OPT_BODYARMORLVL", -1)
                    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
                    STAT_SET_INT("H3OPT_BITSET1", 159)
                    STAT_SET_INT("H3OPT_BITSET0", 524118)
                    SET_INT_GLOBAL(262145 + 28796, 1410065408)
                    menu.set_value(CAH_1P_CUT, 60)
                    menu.set_value(CAH_1P_CUT_LOOP, true)
                    menu.set_value(CAH_2P_CUT, 147)
                    menu.set_value(CAH_2P_CUT_LOOP, true)
                    menu.set_value(CAH_3P_CUT, 147)
                    menu.set_value(CAH_3P_CUT_LOOP, true)
                    menu.set_value(CAH_4P_CUT, 147)
                    menu.set_value(CAH_4P_CUT_LOOP, true)

                    util.yield()
                end
            end)

            menu.toggle(CASINO_PRESETS_DIAMOND, ("Aggressive Approach"), {"hccahdiaagg"}, IsWorking(true) .. ("ALWAYS choose Low Level Buyer!"), function(Toggle)
                DiamondRD = Toggle

                if DiamondRD then
                    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)
                    STAT_SET_INT("H3OPT_MASKS", 4)
                    STAT_SET_INT("H3OPT_WEAPS", 1)
                    STAT_SET_INT("H3OPT_VEHS", 3)
                end

                if not DiamondRD then
                    menu.set_value(CAH_1P_CUT, 100)
                    menu.set_value(CAH_1P_CUT_LOOP, false)
                    menu.set_value(CAH_2P_CUT, 100)
                    menu.set_value(CAH_2P_CUT_LOOP, false)
                    menu.set_value(CAH_3P_CUT, 100)
                    menu.set_value(CAH_3P_CUT_LOOP, false)
                    menu.set_value(CAH_4P_CUT, 100)
                    menu.set_value(CAH_4P_CUT_LOOP, false)
                end

                while DiamondRD do
                    STAT_SET_INT("CAS_HEIST_FLOW", -1)
                    STAT_SET_INT("H3_LAST_APPROACH", 0)
                    STAT_SET_INT("H3OPT_APPROACH", 3)
                    STAT_SET_INT("H3_HARD_APPROACH", 0)
                    STAT_SET_INT("H3OPT_TARGET", 3)
                    STAT_SET_INT("H3OPT_POI", 1023)
                    STAT_SET_INT("H3OPT_ACCESSPOINTS", 2047)
                    STAT_SET_INT("H3OPT_CREWWEAP", 4)
                    STAT_SET_INT("H3OPT_CREWDRIVER", 3)
                    STAT_SET_INT("H3OPT_CREWHACKER", 4)
                    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
                    STAT_SET_INT("H3OPT_BODYARMORLVL", -1)
                    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
                    STAT_SET_INT("H3OPT_BITSET1", 799)
                    STAT_SET_INT("H3OPT_BITSET0", 3670102)
                    SET_INT_GLOBAL(262145 + 28796, 1410065408)
                    menu.set_value(CAH_1P_CUT, 60)
                    menu.set_value(CAH_1P_CUT_LOOP, true)
                    menu.set_value(CAH_2P_CUT, 147)
                    menu.set_value(CAH_2P_CUT_LOOP, true)
                    menu.set_value(CAH_3P_CUT, 147)
                    menu.set_value(CAH_3P_CUT_LOOP, true)
                    menu.set_value(CAH_4P_CUT, 147)
                    menu.set_value(CAH_4P_CUT_LOOP, true)

                    util.yield()
                end
            end)

        ---

        local CASINO_PRESETS_GOLD = menu.list(CASINO_PRESETS, ("Gold"), {}, ("$3.5 Millions & For All Players"), function(); end)

            menu.toggle(CASINO_PRESETS_GOLD, ("Silent & Sneaky Approach"), {"hccahgoldsil"}, IsWorking(true) .. ("ALWAYS choose Low Level Buyer!"), function(Toggle)
                GoldST = Toggle

                if GoldST then
                    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)
                    STAT_SET_INT("H3OPT_MASKS", 9)
                    STAT_SET_INT("H3OPT_WEAPS", 1)
                    STAT_SET_INT("H3OPT_VEHS", 3)
                end

                if not GoldST then
                    menu.set_value(CAH_1P_CUT, 100)
                    menu.set_value(CAH_1P_CUT_LOOP, false)
                    menu.set_value(CAH_2P_CUT, 100)
                    menu.set_value(CAH_2P_CUT_LOOP, false)
                    menu.set_value(CAH_3P_CUT, 100)
                    menu.set_value(CAH_3P_CUT_LOOP, false)
                    menu.set_value(CAH_4P_CUT, 100)
                    menu.set_value(CAH_4P_CUT_LOOP, false)
                end

                while GoldST do
                    STAT_SET_INT("CAS_HEIST_FLOW", -1)
                    STAT_SET_INT("H3_LAST_APPROACH", 0)
                    STAT_SET_INT("H3OPT_APPROACH", 1)
                    STAT_SET_INT("H3_HARD_APPROACH", 0)
                    STAT_SET_INT("H3OPT_TARGET", 1)
                    STAT_SET_INT("H3OPT_POI", 1023)
                    STAT_SET_INT("H3OPT_ACCESSPOINTS", 2047)
                    STAT_SET_INT("H3OPT_CREWWEAP", 4)
                    STAT_SET_INT("H3OPT_CREWDRIVER", 3)
                    STAT_SET_INT("H3OPT_CREWHACKER", 4)
                    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
                    STAT_SET_INT("H3OPT_BODYARMORLVL", -1)
                    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
                    STAT_SET_INT("H3OPT_BITSET1", 127)
                    STAT_SET_INT("H3OPT_BITSET0", 262270)
                    SET_INT_GLOBAL(262145 + 28795, 1410065408) -- -582734553
                    menu.set_value(CAH_1P_CUT, 60)
                    menu.set_value(CAH_1P_CUT_LOOP, true)
                    menu.set_value(CAH_2P_CUT, 177)
                    menu.set_value(CAH_2P_CUT_LOOP, true)
                    menu.set_value(CAH_3P_CUT, 177)
                    menu.set_value(CAH_3P_CUT_LOOP, true)
                    menu.set_value(CAH_4P_CUT, 177)
                    menu.set_value(CAH_4P_CUT_LOOP, true)

                    util.yield()
                end
            end)

            menu.toggle(CASINO_PRESETS_GOLD, ("BigCon Approach"), {"hccahgoldbig"}, IsWorking(true) .. ("ALWAYS choose Low Level Buyer!"), function(Toggle)
                GoldND = Toggle

                if GoldND then
                    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)
                    STAT_SET_INT("H3OPT_MASKS", 9)
                    STAT_SET_INT("H3OPT_WEAPS", 1)
                    STAT_SET_INT("H3OPT_VEHS", 3)
                end

                if not GoldND then
                    menu.set_value(CAH_1P_CUT, 100)
                    menu.set_value(CAH_1P_CUT_LOOP, false)
                    menu.set_value(CAH_2P_CUT, 100)
                    menu.set_value(CAH_2P_CUT_LOOP, false)
                    menu.set_value(CAH_3P_CUT, 100)
                    menu.set_value(CAH_3P_CUT_LOOP, false)
                    menu.set_value(CAH_4P_CUT, 100)
                    menu.set_value(CAH_4P_CUT_LOOP, false)
                end

                while GoldND do
                    STAT_SET_INT("CAS_HEIST_FLOW", -1)
                    STAT_SET_INT("H3_LAST_APPROACH", 0)
                    STAT_SET_INT("H3OPT_APPROACH", 2)
                    STAT_SET_INT("H3_HARD_APPROACH", 0)
                    STAT_SET_INT("H3OPT_TARGET", 1)
                    STAT_SET_INT("H3OPT_POI", 1023)
                    STAT_SET_INT("H3OPT_ACCESSPOINTS", 2047)
                    STAT_SET_INT("H3OPT_CREWWEAP", 4)
                    STAT_SET_INT("H3OPT_CREWDRIVER", 3)
                    STAT_SET_INT("H3OPT_CREWHACKER", 4)
                    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
                    STAT_SET_INT("H3OPT_BODYARMORLVL", -1)
                    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
                    STAT_SET_INT("H3OPT_BITSET1", 159)
                    STAT_SET_INT("H3OPT_BITSET0", 524118)
                    SET_INT_GLOBAL(262145 + 28795, 1410065408)
                    menu.set_value(CAH_1P_CUT, 60)
                    menu.set_value(CAH_1P_CUT_LOOP, true)
                    menu.set_value(CAH_2P_CUT, 177)
                    menu.set_value(CAH_2P_CUT_LOOP, true)
                    menu.set_value(CAH_3P_CUT, 177)
                    menu.set_value(CAH_3P_CUT_LOOP, true)
                    menu.set_value(CAH_4P_CUT, 177)
                    menu.set_value(CAH_4P_CUT_LOOP, true)

                    util.yield()
                end
            end)

            menu.toggle(CASINO_PRESETS_GOLD, ("Aggressive Approach"), {"hccahgoldagg"}, IsWorking(true) .. ("ALWAYS choose Low Level Buyer!"), function(Toggle)
                GoldRD = Toggle

                if GoldRD then
                    STAT_SET_INT("H3_COMPLETEDPOSIX", -1)
                    STAT_SET_INT("H3OPT_MASKS", 4)
                    STAT_SET_INT("H3OPT_WEAPS", 1)
                    STAT_SET_INT("H3OPT_VEHS", 3)
                end

                if not GoldRD then
                    menu.set_value(CAH_1P_CUT, 100)
                    menu.set_value(CAH_1P_CUT_LOOP, false)
                    menu.set_value(CAH_2P_CUT, 100)
                    menu.set_value(CAH_2P_CUT_LOOP, false)
                    menu.set_value(CAH_3P_CUT, 100)
                    menu.set_value(CAH_3P_CUT_LOOP, false)
                    menu.set_value(CAH_4P_CUT, 100)
                    menu.set_value(CAH_4P_CUT_LOOP, false)
                end

                while GoldRD do
                    STAT_SET_INT("CAS_HEIST_FLOW", -1)
                    STAT_SET_INT("H3OPT_APPROACH", 3)
                    STAT_SET_INT("H3OPT_TARGET", 1)
                    STAT_SET_INT("H3OPT_POI", 1023)
                    STAT_SET_INT("H3OPT_ACCESSPOINTS", 2047)
                    STAT_SET_INT("H3OPT_DISRUPTSHIP", 3)
                    STAT_SET_INT("H3OPT_BODYARMORLVL", -1)
                    STAT_SET_INT("H3OPT_KEYLEVELS", 2)
                    STAT_SET_INT("H3OPT_CREWWEAP", 4)
                    STAT_SET_INT("H3OPT_CREWDRIVER", 3)
                    STAT_SET_INT("H3OPT_CREWHACKER", 4)
                    STAT_SET_INT("H3OPT_BITSET1", 799)
                    STAT_SET_INT("H3OPT_BITSET0", 3670102)
                    STAT_SET_INT("H3_HARD_APPROACH", 0)
                    STAT_SET_INT("H3_HARD_APPROACH", 0)
                    SET_INT_GLOBAL(262145 + 28795, 1410065408)
                    menu.set_value(CAH_1P_CUT, 60)
                    menu.set_value(CAH_1P_CUT_LOOP, true)
                    menu.set_value(CAH_2P_CUT, 177)
                    menu.set_value(CAH_2P_CUT_LOOP, true)
                    menu.set_value(CAH_3P_CUT, 177)
                    menu.set_value(CAH_3P_CUT_LOOP, true)
                    menu.set_value(CAH_4P_CUT, 177)
                    menu.set_value(CAH_4P_CUT_LOOP, true)

                    util.yield()
                end
            end)
            menu.action(CASINO_PRESETS, ("Set Heist to Default [Reset]"), {"hccahreset"}, "", function()
                STAT_SET_INT("H3_LAST_APPROACH", 0)
                STAT_SET_INT("H3OPT_APPROACH", 0)
                STAT_SET_INT("H3_HARD_APPROACH", 0)
                STAT_SET_INT("H3OPT_TARGET", 0)
                STAT_SET_INT("H3OPT_POI", 0)
                STAT_SET_INT("H3OPT_ACCESSPOINTS", 0)
                STAT_SET_INT("H3OPT_BITSET1", 0)
                STAT_SET_INT("H3OPT_CREWWEAP", 0)
                STAT_SET_INT("H3OPT_CREWDRIVER", 0)
                STAT_SET_INT("H3OPT_CREWHACKER", 0)
                STAT_SET_INT("H3OPT_WEAPS", 0)
                STAT_SET_INT("H3OPT_VEHS", 0)        
                STAT_SET_INT("H3OPT_DISRUPTSHIP", 0)
                STAT_SET_INT("H3OPT_BODYARMORLVL", 0)
                STAT_SET_INT("H3OPT_KEYLEVELS", 0)
                STAT_SET_INT("H3OPT_MASKS", 0)
                STAT_SET_INT("H3OPT_BITSET0", 0)
            end)

    local CAH_ADVCED = menu.list(CASINO_HEIST, ("Advanced Features"), {}, "", function(); end)
    
        local CAH_PLAYER_CUT = menu.list(CAH_ADVCED, ("Players Cut"), {}, "", function(); end)

            local CAH_NON_YOUR_CUT = menu.list(CAH_PLAYER_CUT, ("Your Cut (Non-Host)"), {}, "", function(); end)

                CAH_NON_HOST_CUT_LOOP = menu.toggle_loop(CAH_NON_YOUR_CUT, ("Enable"), {"hccahnonhostloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(2715699 + 6546, menu.get_value(CAH_NON_HOST_CUT)) -- gb_casino_heist.c
                end, function()
                    SET_INT_GLOBAL(2715699 + 6546, 100)
                end)

                CAH_NON_HOST_CUT = menu.slider(CAH_NON_YOUR_CUT, ("Custom Payout"), {"hccahnonhost"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---

            local CAH_PLAYER_HOST = menu.list(CAH_PLAYER_CUT, ("Your Cut"), {}, "", function(); end)

                CAH_1P_CUT_LOOP = menu.toggle_loop(CAH_PLAYER_HOST, ("Enable"), {"hccah1pcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1966534 + 2326, menu.get_value(CAH_1P_CUT)) -- gb_casino_heist.c
                end, function()
                    SET_INT_GLOBAL(1966534 + 2326, 100)
                end)

                CAH_1P_CUT = menu.slider(CAH_PLAYER_HOST, ("Custom Payout"), {"hccah1pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---

            local CAH_PLAYER_TWO = menu.list(CAH_PLAYER_CUT, ("Player 2"), {}, "", function(); end)

                CAH_2P_CUT_LOOP = menu.toggle_loop(CAH_PLAYER_TWO, ("Enable"), {"hccah2pcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1966534 + 2326 + 1, menu.get_value(CAH_2P_CUT)) -- gb_casino_heist.c
                end, function()
                    SET_INT_GLOBAL(1966534 + 2326 + 1, 100)
                end)

                CAH_2P_CUT = menu.slider(CAH_PLAYER_TWO, ("Custom Payout"), {"hccah2pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---

            local CAH_PLAYER_THREE = menu.list(CAH_PLAYER_CUT, ("Player 3"), {}, "", function(); end)

                CAH_3P_CUT_LOOP = menu.toggle_loop(CAH_PLAYER_THREE, ("Enable"), {"hccah3pcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1966534 + 2326 + 2, menu.get_value(CAH_3P_CUT)) -- gb_casino_heist.c
                end, function()
                    SET_INT_GLOBAL(1966534 + 2326 + 2, 100)
                end)

                CAH_3P_CUT = menu.slider(CAH_PLAYER_THREE, ("Custom Payout"), {"hccah3pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---

            local CAH_PLAYER_FOUR = menu.list(CAH_PLAYER_CUT, ("Player 4"), {}, "", function(); end)
                
                CAH_4P_CUT_LOOP = menu.toggle_loop(CAH_PLAYER_FOUR, ("Enable"), {"hccah4pcutloop"}, IsWorking(false), function()
                    SET_INT_GLOBAL(1966534 + 2326 + 3, menu.get_value(CAH_4P_CUT)) -- gb_casino_heist.c
                end, function()
                    SET_INT_GLOBAL(1966534 + 2326 + 3, 100)
                end)

                CAH_4P_CUT = menu.slider(CAH_PLAYER_FOUR, ("Custom Payout"), {"hccah4pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

            ---

            menu.toggle_loop(CAH_PLAYER_CUT, ("Set 100% to everyone"), {"hccahall100"}, IsWorking(false), function()
                menu.set_value(CAH_1P_CUT, 100)
                menu.set_value(CAH_1P_CUT_LOOP, true)
                menu.set_value(CAH_2P_CUT, 100)
                menu.set_value(CAH_2P_CUT_LOOP, true)
                menu.set_value(CAH_3P_CUT, 100)
                menu.set_value(CAH_3P_CUT_LOOP, true)
                menu.set_value(CAH_4P_CUT, 100)
                menu.set_value(CAH_4P_CUT_LOOP, true)
            end, function()
                menu.set_value(CAH_1P_CUT, 100)
                menu.set_value(CAH_1P_CUT_LOOP, false)
                menu.set_value(CAH_2P_CUT, 100)
                menu.set_value(CAH_2P_CUT_LOOP, false)
                menu.set_value(CAH_3P_CUT, 100)
                menu.set_value(CAH_3P_CUT_LOOP, false)
                menu.set_value(CAH_4P_CUT, 100)
                menu.set_value(CAH_4P_CUT_LOOP, false)
            end)

        menu.action(CAH_ADVCED, ("Instant Vault Door Laser"), {"hccahinsvault"}, IsWorking(false), function() -- Locals from https://www.unknowncheats.me/forum/3418914-post13398.html, Values from Heist Control for Nightfall
            local Value = GET_INT_LOCAL("fm_mission_controller", 10082 + 37)
            SET_INT_LOCAL("fm_mission_controller", 10082 + 7, Value)
        end)

    ---

    local TELEPORT_CAH = menu.list(CASINO_HEIST, ("Teleport"), {}, "", function(); end)

        menu.divider(TELEPORT_CAH, ("Inside"))

            menu.action(TELEPORT_CAH, ("Planning Boards"), {}, "", function()
                TELEPORT(2711.773, -369.458, -54.781)
            end)
            menu.action(TELEPORT_CAH, ("Garage Exit"), {}, "", function()
                TELEPORT(2677.237, -361.494, -55.187)
            end)
            menu.action(TELEPORT_CAH, ("Waste Disposal"), {}, "", function()
                TELEPORT(2542.052, -214.3084, -58.722965)
            end)
            menu.action(TELEPORT_CAH, ("Staff Lobby"), {}, "", function()
                TELEPORT(2547.9192, -273.16754, -58.723003)
            end)
            menu.action(TELEPORT_CAH, ("2-Keypad Door"), {}, "", function()
                TELEPORT(2465.4746, -279.2276, -70.694145)
            end)
            menu.action(TELEPORT_CAH, ("Inside Vault"), {}, "", function()
                TELEPORT(2515.1252, -238.91661, -70.73713)
            end)
            menu.action(TELEPORT_CAH, ("Pre-Inside Vault"), {}, "", function()
                TELEPORT(2497.5098, -238.50768, -70.7388)
            end)
            menu.action(TELEPORT_CAH, ("Daily Bonus Room"), {}, "", function()
                TELEPORT(2520.8645, -286.30685, -58.723007)
            end)

        ---

        menu.divider(TELEPORT_CAH, ("Outside"))

            menu.action(TELEPORT_CAH, ("Main Gate"), {}, "", function()
                TELEPORT(917.24634, 48.989567, 80.89892)
            end)
            menu.action(TELEPORT_CAH, ("Staff Lobby"), {}, "", function()
                TELEPORT(965.14856, -9.05023, 80.63045)
            end)
            menu.action(TELEPORT_CAH, ("Waste Disposal"), {}, "", function()
                TELEPORT(997.5346, 84.51491, 80.990555)
            end)



        menu.toggle_loop(CASINO_HEIST, ("Skip Hacking"), {}, IsWorking(true) .. ("Works on both of sorts: Fingerprint and Keypad"), function()
            if GET_INT_LOCAL("fm_mission_controller", 52929) ~= 1 then -- For Fingerprint, 
                SET_INT_LOCAL("fm_mission_controller", 52929, 5)
            end
            if GET_INT_LOCAL("fm_mission_controller", 53991) ~= 1 then -- For Keypad, 
                SET_INT_LOCAL("fm_mission_controller", 53991, 5)
            end
        end)

    ---

--- Doomsday Heist

    menu.list_action(DOOMS_HEIST, ("Automated Presets"), {"hcdoomspreset"}, "", {
        { ("The Data Breaches ACT I"), {"1st"} },
        { ("The Bogdan Problem ACT II"), {"2nd"} },
        { ("The Doomsday Scenario ACT III"), {"3rd"} },
    }, function(Index)
        if Index == 1 then
            STAT_SET_INT("GANGOPS_FLOW_MISSION_PROG", 503)
            STAT_SET_INT("GANGOPS_HEIST_STATUS", -229383)
            STAT_SET_INT("GANGOPS_FLOW_NotifyS", 1557)
        elseif Index == 2 then
            STAT_SET_INT("GANGOPS_FLOW_MISSION_PROG", 240)
            STAT_SET_INT("GANGOPS_HEIST_STATUS", -229378)
            STAT_SET_INT("GANGOPS_FLOW_NotifyS", 1557)
        elseif Index == 3 then
            STAT_SET_INT("GANGOPS_FLOW_MISSION_PROG", 16368)
            STAT_SET_INT("GANGOPS_HEIST_STATUS", -229380)
            STAT_SET_INT("GANGOPS_FLOW_NotifyS", 1557)
        end
    end)

    local TELEPORT_DOOMS = menu.list(DOOMS_HEIST, ("Teleport"), {}, "", function(); end)

        menu.action(TELEPORT_DOOMS, "Heist Screen on Facility", {}, "Make sure you are in the your facility.", function()
            TELEPORT(350.69284, 4872.308, -60.794243)
            SET_HEADING(-50)
        end)
        menu.action(TELEPORT_DOOMS, ("Heist board"), {}, "[" .. ("The Bogdan Problem ACT II") .. "]", function()
            TELEPORT(515.528, 4835.353, -62.587)
        end)
        menu.action(TELEPORT_DOOMS, ("Prisoner cell"), {}, "[" .. ("The Bogdan Problem ACT II") .. "]", function()
            TELEPORT(512.888, 4833.033, -68.989)
        end)

    ---

    local DDHEIST_PLYR_MANAGER = menu.list(DOOMS_HEIST, ("Players Cut"), {}, "", function(); end)

        local DDHEIST_HOST_MANAGER = menu.list(DDHEIST_PLYR_MANAGER, ("Your Cut"), {}, "", function(); end)

            DOOMS_HOST_CUT_LOOP = menu.toggle_loop(DDHEIST_HOST_MANAGER, ("Enable"), {"hcdooms1ploop"}, IsWorking(false), function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 1, menu.get_value(DOOMS_HOST_CUT)) -- gb_gang_ops_planning.c
            end, function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 1, 100)
            end)

            DOOMS_HOST_CUT = menu.slider(DDHEIST_HOST_MANAGER, ("Custom Payout"), {"hcdooms1pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

        ---

        local DDHEIST_PLAYER2_MANAGER = menu.list(DDHEIST_PLYR_MANAGER, ("Player 2"), {}, "", function(); end)
            
            DOOMS_2P_CUT_LOOP = menu.toggle_loop(DDHEIST_PLAYER2_MANAGER, ("Enable"), {"hcdooms2pcutloop"}, IsWorking(false), function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 2, menu.get_value(DOOMS_2P_CUT)) -- gb_gang_ops_planning.c
            end, function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 2, 100)
            end)

            DOOMS_2P_CUT = menu.slider(DDHEIST_PLAYER2_MANAGER, ("Custom Payout"), {"hcdooms2pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

        ---

        local DDHEIST_PLAYER3_MANAGER = menu.list(DDHEIST_PLYR_MANAGER, ("Player 3"), {}, "", function(); end)

            DOOMS_3P_CUT_LOOP = menu.toggle_loop(DDHEIST_PLAYER3_MANAGER, ("Enable"), {"hcdooms3pcutloop"}, IsWorking(false), function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 3, menu.get_value(DOOMS_3P_CUT)) -- gb_gang_ops_planning.c
            end, function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 3, 100)
            end)

            DOOMS_3P_CUT = menu.slider(DDHEIST_PLAYER3_MANAGER, ("Custom Payout"), {"hcdooms3pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

        ---

        local DDHEIST_PLAYER4_MANAGER = menu.list(DDHEIST_PLYR_MANAGER, ("Player 4"), {}, "", function(); end)

            DOOMS_4P_CUT_LOOP = menu.toggle_loop(DDHEIST_PLAYER4_MANAGER, ("Enable"), {"hcdooms4pcutloop"}, IsWorking(false), function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 4, menu.get_value(DOOMS_4P_CUT)) -- gb_gang_ops_planning.c
            end, function()
                SET_INT_GLOBAL(1962546 + 812 + 50 + 4, 100)
            end)

            DOOMS_4P_CUT = menu.slider(DDHEIST_PLAYER4_MANAGER, ("Custom Payout"), {"hcdooms4pcut"}, "(%)", 0, 1000, 100, 5, function(); end)

        ---

        menu.toggle_loop(DDHEIST_PLYR_MANAGER, ("Modify ACT I Payment [$2.5 Millions]"), {"hcdooms1stpay"}, IsWorking(true) .. ("Set difficulty as hard. In-Game percentage may seem weird. Applied to everyone."), function()
            menu.set_value(DOOMS_HOST_CUT, 209)
            menu.set_value(DOOMS_HOST_CUT_LOOP, true)
            menu.set_value(DOOMS_2P_CUT, 209)
            menu.set_value(DOOMS_2P_CUT_LOOP, true)
            menu.set_value(DOOMS_3P_CUT, 209)
            menu.set_value(DOOMS_3P_CUT_LOOP, true)
            menu.set_value(DOOMS_4P_CUT, 209)
            menu.set_value(DOOMS_4P_CUT_LOOP, true)
        end, function()
            menu.set_value(DOOMS_HOST_CUT, 100)
            menu.set_value(DOOMS_HOST_CUT_LOOP, false)
            menu.set_value(DOOMS_2P_CUT, 100)
            menu.set_value(DOOMS_2P_CUT_LOOP, false)
            menu.set_value(DOOMS_3P_CUT, 100)
            menu.set_value(DOOMS_3P_CUT_LOOP, false)
            menu.set_value(DOOMS_4P_CUT, 100)
            menu.set_value(DOOMS_4P_CUT_LOOP, false)
        end)

        menu.toggle_loop(DDHEIST_PLYR_MANAGER, ("Modify ACT II Payment [$2.5 Millions]"), {"hcdooms2ndpay"}, IsWorking(true) .. ("Set difficulty as hard. In-Game percentage may seem weird. Applied to everyone."), function()
            menu.set_value(DOOMS_HOST_CUT, 142)
            menu.set_value(DOOMS_HOST_CUT_LOOP, true)
            menu.set_value(DOOMS_2P_CUT, 142)
            menu.set_value(DOOMS_2P_CUT_LOOP, true)
            menu.set_value(DOOMS_3P_CUT, 142)
            menu.set_value(DOOMS_3P_CUT_LOOP, true)
            menu.set_value(DOOMS_4P_CUT, 142)
            menu.set_value(DOOMS_4P_CUT_LOOP, true)
        end, function()
            menu.set_value(DOOMS_HOST_CUT, 100)
            menu.set_value(DOOMS_HOST_CUT_LOOP, false)
            menu.set_value(DOOMS_2P_CUT, 100)
            menu.set_value(DOOMS_2P_CUT_LOOP, false)
            menu.set_value(DOOMS_3P_CUT, 100)
            menu.set_value(DOOMS_3P_CUT_LOOP, false)
            menu.set_value(DOOMS_4P_CUT, 100)
            menu.set_value(DOOMS_4P_CUT_LOOP, false)
        end)

        menu.toggle_loop(DDHEIST_PLYR_MANAGER, ("Modify ACT III Payment [$2.5 Millions]"), {"hcdooms3rdpay"}, IsWorking(true) .. ("Set difficulty as hard. In-Game percentage may seem weird. Applied to everyone."), function()
            menu.set_value(DOOMS_HOST_CUT, 113)
            menu.set_value(DOOMS_HOST_CUT_LOOP, true)
            menu.set_value(DOOMS_2P_CUT, 113)
            menu.set_value(DOOMS_2P_CUT_LOOP, true)
            menu.set_value(DOOMS_3P_CUT, 113)
            menu.set_value(DOOMS_3P_CUT_LOOP, true)
            menu.set_value(DOOMS_4P_CUT, 113)
            menu.set_value(DOOMS_4P_CUT_LOOP, true)
        end, function()
            menu.set_value(DOOMS_HOST_CUT, 100)
            menu.set_value(DOOMS_HOST_CUT_LOOP, false)
            menu.set_value(DOOMS_2P_CUT, 100)
            menu.set_value(DOOMS_2P_CUT_LOOP, false)
            menu.set_value(DOOMS_3P_CUT, 100)
            menu.set_value(DOOMS_3P_CUT_LOOP, false)
            menu.set_value(DOOMS_4P_CUT, 100)
            menu.set_value(DOOMS_4P_CUT_LOOP, false)
        end)

    ---

    menu.toggle_loop(DOOMS_HEIST, ("Skip Hacking"), {}, IsWorking(true) .. "[" .. ("The Doomsday Scenario ACT III") .. " & " .. ("The Data Breaches ACT I") .. " - " .. ("Setup: Server Farm (Lester)") .. "]", function() -- https://www.unknowncheats.me/forum/3455828-post8.html
        SET_INT_LOCAL("fm_mission_controller", 1263 + 135, 3) -- For ACT III
        SET_INT_LOCAL("fm_mission_controller", 1537, 2) -- For ACT I, Setup: Server Farm (Lester)
    end)

    menu.action(DOOMS_HEIST, ("Set Heist to Default [Reset]"), {"hcdoomsreset"}, ("Change your session to apply!"), function()
        STAT_SET_INT("GANGOPS_FLOW_MISSION_PROG", 240)
        STAT_SET_INT("GANGOPS_HEIST_STATUS", 0)
        STAT_SET_INT("GANGOPS_FLOW_NotifyS", 1557)
    end)

---


--- Classic Heist

        
        menu.toggle_loop(CLASSIC_HEISTS, ("Complete all Setup"), {}, ("You may need to choose a Heist and then complete the first setup, activated until then"), function()
            STAT_SET_INT("HEIST_PLANNING_STAGE", -1)
        end)
        menu.toggle_loop(CLASSIC_HEISTS, ("Skip Hacking"), {}, IsWorking(false), function() -- https://www.unknowncheats.me/forum/3455828-post8.html
            SET_INT_LOCAL("fm_mission_controller", 11731 + 24, 7)
        end)
        menu.toggle_loop(CLASSIC_HEISTS, "Skip Drilling", {}, "", function() -- https://www.unknowncheats.me/forum/3485435-post19.html
            SET_FLOAT_LOCAL("fm_mission_controller", 10042 + 11, 100)
        end)

        ---
        AUTO_COMPLETE_HEIST = menu.list(menu.my_root(), ("Instance Heist Complete"), {}, "", function(); end)
        menu.action(AUTO_COMPLETE_HEIST, "Cayo / Tuners / Agency", {}, IsWorking(false), function() -- Done Cayo Perico Heist Instantly: https://www.unknowncheats.me/forum/3472329-post13554.html
            if players.get_script_host() ~= players.user() then
                menu.trigger_commands("scripthost")
            end

            SET_INT_LOCAL("fm_mission_controller_2020", 31554 + 6843, 51338752)
            SET_INT_LOCAL("fm_mission_controller_2020", 31554 + 8218, 50)
        end)

        menu.action(AUTO_COMPLETE_HEIST, "Casino Aggressive / Doomsday / Classic", {}, IsWorking(false), function()
            if players.get_script_host() ~= players.user() then
                menu.trigger_commands("scripthost")
            end

            SET_INT_LOCAL("fm_mission_controller", 19679, 12)
            SET_INT_LOCAL("fm_mission_controller", 19679 + 2686, 10000000)
            SET_INT_LOCAL("fm_mission_controller", 28298 + 1, 99999)
            SET_INT_LOCAL("fm_mission_controller", 31554 + 69, 99999)
        end)

        NEAR_PED_CAM = menu.list(menu.my_root(), ("Manage Near Peds & Cams"), {}, "", function(); end)
            
            IS_HOSTILE_PED = menu.toggle(NEAR_PED_CAM, ("Work only to hostile peds"), {}, ("Enabled: Ped options work only to hostile peds") .. "\n\n" .. ("Disabled: Ped options work to all peds"), function() end)

        ---

        menu.divider(NEAR_PED_CAM, ("Peds"))

            menu.action(NEAR_PED_CAM, ("Remove Weapons"), {"hcremwepon"}, "", function()
                for k, ent in pairs(entities.get_all_peds_as_handles()) do
                    if not IS_PED_PLAYER(ent) then
                        if menu.get_value(IS_HOSTILE_PED) then
                            if PED.IS_PED_IN_COMBAT(ent, players.user()) then
                                WEAPON.REMOVE_ALL_PED_WEAPONS(ent, true)
                            end
                        else
                            WEAPON.REMOVE_ALL_PED_WEAPONS(ent, true)
                        end
                    end
                end
            end)

            menu.action(NEAR_PED_CAM, ("Delete"), {"hcdelped"}, "", function()
                for k, ent in pairs(entities.get_all_peds_as_handles()) do
                    if not IS_PED_PLAYER(ent) then
                        if menu.get_value(IS_HOSTILE_PED) then
                            if PED.IS_PED_IN_COMBAT(ent, players.user()) then
                                entities.delete_by_handle(ent)
                            end
                        else
                            entities.delete_by_handle(ent)
                        end
                    end
                end
            end)

            menu.action(NEAR_PED_CAM, ("Kill"), {"hckillped"}, "", function()
                for k, ent in pairs(entities.get_all_peds_as_handles()) do
                    if not IS_PED_PLAYER(ent) then
                        if menu.get_value(IS_HOSTILE_PED) then
                            if PED.IS_PED_IN_COMBAT(ent, players.user()) then
                                ENTITY.SET_ENTITY_HEALTH(ent, 0)
                            end
                        else
                            ENTITY.SET_ENTITY_HEALTH(ent, 0)
                        end
                    end
                end
            end)

            menu.action(NEAR_PED_CAM, "Shoot", {"hcshootped"}, "", function() -- Thanks for coding this, Pedro9558#3559
                for k, ent in pairs(entities.get_all_peds_as_handles()) do
                    if not IS_PED_PLAYER(ent) and not ENTITY.IS_ENTITY_DEAD(ent) then
                        local PedPos = v3.new(ENTITY.GET_ENTITY_COORDS(ent))
                        local AddPos = v3.new(ENTITY.GET_ENTITY_COORDS(ent))
                        AddPos:add(v3.new(0, 0, 1))
                        if menu.get_value(IS_HOSTILE_PED) then
                            if PED.IS_PED_IN_COMBAT(ent, players.user()) then
                                if (PED.GET_VEHICLE_PED_IS_USING(ent) ~= 0) then
                                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ent)
                                end
                                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, PedPos.x, PedPos.y, PedPos.z, 1000, false, 0xC472FE2, players.user_ped(), false, true, 1000)
                            end
                        else
                            if (PED.GET_VEHICLE_PED_IS_USING(ent) ~= 0) then
                                TASK.CLEAR_PED_TASKS_IMMEDIATELY(ent)
                            end
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(AddPos.x, AddPos.y, AddPos.z, PedPos.x, PedPos.y, PedPos.z, 1000, false, 0xC472FE2, players.user_ped(), false, true, 1000)
                        end
                    end
                end
            end)

        ---

        menu.divider(NEAR_PED_CAM, ("Cams"))

            menu.toggle_loop(NEAR_PED_CAM, ("Delete"), {"hcdelcam"}, "[" .. ("Cayo Perico Heist") .. " & " .. ("Diamond Casino Heist") .. "]", function()
                for k, ent in pairs(entities.get_all_objects_as_handles()) do
                    local Cams = {
                        -1233322078,
                        168901740,
                        -1095296451,
                        -173206916,
                        -1159421424,
                        548760764,
                        -1340405475,
                        1449155105,
                        -354221800,
                        -1884701657,
                        2090203758,
                        -1007354661,
                        -1842407088,
                        289451089,
                        3061645218,
                        -247409812,
                    }

                    local EntityModel = ENTITY.GET_ENTITY_MODEL(ent)
                    for i = 1, #Cams do
                        if EntityModel == Cams[i] then
                            entities.delete_by_handle(ent)
                        end
                    end
                end
            end)

        ---

    ---

    local BYPASS_DOOR = menu.list(menu.my_root(), ("Bypass Locked Doors"), {}, "", function(); end)


            NOCLIP_SPEED = menu.slider(BYPASS_DOOR, ("Speed of Improved No Clip"), {"hcspdhcnoclip"}, "", 1, 100, 10, 5, function(); end)
            DISTANCE_TPTF = menu.slider(BYPASS_DOOR, ("Distance of Teleport To Forward"), {"hcdishctptf"}, "", 1, 100, 10, 5, function(); end)

        ---

        menu.divider(BYPASS_DOOR, ("Bypass Locked Doors"))

            menu.toggle(BYPASS_DOOR, ("Improved No Clip"), {"hcnoclip"}, "", function(Toggle) -- From Command Box Scripts: No Clip
                ImprovedNoClip = Toggle
        
                if ImprovedNoClip then
                    menu.trigger_commands("levitate on")
                    menu.trigger_commands("levitatespeed " .. menu.get_value(NOCLIP_SPEED) * 0.01)
                    menu.trigger_commands("levitatesprintmultiplier 0.50")
                    menu.trigger_commands("levitatepassivemin 0")
                    menu.trigger_commands("levitatepassivemax 0")
                    menu.trigger_commands("levitatepassivespeed 0")
                    menu.trigger_commands("levitateassistup 0")
                    menu.trigger_commands("levitateassistdown 0")
                    menu.trigger_commands("levitateassistdeadzone 0")
                    menu.trigger_commands("levitateassistsnap 0")
                else
                    menu.trigger_commands("levitate off")
                end

                while ImprovedNoClip do
                    menu.trigger_commands("levitatespeed " .. menu.get_value(NOCLIP_SPEED) * 0.01)
                    util.yield(500)
                end
            end)
    
            menu.action(BYPASS_DOOR, ("Teleport To Forward"), {"hctptf"}, "", function() -- Credit goes to Lancescript
                local Handle = PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) and PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) or players.user_ped()
                local Pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(Handle, 0, menu.get_value(DISTANCE_TPTF) * 0.1, 0)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Handle, Pos.x, Pos.y, Pos.z, false, false, false)
            end)
            menu.toggle_loop(menu.my_root(), "Auto Clicker", {"hcautocollect"}, "Collects targets via clicking left mouse button. Note that there are some delays before disabling completely.", function()
                PAD._SET_CONTROL_NORMAL(0, 237, 1)
                util.yield(50)
            end)
