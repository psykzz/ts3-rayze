--[[
-- PsyK Mod -- Function file.
-- Version: 1.2
-- Author: PsyK
-- Website: http://www.psykzz.co.uk
-- E-Mail: matt.daemon660@gmail.com
--]]

-- Verbose mode : prints lots of debug text.
local verbose = false

-- Randomise the seed, and waste a few samples.
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
math.random(); math.random(); math.random()

function msg(txt)
   if verbose then
      ts3.printMessageToCurrentTab(txt)
   end
end

function sendServerMessage(ServerConn, message) 
   local error_txtToServer = ts3.requestSendServerTextMsg(ServerConn, message)
   if error_txtToServer ~= ts3errors.ERROR_ok then 
      msg("Error sending message to Server channel")
      return false
   end
   return true
end

function subscribeAllChannels(serverConnectionHandlerID) 
   local error = ts3.requestChannelSubscribeAll(serverConnectionHandlerID)
	if error == ts3errors.ERROR_not_connected then
		msg("Not connected")
		return false
	elseif error ~= ts3errors.ERROR_ok then
		msg("Error subscribing channel: " .. error)
		return false
	end
   return true
end

function getChannelID(ServerConn, ClientID)
   local myClientChannel, error_selfChannel = ts3.getChannelOfClient( ServerConn, ClientID )
   if error_selfChannel ~= ts3errors.ERROR_ok then
      msg( 'Error getting your client : ' .. error_selfChannel )
      return false
   end
   return myClientChannel
end

function getSelfID(serverConnectionHandlerID) 
	local myClientID, error_getSelf = ts3.getClientID(serverConnectionHandlerID)
	if error_getSelf ~= ts3errors.ERROR_ok then
		msg("Error getting own client ID: " .. error)
		return false
	end
	if myClientID == 0 then
		msg("Not connected")
		return false
	end
   return myClientID
end

function kickFromChannel(ServerConn, ClientID, message)
   local error_kickClient = ts3.requestClientKickFromChannel(ServerConn, ClientID, "Lady luck has struck again!")
   if error_kickClient ~= ts3errors.ERROR_ok then
      msg("Error kicking client "..rand..".")
      return false
   end
   return true
end

function kickFromServer(ServerConn, ClientID, message)
   local error_kickClient = ts3.requestClientKickFromServer(ServerConn, ClientID, "Lady luck has struck again!")
   if error_kickClient ~= ts3errors.ERROR_ok then
      msg("Error kicking client "..rand..".")
      return false
   end
   return true
end

function getClientName(ServerConn, ClientID)
 local clientName, error_clientName = ts3.getClientVariableAsString(ServerConn, ClientID, ts3defs.ClientProperties.CLIENT_NICKNAME)
	if error_clientName ~= ts3errors.ERROR_ok then
		msg("Error getting client nickname for #"..ClientID..".")
		return false
   end
   return clientName
end

function getClientList(serverConnectionHandlerID)
   local clients, error_clientList = ts3.getClientList(serverConnectionHandlerID)
	if error_clientList == ts3errors.ERROR_not_connected then
		msg("Not connected")
		return false
	elseif error_clientList ~= ts3errors.ERROR_ok then
		msg("Error getting client list: " .. error)
		return false
	end
   return clients
end


function getChannelList(serverConnectionHandlerID)
   local channels, error_channelList = ts3.getChannelList(serverConnectionHandlerID)
	if error_channelList == ts3errors.ERROR_not_connected then
		msg("Not connected")
		return false
	elseif error_channelList ~= ts3errors.ERROR_ok then
		msg("Error getting client list: " .. error)
		return false
	end
   return channels
end

function moveClient (ServerConn, clientID, newChannelID, password)
   local error_Move = ts3.requestClientMove(ServerConn, clientID, newChannelID, password)
   if error_Move == ts3errors.ERROR_not_connected then
		msg("Not connected")
		return false
	elseif error_Move ~= ts3errors.ERROR_ok then
		msg("Error getting client list: " .. error)
		return false
	end
   return true
end

function rand(lower,upper)
   --[[seed = seed+1
   math.randomseed(tonumber(tostring(seed):reverse():sub(1,6)))
   math.random()
   math.random()
   math.random()
   math.randomseed(tonumber(tostring(seed):reverse():sub(1,6))+math.random())
   math.random()
   math.random()--]]
   return math.random(lower,upper)
end