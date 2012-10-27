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

public class AnimatorPool : GLib.Object {
    
    public bool is_active { get {
        foreach (var animator in animators)
            if (animator.is_active)
                return true;
        return false;
    } }
    
    private Gee.ArrayList<Animator> animators;
    
    public AnimatorPool() {
        animators = new Gee.ArrayList<Animator>();
    }
    
    public void add(Animator animator) {
        animators.add(animator);
    }
    
    public void update(double time) {
        foreach (var animator in animators)
            animator.update(time);
    }
}

}
