package hj25s;

import ec.Signal;
import bootstrap.SelfClosingScreen;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;
import fancy.widgets.StatsDisplay;

class SimulationScreen extends BaseDkit implements SelfClosingScreen {
    static var SRC = <simulation-screen vl={PortionLayout.instance}>
        <base(b().v(pfr, 0.1).b()) public id="stats">
            ${new StatsDisplay(__this__.ph)}
        </base>
        <label(b().v(pfr, .15).b()) public id="lbl" autoSize={true} />
        <button(b().h(sfr, .36).v(sfr, .12).b()) public id="okButton"  enabled={false} text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
 </simulation-screen>

    public var onDone:ec.Signal<Void->Void> = new ec.Signal();

    function onOkClick() {
        onDone.dispatch();
    }
}
