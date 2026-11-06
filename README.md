# Roblox Avatar Morph Server Script

Avatar Morph Studio is a Roblox server script that lets authorized players morph their character into another Roblox user's avatar by entering the user's username. It uses Roblox avatar lookup APIs, applies the selected user's HumanoidDescription, and temporarily changes the visible display name while preserving the player's real account identity.

## Install

1. Create a normal `Script` inside `ServerScriptService`.
2. Copy the contents of `ServerScriptService/AvatarMorphServer.lua` into the Script, or use that file as the Script source.
3. Open the script and replace `123456789` in `ADMIN_USER_IDS` with your numeric Roblox UserId.
4. Publish the place and test it in a live Roblox server.

The avatar lookup APIs require a live server connection. The script uses server-side chat handling and does not require a LocalScript.

## Use

Authorized players can use these chat commands:

- `/morph Username` loads the specified

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/84cd8877-75c0-402f-a403-32956b047298?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=84cd8877-75c0-402f-a403-32956b047298
