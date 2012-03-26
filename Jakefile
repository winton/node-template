var exec = require('child_process').exec,
	kexec = require('kexec'),
	fs = require('fs');

desc('Build project.');
task('build', function (params) {
	jake.Task['build:lib'].invoke();
	jake.Task['build:test'].invoke();
	jake.Task['build:stasis'].invoke();
});

namespace('build', function() {

	desc('Build /lib from /src.');
	task('lib', function (params) {
		exec('rm -rf ' + __dirname + '/lib', function() {
			console.log('Removed lib directory.');
			exec('coffee -b -o ' + __dirname + '/lib -c ' + __dirname + '/src', function (error, stdout, stderr) {
				console.log('Built /lib from /src.');
				console.log(stderr);
			});
		});
	});

	desc('Build /test from /test_src.');
	task('test', function (params) {
		exec('rm -rf ' + __dirname + '/test', function() {
			console.log('Removed test directory.');
			exec('coffee -b -o ' + __dirname + '/test -c ' + __dirname + '/test_src', function (error, stdout, stderr) {
				console.log('Built /test from /test_src.');
				console.log(stderr);
			});
		});
	});

	desc('Build stasis templates.');
	task('stasis', function (params) {
		exec('cd ' + __dirname + '/stasis && stasis -p ../public', function() {
			console.log('Built stasis templates.');
		})
	});
});

desc('Install dependencies.');
task('install', function (params) {
	jake.Task['install:node'].invoke();
	jake.Task['install:ruby'].invoke();
});

namespace('install', function() {

	desc('Install node dependencies.');
	task('node', function (params) {
		var pkg = JSON.parse(fs.readFileSync(__dirname + '/package.json').toString());
		var cmds = [];
		for (dep in pkg.dependencies) {
			dep = dep + '@' + pkg.dependencies[dep];
			(function(dep) {
				exec('cd ' + __dirname + ' && npm install ' + dep, function() {
					console.log('Installed ' + dep + '.');
				});
			})(dep);
		}
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
	kexec('cd ' + __dirname + ' && mocha --reporter spec')
});