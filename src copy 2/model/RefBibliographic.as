package model {
	
	public class RefBibliographic {
		
		private var _id:int;
		private var _uniqueID:String;
		
		private var _titles:Array = new Array();
		private var _title:Object;
		private var _authors:Array = new Array();
		private var _author:Object;
		private var _editors:Array = new Array();
		private var _editor:Object;
		private var _authorship:String;
		private var _language:String;
		
		private var _publisher:String;
		
		private var _pubPlaces:Array = new Array();
		private var _pubPlace:String;
		
		private var _countries:Array = new Array();
		private var _country:String;
		
		private var _date:int;
		
		private var _series:Array = new Array();
		private var _serie:Object;
		private var _scope:String;
		
		private var _sourceRole:String;
		private var _type:String;
		
		private var _notes:Array = new Array();
		private var _note:Object;
		
		
		
		public function RefBibliographic(id:int) {
			_id = id;
		}
		
		public function get uniqueID():String {
			return _uniqueID;
		}

		public function set uniqueID(value:String):void {
			_uniqueID = value;
		}

		public function addTitle(name:String, level:String):void {
			_title = new Object();
			_title.id = _titles.length;
			_title.name = name;
			_title.level = level;
			
			_titles.push(_title);
			_title = null;
		}
		
		public function get titles():Array {
			return _titles;
		}
		
		public function get title():String {
			//return the higher level title
			var realTitle:String;
			var levels:Array = ["a","m","j","s","u"];
			var lvNumber:uint = 0;
			
			//if it has titles
			if(_titles.length > 0) {
				//does not have level
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
		
		public function addAuthor(last:String, first:String = null):void {
			_author = new Object();
			_author.id = _authors.length;
			_author.lastName = last;
			_author.firstName = first;
			
			_authors.push(_author);
			_author = null;
		}
		
		public function get authors():Array {
			return _authors;	
		}
		
		public function get fullAuthors():String {
			var fullAuth:String = "";
			for each (var auth:Object in _authors) {
				fullAuth += auth.lastName + ", " + auth.firstName + ", ";
			}
			return fullAuth;	
		}
		
		public function addEditor(last:String, first:String = null):void {
			_editor = new Object();
			_editor.id = _editors.length;
			_editor.lastName = last;
			_editor.firstName = first;
			
			_editors.push(_editor);
			_editor = null;
		}
		
		public function get editors():Array {
			return _editors;	
		}
		
		public function get fullEditors():String {
			var fullEditors:String = "";
			for each (var edit:Object in _editors) {
				fullEditors += edit.lastName + ", " + edit.firstName + ", ";
			}
			return fullEditors;	
		}
		
		public function getAuthorship(FirsNameLastName:Boolean = false):String {
			setFullAuthorship(FirsNameLastName);
			return _authorship;
		}
		
		public function setFullAuthorship(FirsNameLastName:Boolean):void {
			_authorship = "";
			
			if (_authors.length > 0) {																			//if there is any author
				
				for each(_author in _authors) {																	//authors loop
					
					if (FirsNameLastName) {
						
						if (_author.firstName) {																	//if there is first name
							_authorship += _author.firstName;
						}
						
						if (_author.lastName) {																		//if there is last name
							_authorship += " " + _author.lastName;
						}
						
						
					} else {
					
						if (_author.lastName) {																		//if there is last name
							_authorship += _author.lastName;
						}
						
						if (_author.lastName && _author.firstName) {												//add comma to separate last and firt name if there is last name
							_authorship += ", "
						}
						
						if (_author.firstName) {																	//if there is first name
							_authorship += _author.firstName;
						}						
					}
					
					if (_author.id < _authors.length-1) {														//add comma to separate authors if it is not the last one
						_authorship += ", ";	
					}
					
				}
			}
				
				//Editors 
			else if (_editors.length > 0) {																		//if there is any editor
				for each(_editor in _editors) {																	//editor loop										
					
					if (FirsNameLastName) {
						
						if (_editor.firstName) {														//if there is first name
							_authorship += _editor.firstName;
						}
						
						if (_editor.lastName) {
							_authorship += " " +_editor.lastName;
						}
						
					} else {
					
						if (_editor.lastName) {
							_authorship += _editor.lastName;
						}
						
						if (_editor.lastName && _editor.firstName) {						//add comma to separate last and firt name if there is last name
							_authorship += ", "
						}
						
						if (_editor.firstName) {														//if there is first name
							_authorship += _editor.firstName;
						}
						
					}
					
					if (_editor.id < _editors.length-1) {												//add comma to separate authors if it is not the last one
						_authorship += ", ";	
					}
				}
			}
				
				//No authorship
			else {																							//No authorship
				_authorship = " ";
			}
			
		}
		
		public function get language():String {
			return _language;
		}
		
		public function set language(value:String):void {
			_language = value;
		}
		
		public function get publisher():String {
			return _publisher;
		}
		
		public function set publisher(value:String):void {
			_publisher = value;
		}
		
		public function get pubPlaces():Array {
			return _pubPlaces;
		}
		
		public function addPubPlace(name:String):void {
			_pubPlaces.push(name);
		}
		
		public function get countries():Array {
			return _countries;
		}
		
		public function addCountry(name:String):void {
			_countries.push(name);
		}
		
		public function get date():int {
			return _date;
		}
		
		public function set date(value:int):void {
			_date = value;
		}
		
		public function addSerie(title:String, bibScopetype:String = null, bibScope:Number = 0):void {
			_serie = new Object();
			_serie.id = _series.length;
			_serie.title = title;
			_serie.type = bibScopetype;
			_serie.bibScope = bibScope;
			
			_series.push(_serie);
			_serie = null;
		}
		
		public function get series():Array {
			return _series;	
		}
		
		public function get scope():String {
			return _scope;
		}
		
		public function set scope(value:String):void {
			_scope = value;
		}
		
		public function get sourceRole():String
		{
			return _sourceRole;
		}

		public function set sourceRole(value:String):void
		{
			_sourceRole = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function addNote(noteID:int, reason:String, contentType:String, furtherReading:String):void {
			_note = new Object();
			_note.id = noteID;
			_note.reason = reason;
			_note.contentType = contentType;
			_note.furtherReading = furtherReading;
			
			_notes.push(_note);
			_note = null;
		}
		
		public function get notes():Array {
			return _notes;	
		}
		
	}
}