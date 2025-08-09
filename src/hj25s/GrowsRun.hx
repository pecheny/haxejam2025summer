package hj25s;

import al.ec.WidgetSwitcher;
import fancy.widgets.OptionPickerGui;
import ec.Entity;
import al.Builder;
import loops.llevelup.LevelUpActivity;
import hj25s.GrowsGui;
import hj25s.GroundsState.Resources;
import hj25s.GroundsState.FlowerStats;
import bootstrap.GameRunBase;

typedef LevelSpendings = Map<String, Float>;

class GrowsRun extends GameRunBase {
    @:once var switcher:WidgetSwitcher<Axis2D>;
    @:once var flower:FlowerStats;
    @:once var res:Resources;
    @:once var fui:FuiBuilder;
    var gui:GrowthScreen;
    var spendings:Array<LevelSpendings> = [["wtr" => 5], ["wtr" => 10], ["wtr" => 20],];
    var lvlup:LevelUpActivity;
    var winScreen:WinScreen;

    override function init() {
        super.init();
        gui = new GrowthScreen(getView());
        gui.onDone.listen(onEnd);
        var lvgui = new LevelupGui2(Builder.widget());
        // lvgui.entity.addComponent(fui.textStyles.getStyle(DS.small_text));
        lvlup = new LevelUpActivity(new Entity("lvlup"), lvgui.ph);
        entity.addChild(lvlup.entity);
        lvlup.entity.addComponentByType(OptionPickerGui, lvgui);
        lvlup.gameOvered.listen(onLvlup);
        winScreen = new WinScreen(Builder.widget());
        winScreen.onDone.listen(() -> gameOvered.dispatch());
    }

    function onLvlup() {
        if (flower.lvl.value >= spendings.length - 1) {
            switcher.switchTo(winScreen.ph);
        } else {
            gameOvered.dispatch();
        }
    }

    function onEnd() {
        if (lvlup.shouldActivate()) {
            lvlup.reset();
            switcher.switchTo(lvlup.getView());
            lvlup.startGame();
        } else {
            gameOvered.dispatch();
        }
    }

    override function startGame() {
        super.startGame();
        apply();
    }

    function apply() {
        var spending = spendings[Std.int(flower.lvl.value)];
        var damage = 0.;
        for (k => v in spending.keyValueIterator()) {
            var r = res.get(k);
            var delta = r.value - v;
            if (delta < 0) {
                r.value = 0;
                damage += delta;
            } else {
                r.value -= v;
            }
        }
        if (damage == 0)
            flower.exp.value++;
        gui.initData({damage: damage, spent: spending});
    }
}
