﻿component{
	// Configure ColdBox Application
	function configure(){
		// coldbox directives
		coldbox = {
			// Application Setup
			appName : "Module Tester",
			// Development Settings
			reinitPassword : "",
			handlersIndexAutoReload : true,
			modulesExternalLocation : [],
			// Implicit Events
			defaultEvent : "",
			requestStartHandler : "",
			requestEndHandler : "",
			applicationStartHandler : "",
			applicationEndHandler : "",
			sessionStartHandler : "",
			sessionEndHandler : "",
			missingTemplateHandler : "",
			// Error/Exception Handling
			exceptionHandler : "",
			onInvalidEvent : "",
			customErrorTemplate : "/coldbox/system/includes/BugReport.cfm",
			// Application Aspects
			handlerCaching : false,
			eventCaching : false
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = { development : "localhost,127\.0\.0\.1" };

		// Module Directives
		modules = {
			// An array of modules names to load, empty means all of them
			include : [],
			// An array of modules names to NOT load, empty means none
			exclude : []
		};

		// Register interceptors as an array, we need order
		interceptors = [
			// SES
			{ class : "coldbox.system.interceptors.SES" }
		];

		// LogBox DSL
		logBox = {
			// Define Appenders
			appenders : {
				files : {
					class : "coldbox.system.logging.appenders.RollingFileAppender",
					properties : { filename : "tester", filePath : "/#appMapping#/logs" }
				},
				console : {
					class : "coldbox.system.logging.appenders.ConsoleAppender"
				}
			},
			// Root Logger
			root : { levelmax : "DEBUG", appenders : "*" },
			// Implicit Level Categories
			info : [ "coldbox.system" ]
		};

		// Module Settings
		moduleSettings = {
			// CB Security
			cbSecurity : {
				// Global Relocation when an invalid access is detected, instead of each rule declaring one.
				"invalidAccessRedirect" 		: "main.index",
				// Global override event when an invalid access is detected, instead of each rule declaring one.
				"invalidAccessOverrideEvent"	: "main.index",
				// Default invalid action: override or redirect when an invalid access is detected, default is to redirect
				"defaultInvalidAction"			: "redirect",
				// The global security rules
				"rules" 						: [
					// should use direct action and do a global redirect
					{
						"whitelist": "",
						"securelist": "admin",
						"match": "event",
						"roles": "admin",
						"permissions": "",
						"action" : "redirect"
					},
					// no action, use global default action
					{
						"whitelist": "",
						"securelist": "noAction",
						"match": "url",
						"roles": "admin",
						"permissions": ""
					},
					// Using overrideEvent only, so use an explicit override
					{
						"securelist": "ruleActionOverride",
						"match": "url",
						"overrideEvent": "main.login"
					},
					// direct action, use global override
					{
						"whitelist": "",
						"securelist": "override",
						"match": "url",
						"roles": "",
						"permissions": "",
						"action" : "override"
					},
					// Using redirect only, so use an explicit redirect
					{
						"securelist": "ruleActionRedirect",
						"match": "url",
						"redirect": "main.login"
					}
				]
			}
		};
	}

	/**
	 * Load the Module you are testing
	 */
	function afterAspectsLoad( event, interceptData, rc, prc ){
		controller
			.getModuleService()
			.registerAndActivateModule( moduleName = request.MODULE_NAME, invocationPath = "moduleroot" );
	}
}
