extends Resource
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
@export var effect: GDScript
@export var particle: PackedScene
