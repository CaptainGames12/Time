extends Resource
## This class is used for creating held in inventory elements/spells information containers
class_name InvItem
@export_group("Properties")
@export var item_name: String
@export var price: int
@export var damage: int

@export_group("Textures")
@export var texture: Texture2D
@export var inv_texture: Texture2D
@export var small_texture: Texture2D

@export_group("Audio")
@export var audio: AudioStream

@export_group("Effects")
## Effect holds script where logic of spell is described or spawn_area can be called if it's static spell.
## Most of times effect is attached to SpellManager which attack area reparents to enemy.
@export var effect: GDScript
## This variable holds particle 
@export var particle: PackedScene
## It holds spawned areas/entities for static spells. Every effect for areas is written in their own scripts.
@export var spawn_area: PackedScene
