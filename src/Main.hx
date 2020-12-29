package;
import h2d.Bitmap;
import hxd.Res;
import hxd.Event;
import hxd.Window;


class Main extends hxd.App {
	
	var mainCharacter : Character;	
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
		MapImporter.ImportTiledMap(mapData, mapImage, s2d);
		
		mainCharacter = new Character("none", s2d);
		
		
	}
	
	override function update(dt:Float) {
		mainCharacter.HandleInput(dt);
		//s2d.offsetX = mainCharacter.currentAnimation.x;
		//s2d.offsetY = mainCharacter.currentAnimation.y;
		
	}
	
	static function main() {
		new Main();
	}	
}