--[[
-- PsyK Mod -- Logic file.
-- Version: 1.2
-- Author: PsyK
-- Website: http://www.psykzz.co.uk
-- E-Mail: matt.daemon660@gmail.com
--]]

function scramble(serverConnectionHandlerID, ...)
   subscribeAllChannels(serverConnectionHandlerID) 
   local myClientID = getSelfID(serverConnectionHandlerID)
   local clients = getClientList(serverConnectionHandlerID)
   local myClientChannel = getChannelID( serverConnectionHandlerID, myClientID )
   local channels = getChannelList(serverConnectionHandlerID)
   for k,v in ipairs(clients) do
      local rand = rand(1,#channels)
      local clientChannel = getChannelID( serverConnectionHandlerID, v )
      if clientChannel ~= myClientChannel then
         print(""..v.."removed")
         msg('removed '.. v ..' because not in channel') 
         table.remove(clients,k)
      else
         local clientName = getClientName(serverConnectionHandlerID, clients[k])
         moveClient(serverConnectionHandlerID,v,channels[rand], "")
         sendServerMessage(serverConnectionHandlerID, "[b]Scramble![/b]")
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