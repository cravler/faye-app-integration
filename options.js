//
module.exports = function(env) {

    var fs = require('fs');

    var getPlugins = function() {
        var dir = './plugins';
        var plugins = [];
        var list = fs.readdirSync(dir);
        list.forEach(function(file) {
            file = dir + '/' + file;
            var stat = fs.statSync(file);
            if (stat && stat.isDirectory()) {
                plugins.push(require(file));
            }
        });
        return plugins;
    };

    var extensions = [];
    var monitoring = [];

    getPlugins().forEach(function(plugin) {
        extensions = extensions.concat(plugin['extensions'] || []);
        monitoring = monitoring.concat(plugin['monitoring'] || []);
    });

    if ('development' == env) {
        monitoring = monitoring.concat([
            'faye-app/monitoring/debug',
            'faye-app/monitoring/web-debug'
        ]);
    }

    return {
        extensions: extensions,
        monitoring: monitoring
    };

}(process.env.FAYE_ENV || 'production');
