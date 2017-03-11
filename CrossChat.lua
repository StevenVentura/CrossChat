--Author: Nøøblet-Gorefiend (Steven Ventura)
--Date Created: March 10, 2017
--This addon lets you whisper the enemy faction using battle.net whispers. See https://github.com/StevenVentura/CrossChat for more info.

--all my constants for message shortening
CROSSCHAT_MESSAGE_INDICATOR = "÷;
CROSSCHAT_SENDMESSAGETOTALKER = "a";
CROSSCHAT_ASKINGFORHOST = "b";
CROSSCHAT_RECEIVEMESSAGEFROMTALKER = "c";

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


local function onBattlenetMessageReceived(words)
--return if its not an addon message
if (~(string.sub(message,1,strlen(CROSSCHAT_MESSAGE_INDICATOR)) == CROSSCHAT_MESSAGE_INDICATOR)) return;

--snip addonmessage header
CROSSCHAT_ServerBNetMessageReceived(string.sub(message,1+strlen(CROSSCHAT_MESSAGE_INDICATOR)));






end--end function




--this is called after the variables are loaded
function CrossChatInit()
CrossChat:SetScript("OnUpdate", function(self, elapsed) CrossChatOnUpdate(self, elapsed) end)
CrossChat:SetScript("OnEvent",function(self,event,...) self[event](self,event,...);end)
CrossChat:RegisterEvent("VARIABLES_LOADED");



print("hello world xd")

end--end function CrossChatInit






