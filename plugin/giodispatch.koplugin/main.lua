--[[
Gio's Daily Dispatch for KOReader.

Fetches <base>/latest.html, keeps a dated copy in koreader/giodispatch/,
and opens it in the reader. With no connection it opens the newest copy.
]]

local DataStorage = require("datastorage")
local Dispatcher = require("dispatcher")
local InfoMessage = require("ui/widget/infomessage")
local InputDialog = require("ui/widget/inputdialog")
local LuaSettings = require("luasettings")
local NetworkMgr = require("ui/network/manager")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local http = require("socket.http")
local lfs = require("libs/libkoreader-lfs")
local logger = require("logger")
local socket = require("socket")
local socketutil = require("socketutil")
local _ = require("gettext")

local DEFAULT_BASE = "https://gcaprojects.github.io/gio-dispatch/"
local DIR = DataStorage:getDataDir() .. "/giodispatch/"
local KEEP_DAYS = 30

local GioDispatch = WidgetContainer:extend{
    name = "giodispatch",
    is_doc_only = false,
}

function GioDispatch:init()
    lfs.mkdir(DIR)
    self.settings = LuaSettings:open(DataStorage:getSettingsDir() .. "/giodispatch.lua")
    self:onDispatcherRegisterActions()
    self.ui.menu:registerToMainMenu(self)
end

-- Lets gestures and the Bookshelf start menu open today's edition.
function GioDispatch:onDispatcherRegisterActions()
    Dispatcher:registerAction("giodispatch_today", {
        category = "none",
        event = "GioDispatchToday",
        title = _("Gio's Daily Dispatch: today's edition"),
        general = true,
    })
end

function GioDispatch:onGioDispatchToday()
    self:fetchAndOpen()
    return true
end

function GioDispatch:base()
    local base = self.settings:readSetting("base_url", DEFAULT_BASE)
    if base:sub(-1) ~= "/" then base = base .. "/" end
    return base
end

function GioDispatch:addToMainMenu(menu_items)
    menu_items.gio_dispatch = {
        text = _("Gio's Daily Dispatch"),
        sorting_hint = "tools",
        sub_item_table = {
            {
                text = _("Today's edition"),
                callback = function() self:fetchAndOpen() end,
            },
            {
                text = _("Open last downloaded edition"),
                callback = function() self:openNewest(false) end,
            },
            {
                text = _("Set edition URL"),
                keep_menu_open = true,
                callback = function() self:editBaseUrl() end,
            },
        },
    }
end

-- Download url to path via a .part file, so a dropped connection never
-- leaves a half-written edition behind.
local function download(url, path)
    local fh = io.open(path .. ".part", "wb")
    if not fh then return false end
    socketutil:set_timeout(socketutil.FILE_BLOCK_TIMEOUT, socketutil.FILE_TOTAL_TIMEOUT)
    local code = socket.skip(1, http.request{
        url = url,
        sink = socketutil.file_sink(fh),
    })
    socketutil:reset_timeout()
    if code ~= 200 then
        logger.warn("GioDispatch: download failed", url, code)
        os.remove(path .. ".part")
        return false
    end
    return os.rename(path .. ".part", path)
end

-- Editions carry <meta name="edition-date" content="YYYY-MM-DD">.
local function editionDate(path)
    local f = io.open(path, "rb")
    if not f then return end
    local head = f:read(4096) or ""
    f:close()
    return head:match('name="edition%-date"%s+content="(%d%d%d%d%-%d%d%-%d%d)"')
end

local function listEditions()
    local files = {}
    for name in lfs.dir(DIR) do
        if name:match("^%d%d%d%d%-%d%d%-%d%d%.html$") then table.insert(files, name) end
    end
    table.sort(files) -- ISO dates sort chronologically
    return files
end

local function prune()
    local files = listEditions()
    for i = 1, #files - KEEP_DAYS do os.remove(DIR .. files[i]) end
end

local function openFile(path)
    local ReaderUI = require("apps/reader/readerui")
    ReaderUI:showReader(path)
end

function GioDispatch:openNewest(after_failed_fetch)
    local files = listEditions()
    if #files == 0 then
        UIManager:show(InfoMessage:new{ text = _("No edition downloaded yet. Connect to Wi-Fi and try again.") })
        return
    end
    if after_failed_fetch then
        UIManager:show(InfoMessage:new{
            text = _("Couldn't fetch today's edition. Opening the last one: ") .. files[#files]:sub(1, 10),
            timeout = 3,
        })
    end
    openFile(DIR .. files[#files])
end

function GioDispatch:fetchAndOpen()
    NetworkMgr:runWhenOnline(function()
        local msg = InfoMessage:new{ text = _("Fetching today's edition…") }
        UIManager:show(msg)
        UIManager:forceRePaint()
        local tmp = DIR .. "latest.html"
        local ok = download(self:base() .. "latest.html", tmp)
        UIManager:close(msg)
        local date = ok and editionDate(tmp)
        if not date then
            return self:openNewest(true)
        end
        local path = DIR .. date .. ".html"
        os.rename(tmp, path)
        prune()
        NetworkMgr:afterWifiAction()
        openFile(path)
    end)
end

function GioDispatch:editBaseUrl()
    local dialog
    dialog = InputDialog:new{
        title = _("Edition URL"),
        input = self:base(),
        buttons = {{
            {
                text = _("Cancel"),
                id = "close",
                callback = function() UIManager:close(dialog) end,
            },
            {
                text = _("Save"),
                is_enter_default = true,
                callback = function()
                    self.settings:saveSetting("base_url", dialog:getInputText())
                    self.settings:flush()
                    UIManager:close(dialog)
                end,
            },
        }},
    }
    UIManager:show(dialog)
    dialog:onShowKeyboard()
end

return GioDispatch
