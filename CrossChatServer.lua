--[[
CrossChatServer.lua
Steven Ventura (Gangsthurh)
3/11/17

The purpose of this lua file is to handle all of the server-related code. 
	This keeps is separate from the Client-related code and the general-purpose code.

--]]


--[[
DOCUMENTATION
"players" array is an array of objects. it should be changed with my access functions.

The data of each cell of "players" looks like this:
playerObject
	presenceID
	playerName
	stackOfMessagesToSend -- example: CROSSCHAT_MESSAGE_INDICATOR CROSSCHAT_SEND_MESSAGE 
	talkerObjectArray
		talkerObject
			name
			realm
		

]]
local players = {};

--[[first two bytes have been trimmed. send the message and store the data of who it was sent to.
note that "clientName" parameter is a battlenet presenceID
]]
local function queueNewMessageFromClient(presenceID,message)
--parse out the message
indexOfSpace = string.find(message," ");
whoToSendMessageTo = string.sub(message,1,indexOfSpace-1);
dataToSend = string.sub(message,indexOfSpace+1);

--put the new header on the message so he knows who he is hearing from
dataToSend = "<cc>[" .. players[presenceID].playerName .. "]: " .. dataToSend;

--add this person to list of people who can reply to your client player
players[presenceID].talkerObjectArray[whoToSendMessageTo] = whoToSendMessageTo;
--just go ahead and send the message
SendChatMessage(dataToSend,"WHISPER",nil,whoToSendMessageTo);
end--end function

--all of the talkers are stored on the client
<<<<<<< HEAD
function CROSSCHAT_acceptNewClient(sender,data)
player = {
	presenceID = sender,
	playerName = data;
=======
function CROSSCHAT_acceptNewClient(sender,name)
player = {
	presenceID = sender,
	playerName = name;
>>>>>>> origin/master
	stackOfMessagesToSend = {},--stackOfMessagesToSend
	talkerObjectArray = {}--talker array
};
players[sender] = player;
end--end function



--[[
DOCUMENTATION
format: 
message inidicator, sender name, data
note "player" is a presenceID
]]
function CROSSCHAT_sendBNetMessageFromTalkerToClient(talker,player,message)
--make that header
messageOut = CROSSCHAT_MESSAGE_INDICATOR .. CROSSCHAT_RECEIVEMESSAGEFROMTALKER .. talker .. " " .. message;
BNSendWhisper(player,messageText);

end--end function

function CROSSCHAT_ServerWhisperReceived(sender,message)
--check if this is one of our clients''' talkers''. if so, send the message
for player in players do
for talker in player.talkerObjectArray do
if (talker == sender)
	then
	CROSSCHAT_sendBNetMessageFromTalkerToClient(talker,player,message);
	return
	end
end--end for
end--end for



end--end function



--[[
DOCUMENTATION
CROSSCHAT MESSAGING:
	bytes:			
format of message: xxDATA

all messages here are addon messages
<<<<<<< HEAD

note that @param sender is presenceID
=======
>>>>>>> origin/master
--]]
function CROSSCHAT_ServerBNetMessageReceived(sender,message)
typeOfMessage = string.sub(message,1,1);


--it is words to send from client to talker
if (typeOfMessage == CROSSCHAT_SENDMESSAGETOTALKER)
then
queueNewMessageFromClient(sender,string.sub(message,1+1));
end--end if

--[[
DOCUMENTATION
it is a client requesting to be hosted by me. the DATA section has the name of client's current ingame player.

]]
if (typeOfMessage == CROSSCHAT_ASKINGFORHOST)
then
CROSSCHAT_acceptNewClient(sender,string.sub(message,1+1));
end--end if

--[[
CLIENT CODE HANDLES OTHER THINGS:
typeOfMessage == CROSSCHAT_RECEIVEMESSAGEFROMTALKER

]]




end--end function