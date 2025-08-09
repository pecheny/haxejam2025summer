package hj25s;

import hj25s.GrowsGui.GrowthScreen;
import hj25s.GroundsState.Resources;
import hj25s.GroundsState.FlowerStats;
import bootstrap.GameRunBase;

typedef LevelSpendings = Map<String, Float>;

class GrowsRun extends GameRunBase {
    @:once var flower:FlowerStats;
    @:once var res:Resources;
    var gui:GrowthScreen;
    var spendings:Array<LevelSpendings> = [["wtr" => 5], ["wtr" => 10], ["wtr" => 20],];
    
    override function init() {
        super.init();
        gui = new GrowthScreen(getView());
        gui.onDone.listen(() -> gameOvered.dispatch());
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
        gui.initData({damage:damage, spent:spending});
    }
}
