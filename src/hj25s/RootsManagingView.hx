package hj25s;

import hj25s.GroundsState.GroundCell;
import hj25s.GroundsState.Grid;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import a2d.Boundbox;
import al.Builder;
import a2d.Stage;
import a2d.TableWidgetContainer;
import a2d.PlaceholderBuilder2D;
import a2d.Widget;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

class RootsManagingView extends BaseDkit {
    public var grounds:GroundsView;
    static var SRC = <roots-managing-view vl={PortionLayout.instance}>
    
        <label(b().v(sfr, .15).b()) text={"Controls settings"} />
        <base(b().v(pfr, 1).b()) public id="canvas">
            // ${fui.quad(__this__.ph,0xffc31e9a)}
            ${grounds = new GroundsView(__this__.ph)}
        </base>
    </roots-managing-view>
}

class GroundsView extends Widget {
    @:once var stage:Stage;
    @:once var grid:Grid;

    var cells:Array<CellView> = [];

    public function new(ph) {
        super(ph);
    }

    override function init() {
        super.init();
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
    }
    
    public function hlCells(cells:Array<Int>) {
        for (i in 0...grid.numCells()) {
            this.cells[i].setHl(false);
        }
        for (i in cells){
            this.cells[i].setHl(true);
        }
    }
    
    public function initData(data:Array<GroundCell>) {
        for (i in 0...data.length) {
            cells[i].initData(data[i]);
        }
    }

}

class CellView extends BaseDkit {
    @:once var colors:ShapesColorAssigner<ColorSet>;
    static var SRC = <cell-view >
            ${fui.quad(__this__.ph,Std.int(Math.random() * 0x26ff0000))}
            <label(b().b()) id="lbl" />
    </cell-view>
    
    override function init() {
        super.init();
        colors.setColor(0xff);
    }
    
    public function initData(data:GroundCell) {
        lbl.text = "" + data.production.wtr.value;
    
    }
    
    public function setHl(val:Bool) {
        colors.setColor(val? 0xff0000ff:0x200000ff);
    }
}
