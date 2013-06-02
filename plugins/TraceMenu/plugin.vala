class TraceMenu : GLib.Object, TestPlugin {
    
    public string print_name () {
        return "TraceMenu";
    }
    
    public int calculate() {
        return 815;
    }
}

public Type register_plugin (Module module) {
    // types are registered automatically
    return typeof (TraceMenu);
}
