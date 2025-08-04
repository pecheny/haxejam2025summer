package hj25s;

import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

class RootsManagingView extends BaseDkit {
    static var SRC = <roots-managing-view vl={PortionLayout.instance}>
    
        <label(b().v(sfr, .15).b()) text={"Controls settings"} />
        <base(b().v(pfr, 1).b()) public id="canvas">
            ${fui.quad(__this__.ph,0x26ff0000)}
        </base>
    </roots-managing-view>
}
