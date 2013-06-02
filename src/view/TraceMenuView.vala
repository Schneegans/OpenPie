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

public class TraceMenuView : MenuView {
  
  private TraceMenu menu = null;
  
  public TraceMenuView(TraceMenu menu, TransparentWindow window) {
    base(window);
    
    this.menu = menu;

    window.on_key_up.connect((key) => {
      if (key.with_mouse && key.key_code == 1) {
        GLib.Timeout.add(1000, () => {
          on_close(); 
          return false;
        });
      }
    });
  }
  
  protected override void on_draw(Cairo.Context ctx, double time) {
  
  }
  
}   
  
}
