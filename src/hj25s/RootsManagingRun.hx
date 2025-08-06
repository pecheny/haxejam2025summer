package hj25s;

import haxe.Json;
import hj25s.GroundsState;
import bootstrap.GameRunBase;

class RootsManagingRun extends GameRunBase {
    @:once var fui:FuiBuilder;
    @:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var view:RootsManagingView;

    public function new(ctx, v) {
        super(ctx, v);
        entity.addChild(v.entity);
    }

    override function init() {
        super.init();
        // for (i in 0...5)
        //     addView();
        // trace(state);
        // var dump = state.dump();
        // sys.io.File.saveContent("state.json", Json.stringify(dump, null, " "));
        view.roots.rootClick.listen(select);
    }
    
    public function select(idx) {
        view.roots.select(idx);
        var view = view.roots.views[idx];
        var data = state.frags[idx];
        var cells = grid.getIntersectingCells(data.pos, view.getTip());
        this.view.grounds.hlCells(cells);
    }

    override function startGame() {
        super.startGame();
        createGrounds();

        view.roots.initData(state.frags);
        view.grounds.initData(state.cells);
    }

    override function reset() {
        super.reset();
    }


    public function createGrounds() {
        state.cells.resize(0);
        for (i in 0...grid.numCells()) {
            var cell = new GroundCell();
            cell.production.wtr.max = Std.int(Math.random() * 5);
            cell.production.wtr.value = cell.production.wtr.max;
            state.cells.push(cell);
        }
    }

}
