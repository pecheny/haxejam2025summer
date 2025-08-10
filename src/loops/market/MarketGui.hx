package loops.market;

import i18n.I18n;
import fu.ui.scroll.WheelHandler;
import fu.ui.scroll.ScrollboxInput;
import shimp.InputSystem.InputSystemTarget;
import fu.ui.scroll.ScrollableContent.Scrollable;
import htext.Align;
import a2d.Placeholder2D;
import al.core.DataView;
import al.layouts.PortionLayout;
import dkit.Dkit.BaseDkit;
import fu.Signal.IntSignal;
import fu.bootstrap.ButtonScale;
import fu.ui.ButtonEnabled;
import fu.ui.Properties;
import loops.market.MarketActivity.MarketGui;
import loops.market.MarketData;

using a2d.ProxyWidgetTransform;
using al.Builder;

class MarketWidget extends BaseDkit implements MarketGui {
    public var onDone:ec.Signal<Void->Void> = new ec.Signal();
    public var onChoice(default, null) = new IntSignal();

    static var SRC = <market-widget vl={PortionLayout.instance}>
        <data-container(b().v(pfr, 1).b()) scroll={true} id="cardsContainer"   itemFactory={cardFactory} inputFactory={inputFactory} layouts={GuiStyles.L_VERT_BUTTONS }>
            ${new WheelHandler(__this__.ph, vertical)}
        </data-container>

        <button(b().h(sfr, .36).v(sfr, .12).b())   text={ "Done" } onClick={onOkClick} style={"small-text-center"} />
    </market-widget>;

    var maxNumber:Int;

    function cardFactory() {
        var mc = new MarketCard(b().v(sfr, 0.2).h(sfr, 0.3).t(1).b("card"));
        new ButtonScale(mc.entity);
        return mc;
    }
    
    override function init() {
        super.init();
    }

    function inputFactory(ph, n) {
        new ButtonEnabled(ph, onChoice.dispatch.bind(n));
    }

    function onOkClick() {
        onDone.dispatch();
    }

    public function initData(items:Array<MarketItemRecord>) {
        cardsContainer.initData(items);
    }
}

class MarketCard extends BaseDkit implements DataView<MarketItemRecord> {
    @:once var toggle:EnabledProp;
    @:once var i18n:I18n;
    var descr:MarketItemRecord;

    static var SRC = <market-card vl={PortionLayout.instance} >
        ${fui.quad(__this__.ph.grantInnerTransformPh(), 0)}
        <base(b().v(pfr, 0.2).b()) />
        <switcher(b().v(pfr, 1).b()) id="content"   >
            <label(b().v(pfr, 0.2).b()) id="soldCard" text={"X"} align={Align.Center} />
            <label(b().v(pfr, 0.2).b()) public id="card" autoSize={true} style={DS.small_text}  />
        </switcher>
        <label(b().v(pfr, 0.2).b()) id="lbl" align={Align.Center}  />
    </market-card>;

    public function initData(descr:MarketItemRecord) {
        
        if (this.descr != null)
            this.descr.onChange.remove(onChange);
        this.descr = descr;
        card.text = descr.data.descr;
        descr.onChange.listen(onChange);
        onChange(descr.state);
    }

    function onChange(s:MarketItemState) {
        toggle.enabled = s == MarketItemState.available;
        lbl.color = s == MarketItemState.na ? 0xff0000 : 0xffffff;
        if (s == sold) {
            lbl.text = "Sold out!";
            content.switchTo(soldCard.ph);
        } else {
            lbl.text = getCaption(descr.data);
            content.switchTo(card.ph);
        }
    }

    function getCaption(d:MarketItem) {
        return i18n.tags("<wtr/>") + d.price;
    }
}
