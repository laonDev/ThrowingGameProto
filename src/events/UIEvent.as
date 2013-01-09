package events
{
	import starling.events.Event;
	
	public class UIEvent extends Event
	{
		public static const BUTTON_CLICK:String = "buttonClick";
		
		public function UIEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}