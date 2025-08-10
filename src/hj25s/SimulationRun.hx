package hj25s;

import stset.Stats.StatsSet;
import fu.ui.Properties.EnabledProp;
import hj25s.SimulationGui.SimulationScreen;
import fu.Serializable;
import stset.Stats.CapGameStat;
import bootstrap.GameRunBase;
import hj25s.GroundsState;

class SimulationRun extends GameRunBase {
    @:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var selection:Selection;
    var gui:SimulationScreen;
    var gathering:Array<GatherData> = [];
    var t:Float;
    var ended = false;
    var gathered = new Resources({});

    override function init() {
        super.init();
        gathered.load({wtr: {max: 100, value: 0}});
        gui = new SimulationScreen(getView());
        gui.stats.entity.addComponentByType(StatsSet, gathered);
        gui.onDone.listen(() -> gameOvered.dispatch());

        selection.onChange.listen(onSelect);
    }

    function onSelect() {
        var frag = null;
        if (selection.value > -1)
            frag = state.frags[selection.value];
        if (frag != null)
            untyped gui.frag.entity.getComponent(StatsSet).load(frag.gathering.gathered.dump());
        else
            untyped gui.frag.entity.getComponent(StatsSet).load({wtr: {max: 0, value: 0}});
    }

    override function update(dt:Float) {
        if (ended)
            return;
        var step = 1 / 60;
        var hasChange = false;
        for (fd in gathering) {
            for (k in fd.gathered.keys) {
                var stat:CapGameStat<Float> = cast fd.gathered.get(k);
                if (stat.value >= stat.max)
                    continue;
                for (cell in fd.cells) {
                    var cellStat = cell.production.get(k);
                    var inc = Math.min(cellStat.value, fd.speed * step);
                    // trace(inc, (fd.speed * step), fd.speed );
                    var beforeCap = stat.max - stat.value + inc;
                    inc = Math.min(inc, beforeCap);
                    if (inc > 0) {
                        gathered.get(k).value += inc;
                        hasChange = true;
                        cellStat.value -= inc;
                        stat.value += inc;
                    }
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
            var gd = frag.gathering;
            for (k in gd.gathered.keys)
                gd.gathered.get(k).value = 0;

            gd.cells = grid.getIntersectingCells(frag.pos, frag.end).map(idx -> state.cells[idx]);
            gathering.push(gd);
        }
    }

    override function reset() {
        super.reset();
        for (k in gathered.keys) {
            gathered.get(k).value = 0;
        }
        gathering.resize(0);
    }
}
