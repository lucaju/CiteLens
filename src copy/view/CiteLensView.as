package view {
	
	//imports
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import controller.CiteLensController;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.CiteLensModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	import mvc.Observable;
	
	import view.bibliography.BibliographyView;
	import view.filter.FilterPanel;
	import view.mini.ColorColumn;
	import view.reader.Reader;
	
	public class CiteLensView extends AbstractView {
		
		//properties
		static public var citeLensController:CiteLensController										//controller
		
		//graphic layout slots
		private var header:Header;																	//Header
		private var filterPanel:FilterPanel;														//flter panel
		private var filterPanelArray:Array;															//Filter panel collection
		private var bibiographyView:BibliographyView;												//Bibliography List
		private var readerView:Reader;																//Reader
		private var miniNav:ColorColumn;															//Mini Nav
		
		/**
		 * Contructor
		 **/
		public function CiteLensView(c:IController) {
			
			super(c);
			
			//define controller
			citeLensController = CiteLensController(c);
			
		}
		
		/**
		 * Initialize
		 **/
		public function initialize():void {
			
			//add Header to the main view
			header = new Header();
			this.addChild(header);
			
			//add Bibliography list;
			bibiographyView = new BibliographyView();
			bibiographyView.x = 25;
			bibiographyView.y = 85;
			
			this.addChild(bibiographyView);
			bibiographyView.initialize();
			
			//filter panels
			filterPanelArray = new Array();
			var posX:Number = 225;
			var numFilterPanel:int = 3;
			
			//add filter panels
			for (var i:int = 1; i <= numFilterPanel; i++) {
				filterPanel = new FilterPanel(i);
				filterPanel.y = 85
				filterPanel.x = posX;
				
				this.addChild(filterPanel);
				
				filterPanel.init();
				
				filterPanelArray.push();
				
				posX += filterPanel.width + 10;
			}
			
			//add Reader;
			readerView = new Reader();
			readerView.y = 85
			readerView.x = 815;
			
			this.addChild(readerView);
			readerView.initialize();
			
			//add Mini Nav;
			miniNav = new ColorColumn();
			miniNav.y = 85
			miniNav.x = 1100;
			
			this.addChild(miniNav);
			miniNav.initialize();
		}
		
	}
}