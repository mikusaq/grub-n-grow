extends CanvasLayer

const money_symbol = "$"

func set_money(money: int):
	$MoneyAmount.text = money_symbol + str(money)
