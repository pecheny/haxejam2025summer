package hj25s;

import stset.Stats;
import ec.DebugInit;
import dkit.Dkit;
import fu.PropStorage;
import fancy.widgets.StatsDisplay;
import a2d.Boundbox;
import a2d.PlaceholderBuilder2D;
import a2d.Stage;
import a2d.TableWidgetContainer;
import a2d.Widget;
import al.Builder;
import al.layouts.PortionLayout;
import backends.openfl.SpriteAspectKeeper;
import dkit.Dkit.BaseDkit;
import fu.Signal;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import hj25s.GroundsState;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Point;

class RootsManagingView extends BaseDkit {
    public var grounds:GroundsView;
    public var roots:RootsView;

    static var SRC = <roots-managing-view vl={PortionLayout.instance}>
    
        <label(b().v(sfr, .15).b()) text={"Controls settings"} />
        <base(b().v(pfr, 1).b()) public id="canvas">
            // ${fui.quad(__this__.ph,0xffc31e9a)}
            ${grounds = new GroundsView(__this__.ph)}
            ${roots = new RootsView(__this__.ph)}
        </base>
    </roots-managing-view>
}

class GroundsView extends Widget {
    @:once var stage:Stage;
    @:once var grid:Grid;
    @:once var state:GroundsState;
    @:once var selection:Selection;

    var props:PropStorage<Dynamic>;
    var cells:Array<CellView> = [];

    public function new(ph) {
        super(ph);
    }

    override function init() {
        super.init();
        props = entity.getOrCreate(PropStorage, () -> new CascadeProps<String>(null, "ground-props"));
        props.set(Dkit.TEXT_STYLE, DS.micro_text);

        var gph = Builder.widget();
        var bb = new Boundbox();
        var ak = new AspectKeeper(cast gph.axisStates, bb);
        for (a in Axis2D)
            ph.axisStates[a].addSibling(ak.getApplier(a));
        var axisFac = new Axis2DStateFactory(horizontal, stage);
        var wdc = new TableWidgetContainer(gph, horizontal, [for (i in 0...grid.cellsXCount) axisFac.create()], axisFac.create);
        for (i in 0...grid.numCells()) {
            var cell = new CellView(Builder.widget());
            cells.push(cell);
            Builder.addWidget(wdc, cell.ph);
        }
        entity.addChild(gph.entity);
        selection.onChange.listen(hlSelection);
        if (data != null)
            initData(data);
    }

    function hlSelection() {
        var data = state.frags[selection.value];
        var cells = grid.getIntersectingCells(data.pos, data.end);
        hlCells(cells);
    }

    function hlCells(cells:Array<Int>) {
        for (i in 0...grid.numCells()) {
            this.cells[i].setHl(false);
        }
        for (i in cells) {
            this.cells[i].setHl(true);
        }
    }

    var data:Array<GroundCell>;

    public function initData(data:Array<GroundCell>) {
        this.data = data;
        if (!_inited)
            return;
        for (i in 0...data.length) {
            cells[i].initData(data[i]);
        }
    }
}

class RootsView extends Widget {
    @:once var grid:Grid;
    @:once var state:GroundsState;
    @:once var selection:Selection;
    var spr:Sprite = new Sprite();

    public var views:Array<RootFragmentView> = [];
    public var rootClick:Signal<Int->Void> = new Signal();

    override public function init() {
        #if (!display)
        spr.graphics.beginFill(0x341401, 0.1);
        spr.graphics.drawRect(0, 0, grid.width, grid.height);
        spr.graphics.endFill();
        #end
        spr.addEventListener(MouseEvent.CLICK, onClick);
        new SpriteAspectKeeper(ph, spr);
        selection.onChange.listen(select);
        state.fragCreated.listen(() -> addView(state.frags[state.frags.length-1]));
    }

    public function initData(frags:Array<RootFragment>) {
        for (data in frags) {
            addView(data);
        }
    }

    function addView(data:RootFragment) {
        var view = new RootFragmentView(data);
        view.name = "frag-" + (views.length);
        spr.addChild(view);
        views.push(view);
    }

    public function reset() {
        while (spr.numChildren > 0) {
            spr.removeChildAt(0);
        }
        views.resize(0);
    }

    function onClick(e:MouseEvent) {
        var target:Sprite = cast e.target;
        var parts = target.name.split("-");
        if (parts[0] != "frag")
            return;
        var idx = Std.parseInt(parts[1]);
        rootClick.dispatch(idx);
        // select(idx);
    }

    public function select() {
        var idx = selection.value;
        for (i in 0...views.length)
            views[i].setState(idx == i);
    }
}

class RootFragmentView extends Sprite {
    var data:RootFragment;

    public function new(data:RootFragment) {
        super();
        this.data = data;
        setState(false);
    }

    public function setState(selected:Bool) {
        #if (!display)
        graphics.clear();
        var scale = openfl.display.LineScaleMode.NONE;
        var caps = openfl.display.CapsStyle.NONE;
        var joints = openfl.display.JointStyle.BEVEL;

        graphics.lineStyle(1, selected ? 0xffffff : 0x00a070, 1, false, scale, caps, joints);
        graphics.moveTo(data.pos.x, data.pos.y);
        graphics.lineTo(data.end.x, data.end.y);
        #end
    }
}

class CellView extends BaseDkit {
    @:once var colors:ShapesColorAssigner<ColorSet>;

    static var SRC = <cell-view >
            ${fui.quad(__this__.ph,Std.int(Math.random() * 0x26ff0000))}
            // <label(b().b()) id="lbl" />
    </cell-view>

    var sd:StatsDisplay;

    override function init() {
        super.init();
        colors.setColor(0xff);
        sd = new StatsDisplay(ph);
    }

    public function initData(data:GroundCell) {
        // lbl.text = "" + data.production.wtr.value;
        entity.addComponentByType(StatsSet, data.production);
        DebugInit.initCheck.listen((_) -> {
            trace(sd);
        });
    }

    public function setHl(val:Bool) {
        colors.setColor(val ? 0xff0000ff : 0x200000ff);
    }
}
