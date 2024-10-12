extends Control

func init(resource, amount):
    $ResourceColor.color = item_get_color(resource)
    $ResourceAmount.text = "[center]%s[/center]" % str(amount)
    $ResourceName.text = "[center]%s[/center]" % resource

func item_get_color(item_name):
    var item = load("res://resources/items/" + item_name + ".tres")
    return item.color
