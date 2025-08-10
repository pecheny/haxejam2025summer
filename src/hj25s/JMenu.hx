package hj25s;

import dkit.Dkit.BaseDkit;
import fu.ui.Properties.EnabledProp;

class JMenu extends BaseDkit {
    @:once var l:Hxjam2025s;

    static var SRC = <j-menu layouts={GuiStyles.L_VERT_BUTTONS}>
    <button(b().v(sfr, 0.1).b()) text={"new game"} onClick={()->l.newGame()} />
    <button(b().v(sfr, 0.1).b()) text={"load game"} onClick={()->l.loadGame()} />
    <button(b().v(sfr, 0.1).b()) text={"how to play"} onClick={()->l.showHelp()} />
    <button(b().v(sfr, 0.1).b()) id="backToGame" enabled={false} text={"continue"} onClick={()->l.toggleMenu()} />
 </j-menu>

    override function init() {
        super.init();
        var ep1 = EnabledProp.getOrCreate(backToGame.entity);
        var has = l.hasActiveSession;
        has.onChange.listen(() -> {
            ep1.value = has.value;
        });
    }
}
