# The Unnoficial Rivals of Aether API
This is a CheatEngine table attached to a series of Lua scripts that can be used to export data related to the game.
Common uses could be statistic projects and scrapers to update data on a tournament scoreboard.

Current data it is able to obtain:
- Player Stock Losses (not stock count, and will also not increase with SDs)
- Player Percentage
- Player Character (IDs only)
- Player Standings
- A flag that determines whether the game client is in a match or not.

Every number of seconds (configurable in the script), the script checks for changes and if there are any, it will send the changes to the set address (also configurable in the script) via a URI-encoded POST request.
You are also able to configure which scope of changes should trigger a request (currently only in-game flag is supported as a trigger).
Please note that it's not part of the scope of this project to export this data to whichever software you use. You must write your own middleware that receives requests sent from the CheatEngine client and applies the data to your software accordingly. Either that or you must ask the maintainer of the software you work with to develop the implementation for you.

## Disclaimer
This project has been developed with the sole purpose of scraping data from offline matches. These addresses may not point to actual data in the game, so making any changes to these values may cause unintended behavior.
**This project has not been tested online, and it is currently unknown if it is safe to use in online matches.**

## Setup
First the cheat table must be able to find the addresses related to the game data. This must be done every time the game launches, as the addresses can change.
- Make sure the game is running
- Launch the CheatEngine client and open the script roa.CT (Ctrl+O)
- Attach the Rivals of Aether game to the CheatEngine client
- Click on the "Active" box on the "Poll for Memory Addresses" script.
- Start a match. This can be a FFA or Doubles match with CPUs. Make sure it's a 4-player match so data for all ports can be collected.
- Wait for the match to finish. Once the match ends the script will automatically finish polling.
- Click on the "Active" box on the "Observe Changes & Send to Server" script. You should be good to go here.
If you close out of CheatEngine or Rivals of Aether, you must do all of the above steps again.

## Data Export Structure
This is the data that will be exported through the URI-encoded form to the address of your choosing:
- P1StocksLost, P2StocksLost, P3StocksLost, P4StocksLost: Player Stock Losses (number)
- P1Percentage, P2Percentage, P3Percentage, P4Percentage: Player Percentage (number)
- P1Character, P1Character, P1Character, P1Character: Player character in IDs
- P1Standing, P2Standing, P3Standing, P4Standing: Player standing, from 1 (1st) to 4 (4th), should be the same for doubles matches

### Character IDs
- Random: 1
- Zetterburn: 2
- Orcane: 3
- Wrastor: 4
- Kragg: 5
- Forsburn: 6
- Maypul: 7
- Absa: 8 (might show 3.95252516672997E-323 as a bug)
- Etalus: 9
- Ori: 10
- Ranno: 11
- Clairen: 12
- Sylvanos: 13
- Elliana: 14
- Shovel Knight: 15
- Mollo: 16
- Hodan: 17
- Pomme: 18
- Olympia: 19
Workshop characters may show up as values above 20, but these cannot be fully determined as of this writing.

## Help this project
This cheat table was written in a very rudimentary way as GameMaker is really good with hiding values inside memory, also I'm not really good with CE (this is my first project and I've developed it in about 2 weeks for a very specific need). If someone is able to rewrite the memory address obtaining part, preferrably using a way that fetches the values from static pointers instead, it would be very appreciated.
