# 🧠 Roblox Automation Showcase (Educational Use Only)

> ⚠️ **Disclaimer:** This repository is intended **solely for educational purposes**.  
> It demonstrates scripting skills in Roblox Lua, RemoteEvents/Functions usage, automation workflows, and integrations with external APIs such as Discord.  
> None of the code is designed or intended for Terms-of-Service violations or unauthorized use.

---

## 📦 Scripts Included

### `1_auto_mailer.lua`

Automates mass sending of pets and diamonds to a list of accounts.

- Uses Roblox `RemoteFunction` to trigger mailbox events
- Loops through inventory and sends items matching specific rules (e.g. pet type, exclusivity, traits)
- Demonstrates retry logic, dynamic filtering, and mailbox automation

### `2_targeted_pet_mailer.lua`

Sends only selected high-value pets (e.g. Titanic, Huge) to a target user.

- Filters inventory by pet name and type
- Ensures pets are unlocked before sending
- Good for learning inventory parsing and UI-based constraints

### `3_discord_command_executor.lua`

Fetches the latest command from a Discord channel and executes it inside the Roblox client.

- Simulates a WebSocket via HTTP polling
- Extracts code from Discord embeds (`Aura`-prefixed)
- Can teleport the player to a specific `JobID`, or run Lua code via `loadstring`
- Controlled and safe: prevents re-execution of the same message

---

## 🛠️ Project Structure

```
scripts/
├── 1_auto_mailer.lua -- Inventory scanner + gem/item sender
├── 2_targeted_pet_mailer.lua -- Selective Huge/Titanic sender
└── 3_discord_command_executor.lua -- Remote Discord-controlled executor

README.md -- You're reading it :)
```

## 🔐 Legal & Ethical Notice

All scripts here respect Roblox’s mechanics and systems — and **must not** be used to:

- Exploit or interfere with public games
- Spam, harm, or abuse the mailbox system
- Evade bans or duplicate currency
- Circumvent platform limitations

Please follow:

- [Roblox Terms of Use](https://en.help.roblox.com/hc/en-us/articles/203313410)
- [Discord Terms](https://discord.com/terms)
