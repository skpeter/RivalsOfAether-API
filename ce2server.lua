-- Note: this is the same script that should reside inside CE's cheat table. It's only being replicated here for sourcing reasons

-- Rivals of Aether memory addresses
MemoryAddresses = {
    IsNotInGame = 1,
    P1Stocks = 3,
    P1Percentage = 0,
    P2Stocks = 3,
    P2Percentage = 0,
    P3Stocks = 3,
    P3Percentage = 0,
    P4Stocks = 3,
    P4Percentage = 0
}
-- Addresses from previous poll. Used to determine if changes were made.
PreviousAddresses = {
    IsNotInGame = 1,
    P1Stocks = 3,
    P1Percentage = 0,
    P2Stocks = 3,
    P2Percentage = 0,
    P3Stocks = 3,
    P3Percentage = 0,
    P4Stocks = 3,
    P4Percentage = 0
}

DiffHandler = "game" -- Set to "everything to trigger posting to the server on any data change"

local function copyTable(src)
    local dest = {}
    for key, value in pairs(src) do
        if type(value) == "table" then
            dest[key] = copyTable(value)
        else
            dest[key] = value
        end
    end
    return dest
end

-- Converts a table to encoded JSON string
local function jsonEncode(tbl, indent)
    if not indent then indent = 0 end
    local json = ""
    local spacing = string.rep(" ", indent)

    json = json .. "{\n"

    local isFirst = true
    for key, value in pairs(tbl) do
        if not isFirst then
            json = json .. ",\n"
        end
        isFirst = false
        json = json .. spacing .. "  \"" .. key .. "\": "

        if type(value) == "string" then
            json = json .. "\"" .. value .. "\""
        elseif type(value) == "number" or type(value) == "boolean" then
            json = json .. tostring(value)
        elseif type(value) == "table" then
            json = json .. jsonEncode(value, indent + 2)
        else
            json = json .. "null"
        end
    end

    json = json .. "\n" .. spacing .. "}"
    return json
end

-- Gets an address that was registered in the table by its description.
local function getAddressByDescription(description)
    for i = 0, getAddressList().getCount() - 1 do
        local entry = getAddressList().getMemoryRecord(i)
        if entry.Description == description then
            return entry.Address
        end
    end
    return nil
end

-- Function to send data to your HTTP server
local sendToServer = function(data)
    local url = "https://webhook.site/af11a170-98dd-4708-b989-eecd49644656"
    local internet = getInternet()
    local result = internet.postURL(url, data)
    if result then print("Response: " .. result) end
    PreviousAddresses = copyTable(MemoryAddresses)
end

-- Gets the values from CheatEngine
local function getValues()
    for address, v in pairs(MemoryAddresses) do
        local tableAddress = getAddressByDescription(address)
        if (tableAddress) then
            local value = math.floor(readDouble(tableAddress)) -- Read the value from the memory address. Function exists in CE.
            MemoryAddresses[address] = value -- Add the value to the data table
        end
    end
end

-- Main loop
local function onTimerTick()
    getValues()
    if (DiffHandler == "game") then
        if (MemoryAddresses["IsNotInGame"] ~= PreviousAddresses["IsNotInGame"]) then
            sendToServer(jsonEncode(MemoryAddresses))
        end
    else
        for index, value in pairs(MemoryAddresses) do
            if value ~= PreviousAddresses[index] then
                sendToServer(jsonEncode(MemoryAddresses))
                break
            end
        end
    end
end

-- Create a timer object
local timer = createTimer()

-- Set the timer interval (in milliseconds) and the function to call
timer.Interval = 2000
timer.OnTimer = onTimerTick

-- Start the timer
timer.setEnabled(true)