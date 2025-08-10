package hj25s;

import openfl.Assets;
import haxe.Json;
import al.Builder;
import ec.Entity;
import bootstrap.SequenceRun;
import hj25s.GroundsState;

class TurnLoop extends SequenceRun {
    @:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var view:RootsManagingView;

    override function init() {
        super.init();
        addActivity(new RootsManagingRun(new Entity("managing"), Builder.widget()));
        addActivity(new SimulationRun(new Entity("simulation"), Builder.widget()));
        addActivity(new GrowsRun(new Entity("grows"), Builder.widget()));
        addFuncStep(rerollMarket);
        addChecker(() -> state.flower.lvl.value > 1);
        addChecker(() -> state.flower.hlt.value <= 0);
    }

    function rerollMarket() {
        state.market = Json.parse(Assets.getText("cards.json"));
    }
}
