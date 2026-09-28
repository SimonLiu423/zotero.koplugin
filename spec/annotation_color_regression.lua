-- Run with: lua5.1 spec/annotation_color_regression.lua
package.path = './?.lua;' .. package.path

local items = {}
for i = 1, 39 do
    items[i] = {
        color = 'blue', datetime = '2026-09-28 14:00:00', drawer = 'lighten',
        page = 1, pageno = 1,
        pboxes = { { x = 10, y = 20, w = 30, h = 5 } },
    }
end

local settings = { data = { annotations = items } }
function settings:flush() end
package.preload.docsettings = function()
    return { open = function() return settings end }
end
package.preload.json = function()
    return { encode = function() return '{}' end }
end
package.preload.logger = function()
    return { info = function() end, warn = function() end, err = function() end, dbg = function() end }
end

local Annotations = require('annotations')
Annotations.getPageDimensions = function()
    return { [1] = { width = 600, height = 800, bbox_x0 = 0, bbox_y0 = 0,
        bbox_x1 = 600, bbox_y1 = 800, bbox_width = 600 } }
end

local function create(items_to_upload)
    local created, failed = {}, {}
    for i, item in ipairs(items_to_upload) do
        if item.annotationColor:match('^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$') then
            created[i] = { key = 'CREATED' .. i }
        else
            failed[i] = { code = 400, message = 'annotationColor must be a hex color' }
        end
    end
    return created, failed
end

local failures = Annotations.createAnnotations('/fixture.pdf', 'PARENT', create)
assert(failures == 0, ('expected 0 annotation upload failures, got %d'):format(failures))
print('39 blue annotations uploaded successfully')
