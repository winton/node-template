var exec = require('child_process').exec,
	fs = require('fs');

desc('Install dependencies.');
task('install', function (params) {
	jake.Task['install:node'].invoke();
	jake.Task['install:ruby'].invoke();
});

namespace('install', function() {

	desc('Install node dependencies.');
	task('node', function (params) {
		exec('npm link');
	});

	desc('Install ruby dependencies.');
	task('ruby', function (params) {
		exec('gem install --no-ri --no-rdoc bundler', function() {
			console.log('Installed bundler.');
			exec('cd ' + __dirname + '/stasis && bundle install', function () {
				console.log('Installed gems.');
			});
		});
	});
});

desc('Run tests.');
task('test', function (params) {
	var	kexec = require('kexec');
	kexec('cd ' + __dirname + ' && mocha --reporter spec')
});