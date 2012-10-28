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

public class TraceMenuController : MenuController {
    
    private TraceMenu menu = null;
    
    public TraceMenuController(TraceMenu menu, TransparentWindow window) {
        base(window);
        
        this.menu = menu;
    }
    
    protected override void on_mouse_move(double x, double y) {

    }
    
    protected override void on_key_up(Key key) {

    }
    
    protected override void on_key_down(Key key) {
        this.window.remove_grab();
        this.menu.fade_out();
        this.window.start_rendering();
        this.on_select("test");
    }
}   
    
}
