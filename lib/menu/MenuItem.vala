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

public class MenuItem : Clutter.Actor {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////

  public string text  { public get; public set; default = "Unnamed Item"; }
  public string icon  { public get; public set; default = "none"; }
  public double angle { public get; public set; default = 0.0; }
   
  public Gee.ArrayList<MenuItem>  children { public get; 
                                             private set; 
                                             default = null; }
  public weak Clutter.Actor       parent   { public get; 
                                             public set; 
                                             default = null; }
  
  construct {
    children = new Gee.ArrayList<MenuItem>();
    reactive = true;
  }
  
  public void add_sub_menu(MenuItem item) {
    children.add(item);
    item.parent = this;
  }
  
  public void display() {
    
    enter_event.connect(on_enter);
    leave_event.connect(on_leave);
    
    
    width = 100;
    height = 100;
    x = 100;
    y = 100;
    
//    if (is_root())  background_color = Clutter.Color.from_string("blue");
//    else            background_color = Clutter.Color.from_string("red");
    
    background_color = Clutter.Color.from_string("red");
  
    parent.add_child(this);
    
    foreach (var child in children) {
      child.display();
    }
  }
  
  public void close() {
    enter_event.disconnect(on_enter);
    leave_event.disconnect(on_leave);
  
    parent.remove_child(this);
  }
  
  public bool is_root() {
    return parent == null;
  }
  
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  private bool on_enter(Clutter.CrossingEvent e) {
    background_color = Clutter.Color.from_string("blue");
    return true;
  }
  
  private bool on_leave(Clutter.CrossingEvent e) {
    background_color = Clutter.Color.from_string("red");
    return true;
  }
  
  // for debugging purposes
  private void print_(int indent = 0) {
    string space = "";
    
    for (int i=0; i<indent; ++i)
      space += "  ";
      
    debug(space + "\"" + this.text 
                + "\" (Icon: \"" + this.icon 
                + "\", Angle: %f)".printf(this.angle));
    
    foreach (var child in this.children)
      child.print_(indent + 1);
  }
}
  
}
