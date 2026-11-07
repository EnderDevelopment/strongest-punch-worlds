# Roblox Modded World Script

Strongest Punch Worlds is a Roblox script project for a standalone punch and collect simulator world. It includes a generated Roblox map, strength orbs, a rare crystal orb, a punch wall, a strength-based world portal, leaderstats, server-authoritative punching, a punch animation, and a mobile-friendly punch button.

## Install

1. Open Roblox Studio and create or open an experience.
2. In Explorer, create a ModuleScript inside `ServerScriptService` named `WorldConfig`.
3. Copy the contents of `src/WorldConfig.lua` into the `WorldConfig` ModuleScript.
4. Create a Script inside `ServerScriptService` named `ModdedWorld`.
5. Copy the contents of `src/ModdedWorld.server.lua` into the `ModdedWorld` Script.
6. Create a LocalScript inside `StarterPlayer > StarterPlayerScripts` named `Punch`.
7. Copy the contents of `src/Punch.client.lua` into the `Punch` LocalScript.
8. Start a Play test. The server script generates the Crystal Foundry world inside Workspace.

## Use

1. Move around the generated map and collect the blue strength orbs.
2. Collect the rare crystal orb near the punch wall. It awards a large amount of Strength and five Orbs.
3. Walk to the punch wall and use one of these controls:
   - Left mouse button
   - The `E` key
   - The on-screen `PUNCH [E]` button
4. Your Strength determines the damage dealt to the wall. The punch request is checked and processed by the server, and a punch animation plays locally.
5. After reaching the required Strength, walk into the Next World portal. The portal sets the player's `UnlockedWorld` attribute to the next world index and moves the player beyond the portal.
6. Edit `src/WorldConfig.lua` to change orb rewards, respawn times, wall health, punch scaling, portal requirements, cooldown, and the configured world index.

The current project generates one world named Crystal Foundry. It includes Strength, Orbs, and Prestige leaderstats, but it does not currently implement multiple generated worlds, a pet menu, saved player data, or automatic prestige milestones.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/9091d615-e855-48f2-a03d-cdc3c8f06d8f?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=9091d615-e855-48f2-a03d-cdc3c8f06d8f
