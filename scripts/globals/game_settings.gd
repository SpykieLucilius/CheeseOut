extends Node

# ------------------------------------------------------------------
# Game settings singleton autoload
# ------------------------------------------------------------------

enum Difficulty { EASY, NORMAL, HARD }

var difficulty: int = Difficulty.NORMAL
var is_solo: bool = false