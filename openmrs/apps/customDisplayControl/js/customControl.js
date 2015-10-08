'use strict';

angular.module('bahmni.common.displaycontrol.custom')
    .directive('birthCertificate', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
            var link = function ($scope) {
                console.log("inside birth certificate");
                var conceptNames = ["HEIGHT"];
                $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/birthCertificate.html";
                spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "latest", undefined, $scope.visitUuid, undefined).then(function (response) {
                    $scope.observations = response.data;
                }));
            };

            return {
                restrict: 'E',
                template: '<ng-include src="contentUrl"/>',
                link: link
            }
    }]).directive('deathCertificate', ['$q','visitService', 'bedService','appService', 'spinner', function ($q, visitService, bedService,appService, spinner) 
    {
        var link = function ($scope) 
        {
            var conceptNames = ["BMI"];
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/deathCertificate.html";
            
            spinner.forPromise($q.all([bedService.getAssignedBedForPatient($scope.patient.uuid),visitService.getVisitSummary($scope.visitUuid)]).then(function(results){
                    $scope.bedDetails = results[0];
                    $scope.visitSummary = results[1].data;
                }));
                
        };
        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>'
        }
    }]).directive('deathFooter', ['visitService','appService', 'spinner', function (visitService,appService, spinner) 
    {
       var link = function ($scope) 
        {
            var conceptNames = ["BMI"];
            
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/deathFooter.html";
            $scope.curDate=new Date();
        };

        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>',
        }
    }]).directive('dischargeSummary', ['$q','visitService', 'bedService','appService', 'spinner', function ($q, visitService, bedService,appService, spinner) 
    {
        var link = function ($scope) 
        {
            var conceptNames = ["BMI"];
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/dischargeSummary.html";
            
            spinner.forPromise($q.all([bedService.getAssignedBedForPatient($scope.patient.uuid),visitService.getVisitSummary($scope.visitUuid)]).then(function(results){
                    $scope.bedDetails = results[0];
                    $scope.visitSummary = results[1].data;
                }));
                
        };

        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>',
        }
    }]).directive('footerSummary', ['visitService','appService', 'spinner', function (visitService,appService, spinner) 
    {
       var link = function ($scope) 
        {
            var conceptNames = ["BMI"];
            
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/footerSummary.html";
                spinner.forPromise(visitService.getVisitSummary($scope.visitUuid).then(function(results){
					$scope.visitSummary = results.data;
                }));
        };

        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>',
        }
    }]).directive('prescriptionFooter', ['visitService','appService', 'spinner', function (visitService,appService, spinner) 
    {
       var link = function ($scope) 
        {
            var conceptNames = ["BMI"];
            
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/prescription.html";
            $scope.curDate=new Date();
        };

        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>',
        }
    }]);