////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2013 by Simon Schneegans                                //  
//                                                                            //
// This program is free software: you can redistribute it and/or modify it    //
// under the terms of the GNU General Public License as published by the Free //
// Software Foundation, either version 3 of the License, or (at your option)  //
// any later version.                                                         //
//                                                                            //
// This program is distributed in the hope that it will be useful, but        //
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY //
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   //
// for more details.                                                          //
//                                                                            //
// You should have received a copy of the GNU General Public License along    //
// with this program.  If not, see <http://www.gnu.org/licenses/>.            //
////////////////////////////////////////////////////////////////////////////////

namespace OpenPie {

////////////////////////////////////////////////////////////////////////////////
// The Deamon class owns the main() method of OpenPie. It opens the DBus-     //
// interface and listens for incoming requests for pie menu openings.         //
////////////////////////////////////////////////////////////////////////////////

public class Deamon : GLib.Object {
  
  //////////////////////////////////////////////////////////////////////////////
  //              public interface                                            //        
  //////////////////////////////////////////////////////////////////////////////
  
  // The current version of OpenPie
  public static string version;
  
  // The beginning of everything
  public static int main(string[] args) 
  {
    version = "0.1";
    
    // init toolkits
    Logger.init();
    GtkClutter.init(ref args);
    
    // be friendly
    message("Welcome to OpenPie " + version + "!");

    // connect SigHandlers
    Posix.signal(Posix.SIGINT, sig_handler_);
    Posix.signal(Posix.SIGTERM, sig_handler_);
    
    // search for resource directories
    Paths.init();
  
    // finished loading... so run the prog!
    message("Started happily...");
    
    dbus_interface_ = new DBusInterface();  
    dbus_interface_.bind();

    return 0;
  }

  //////////////////////////////////////////////////////////////////////////////
  //              private stuff                                               //
  //////////////////////////////////////////////////////////////////////////////
  
  // The class which listens for dbus-menu-open-requests
  private static DBusInterface dbus_interface_ = null;
  
  // Print a nifty message when the prog is killed.
  private static void sig_handler_(int sig) 
  {
    stdout.printf("\n");
    message("Caught signal (%d), bye!".printf(sig));
    dbus_interface_.unbind();
  }
}

}
