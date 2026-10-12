## A bunch of signals and variables to make passing information from 
## different nodes easier. No need for $"../../Target" to get info.
extends Node

## Pointer to the inventory handler. If multiplayer is implemented later on
## this might need to be reworked.
var G_INVENTORYHANDLER : InventoryHandler = null

## A preloaded list of all items in the game in JSON format.
const ITEMS = preload("res://data/raw/items.json")

## A preloaded list of the default values for various things. Will add more
## information to this comment as more data is added. May have to split up this
## file to make the information more clear.
const DEFAULTS = preload("res://data/raw/defaults.json")

##
#signal 
