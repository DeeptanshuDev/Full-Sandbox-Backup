window.ratingStatus = (function(){
    var value = false; // private
 
    return { //public API
         
        setEdit: function() {
            value = true;
            return value;
        },
 
		resetEdit: function() {
            value = false;
            return value;
        },
		
        isEdit: function() {
            return value;
        }
         
    };
}());