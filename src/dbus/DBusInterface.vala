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

    public void bind() {
        Bus.own_name(BusType.SESSION, "org.openpie.main", 
                     BusNameOwnerFlags.NONE,
                     on_connection_, on_success_, on_fail_);
        Gtk.main();
    }
    
    public void unbind() {
        Gtk.main_quit();
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    private void on_connection_(GLib.DBusConnection con) {
        try {
            con.register_object("/org/openpie/main", new OpenPieServer());
        } catch (IOError e) {
            error("Could not register service");
        }
    }
    
    private void on_success_() {
        message("DBus name aquired!");
    }
    
    private void on_fail_() {
        error("Could not aquire DBus name! (Maybe OpenPie server is already running?)");
    }
}

}
