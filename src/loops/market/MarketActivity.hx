package loops.market;

import hj25s.Selection;
import hj25s.RootsManagingView;
import hj25s.GroundsState.Resources;
import bootstrap.Executor;
import fu.Signal;
import bootstrap.Activitor;
import bootstrap.GameRunBase;
import bootstrap.SelfClosingScreen;
import fancy.widgets.OptionPickerGui;
import loops.market.MarketData;

interface MarketGui extends OptionPickerGui<MarketItemRecord> extends SelfClosingScreen {}

class MarketActivity extends GameRunBase implements ActHandler<MarketDesc> implements StatefullActHandler {
    public var onChange:Signal<Void->Void> = new Signal();

    @:once var stats:Resources;
    @:once var executor:Executor;
    @:once var gui:MarketGui;
    @:once var managingGui:RootsManagingView;
    @:once var selection:Selection;
    var data:MarketDesc;
    var items:Array<MarketItemRecord>;

    public function new(ctx, w) {
        super(ctx, w);
        watch(w.entity);
    }

    override function init() {
        super.init();
        gui.onChoice.listen(onChoise);
        gui.onDone.listen(onDone);
    }

    override function startGame() {
        gui.initData(items);
    }

    function onDone() {
        gameOvered.dispatch();
    }

    function onChoise(n) {
        var item = items[n];
        if (selection.value < 0 && (item.data.actions[0].indexOf("addOptions") < 0)) {
            managingGui.title.text = "Select the root fragment!";
            return;
        }

        if (!isAvailable(item.data))
            return;
        stats.wtr.value -= item.data.price;
        item.setState(sold);
        if (item.data.actions != null)
            for (act in item.data.actions)
                executor.run(act);
        // todo this check available right in gui now, put it there
        for (mi in items)
            if (mi.state != sold)
                mi.setState(isAvailable(mi.data) ? available : na);
        onChange.dispatch();
    }

    override function reset() {
        data = null;
    }

    public function initDescr(d:MarketDesc):ActHandler<MarketDesc> {
        data = d;
        items = data.map(mi -> new MarketItemRecord(mi, isAvailable(mi) ? available : na));
        return this;
    }

    function isAvailable(item:MarketItem) {
        return (item.price <= stats.wtr.value);
    }

    public function dump():Dynamic {
        return items.filter(i -> i.state != sold).map(i -> i.data);
    }
}
