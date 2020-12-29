package;
import h2d.Tile;
import hxd.res.TiledMap;

class MapImporter {
	public static function ImportTiledMap(mapData:TiledMapData, tileImage:Tile, scene:h2d.Scene, tileDimX=32, tileDimY=32) {
		importTiledMap(mapData, tileImage, scene, tileDimX, tileDimY);
	}
	
	private static function importTiledMap(mapData:TiledMapData, tileImage:Tile, scene:h2d.Scene, tileDimX:Int, tileDimY:Int){		
      
        // create a TileGroup for fast tile rendering, 
		// attach to 2d scene
        var group = new h2d.TileGroup(tileImage, scene);
		
		var tileWidth = tileDimX;
        var tileHeight = tileDimY;
        var mapWidth = mapData.width;
        var mapHeight = mapData.height;
		
		// make sub tiles from tile
        var tiles = [
             for(y in 0 ... Std.int(tileImage.height / tileHeight))
             for(x in 0 ... Std.int(tileImage.width / tileWidth))
             tileImage.sub(x * tileWidth, y * tileHeight, 
				tileWidth, tileHeight)
        ];
		
		// Build TileGroup from parsed json data
        for(layer in mapData.layers) {
            for(y in 0 ... mapHeight) for (x in 0 ... mapWidth) {
                // get the tile id at the current position 
                var tid = layer.data[x + y * mapWidth];
                if (tid != 0) { // skip transparent tiles
                    // add a tile to the TileGroup
                    group.add(x * tileWidth, 
						y * tileHeight, tiles[tid - 1]);
                }
            }
        }
	}
	
}