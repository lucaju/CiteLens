package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import controller.CiteLensController;
	
	import model.CiteLensModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.columnViz.ColumnViz;
	
	import view.assets.EjectButton;
	import view.intro.ListDocuments;
	
	/**
	 * 
	 * @author lucianofrizzera
	 * 
	 */
	public class MainView extends AbstractView {
		
		//****************** Properties ****************** ****************** ******************
		
		protected var citeLensModel					:CiteLensModel;					//Model - CiteLens data
		protected var citeLensController			:CiteLensController;			//Controller - CiteLens Controller
		protected var citeLensView					:CiteLensView;					//View - CiteLens View
		
		protected var splash						:Splash;
		protected var list							:ListDocuments;
		
		protected var eject							:EjectButton;

		
		//****************** Constructor ****************** ****************** ******************

		/**
		 * 
		 * @param c
		 * 
		 */
		public function MainView(c:IController) {
			super(c);
		}
		
		
		//****************** INITIALIZE ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			loadDocList();
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function loadDocList():void {
			
			//splash
			splash = new Splash();
			this.addChild(splash);
			
			//list
			list = new ListDocuments();
			list.y = 430;
			this.addChild(list);
			
			list.addEventListener(Event.CHANGE, loadCiteLens);
			
		}
		
		
		/**
		 * 
		 * 
		 */
		protected function unloadDocList():void {
			
			list.hideItems();
			
			TweenMax.to(splash,1,{alpha:0,onComplete:this.removeChild,onCompleteParams:[splash]});
			TweenMax.to(list,1,{alpha:0,onComplete:this.removeChild,onCompleteParams:[list]});
			
			list.removeEventListener(Event.CHANGE, loadCiteLens);
			
			list = null;
			splash = null;
			
			ColumnViz.kill();
		}
		
		//****************** PROTECTED EVENTS ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		protected function loadCiteLens(event:Event):void {
			
			//eject
			eject = new EjectButton();
			eject.x = 25;
			eject.y = 20;
			this.addChild(eject);
			
			TweenMax.from(eject,1,{alpha:0});
			
			eject.addEventListener(MouseEvent.CLICK, ejectFunction);
			
			//Starting models
			citeLensModel = new CiteLensModel(list.selctedDoc);
			citeLensModel.addEventListener(Event.COMPLETE, _initCiteLens);
			
			//starting controler
			citeLensController = new CiteLensController([citeLensModel]);
			
			//Starting View
			citeLensView = new CiteLensView(citeLensController);
			this.addChild(citeLensView);
			
			unloadDocList();
			
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function ejectFunction(event:MouseEvent):void {
			loadDocList();
			
			this.removeChild(citeLensView);
			citeLensView = null;
			citeLensController = null;
			citeLensModel = null;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _initCiteLens(event:Event):void {
			citeLensModel.removeEventListener(Event.COMPLETE, _initCiteLens);
			citeLensView.initialize();
		}
	}
}