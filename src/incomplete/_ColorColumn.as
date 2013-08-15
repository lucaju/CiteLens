package view.mini {
	
	//imports
	import view.CiteLensView;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class _ColorColumn extends CiteLensView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var xml			:XMLList;
		protected var allText		:String;
		
		
		protected var xmlns			:Namespace;
		protected var xsi			:Namespace;
		protected var teiH			:Namespace;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function _ColorColumn() {
			super(citeLensController);
		}
	
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
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