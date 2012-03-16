package pipwerks
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class ScormComm 
	{
		private var _scormConnected:Boolean;
		private var scorm:SCORM;
		
		
		public static const LESSONSTATUS_PASSED:String = "passed";		
		public static const LESSONSTATUS_COMPLETED:String = "completed";
		public static const LESSONSTATUS_FAILED:String = "failed";
		public static const LESSONSTATUS_INCOMPLETE:String = "incomplete";
		public static const LESSONSTATUS_BROWSED:String = "browsed";
		public static const LESSONSTATUS_NOTATTEMPTED:String = "not attempted";		
		
		
		public function ScormComm() 
		{			
			if (ExternalInterface.available) scorm = new SCORM();
			}
			
		/**
		 * This is the current student status as determined by the LMS. Six status values are allowed.
		 * @param	status - a String as indicated in LESSONSTATUS_* constants;
		 */
		public function setLessonStatus(status:String) {
			scorm.set("cmi.core.lesson_status", status)
		}
		
		/**
		 * * This is the current student status as determined by the LMS. 
		 * @return Six status values are allowed. See LESSONSTATUS_* constants;
		 */
		public function getLessonStatus():String {
			return scorm.get("cmi.core.lesson_status")
		}		


		
		
		/**
		 * This is the amount of time in hours, minutes and seconds that the student has spent in the SCO at the time they leave it. That is, this represents the time from beginning of the session to the end of a single use of the SCO.
		 */
		public function getSessionTime():String {			
			return scorm.get("cmi.core.session_time")
		}
		
		/**
		 * Returns the official name used for the student on the course roster maintained by the LMS. This is the complete name, not just the first name, in the format lastName, firstName middleInitial, e.g. Doe, John A.
		 * @return the student's name
		 */
		public function getStudentName():String {
			return scorm.get("cmi.core.student_name");
		}

		public function getStudentId():String {
			return scorm.get("cmi.core.student_id");
		}		

		/**
		 * This is the total accumulated time of all the student's sessions in this SCO. It is used to keep track of the total time spent in every session of this SCO for this student. The LMS should initialize this to a default value the first time the SCO is launched and then use the SCO reported values to cmi.core.session_time to keep a running total.
		 */
		public function getTotalTime():String  {			
			return scorm.get("cmi.core.total_time")
		}
		
		
		
		/**
		 * This corresponds to the SCO exit point passed to the LMS the last time the student visited this SCO. This provides a mechanism to let the student return to the SCO at the same place they left earlier. In other words, this element can identify the student's exit point and that point can be used by the SCO as an entry point the next time the student returns to this SCO.
		 * @param   location - Max 255 chars
		 */
		public function setLessonLocation(location:String):void {
			scorm.set("cmi.core.lesson_location", location)
		}		
		
		/**
		 * This provides an indication of the performance of the student during his last attempt on the SCO. This score may be determined and calculated in any manner that makes sense to the SCO designer. For instance, it could reflect the percentage of objectives complete, it could be the raw score on a multiple choice test, or it could indicate the number of correct first responses to embedded questions in a SCO.
		 * @param	score A number representing the student's score
		 */
		public function setScore(score:Number):void {
			scorm.set("cmi.core.score.raw", score.toString())			
		}
		
		/**
		 * This provides an indication of the performance of the student during his last attempt on the SCO. This score may be determined and calculated in any manner that makes sense to the SCO designer. For instance, it could reflect the percentage of objectives complete, it could be the raw score on a multiple choice test, or it could indicate the number of correct first responses to embedded questions in a SCO.
		 * @return
		 */
		public function getScore():Number {
			return Number(scorm.get("cmi.core.score.raw"))
		}		
		
		/**
		 * Saves memento as JSON string in SCO
		 * @param	obj Any Object instance, but not an extended Object
		 */
		public function saveState(obj:Object):void {
			var json:JSONEncoder = new JSONEncoder(obj);
			var str:String = json.getString();
			
			
			
		}
		
		public function loadState():Object {			
			var obj:Object = null;
			var str:String = scorm.get("cmi.suspend_data");
			try {
				var dec:JSONDecoder = new JSONDecoder(str);
				obj = dec.getValue();
			} catch (e:Error) {
				
			}
			return obj;
		}		
		
		/**
		 * Connects to LMS
		 */
		public function connectScorm():void {
			if (!ExternalInterface.available) return;
			_scormConnected = scorm.connect();
		}
		

	
		/**
		 * Disconnects from LMS;
		 */
		public function disconnectScorm() {
			if (scormConnected) scorm.disconnect();
		}
		
		
		/**
		 * Returns true if scorm is connected to LMS
		 */
		public function get scormConnected():Boolean 
		{
			return _scormConnected;
		}
		



	}
	
}