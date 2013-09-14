package view.bibliography {
	
	//imports
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import model.citation.CitationReason;
	
	import view.style.TXTFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ItemCitationInfo extends Sprite {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _citations				:Array;
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param notes
		 * 
		 */
		public function ItemCitationInfo(target:ItemRef, notes:Array) {
			
			_citations = notes;
			
			var line:Sprite = new Sprite();
			line.graphics.lineStyle(2,0xE6E7E8,.5);
			line.graphics.beginFill(0xFFFFFF );
			line.graphics.moveTo(1, 0);
			line.graphics.lineTo(50, 0);
			line.graphics.endFill();
			line.y = 4;
			this.addChild(line);
			
			//Text Field
			var textTF:TextField = new TextField();
			textTF.selectable = false;
			textTF.multiline = true;
			textTF.mouseEnabled = false;
			textTF.wordWrap = true;
			textTF.autoSize = TextFieldAutoSize.LEFT;
			textTF.antiAliasType = AntiAliasType.ADVANCED;
			textTF.width = ItemRef.origWidth - ( 6 * target.margin ) - target.noteAreaWidth;
			textTF.embedFonts = true;
			textTF.y = 8;
			
			var noteString:String = "";
			var citeNum:int = 1;
			
			for each (var note:Object in notes) {
				
				//reason
				
				var reason:String = note.reason;
				if (reason == CitationReason.BOTH.toLowerCase()) {
					reason = CitationReason.SUPPORT.toLowerCase() + " and " + CitationReason.REJECT.toLowerCase();
				} else if (reason == CitationReason.NEITHER.toLowerCase()) {
					reason = "";
				}
				
				//further reading
				var further:String = note.furtherReading;
				if (note.furtherReading == "true") {
					further = "further reading";
				} else {
					further = "";
				}
				
				noteString += "Citation " + citeNum + ": " ;
				if (reason != "") noteString += reason + " ";
				noteString += note.contentType;
				if (further != "") noteString += " " + further;
				/*if (notes.indexOf(note) < notes.length-1)*/ noteString += "\n";
				
				citeNum++;
			}
			//trace (noteString)
			textTF.text = noteString;
			textTF.setTextFormat(TXTFormat.getStyle("Item List Note Info"));
			
			this.addChild(textTF);
			
			//bg
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xFFFFFF,0);
			bg.graphics.drawRect(0,0,this.width,this.height + 10);
			bg.graphics.endFill();
			
			this.addChildAt(bg,0);
			
		}

		
		//****************** GETTETRS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get citations():Array {
			return _citations;
		}

	}
}