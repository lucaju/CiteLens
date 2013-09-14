package model {
	
	//Imports
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.TextFlow;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class DocBodyModel {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var paragraph				:String;
		protected var paragraphXML			:XML;
		protected var _array				:Array;
		protected var _arrayXML				:Array;
		
		protected var paragraphs			:XMLList;
		protected var divs					:XMLList;
		
		protected var xmlns					:Namespace;
		protected var xsi					:Namespace;
		protected var teiH					:Namespace;
		
		protected var textFlow				:TextFlow;
		protected var plainTex				:String;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param data
		 * 
		 */
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

			divs = data.text.body.descendants("div");
			
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param item
		 * 
		 */
		public function addParagraph(paragraph:String):void {		
			//add to the list
			_array.push(paragraph);
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */
		public function addParagraphXML(paragraphXML:XML):void {
			//add to the list
			_arrayXML.push(paragraphXML);
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getParagraphByIndex(value:int):String {
			return _array[value];
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function getParagraphXMLByIndex(value:int):XML {
			return _arrayXML[value];
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getAllParagraphsXML():XML {
			
			default xml namespace = xmlns;

			//final xml
			var resultXML:XML = <body></body>;
			
			var q:int = 0;
			for each (var element:XML in divs.children()) {										// [pb,head,p,note,div,label]
				
				switch (element.localName()) {
					
					case "head":
						resultXML.appendChild( headProcess(element) );
						break;
					
					case "p":
						resultXML.appendChild( paragraphProcess(element) );
						break;
					
					case "label":
						resultXML.appendChild( labelProcess(element) );
						break;
					
				}
			}
			
			
			return resultXML;
		}
		
		/**
		 * 
		 * @param element
		 * @return 
		 * 
		 */
		protected function headProcess(element:XML):XML {
			
			if ( element.hasSimpleContent() ) element.prependChild(<span></span>);
			
			//change name
			if (element.@type == "chapter") {
				element.setName("chapter");
			} else if (element.@type == "chapterSection") {
				element.setName("chapter_section");
			}
			//trace (element)
			return element;
		}
		
		/**
		 * 
		 * @param element
		 * @return 
		 * 
		 */
		protected function labelProcess(element:XML):XML {
			if ( element.hasSimpleContent() ) element.prependChild(<span></span>);
			element.setName("label");
			return element;
		}
		
		/**
		 * 
		 * @param element
		 * @return 
		 * 
		 */
		protected function paragraphProcess(element:XML):XML {
			
			//temp attribute
			default xml namespace = xmlns;
			var id:String
			
			//adding id attibute
			
			for each(var reference:XML in element.descendants("ref")) {
				if (reference.@type == "noteSpan") {
					
					//change tag name
					reference.setName("note_span"); //comment?
					
					//add ID
					id = reference.@corresp;  
					id = id.substring(6);					//#note_xx -> xx
					reference.@id = id;
					
					//add space before and after
					reference.prependChild(" ");
					reference.appendChild(" ");
					
					
				} else if (reference.@type == "noteLoc") {
					
					//change tag name
					reference.setName("note_loc");
					
					//test if next sibling is a reference: Add space
					if (reference.parent() != null && reference.childIndex() < reference.parent().children().length( )-1) {
						var nextNode:XML = reference.parent().*[reference.childIndex( )+1];
						//if (nextNode.localName() == null) reference.appendChild(" ");
					}
					
					//add ID
					id = reference.@target;  
					id = id.substring(6);					//#note_xx -> xx
					reference.@id = id;
					
					
				}
			}
			
			//
			if ( element.hasSimpleContent() ) element.appendChild(<span></span>);
			
			return element;
		}
		
		
		protected function noteProcess():void {
			
		}
		
		protected function pbProcess():void {
			
		}
		
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getFlowConvertText():TextFlow {
			if (!textFlow) textFlow = TextConverter.importToFlow(getAllParagraphsXML(), TextConverter.TEXT_FIELD_HTML_FORMAT);
			return textFlow;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPlainText():String {
			if (!plainTex) {
				if (!textFlow) this.getFlowConvertText();
				plainTex = TextConverter.export(textFlow, TextConverter.PLAIN_TEXT_FORMAT, ConversionType.STRING_TYPE) as String;
			}
			return plainTex;	
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getPlainTextLength():int {
			if (!plainTex) this.getPlainText();
			return plainTex.length;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		/*public function getRefsId():Array {
			
			var i:int = 1;
			
			var refsId:Array = new Array()
			var refs:Array = textFlow.getElementsByTypeName("ref");
			
			for each (var ref:FlowElement in refs) {
				ref.id = i.toString();	//add id to the element
				refsId.push(ref.id);
				i++;
			}
			
			return refsId;
		}*/
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getRefsId():Array {
			
			var refsId:Array = new Array()
			var refs:Array = textFlow.getElementsByTypeName("note_span");
			
			for each (var ref:FlowElement in refs) {
				refsId.push(ref.id);
			}
			
			return refsId;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNoteSpanData():Array {
			
			var noteSpanArray:Array = new Array();
			var noteSpan:Object;						//{id,start,end,numChar}
			
			
			var refs:Array = textFlow.getElementsByTypeName("note_span");
			
			for each (var ref:FlowElement in refs) {
				
				var refLength:int = ref.getText().length;
				var posStart:int = ref.getAbsoluteStart();
				var posEnd:int = posStart + refLength;
				
				noteSpan = {id: ref.id, start:posStart, end:posEnd, numChar:refLength};
				
				noteSpanArray.push(noteSpan);
			}
			
			return noteSpanArray;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function getRefLocationByID(id:String):Object {
			
			
			var element:FlowElement = textFlow.getElementByID(id);
			//trace (element.getText())
			
			//trace (textFlow.getElementByID(id).getText())
			//trace (id)
			//trace("---")
			var pos:Object = new Object();
			
			//trace (id)
			
			//trace (">>" + id)
			
			//!!!!!!!!!!!!!!!!!!!!!
			//if (id != "80" && id != "7") {
				pos.start = textFlow.getElementByID(id).getAbsoluteStart();
				pos.end = pos.start + textFlow.getElementByID(id).getText().length;
				
			//}
			
			return pos;
		}
		
		
		//****************** GETTERS // SETTERS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get length():int {
			return _array.length;
		}
	}
}