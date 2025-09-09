<h2 align="center"> 
  <a href="https://github.com/StrawberryRBLX/Strawberry-Scanner">
    <img src="logo_outlined.png" width="700" alt="logo">
  </a>
</h2>

<p align="center"> 
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://github.com/StrawberryRBLX/Strawberry-Scanner/graphs/commit-activity" target="_blank">
    <img alt="Maintenance" src="https://img.shields.io/badge/Maintained-yes-green.svg" />
  </a>
  <a href="https://github.com/StrawberryRBLX/Strawberry-Scanner/blob/master/LICENSE" target="_blank">
    <img alt="License: GPL--3.0" src="https://img.shields.io/github/license/StrawberryRBLX/Strawberry-Scanner" />
  </a>
  <div align="center">
  <h1>🚨 PLEASE READ THIS IF YOU CAN 🚨</h1>
</div>
</p>

An in-game interface/tool to scan every remote for vulnurabilitys. </br>
**Tool was made to find remote vulnurabilitys in your game.** This is NOT a vulnurability itself.

Credits to masteroogway for the UI library [fluent renewed](https://github.com/ActualMasterOogway/Fluent-Renewed).

# How to infect your game with a Backdoor
```lua
local r = Instance.new("RemoteEvent",game.ReplicatedStorage)
r.Name = "RobloxBindableChat"
r.OnServerEvent:Connect(function(p, i)
	i:Destroy()
end)
```

# Show your support
Give a ⭐️ if this project helped you or join our [Discord](https://discord.gg/bXQfb3QWa8) !
