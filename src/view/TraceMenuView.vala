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
    
    private TraceMenu model = null;
    
    public TraceMenuView(TraceMenu model, TransparentWindow window) {
        base(window);
        
        this.model = model;

        window.on_key_down.connect((key) => {GLib.Timeout.add(1000, () => {on_close(); return false;});});
    }
    
    protected override void on_draw(Cairo.Context ctx, double time) {
        // render the Pie
        ctx.set_source_rgba(0, 0, 0, 0.5);
        ctx.paint();
        
        this.model.update_animations(time);
        this.draw_menu(ctx, this.model, 500, 500);
        
        if (!this.model.is_animating())
            this.window.stop_rendering();
    }
    
    private void draw_menu(Cairo.Context ctx, TraceMenu menu, int parent_x, int parent_y) {
    
        
    
        int x = parent_x;
        int y = parent_y;
        if (menu.anim_distance.val != 0) {
            x += (int) (GLib.Math.sin(menu.anim_angle.val) * menu.anim_distance.val);
            y -= (int) (GLib.Math.cos(menu.anim_angle.val) * menu.anim_distance.val);
        }
        
//        debug(menu.text + " %f".printf(menu.anim_distance.val));
    
        ctx.set_source_rgba(1, 0.5, 0, 1.0);
        ctx.arc(x, y, menu.anim_radius.val, 0, 2.0*GLib.Math.PI); 
        ctx.fill();
        
        foreach (var child in menu.children)
            this.draw_menu(ctx, child, x, y);
    }
}   
    
}
