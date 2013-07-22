////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2013 by Simon Schneegans                                //
//                                                                            //
// This program is free software: you can redistribute it and/or modify it    //
// under the terms of the GNU General Public License as published by the Free //
// Software Foundation, either version 3 of the License, or (at your option)  //
// any later version.                                                         //
//                                                                            //
// This program is distributed in the hope that it will be useful, but        //
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY //
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   //
// for more details.                                                          //
//                                                                            //
// You should have received a copy of the GNU General Public License along    //
// with this program.  If not, see <http://www.gnu.org/licenses/>.            //
////////////////////////////////////////////////////////////////////////////////

namespace OpenPie {

public interface Animatable {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////// public static methods ///////////////////////////////

  // smoothly animates a property of the actor ---------------------------------
  public static void animate(Clutter.Actor actor,
                      string property_name, Value val, uint duration,
                      Clutter.AnimationMode mode = Clutter.AnimationMode.LINEAR,
                      uint delay = 0) {

    actor.save_easing_state();
    actor.set_easing_mode(mode);
    actor.set_easing_duration(duration);
    actor.set_easing_delay(delay);

    actor.set_property(property_name, val);

    actor.restore_easing_state();
  }
}

}
