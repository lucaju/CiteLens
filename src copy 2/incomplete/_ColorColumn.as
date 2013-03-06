package view.mini {
	
	//imports
	import view.CiteLensView;
	
	public class ColorColumn extends CiteLensView {
		
		//properties
		private var xml:XMLList;
		private var allText:String;
		
		
		private var xmlns:Namespace;
		private var xsi:Namespace;
		private var teiH:Namespace;
		
		public function ColorColumn() {
			
			super(citeLensController);
			
		}
		
		override public function initialize():void {
			
			
			xml = XMLList(citeLensController.getAllParagraphs());
			
			
			var namespaces:Array = xml.namespaceDeclarations();
			xsi = namespaces[0];
			xmlns = namespaces[1];
			teiH = new Namespace('http://www.w3.org/XML/1998/namespace');
			default xml namespace = xmlns;
			
			var i:int = 0
			/*
			while(i < 2) {
				
				
				//var nodeText:String;
				var newXML:XML = <body></body>;
				var node:XML;
				
				for each(node in xml.children()) {
					//trace (node)
					
					//trace (node.toString())
					
					
					//xml..p.replace(valueOf().childIndex(), valueOf().text());
					//node.parent().replace(node.childIndex(), node.text())
					
					
					var a:XMLList;
					var b:String;
					
					//trace (node.hasComplexContent())
					//trace (node)
					trace (node.children().length())
					if (node.children().length() > 0) {
					//if (node.hasComplexContent()) {
						a = node.children();
						newXML.appendChild(a);
					} else {
						b = node.text();
						newXML.appendChild(b);
					}
					
					//trace (a)
					//newXML.appendChild(a);
					//trace ("||||||||||")
					
				}
				
				
				xml = newXML;
				trace ("------")
				i++;
			}
			*/
			var tt:String;
			for each (var node:XML in xml.descendants()) {
				//trace (node.text())
				//tt += node.text();
			}
			
			//trace (tt)
			//trace (xml.descendants());
			
			
			//var b:XML = new XML(a)
			
			//trace (b)
			
			//trace (xml.*.*.*.*.*.*.children().length())
			//xml.*.*.*.*.*.*.normalize();
			//trace (xml.toString())
			//I could do a loop
			
			//trace (xml.*.*.text())
			
		}
	}
}