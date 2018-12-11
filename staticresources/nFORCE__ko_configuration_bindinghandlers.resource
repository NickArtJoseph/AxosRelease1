(function() {
	ko.bindingHandlers.configureMetadata = {
		init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
			ko.bindingHandlers.visible.update(element, ko.observable(false));
			ko.bindingHandlers.attr.update(element, ko.observable({ href: '' }));
		},
		update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
			var destination = ko.unwrap(valueAccessor().destination);
			var parameters = ko.unwrap(valueAccessor().parameters);

			for (i = 0; i < parameters.length; i++) {
				parameters[i] = ko.unwrap(parameters[i]);
			}

			parameters.unshift(ko.unwrap(valueAccessor().endpoint));

			parameters.push(function(result, event) {
				if (event.status && result != null) {
					ko.bindingHandlers.attr.update(element, ko.observable({
						href: destination.replace('{identifier}', result)
					}));
					ko.bindingHandlers.visible.update(element, ko.observable(true));
				}
			});

			Visualforce.remoting.Manager.invokeAction.apply(Visualforce.remoting.Manager, parameters);
		}
	};
}())