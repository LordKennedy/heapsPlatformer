package;
import h2d.Object;
import h2d.Anim;
import h2d.Tile;
import hxd.Res;
import hxd.Event;
import hxd.Key;
import h2d.SpriteBatch;

enum Direction {Left; Right;}
enum State {Walking; Idle;}

class Character extends Object {
	// Each character needs an animation we can add to a scene
	public var currentAnimation : Anim;
	var animation_speed = 8;
	var movementSpeed = 96;
	var direction = Direction.Right;
	var state = State.Walking;
	
	
	// All characters have 3 attack animations
	var attack1 : Array<Tile>;
	var attack2 : Array<Tile>;
	var attack3 : Array<Tile>;
	
	// A hurt animation
	var hurt : Array<Tile>;
	
	// A death animation
	var death : Array<Tile>;
	
	// An idle and a walk animation
	var idle : Array<Tile>;
	var walk : Array<Tile>;
	
	// 1_heavy, 2_standingLight, 3_walkingLight
	public function new(name : String, scene : h2d.Scene) {
		super(scene);
		var idle_bmp = Res.mainChars._1_Woodcutter.Woodcutter_idle.toTile();
		idle = idle_bmp.gridFlatten(48);
		currentAnimation = new Anim(idle, animation_speed, scene);
		currentAnimation.onAnimEnd = function() {
			switch state {
				case State.Idle:
					// Keep idle
					currentAnimation.play(idle);
				case State.Walking:
					// switch to idle
					state = State.Idle;
					currentAnimation.play(idle);
			}
		}
		
		var attack1_bmp = Res.mainChars._1_Woodcutter.Woodcutter_attack1.toTile();
		attack1 = attack1_bmp.gridFlatten(48);
		
		var walk_bmp = Res.mainChars._1_Woodcutter.Woodcutter_walk.toTile();
		walk = walk_bmp.gridFlatten(48);
		
		// currentAnimation.x = 48;
		// currentAnimation.y = 48;
	}
	
	public function HandleInput(dt:Float) {
		var adjMovementSpeed = movementSpeed * dt;
		if (Key.isDown(Key.A)) {
			currentAnimation.x -= adjMovementSpeed;
			Walk(Direction.Left);
		}
		if (Key.isDown(Key.D)) {
			currentAnimation.x += adjMovementSpeed;
			Walk(Direction.Right);
		}
		
	
	}
	
	private function Walk(newDirection:Direction) {
		if (state == State.Idle) {
			currentAnimation.play(walk);
			state = State.Walking;
		}
		if (newDirection != direction) {
			direction = newDirection;
			for (frame in currentAnimation.frames) {
				frame.flipX();
			}
		}
	}
	
}