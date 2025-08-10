package hj25s;

import ec.Signal;
import bootstrap.SelfClosingScreen;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;
import fancy.widgets.StatsDisplay;
import hj25s.GroundsState;
import stset.Stats.StatsSet;


class SimulationScreen extends BaseDkit implements SelfClosingScreen {
    static var SRC = <simulation-screen vl={PortionLayout.instance}>
        <label(b().v(pfr, .15).b()) text={"Total gained:"} />
        <base(b().v(pfr, 0.1).b()) public id="stats">
            ${new StatsDisplay(__this__.ph)}
        </base>
        <label(b().v(pfr, .15).b()) text={"By current root:"} />

        <base(b().v(pfr, 0.1).b()) public id="frag">
            ${(__this__.ph.entity.addComponentByType(StatsSet, new Resources({})))}
            ${new StatsDisplay(__this__.ph)}
        </base>
        <label(b().v(pfr, .15).b()) public id="lbl" autoSize={true} />
        <base(b().v(pfr, 0.1).b()) />
        <button(b().h(sfr, .36).v(sfr, .12).b()) public id="okButton"  enabled={false} text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
 </simulation-screen>

    public var onDone:ec.Signal<Void->Void> = new ec.Signal();

    function onOkClick() {
        onDone.dispatch();
    }
}
