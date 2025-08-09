package i18n;

import hj25s.GroundsState;

class RootsI18n implements I18n {
    var subst:Map<String, String> = new Map();
    public function new() {
        for (key in colors.keys()) {
            subst.set(key, '<color value="${iconColor(key)}"><font face="icons">${chrs.get(key)}</font></color>');
        }
    }
// ◌ ⦿ ⊖ ○ ↔∞
    var colors:Map<String, Int> = [
        "<wtr/>" => 0x7bbde1,
        "<hlt/>" => 0xdb6a6a,
    ];
    
    var chrs:Map<String, String> = [
        "<wtr/>" => "E",
        "<hlt/>" => "H",
    ];


    function iconColor(statName) {
        return colors[statName];
    }

    public function tr(key:String):String {
        if (subst.exists(key))
            return subst[key];
        return key;
    }

    
    public function tags(str:String) {
        for (key in subst.keys()) {
            if (str.indexOf(key) > -1)
                str = StringTools.replace(str, key, subst[key]);
        }
        return str;
    }
}
