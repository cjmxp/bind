package ios;
// This file was generated with bind library

import bind.objc.Support;

/** Example of Objective-C interface exposed to Haxe */
class AppNativeInterface {

    private var _instance:Dynamic = null;

    public function new() {}

    /** If provided, will be called when root view controller is visible on screen */
    public var viewDidAppear(get,set):Void->Void;

    /** Last name. If provided, will be used when saying hello. */
    public var lastName(get,set):String;

    /** Get shared instance */
    public static function sharedInterface():AppNativeInterface {
        var ret = new AppNativeInterface();
        ret._instance = AppNativeInterface_Extern.sharedInterface();
        return ret;
    }

    /** Say hello to `name` with a native iOS dialog. Add a last name if any is known. */
    public function hello(name:String):Void {
        AppNativeInterface_Extern.hello(_instance, name);
    }

    /** If provided, will be called when root view controller is visible on screen */
    inline private function get_viewDidAppear():Void->Void {
        return AppNativeInterface_Extern.viewDidAppear(_instance);
    }

    /** If provided, will be called when root view controller is visible on screen */
    inline private function set_viewDidAppear(viewDidAppear:Void->Void):Void->Void {
        AppNativeInterface_Extern.setViewDidAppear(_instance, viewDidAppear);
        return viewDidAppear;
    }

    /** Last name. If provided, will be used when saying hello. */
    inline private function get_lastName():String {
        return AppNativeInterface_Extern.lastName(_instance);
    }

    /** Last name. If provided, will be used when saying hello. */
    inline private function set_lastName(lastName:String):String {
        AppNativeInterface_Extern.setLastName(_instance, lastName);
        return lastName;
    }

}

@:keep
@:include('linc_AppNativeInterface.h')
#if !display
@:build(bind.Linc.touch())
@:build(bind.Linc.xml('AppNativeInterface', './'))
#end
@:allow(ios.AppNativeInterface)
private extern class AppNativeInterface_Extern {

    @:native('ios::AppNativeInterface_sharedInterface')
    static function sharedInterface():Dynamic;

    @:native('ios::AppNativeInterface_hello')
    static function hello(instance_:Dynamic, name:String):Void;

    @:native('ios::AppNativeInterface_viewDidAppear')
    static function viewDidAppear(instance_:Dynamic):Void->Void;

    @:native('ios::AppNativeInterface_setViewDidAppear')
    static function setViewDidAppear(instance_:Dynamic, viewDidAppear:Void->Void):Void;

    @:native('ios::AppNativeInterface_lastName')
    static function lastName(instance_:Dynamic):String;

    @:native('ios::AppNativeInterface_setLastName')
    static function setLastName(instance_:Dynamic, lastName:String):Void;

}

