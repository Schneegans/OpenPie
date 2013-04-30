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
// The OpenPieServer shows pie menus when there are incoming requests. It     //
// emits the signal on_select() when the users selects an item from the       //
// currently active menu.                                                     //
////////////////////////////////////////////////////////////////////////////////

[DBus (name = "org.openpie.main")]
public class OpenPieServer : GLib.Object {

    ////////////////////////////////////////////////////////////////////////////
    //                          public interface                              //              
    ////////////////////////////////////////////////////////////////////////////
    
    // emitted, when the users selects an item from the currently active menu
    public signal void on_select(int id, string item);
    
    // opens a menu according to the given description and returns a newly 
    // assigned ID
    public int show_menu(string menu_description) 
    {
        var menu = new PieMenu(menu_description);
        
        current_id_ +=1;
        open_menus_.set(menu, current_id_);
        
        menu.on_select.connect(on_menu_select_);
        menu.on_close.connect(on_menu_close_);
        
        menu.display();
        
        return current_id_;
    } 
    
    ////////////////////////////////////////////////////////////////////////////
    //                          private stuff                                 //
    ////////////////////////////////////////////////////////////////////////////
    
    // stores all currently opened menus with their individual ID
    private Gee.HashMap<PieMenu, int> open_menus_ = new Gee.HashMap<PieMenu, int>();
    
    // stores the ID of the lastly opened menu
    private int current_id_ = 0;
    
    // callback gets called when the user selects an item
    // in the currently active menu
    private void on_menu_select_(PieMenu menu, string item) 
    {
        menu.on_select.disconnect(on_menu_select_);
        on_select(this.open_menus_.get(menu), item);
    }
    
    // callback gets called when the currently active menu is closed
    private void on_menu_close_(PieMenu menu) 
    {
        menu.on_close.disconnect(on_menu_close_);
        this.open_menus_.unset(menu);
    }
}

}
