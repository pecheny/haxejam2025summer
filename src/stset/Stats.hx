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
    @:isVar public var value(get, set):Float;

    function get_value():Float {
        return value;
    }

    function set_value(newVal:Float):Float {
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

class ZeroCapGameStat<T:Float> extends CapGameStat<Float> {
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

class CapGameStat<T:Float> extends GameStat<Float> {
    public var max(default, set):Float;

    public function new(max:Float, val:Float = cast 0) {
        @:bypassAccessor this.max = max;
        super(val);
    }

    override function set_value(newVal:Float):Float {
        if (newVal > max)
            newVal = max;
        return super.set_value(newVal);
    }

    function set_max(val:Float):Float {
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

class TempIncGameStat<T:Float> extends GameStat<Float> {
    public var prm(default, null):GameStat<Float>;
    public var tmp(default, null):GameStat<Float>;

    public function new(val:Float, ?prm:GameStat<Float>, ?tmp) {
        this.prm = prm ?? new GameStat(val);
        this.tmp = tmp ?? new GameStat(0.);
        super(val);
        this.prm.onChange.listen(dispatch);
        this.tmp.onChange.listen(dispatch);
    }

    function dispatch(d) {
        onChange.dispatch(d);
    }

    override function get_value():Float {
        return prm.value + tmp.value;
    }

    override function set_value(newVal:Float):Float {
        return prm.set_value(newVal);
    }

    override function load(d:Dynamic) {
        if (!Std.isOfType(d, Float))
            throw 'Cant load $d to TempIncGameStat';
        tmp.value = 0;
        value = d;
    }
}
