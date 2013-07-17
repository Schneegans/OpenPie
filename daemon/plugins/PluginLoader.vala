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
// This class tries to load all shared objects from a given directoy as       //
// plugins. It stores a map of plugin names and their associated plugins. It  //
// can be used to create instances of the loaded plugins.                     //
////////////////////////////////////////////////////////////////////////////////

public class PluginLoader : GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  construct {
    plugins_ = new Gee.HashMap<string, PluginModule<Plugin>>();
  }

  // loads all plugin shared objects from the given directory and it's sub
  // directories
  public void load_from(string directory) {
    try {

      var dir = GLib.File.new_for_path(directory);
      var files = dir.enumerate_children(FileAttribute.STANDARD_NAME, 0);

      FileInfo info;
      while ((info = files.next_file ()) != null) {

        if (info.get_file_type() == GLib.FileType.DIRECTORY) {

          var sub_dir = dir.get_child(info.get_name());
          var sub_files = sub_dir.enumerate_children(
                                                FileAttribute.STANDARD_NAME, 0);

          FileInfo plugin_info;
          while ((plugin_info = sub_files.next_file ()) != null) {
            load_plugin(plugin_info, sub_dir.get_child(
                                            plugin_info.get_name()).get_path());
          }

        } else  {
          load_plugin(info, dir.get_child(info.get_name()).get_path());
        }
      }

    } catch (Error e) {
      warning("Failed to load plugin: %s\n", e.message);
    }
  }

  // returns a menu instance of the given menu type
  public Menu? get_plugin(string plugin_name) {
    var plugin = plugins_.get(plugin_name);
    if (plugin != null)
      return plugin.new_object();

    warning("Failed to create menu: No plugin named \"%s\" found!",
            plugin_name);
    return null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////

  // stores a list of plugins with their corresponding names
  private Gee.HashMap<string, PluginModule<Plugin>> plugins_;

  // loads a plugin from a shared object
  private void load_plugin(GLib.FileInfo file_info, string path) {

    if (file_info.get_file_type() == GLib.FileType.REGULAR) {
      var name_parts = file_info.get_name().split(".");

      if (name_parts[name_parts.length-1] == "so") {
        var plugin = new PluginModule<Plugin>(path);
        var plugin_object = plugin.new_object();
        plugins_.set(plugin_object.name, plugin);
      }
    }

  }
}

}

