package hj25s;

import openfl.Assets;
import ec.Entity;
import loops.market.MarketGui.MarketWidget;
import loops.market.MarketActivity;
import bootstrap.Executor;
import haxe.Json;
import hj25s.GroundsState;
import bootstrap.GameRunBase;

class RootsManagingRun extends GameRunBase {
@:once var state:GroundsState;
    @:once var grid:Grid;
    @:once var view:RootsManagingView;
    @:once var executor:Executor;
    @:once var selection:Selection;
    var market:MarketActivity;

    public function new(ctx, v) {
        super(ctx, v);
        var mgui = new MarketWidget(getView());
        entity.addComponentByType(MarketGui, mgui);
        mgui.onDone.listen(()->gameOvered.dispatch());
        market = new MarketActivity(new Entity("market"), getView());
        entity.addChild(market.entity);
    }

    override function init() {
        super.init();
        // for (i in 0...5)
        //     addView();
        // trace(state);
        // var dump = state.dump();
        // sys.io.File.saveContent("state.json", Json.stringify(dump, null, " "));
        selection.onChange.listen(()->view.title.text="");
        view.roots.rootClick.listen(select);
    }
    
    override function startGame() {
        market.initDescr(Json.parse(Assets.getText("cards.json")));
        select(-1);
        market.startGame();
    }
    
    override function reset() {
        market.reset();
    }
    
    public function select(idx) {
        selection.value = idx;
    }


}
