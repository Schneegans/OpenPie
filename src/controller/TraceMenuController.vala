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
    private TraceMenuItem active_menu = null;
    private TraceMenuItem hovered_item = null;
    
    public TraceMenuController(TraceMenu menu, TransparentWindow window) {
        base(window);
        
        this.menu = menu;
        this.active_menu = menu.root;
    }
    
    protected override void on_mouse_move(double x, double y) {
        if (this.active_menu.children.size > 0) {
        
            Vector mouse = Vector.sum(active_menu.position, new Vector(-x, -y));
        
            double distance = mouse.length();
            double angle = 0.0;
            
            

            if (distance > 0) {
                angle = GLib.Math.acos(mouse.x/distance);
            if (mouse.y < 0)
                angle = 2.0*GLib.Math.PI - angle;
            }
            
            angle = GLib.Math.fmod(angle + GLib.Math.PI*1.5, 2.0*GLib.Math.PI);

            int next_active_index = -1;

            if (distance > 50) {
                next_active_index = (int)(angle*active_menu.children.size/(2*GLib.Math.PI) + 0.5) % active_menu.children.size;
            } 
            
            if (next_active_index >= 0) {
            
                if (hovered_item != null && hovered_item != active_menu.children.get(next_active_index)) {
                    hovered_item.anim_distance.reset_target(70, 0.5);
                    hovered_item.anim_angle.reset_target(hovered_item.angle, 0.5);
                }
                    
                hovered_item = active_menu.children.get(next_active_index);
                hovered_item.anim_distance.reset_target(distance, 0.5);
                hovered_item.anim_angle.reset_target(angle, 0.5);
            } else if (hovered_item != null) {
                hovered_item.anim_distance.reset_target(70, 0.5);
                hovered_item.anim_angle.reset_target(hovered_item.angle, 0.5);
                hovered_item = null;
            }
            
            this.window.start_rendering();
        }
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
