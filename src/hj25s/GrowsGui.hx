package hj25s;

import i18n.I18n;
import dkit.Dkit.BaseDkit;
import bootstrap.Data;
import stset.Stats;
import a2d.ChildrenPool;
import al.layouts.PortionLayout;
import bootstrap.Executor;
import bootstrap.GameRunBase;
import fu.PropStorage;
import fancy.widgets.OptionPickerGui;
import fu.Signal;
import fu.bootstrap.ButtonColors;
import fu.ui.InteractivePanelBuilder;
import gameapi.CheckedActivity;
import haxe.ds.ReadOnlyArray;
import loops.llevelup.LevelupData;
import utils.WeightedRandomProvider;
import widgets.Label;
import hj25s.GrowsRun.LevelSpendings;
import hj25s.GroundsState.FlowerStats;
import stset.Stats.StatsSet;
import hj25s.GroundsState.Resources;
import fancy.widgets.StatsDisplay;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

typedef GrowsGuiDesc = {
    ?damage:Float,

    spent:LevelSpendings,
}

class GrowthScreen extends BaseDkit {
    @:once var i18n:I18n;
    static var SRC = <growth-screen vl={PortionLayout.instance}>
        <label(b().v(sfr, .15).b()) text={"Day is over"} />
        <label(b().v(pfr, .15).b()) id="lbl" autoSize={true} />
        <button(b().h(sfr, .36).v(sfr, .12).b()) id="okButton" text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
    </growth-screen>

    public var onDone:ec.Signal<Void->Void> = new ec.Signal();

    function onOkClick() {
        onDone.dispatch();
    }

    public function initData(desc:GrowsGuiDesc) {
        lbl.text = "Flower needs: " +i18n.tags([for (k=> v in desc.spent.keyValueIterator()) '<$k/> $v'].join(" ")) + "<br/>";
        if (desc.damage != null && desc.damage > 0) {
            lbl.text += 'Due to insufficient resource the flower loses ${desc.damage} hp';
        } else {
            lbl.text += 'All the flower needs fulfilled';
        }
    }
}

class WinScreen extends BaseDkit {
    static var SRC = <win-screen vl={PortionLayout.instance}>
        <label(b().v(sfr, .15).b()) text={"You WON!"} />
        <button(b().h(sfr, .36).v(sfr, .12).b()) id="okButton" text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
 </win-screen>

    public var onDone:ec.Signal<Void->Void> = new ec.Signal();

    function onOkClick() {
        onDone.dispatch();
    }
}

class LevelupGui2 extends BaseDkit implements OptionPickerGui<String> {
    public var onChoice(default, null) = new IntSignal();

    @:once var props:PropStorage<Dynamic>;
    var input:DataChildrenPool<String, DataLabel>;

    static var SRC = <levelup-gui2>
        <base(b().v(pfr, 1).b()) id="cardsContainer"  vl={PortionLayout.instance} />
    </levelup-gui2>;

    override function init() {
        super.init();
        input = new InteractivePanelBuilder().withContainer(cardsContainer.c)
            .withWidget(() -> {
                var ph = b().h(sfr, 0.3).v(sfr, 0.1).b();
                var bc = new ButtonColors(ph.entity);
                fui.quad(ph, 0);
                new DataLabel(ph, fui.s(DS.small_text));
            })
            .withSignal(onChoice)
            .build();
    }

    public function initData(captions:Array<String>) {
        input.initData(captions);
    }
}
