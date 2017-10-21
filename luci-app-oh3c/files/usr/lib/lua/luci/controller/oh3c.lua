module("luci.controller.oh3c", package.seeall)

function index()
	if nixio.fs.access("/etc/config/h3c") then
	local page 
	page = entry({"admin", "services", "h3c"}, cbi("h3c"), _("h3c"), 30)
	page.i18n = "h3c"
	page.dependent = false
	end
end
