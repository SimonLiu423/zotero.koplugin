-- Run with: lua5.1 spec/annotation_upload_version_regression.lua
package.path = './?.lua;' .. package.path

local payloads, responses = {}, {}
local serial = 0
package.preload.json = function()
    return {
        encode = function(value)
            serial = serial + 1
            local token = 'payload' .. serial
            payloads[token] = value
            return token
        end,
        decode = function(token) return responses[token] end,
    }
end
package.preload['ssl.https'] = function()
    return { request = function(request)
        local items = payloads[request.source]
        assert(items, 'missing request payload')
        local current_version = _G.server_version
        if request.headers['If-Unmodified-Since-Version'] ~= current_version then
            return 1, 412, {}
        end
        local successful = {}
        for i = 1, #items do
            successful[tostring(i - 1)] = { key = 'CREATED' .. i, version = current_version + 1 }
        end
        _G.server_version = current_version + 1
        responses.response = { successful = successful, unchanged = {}, failed = {} }
        request.sink('response')
        return 1, 200, { ['last-modified-version'] = _G.server_version }
    end }
end
package.preload.ltn12 = function()
    return { source = { string = function(s) return s end },
        sink = { table = function(t) return function(s) t[#t + 1] = s end end } }
end
package.preload.logger = function()
    return { info = function() end, warn = function() end, err = function() end, dbg = function() end }
end
package.preload.gettext = function() return function(s) return s end end
for _, name in ipairs({ 'ffi/util', 'luasettings', 'libs/libkoreader-lfs',
    'ffi/sha2', 'lua-ljsqlite3/init', 'annotations', 'docsettings' }) do
    package.preload[name] = function() return {} end
end

local API = require('zoteroapi')
_G.server_version = 7410
API.libVersion = 7410
API.verifyZoteroAccess = function() return nil end
API.getUserLibraryVersion = function() return API.libVersion end
API.zoteroHeader = {}
API.userLibraryURL = 'https://example.invalid/users/test'

local first, first_error = API.createItems({ { itemType = 'annotation' } })
assert(first[1] and #first_error == 0, 'first annotation must upload')
local count = tonumber(os.getenv('ANNOTATION_COUNT')) or 38
local remaining = {}
for i = 1, count do remaining[i] = { itemType = 'annotation' } end
local created, error_message = API.createItems(remaining)
assert(type(error_message) ~= 'string', tostring(error_message))
for i = 1, count do assert(created[i], 'annotation ' .. i .. ' was not uploaded') end
print(('first annotation and subsequent %d uploaded successfully'):format(count))
