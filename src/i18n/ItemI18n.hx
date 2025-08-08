package i18n;

import dungsmpl.WeaponsDefNode;
import dungsmpl.DungeonData.WeaponDesc;
import bootstrap.DefNode;

class ItemI18n<T:{?descr:String}> {
    var defs:WeaponsDefNode;

    public function new(defs:WeaponsDefNode) {
        this.defs = defs;
    }

    public function getName(id:String) {
        return id;
    }

    public function getDescr(id:String) {
        var def = defs.get(id);
        if (def.descr != null)
            return def.descr;
        return 'Descr for $id is not provided.';
    }
}

class WeaponI18n extends ItemI18n<WeaponDesc> {
    override function getName(id:String) {
        var lastColon = id.lastIndexOf(":");
        var end = lastColon > -1 ? lastColon : id.length;
        return id.substring(id.lastIndexOf('/') + 1, end);
    }
    
    public function getStats(id):Array<String> {
        var def = defs.get(id);
        return [
            "<htsw/>: " + def.hitCount,
            "<bnc/>: " + ( def.bounceCount!=null ? "" + def.bounceCount : "<inf/>")
        ];
    
    }
}
