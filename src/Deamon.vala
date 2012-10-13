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
	
public class Deamon : GLib.Object {

    /////////////////////////////////////////////////////////////////////
    /// The current version of OpenPie
    /////////////////////////////////////////////////////////////////////

    public static string version;
    
    private static DBusInterface dbus_interface = null;
    
    /////////////////////////////////////////////////////////////////////
    /// The beginning of everything.
    /////////////////////////////////////////////////////////////////////

    public static int main(string[] args) {
        version = "0.1";
    
        Logger.init();
        Gdk.threads_init();
        Gtk.init(ref args);
        
        message("Welcome to OpenPie " + version + "!");

        // connect SigHandlers
        Posix.signal(Posix.SIGINT, sig_handler);
	    Posix.signal(Posix.SIGTERM, sig_handler);
	
	    // finished loading... so run the prog!
	    message("Started happily...");
	    
	    dbus_interface = new DBusInterface();
	    dbus_interface.bind();

        return 0;
    }

    /////////////////////////////////////////////////////////////////////
    /// Print a nifty message when the prog is killed.
    /////////////////////////////////////////////////////////////////////
    
    private static void sig_handler(int sig) {
        stdout.printf("\n");
		message("Caught signal (%d), bye!".printf(sig));
        dbus_interface.unbind();
	}
}

}
