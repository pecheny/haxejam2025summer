package hj25s;

import ec.Signal;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import bootstrap.SelfClosingScreen;
import dkit.Dkit;
import fu.ui.scroll.WheelHandler;
import i18n.I18n;

class HelpWindow extends BaseDkit implements SelfClosingScreen {
    public var onDone:Signal<Void->Void> = new Signal();

    @:once var i18n:I18n;
    final text = "The goal of the game is to grow a flower. To do this, you need to develop the root to get the required amount of water <wtr/>.<br/><br/>"
        + "Each turn, when the flower has enough <wtr/>, it gains experience <exp/>. Having received 10 <exp/>, the flower increases its level <lvl/>. Grow the flower to level 3 <lvl/>.<br/><br/>"
        + "To develop the root, you need to buy upgrades. Each upgrade is bought for one root fragment. The root fragment is a green stick on the screen."
        + "Before buying an upgrade, you need to click on the fragment. The selected fragment is colored white.<br/><br/>"
        + "Each turn, the player decides whether to spend <wtr/> on growing the flower or put it aside for upgrading the root.<br/><br/>"
        +
        "Unfortunately, I did not have time to adjust the balance and playtest, the values are set by eye. <br/><br/>"
        +"This help available during the game from ESC menu."
;

    static var SRC = <help-window scroll={true} vl={PortionLayout.instance} hl={WholefillLayout.instance}>
    
        <base(b().v(sfr, 0.3).b()) hl={PortionLayout.instance}>
            <label(b().b()) text={"Help"} align={Center} />
            <button(b().h(sfr, 0.05).v(sfr, 0.05).b()) text={"X"} onClick={()->onDone.dispatch()}/>
            <base(b().h(sfr, 0.05).v(sfr, 0.05).b()) />
        </base>

        <label(b().h(pfr, 1).v(pfr, 2.5).b()) autoSize={true} text={"Help"} id="content" align={Forward} style={"small-text"}>
        </label>
        <base(b().h(sfr, 0.05).v(sfr, 0.05).b()) />
        <button(b().h(pfr, 1).v(sfr, 0.1).b()) text={"Back"} onClick={()->onDone.dispatch()}/>

    </help-window>

    override function init() {
        content.text = i18n.tags(text);
        new WheelHandler(ph, vertical);
    }
}
