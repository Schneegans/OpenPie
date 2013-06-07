
namespace OpenPie {

class TraceMenu : PluginInterface, GLib.Object {
    
 
    
    public string print_name () {
        return "TraceMenu";
    }
    
    public int calculate() {
        return 815;
    }
}

}

public GLib.Type register_plugin (GLib.Module module) {
    // types are registered automatically
    return typeof (OpenPie.TraceMenu);
}


