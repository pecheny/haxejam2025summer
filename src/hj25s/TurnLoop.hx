package hj25s;

import ec.Entity;
import bootstrap.SequenceRun;
import hj25s.GroundsState;

class TurnLoop extends SequenceRun {
    @:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var view:RootsManagingView;

    override function init() {
        super.init();
        addActivity(new RootsManagingRun(new Entity("managing"), view.ph));
        addActivity(new SimulationRun(new Entity("simulation"), view.ph));
    }
}
