/* 
Copyright (c) 2011 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

namespace OpenPie {

[DBus (name = "org.openpie.main")]
public class OpenPieServer : GLib.Object {

    public signal void on_select(int id, string item);

    public OpenPieServer() {
        this.open_menus_ = new Gee.HashMap<PieMenu, int>();
    }

    public int show_menu(string menu_description) {
        var menu = new PieMenu(menu_description);
        
        current_id_ +=1;
        open_menus_.set(menu, current_id_);
        
        menu.display();
        
        menu.on_select.connect(on_menu_select_);
        menu.on_close.connect(on_menu_close_);
        
        return current_id_;
    } 
    
    ////////////////////////////////////////////////////////////////////////////
    
    private Gee.HashMap<PieMenu, int>   open_menus_ = null;
    private int                         current_id_ = 0;
    
    private void on_menu_select_(PieMenu menu, string item) {
        menu.on_select.disconnect(on_menu_select_);
        on_select(this.open_menus_.get(menu), item);
    }
    
    private void on_menu_close_(PieMenu menu) {
        menu.on_close.disconnect(on_menu_close_);
        this.open_menus_.unset(menu);
    }
}

}
