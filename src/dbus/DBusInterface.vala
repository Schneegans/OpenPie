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
// The DBusInterface attaches an OpenPieServer to the DBus.                   //
////////////////////////////////////////////////////////////////////////////////

public class DBusInterface : GLib.Object {
    
    ////////////////////////////////////////////////////////////////////////////
    //                          public interface                              //              
    ////////////////////////////////////////////////////////////////////////////
    
    // creates an OpenPieServer and makes it listen to incoming requests
    public void bind() 
    {
        Bus.own_name(BusType.SESSION, "org.openpie.main", 
                     BusNameOwnerFlags.NONE,
                     on_connection_, on_success_, on_fail_);
        Clutter.main();
    }
    
    // stops listening
    public void unbind() 
    {
        Clutter.main_quit();
    }
    
    ////////////////////////////////////////////////////////////////////////////
    //                          private stuff                                 //
    ////////////////////////////////////////////////////////////////////////////
    
    // registers OpenPie on the DBus and creates an OpenPieServer which waits
    // for incoming menu requests
    private void on_connection_(GLib.DBusConnection con) 
    {
        try {
            con.register_object("/org/openpie/main", new OpenPieServer());
        } catch (IOError e) {
            error("Could not register service");
        }
    }
    
    // print message on success
    private void on_success_() 
    {
        message("DBus name aquired!");
    }
    
    // print error on failure
    private void on_fail_() 
    {
        error("Could not aquire DBus name! " +
              "(Maybe OpenPie deamon is already running?)");
    }
}

}
