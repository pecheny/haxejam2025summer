package hj25s;

import openfl.events.MouseEvent;
import openfl.geom.Point;
import backends.openfl.SpriteAspectKeeper;
import openfl.display.Sprite;
import bootstrap.GameRunBase;

class RootsManagingRun extends GameRunBase {
    @:once var fui:FuiBuilder;
    var view:RootsManagingView;
    var spr:Sprite;

    public function new(ctx, v:RootsManagingView) {
        this.view = v;
        super(ctx, v.ph);
    }

    var views:Array<RootFragmentView> = [];

    override function init() {
        trace("init");
        super.init();
        spr = new Sprite();
        #if (!display)
        spr.graphics.beginFill(0x341401);
        spr.graphics.drawRect(0, 0, 100, 100);
        spr.graphics.endFill();
        #end
        spr.addEventListener(MouseEvent.CLICK, onClick);
        new SpriteAspectKeeper(view.canvas.ph, spr);
        for (i in 0...5)
            addView();
        var last = views[views.length - 1];
        last.setState(true);
    }

    function addView() {
        var data = new RootFragment();
        if (views.length > 0) {
            var last = views[views.length - 1];
            var tip = last.getTip();
            data.x = tip.x;
            data.y = tip.y;
            data.angle = last.rotation + 5;
        }
        var view = new RootFragmentView(data);
        view.name = "frag-" + (views.length);
        spr.addChild(view);
        views.push(view);
    }

    function onClick(e:MouseEvent) {
        var target:Sprite = cast e.target;
        var idx = Std.parseInt(target.name.split("-")[1]);
        select(idx);
    }

    function select(idx) {
        for (i in 0...views.length)
            views[i].setState(idx == i);
    }
}

class RootFragment {
    public var x:Float = 50;
    public var y:Float = 0;
    public var angle:Float = 0;

    public function new() {}
}

class RootFragmentView extends Sprite {
    public function new(data:RootFragment) {
        super();
        this.x = data.x;
        this.y = data.y;
        this.rotation = data.angle;
        setState(false);
    }

    public function setState(selected:Bool) {
        #if (!display)
        graphics.clear();
        graphics.lineStyle(4, selected ? 0xffffff : 0x00a070);
        graphics.moveTo(0, 0);
        graphics.lineTo(0, 25);
        #end
    }

    var point = new Point(0, 25);

    public function getTip() {
        return localToGlobal(point);
    }
}
