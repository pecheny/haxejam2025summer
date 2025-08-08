package hj25s;

import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

class GameScreen extends BaseDkit {
    public var managing:RootsManagingView;
    static var SRC = <game-screen hl={PortionLayout.instance}>
        <switcher(b().h(pfr, .35).b())  public id="switcher"/>
        <base(b().h(pfr, 1).b()) >
            ${managing = new RootsManagingView(__this__.ph)}
        </base>
 </game-screen>
}
