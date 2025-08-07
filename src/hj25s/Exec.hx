package hj25s;

import ec.Component;

@:keep
class ExecCtx extends Component {
    @:once var state:GroundsState;

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
}
