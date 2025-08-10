package hj25s;

import loops.market.MarketData.MarketDesc;
import hxmath.math.Vector2;
import stset.Stats;
import fu.Signal;
import a2d.Boundbox;
import Axis2D;
import bootstrap.Lifecycle.State;
import fu.Serializable;

@:keep
class GroundsState implements Serializable implements State {
    @:serialize(itemCtr = new RootFragment()) public var frags:Array<RootFragment> = [];
    @:serialize(fixedArray = true) public var cells:Array<GroundCell> = [];
    @:serialize public var resources:Resources = new Resources({});
    @:serialize public var flower:FlowerStats = new FlowerStats({});
    @:serialize public var market:MarketDesc = [];
    public var fragCreated:Signal<Void->Void> = new Signal();

    public function new() {
        frags = [];
    }
}

enum abstract FragState(Int) from Int to Int {
    var alive;
    var dead;
}

@:keep
class GatherData implements Serializable {
    @:serialize public var gathered:Resources = new Resources({});
    @:serialize public var speed:Float;
    public var cells:Array<GroundCell>;

    public function new() {}
}

@:keep
class RootFragment implements Serializable {
    public function new() {
        gathering.load({
            gathered: {
                wtr: {
                    max: 0.5,
                    value: 0
                }
            },
            speed: 0.5
        });
    }

    // @:serialize(skipNullLoad = true) 
    public var parent:Int = -1;
    // @:serialize(skipNullLoad = true)
     public var children:Array<Int> = [];
    // @:serialize(skipNullLoad = true)
     public var state:FragState = alive;
    @:serialize public var gathering:GatherData = new GatherData();

    @:serialize var _pos:Vec2 = new Vec2(0, 0);
    @:serialize var _end:Vec2 = new Vec2(0, 0);

    // public var pos:Vector2;
    // public var end:Vector2;
    public var pos(get, set):Vector2;
    public var end(get, set):Vector2;

    public var onChange:Signal<Void->Void> = new Signal();

    function set_pos(value:Vector2):Vector2 {
        return _pos = value;
    }

    function get_pos():Vector2 {
        return _pos;
    }

    function set_end(value:Vector2):Vector2 {
        return _end = value;
    }

    function get_end():Vector2 {
        return _end;
    }
    
    public function dump() {

    
    }
}

@:keep
class FlowerStats implements fu.Serializable implements StatsSet {
    public var hlt(default, null):CapGameStat<Int>;
    public var exp(default, null):GameStat<Int>;
    public var lvl(default, null):GameStat<Int>;

    public function dump() {
        for (k in this.keys) {
            Reflect.setField(data, k, this.get(k).getData());
        }
    }
}

@:keep
class Resources implements fu.Serializable implements StatsSet {
    public var wtr(default, null):CapGameStat<Float>;

    public function dump() {
        for (k in this.keys) {
            Reflect.setField(data, k, this.get(k).getData());
        }
    }
}

@:keep
class GroundCell implements Serializable {
    @:serialize public var production(default, null):Resources = new Resources({});

    public function new() {}
}

@:keep class Vec2 implements Serializable {
    @:serialize public var x:Float = 0;
    @:serialize public var y:Float = 0;

    public function new(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }

    public function toString() {
        return '[$x, $y]';
    }
}

typedef CellId = Array<Int>;

class Grid {
    public var cellsXCount:Int;
    public var cellsYCount:Int;

    public var width:Float;
    public var height:Float;

    public function new(width:Float, height:Float, cellsXCount:Int, cellsYCount:Int) {
        this.width = width;
        this.height = height;
        this.cellsXCount = cellsXCount;
        this.cellsYCount = cellsYCount;
    }

    public function coordsToIndex(x:Int, y:Int) {
        return y * cellsYCount + x;
    }

    public function numCells() {
        return cellsXCount * cellsYCount;
    }

    public function getIntersectingCells(begin:Vec2, end:Vec2):Array<Int> {
        var cellWidth = width / cellsXCount;
        var cellHeight = height / cellsYCount;

        // Function to clamp cell indexes
        var clampX:Int->Int = x -> Std.int(Math.min(cellsXCount - 1, Math.max(0, x)));
        var clampY:Int->Int = y -> Std.int(Math.min(cellsYCount - 1, Math.max(0, y)));

        // Convert point to cell coordinate
        function pointToCell(p:Vec2):CellId {
            return [clampX(Math.floor(p.x / cellWidth)), clampY(Math.floor(p.y / cellHeight))];
        }

        var startCell = pointToCell(begin);
        var endCell = pointToCell(end);

        var result:Array<Int> = [];

        // Setup for DDA grid traversal
        var x0 = begin.x / cellWidth;
        var y0 = begin.y / cellHeight;
        var x1 = end.x / cellWidth;
        var y1 = end.y / cellHeight;

        var cellX = Std.int(Math.floor(x0));
        var cellY = Std.int(Math.floor(y0));
        var endCellX = Std.int(Math.floor(x1));
        var endCellY = Std.int(Math.floor(y1));

        var stepX = 0;
        var stepY = 0;
        var tMaxX:Float;
        var tMaxY:Float;
        var tDeltaX:Float;
        var tDeltaY:Float;

        var dx = x1 - x0;
        var dy = y1 - y0;

        stepX = (dx > 0) ? 1 : ((dx < 0) ? -1 : 0);
        stepY = (dy > 0) ? 1 : ((dy < 0) ? -1 : 0);

        tMaxX = (stepX > 0) ? ((cellX + 1) - x0) / dx : ((x0 - cellX) / -dx);

        tMaxY = (stepY > 0) ? ((cellY + 1) - y0) / dy : ((y0 - cellY) / -dy);

        // If dx or dy == 0, fix infinite values to large number
        tMaxX = (dx == 0) ? 1e30 : tMaxX;
        tMaxY = (dy == 0) ? 1e30 : tMaxY;

        tDeltaX = (dx == 0) ? 1e30 : 1 / Math.abs(dx);
        tDeltaY = (dy == 0) ? 1e30 : 1 / Math.abs(dy);

        // Collect first cell (begin cell)
        if (cellX >= 0 && cellX < cellsXCount && cellY >= 0 && cellY < cellsYCount)
            result.push(coordsToIndex(cellX, cellY));

        // Traverse the grid until we reach the end cell
        while (cellX != endCellX || cellY != endCellY) {
            if (tMaxX < tMaxY) {
                tMaxX += tDeltaX;
                cellX += stepX;
            } else {
                tMaxY += tDeltaY;
                cellY += stepY;
            }

            if (cellX >= 0 && cellX < cellsXCount && cellY >= 0 && cellY < cellsYCount)
                result.push(coordsToIndex(cellX, cellY));
        }

        return result;
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
