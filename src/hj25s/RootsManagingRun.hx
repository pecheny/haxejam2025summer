package hj25s;

import bootstrap.Executor;
import haxe.Json;
import hj25s.GroundsState;
import bootstrap.GameRunBase;

class RootsManagingRun extends GameRunBase {
@:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var view:RootsManagingView;
    @:once var executor:Executor;

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
        var cells = grid.getIntersectingCells(data.pos, data.end);
        this.view.grounds.hlCells(cells);
        executor.run("test()");
        gameOvered.dispatch();
    }


}
