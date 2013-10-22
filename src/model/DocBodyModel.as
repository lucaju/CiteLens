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
			
			XML.ignoreWhitespace = false;

			divs = data.text.body.descendants("div");
			
		}
		
		
		//****************** PUBLIC AUXILIAR CONSTUCTOR METHODS ****************** ****************** ******************
		
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
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param element
		 * @return 
		 * 
		 */
		protected function processHeader(element:XML):XML {
			
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
		protected function processLabel(element:XML):XML {
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
		protected function processParagraph(element:XML):XML {
			
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
					//reference.prependChild(" ");
					//reference.appendChild(" ");
					
					//--------
					//Remove elements with attrtibute rend=false
					
					var elements:XMLList = reference.descendants("@rend");
					var rep:XML = <span> </span>;
					
					for each (var elem:XML in elements) {
						
						var tagElement:XML = elem.parent();
						
						tagElement.setChildren(" ");
						
						//var parent:XML = tagElement.parent();
						//var localName:String = tagElement.localName();
							
					//	if (parent) if (parent.hasOwnProperty(localName)) parent.replace(localName,rep);								//<< remove some, bute editor doesn't work	
							
						
					}
					
					//--------
					
					////************************* Work still in progress ****************
					
					
				} else if (reference.@type == "noteLoc") {
					
					//change tag name
					reference.setName("note_loc");
					
					//test if next sibling is a reference: Add space
					if (reference.parent() != null && reference.childIndex() < reference.parent().children().length( )-1) {
						var nextNode:XML = reference.parent().*[reference.childIndex( )+1];
						if (nextNode.localName() == null) reference.appendChild(" ");
					}
					
					//add ID
					//id = reference.@target;  
					//id = id.substring(6);					//#note_xx -> xx
					//trace(reference.text(),">>",reference.text().length())
					reference.@id = reference;
					if (reference.text().length() > 1) reference.@id = reference.toString().substring(0,reference.toString().length-1);
					
					
				}
			}
			
			//adding spaces
			if ( element.hasSimpleContent() ) element.appendChild(<span></span>);
			
			//adding spaces in the descendants
			var descendants:XMLList = element.descendants();
			
			var prevDesc:XML;
			
			for each (var desc:XML in descendants) {
				
				// if not a superscript note locatator
				if (desc.localName() != "note_loc") {
				
					//if is not the first descendant (of each paragraph)
					if (desc.childIndex() > 0) {
						
						//if is not set to false render
						if (!desc.@rend) {
							
							//if this or the previous are not a note span
							if (desc.localName() != "note_span" && prevDesc.localName() != "note_span") {				
								
								desc.prependChild(" ");
								desc.appendChild(" ");
								
							}
							
						}
						
					}
					
					//if note span
					if (desc.localName() == "note_span") {
						
						//if is not the first in the paragraph and previous is not a note span
						if (desc.childIndex() > 0 && prevDesc.localName() != "note_span") desc.prependChild(" ");
						
						//if previous is not a note span
						if (prevDesc && prevDesc.localName() != "note_span") desc.appendChild(" ");	
						
						//if is the first
						if (!prevDesc) desc.appendChild(" ");
					}
					
					//if it is a false render
					if (desc.hasOwnProperty("@rend")) desc.appendChild(<span> </span>);
					
					
				}
					
				prevDesc = desc;
				
				
			}
			
			//return
			return element;
		}
		
		
		/**
		 * 
		 * @param element
		 * 
		 */
		protected function processNote():XML {
			
			//temp attribute
			default xml namespace = xmlns;
			
			//result xml
			var resultXML:XML = <body></body>;
			
			
			for each (var element:XML in divs.children()) {										
				
				if (element.localName() == "note") {
					
					var note:XML = <footnote></footnote>;
					
					//--------
					//Remove elements with attrtibute rend=false
					var elements:XMLList = element.descendants("@rend");
					
					for each (var elemen:XML in elements) {
						var tagElement:XML = elemen.parent();
						tagElement.setChildren("");
					}
					
					//--------
					
					for each(var elem:XML in element.children()) {
						
						
						//find note number
						//change <gi> tag name to <note_number>
						//store note number in the note attribute ID
						if (elem.localName() == "gi") {
							
							elem.setLocalName("note_number");
							
							var id:String = elem.text();  
							id = id.substring(0,id.length-1);					//xx. -> xx
							
							note.@id = id;
						}
						
						//add extra space to elements
						for each(var e:XML in elem.descendants()) {
							if (e.hasSimpleContent()) e.prependChild(" ");
						}
						
						//if ( elem.hasSimpleContent() ) elem.prependChild(<span></span>);
						
						note.appendChild(elem);
					
					}
					
					var p:XML = <p></p>;
					p.appendChild(note);
					resultXML.appendChild(p);
					
				}
				
			}
			
			//adding spaces
			if ( resultXML.hasSimpleContent() ) resultXML.appendChild(<span></span>);
			
			//adding spaces in the descendants
			var descendants:XMLList = resultXML.descendants();
			
			var prevDesc:XML;
			
			for each (var desc:XML in descendants) {
				
				//if it is a false render
				if (desc.hasOwnProperty("@rend")) desc.appendChild(<span></span>);
				
			}
			
			return resultXML;
		}
		
		/**
		 * 
		 * 
		 */
		protected function processPb():void {
			
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
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
			
			for each (var element:XML in divs.children()) {										// [pb,head,p,note,div,label]
				
				switch (element.localName()) {
					
					case "head":
						resultXML.appendChild( processHeader(element) );
						break;
					
					case "p":
						resultXML.appendChild( processParagraph(element) );
						break;
					
					case "label":
						resultXML.appendChild( processLabel(element) );
						break;
					
				}
			}
			
		//trace (resultXML)
			
			return resultXML;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNotes():XML {
			return this.processNote();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getNotesAsTextFlow():TextFlow {
			var notesFlow:TextFlow = TextConverter.importToFlow(getNotes(), TextConverter.TEXT_FIELD_HTML_FORMAT);
			return notesFlow;
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
			
			if (!textFlow) this.getFlowConvertText();
			var refs:Array = textFlow.getElementsByTypeName("note_span");
			
			for each (var ref:FlowElement in refs) {
				
				var refLength:int = ref.getText().length//-1;
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

			var pos:Object = new Object();
			
			pos.start = textFlow.getElementByID(id).getAbsoluteStart();
			pos.end = pos.start + textFlow.getElementByID(id).getText().length;
			
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