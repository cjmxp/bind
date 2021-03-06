package bind;

import Sys.println;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

using StringTools;

class Cli {

    var args:Array<String>;

    var cwd:String;

    public function new(args:Array<String>, cwd:String) {

        this.args = args;
        this.cwd = cwd;

    } //new

    public function run():Void {

        if (args.length < 2) {
            println("Usage: haxelib run bind objc SomeHeaderFile.h");
            return;
        }

        // Extract options
        var options = {
            json: false,
            parseOnly: false,
            pretty: false,
            export: null
        };
        var bindClassOptions:Dynamic = {};
        var fileArgs = [];
        var i = 1;
        while (i < args.length) {

            var arg = args[i];

            if (arg.startsWith('--')) {
                if (arg == '--json') options.json = true;
                else if (arg == '--parse-only') options.parseOnly = true;
                else if (arg == '--pretty') options.pretty = true;
                else if (arg == '--export') {
                    i++;
                    options.export = args[i];
                    options.json = true;
                }
                else if (arg == '--namespace') {
                    i++;
                    bindClassOptions.namespace = args[i];
                }
                else if (arg == '--package') {
                    i++;
                    bindClassOptions.pack = args[i];
                }
                else if (arg == '--objc-prefix') {
                    i++;
                    bindClassOptions.objcPrefix = args[i];
                }
                else if (arg == '--cwd') {
                    i++;
                    this.cwd = args[i];
                    Sys.setCwd(args[i]);
                }
            }
            else {
                fileArgs.push(arg);
            }

            i++;
        }

        var kind = args[0];
        var json = [];
        var output = '';

        // Parse
        if (kind == 'objc') {

            for (i in 0...fileArgs.length) {
                var file = fileArgs[i];

                var path = Path.isAbsolute(file) ? file : Path.join([cwd, file]);
                if (!FileSystem.exists(path)) {
                    throw "Header file doesn't exist at path " + path;
                }
                if (FileSystem.isDirectory(path)) {
                    throw "Expected a header file but got a directory at path " + path;
                }
                var code = File.getContent(path);

                bindClassOptions.headerPath = path;
                bindClassOptions.headerCode = code;

                var ctx = {i: 0, types: new Map()};
                var result = null;
                while ((result = bind.objc.Parse.parseClass(code, ctx)) != null) {
                    result.path = path;

                    if (options.json) {
                        if (options.parseOnly) {
                            json.push(bind.Json.stringify(result, options.pretty));
                        }
                        else {
                            for (entry in bind.objc.Bind.bindClass(result, bindClassOptions)) {
                                json.push(bind.Json.stringify(entry, options.pretty));
                            }
                        }
                    }
                    else {
                        if (options.parseOnly) {
                            output += '' + result;
                        }
                        else {
                            for (entry in bind.objc.Bind.bindClass(result, bindClassOptions)) {
                                output += '-- BEGIN ' + entry.path + " --\n";
                                output += entry.content.rtrim() + "\n\n";
                                output += '-- END ' + entry.path + " --\n";
                            }
                        }
                    }
                }
            }
        }

        if (options.json) {
            if (options.export != null) {

                if (!FileSystem.exists(options.export)) {
                    FileSystem.createDirectory(options.export);
                }

                for (jsonItem in json) {
                    var fileInfo:{path:String,content:String} = Json.parse(jsonItem);
                    var filePath = Path.join([options.export, fileInfo.path]);

                    if (!FileSystem.exists(Path.directory(filePath))) {
                        FileSystem.createDirectory(Path.directory(filePath));
                    }

                    File.saveContent(filePath, fileInfo.content);
                }

            }
            else {
                if (options.pretty) {
                    println('['+json.join(',\n')+']');
                } else {
                    println('['+json.join(',')+']');
                }
            }
        }
        else {
            if (output.trim() != '') {
                println(output.rtrim());
            }
        }

    } //run

} //Cli
