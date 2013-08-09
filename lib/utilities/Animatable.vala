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

////////////////////////////////////////////////////////////////////////////////
// This interface provides a function which interpolates a property of a      //
// given Clutter.Actor smoothly                                               //
////////////////////////////////////////////////////////////////////////////////

public interface Animatable {

  //////////////////////////////////////////////////////////////////////////////
  //                          public interface                                //
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////// config utility class ////////////////////////////

  public class Config : GLib.Object {

    /////////////////////////// public variables /////////////////////////////////

    // duration in seconds
    public uint duration { get; set; default=0; }

    // animation mode
    public Clutter.AnimationMode mode { get; set;
                                        default=Clutter.AnimationMode.LINEAR; }

    // delay before animation starts, in seconds
    public uint delay    { get; set; default=0; }

    //////////////////////////// public methods //////////////////////////////////

    // interpolates linearly ---------------------------------------------------
    public Config.linear(uint duration, uint delay = 0) {
      this.duration = duration;
      this.delay = delay;
    }

    // interpolates with the given animation mode ------------------------------
    public Config.full(uint duration, Clutter.AnimationMode mode,
                       uint delay = 0) {

      this.duration = duration;
      this.mode = mode;
      this.delay = delay;
    }
  }

  //////////////////////// public static methods ///////////////////////////////

  // smoothly animates a property of the actor ---------------------------------
  public static void animate(Clutter.Actor actor, string property_name,
                             Value val, Config config) {

    actor.save_easing_state();
    actor.set_easing_mode(config.mode);
    actor.set_easing_duration(config.duration);
    actor.set_easing_delay(config.delay);

    actor.set_property(property_name, val);

    actor.restore_easing_state();
  }
}

}
