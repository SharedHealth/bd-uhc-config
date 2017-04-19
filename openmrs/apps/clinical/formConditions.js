var validateDateRange = function(date, conditions) {
	var startLimit = new Date(1800,0,1);
	var endLimit = new Date(2100,11,31);
	var d = Date.parse(date);
    if(d < startLimit || d > endLimit) {
        conditions.error = "Enter a valid date";
    }
    return conditions;
}

Bahmni.ConceptSet.FormConditions.rules = {
    'Procedure End Date' : function (formName, formFieldValues) {
                var conditions = {};
                var start = formFieldValues['Procedure Start Date'];
                var end = formFieldValues['Procedure End Date'];
    			if(end && start){
    		        if (start > end) {
                        conditions.error = "Start date should be before end date";
                        return conditions;
                    }
                }
                if(end){
                    if(!start)
                    conditions.error = "Please enter start date.";
                    return conditions;
                }
                validateDateRange(end, conditions);
                return conditions;
            },
    'Procedure Start Date' : function (formName, formFieldValues) {
                var conditions = {};
                var start = formFieldValues['Procedure Start Date'];
                var end = formFieldValues['Procedure End Date'];
                if(end && start){
                    if (start > end) {
                        conditions.error = "Start date should be before end date";
                        return conditions;
                    }
                }
                if (!start) {
                    if(end) {
                        conditions.error = "Start date should be before end date";
                        return conditions;
                    }
                }
                validateDateRange(start, conditions);
                return conditions;
            },
    'Follow up date' : function (formName, formFieldValues) {
                var conditions = {};
                var followUpDate = formFieldValues['Follow up date'];
                conditions = validateDateRange(followUpDate, conditions);
                var today = new Date();
	            var d = Date.parse(followUpDate);
                if( d <= today) {
                   conditions.error = "Followup date must be a future date";
                }
                return conditions;
             },

};