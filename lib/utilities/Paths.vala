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
// A static class which stores all relevant paths used by OpenPie.            //
// These depend upon the location from which the program was launched.        //
////////////////////////////////////////////////////////////////////////////////

public class Paths : GLib.Object {
  
  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////
  
  // The global plugin directory, usually /usr/share/openpie/plugins
  public static string global_plugin_directory { get; private set; default=""; }

  // The user plugin directory, usually ~/.local/share/openpie/plugins
  public static string local_plugin_directory { get; private set; default=""; }

  // The path to the executable.
  public static string executable { get; private set; default=""; }
  
  // Initializes all values above.
  public static void init() {
  
    // get path of executable
    try {
      executable = GLib.File.new_for_path(
                         GLib.FileUtils.read_link("/proc/self/exe")).get_path();
    } catch (GLib.FileError e) {
      warning("Failed to get path of executable!");
    }

    // get global path
    string[] search_dirs = {"/usr/share/openpie/",
                       "/usr/local/share/openpie/",
                       "/opt/openpie" };
    var global_dir = "";
    foreach (var dir_name in search_dirs) {
      var dir = GLib.File.new_for_path(dir_name);
      if(dir.query_exists()) {
        global_dir = dir.get_path();
        break;
      }
    }
    
    // get local path
    search_dirs = {"~/.local/share/openpie/",
                   "~./openpie/" };
    var local_dir = "";  
    foreach (var dir_name in search_dirs) {
      var dir = GLib.File.new_for_path(dir_name);
      if(dir.query_exists()) {
        local_dir = dir.get_path();
        break;
      }
    }
    
    // fallback mode, openpie seems not to be installed
    if(global_dir == "" && local_dir == "") {
      var exe = GLib.File.new_for_path(GLib.Path.get_dirname(executable));
      local_dir = exe.get_parent().get_child("share").get_child("openpie")
                                                                    .get_path();
    }
    
    
    if (global_dir != "") {
      message("Found global resources directory in \"%s\".", global_dir);
      
      global_plugin_directory = global_dir + "/plugins";
    } else {
      
      global_plugin_directory = "";
    }
    
    if (local_dir != "") {
      message("Found local resources directory in \"%s\".", local_dir);
      
      local_plugin_directory = local_dir + "/plugins";
      
      create_directory(local_plugin_directory);
    } else {
      
      local_plugin_directory = "";
    }
  }  
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  // creates an empty directory if it does not exist already
  private static void create_directory(string name) {
    
    var dir = GLib.File.new_for_path(name);
    
    if(!dir.query_exists()) {
      try {
        dir.make_directory();
      } catch (GLib.Error e) {
        error(e.message);
      }
    }
  }
}

}
