local TextChatService = game:GetService("TextChatService")

local customTextChatServiceFolder = Instance.new("Folder")
customTextChatServiceFolder.Name = "RBXCustomTextChatService"
customTextChatServiceFolder.Parent = TextChatService

return {
	container = customTextChatServiceFolder
}