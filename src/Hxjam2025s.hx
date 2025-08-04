package;

import al.Builder;
import hj25s.RootsManagingView;
import ec.Entity;
import hj25s.RootsManagingRun;
import bootstrap.BootstrapMain;

class Hxjam2025s extends BootstrapMain {
    public function new() {
        super();
        var run = new RootsManagingRun(new Entity("roots run"), new RootsManagingView(Builder.widget()));
        runSwitcher.switchTo(run);
    }
}
