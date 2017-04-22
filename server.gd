extends Control

var _peer = ENetPacketPeer.new()
var _clients = []
var turn = 0

func _ready():
    _peer.create_server(4444)
    get_node("ENetNode").connect("network_peer_connected", self, "client_connected")
    get_node("ENetNode").connect("peer_packet", self, "client_msg")
    get_node("ENetNode").set_network_peer(_peer)

func client_connected(id):
    _clients.append(id)

func client_msg(id, ch, msg):
    print("msg")
    var pos = bytes2var(msg)
    if id != _clients[turn]:
        print("Not your turn!")
    elif get_node("GridContainer").get_children()[pos].get_text() != "":
        print("Not empty!")
    else:
        var cid = _clients[turn]
        var text = "X"
        if turn == 0:
            text = "O"
        get_node("GridContainer").get_children()[pos].set_text(text)
        turn += 1
        if turn >= _clients.size():
            turn = 0
        get_node("ENetNode").broadcast(var2bytes([pos, text]), 0)