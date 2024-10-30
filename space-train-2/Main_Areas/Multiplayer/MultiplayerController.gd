extends Control
var Address
@export var port:int = 8080
var peer
var hosting = false
signal back_pressed

func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		HostGame()

func HostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 3)
	if error != OK:
		print("cannot host:" + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer) #set server as peer
	print("waiting for players")

#called on server and client
func peer_connected(id):
	print("Player connected" + str(id))
#called on server and client
func peer_disconnected(id):
	print("Player disconnected" + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free() 
#called on client only
func connected_to_server():
	SendPlayerInfo.rpc_id(1, $NameInput.text, multiplayer.get_unique_id())
	print("Connected to server")
#called on client only
func connection_failed():
	print("Connection failed")

@rpc("any_peer")
func SendPlayerInfo(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : name,
			"id" : id,
			"score" : 0
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInfo.rpc(GameManager.Players[i].name, i )

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load( "res://Main_Areas/Planets/Forest/Forest_room_1.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_host_button_down() -> void:
	hosting = true
	Address = "127.0.0.1"
	var interfaces = IP.get_local_interfaces()
	var ip_address
	for iface in interfaces:
		print(iface)
		var addresses = iface.addresses
		for a in addresses:
			if a.begins_with("192.168.1."):
				ip_address = a
				print("Your IP is: ", a)
	$IpLabel.text = "You are hosting at: " + str(ip_address)
	HostGame()
	SendPlayerInfo($NameInput.text, multiplayer.get_unique_id())

func _on_join_button_down() -> void:
	Address = $IpInput.text
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Trying to join game at: " + str(Address))  

func _on_start_button_down() -> void:
	if hosting:
		StartGame.rpc()
	else:
		if $IpInput.text == "":
			print("not hosting")
			HostGame()
			SendPlayerInfo($NameInput.text, multiplayer.get_unique_id())
			StartGame.rpc()
		else:
			print("tried to start while inputting address")

func _on_back_pressed() -> void:
	back_pressed.emit()
