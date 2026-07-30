HNF = { Config = require("config.shared"), GFunctions = {}, Utils = {}}

local status, result = pcall(require, "locales." .. HNF.Config.locale)
if not status then
    error("^1[ERROR] ^3Locales not found. Stopping resource. Fix it in Config.locale^7")
end
HNF.Locales = result