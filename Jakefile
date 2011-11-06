var exec = require('child_process').exec,
	fs = require('fs');

desc('Build project.');
task('build', function (params) {
	jake.Task['build:lib'].invoke();
	jake.Task['build:stasis'].invoke();
});

namespace('build', function() {

	desc('Build /lib from /src.');
	task('lib', function (params) {
		execCommands({
			'Removed lib directory.':
				'rm -rf ' + __dirname + '/lib',
			'Built /lib from /src.':
				'coffee -b -o ' + __dirname + '/lib -c ' + __dirname + '/src'
		});
	});

	desc('Build stasis templates.');
	task('stasis', function (params) {
		execCommands({
			'Built stasis templates.':
				'cd ' + __dirname + '/stasis && stasis -p ../public'
		});
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
		var cmds = {};
		for (dep in pkg.dependencies) {
			dep = dep + '@' + pkg.dependencies[dep];
			cmds['Installed ' + dep + '.'] = 'npm install -g ' + dep;
		}
		execCommands(cmds);
	});

	desc('Install ruby dependencies.');
	task('ruby', function (params) {
		execCommands({
			'Installed stasis.':
				'gem install --no-ri --no-rdoc stasis'
		});
	});
});

function execCommands(commands) {
	for(var msg in commands)
		(function(msg, cmd) {
			exec(commands[msg], function () { console.log(msg); });
		})(msg, commands[msg]);
}