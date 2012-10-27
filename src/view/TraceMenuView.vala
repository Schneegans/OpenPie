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

    public AnimatorPool anims = null;
    public Animator size = null;
    
    public TraceMenuView(MenuModel model, TransparentWindow window) {
        base(model, window);
        
        size = new Animator.cubic(Animator.Direction.IN_OUT, 10, 100, 1, 1);
        bool even = true;
        
        anims = new AnimatorPool();
        anims.add(size);
        
        GLib.Timeout.add(3000, () => {
            even = !even;
            
            if (even) size.reset_target(100, 1);
            else      size.reset_target(10, 1);
            
            window.start_rendering();
            return true;
        });
        
        window.on_key_down.connect((key) => {message("down");GLib.Timeout.add(1000, () => {on_close(); return false;});});
    }
    
    protected override void on_draw(Cairo.Context ctx, double time) {
        // render the Pie
        ctx.set_source_rgba(0, 0, 0, 0.5);
        ctx.paint();
        
        size.update(time);
        
        ctx.set_source_rgba(1, 0.5, 0, 1);
        ctx.arc(0, 0, size.val, 0, 2*GLib.Math.PI);
        ctx.fill();
        
        if (!anims.is_active)
            window.stop_rendering();
    }
}   
    
}
