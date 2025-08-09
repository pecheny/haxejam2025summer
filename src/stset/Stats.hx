package stset;

import fu.Signal;
import haxe.ds.ReadOnlyArray;

@:autoBuild(stset.StatsMacro.build())
interface StatsSet {
    var keys(default, null):ReadOnlyArray<String>;
}

interface StatRO<T:Float> {
    var onChange(default, null):Signal<T->Void>;
    var value(get, null):T;
}

interface Serializable {
    function load(d:Dynamic):Void;
    function getData():Dynamic;
}

class GameStat<T:Float> implements StatRO<Float> implements Serializable {
    public var onChange(default, null):Signal<Float->Void> = new Signal();
    @:isVar public var value(get, set):T;

    function get_value():T {
        return value;
    }

    function set_value(newVal:T):T {
        var delta = newVal - value;
        value = newVal;
        onChange.dispatch(delta);
        return value;
    }

    public function new(v:T) {
        this.value = v;
    }

    public function load(d:Dynamic):Void {
        value = d;
    }

    public function getData():Dynamic
        return value;
}

class ZeroCapGameStat<T:Float> extends CapGameStat<T> {
    override function load(d:Dynamic) {
        if (d is Float) {
            max = d;
            value = cast 0;
        } else {
            max = d.max;
            value = d.value;
        }
    }
}

class CapGameStat<T:Float> extends GameStat<T> {
    public var max(default, set):T;

    public function new(max:T, val:T = cast 0) {
        @:bypassAccessor this.max = max;
        super(val);
    }

    override function set_value(newVal:T):T {
        if (newVal > max)
            newVal = max;
        return super.set_value(newVal);
    }

    function set_max(val:T):T {
        max = val;
        set_value(value);
        return max;
    }

    override function getData():Dynamic {
        return {value: value, max: max};
    }

    override function load(d:Dynamic) {
        if (d is Float) {
            @:bypassAccessor max = d;
            value = max;
        } else {
            @:bypassAccessor max = d.max;
            value = d.value;
        }
    }
}

class TempIncGameStat<T:Float> extends GameStat<T> {
    public var prm(default, null):GameStat<T>;
    public var tmp(default, null):GameStat<T>;

    public function new(val:T, ?prm:GameStat<T>, ?tmp) {
        this.prm = prm ?? new GameStat(val);
        this.tmp = tmp ?? new GameStat(val);
        this.tmp.value = cast 0;
        super(val);
        this.prm.onChange.listen(dispatch);
        this.tmp.onChange.listen(dispatch);
    }

    function dispatch(d) {
        onChange.dispatch(d);
    }

    override function get_value():T {
        return prm.value + tmp.value;
    }

    override function set_value(newVal:T):T {
        return prm.set_value(newVal);
    }

    override function load(d:Dynamic) {
        if (!Std.isOfType(d, Float))
            throw 'Cant load $d to TempIncGameStat';
        tmp.value = cast 0;
        value = d;
    }
}
