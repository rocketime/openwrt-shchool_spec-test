local fs = require "nixio.fs"
local http = luci.http

ful = SimpleForm("upload", translate("Upload"), nil)
ful.reset = false
ful.submit = false

sul = ful:section(SimpleSection, "", translate("Upload data file to '/etc/mentohust/'" .. "<br />" .. " " .. "<br />" .. 
									"Upload 8021x.exe,W32N55.dll,SuConfig.dat and data.mpf if necessery "))

---upload---

fu = sul:option(FileUpload, "")
fu.template = "mentohust/upload"
um = sul:option(DummyValue, "", nil)
um.template = "mentohust/dvalue"

local dir, fd
dir = "/tmp/mentohust/"
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
			um.value = translate("File saved to") .. ' "/tmp/mentohust/' .. meta.file .. '"'
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

local initst, it, attrt = {}, 1
local files = fs.dir("/tmp/mentohust/")
if files then
	for f in files do
		attrt = fs.stat("/tmp/mentohust/" .. f)
		if attrt then
			initst[it] = {}
			initst[it].name = f
			initst[it].mtime = os.date("%Y-%m-%d %H:%M:%S", attrt.mtime)
			initst[it].modestr = attrt.modestr
			initst[it].size = tostring(attrt.size)
			initst[it].remove = 0
			initst[it].install = false
			it = it + 1
		end
	end
end
---form-----

form = SimpleForm("filelist", translate("Files Uploaded"), nil)
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

btnrm.write = function(self, section)
 	local v = fs.unlink("/etc/mentohust/" .. fs.basename(inits[section].name))
 	if v then table.remove(inits, section) end
 	return v
end

----ff --

ff = SimpleForm("upload", translate("Files Waiting Upload"), nil)
ff.reset = false
ff.submit = false 
tb = ff:section(Table, initst)
nm = tb:option(DummyValue, "name", translate("File name"))
mt = tb:option(DummyValue, "mtime", translate("Modify time"))
ms = tb:option(DummyValue, "modestr", translate("Mode string"))
sz = tb:option(DummyValue, "size", translate("Size"))
btnrmt = tb:option(Button, "remove1", translate("Remove"))

btnrmt.render = function(self, section, scope)
	self.inputstyle = "remove"
	Button.render(self, section, scope)
end

btnrmt.write = function(self, section)
 	local vt = fs.unlink("/tmp/mentohust/" .. fs.basename(initst[section].name))
 	if vt then table.remove(initst, section) end
 	return vt
end

btncf = tb:option(Button, "action", translate("Action"))

btncf.render = function(self, section, scope)
	self.title = translate("Confirm Upload")
	self.inputstyle = "apply"
	Button.render(self, section, scope)
end

btncf.write = function(self, section)
 	os.execute("mv /tmp/mentohust/"..fs.basename(initst[section].name).." /etc/mentohust/ 2>>/tmp/web_shell_output 1>>/tmp/web_shell_output &" )
	sul = ful:section(SimpleSection, "", translate("Uploading. Plase wait few minutes then reload this page manually"))
	return ture
	
end

return ful, ff, form