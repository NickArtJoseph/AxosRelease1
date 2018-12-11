angular.module('app')
	.controller('loanAutoDecisionScorecardController', ['$scope', 'dataService', '$window', 'messageService',
		function($scope, dataService, $window, messageService) {
			"use strict";
			var vm = this;
			vm.window = $window;
			vm.scorecard = null;
			vm.loanId = null;
			vm.namespacePrefix = '';
			vm.selectedAccount = null;
			vm.borrowerAccount = 'Borrower Account';
			vm.tabType = 'loan';
			vm.loanInformation = null;
			vm.accounts = [];
			vm.policyExceptions = null;
			vm.isRetailLoan = null;
			vm.performAction = performAction;
			vm.init = init;
			vm.getScorecardDetails = getScorecardDetails;
			vm.customFieldName = customFieldName;
			vm.hasOverallPointInformation = hasOverallPointInformation;
			vm.clickTab = clickTab;
			vm.redirectToCreditReport = redirectToCreditReport;
			vm.isMultiCurrency = isMultiCurrency;

			function init(loanId, scorecardId, scorecardObjectName) {
				vm.loanId = loanId;
				if (scorecardObjectName.indexOf('__') > 0) {
					vm.namespacePrefix = scorecardObjectName.substring(0,scorecardObjectName.indexOf('__')+2);
				}
				clickTab(null);
				loadScorecard(scorecardId);
			}

			function loadScorecard(scorecardId) {
				dataService.getScorecard(scorecardId).then(
					function(response) {
						vm.scorecard = response;
						vm.isRetailLoan = isRetailLoan(response);
						drawOverviewChart();
					},
					errorHandler
				);
				dataService.getLoanInformation(scorecardId).then(
					function(response) {
						vm.loanInformation = response;
						vm.borrowerAccount = vm.loanInformation[vm.namespacePrefix + 'Account__r'];
						vm.accounts = [];
						if (vm.borrowerAccount != null) {
							vm.accounts.push(vm.borrowerAccount);
						}
						var entities = vm.loanInformation[vm.namespacePrefix + 'Legal_Entities__r'];
						if (entities != null) {
							for (var cnt = 0; cnt < entities.length; cnt++) {
								if (vm.borrowerAccount == undefined || entities[cnt][vm.namespacePrefix + 'Account__r'].Id != vm.borrowerAccount.Id) {
									vm.accounts.push(entities[cnt][vm.namespacePrefix + 'Account__r']);
								}
								if (vm.borrowerAccount == null) {
									if (entities[cnt][vm.namespacePrefix + 'Borrower_Type__c'] == 'Borrower') {
										vm.borrowerAccount = entities[cnt];
									}
								}
							}
						}
						vm.policyExceptions = vm.loanInformation[vm.namespacePrefix+'Policy_Exceptions__r'];
						if(vm.policyExceptions == null)
							vm.policyExceptions = [];

						clickTab(null);
					},
					errorHandler
				);
			}

			function isMultiCurrency() {
				return vm.loanInformation !== null && vm.loanInformation['CurrencyIsoCode'] !== undefined;
			}

			function isRetailLoan(response){
				if (response[vm.namespacePrefix+'Loan__r'] != null) {
					return response[vm.namespacePrefix+'Loan__r'][vm.customFieldName('Product_Line')] == 'Consumer';
				}
				return null;
			}

			function getScorecardDetails() {
				if (vm.scorecard != null) {
					return vm.scorecard[vm.namespacePrefix+'Scorecard_Details__r'];
				}
				return [];
			}

			function clickTab(account) {
				vm.selectedAccount = account;
				if (account == null) {
					vm.tabType = 'loan';
					vm.selectedAccount = vm.borrowerAccount;
				}
				else {
					vm.tabType = 'account';
					vm.selectedAccount = account;
				}
			}

			function performAction(action) {
				var href = vm.window.location.pathname +
					'?app=' + action +
					'&id='+vm.loanId;
				if (vm.window.location.search != undefined &&
					vm.window.location.search != null &&
					vm.window.location.search.indexOf('inline=1') > 0) {
					href += '&inline=1';
				}
				vm.window.location.href = href;
			}

			function hasOverallPointInformation() {
				return vm.scorecard != null &&
					vm.scorecard[vm.customFieldName('Assigned_Points')] !== null &&
					vm.scorecard[vm.customFieldName('Assigned_Points')] !== undefined &&
					vm.scorecard[vm.customFieldName('Maximum_Points')] !== null &&
					vm.scorecard[vm.customFieldName('Maximum_Points')] !== undefined;
			}

			function drawOverviewChart(assignedPoints, maximumPoints) {
				google.charts.load('current', {packages:['corechart']});
				google.charts.setOnLoadCallback(drawChart);
				function drawChart() {
					var data = google.visualization.arrayToDataTable([
					  ['Category','Points'],
					  ['Assigned',vm.scorecard[vm.customFieldName('Assigned_Points')]],
					  ['Unassigned',vm.scorecard[vm.customFieldName('Maximum_Points')]-vm.scorecard[vm.customFieldName('Assigned_Points')]]
					]);

					var options = {
					  pieHole: 0.8,
					  enableInteractivity: false,
					  tooltip: {trigger: 'none'},
					  legend: {position: 'none'},
					  pieSliceText: 'none',
					  pieStartAngle: 270-(180*vm.scorecard[vm.customFieldName('Assigned_Points')]/vm.scorecard[vm.customFieldName('Maximum_Points')]),
					  colors:['06b264','CFD7E6'],
					  chartArea:{left:0,top:0,width:'100%',height:'100%'}
					};

					var chart = new google.visualization.PieChart(document.getElementById('decisionOverviewPointsChart'));
					chart.draw(data, options);
				}
			}

			function redirectToCreditReport() {
				vm.window.location.href =
					'/' + vm.selectedAccount[vm.customFieldName('FICO_Credit_Report')]
			}

			function customFieldName(fieldName) {
				return vm.namespacePrefix + fieldName + '__c';
			}

			function errorHandler(error) {
				LifeCycle.unblockUI();
				messageService.setMessage({type: messageService.messageTypes.error, text: error }, true);
			}
}])
.filter('fieldset', function($filter) {
	return function(value, type) {
		if (value == null || value == undefined) {
			value = '\u00A0';
		}
		if (type == 'datetime' || type == 'date') {
			return $filter('date')(value, 'mediumDate', '+0000');
		}
		if (type == 'currency') {
			return $filter('currency')(value, '$');
		}
		if (type == 'percent') {
			return $filter('number')(value, '3')+'%';
		}
		if (type == 'boolean') {

			return String(value).charAt(0).toUpperCase() + String(value).slice(1);
		}
		return value;
	}
})
.directive('ndsValue', function(){
	return {
		restrict: 'A',
	scope: {
		ndsValue: '='
	},
	link: function(scope, element){
		element.bind('valueChange', function(event){
			scope.$apply(function(){
					scope.ndsValue = event.originalEvent ? event.originalEvent.detail : event.detail;
				});
			});
		}
	}
})
.directive('ndsProps', function(){
	return {
		link: function(scope, element, attrs){
			scope.$watchCollection(attrs.ndsProps, function(newValues){
				for (var key in newValues) {
					element[0][key] = newValues[key];
				}
			});
		}
	}
});