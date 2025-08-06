package hj25s;

import ec.Entity;
import gameapi.GameRun;
import bootstrap.GameRunBase;
import hj25s.GroundsState;

class RootsGame extends GameRunBase {
    @:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var view:RootsManagingView;
    
    var loop:GameRun;
    
    override function init() {
        super.init();
        loop = new RootsManagingRun(new Entity("roots run"), getView());
        entity.addChild(loop.entity);
    }

    override function startGame() {
        super.startGame();
        createGrounds();
        view.roots.initData(state.frags);
        view.grounds.initData(state.cells);
        loop.startGame();
    }
    
    override function update(dt:Float) {
        loop.update(dt);
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
