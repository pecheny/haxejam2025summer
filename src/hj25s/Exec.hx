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

    public function test() {
        trace("foo", state.cells.length);
    }

    public function addFrag(len:Float) {
        if (selection.value < 0)
            return;
        var papa = state.frags[selection.value];
        var papaDir = papa.end - papa.pos;
        var frag = new RootFragment();
        frag.end.set(0, len);
        frag.end.angle = papaDir.angle;
        frag.end += papa.end;
        frag.pos += papa.end;
        state.frags.push(frag);
        state.fragCreated.dispatch();
    }
}
