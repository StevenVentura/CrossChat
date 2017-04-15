--[[

Steven Ventura
3/12/17
the client code desu

]]



--[[
CLIENT "players" documentation:
--note this is different from the "players" table in CrossChatServer.lua
players looks like this:
playerObject
	playerName&server
	hostID
]]
local players = {};



function CROSSCHAT_CLIENT_SLASHCROSSCHAT(command)
enemyName = "";
--get the name of who he is trying to slash talk to
--check if hes targeting someone
targetName = "";
targetName = GetUnitName("target",true);
if (targetName == GetUnitName("player")) then
	targetName = "";
	end
if (targetName == nil and (command == "" or command == nil)) then
print(CROSSCHAT_COLOR .. "<CrossChat>You need to specify a target");
end--end if
if (targetName ~= "" and targetName ~= nil) then
	enemyName=targetName;
	else 
	enemyName = command;
	end
--enemyName has now been resolved and can be used.

if (enemyName ~= "") then
--TODO: check if player exists
CROSSCHAT_findServerHostForEnemy(enemyName);
BNSendWhisper(players[enemyName].hostID,CROSSCHAT_MESSAGE_INDICATOR .. CROSSCHAT_ADDINGNEWENEMY .. enemyName);
print(CROSSCHAT_COLOR .. enemyName .. " is being now hosted by " .. players[enemyName].hostID);
end
end--end function

--[[
Crosschat uses its own tab for whispers. the TAB key is overwritten to cycle through the different enemies. The 
	ENTER key is also overwritten for macros to send the message over the socket. There is also a 
	listener on each keystroke to correctly format the editbox. 
	
	The tab itself has messages from the enemy players, and from the player himself.
	You can click on the name of the enemy player if you want to talk to them instead.
]]

currentEnemyTalkingTo="";
--function to be called only once at addon startup
function CROSSCHAT_addCrosschatTab()
--http://wowwiki.wikia.com/wiki/Creating_tabbed_windows


--check if tab already there
local tab = 1
  for i = 1,30 do
    if GetChatWindowInfo(i)=="CrossChat" then
      print("Crosschat tab detected. not adding duplicate.");
	  return
    end
  end

--  _G["ChatFrame"..tab]:AddMessage(...)
--PanelTemplates_SetTab(myTabContainerFrame, 2);

  
  
  
  

end--end function
--it is called like this because i am going to open a new tab
function CROSSCHAT_findServerHostForEnemy(enemyName)
--[[
has to find a host for this guy
and then add him to our array
]]

--find sahib for now; dedicated host
for index = 1, BNGetNumFriends() do
--http://wowprogramming.com/docs/api/BNGetFriendInfo
local presenceID,glitchyAccountName,bnetNameWithNumber,isJustBNetFriend,characterName,uselessnumber,game = BNGetFriendInfo( index );
if (bnetNameWithNumber == "StevenOldAcc#1866") then
	players[enemyName] = {
	playerName = enemyName,
	hostID = presenceID
	};
--send the acknowledge to the server
name = GetUnitName("player",false);
realm = GetRealmName("player");
combo = name .. "-" .. realm;
BNSendWhisper(presenceID,CROSSCHAT_MESSAGE_INDICATOR .. CROSSCHAT_ASKINGFORHOST .. combo);
end--end if
--TODO poll for other hosts
end--end for

end--end function

--things other talkers say back to me
function CROSSCHAT_postReceivedMessageInTab(author,message)



end--end function
--things i say
function CROSSCHAT_postMyOwnMessageInTab(message)


end--end function

--the first byte of the message has been truncated (its an addon message)
function CROSSCHAT_ClientBNetMessageReceived(presenceID,message)
messageType = string.sub(message,1,1);
data = string.sub(message,1+1);
split = CrossChatSplitString(data);
if (messageType == CROSSCHAT_RECEIVEMESSAGEFROMTALKER) then
--data section: talker + " " + message
CROSSCHAT_postReceivedMessageInTab(split[1],split[2]);

end--end if




end--end function