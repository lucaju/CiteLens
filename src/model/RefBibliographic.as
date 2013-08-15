package model {
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class RefBibliographic {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var _id					:int;
		protected var _uniqueID				:String;
		
		protected var _titles				:Array = new Array();
		protected var _title				:Object;
		protected var _authors				:Array = new Array();
		protected var _author				:Object;
		protected var _editors				:Array = new Array();
		protected var _editor				:Object;
		protected var _authorship			:String;
		protected var _language				:String;
		
		protected var _publisher			:String;
		
		protected var _pubPlaces			:Array = new Array();
		protected var _pubPlace				:String;
		
		protected var _countries			:Array = new Array();
		protected var _country				:String;
		
		protected var _date					:int;
		
		protected var _series				:Array = new Array();
		protected var _serie				:Object;
		protected var _scope				:String;
		
		protected var _sourceRole			:String;
		protected var _type					:String;
		
		protected var _notes				:Array = new Array();
		protected var _note					:Object;
		
		
		//****************** Constructor ****************** ****************** ******************
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function RefBibliographic(id:int) {
			_id = id;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get uniqueID():String {
			return _uniqueID;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set uniqueID(value:String):void {
			_uniqueID = value;
		}

		/**
		 * 
		 * @param name
		 * @param level
		 * 
		 */
		public function addTitle(name:String, level:String):void {
			_title = new Object();
			_title.id = _titles.length;
			_title.name = name;
			_title.level = level;
			
			_titles.push(_title);
			_title = null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get titles():Array {
			return _titles;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			
			//return the higher level title
			var realTitle:String;
			var levels:Array = ["a","m","j","s","u"];
			var lvNumber:uint = 0;
			
			//if it has titles
			if(_titles.length > 0) {
				//it does not has level
				if (!_titles[i].level) {
					realTitle = _titles[i].name;
					
				} else {
					//for (var i:int = 0; i < _titles.length; i++) {
					var i:int = 0;
					while(i < _titles.length) {
						
						//test for the highest level
						
						if (_titles[i].level == levels[lvNumber]) {
							realTitle = _titles[i].name;
							break;
						}
						
						//if there isn't any, lower the level
						if(i == _titles.length-1 && lvNumber < levels.length) {
							i = -1;
							lvNumber++;
						}
						//if there isn't any in the lowest level
						else if (i == _titles.length-1 && lvNumber == levels.length-1) {
							realTitle = "No title found";
						}
						
						i++;
					}
					
				}
			} else {
				realTitle = "No title found";
			}
			
			return realTitle;
		}
		
		/**
		 * 
		 * @param last
		 * @param first
		 * 
		 */
		public function addAuthor(last:String, first:String = null):void {
			_author = new Object();
			_author.id = _authors.length;
			_author.lastName = last;
			_author.firstName = first;
			
			_authors.push(_author);
			_author = null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get authors():Array {
			return _authors;	
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get fullAuthors():String {
			var fullAuth:String = "";
			for each (var auth:Object in _authors) {
				fullAuth += auth.lastName + ", " + auth.firstName + ", ";
			}
			return fullAuth;	
		}
		
		/**
		 * 
		 * @param last
		 * @param first
		 * 
		 */
		public function addEditor(last:String, first:String = null):void {
			_editor = new Object();
			_editor.id = _editors.length;
			_editor.lastName = last;
			_editor.firstName = first;
			
			_editors.push(_editor);
			_editor = null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get editors():Array {
			return _editors;	
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get fullEditors():String {
			var fullEditors:String = "";
			for each (var edit:Object in _editors) {
				fullEditors += edit.lastName + ", " + edit.firstName + ", ";
			}
			return fullEditors;	
		}
		
		/**
		 * 
		 * @param FirsNameLastName
		 * @return 
		 * 
		 */
		public function getAuthorship(FirsNameLastName:Boolean = false):String {
			setFullAuthorship(FirsNameLastName);
			return _authorship;
		}
		
		/**
		 * 
		 * @param FirsNameLastName
		 * 
		 */
		public function setFullAuthorship(FirsNameLastName:Boolean):void {
			_authorship = "";
			
			if (_authors.length > 0) {																			//if there is any author
				
				for each(_author in _authors) {																	//authors loop
					
					if (FirsNameLastName) {						
						if (_author.firstName) _authorship += _author.firstName;								//if there is first name					
						if (_author.lastName) _authorship += " " + _author.lastName;							//if there is last name
							
						
					} else {
					
						if (_author.lastName) _authorship += _author.lastName;									//if there is last name	
						if (_author.lastName && _author.firstName) _authorship += ", ";							//add comma to separate last and firt name if there is last name
						if (_author.firstName) _authorship += _author.firstName;								//if there is first name
												
					}
					
					if (_author.id < _authors.length-1) _authorship += ", ";									//add comma to separate authors if it is not the last one
					
				}
			}
				
				//Editors 
			else if (_editors.length > 0) {																		//if there is any editor
				for each(_editor in _editors) {																	//editor loop										
					
					if (FirsNameLastName) {
						
						if (_editor.firstName) _authorship += _editor.firstName;								//if there is first name
						if (_editor.lastName) _authorship += " " +_editor.lastName;
									
					} else {
					
						if (_editor.lastName) _authorship += _editor.lastName;
						if (_editor.lastName && _editor.firstName) _authorship += ", ";							//add comma to separate last and firt name if there is last name
						if (_editor.firstName) _authorship += _editor.firstName;								//if there is first name
						
					}
					
					if (_editor.id < _editors.length-1) _authorship += ", ";									//add comma to separate authors if it is not the last one
						
				}
			}
				
				//No authorship
			else {																							//No authorship
				_authorship = " ";
			}
			
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get language():String {
			return _language;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set language(value:String):void {
			_language = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get publisher():String {
			return _publisher;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set publisher(value:String):void {
			_publisher = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get pubPlaces():Array {
			return _pubPlaces;
		}
		
		/**
		 * 
		 * @param name
		 * 
		 */
		public function addPubPlace(name:String):void {
			_pubPlaces.push(name);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get countries():Array {
			return _countries;
		}
		
		/**
		 * 
		 * @param name
		 * 
		 */
		public function addCountry(name:String):void {
			_countries.push(name);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get date():int {
			return _date;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set date(value:int):void {
			_date = value;
		}
		
		/**
		 * 
		 * @param title
		 * @param bibScopetype
		 * @param bibScope
		 * 
		 */
		public function addSerie(title:String, bibScopetype:String = null, bibScope:Number = 0):void {
			_serie = new Object();
			_serie.id = _series.length;
			_serie.title = title;
			_serie.type = bibScopetype;
			_serie.bibScope = bibScope;
			
			_series.push(_serie);
			_serie = null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get series():Array {
			return _series;	
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get scope():String {
			return _scope;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set scope(value:String):void {
			_scope = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get sourceRole():String {
			return _sourceRole;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set sourceRole(value:String):void {
			_sourceRole = value;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get type():String {
			return _type;
		}

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set type(value:String):void {
			_type = value;
		}

		/**
		 * 
		 * @param noteID
		 * @param UniqueID
		 * @param reason
		 * @param contentType
		 * @param furtherReading
		 * 
		 */
		public function addNote(noteID:int, UniqueID:String, reason:String, contentType:String, furtherReading:String):void {
			_note = new Object();
			_note.id = noteID;
			_note.UniqueID = noteID;
			_note.reason = reason;
			_note.contentType = contentType;
			_note.furtherReading = furtherReading;
			
			_notes.push(_note);
			_note = null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get notes():Array {
			return _notes;	
		}

	}
}