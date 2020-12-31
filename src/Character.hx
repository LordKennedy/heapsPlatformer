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
	
	/*
	// All characters have 3 attack animations
	var attack1 : Array<Tile>;
	var attack2 : Array<Tile>;
	var attack3 : Array<Tile>;
	
	// A hurt animation
	var hurt : Array<Tile>;
	
	// A death animation
	var death : Array<Tile>;
	*/
	
	// An idle and a walk animation IN BOTH DIRECTIONS!
	var idle_right : Array<Tile>;
	var idle_left : Array<Tile>;
	
	var walk_right : Array<Tile>;
	var walk_left : Array<Tile>;
	
	
	// 1_heavy, 2_standingLight, 3_walkingLight
	public function new(name : String, scene : h2d.Scene) {
		super(scene);
		var idle_bmp = Res.mainChars._1_Woodcutter.Woodcutter_idle.toTile();
		idle_right = idle_bmp.gridFlatten(48);
		setPivot(idle_right);
		currentAnimation = new Anim(idle_right, animation_speed, scene);
		
		idle_left = idle_bmp.gridFlatten(48);
		invert(idle_left);
		setPivot(idle_left);
		
		//var attack1_bmp = Res.mainChars._1_Woodcutter.Woodcutter_attack1.toTile();
		//attack1 = attack1_bmp.gridFlatten(48);
		
		var walk_bmp = Res.mainChars._1_Woodcutter.Woodcutter_walk.toTile();
		walk_right = walk_bmp.gridFlatten(48);
		setPivot(walk_right);
		
		walk_left = walk_bmp.gridFlatten(48);
		invert(walk_left);
		setPivot(walk_left);
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
		
		if (Key.isReleased(Key.A) || Key.isReleased(Key.D)) {
			StopWalking();
		}
	}
	
	private function Walk(newDirection:Direction) {
		direction = newDirection;
		if (state == State.Idle) {
			switch direction {
				case Direction.Left: currentAnimation.play(walk_left);
				default: currentAnimation.play(walk_right);
			}			
		}
		state = State.Walking;
	}
	
	private function StopWalking() {
		state = State.Idle;
		switch direction {
			case Direction.Left: currentAnimation.play(idle_left);
			default: currentAnimation.play(idle_right);
		}
		
	}
	
	private function setPivot(animSet:Array<Tile>, dx=17, dy=24) {
		for (frame in animSet) {
			frame.dx = dx;
			frame.dy = dy;
		}
	}
	
	private function invert(animSet:Array<Tile>) {
		for (frame in animSet) {
			frame.flipX();
		}
	}	
}