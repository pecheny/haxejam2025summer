package;

import hj25s.GameScreen;
import hj25s.Selection;
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
        var grid = new Grid(100, 100, 10, 10);
        rootEntity.addComponent(grid);
        Selection.getOrCreate(rootEntity);
        var state = rootEntity.addComponent(new GroundsState());
        state.load(Json.parse(Assets.getText("state.json")));
        rootEntity.addComponent(state.resources);
        var ctx = rootEntity.addComponent(new ExecCtx(rootEntity));
        rootEntity.addComponent(new Executor(ctx.vars, true));

        var view = new GameScreen(Builder.widget());
        fui.makeClickInput(view.ph);
        rootEntity.addComponent(view);
        rootEntity.addComponent(view.managing);
        var run = new RootsGame(new Entity("roots game"), view.ph);
        runSwitcher.switchTo(run);
        run.reset();
        run.startGame();
    }
}
