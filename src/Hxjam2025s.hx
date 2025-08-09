package;

import al.ec.WidgetSwitcher;
import bootstrap.Menu;
import bootstrap.Lifecycle;
import bootstrap.DefNode;
import loops.llevelup.LevelupData;
import loops.llevelup.LevelUpActivity.LevelingStats;
import i18n.RootsI18n;
import i18n.I18n;
import stset.Stats.StatsSet;
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

class Hxjam2025s extends LifecycleImpl {
    public function new() {
        super();
        var grid = new Grid(100, 100, 10, 10);
        rootEntity.addComponent(grid);
        rootEntity.addComponentByType(I18n, new RootsI18n());
        rootEntity.addComponent(new LevelingDef(new DefNode("levelups", openfl.utils.Assets.getLibrary("")).get));
        var sel = Selection.getOrCreate(rootEntity);
        sel.value = -1;
        var state = rootEntity.addComponent(new GroundsState());
        // state.load(Json.parse(Assets.getText("state.json")));
        rootEntity.addComponentByType(State, state);
        rootEntity.addComponent(state.resources);
        rootEntity.addComponent(state.flower);
        rootEntity.addComponent(new LevelingStats(state.flower));

        var ctx = rootEntity.addComponent(new ExecCtx(rootEntity));
        rootEntity.addComponent(new Executor(ctx.vars, true));

        var view = new GameScreen(Builder.widget());
        fui.makeClickInput(view.ph);
        rootEntity.addComponent(view);
        rootEntity.addComponent(view.managing);
        var run = new RootsGame(new Entity("roots game"), view.ph);
        run.entity.addComponent(@:privateAccess view.switcher.switcher);
        bindRun(run);
        rootEntity.getComponent(WidgetSwitcher).switchTo(run.getView()); // preinit
        new Menu(menu);
        showMenu();
        // runSwitcher.switchTo(run);
        // run.reset();
        // run.startGame();
    }
}
