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

public class PieMenu : GLib.Object {
  
  //////////////////////////////////////////////////////////////////////////////
  //              public interface                                            //        
  //////////////////////////////////////////////////////////////////////////////
  
  // emitted when some item is selected (occurs prior to on_close)
  public signal void on_select(PieMenu menu, string item);
  
  // emitted when the menu finally disappears from screen
  public signal void on_close(PieMenu menu);
  
  public PieMenu(string menu_description, TransparentWindow window) 
  {
    var loader  = new MenuLoader.from_string(menu_description);
    
    menu_       = new TraceMenu(TraceMenuHelpers.adjust_angles(loader.model));
    controller_ = new TraceMenuController(menu_, window);
    view_       = new TraceMenuView(menu_, window);
  }

  public void display() 
  {
    controller_.on_select.connect(on_controller_select_);
    view_.on_close.connect(on_view_close_);
  }
  
  //////////////////////////////////////////////////////////////////////////////
  //              private stuff                                               //
  //////////////////////////////////////////////////////////////////////////////
  
  private MenuController    controller_ = null;
  private MenuView          view_       = null;
  private TraceMenu         menu_       = null;
  
  private void on_controller_select_(string item) 
  {
    controller_.on_select.disconnect(on_controller_select_);
    on_select(this, item);
  }
  
  private void on_view_close_() 
  {
    view_.on_close.disconnect(on_view_close_);
    on_close(this);
  }
}   
  
}
