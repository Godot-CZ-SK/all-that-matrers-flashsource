package Playtomic
{
   final class LogRequest
   {
      
      private static var Pool:Array = new Array();
       
      
      private var _data:String = "";
      
      private var _hasView:Boolean = false;
      
      private var _hasPlay:Boolean = false;
      
      var ready:Boolean = false;
      
      function LogRequest()
      {
         super();
      }
      
      static function Create() : LogRequest
      {
         var request:LogRequest = Pool.length > 0 ? Pool.pop() as LogRequest : new LogRequest();
         request._data = "";
         request._hasView = false;
         request._hasPlay = false;
         request.ready = false;
         return request;
      }
      
      function MassQueue(data:Array) : void
      {
         var request:LogRequest = null;
         for(var i:int = data.length - 1; i > -1; i--)
         {
            this.Queue(data[i]);
            data.splice(i,1);
            if(this.ready)
            {
               this.Send();
               request = Create();
               request.MassQueue(data);
               return;
            }
         }
         Log.LogQueue = this;
      }
      
      function Queue(data:String) : void
      {
         this._data += (this._data == "" ? "" : "~") + data;
         if(this._data.indexOf("v/") == 0)
         {
            this._hasView = true;
         }
         if(this._data.indexOf("p/") == 0)
         {
            this._hasPlay = true;
         }
         if(this._data.length > 300)
         {
            this.ready = true;
         }
      }
      
      public function Send() : void
      {
         if(this._data == "")
         {
            return;
         }
         Request.SendStatistics(this.Complete,"/tracker/q.aspx?q=" + this._data + "&url=" + (!!this._hasView ? Log.SourceUrl : Log.BaseUrl));
      }
      
      private function Complete(success:Boolean) : void
      {
         if(success)
         {
            if(this._hasView)
            {
               Log.IncreaseViews();
            }
            if(this._hasPlay)
            {
               Log.IncreasePlays();
            }
         }
         Pool.push(this);
      }
   }
}
