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
    @:once var selection:Selection;

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
        selection.value = idx;
        executor.run("addFrag(10)");
        // gameOvered.dispatch();
    }


}
