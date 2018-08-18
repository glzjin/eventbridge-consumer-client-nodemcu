-- Config
consumer_uuid = ""
key = ""
ws_url = 'ws://eb.zhaoj.in:80/consumer/websocket'

-- Connect wifi
wifi.sta.autoconnect(1)
wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid = "EventBridge" .. node.chipid(), auth = wifi.WPA_WPA2_PSK, pwd = "12345678"})
enduser_setup.manual(true)
enduser_setup.start(
  function()
    print("Connected to wifi as:" .. wifi.sta.getip())
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
);

-- Event handle
event_list = {}

function is_in_array(t, key)
    for k, v in ipairs(t) do
        if(k == key)
        then
            return true
        end
    end
    return false
end

function event_handle(event_id)
    print("Recv Event ID " .. event_id)
    if(is_in_array(event_list, event_id) ~= true)
    then
        print("The event id is invaild!")
        return
    end
    event_list[event_id]()
    print("Consumed Event ID " .. event_id)
end

-- Reg Rf event
require("rf_command")
rf_event_reg(event_list, 0)

-- Init websocket
function websocket_init()
    local ws = websocket.createClient()
    ws:on("connection", function(ws)
        print("Connected to server")
      if(ws:send(sjson.encode({action = "reg", consumer_uuid = consumer_uuid, key = key})) ~= nil)
      then
        wifi.sta.disconnect()
      end
    end)
    ws:on("receive", function(_, msg, opcode)
      data = sjson.decode(msg)
      if(data['code'] == 100)
      then
        print("Registered to server")
      elseif(data['code'] == 300)
      then
        event_handle(data['data']['event']['event_id'])
      else
        print("Your key is mismatch with server!")
        wifi.sta.disconnect()
      end
    end)
    ws:on("close", function(_, status)
      print('Connection closed', status)
      ws = nil
      wifi.sta.disconnect()
    end)

    ws:connect(ws_url)
end

-- Wifi event mon

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
    print("Connected to wifi")
    websocket_init()
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
    wifi.sta.connect()
end)
