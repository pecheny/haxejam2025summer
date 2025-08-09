package hj25s;

import hj25s.GrowsRun.LevelSpendings;
import hj25s.GroundsState.FlowerStats;
import stset.Stats.StatsSet;
import hj25s.GroundsState.Resources;
import fancy.widgets.StatsDisplay;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

typedef GrowsGuiDesc = {
    ?damage:Float,
    spent:LevelSpendings,
}
class GrowthScreen extends BaseDkit {
    static var SRC = <growth-screen vl={PortionLayout.instance}>
        <label(b().v(sfr, .15).b()) text={"Day is over"} />
        <label(b().v(pfr, .15).b()) id="lbl" />
        <button(b().h(sfr, .36).v(sfr, .12).b()) id="okButton" text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
    </growth-screen>

    public var onDone:ec.Signal<Void->Void> = new ec.Signal();

    function onOkClick() {
        onDone.dispatch();
    }
    
    public function initData(desc:GrowsGuiDesc) {
        if (desc.damage!=null && desc.damage > 0) {
            lbl.text = 'Due to insufficient resource the flower loses ${desc.damage} hp';
        } else {
            lbl.text = 'All the flower needs fulfilled';
        }
    }
}
