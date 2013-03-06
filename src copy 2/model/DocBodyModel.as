package model {
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.TextFlow;
	
	public class DocBodyModel {
		
		//properties
		private var paragraph:String;
		private var paragraphXML:XML;
		private var _array:Array;
		private var _arrayXML:Array;
		
		private var paragraphs:XMLList;
		
		private var xmlns:Namespace;
		private var xsi:Namespace;
		private var teiH:Namespace;
		
		private var textFlow:TextFlow;
		private var _plainTex:String;
		
		
		public function DocBodyModel(data:XML) {
			
			//namespaces
			
			//xmlns = new Namespace(fullData.namespace());
			//trace (xmlns.prefix, xmlns.uri)
			
			var namespaces:Array = data.namespaceDeclarations();
			xsi = namespaces[0];
			xmlns = namespaces[1];
			
			//define namespace of lang and id attributes
			//trace(item.attributes()[1].name());
			teiH = new Namespace('http://www.w3.org/XML/1998/namespace');
			
			//define the default namespace
			default xml namespace = xmlns;

			paragraphs = data.text.body.div.descendants("p");
			
			_array = new Array();
			_arrayXML = new Array();
			
			
			//adding references
			for each(var p:XML in paragraphs) {
				addParagraph(p.toXMLString());
				
				/*
				var a:XML
				
				if (p.hasSimpleContent()) {
				//p.prependChild("<p>");
				//p.appendChild("</p>");
				
				
				var x:String = p.toXMLString();
				//trace (x);
				a = new XML(x);
				//trace (a)
				docBody.addParagraphXML(a);
				} else {
				
				}
				*/
				
				addParagraphXML(p);
				
			}
			
		}
		
		private function addParagraph(item:String):void {
				
			//create new paragraph
			paragraph = item;
			
			//add to the list
			_array.push(paragraph);
		}
		
		private function addParagraphXML(item:XML):void {
			
			//create new paragraph
			paragraphXML = item;
			//add to the list
			_arrayXML.push(paragraphXML);
		}
		
		public function get length():int {
			return _array.length;
		}
		
		public function getParagraphByIndex(value:int):String {
			return _array[value];
		}
		public function getParagraphXMLByIndex(value:int):XML {
			return _arrayXML[value];
		}
		
		public function getAllParagraphsXML():XML {
			
			//temp attribute
			var id:String
			
			//final xml
			var xml:XML = <body></body>;
			
			//paragraph loop
			for each(var p:XML in _arrayXML) {
				
				//adding id attibute
				for each(var reference:XML in p.ref) {
					
					//add ID
					id = reference.@corresp;  
					id = id.substring(6);					//#note_xx -> xx
					reference.@id = id;
				
					//changing footnote anchor tag name and adding id attibute
					for each(var footnote:XML in reference.ref) {
						
						//change tag name
						footnote.setName("noteLoc");
						
						//add ID
						id = footnote.@target;  
						id = id.substring(6);					//#note_xx -> xx
						footnote.@id = id;	
					}
				}
				
				//join paragraphs into one xml
				if (p.hasSimpleContent()) {
					
					//var a:XML = <span></span>;
					//a.appendChild(p);
					//trace (a)
					//trace ("---")
					//p.prependChild(<p>);
					//p.appendChild();
					
					//var x:String = p.toXMLString();
					//trace (x);
					//a = new XML(x);
					//trace (a)
					//docBody.addParagraphXML(a);
					
					p.appendChild(<span></span>);
					xml.appendChild(p);
					
				} else {
					xml.appendChild(p);
				}
				
			}
			
			return xml;
		}
		
		public function getFlowConvertText():TextFlow {
			
			textFlow = new TextFlow();
			textFlow = TextConverter.importToFlow(getAllParagraphsXML(),TextConverter.TEXT_FIELD_HTML_FORMAT);

			return textFlow;
		}
		
		public function getPlainText():String {
			
			_plainTex = TextConverter.export(textFlow,TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE) as String;
			return _plainTex;
		}
		
		public function getPlainTextLength():int {
			getPlainText();
			return _plainTex.length;
		}
		
		public function getRefsId():Array {
			var refsId:Array = new Array()
			var refs:Array = textFlow.getElementsByTypeName("ref");
			for each (var ref:FlowElement in refs) {
				if (ref.id != "") {				
					refsId.push(ref.id);
				}
			}
			return refsId;
		}
		
		public function getRefLocationByID(id:String):Object {
			//trace (id)
			var pos:Object = new Object();
			pos.start = textFlow.getElementByID(id).getAbsoluteStart();
			pos.end = pos.start + textFlow.getElementByID(id).getText().length;
			return pos;
		}
	}
}