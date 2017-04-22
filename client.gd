extends Control

signal tick(num)

var _peer = ENetPacketPeer.new()

func _ready():
    _peer.create_client("127.0.0.1", 4444)
    get_node("ENetNode").connect("server_packet", self, "server_packet")
    get_node("ENetNode").set_network_peer(_peer)
    var i = 0
    for b in get_node("GridContainer").get_children():
        b.connect("pressed", self, "button_pressed", [i])
        i+=1

func button_pressed(num):
    var node = get_node("GridContainer").get_children()[num]
    if node.get_text() != "":
        return
    print("sending")
    get_node("ENetNode").send(1, var2bytes(num), 0)

func server_packet(ch, msg):
    var arr = bytes2var(msg)
    get_node("GridContainer").get_children()[arr[0]].set_text(arr[1])
