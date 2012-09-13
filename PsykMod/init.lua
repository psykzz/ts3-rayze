--[[
-- PsyK Mod -- Init file.
-- Version: 1.2
-- Author: PsyK
-- Website: http://www.psykzz.co.uk
-- E-Mail: matt.daemon660@gmail.com
--]]

require("ts3init")

require("ts3defs")
require("ts3errors")

require("PsykMod/logic")
require("PsykMod/functions")



ts3RegisterModule("PsykMod", registeredEvents)
print("Finished loading PsykMod.")
