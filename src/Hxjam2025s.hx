package;

import bootstrap.Executor;
import hj25s.Exec.ExecCtx;
import hj25s.RootsGame;
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
        var view = new RootsManagingView(Builder.widget());
        var run = new RootsGame(new Entity("roots game"), view.ph);
        var grid = new Grid(100, 100, 10, 10);
        run.entity.addComponent(grid);
        run.entity.addComponent(view);
        run.entity.addChild(view.entity);
        var state = rootEntity.addComponent(new GroundsState());
        var ctx = rootEntity.addComponent(new ExecCtx(rootEntity));
        rootEntity.addComponent(new Executor(ctx.vars, true));

        state.load(Json.parse(Assets.getText("state.json")));
        runSwitcher.switchTo(run);
        run.startGame();
    }
}
