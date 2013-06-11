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
// A base class for all menu items. It's derived from a Clutter.Actor and can //
// be shown directly on stage. Derived classes have to implement its          //
// appearance and behaviour.                                                  //
////////////////////////////////////////////////////////////////////////////////

public abstract class MenuItem : Clutter.Actor {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //        
  //////////////////////////////////////////////////////////////////////////////

  public string text  { public get; public set;  default = "Unnamed Item"; }
  public string icon  { public get; public set;  default = "none"; }
  public double angle { public get; public set;  default = 0.0; }
   
  public weak Clutter.Actor       parent   { public get; 
                                             public set; 
                                             default = null; }
  
  construct {
    reactive = true;
  }
  
  public abstract Gee.ArrayList<MenuItem> get_sub_menus();
  public abstract void add_sub_menu(MenuItem item);
  
  public virtual void on_init() {}
  
  // shows the MenuItem and all of it's sub menus on the screen
  public void display() {
    
    enter_event.connect(on_enter);
    leave_event.connect(on_leave);
  
    parent.add_child(this);
    
    foreach (var menu in get_sub_menus()) {
      menu.display();
    }
  }
  
  // removes the MenuItem and all of it's sub menus from the screen
  public void close() {
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
    
    foreach (var menu in get_sub_menus())
      menu.print(indent + 1);
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //                         protected stuff                                  //
  //////////////////////////////////////////////////////////////////////////////
  
  protected virtual bool on_enter(Clutter.CrossingEvent e) { return false; } 
  protected virtual bool on_leave(Clutter.CrossingEvent e) { return false; } 
}
  
}
