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
    
        public signal void on_selection(int id, string item);
        
        private PieMenu menu = null;

        public int show_menu(string menu_description) {
            debug("Got show request!");
            this.menu = new PieMenu(menu_description);
            this.menu.display();
            
            this.menu.on_selection.connect((item) => {
                on_selection(0, item);
            });
            
            return 0;
        } 
    }

    public void bind() {
        Bus.own_name (BusType.SESSION, "org.openpie.main", BusNameOwnerFlags.NONE,
            (con) => {
                try {
                    con.register_object("/org/openpie/main", new OpenPieServer());
                } catch (IOError e) {
                    error("Could not register service");
                }},
            () => message("DBus name aquired!"),
            () => warning("Could not aquire DBus name!"));

        Gtk.main();
    }
    
    public void unbind() {
        Gtk.main_quit();
    }
}

}
