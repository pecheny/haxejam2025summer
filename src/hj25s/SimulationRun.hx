package hj25s;

import fu.ui.Properties.EnabledProp;
import hj25s.SimulationGui.SimulationScreen;
import fu.Serializable;
import stset.Stats.CapGameStat;
import bootstrap.GameRunBase;
import hj25s.GroundsState;

class SimulationRun extends GameRunBase {
    @:once var state:GroundsState;
    @:once var grid:Grid;
    var gui:SimulationScreen;
    var gathering:Array<GatherData> = [];
    var t:Float;
    var ended = false;

    var defaultFragData = {
        gathered: {
            wtr: {
                max: 0.5,
                value: 0
            }
        },
        speed: 0.5
    }

    override function init() {
        super.init();
        gui = new SimulationScreen(getView());
        gui.onDone.listen(() -> gameOvered.dispatch());
    }

    override function update(dt:Float) {
        if(ended)
            return;
        var step = 1 / 60;
        var hasChange = false;
        for (fd in gathering) {
            // TODO all res
            if (fd.gathered.wtr.value >= fd.gathered.wtr.max)
                continue;
            for (cell in fd.cells) {
                var inc = Math.min(cell.production.wtr.value, fd.speed * step);
                var beforeCap = fd.gathered.wtr.max - fd.gathered.wtr.value + inc;
                inc = Math.min(inc, beforeCap);
                if (inc > 0) {
                    hasChange = true;
                    cell.production.wtr.value -= inc;
                    fd.gathered.wtr.value += inc;
                }
            }
        }
        super.update(dt);
        t -= dt;
        if (t <= 0 || !hasChange) {
            onSimulationEnd();
        }
    }

    function onSimulationEnd() {
        ended = true;
        var d = 0.;
        for (gd in gathering) {
            d += gd.gathered.wtr.value;
        }
        state.resources.wtr.value += d;
        EnabledProp.getOrCreate(gui.okButton.entity).value = true;
    }

    override function startGame() {
        refillCells();
        gatherCells();
        ended = false;
        EnabledProp.getOrCreate(gui.okButton.entity).value = false;
        super.startGame();
        t = 3;
    }

    function refillCells() {
        for (cell in state.cells) {
            for (rn in cell.production.keys) {
                var r:CapGameStat<Float> = cast cell.production.get(rn);
                r.value = r.max;
            }
        }
    }

    function gatherCells() {
        for (frag in state.frags) {
            var gd = new GatherData();
            gd.cells = grid.getIntersectingCells(frag.pos, frag.end).map(idx -> state.cells[idx]);
            gd.load(defaultFragData);
            gathering.push(gd);
        }
    }

    override function reset() {
        super.reset();
        gathering.resize(0);
    }
}

class GatherData implements Serializable {
    @:serialize public var gathered:Resources = new Resources({});
    @:serialize public var speed:Float;
    public var cells:Array<GroundCell>;

    public function new() {}
}
