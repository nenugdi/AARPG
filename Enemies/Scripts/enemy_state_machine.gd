class_name  EnemyStateMachine extends Node

var states : Array[EnemyState]
var prev_state : EnemyState
var current_state : EnemyState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED #这个节点会立刻 “冻结” ，完全停止运行！
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ChangeState(current_state.Process(delta))
	pass

func _physics_process(delta: float) -> void:
	ChangeState(current_state.Physics(delta))
	pass


func initialize( _enemy : Enemy )->void:
	states = []
	for c in get_children(): #获取所有状态机的子节点，就是全部状态
		if c is EnemyState:
			states.append(c)
	for s in states: #把状态的两个属性赋值
		s.enemy = _enemy
		s.enemy_state_machine = self
		s.Init() #暂时没用上,用于stun状态
		
	if states.size()>0: #装入第一个状态
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT #让节点运行起来


func ChangeState(new_state : EnemyState) ->void:
	if new_state == null || new_state == current_state:
		return
	if current_state:
		current_state.Exit()
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
