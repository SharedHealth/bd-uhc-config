var getLunhAlgorithmSum = function(healthId) {
	var lunhAlgorithmSum = 0,
		currentDigit = 0,
		isEvenIndexFromLast = false;

	for (var n = healthId.length - 1; n >= 1; n--) {
		var cDigit = healthId.charAt(n),
			currentDigit = parseInt(cDigit, 10);

		if (isEvenIndexFromLast) {
			if ((currentDigit *= 2) > 9) currentDigit -= 9;
		}

		lunhAlgorithmSum += currentDigit;
		isEvenIndexFromLast = !isEvenIndexFromLast;
	}
	return lunhAlgorithmSum;
}

var containFourConsecutiveDigits = function(healthId) {
	var healthIdToCheck = healthId.slice(0, healthId.length - 1);
	return healthIdToCheck.match(/([0-9])\1\1\1/);
}

var containTwoSetsOfThreeConsecutiveDigits = function(healthId) {
	var healthIdToCheck = healthId.slice(0, healthId.length - 1);
	var matches = healthIdToCheck.match(/([0-9])\1\1/g);
	return matches && matches.length > 1;
}

Bahmni.Registration.customValidator = {
	"healthId": {
		method: function(name, value, attributeDetails) {
			if (containFourConsecutiveDigits(value)) {
				return false;
			}
			if (containTwoSetsOfThreeConsecutiveDigits(value)) {
				return false
			}
			return (getLunhAlgorithmSum(value) % 10) == 0;
		},
		errorMessage: "Please Enter Valid HID."
	}
};