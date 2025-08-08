package fu;



abstract DynamicIntMap({}) from {} {
    public inline function new(v) {
        this = v;
    }

    @:arrayAccess public inline function get(key:String) {
        return Reflect.field(this, key) ?? 0;
    }

    @:arrayAccess public inline function set(key:String, val:Int) {
        Reflect.setField(this, key, val);
        return val;
    }
    
    public inline function copy() {
        return Reflect.copy(this);
    }
}
