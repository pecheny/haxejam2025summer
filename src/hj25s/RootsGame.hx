package hj25s;

import al.ec.WidgetSwitcher;
import ec.Entity;
import gameapi.GameRun;
import bootstrap.GameRunBase;
import hj25s.GroundsState;

class RootsGame extends GameRunBase {
    @:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var view:GameScreen;
    @:once var fui:FuiBuilder;
    @:once var switcher:WidgetSwitcher<Axis2D>;

    var loop:GameRun;

    override function init() {
        super.init();
        loop = new TurnLoop(new Entity("roots run"), getView(), @:privateAccess view.switcher.switcher);
        loop.gameOvered.listen(() -> gameOvered.dispatch());
        entity.addChild(loop.entity);
    }

    override function startGame() {
        super.startGame();
        createGrounds();
        view.managing.roots.initData(state.frags);
        view.managing.grounds.initData(state.cells);
        loop.startGame();
    }

    override function reset() {
        loop.reset();
    }

    override function update(dt:Float) {
        loop.update(dt);
    }

    public function createGrounds() {
        state.cells.resize(0);
        for (i in 0...grid.numCells()) {
            var cell = new GroundCell();
            if (Math.random() > 0.5)
                cell.production.wtr.max = Std.int(1 + Math.random() * 5);
            cell.production.wtr.value = cell.production.wtr.max;
            state.cells.push(cell);
        }
    }
}
