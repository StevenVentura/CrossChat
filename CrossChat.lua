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
CROSSCHAT_GREENONE = "|cff22dd22";

SLASH_CROSSCHAT1 = "/crosschat"; SLASH_CROSSCHAT2 = "/cc"; SLASH_CROSSCHAT3 = "/cross";
SlashCmdList["CROSSCHAT"] = slashCrossChat;

function slashCrossChat(msg,editbox)
command, rest = msg:match("^(%S*)%s*(.-)$");
InterfaceOptionsFrame_OpenToCategory(CrossChatOptionsPanel);
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


CrossChatDoOnlyOnce = 1;
function CrossChatOnUpdate(self, elapsed)

if (CrossChatDoOnlyOnce == 1) then
CrossChatDoOnlyOnce = 0;
CrossChatCreateOptions();
end--end if once only startup code
showTho = false;
if (ChatFrame3:IsShown() == false) then
showTho = true;
end
if (GeneralDockManager.selected ~= ChatFrame3) then
showTho = false;
ChatFrame3.FontStringContainer:Hide();
else
ChatFrame3.FontStringContainer:Show();
end
if (showTho == true) then ChatFrame3Tab:SetText("CrossChat"); ChatFrame3:Show() end
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



function CrossChatOutgoing(chatEntry, send)
--http://wowprogramming.com/docs/widgets/EditBox



if (send == 1 and chatEntry:GetName()=="ChatFrame3EditBox")
then
--this part fires when a message is sent
if (string.sub(chatEntry:GetText(),1,1) == "/"
	or chatEntry:GetText() == nil
	or chatEntry:GetText() == "") then
--do nothing for now i guess
else
CROSSCHAT_postMyOwnMessageInTab(chatEntry:GetText());
chatEntry:SetText("");--absorb the message
--also send it back
end


end


end--end function CrossChatOutgoing

CrossChatOptionsListBoxes = {};

function CrossChatCreateOptions() 
CrossChatOptionsPanel = CreateFrame("Frame","CrossChatOptionsPanel",UIParent);
CrossChatOptionsPanel.name = "CrossChat /cc";
--http://wowprogramming.com/snippets/Simple_Scroll_Frame_35

CrossChatScrollFrameTitle = CrossChatOptionsPanel:CreateFontString("CrossChatScrollFrameTitle",CrossChatOptionsPanel,"GameFontNormal");
CrossChatScrollFrameTitle:SetTextColor(1,1,0,1);
 CrossChatScrollFrameTitle:SetShadowColor(0,0,0,1);
 CrossChatScrollFrameTitle:SetShadowOffset(2,-1);
 CrossChatScrollFrameTitle:SetPoint("TOPLEFT",10,-10);
 CrossChatScrollFrameTitle:SetText("Friends to add");
 CrossChatScrollFrameTitle:Show();

local frame = CreateFrame("Frame", "CrossChatScrollFrameParent", CrossChatOptionsPanel) 
frame:SetSize(150, 200) 
frame:SetPoint("TOPLEFT",CrossChatScrollFrameTitle,"BOTTOMLEFT",0,0);
local texture = frame:CreateTexture() 
texture:SetAllPoints() 
texture:SetColorTexture(1,1,1,0.1) 
frame.background = texture 
local scrollframe = CreateFrame("ScrollFrame","CrossChatScrollFrame",CrossChatScrollFrameParent);
scrollframe:SetPoint("CENTER",0,0);
scrollframe:SetSize(150,200);
scrollframe:Show();

scrollbar = CreateFrame("Slider", CrossChatScrollBar, CrossChatScrollFrame, "UIPanelScrollBarTemplate") 
scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", 4, -16) 
scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 4, 16) 
scrollbar:SetMinMaxValues(1, 16*BNGetNumFriends()) 
scrollbar:SetValueStep(1) 
scrollbar.scrollStep = 1
scrollbar:SetValue(0) 
scrollbar:SetWidth(16) 
scrollbar:SetScript("OnValueChanged", 
function (self, value) 
self:GetParent():SetVerticalScroll(value) 
end) 
local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
scrollbg:SetAllPoints(scrollbar) 
scrollbg:SetColorTexture(0, 0, 0, 0.4) 

local content = CreateFrame("Frame", CrossChatScrollFrameContent, CrossChatScrollFrame) 
content:SetSize(128, 128) 
local texture = content:CreateTexture() 
texture:SetAllPoints() 
--texture:SetTexture("Interface\\GLUES\\MainMenu\\Glues-BlizzardLogo") 
texture:SetColorTexture(0,0,0,0);
content.texture = texture 

scrollframe:SetScrollChild(content)
--end http://wowprogramming.com/snippets/Simple_Scroll_Frame_35



local dummy = CreateFrame("CheckButton","CrossChatFriendSelectButton0",content,"OptionsCheckButtonTemplate");
dummy:SetPoint("TOPLEFT",0,16);
dummy:Hide();
--check boxes are 26 by 26 pixels. the gap between them is ...


for index = 1, BNGetNumFriends() do
--http://wowprogramming.com/docs/api/BNGetFriendInfo
local presenceID,glitchyAccountName,bnetNameWithNumber,isJustBNetFriend,characterName,uselessnumber,game = BNGetFriendInfo( index );
CrossChatOptionsListBoxes[bnetNameWithNumber] = {};
CrossChatOptionsListBoxes[bnetNameWithNumber].name = bnetNameWithNumber;
local pls = CreateFrame("CheckButton","CrossChatFriendSelectButton" .. index,content,"OptionsCheckButtonTemplate");
pls:SetPoint("TOPLEFT",_G["CrossChatFriendSelectButton" .. index-1],"BOTTOMLEFT",0,0);
pls.name = bnetNameWithNumber;
pls.setFunc = function(value) 
CrossChatOptionsListBoxes.checked = (value == "1");
end--end anonymous function
--now make text labels
local titleText = pls:CreateFontString("titleText",pls,"GameFontNormal");
 titleText:SetTextColor(1,0.643,0.169,1);
 titleText:SetShadowColor(0,0,0,1);
 titleText:SetShadowOffset(2,-1);
 titleText:SetPoint("LEFT",pls,"RIGHT",0,0);
 titleText:SetText(bnetNameWithNumber);
 titleText:Show();



end--end for
--[[for i=1,100 do
local pls = CreateFrame("CheckButton","plstho" .. i,content,"OptionsCheckButtonTemplate");
pls:SetPoint("TOPLEFT",_G["plstho" ..i-1],"BOTTOMLEFT",0,0);
pls:Show();
end--end for
]]



--add this options panel to the UI.
InterfaceOptions_AddCategory(CrossChatOptionsPanel);
InterfaceAddOnsList_Update();
end--end function CrossChatCreateOptions

--this is called after the variables are loaded
function CrossChatInit()

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",CROSSCHAT_onWhisperReceived);
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM",CROSSCHAT_onWhisperSent);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER",CROSSCHAT_CHAT_MSG_BN_WHISPER);
ChatFrame3:HookScript("OnHyperlinkClick",function(...) print("A hyperlink was clicked: ", ...) end)
ChatFrame3:AddMessage(CROSSCHAT_COLOR .. "HELP LISTING options: either...\n    1) Target someone and type /cc.\nor 2) Type /cc and then someones name. Include the dash-server name. \n         |cffff0000example: |cffffee00/cc swifty-ragnaros");
hooksecurefunc('ChatEdit_ParseText',CrossChatOutgoing);

CROSSCHAT_scanFriendsList();
--TODO
--CROSSCHAT_addCrosschatTab();
end--end function CrossChatInit