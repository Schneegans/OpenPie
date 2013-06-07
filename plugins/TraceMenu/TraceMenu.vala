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

class TraceMenu : PluginInterface, Menu {
    
  //////////////////////////////////////////////////////////////////////////////
  //                         public interface                                 //        
  //////////////////////////////////////////////////////////////////////////////
    
  public string print_name () {
    return "TraceMenu";
  }
  
  public int calculate() {
    return 815;
  }
    
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
}

}

// this method is called by the OpenPie Daemon when it registers the 
// plugin. Name and signature of this method cannot be changed.
public GLib.Type register_plugin(GLib.Module module) {
  return typeof (OpenPie.TraceMenu);
}


