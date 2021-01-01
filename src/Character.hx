package;
import h2d.Object;
import h2d.Anim;
import h2d.Tile;
import h2d.TileGroup;
import hxd.Res;
import hxd.Key;

import MapImporter;

enum Direction {Left; Right;}
enum State {Walking; Idle;}

// TODO: Refactor to extend ANIM and get rid of currentAnimation

class Character extends Object {
	// Each character needs an animation we can add to a scene
	public var currentAnimation : Anim;
	var animation_speed = 8;
	var movementSpeed = 96;
	var direction = Direction.Right;
	var state = State.Walking;
	var touchingGround:Bool = false;
	
	var gravity:Float = 10;
	var verticalVelocity:Float = 0;
	
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
	public function new(scene : h2d.Scene) {
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
		
		// State vars
		direction = Direction.Right;
		state = State.Idle;
	}
	
	// Probably needs refactoring, but handles inputs.
	public function HandleInput(dt:Float) {
		var adjMovementSpeed = movementSpeed * dt;
		// L/R movement
		if (Key.isDown(Key.A)) {
			currentAnimation.x -= adjMovementSpeed;
			Walk(Direction.Left);
		}
		if (Key.isDown(Key.D)) {
			currentAnimation.x += adjMovementSpeed;
			Walk(Direction.Right);
		}
		// Back to idle from L/R
		if (Key.isReleased(Key.A) || Key.isReleased(Key.D)) {
			StartIdle();
		}
		
		// Jumping
		if (Key.isPressed(Key.W) && touchingGround) {
			verticalVelocity -= 480;
			touchingGround = false;	
			currentAnimation.y -= 5;
		}
		
		// Attacking
	}
	
	// Switches the character to walking state and animation
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
	
	// Switches the character back to the idle
	private function StartIdle() {
		state = State.Idle;
		switch direction {
			case Direction.Left: currentAnimation.play(idle_left);
			default: currentAnimation.play(idle_right);
		}
		
	}
	
	// Update should handle gravitational applications
	// Detect collisions where?
	public function update(dt:Float, mapGroup:Array<Coord>) {		
		// To apply gravity:
		var canMove = true;
		
		// Now, see if our pivot is colliding with any tiles in mapGroup		
		for (tile in mapGroup) {
			// TODO: Fix for different tile sizes
			if ((currentAnimation.y <= tile.y + 32 && tile.y <= currentAnimation.y)
			  && currentAnimation.x <= tile.x && tile.x -32 <= currentAnimation.x){
				// We know we are colliding, can't move down
				canMove = false;
				verticalVelocity = 0;
				touchingGround = true;
				// Adjust player to the top of the tile
				currentAnimation.y = tile.y;
				break; // We don't need to keep looking
			}
		}
		if (canMove) {
			touchingGround = false;
			currentAnimation.y += verticalVelocity * dt;
			verticalVelocity += gravity;
		}
	}
	
	
	
	// Helpers
	
	// setPivot sets the correct pivot for the main characters
	// The pivot point is located at their center, feet
	// dy=-16
	private function setPivot(animSet:Array<Tile>, dx=17, dy=-48) {
		for (frame in animSet) {
			frame.dx = dx;
			frame.dy = dy;
		}
	}
	
	// Invert flips all tiles in an animation set
	private function invert(animSet:Array<Tile>) {
		for (frame in animSet) {
			frame.flipX();
		}
	}	
}