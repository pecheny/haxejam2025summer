package;

import a2d.ContainerStyler;
import al.layouts.WholefillLayout;
import al.layouts.PortionLayout;
import al.layouts.data.LayoutData;
import al.layouts.Padding;
import macros.AVConstructor;
import ec.Entity;

class RootsUikit extends FlatUikitExtended {
    public static final FIXED_PADDING_LAYOUT = new Padding(new FixedSize(0.05), PortionLayout.center);
    public static final FIXED_PADDING_LAYOUT_W = new Padding(new FixedSize(0.05), WholefillLayout.instance);
    public static var INACTIVE_COLORS(default, null):AVector<shimp.ClicksInputSystem.ClickTargetViewState, Int> = AVConstructor.create( //    Idle =>
        0xBB121212, 0xBB121212, 0xBB121212, 0xBB121212,);

    public static var INTERACTIVE_COLORS(default, null):AVector<shimp.ClicksInputSystem.ClickTargetViewState, Int> = AVConstructor.create( //    Idle =>
        0xff000000, //    Hovered =>
        0xffd46e00, //    Pressed =>
        0xFFd46e00, //    PressedOutside =>
        0xff000000);

    override function configure(e:Entity) {
        var fntPath = "fonts/RobotoSlab.fnt";
        ctx.fonts.initFont("", fntPath, null);
        var fntPath = "fonts/RobotoSlab-bold.fnt";
        ctx.fonts.initFont("bold", fntPath, null);
        var fntPath = "fonts/icons.fnt";
        ctx.fonts.initFont("icons", fntPath, null);

        regDefaultDrawcalls();
        regStyles(e);
        regLayouts(e);
    }

    override function regStyles(e:Entity) {
        super.regStyles(e);
        ctx.textStyles.newStyle(DS.micro_text)
            .withAlign(horizontal, Center)
            .withAlign(vertical, Forward)
            .withSize(sfr, .05)
            .build();
        ctx.textStyles.newStyle(DS.small_text) //        .withAlign(vertical, Center)
            .withSize(sfr, .07) // .withPadding(horizontal, sfr, 0.1)
            .withAlign(vertical, Center)
            .withAlign(horizontal, Center)
            .build();

        ctx.textStyles.newStyle(DS.heading).withSize(sfr, .14).build();
    }

    override function regLayouts(e) {
        super.regLayouts(e);

        var contLayouts = e.getComponent(ContainerStyler);
        var distributer = new PortionLayout(Forward, new FixedSize(0.1));
        contLayouts.reg(GuiStyles.L_HOR_CARDS, distributer, WholefillLayout.instance);
        contLayouts.reg(GuiStyles.L_VERT_BUTTONS, WholefillLayout.instance, distributer);
    }
}
