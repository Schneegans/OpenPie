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
  
  // adds a child to this MenuItem
  public void add_sub_menu(MenuItem item) {
    children.add(item);
    item.parent = this;
  }
  
  // shows the MenuItem and all of it's children on the screen
  public virtual void display() {
    
    enter_event.connect(on_enter);
    leave_event.connect(on_leave);
    
    width = 100;
    height = 100;
    x = 100;
    y = 100;
    
    background_color = Clutter.Color.from_string("red");
  
    parent.add_child(this);
    
    foreach (var child in children) {
      child.display();
    }
  }
  
  // removes the MenuItem and all of it's children from the screen
  public virtual void close() {
    enter_event.disconnect(on_enter);
    leave_event.disconnect(on_leave);
  
    parent.remove_child(this);
  }
  
  // for debugging purposes
  public virtual void print(int indent = 0) {
    string space = "";
    
    for (int i=0; i<indent; ++i)
      space += "  ";
      
    debug(space + get_type().name() + ":"
                + "\"" + this.text 
                + "\" (Icon: \"" + this.icon 
                + "\", Angle: %f)".printf(this.angle));
    
    foreach (var child in this.children)
      child.print(indent + 1);
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                          private stuff                                   //
  //////////////////////////////////////////////////////////////////////////////
  
  // called when the mouse starts hovering the MenuItem
  private bool on_enter(Clutter.CrossingEvent e) {
    background_color = Clutter.Color.from_string("blue");
    return true;
  }
  
  // called when the mouse stops hovering the MenuItem
  private bool on_leave(Clutter.CrossingEvent e) {
    background_color = Clutter.Color.from_string("red");
    return true;
  }
}
  
}
