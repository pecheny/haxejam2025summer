package;

import haxe.Json;
import openfl.Assets;
import hj25s.GroundsState;
import al.Builder;
import hj25s.RootsManagingView;
import ec.Entity;
import hj25s.RootsManagingRun;
import bootstrap.BootstrapMain;

class Hxjam2025s extends BootstrapMain {
    public function new() {
        super();
        var run = new RootsManagingRun(new Entity("roots run"), new RootsManagingView(Builder.widget()));
        var grid = new Grid();
        grid.width = 5;
        grid.height = 5;
        run.entity.addComponent(grid);
        var state = run.entity.addComponent(new GroundsState());
        state.load(Json.parse(Assets.getText("state.json")));
        runSwitcher.switchTo(run);
        run.startGame();
    }
}
