#Deathrun
##How to play
There are two teams: **Runners** and **Deaths**. The objective of the Runners is to complete the course without getting caught in any traps. The objective of the Deaths is to trigger the traps in a way that will kill all the Runners in the most efficient way possible.

*Deaths - Press buttons, get kills.*<br>
*Runners - Run, and don't die.*

##Tactics
###Runner Tactics
Runners can **bait the traps** in order to cause the Deaths to trigger them without getting a kill. This involves techniques such as **air-strafing, bhopping**, and even teammates **distracting the Deaths** while they try and trigger the traps. Runners should do whatever they can to avoid dying, however dirty or dodgy their tactics may be.

###Death Tactics
Deaths can take advantage of this, however. Prediction and gamesense is key - Good Deaths can read the Runner's movements and predict when the Runner is about to try and cross the trap, as opposed to when they are trying to bait the trap. If a teammate is trying to distract you, you can expect the Runner to try and cross the trap in the moment that they think you're distracted. Pay attention!

##Commands
* Settings Menu - !settings
	* The settings menu is where you can edit all your clientside settings such as HUD position, announcer frequency, targetID fade time, and autojump.
* Crosshair Creator - !crosshair
	* This menu allows you to customise the appearance of your crosshair. Neat!
* This menu (Help menu) - !help
* Respawn - !r or !respawn
	* Available only during the round state WAITING FOR PLAYERS. This command respawns you at the start of the map in case you get stuck anywhere.
* Cleanup - !cleanup
	* Available only during the round state WAITING FOR PLAYERS. This command cleans up the map and all it's entities, thus resetting all the traps so that you can practice the course again.
* SetLives - !setlives <player> <lives> or !setlives <lives>
    * This command set lives to any runner
    * Only work if deathrun_enablelives is enabled
* GetLives - !getlives or !getlives <player>
    * This command get lives to any runner
    * Only work if deathrun_enablelives is enabled
* Toggle automatic checkpoint - !toggleautocheckpoint
    * This command toggle into manual or automatic checkpoint
    * Only work if deathrun_enablelives is enabled
* Set checkpoint - !checkpoint
    * This command save the position to respawn if your have lives, if the automatic checkpoint has enable then this command cancel the next automatic autosave, later save automatic again, this command have restrictions for use.
    * Only work if deathrun_enablelives is enabled
