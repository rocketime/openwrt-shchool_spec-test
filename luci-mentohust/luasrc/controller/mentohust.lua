--[[

LuCI mentohust
Author:a1ive

]]--

module("luci.controller.mentohust", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/mentohust") then
		return
	end
	
local page = entry({"admin", "services", "mentohust"},
		alias("admin", "services", "mentohust", "general"),
		_("MentoHUST"), 10)

	entry({"admin", "services", "mentohust", "general"},
		cbi("mentohust/mentohust"),
		_("General Settings"), 10)
		
	entry({"admin", "services", "mentohust", "upload-files"},
		cbi("mentohust/upload-files"),
		_("Upload Data Files"), 20)
	
	
	
	
	page.i18n = "mentohust"
	page.dependent = true
	
end
