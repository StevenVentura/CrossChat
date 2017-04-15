--Author: Nøøblet-Gorefiend (Steven Ventura)
--Date Created: March 10, 2017
--This addon lets you whisper the enemy faction using battle.net whispers. See https://github.com/StevenVentura/CrossChat for more info.
CrossChat = CreateFrame("Frame");

--CrossChat:SetScript("OnEvent",function(self,event,...) self[event](self,event,...);end)
CrossChat:SetScript("OnUpdate", function(self, elapsed) CrossChatOnUpdate(self, elapsed) end)
CrossChat:RegisterEvent("VARIABLES_LOADED");
CrossChat:RegisterEvent("CHAT_MSG_BN_WHISPER");

--all my constants for message shortening
CROSSCHAT_MESSAGE_INDICATOR = "÷";
CROSSCHAT_SENDMESSAGETOTALKER = "a";
CROSSCHAT_ASKINGFORHOST = "b";
CROSSCHAT_RECEIVEMESSAGEFROMTALKER = "c";
CROSSCHAT_ADDINGNEWENEMY = "d";
CROSSCHAT_COLOR = "|cffff8800";--message color

SLASH_CROSSCHAT1 = "/crosschat"; SLASH_CROSSCHAT2 = "/cc"; SLASH_CROSSCHAT3 = "/cross";
SlashCmdList["CROSSCHAT"] = slashCrossChat;

function slashCrossChat(msg,editbox)
command, rest = msg:match("^(%S*)%s*(.-)$");
CROSSCHAT_CLIENT_SLASHCROSSCHAT(command);

end--end function
--local function taken from http://stackoverflow.com/questions/1426954/split-string-in-lua by user973713 on 11/26/15
function CrossChatSplitString(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; local i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function CrossChatOnUpdate(self, elapsed)

end--end function CrossChatOnUpdate


function CROSSCHAT_onWhisperSent(ChatFrameSelf, event, message, author, ...)
return (string.sub(message,1,1) == CROSSCHAT_MESSAGE_INDICATOR);--hide the chat if its crosschat message plugin not necessary actually
end--end function
function CROSSCHAT_onWhisperReceived(ChatFrameSelf, event, message, author, ...)
CROSSCHAT_ServerWhisperReceived(author,message);
end--end function


function CROSSCHAT_scanFriendsList()

if BNConnected() then
for index = 1, BNGetNumFriends() do
--http://wowprogramming.com/docs/api/BNGetFriendInfo
local presenceID,glitchyAccountName,bnetNameWithNumber,isJustBNetFriend,characterName,uselessnumber,game = BNGetFriendInfo( index );

end--end for
end--end if BNConnected

--C_Timer.After( 3, CROSSCHAT_scanFriendsList );
end--end function

--http://wowprogramming.com/docs/events/CHAT_MSG_BN_WHISPER
function CROSSCHAT_CHAT_MSG_BN_WHISPER(tableThing,uselessCHAT_MSG_BN_WHISPER
						,message,sender,u3,u4,u5,u6,u7,u8,u9,u10,presenceLie,u11,presenceID,u13)
--return if its not an addon message
if (not(string.sub(message,1,strlen(CROSSCHAT_MESSAGE_INDICATOR)) == CROSSCHAT_MESSAGE_INDICATOR)) then return; end
if (sender == GetUnitName("player")) then return; end
--snip addonmessage header and plug into the server and client modules
CROSSCHAT_ClientBNetMessageReceived(presenceID,string.sub(message,1+strlen(CROSSCHAT_MESSAGE_INDICATOR)));
CROSSCHAT_ServerBNetMessageReceived(presenceID,string.sub(message,1+strlen(CROSSCHAT_MESSAGE_INDICATOR)));
end--end function





--this is called after the variables are loaded
function CrossChatInit()

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",CROSSCHAT_onWhisperReceived);
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM",CROSSCHAT_onWhisperSent);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER",CROSSCHAT_CHAT_MSG_BN_WHISPER);
CROSSCHAT_scanFriendsList();
--TODO
--CROSSCHAT_addCrosschatTab();
end--end function CrossChatInit