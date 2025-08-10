package hj25s;

import hj25s.GroundsState;
import ec.Component;

@:keep
class ExecCtx extends Component {
    @:once var state:GroundsState;
    @:once var selection:Selection;

    var ctx:ExecCtx;

    @:isVar public var vars(get, null):Dynamic = {};

    override function init() {
        Reflect.setField(vars, "ctx", this);
        ctx = this;
    }

    function get_vars():Dynamic {
        if (!_inited)
            throw "wrong";
        return vars;
    }

    public function enlarge(len) {}
    
    public function incAbsorb(val:Float) {
        if (selection.value < 0)
            return;
        var papa = state.frags[selection.value];
        papa.gathering.speed += val;
        papa.onChange.dispatch();
    }

    public function addFork() {
        if (selection.value < 0)
            return;
        var papa = state.frags[selection.value];
        var dev = 1/4;
        var len = 3 + Math.random() * 8;
        var frag = createFrag(papa.end, (papa.end - papa.pos).rotate(  Math.PI * dev).angle, len);
        regFrag(frag, papa);
        len = 3 + Math.random() * 8;
        frag = createFrag(papa.end, (papa.end - papa.pos).rotate( - Math.PI * dev).angle, len);
        regFrag(frag, papa);
    }

    public function addFrag(len:Float, dev:Float = 1 / 4) {
        if (selection.value < 0)
            return;
        var papa = state.frags[selection.value];
        var frag = createFrag(papa.end, (papa.end - papa.pos).rotate((Math.random() - 0.5) * Math.PI * dev).angle, len);
        regFrag(frag, papa);
    }

    function createFrag(pos, dir, len) {
        var frag = new RootFragment();
        frag.end.set(0, len);
        frag.end.angle = dir;
        frag.end += pos;
        frag.pos += pos;
        return frag;
    }

    function regFrag(frag:RootFragment, ?papa:RootFragment) {
        frag.parent = state.frags.indexOf(papa);
        if (papa!=null) {
            papa.children.push(state.frags.length);
        }
        state.frags.push(frag);
        state.fragCreated.dispatch();
    }
}
