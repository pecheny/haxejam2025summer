package hj25s;

import bootstrap.GameRunBase;
import hj25s.GroundsState;

class SimulationRun extends GameRunBase {
    @:once var state:GroundsState;

    override function startGame() {
        super.startGame();
        var wtr = state.cells[0].production.wtr;
        wtr.value = wtr.max;
        t = 3;
    }

    var t:Float;

    override function update(dt:Float) {
        var wtr = state.cells[0].production.wtr;
        wtr.value -= 0.01;
        super.update(dt);
        t -= dt;
        if (t <= 0)
            gameOvered.dispatch();
    }
}
