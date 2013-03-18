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

        window.on_key_down.connect((key) => {GLib.Timeout.add(1000, () => {on_close(); return false;});});
    }
    
    protected override void on_draw(Cairo.Context ctx, double time) {
        
    
        if (this.menu.origin.x == -1) {
            var mouse = window.get_mouse_position();
            if (mouse.x == 0 && mouse.y == 0)
                return;
            this.menu.origin = mouse;
        }
        
        // render the Pie
        ctx.set_source_rgba(0, 0, 0, this.menu.anim_alpha.val);
        ctx.paint();
        
        this.menu.update_animations(time);
        this.update_menu(this.menu.root, this.menu.origin);
        this.draw_menu(this.menu.root, ctx);
        
        if (!this.menu.is_animating())
            this.window.stop_rendering();
    }
    
    private void update_menu(TraceMenuItem menu, Vector parent_position) {
        menu.position = parent_position.copy();
        
        if (menu.anim_distance.val != 0) {
            menu.position.x += (GLib.Math.sin(menu.anim_angle.val) * menu.anim_distance.val);
            menu.position.y -= (GLib.Math.cos(menu.anim_angle.val) * menu.anim_distance.val);
        }
        
        foreach (var child in menu.children)
            this.update_menu(child, menu.position);
    }
    
    private void draw_menu(TraceMenuItem menu, Cairo.Context ctx) {
        
        if (menu.anim_radius.val > 0.0) {
            ctx.set_source_rgba(1, 0.5, 0, 1.0);
            ctx.arc(menu.position.x, menu.position.y, menu.anim_radius.val, 0, 2.0*GLib.Math.PI); 
            ctx.fill();
            
            foreach (var child in menu.children)
                this.draw_menu(child, ctx);
        }
    }
}   
    
}
