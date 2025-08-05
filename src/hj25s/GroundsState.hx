package hj25s;

import Axis2D;
import bootstrap.Lifecycle.State;
import fu.Serializable;

@:keep
class GroundsState implements Serializable implements State {
    @:serialize(itemCtr = new RootFragment()) public var frags:Array<RootFragment> = [];

    public function new() {
        frags = [];
    }
}

@:keep
class RootFragment implements Serializable {
    public function new() {}

    @:serialize public var pos:Vec2 = new Vec2();
    @:serialize public var angle:Float = 0;
}

@:keep
class Vec2 implements Serializable {
    @:serialize public var x:Float = 0;
    @:serialize public var y:Float = 0;

    public function new() {}
}

class Grid {
    public var width:Int;
    public var height:Int;

    public function new() {}
    public function coordsToIndex(x, y) {
        // var ix = children.length % refRow.length;
        // var iy = Math.floor(children.length / refRow.length);
        return y * height + x;
    }
    public function numCells() {
        return width * height;
    }
}

// @:forward
// // abstract Vec2(AVector<Axis2D, Float>) {
// abstract Vec2(Array<Float>) {
//     public inline function new() {
//         // this = cast new haxe.ds.Vector(2, 0.);
//         this = [0., 0.];
//     }
//     public var x(get, set):Float;
//     inline function set_x(val:Float):Float {
//         return this[horizontal] = val;
//     }
//     inline function get_x():Float {
//         return this[horizontal];
//     }
//     public var y(get, set):Float;
//     inline function set_y(val:Float):Float {
//         return this[vertical] = val;
//     }
//     inline function get_y():Float {
//         return this[vertical];
//     }
// }
