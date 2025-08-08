package hj25s;

import stset.Stats.StatsSet;
import hj25s.GroundsState.Resources;
import fancy.widgets.StatsDisplay;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

class GameScreen extends BaseDkit {
    @:once var res:Resources;
    public var managing:RootsManagingView;

    static var SRC = <game-screen hl={PortionLayout.instance}>
        <base(b().h(pfr, .35).b()) vl={PortionLayout.instance}>
            <base(b().v(pfr, 0.1).b()) id="stats">
                ${new StatsDisplay(__this__.ph)}
            </base>
            <switcher(b().v(pfr, 1).b())  public id="switcher"/>
        </base>

        <base(b().h(pfr, 1).b()) >
            ${managing = new RootsManagingView(__this__.ph)}
        </base>
 </game-screen>

    override function init() {
        super.init();
        stats.entity.addComponentByType(StatsSet, res);
    }
}
