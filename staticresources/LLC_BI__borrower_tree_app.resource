window.borrowerTreeApp = {};

(function (app){
	function App(){
		this.run = function(recordId, recordType, canvasId){
			app.canvasId = canvasId;
			var viewModel = new app.ViewModel(recordType, canvasId);

			app.viewModel = ko.mapping.fromJS(
					viewModel,
					app.contextMapping);

			ko.applyBindings(ko.validatedObservable(app.viewModel));
			viewModel.recurseChainRetrieve(viewModel[recordType], recordId, recordType);
			return this;
		};
	};
	app.App = App;
	function RelationshipSearchApp(){
		this.run = function(loanId){
			var viewModel = new app.ViewModel('RELATIONSHIP', '');
			app.viewModel = ko.mapping.fromJS(
					viewModel,
					app.contextMapping);

			app.viewModel.retrieveRecord(loanId, 'LOAN');
			ko.applyBindings(ko.validatedObservable(app.viewModel),
				document.getElementById('borrower-tree-search-account'));
			return this;
		};
	};
	app.RelationshipSearchApp = RelationshipSearchApp;
	function LoanSearchApp(){
		this.run = function(accountId){
			var viewModel = new app.ViewModel('LOAN', '');
			app.viewModel = ko.mapping.fromJS(
					viewModel,
					app.contextMapping);

			app.viewModel.retrieveRecord(accountId, 'RELATIONSHIP');
			ko.applyBindings(ko.validatedObservable(app.viewModel));
			return this;
		};
	};
	app.LoanSearchApp = LoanSearchApp;

	function RelationshipSearchAppFromPackage(){
		this.run = function(packageId){
			var viewModel = new app.ViewModel('RELATIONSHIP', '');
			app.viewModel = ko.mapping.fromJS(
					viewModel,
					app.contextMapping);
			app.viewModel.retrieveRecord(packageId, 'PRODUCTPACKAGE');
			ko.applyBindings(ko.validatedObservable(app.viewModel),
				document.getElementById('borrower-tree-search-account-pp'));
			return this;
		};
	};
	app.RelationshipSearchAppFromPackage = RelationshipSearchAppFromPackage;

	app.DefaultModelData = {
			recordId : null,
			name : '',
			isLoaded : false,
			isSaved : false,
			disabled: false,
			freeTextSearchField: ''
	};
	app.objMapping = {
		'LOAN' : function(rawData){
			return new Loan(rawData);
		},
		'RELATIONSHIP' :function(rawData){
			return new Relationship(rawData)
		},
		'BORROWER':function(rawData){
			return new Borrower(rawData);;
		},
		'GUARANTOR':function(rawData){
			return new Guarantor(rawData);
		},
		'INVOLVEMENT':function(rawData){
			return new Involvement(rawData);
		},
		'SIGNER' : function(rawData){
			return new Signer(rawData);
		},
		'CONTACT' :function(rawData){
			return new Contact(rawData);
		},
		'PRODUCTPACKAGE' :function(rawData){
			return new Package(rawData);
		}
	}
	app.contextMapping = {
		'LOAN' : {
			create: function(options){
				return new Loan(options.data);
			}
		},
		'RELATIONSHIP' : {
			create: function(options){
				return new Relationship(options.data);
			}
		},
		'BORROWER':{
			create: function (options){
				return new Borrower(options.data);
			}
		},
		'GUARANTOR':{
			create: function (options){
				return new Guarantor(options.data);
			}
		},
		'SIGNER' : {
			create: function (options){
				return new Signer(options.data);
			}
		},
		'CONTACT' : {
			create: function(options){
				return new Contact(options.data);
			}
		},
		'PRODUCTPACKAGE' :function(options){
			return new Package(options.data);
		}
	};
	app.mapping = {
		'LOAN' : {
			'relationship': {
				create: function (options){
					return new Relationship(options.data);
				}
			},
			'borrowers': {
				create: function (options){
					return new Borrower(options.data);
				}
			},
			'guarantors': {
				create: function (options){
					return new Guarantor(options.data);
				}
			},
			'productPackage': {
				create: function (options){
					return new Package(options.data);
				}
			},
		},
		'PRODUCTPACKAGE' : {
		},
		'RELATIONSHIP' : {
			'parent': {
				create: function (options){
					return new Relationship(options.data);
				}
			},
			'loans': {
				create: function (options){
					return new Loan(options.data);
				}
			},
			'contacts': {
				create: function (options){
					return new Contact(options.data);
				}
			},
			'involvements': {
				create: function (options){
					return new Involvement(options.data);
				}
			},
			'productPackage': {
				create: function (options){
					return new Package(options.data);
				}
			},
		},
		'INVOLVEMENT': {
			'loan': {
				create: function (options){
					return new Loan(options.data);
				}
			},
			'relationship': {
				create: function (options){
					return new Relationship(options.data);
				}
			},
			'signers': {
				create: function (options){
					return new Signer(options.data);
				}
			},
			'productPackage': {
				create: function (options){
					return new Package(options.data);
				}
			},
		},
		'SIGNER' : {
			'involvement': {
				create: function (options){
					if('BORROWER' == LifeCycle.BorrowerTree.typeMap[options.data.apexType]){
						return new Borrower(options.data);
					}
					return new Guarantor(options.data);
				}
			},
			'contact': {
				create: function (options){
					return new Contact(options.data);
				}
			}
		},
		'CONTACT' : {
			'relationship': {
				create: function (options){
					return new Relationship(options.data);
				}
			},
			'signings': {
				create: function (options){
					return new Signer(options.data);
				}
			}
		}
	}
	app.mapping.BORROWER = app.mapping.INVOLVEMENT;
	app.mapping.GUARATOR = app.mapping.INVOLVEMENT;

	// icons per: http://raphaeljs.com/icons/
	app.svgIcons = {
		dollar: 'M16,1.466C7.973,1.466,1.466,7.973,1.466,16c0,8.027,6.507,14.534,14.534,14.534c8.027,0,14.534-6.507,14.534-14.534C30.534,7.973,24.027,1.466,16,1.466z M17.255,23.88v2.047h-1.958v-2.024c-3.213-0.44-4.621-3.08-4.621-3.08l2.002-1.673c0,0,1.276,2.223,3.586,2.223c1.276,0,2.244-0.683,2.244-1.849c0-2.729-7.349-2.398-7.349-7.459c0-2.2,1.738-3.785,4.137-4.159V5.859h1.958v2.046c1.672,0.22,3.652,1.1,3.652,2.993v1.452h-2.596v-0.704c0-0.726-0.925-1.21-1.959-1.21c-1.32,0-2.288,0.66-2.288,1.584c0,2.794,7.349,2.112,7.349,7.415C21.413,21.614,19.785,23.506,17.255,23.88z',
		person: 'M21.021,16.349c-0.611-1.104-1.359-1.998-2.109-2.623c-0.875,0.641-1.941,1.031-3.103,1.031c-1.164,0-2.231-0.391-3.105-1.031c-0.75,0.625-1.498,1.519-2.111,2.623c-1.422,2.563-1.578,5.192-0.35,5.874c0.55,0.307,1.127,0.078,1.723-0.496c-0.105,0.582-0.166,1.213-0.166,1.873c0,2.932,1.139,5.307,2.543,5.307c0.846,0,1.265-0.865,1.466-2.189c0.201,1.324,0.62,2.189,1.463,2.189c1.406,0,2.545-2.375,2.545-5.307c0-0.66-0.061-1.291-0.168-1.873c0.598,0.574,1.174,0.803,1.725,0.496C22.602,21.541,22.443,18.912,21.021,16.349zM15.808,13.757c2.362,0,4.278-1.916,4.278-4.279s-1.916-4.279-4.278-4.279c-2.363,0-4.28,1.916-4.28,4.279S13.445,13.757,15.808,13.757z',
		relationship: 'M6.812,17.202l7.396-3.665v-2.164h-0.834c-0.414,0-0.808-0.084-1.167-0.237v1.159l-7.396,3.667v2.912h2V17.202zM26.561,18.875v-2.913l-7.396-3.666v-1.158c-0.358,0.152-0.753,0.236-1.166,0.236h-0.832l-0.001,2.164l7.396,3.666v1.672H26.561zM16.688,18.875v-7.501h-2v7.501H16.688zM27.875,19.875H23.25c-1.104,0-2,0.896-2,2V26.5c0,1.104,0.896,2,2,2h4.625c1.104,0,2-0.896,2-2v-4.625C29.875,20.771,28.979,19.875,27.875,19.875zM8.125,19.875H3.5c-1.104,0-2,0.896-2,2V26.5c0,1.104,0.896,2,2,2h4.625c1.104,0,2-0.896,2-2v-4.625C10.125,20.771,9.229,19.875,8.125,19.875zM13.375,10.375H18c1.104,0,2-0.896,2-2V3.75c0-1.104-0.896-2-2-2h-4.625c-1.104,0-2,0.896-2,2v4.625C11.375,9.479,12.271,10.375,13.375,10.375zM18,19.875h-4.625c-1.104,0-2,0.896-2,2V26.5c0,1.104,0.896,2,2,2H18c1.104,0,2-0.896,2-2v-4.625C20,20.771,19.104,19.875,18,19.875z',
		link: 'M16.45,18.085l-2.47,2.471c0.054,1.023-0.297,2.062-1.078,2.846c-1.465,1.459-3.837,1.459-5.302-0.002c-1.461-1.465-1.46-3.836-0.001-5.301c0.783-0.781,1.824-1.131,2.847-1.078l2.469-2.469c-2.463-1.057-5.425-0.586-7.438,1.426c-2.634,2.637-2.636,6.907,0,9.545c2.638,2.637,6.909,2.635,9.545,0l0.001,0.002C17.033,23.511,17.506,20.548,16.45,18.085zM14.552,12.915l2.467-2.469c-0.053-1.023,0.297-2.062,1.078-2.848C19.564,6.139,21.934,6.137,23.4,7.6c1.462,1.465,1.462,3.837,0,5.301c-0.783,0.783-1.822,1.132-2.846,1.079l-2.469,2.468c2.463,1.057,5.424,0.584,7.438-1.424c2.634-2.639,2.633-6.91,0-9.546c-2.639-2.636-6.91-2.637-9.545-0.001C13.967,7.489,13.495,10.451,14.552,12.915zM18.152,10.727l-7.424,7.426c-0.585,0.584-0.587,1.535,0,2.121c0.585,0.584,1.536,0.584,2.121-0.002l7.425-7.424c0.584-0.586,0.584-1.535,0-2.121C19.687,10.141,18.736,10.142,18.152,10.727z',
		envelope: 'M28.516,7.167H3.482l12.517,7.108L28.516,7.167zM16.74,17.303C16.51,17.434,16.255,17.5,16,17.5s-0.51-0.066-0.741-0.197L2.5,10.06v14.773h27V10.06L16.74,17.303z',
		outwards: 'M25.545,23.328,17.918,15.623,25.534,8.007,27.391,9.864,29.649,1.436,21.222,3.694,23.058,5.53,15.455,13.134,7.942,5.543,9.809,3.696,1.393,1.394,3.608,9.833,5.456,8.005,12.98,15.608,5.465,23.123,3.609,21.268,1.351,29.695,9.779,27.438,7.941,25.6,15.443,18.098,23.057,25.791,21.19,27.638,29.606,29.939,27.393,21.5z',
		inwards: 'M25.083,18.895l-8.428-2.259l2.258,8.428l1.838-1.837l7.053,7.053l2.476-2.476l-7.053-7.053L25.083,18.895zM5.542,11.731l8.428,2.258l-2.258-8.428L9.874,7.398L3.196,0.72L0.72,3.196l6.678,6.678L5.542,11.731zM7.589,20.935l-6.87,6.869l2.476,2.476l6.869-6.869l1.858,1.857l2.258-8.428l-8.428,2.258L7.589,20.935zM23.412,10.064l6.867-6.87l-2.476-2.476l-6.868,6.869l-1.856-1.856l-2.258,8.428l8.428-2.259L23.412,10.064z',
		piechart: 'M15.583,15.917l1.648-10.779C16.692,5.056,16.145,5,15.583,5C9.554,5,4.666,9.888,4.666,15.917c0,6.029,4.888,10.917,10.917,10.917S26.5,21.946,26.5,15.917c0-0.256-0.021-0.507-0.038-0.759L15.583,15.917zM19.437,3.127l-1.648,10.779l10.879-0.759C28.313,8.026,24.436,3.886,19.437,3.127z',
		chart: 'M3.625,25.062c-0.539-0.115-0.885-0.646-0.77-1.187l0,0L6.51,6.584l2.267,9.259l1.923-5.188l3.581,3.741l3.883-13.103l2.934,11.734l1.96-1.509l5.271,11.74c0.226,0.504,0,1.095-0.505,1.321l0,0c-0.505,0.227-1.096,0-1.322-0.504l0,0l-4.23-9.428l-2.374,1.826l-1.896-7.596l-2.783,9.393l-3.754-3.924L8.386,22.66l-1.731-7.083l-1.843,8.711c-0.101,0.472-0.515,0.794-0.979,0.794l0,0C3.765,25.083,3.695,25.076,3.625,25.062L3.625,25.062z',
		people: 'M21.053,20.8c-1.132-0.453-1.584-1.698-1.584-1.698s-0.51,0.282-0.51-0.51s0.51,0.51,1.02-2.548c0,0,1.414-0.397,1.132-3.68h-0.34c0,0,0.849-3.51,0-4.699c-0.85-1.189-1.189-1.981-3.058-2.548s-1.188-0.454-2.547-0.396c-1.359,0.057-2.492,0.792-2.492,1.188c0,0-0.849,0.057-1.188,0.397c-0.34,0.34-0.906,1.924-0.906,2.321s0.283,3.058,0.566,3.624l-0.337,0.113c-0.283,3.283,1.132,3.68,1.132,3.68c0.509,3.058,1.019,1.756,1.019,2.548s-0.51,0.51-0.51,0.51s-0.452,1.245-1.584,1.698c-1.132,0.452-7.416,2.886-7.927,3.396c-0.511,0.511-0.453,2.888-0.453,2.888h26.947c0,0,0.059-2.377-0.452-2.888C28.469,23.686,22.185,21.252,21.053,20.8zM8.583,20.628c-0.099-0.18-0.148-0.31-0.148-0.31s-0.432,0.239-0.432-0.432s0.432,0.432,0.864-2.159c0,0,1.199-0.336,0.959-3.119H9.538c0,0,0.143-0.591,0.237-1.334c-0.004-0.308,0.006-0.636,0.037-0.996l0.038-0.426c-0.021-0.492-0.107-0.939-0.312-1.226C8.818,9.619,8.53,8.947,6.947,8.467c-1.583-0.48-1.008-0.385-2.159-0.336C3.636,8.179,2.676,8.802,2.676,9.139c0,0-0.72,0.048-1.008,0.336c-0.271,0.271-0.705,1.462-0.757,1.885v0.281c0.047,0.653,0.258,2.449,0.469,2.872l-0.286,0.096c-0.239,2.783,0.959,3.119,0.959,3.119c0.432,2.591,0.864,1.488,0.864,2.159s-0.432,0.432-0.432,0.432s-0.383,1.057-1.343,1.439c-0.061,0.024-0.139,0.056-0.232,0.092v5.234h0.575c-0.029-1.278,0.077-2.927,0.746-3.594C2.587,23.135,3.754,22.551,8.583,20.628zM30.913,11.572c-0.04-0.378-0.127-0.715-0.292-0.946c-0.719-1.008-1.008-1.679-2.59-2.159c-1.584-0.48-1.008-0.385-2.16-0.336C24.72,8.179,23.76,8.802,23.76,9.139c0,0-0.719,0.048-1.008,0.336c-0.271,0.272-0.709,1.472-0.758,1.891h0.033l0.08,0.913c0.02,0.231,0.022,0.436,0.027,0.645c0.09,0.666,0.21,1.35,0.33,1.589l-0.286,0.096c-0.239,2.783,0.96,3.119,0.96,3.119c0.432,2.591,0.863,1.488,0.863,2.159s-0.432,0.432-0.432,0.432s-0.053,0.142-0.163,0.338c4.77,1.9,5.927,2.48,6.279,2.834c0.67,0.667,0.775,2.315,0.746,3.594h0.48v-5.306c-0.016-0.006-0.038-0.015-0.052-0.021c-0.959-0.383-1.343-1.439-1.343-1.439s-0.433,0.239-0.433-0.432s0.433,0.432,0.864-2.159c0,0,0.804-0.229,0.963-1.841v-1.227c-0.001-0.018-0.001-0.033-0.003-0.051h-0.289c0,0,0.215-0.89,0.292-1.861V11.572z'
	};

	app.blockUI = function(){
		return LifeCycle.blockUI ? LifeCycle.blockUI() : Utils.blockUI();
	};
	app.unblockUI = function(){
		return LifeCycle.unblockUI ? LifeCycle.unblockUI() : Utils.unblockUI();
	};

	app.performingAjax = ko.observable(false);
	jQuery(document).ajaxSend(function(event, request, settings) {
		app.performingAjax(true);
	});

	jQuery(document).ajaxComplete(function(event, request, settings) {
		app.performingAjax(false);
	});
	app.performingAjax.subscribe(function(newValue) {
		(newValue? app.blockUI : app.unblockUI)();
	});
	app.validate = function(model){
		if(model != null && model.validationModel){
			if(!model.validationModel.isValid()){
				var result = ko.validation.group(model.validationModel(), {deep: true});
				result.showAllMessages(true);
				model.disabled(!model.disabled());
				model.disabled(!model.disabled()); // this line repeated intentionally
				LifeCycle.BorrowerTree.debug('ERROR', 'validation error for: ' +model.name());
				LifeCycle.BorrowerTree.debugObject('ERROR', model);
				LifeCycle.BorrowerTree.debugObject('ERROR', result());
				throw 'Validation Errors!';
			}
		}
		return model;
	};
	app.mapFromJS = function(defaultData, mapping, instance){
		ko.mapping.fromJS(defaultData, mapping, instance);
		instance.isDisabled = ko.computed(function(){
			return (instance.validationModel && instance.validationModel.isValid() && instance.disabled()) ||
				(!instance.validationModel && instance.disabled());
		});
		return instance;
	};
	app.mapToJS = function(model){
		var mapping = app.mapping[LifeCycle.BorrowerTree.typeMap[model.apexType()]];
		var ignores = _.map(mapping, function(val, key){ return key; });
		var raw = ko.mapping.toJS(
				model,
				{'ignore': ignores});
		_.each(ignores, function(element, index){
			if(model[element]){
				if(model[element].apexType){
					raw[element] =
						ko.mapping.toJS(
								app.objMapping[LifeCycle.BorrowerTree.typeMap[model[element].apexType()]](
										{recordId: model[element].recordId()}));
				}
				else if(jQuery.isArray(model[element])){
					var arr = [];
					_.each(model[element](), function(element, index){
						arr[index] = app.mapToJS(element);
					});
					raw[element] = arr;
				}
			}
		});
		return raw;
	}
	app.errorMsg = ko.observable('');
})(window.borrowerTreeApp);