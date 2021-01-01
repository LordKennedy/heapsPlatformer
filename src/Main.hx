package;
import h2d.Anim;
import h2d.Bitmap;
import hxd.Res;
import hxd.Event;
import hxd.Window;

import MapImporter;


class Main extends hxd.App {
	
	var mainCharacter : Character;
	var mapGroup : Array<Coord>;
	
	override function init() {
		super.init();
		Res.initEmbed();
		s2d.scaleMode = ScaleMode.Zoom(4);		
		// Add backdrop and tiles
		var backdrop_bmp = new Bitmap(
			Res.swamp._2_Background.Background.toTile(), s2d);
		
		var mapData = haxe.Json.parse(hxd.Res.maps.export.firstMap.entry.getText());
		var mapImage = hxd.Res.swamp._1_Tiles.Tileset.toTile();
		
		// Import the map
		mapGroup = MapImporter.ImportTiledMap(mapData, mapImage, s2d);
		mainCharacter = new Character(s2d);	
		
	}
	
	override function update(dt:Float) {
		mainCharacter.HandleInput(dt);
		mainCharacter.update(dt, mapGroup);
		s2d.x = -1 * mainCharacter.currentAnimation.x + 48;
		s2d.y = -1 * mainCharacter.currentAnimation.y + 2* 48;
		
	}
	
	static function main() {
		new Main();
	}	
}