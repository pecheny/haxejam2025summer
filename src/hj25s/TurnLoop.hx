package hj25s;

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
    }
}
