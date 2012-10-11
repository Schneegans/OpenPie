/* 
Copyright (c) 2011 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

namespace OpenPie {
	
public class DBusInterface : GLib.Object {

    [DBus (name = "org.openpie.main")]
    public class OpenPieServer : GLib.Object {

        public int open_menu(string menu) {
            debug("Got request: " + menu);
            
            debug("Sent confirmation.");
            on_selection(0, menu);

            return 0;
        } 
        
        public signal void on_selection(int menu_id, string selected_item);
    }
    
    private MainLoop loop = null;
    
    public DBusInterface() {
        loop = new MainLoop();
    }

    void on_bus_aquired(DBusConnection conn) {
        try {
            conn.register_object("/org/openpie/main", new OpenPieServer());
        } catch (IOError e) {
            error("Could not register service");
        }
    }

    public void bind() {
        Bus.own_name (BusType.SESSION, "org.openpie.main", BusNameOwnerFlags.NONE,
        on_bus_aquired,
        () => message("DBus name aquired!"),
        () => warning("Could not aquire DBus name!"));

        loop.run();
    }
    
    public void unbind() {
        loop.quit();
    }
}

}
