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

public class PieMenu : GLib.Object {

    public signal void on_select(string item);
    public signal void on_close();

    private TransparentWindow window = null;
    private MenuController controller = null;
    private MenuView view = null;
    private MenuModel model = null;
    
    public PieMenu(string menu_description) {
        window = new TransparentWindow();
    
        model = new TraceMenuModel.from_string(menu_description);

        controller = new TraceMenuController(model, window);
        view = new TraceMenuView(model, window);
    }
    
    public void display() {
        window.open();
        
        controller.on_select.connect((item) => {
            on_select(item);
        });
        
        view.on_close.connect(() => {
            window.destroy();
            on_close();
        });
    }
}   
    
}
