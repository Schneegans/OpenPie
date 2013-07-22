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
// A generic plugin module. It loads a shared object (*.so), searches for a   //
// function called "register_plugin" and calls it. Afterwards this class can  //
// be used to instanciate objects of the registered type.                     //
////////////////////////////////////////////////////////////////////////////////

public class PluginModule<T> : Object {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////// public methods //////////////////////////////////

  public PluginModule(string path) {
    assert(GLib.Module.supported());

    // load the shared object
    module_ = Module.open(path, GLib.ModuleFlags.BIND_LAZY);
    if (module_ == null) {
      warning("Failed to load plugin '%s'!\n", module_.name ());
      return;
    }

    message("Loaded plugin '%s'.\n", module_.name());

    // register the type of the contained plugin class
    void* f;
    module_.symbol("register_plugin", out f);
    unowned register_ register_plugin = (register_) f;

    type_ = register_plugin(module_);
  }

  // create an object of the loaded plugin class
  public T new_object () {
    return Object.new(type_);
  }

  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////// member variables //////////////////////////////////

  // the type of the plugin class which has been loaded from file
  private GLib.Type type_;

  // a reference to the shared object file
  private GLib.Module module_;

  // function type of the plugin class registration method
  private delegate GLib.Type register_ (GLib.Module module);
}

}
