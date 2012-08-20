--
-- rayze Roll dice admin fuck about
-- Version: 1.0
-- Author: PsyK
-- Website: http://www.psykzz.co.uk
-- E-Mail: matt.daemon660@gmail.com
--
require("ts3defs")
require("ts3errors")

local debug = false

function msg(txt)
   if debug then
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

function rand1(lower,upper) 
   local norolls = math.random(1,100)
   local roll= {}
   for i=1,norolls do
      roll[i] = math.random(lower,upper)
   end
   local selectroll = math.random(1,norolls)
   return roll[selectroll]
end

function rand(lower,upper)
   math.randomseed(tonumber(tostring(os.clock()):reverse():sub(1,6)))
   math.random()
   math.random()
   math.random()
   math.randomseed(tonumber(tostring(os.clock()):reverse():sub(1,6))+math.random())
   math.random()
   math.random()
   return math.random(lower,upper)
end

function testChannel(serverConnectionHandlerID, ...)
   subscribeAllChannels(serverConnectionHandlerID) 
   local myClientID = getSelfID(serverConnectionHandlerID)
   local clients = getClientList(serverConnectionHandlerID)
   local myClientChannel = getChannelID( serverConnectionHandlerID, myClientID )
   sendServerMessage(serverConnectionHandlerID, "[b]Clients in channel "..myClientChannel.."[/b]")
   for k,v in ipairs(clients) do 
      local ClientChannel = getChannelID( serverConnectionHandlerID, v )
      if myClientChannel == ClientChannel then
         local clientName = getClientName(serverConnectionHandlerID, v)
         ts3.requestSendServerTextMsg(serverConnectionHandlerID, clientName..",")
      end
   end
end

function roll(serverConnectionHandlerID, ...)
   subscribeAllChannels(serverConnectionHandlerID) 
   local myClientID = getSelfID(serverConnectionHandlerID)
   local clients = getClientList(serverConnectionHandlerID)
   local myClientChannel = getChannelID( serverConnectionHandlerID, myClientID )
   for k,v in ipairs(clients) do 
      local clientChannel = getChannelID( serverConnectionHandlerID, v )
      if clientChannel ~= myClientChannel then
         msg('removed '.. v ..' because not in channel') 
         table.remove(clients,k)
      end
   end
   local rand = rand(1,#clients)
   local clientName = getClientName(serverConnectionHandlerID, clients[rand])
   sendServerMessage(serverConnectionHandlerID, "[b]DICE ROLLED![/b]")
   kickFromChannel(serverConnectionHandlerID, clients[rand], "Lady luck has struck again!")
   sendServerMessage(serverConnectionHandlerID, "[b]Dice rolled a number "..rand.."! "..clientName.." was Kicked, unlucky![/b]")
end
