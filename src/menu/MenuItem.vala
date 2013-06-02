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

public class MenuItem : GLib.Object {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////

  public string text  { public get; public set; default = "Unnamed Item"; }
  public string icon  { public get; public set; default = "none"; }
  public double angle { public get; public set; default = 0.0; }
  
  public Gee.ArrayList<MenuItem> children { public get; private set; default = null; }
  
  construct {
    children = new Gee.ArrayList<MenuItem>();
  }
  
  public void add_child(MenuItem item) {
    children.add(item);
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  private MenuItemArea active_area = null;
  
  // for debugging purposes
  private void print_(int indent = 0) {
    string space = "";
    
    for (int i=0; i<indent; ++i)
      space += "  ";
      
    debug(space + "\"" + this.text + "\" (Icon: \"" + this.icon + "\", Angle: %f)".printf(this.angle));
    
    foreach (var child in this.children)
      child.print_(indent + 1);
  }
}
  
}