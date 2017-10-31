local fs = require "nixio.fs"
local http = luci.http

ful = SimpleForm("upload", translate("Upload"), nil)
ful.reset = false
ful.submit = false

sul = ful:section(SimpleSection, "", translate("Upload data file to '/etc/mentohust/'" .. "<br />" .. 
									"Upload 8021x.exe,W32N55.dll,SuConfig.dat and data.mpf if needed "))
fu = sul:option(FileUpload, "")
fu.template = "mentohust/upload"
um = sul:option(DummyValue, "", nil)
um.template = "mentohust/dvalue"

local dir, fd
dir = "/etc/mentohust/"
fs.mkdir(dir)
http.setfilehandler(
	function(meta, chunk, eof)
		if not fd then
			if (not meta) or (not meta.name) or (not meta.file) then return end
			fd = nixio.open(dir .. meta.file, "w")
			if not fd then
				um.value = translate("Create upload file error.")
				return
			end
		end
		if chunk and fd then
			fd:write(chunk)
		end
		if eof and fd then
			fd:close()
			fd = nil
			um.value = translate("File saved to") .. ' "/etc/mentohust/' .. meta.file .. '"'
		end
	end
)

if luci.http.formvalue("upload") then
	local f = luci.http.formvalue("ulfile")
	if #f <= 0 then
		um.value = translate("No specify upload file.")
	end
end

local inits, i, attr = {}, 1
local files = fs.dir("/etc/mentohust/")
if files then
	for f in files do
		attr = fs.stat("/etc/mentohust/" .. f)
		if attr then
			inits[i] = {}
			inits[i].name = f
			inits[i].mtime = os.date("%Y-%m-%d %H:%M:%S", attr.mtime)
			inits[i].modestr = attr.modestr
			inits[i].size = tostring(attr.size)
			inits[i].remove = 0
			inits[i].install = false
			i = i + 1
		end
	end
end

form = SimpleForm("filelist", translate("Upload file list"), nil)
form.reset = false
form.submit = false

tb = form:section(Table, inits)
nm = tb:option(DummyValue, "name", translate("File name"))
mt = tb:option(DummyValue, "mtime", translate("Modify time"))
ms = tb:option(DummyValue, "modestr", translate("Mode string"))
sz = tb:option(DummyValue, "size", translate("Size"))
btnrm = tb:option(Button, "remove", translate("Remove"))
btnrm.render = function(self, section, scope)
	self.inputstyle = "remove"
	Button.render(self, section, scope)
end


return ful, form
