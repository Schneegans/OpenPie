/* 
Copyright (c) 2011-2012 by Simon Schneegans

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

public abstract class MenuController : GLib.Object {

    protected TransparentWindow window = null;
    protected MenuModel model = null;
    
    public MenuController(MenuModel model, TransparentWindow window) {
        this.window = window;
        this.model = model;
        
        this.window.on_mouse_move.connect((x, y) => {
            debug("huhu");
        });
    }
    
    protected abstract void on_mouse_move(double x, double y); 

}   
    
}
