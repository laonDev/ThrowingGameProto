package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source="../assets/bgLayer1.jpg")]
		public static const BgLayer1:Class;

		[Embed(source="../assets/welcome_playButton.png")]
		public static const PlayButton:Class;
		
		[Embed(source="../assets/fly_object.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="../assets/fly_object.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public static function getAtlas():TextureAtlas
		{
			if(gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
	}
}